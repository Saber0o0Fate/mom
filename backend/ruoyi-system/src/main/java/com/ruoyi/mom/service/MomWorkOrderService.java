package com.ruoyi.mom.service;

import java.math.BigDecimal;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.mom.domain.MomMaterial;
import com.ruoyi.mom.domain.MomMbom;
import com.ruoyi.mom.domain.MomResource;
import com.ruoyi.mom.domain.MomRouting;
import com.ruoyi.mom.domain.MomWorkOrder;
import com.ruoyi.mom.domain.MomWorkOrderImport;
import com.ruoyi.mom.mapper.MomBaseMapper;
import com.ruoyi.mom.mapper.MomMbomMapper;
import com.ruoyi.mom.mapper.MomWorkOrderMapper;

/**
 * MOM生产工单服务
 */
@Service
public class MomWorkOrderService
{
    public static final String STATUS_DRAFT = "draft";
    public static final String STATUS_RELEASED = "released";
    public static final String STATUS_RUNNING = "running";
    public static final String STATUS_FINISHED = "finished";
    public static final String STATUS_CLOSED = "closed";

    @Autowired
    private MomWorkOrderMapper mapper;

    @Autowired
    private MomBaseMapper baseMapper;

    @Autowired
    private MomMbomMapper mbomMapper;

    public List<MomWorkOrder> selectWorkOrderList(MomWorkOrder workOrder)
    {
        return mapper.selectWorkOrderList(workOrder);
    }

    public MomWorkOrder selectWorkOrderById(Long id)
    {
        return mapper.selectWorkOrderById(id);
    }

    public int insertWorkOrder(MomWorkOrder workOrder)
    {
        ensure(mapper.countWorkOrderCode(workOrder.getWorkOrderCode(), null) == 0, "工单编码已存在");
        if (workOrder.getStatus() == null)
        {
            workOrder.setStatus(STATUS_DRAFT);
        }
        if (workOrder.getCompletedQty() == null)
        {
            workOrder.setCompletedQty(BigDecimal.ZERO);
        }
        return mapper.insertWorkOrder(workOrder);
    }

    public String importWorkOrder(List<MomWorkOrderImport> rows, boolean updateSupport, String username)
    {
        if (StringUtils.isNull(rows) || rows.isEmpty())
        {
            throw new ServiceException("导入生产工单数据不能为空");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        for (int i = 0; i < rows.size(); i++)
        {
            MomWorkOrderImport row = rows.get(i);
            try
            {
                MomWorkOrder workOrder = buildWorkOrder(row);
                MomWorkOrder existing = mapper.selectWorkOrderByCode(workOrder.getWorkOrderCode());
                if (existing == null)
                {
                    workOrder.setCreateBy(username);
                    insertWorkOrder(workOrder);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append("、工单 ").append(workOrder.getWorkOrderCode()).append(" 导入成功");
                }
                else if (updateSupport)
                {
                    workOrder.setWorkOrderId(existing.getWorkOrderId());
                    workOrder.setUpdateBy(username);
                    updateWorkOrder(workOrder);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append("、工单 ").append(workOrder.getWorkOrderCode()).append(" 更新成功");
                }
                else
                {
                    failureNum++;
                    failureMsg.append("<br/>").append(failureNum).append("、第 ").append(i + 2).append(" 行工单 ").append(workOrder.getWorkOrderCode()).append(" 已存在");
                }
            }
            catch (Exception e)
            {
                failureNum++;
                String code = StringUtils.isNotBlank(row.getWorkOrderCode()) ? row.getWorkOrderCode() : "空编码";
                failureMsg.append("<br/>").append(failureNum).append("、第 ").append(i + 2).append(" 行工单 ").append(code).append(" 导入失败：").append(e.getMessage());
            }
        }
        if (failureNum > 0)
        {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        }
        successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        return successMsg.toString();
    }

    private MomWorkOrder buildWorkOrder(MomWorkOrderImport row)
    {
        ensure(StringUtils.isNotBlank(row.getWorkOrderCode()), "工单编码不能为空");
        ensure(StringUtils.isNotBlank(row.getWorkOrderName()), "工单名称不能为空");
        ensure(StringUtils.isNotBlank(row.getProductCode()), "成品物料编码不能为空");
        ensure(row.getPlanQty() != null, "计划数量不能为空");
        ensure(row.getPlanQty().compareTo(BigDecimal.ZERO) > 0, "计划数量必须大于0");

        MomMaterial product = baseMapper.selectMaterialByCode(row.getProductCode());
        ensure(product != null, "成品物料编码不存在：" + row.getProductCode());
        ensure("product".equals(product.getMaterialType()) || "成品".equals(product.getCategoryName()), "物料不是成品类型：" + row.getProductCode());

        MomWorkOrder workOrder = new MomWorkOrder();
        workOrder.setWorkOrderCode(row.getWorkOrderCode());
        workOrder.setWorkOrderName(row.getWorkOrderName());
        workOrder.setProductId(product.getMaterialId());
        workOrder.setPlanQty(row.getPlanQty());
        workOrder.setCompletedQty(BigDecimal.ZERO);
        workOrder.setUnit(StringUtils.isNotBlank(row.getUnit()) ? row.getUnit() : product.getUnit());
        workOrder.setPriority(normalizePriority(row.getPriority()));
        workOrder.setSourceOrderCode(row.getSourceOrderCode());
        workOrder.setPlanStartDate(row.getPlanStartDate());
        workOrder.setPlanEndDate(row.getPlanEndDate());
        workOrder.setStatus(normalizeStatus(row.getStatus()));
        workOrder.setRemark(row.getRemark());

        if (StringUtils.isNotBlank(row.getMbomCode()))
        {
            MomMbom mbom = mbomMapper.selectMbomByCode(row.getMbomCode());
            ensure(mbom != null, "MBOM编码不存在：" + row.getMbomCode());
            ensure(product.getMaterialId().equals(mbom.getProductId()), "MBOM所属成品与工单成品不一致：" + row.getMbomCode());
            workOrder.setMbomId(mbom.getMbomId());
        }
        if (StringUtils.isNotBlank(row.getRoutingCode()))
        {
            MomRouting routing = baseMapper.selectRoutingByCode(row.getRoutingCode());
            ensure(routing != null, "路线编码不存在：" + row.getRoutingCode());
            ensure(product.getMaterialId().equals(routing.getProductId()), "工艺路线所属成品与工单成品不一致：" + row.getRoutingCode());
            workOrder.setRoutingId(routing.getRoutingId());
        }
        if (StringUtils.isNotBlank(row.getResourceCode()))
        {
            MomResource resource = baseMapper.selectResourceByCode(row.getResourceCode());
            ensure(resource != null, "资源编码不存在：" + row.getResourceCode());
            workOrder.setResourceId(resource.getResourceId());
        }
        return workOrder;
    }

    private String normalizePriority(String priority)
    {
        if (StringUtils.isBlank(priority) || "普通".equals(priority))
        {
            return "normal";
        }
        if ("加急".equals(priority))
        {
            return "urgent";
        }
        if ("紧急".equals(priority))
        {
            return "critical";
        }
        return priority;
    }

    private String normalizeStatus(String status)
    {
        if (StringUtils.isBlank(status) || "草稿".equals(status))
        {
            return STATUS_DRAFT;
        }
        if ("已下达".equals(status))
        {
            return STATUS_RELEASED;
        }
        if ("生产中".equals(status))
        {
            return STATUS_RUNNING;
        }
        if ("已完工".equals(status))
        {
            return STATUS_FINISHED;
        }
        if ("已关闭".equals(status))
        {
            return STATUS_CLOSED;
        }
        return status;
    }

    public int updateWorkOrder(MomWorkOrder workOrder)
    {
        ensure(mapper.countWorkOrderCode(workOrder.getWorkOrderCode(), workOrder.getWorkOrderId()) == 0, "工单编码已存在");
        MomWorkOrder old = require(workOrder.getWorkOrderId());
        ensure(!STATUS_CLOSED.equals(old.getStatus()), "已关闭工单不能修改");
        return mapper.updateWorkOrder(workOrder);
    }

    public int deleteWorkOrderByIds(Long[] ids)
    {
        for (Long id : ids)
        {
            MomWorkOrder workOrder = require(id);
            ensure(STATUS_DRAFT.equals(workOrder.getStatus()), "只能删除草稿工单");
        }
        return mapper.deleteWorkOrderByIds(ids);
    }

    public int release(Long id, String username)
    {
        MomWorkOrder workOrder = require(id);
        ensure(STATUS_DRAFT.equals(workOrder.getStatus()), "只有草稿工单可以下达");
        return mapper.updateWorkOrderStatus(id, STATUS_RELEASED, username);
    }

    public int start(Long id, String username)
    {
        MomWorkOrder workOrder = require(id);
        ensure(STATUS_RELEASED.equals(workOrder.getStatus()), "只有已下达工单可以开工");
        return mapper.startWorkOrder(id, username);
    }

    public int finish(Long id, BigDecimal completedQty, String username)
    {
        MomWorkOrder workOrder = require(id);
        ensure(STATUS_RUNNING.equals(workOrder.getStatus()) || STATUS_RELEASED.equals(workOrder.getStatus()), "只有已下达或生产中工单可以完工");
        BigDecimal qty = completedQty == null ? workOrder.getPlanQty() : completedQty;
        ensure(qty.compareTo(BigDecimal.ZERO) >= 0, "完工数量不能小于0");
        ensure(qty.compareTo(workOrder.getPlanQty()) <= 0, "完工数量不能大于计划数量");
        return mapper.finishWorkOrder(id, qty, username);
    }

    public int close(Long id, String username)
    {
        MomWorkOrder workOrder = require(id);
        ensure(!STATUS_CLOSED.equals(workOrder.getStatus()), "工单已关闭");
        return mapper.updateWorkOrderStatus(id, STATUS_CLOSED, username);
    }

    private MomWorkOrder require(Long id)
    {
        MomWorkOrder workOrder = mapper.selectWorkOrderById(id);
        ensure(workOrder != null, "工单不存在");
        return workOrder;
    }

    private void ensure(boolean expression, String message)
    {
        if (!expression)
        {
            throw new ServiceException(message);
        }
    }
}
