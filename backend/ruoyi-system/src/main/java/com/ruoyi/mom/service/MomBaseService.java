package com.ruoyi.mom.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.core.domain.TreeSelect;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.mom.domain.MomMaterial;
import com.ruoyi.mom.domain.MomMaterialCategory;
import com.ruoyi.mom.domain.MomOperation;
import com.ruoyi.mom.domain.MomProduct;
import com.ruoyi.mom.domain.MomResource;
import com.ruoyi.mom.domain.MomRouting;
import com.ruoyi.mom.domain.MomRoutingStepImport;
import com.ruoyi.mom.domain.MomShiftCalendar;
import com.ruoyi.mom.domain.MomWorkStep;
import com.ruoyi.mom.mapper.MomBaseMapper;
import com.ruoyi.system.service.ISysCodeRuleService;

/**
 * MOM基础数据服务
 */
@Service
public class MomBaseService
{
    private static final String RULE_ROUTING = "ROUTING";
    private static final String RULE_OPERATION = "OPERATION";
    private static final String RULE_STEP = "STEP";

    @Autowired
    private MomBaseMapper mapper;

    @Autowired
    private ISysCodeRuleService codeRuleService;

    public List<MomMaterialCategory> selectMaterialCategoryList(MomMaterialCategory category) { return mapper.selectMaterialCategoryList(category); }
    public List<TreeSelect> selectMaterialCategoryTree()
    {
        List<MomMaterialCategory> categories = mapper.selectMaterialCategoryList(new MomMaterialCategory());
        return buildCategoryTreeSelect(categories);
    }
    public MomMaterialCategory selectMaterialCategoryById(Long id) { return mapper.selectMaterialCategoryById(id); }
    public int insertMaterialCategory(MomMaterialCategory category)
    {
        ensure(mapper.countMaterialCategoryCode(category.getCategoryCode(), null) == 0, "分类编码已存在");
        fillCategoryAncestors(category);
        return mapper.insertMaterialCategory(category);
    }
    public int updateMaterialCategory(MomMaterialCategory category)
    {
        ensure(mapper.countMaterialCategoryCode(category.getCategoryCode(), category.getCategoryId()) == 0, "分类编码已存在");
        ensure(!category.getCategoryId().equals(category.getParentId()), "上级分类不能选择自己");
        fillCategoryAncestors(category);
        return mapper.updateMaterialCategory(category);
    }
    @Transactional
    public int deleteMaterialCategoryByIds(Long[] ids)
    {
        ensure(mapper.countMaterialByCategoryIds(ids) == 0, "分类下存在物料，不允许删除");
        return mapper.deleteMaterialCategoryByIds(ids);
    }

    public List<MomMaterial> selectMaterialList(MomMaterial material) { return mapper.selectMaterialList(material); }
    public List<MomMaterial> selectMaterialAll() { return mapper.selectMaterialAll(); }
    public MomMaterial selectMaterialById(Long id) { return mapper.selectMaterialById(id); }
    public int insertMaterial(MomMaterial material)
    {
        ensure(mapper.countMaterialCode(material.getMaterialCode(), null) == 0, "物料编码已存在");
        checkMaterial(material);
        return mapper.insertMaterial(material);
    }
    public int updateMaterial(MomMaterial material)
    {
        ensure(mapper.countMaterialCode(material.getMaterialCode(), material.getMaterialId()) == 0, "物料编码已存在");
        checkMaterial(material);
        return mapper.updateMaterial(material);
    }
    public int deleteMaterialByIds(Long[] ids) { return mapper.deleteMaterialByIds(ids); }
    public String importMaterial(List<MomMaterial> materials, boolean updateSupport, String operName)
    {
        if (StringUtils.isNull(materials) || materials.isEmpty())
        {
            throw new ServiceException("导入物料数据不能为空");
        }
        if (!hasMaterialImportData(materials))
        {
            throw new ServiceException("当前文件不是物料数据导入模板，请下载物料数据模板后再导入；工艺路线工步表请在【工艺路线】页面导入");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        int rowNum = 1;
        for (MomMaterial material : materials)
        {
            try
            {
                checkImportMaterialRow(material, rowNum);
                resolveMaterialCategory(material);
                material.setMaterialCode(material.getMaterialCode().trim());
                material.setMaterialName(material.getMaterialName().trim());
                MomMaterial old = mapper.selectMaterialByCode(material.getMaterialCode());
                if (old == null)
                {
                    material.setCreateBy(operName);
                    insertMaterial(material);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append("、物料 ").append(material.getMaterialCode()).append(" 导入成功");
                }
                else if (updateSupport)
                {
                    material.setMaterialId(old.getMaterialId());
                    material.setUpdateBy(operName);
                    updateMaterial(material);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append("、物料 ").append(material.getMaterialCode()).append(" 更新成功");
                }
                else
                {
                    failureNum++;
                    failureMsg.append("<br/>").append(failureNum).append("、物料 ").append(material.getMaterialCode()).append(" 已存在");
                }
            }
            catch (Exception e)
            {
                failureNum++;
                String materialCode = material == null ? "第" + rowNum + "行" : defaultText(material.getMaterialCode(), "第" + rowNum + "行");
                String msg = "<br/>" + failureNum + "、物料 " + materialCode + " 导入失败：";
                failureMsg.append(msg).append(e.getMessage());
            }
            rowNum++;
        }
        if (failureNum > 0)
        {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        }
        successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        return successMsg.toString();
    }

    public List<MomProduct> selectProductList(MomProduct product) { return mapper.selectProductList(product); }
    public List<MomProduct> selectProductAll() { return mapper.selectProductAll(); }
    public MomProduct selectProductById(Long id) { return mapper.selectProductById(id); }
    public int insertProduct(MomProduct product)
    {
        ensure(mapper.countProductCode(product.getProductCode(), null) == 0, "产品编码已存在");
        return mapper.insertProduct(product);
    }
    public int updateProduct(MomProduct product)
    {
        ensure(mapper.countProductCode(product.getProductCode(), product.getProductId()) == 0, "产品编码已存在");
        return mapper.updateProduct(product);
    }
    public int deleteProductByIds(Long[] ids) { return mapper.deleteProductByIds(ids); }

    public List<MomResource> selectResourceList(MomResource resource) { return mapper.selectResourceList(resource); }
    public List<MomResource> selectResourceAll() { return mapper.selectResourceAll(); }
    public MomResource selectResourceById(Long id) { return mapper.selectResourceById(id); }
    @Transactional(rollbackFor = Exception.class)
    public int insertResource(MomResource resource)
    {
        boolean autoCode = StringUtils.isBlank(resource.getResourceCode());
        if (!autoCode)
        {
            ensure(mapper.countResourceCode(resource.getResourceCode(), null) == 0, "资源编码已存在");
            return mapper.insertResource(resource);
        }
        for (int i = 0; i < 10; i++)
        {
            resource.setResourceCode(codeRuleService.nextCode(resourceRuleCode(resource.getResourceType())));
            if (mapper.countResourceCode(resource.getResourceCode(), null) > 0)
            {
                continue;
            }
            try
            {
                return mapper.insertResource(resource);
            }
            catch (DuplicateKeyException e)
            {
                resource.setResourceCode(null);
            }
        }
        throw new ServiceException("资源编码自动生成失败，请检查编码规则");
    }

    @Transactional(rollbackFor = Exception.class)
    public int updateResource(MomResource resource)
    {
        if (StringUtils.isBlank(resource.getResourceCode()))
        {
            resource.setResourceCode(codeRuleService.nextCode(resourceRuleCode(resource.getResourceType())));
        }
        ensure(mapper.countResourceCode(resource.getResourceCode(), resource.getResourceId()) == 0, "资源编码已存在");
        return mapper.updateResource(resource);
    }
    public int deleteResourceByIds(Long[] ids) { return mapper.deleteResourceByIds(ids); }

    public List<MomShiftCalendar> selectCalendarList(MomShiftCalendar calendar) { return mapper.selectCalendarList(calendar); }
    public MomShiftCalendar selectCalendarById(Long id) { return mapper.selectCalendarById(id); }
    public int insertCalendar(MomShiftCalendar calendar)
    {
        ensure(mapper.countCalendarShift(calendar.getCalendarDate(), calendar.getShiftCode(), null) == 0, "同一天同一班次已存在");
        return mapper.insertCalendar(calendar);
    }
    public int updateCalendar(MomShiftCalendar calendar)
    {
        ensure(mapper.countCalendarShift(calendar.getCalendarDate(), calendar.getShiftCode(), calendar.getCalendarId()) == 0, "同一天同一班次已存在");
        return mapper.updateCalendar(calendar);
    }
    public int deleteCalendarByIds(Long[] ids) { return mapper.deleteCalendarByIds(ids); }

    public List<MomRouting> selectRoutingList(MomRouting routing) { return mapper.selectRoutingList(routing); }
    public MomRouting selectRoutingById(Long id) { return mapper.selectRoutingById(id); }
    public MomRouting selectRoutingDetail(Long id)
    {
        MomRouting routing = mapper.selectRoutingById(id);
        if (routing != null)
        {
            List<MomOperation> operations = mapper.selectOperationList(operationQuery(id));
            for (MomOperation operation : operations)
            {
                operation.setSteps(mapper.selectStepList(stepQuery(operation.getOperationId())));
            }
            routing.setOperations(operations);
        }
        return routing;
    }

    public List<MomRoutingStepImport> selectRoutingStepExportList(MomRouting query)
    {
        List<MomRoutingStepImport> exportRows = new ArrayList<>();
        List<MomRouting> routings = mapper.selectRoutingList(query);
        for (MomRouting routing : routings)
        {
            MomRouting detail = selectRoutingDetail(routing.getRoutingId());
            if (detail == null)
            {
                continue;
            }
            List<MomOperation> operations = detail.getOperations();
            if (operations == null || operations.isEmpty())
            {
                exportRows.add(buildRoutingExportRow(detail, null, null));
                continue;
            }
            for (MomOperation operation : operations)
            {
                List<MomWorkStep> steps = operation.getSteps();
                if (steps == null || steps.isEmpty())
                {
                    exportRows.add(buildRoutingExportRow(detail, operation, null));
                    continue;
                }
                for (MomWorkStep step : steps)
                {
                    exportRows.add(buildRoutingExportRow(detail, operation, step));
                }
            }
        }
        return exportRows;
    }

    @Transactional(rollbackFor = Exception.class)
    public int insertRouting(MomRouting routing)
    {
        fillRoutingCode(routing);
        checkRouting(routing);
        return mapper.insertRouting(routing);
    }
    @Transactional(rollbackFor = Exception.class)
    public int updateRouting(MomRouting routing)
    {
        fillRoutingCode(routing);
        checkRouting(routing);
        return mapper.updateRouting(routing);
    }
    @Transactional(rollbackFor = Exception.class)
    public String importRoutingBySteps(List<MomRoutingStepImport> rows, boolean updateSupport, String operName)
    {
        if (StringUtils.isNull(rows) || rows.isEmpty())
        {
            throw new ServiceException("导入工艺路线数据不能为空");
        }
        Map<String, List<MomRoutingStepImport>> routingGroups = new LinkedHashMap<>();
        for (MomRoutingStepImport row : rows)
        {
            String routingKey = StringUtils.isBlank(row.getRoutingCode())
                    ? defaultText(finishedMaterialCode(row), "") + "|" + defaultText(row.getVersion(), "V1") + "|" + defaultText(row.getRoutingName(), "")
                    : row.getRoutingCode().trim();
            ensure(StringUtils.isNotBlank(routingKey), "路线导入行缺少可分组信息");
            routingGroups.computeIfAbsent(routingKey, key -> new ArrayList<>()).add(row);
        }

        int routingCount = 0;
        int operationCount = 0;
        int stepCount = 0;
        StringBuilder message = new StringBuilder();
        for (Map.Entry<String, List<MomRoutingStepImport>> entry : routingGroups.entrySet())
        {
            String routingCode = entry.getKey();
            List<MomRoutingStepImport> groupRows = entry.getValue();
            MomRoutingStepImport first = groupRows.get(0);
            String productCode = finishedMaterialCode(first);
            ensure(StringUtils.isNotBlank(first.getRoutingName()), "路线 " + routingCode + " 的路线名称不能为空");
            ensure(StringUtils.isNotBlank(productCode), "路线 " + routingCode + " 的成品物料编码不能为空");
            MomProduct product = mapper.selectProductByCode(productCode);
            ensure(product != null, "成品物料编码不存在：" + productCode + "，请先在【物料数据】维护物料类型为【成品】的物料");

            MomRouting old = StringUtils.isBlank(first.getRoutingCode()) ? null : mapper.selectRoutingByCode(first.getRoutingCode().trim());
            MomRouting routing = buildRouting(first, product, operName);
            if (old == null)
            {
                insertRouting(routing);
                routingCount++;
                message.append("<br/>路线 ").append(routingCode).append(" 创建成功");
            }
            else if (updateSupport)
            {
                routing.setRoutingId(old.getRoutingId());
                routing.setUpdateBy(operName);
                updateRouting(routing);
                mapper.deleteStepByRoutingIds(new Long[] { old.getRoutingId() });
                mapper.deleteOperationByRoutingIds(new Long[] { old.getRoutingId() });
                message.append("<br/>路线 ").append(routingCode).append(" 更新成功");
            }
            else
            {
                throw new ServiceException("路线编码已存在：" + routingCode);
            }

            Map<String, List<MomRoutingStepImport>> operationGroups = new LinkedHashMap<>();
            for (MomRoutingStepImport row : groupRows)
            {
                String operationKey = StringUtils.isBlank(row.getOperationCode())
                        ? defaultText(row.getOperationName(), "") + "|" + (row.getOperationSeq() == null ? "" : row.getOperationSeq())
                        : row.getOperationCode().trim();
                ensure(StringUtils.isNotBlank(operationKey), "路线 " + routing.getRoutingCode() + " 存在空工序编码时，工序名称不能为空");
                operationGroups.computeIfAbsent(operationKey, key -> new ArrayList<>()).add(row);
            }

            int operationIndex = 1;
            for (Map.Entry<String, List<MomRoutingStepImport>> operationEntry : operationGroups.entrySet())
            {
                MomRoutingStepImport operationFirst = operationEntry.getValue().get(0);
                MomOperation operation = buildOperation(operationFirst, routing.getRoutingId(), operationIndex, operName);
                insertOperation(operation);
                operationCount++;

                int stepIndex = 1;
                for (MomRoutingStepImport stepRow : operationEntry.getValue())
                {
                    MomWorkStep step = buildStep(stepRow, operation.getOperationId(), stepIndex, operName);
                    insertStep(step);
                    stepCount++;
                    stepIndex++;
                }
                operationIndex++;
            }
        }
        message.insert(0, "恭喜您，工艺路线导入成功！共处理路线 " + routingGroups.size() + " 条，新增路线 " + routingCount + " 条，工序 " + operationCount + " 条，工步 " + stepCount + " 条。");
        return message.toString();
    }
    @Transactional
    public int deleteRoutingByIds(Long[] ids)
    {
        mapper.deleteStepByRoutingIds(ids);
        mapper.deleteOperationByRoutingIds(ids);
        return mapper.deleteRoutingByIds(ids);
    }

    public List<MomOperation> selectOperationList(MomOperation operation) { return mapper.selectOperationList(operation); }
    public MomOperation selectOperationById(Long id) { return mapper.selectOperationById(id); }
    @Transactional(rollbackFor = Exception.class)
    public int insertOperation(MomOperation operation)
    {
        fillOperationCode(operation);
        ensure(mapper.countOperationCode(operation.getRoutingId(), operation.getOperationCode(), null) == 0, "同一路线下工序编码已存在");
        ensure(mapper.countOperationSeq(operation.getRoutingId(), operation.getOperationSeq(), null) == 0, "同一路线下工序顺序已存在");
        return mapper.insertOperation(operation);
    }
    @Transactional(rollbackFor = Exception.class)
    public int updateOperation(MomOperation operation)
    {
        fillOperationCode(operation);
        ensure(mapper.countOperationCode(operation.getRoutingId(), operation.getOperationCode(), operation.getOperationId()) == 0, "同一路线下工序编码已存在");
        ensure(mapper.countOperationSeq(operation.getRoutingId(), operation.getOperationSeq(), operation.getOperationId()) == 0, "同一路线下工序顺序已存在");
        return mapper.updateOperation(operation);
    }
    @Transactional
    public int deleteOperationByIds(Long[] ids)
    {
        mapper.deleteStepByOperationIds(ids);
        return mapper.deleteOperationByIds(ids);
    }

    public List<MomWorkStep> selectStepList(MomWorkStep step) { return mapper.selectStepList(step); }
    public MomWorkStep selectStepById(Long id) { return mapper.selectStepById(id); }
    @Transactional(rollbackFor = Exception.class)
    public int insertStep(MomWorkStep step)
    {
        fillStepCode(step);
        ensure(mapper.countStepCode(step.getOperationId(), step.getStepCode(), null) == 0, "同一工序下工步编码已存在");
        ensure(mapper.countStepSeq(step.getOperationId(), step.getStepSeq(), null) == 0, "同一工序下工步顺序已存在");
        if (step.getIsReportPoint() == null)
        {
            step.setIsReportPoint("Y");
        }
        return mapper.insertStep(step);
    }
    @Transactional(rollbackFor = Exception.class)
    public int updateStep(MomWorkStep step)
    {
        fillStepCode(step);
        ensure(mapper.countStepCode(step.getOperationId(), step.getStepCode(), step.getStepId()) == 0, "同一工序下工步编码已存在");
        ensure(mapper.countStepSeq(step.getOperationId(), step.getStepSeq(), step.getStepId()) == 0, "同一工序下工步顺序已存在");
        return mapper.updateStep(step);
    }
    public int deleteStepByIds(Long[] ids) { return mapper.deleteStepByIds(ids); }

    private void fillRoutingCode(MomRouting routing)
    {
        if (StringUtils.isNotBlank(routing.getRoutingCode()))
        {
            return;
        }
        for (int i = 0; i < 10; i++)
        {
            routing.setRoutingCode(codeRuleService.nextCode(RULE_ROUTING));
            if (mapper.countRoutingCode(routing.getRoutingCode(), routing.getRoutingId()) == 0)
            {
                return;
            }
        }
        throw new ServiceException("路线编码自动生成失败，请检查编码规则");
    }

    private void fillOperationCode(MomOperation operation)
    {
        if (StringUtils.isNotBlank(operation.getOperationCode()))
        {
            return;
        }
        for (int i = 0; i < 10; i++)
        {
            operation.setOperationCode(codeRuleService.nextCode(RULE_OPERATION));
            if (mapper.countOperationCode(operation.getRoutingId(), operation.getOperationCode(), operation.getOperationId()) == 0)
            {
                return;
            }
        }
        throw new ServiceException("工序编码自动生成失败，请检查编码规则");
    }

    private void fillStepCode(MomWorkStep step)
    {
        if (StringUtils.isNotBlank(step.getStepCode()))
        {
            return;
        }
        for (int i = 0; i < 10; i++)
        {
            step.setStepCode(codeRuleService.nextCode(RULE_STEP));
            if (mapper.countStepCode(step.getOperationId(), step.getStepCode(), step.getStepId()) == 0)
            {
                return;
            }
        }
        throw new ServiceException("工步编码自动生成失败，请检查编码规则");
    }

    private void checkRouting(MomRouting routing)
    {
        ensure(mapper.countRoutingCode(routing.getRoutingCode(), routing.getRoutingId()) == 0, "路线编码已存在");
        ensure(mapper.countRoutingVersion(routing.getProductId(), routing.getVersion(), routing.getRoutingId()) == 0, "同一产品同一版本路线已存在");
    }

    private MomRouting buildRouting(MomRoutingStepImport row, MomProduct product, String operName)
    {
        MomRouting routing = new MomRouting();
        routing.setRoutingCode(StringUtils.isBlank(row.getRoutingCode()) ? null : row.getRoutingCode().trim());
        routing.setRoutingName(row.getRoutingName().trim());
        routing.setProductId(product.getProductId());
        routing.setVersion(defaultText(row.getVersion(), "V1"));
        routing.setStatus(defaultText(row.getRoutingStatus(), "0"));
        routing.setRemark(row.getRoutingRemark());
        routing.setCreateBy(operName);
        return routing;
    }

    private String finishedMaterialCode(MomRoutingStepImport row)
    {
        if (row == null)
        {
            return "";
        }
        return defaultText(StringUtils.isNotBlank(row.getProductCode()) ? row.getProductCode() : row.getLegacyProductCode(), "");
    }

    private MomOperation buildOperation(MomRoutingStepImport row, Long routingId, int operationIndex, String operName)
    {
        ensure(StringUtils.isNotBlank(row.getOperationName()), "工序名称不能为空");
        ensure(StringUtils.isNotBlank(row.getResourceCode()), "工序 " + row.getOperationName() + " 的工位编码不能为空");
        MomResource station = mapper.selectResourceByCode(row.getResourceCode().trim());
        ensure(station != null, "工位编码不存在：" + row.getResourceCode());
        ensure(StringUtils.equals(station.getResourceType(), "station"), "资源不是工位类型：" + row.getResourceCode());
        MomOperation operation = new MomOperation();
        operation.setRoutingId(routingId);
        operation.setOperationCode(StringUtils.isBlank(row.getOperationCode()) ? null : row.getOperationCode().trim());
        operation.setOperationName(row.getOperationName().trim());
        operation.setOperationSeq(row.getOperationSeq() == null ? operationIndex * 10 : row.getOperationSeq());
        operation.setStandardMinutes(row.getOperationStandardMinutes());
        operation.setResourceType(defaultText(row.getResourceType(), "station"));
        operation.setResourceId(station.getResourceId());
        operation.setStatus("0");
        operation.setRemark(row.getOperationRemark());
        operation.setCreateBy(operName);
        return operation;
    }

    private MomWorkStep buildStep(MomRoutingStepImport row, Long operationId, int stepIndex, String operName)
    {
        ensure(StringUtils.isNotBlank(row.getStepName()), "工步名称不能为空");
        MomWorkStep step = new MomWorkStep();
        step.setOperationId(operationId);
        step.setStepCode(StringUtils.isBlank(row.getStepCode()) ? null : row.getStepCode().trim());
        step.setStepName(row.getStepName().trim());
        step.setStepSeq(row.getStepSeq() == null ? stepIndex * 10 : row.getStepSeq());
        step.setStandardMinutes(row.getStepStandardMinutes());
        step.setIsReportPoint(defaultText(row.getIsReportPoint(), "Y"));
        step.setStepDesc(row.getStepDesc());
        step.setOperationType(row.getOperationType());
        step.setScrewCheckCount(row.getScrewCheckCount());
        step.setVisionProgram(row.getVisionProgram());
        step.setGuideTaskId(row.getGuideTaskId());
        step.setImageUrl(row.getImageUrl());
        step.setStatus(defaultText(row.getStepStatus(), "0"));
        step.setRemark(row.getStepRemark());
        step.setCreateBy(operName);
        return step;
    }

    private MomRoutingStepImport buildRoutingExportRow(MomRouting routing, MomOperation operation, MomWorkStep step)
    {
        MomRoutingStepImport row = new MomRoutingStepImport();
        row.setRoutingCode(routing.getRoutingCode());
        row.setRoutingName(routing.getRoutingName());
        row.setProductCode(routing.getProductCode());
        row.setVersion(routing.getVersion());
        row.setRoutingStatus(routing.getStatus());
        row.setRoutingRemark(routing.getRemark());
        if (operation != null)
        {
            row.setOperationCode(operation.getOperationCode());
            row.setOperationName(operation.getOperationName());
            row.setOperationSeq(operation.getOperationSeq());
            row.setOperationStandardMinutes(operation.getStandardMinutes());
            row.setResourceType(operation.getResourceType());
            row.setResourceCode(operation.getResourceCode());
            row.setOperationRemark(operation.getRemark());
        }
        if (step != null)
        {
            row.setStepCode(step.getStepCode());
            row.setStepName(step.getStepName());
            row.setStepSeq(step.getStepSeq());
            row.setStepStandardMinutes(step.getStandardMinutes());
            row.setIsReportPoint(step.getIsReportPoint());
            row.setStepDesc(step.getStepDesc());
            row.setOperationType(step.getOperationType());
            row.setScrewCheckCount(step.getScrewCheckCount());
            row.setVisionProgram(step.getVisionProgram());
            row.setGuideTaskId(step.getGuideTaskId());
            row.setImageUrl(step.getImageUrl());
            row.setStepStatus(step.getStatus());
            row.setStepRemark(step.getRemark());
        }
        return row;
    }

    private String defaultText(String value, String defaultValue)
    {
        return StringUtils.isBlank(value) ? defaultValue : value.trim();
    }

    private MomOperation operationQuery(Long routingId)
    {
        MomOperation operation = new MomOperation();
        operation.setRoutingId(routingId);
        return operation;
    }

    private MomWorkStep stepQuery(Long operationId)
    {
        MomWorkStep step = new MomWorkStep();
        step.setOperationId(operationId);
        return step;
    }

    private List<TreeSelect> buildCategoryTreeSelect(List<MomMaterialCategory> categories)
    {
        Map<Long, TreeSelect> nodes = new HashMap<>();
        List<TreeSelect> roots = new ArrayList<>();
        for (MomMaterialCategory category : categories)
        {
            TreeSelect node = new TreeSelect();
            node.setId(category.getCategoryId());
            node.setLabel(category.getCategoryName());
            node.setChildren(new ArrayList<>());
            nodes.put(category.getCategoryId(), node);
        }
        for (MomMaterialCategory category : categories)
        {
            TreeSelect node = nodes.get(category.getCategoryId());
            if (category.getParentId() != null && category.getParentId() != 0 && nodes.containsKey(category.getParentId()))
            {
                nodes.get(category.getParentId()).getChildren().add(node);
            }
            else
            {
                roots.add(node);
            }
        }
        return roots;
    }

    private void fillCategoryAncestors(MomMaterialCategory category)
    {
        if (category.getParentId() == null || category.getParentId() == 0)
        {
            category.setParentId(0L);
            category.setAncestors("0");
            return;
        }
        MomMaterialCategory parent = mapper.selectMaterialCategoryById(category.getParentId());
        ensure(parent != null, "上级分类不存在");
        category.setAncestors(parent.getAncestors() + "," + parent.getCategoryId());
    }

    private void checkMaterial(MomMaterial material)
    {
        ensure(material.getCategoryId() != null, "物料分类不能为空");
        ensure(mapper.selectMaterialCategoryById(material.getCategoryId()) != null, "物料分类不存在");
    }

    private void checkImportMaterialRow(MomMaterial material, int rowNum)
    {
        if (material == null)
        {
            throw new ServiceException("第" + rowNum + "行为空，请删除空行或选择正确的物料导入模板");
        }
        if (StringUtils.isBlank(material.getMaterialCode()))
        {
            throw new ServiceException("物料编码不能为空，请确认当前文件为物料数据导入模板");
        }
        if (StringUtils.isBlank(material.getMaterialName()))
        {
            throw new ServiceException("物料名称不能为空");
        }
        if (StringUtils.isBlank(material.getCategoryName()) && material.getCategoryId() == null)
        {
            throw new ServiceException("物料分类不能为空");
        }
    }

    private boolean hasMaterialImportData(List<MomMaterial> materials)
    {
        for (MomMaterial material : materials)
        {
            if (material == null)
            {
                continue;
            }
            if (StringUtils.isNotBlank(material.getMaterialCode())
                    || StringUtils.isNotBlank(material.getMaterialName())
                    || StringUtils.isNotBlank(material.getCategoryName())
                    || StringUtils.isNotBlank(material.getMaterialType()))
            {
                return true;
            }
        }
        return false;
    }

    private void resolveMaterialCategory(MomMaterial material)
    {
        if (material.getCategoryId() != null)
        {
            return;
        }
        if (StringUtils.isBlank(material.getCategoryName()))
        {
            throw new ServiceException("物料分类不能为空");
        }
        MomMaterialCategory category = mapper.selectMaterialCategoryByCode(material.getCategoryName());
        if (category == null)
        {
            category = mapper.selectMaterialCategoryByName(material.getCategoryName());
        }
        if (category == null)
        {
            throw new ServiceException("物料分类不存在：" + material.getCategoryName());
        }
        material.setCategoryId(category.getCategoryId());
    }

    private String resourceRuleCode(String resourceType)
    {
        if (StringUtils.equals(resourceType, "factory"))
        {
            return "FACTORY";
        }
        if (StringUtils.equals(resourceType, "workshop"))
        {
            return "WORKSHOP";
        }
        if (StringUtils.equals(resourceType, "line"))
        {
            return "LINE";
        }
        if (StringUtils.equals(resourceType, "station"))
        {
            return "STATION";
        }
        if (StringUtils.equals(resourceType, "location"))
        {
            return "LOCATION";
        }
        return "RESOURCE";
    }

    private void ensure(boolean expression, String message)
    {
        if (!expression)
        {
            throw new ServiceException(message);
        }
    }
}
