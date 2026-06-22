package com.ruoyi.mom.service;

import java.math.BigDecimal;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.mom.domain.MomWorkOrder;
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
