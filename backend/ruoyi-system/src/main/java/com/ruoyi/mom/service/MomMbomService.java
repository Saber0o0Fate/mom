package com.ruoyi.mom.service;

import java.util.ArrayList;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.mom.domain.MomMaterial;
import com.ruoyi.mom.domain.MomMbom;
import com.ruoyi.mom.domain.MomMbomGenerateRequest;
import com.ruoyi.mom.domain.MomMbomImport;
import com.ruoyi.mom.domain.MomMbomItem;
import com.ruoyi.mom.domain.MomOperation;
import com.ruoyi.mom.domain.MomProduct;
import com.ruoyi.mom.domain.MomRouting;
import com.ruoyi.mom.domain.MomWorkStep;
import com.ruoyi.mom.mapper.MomBaseMapper;
import com.ruoyi.mom.service.MomConsoleService;
import com.ruoyi.mom.mapper.MomMbomMapper;

/**
 * MOM制造BOM服务
 */
@Service
public class MomMbomService
{
    @Autowired
    private MomMbomMapper mapper;

    @Autowired
    private MomBaseMapper baseMapper;

    @Autowired
    private MomConsoleService consoleService;

    public List<MomMbom> selectMbomList(MomMbom mbom) { return mapper.selectMbomList(mbom); }
    public MomMbom selectMbomById(Long id) { return mapper.selectMbomById(id); }
    public MomMbom selectMbomDetail(Long id)
    {
        MomMbom mbom = mapper.selectMbomById(id);
        if (mbom != null)
        {
            MomMbomItem query = new MomMbomItem();
            query.setMbomId(id);
            mbom.setItems(buildTree(mapper.selectItemList(query), 0L));
        }
        return mbom;
    }
    public int insertMbom(MomMbom mbom)
    {
        checkMbom(mbom);
        return mapper.insertMbom(mbom);
    }

    @Transactional(rollbackFor = Exception.class)
    public MomMbom generateMbom(MomMbomGenerateRequest request, String operName)
    {
        Map<String, Object> pbom = consoleService.selectPbomById(request.getPbomId());
        MomRouting routing = baseMapper.selectRoutingById(request.getRoutingId());
        ensure(routing != null, "工艺路线不存在");

        Long productId = request.getProductId() == null ? longValue(pbom.get("productId")) : request.getProductId();
        ensure(productId != null, "成品物料不能为空");
        ensure(productId.equals(longValue(pbom.get("productId"))), "选择的成品物料与PBOM不一致");
        ensure(productId.equals(routing.getProductId()), "选择的成品物料与工艺路线不一致");

        MomMbom old = mapper.selectMbomByCode(request.getMbomCode());
        if (old != null)
        {
            ensure(Boolean.TRUE.equals(request.getUpdateSupport()), "MBOM编码已存在：" + request.getMbomCode());
            mapper.deleteItemByMbomIds(new Long[] { old.getMbomId() });
        }

        MomMbom mbom = old == null ? new MomMbom() : old;
        mbom.setMbomCode(request.getMbomCode());
        mbom.setMbomName(request.getMbomName());
        mbom.setProductId(productId);
        mbom.setVersion(defaultString(request.getVersion(), "V1"));
        mbom.setEffectiveDate(request.getEffectiveDate());
        mbom.setExpireDate(request.getExpireDate());
        mbom.setStatus(defaultString(request.getStatus(), "0"));
        mbom.setRemark(request.getRemark());
        if (old == null)
        {
            mbom.setCreateBy(operName);
            insertMbom(mbom);
        }
        else
        {
            mbom.setUpdateBy(operName);
            updateMbom(mbom);
        }

        List<MomOperation> operations = baseMapper.selectOperationList(operationQuery(request.getRoutingId()));
        Map<Long, List<Map<String, Object>>> pbomItemsByResource = pbomItemsByResource(pbom);
        int seq = 10;
        int created = 0;
        Set<Long> matchedItemIds = new HashSet<>();
        Set<Long> consumedResourceIds = new HashSet<>();
        for (MomOperation operation : operations)
        {
            if (operation.getResourceId() == null)
            {
                continue;
            }
            if (!consumedResourceIds.add(operation.getResourceId()))
            {
                continue;
            }
            List<Map<String, Object>> stationItems = pbomItemsByResource.get(operation.getResourceId());
            if (stationItems == null || stationItems.isEmpty())
            {
                continue;
            }
            Long stepId = firstStepId(operation.getOperationId());
            for (Map<String, Object> pbomItem : stationItems)
            {
                MomMbomItem item = new MomMbomItem();
                item.setMbomId(mbom.getMbomId());
                item.setParentItemId(0L);
                item.setMaterialId(longValue(pbomItem.get("materialId")));
                item.setItemSeq(seq);
                item.setQuantity(decimalValue(pbomItem.get("quantity"), BigDecimal.ONE));
                item.setScrapRate(BigDecimal.ZERO);
                item.setOperationId(operation.getOperationId());
                item.setStepId(stepId);
                item.setIssueType("operation");
                item.setStatus("0");
                item.setRemark("由PBOM " + value(pbom, "pbomCode") + " 按工位自动生成");
                item.setCreateBy(operName);
                insertItem(item);
                matchedItemIds.add(longValue(pbomItem.get("itemId")));
                created++;
                seq += 10;
            }
        }
        ensure(created > 0, "未根据工位匹配到可生成的投料，请检查PBOM明细和工艺路线工序的工位是否一致");
        ensure(matchedItemIds.size() == pbomItemCount(pbom), "存在未匹配到工序工位的PBOM明细，请检查工位维护");
        return selectMbomDetail(mbom.getMbomId());
    }
    public int updateMbom(MomMbom mbom)
    {
        checkMbom(mbom);
        return mapper.updateMbom(mbom);
    }
    @Transactional
    public int deleteMbomByIds(Long[] ids)
    {
        mapper.deleteItemByMbomIds(ids);
        return mapper.deleteMbomByIds(ids);
    }

    public List<MomMbomItem> selectItemList(MomMbomItem item) { return mapper.selectItemList(item); }
    public MomMbomItem selectItemById(Long id) { return mapper.selectItemById(id); }

    @Transactional
    public String importMbom(List<MomMbomImport> rows, boolean updateSupport, String operName)
    {
        ensure(hasImportRows(rows), "导入数据不能为空");
        Map<String, List<MomMbomImport>> groups = new LinkedHashMap<>();
        int rowNum = 1;
        for (MomMbomImport row : rows)
        {
            rowNum++;
            if (isBlankRow(row))
            {
                continue;
            }
            checkImportRow(row, rowNum);
            groups.computeIfAbsent(row.getMbomCode().trim(), key -> new ArrayList<>()).add(row);
        }
        ensure(!groups.isEmpty(), "导入数据不能为空");

        int success = 0;
        for (Map.Entry<String, List<MomMbomImport>> entry : groups.entrySet())
        {
            List<MomMbomImport> groupRows = entry.getValue();
            MomMbomImport first = groupRows.get(0);
            MomProduct product = baseMapper.selectProductByCode(first.getProductCode().trim());
            ensure(product != null, "成品物料编码不存在：" + first.getProductCode());

            MomMbom mbom = mapper.selectMbomByCode(entry.getKey());
            if (mbom != null)
            {
                ensure(updateSupport, "MBOM编码已存在：" + entry.getKey());
                mbom.setMbomName(first.getMbomName());
                mbom.setProductId(product.getProductId());
                mbom.setVersion(defaultString(first.getVersion(), "V1"));
                mbom.setStatus(defaultString(first.getStatus(), "0"));
                mbom.setRemark(first.getRemark());
                mbom.setUpdateBy(operName);
                updateMbom(mbom);
                mapper.deleteItemByMbomIds(new Long[] { mbom.getMbomId() });
            }
            else
            {
                mbom = new MomMbom();
                mbom.setMbomCode(entry.getKey());
                mbom.setMbomName(first.getMbomName());
                mbom.setProductId(product.getProductId());
                mbom.setVersion(defaultString(first.getVersion(), "V1"));
                mbom.setStatus(defaultString(first.getStatus(), "0"));
                mbom.setRemark(first.getRemark());
                mbom.setCreateBy(operName);
                insertMbom(mbom);
            }

            for (MomMbomImport row : groupRows)
            {
                MomMbomItem item = buildImportItem(row, mbom.getMbomId(), operName);
                insertItem(item);
            }
            success++;
        }
        return "导入成功，共处理 " + success + " 个MBOM，" + groups.values().stream().mapToInt(List::size).sum() + " 条工步投料";
    }

    public int insertItem(MomMbomItem item)
    {
        normalizeItem(item);
        checkItem(item);
        return mapper.insertItem(item);
    }
    public int updateItem(MomMbomItem item)
    {
        normalizeItem(item);
        checkItem(item);
        return mapper.updateItem(item);
    }
    @Transactional
    public int deleteItemByIds(Long[] ids)
    {
        Set<Long> deleteIds = new HashSet<>();
        for (Long id : ids)
        {
            collectItemIds(id, deleteIds);
        }
        return mapper.deleteItemByIds(deleteIds.toArray(new Long[0]));
    }

    private void checkMbom(MomMbom mbom)
    {
        ensure(mapper.countMbomCode(mbom.getMbomCode(), mbom.getMbomId()) == 0, "MBOM编码已存在");
        ensure(mapper.countMbomVersion(mbom.getProductId(), mbom.getVersion(), mbom.getMbomId()) == 0, "同一产品同一版本MBOM已存在");
    }

    private void normalizeItem(MomMbomItem item)
    {
        if (item.getParentItemId() == null)
        {
            item.setParentItemId(0L);
        }
        if (item.getStatus() == null)
        {
            item.setStatus("0");
        }
    }

    private void checkItem(MomMbomItem item)
    {
        ensure(mapper.countItemSeq(item.getMbomId(), item.getParentItemId(), item.getItemSeq(), item.getItemId()) == 0, "同一上级下行号已存在");
    }

    private void collectItemIds(Long itemId, Set<Long> ids)
    {
        if (!ids.add(itemId))
        {
            return;
        }
        MomMbomItem current = mapper.selectItemById(itemId);
        if (current == null)
        {
            return;
        }
        MomMbomItem query = new MomMbomItem();
        query.setMbomId(current.getMbomId());
        query.setParentItemId(itemId);
        for (MomMbomItem child : mapper.selectItemList(query))
        {
            collectItemIds(child.getItemId(), ids);
        }
    }

    private List<MomMbomItem> buildTree(List<MomMbomItem> rows, Long parentId)
    {
        List<MomMbomItem> tree = new ArrayList<>();
        for (MomMbomItem row : rows)
        {
            Long rowParentId = row.getParentItemId() == null ? 0L : row.getParentItemId();
            if (rowParentId.equals(parentId))
            {
                row.setChildren(buildTree(rows, row.getItemId()));
                tree.add(row);
            }
        }
        return tree;
    }

    private void ensure(boolean expression, String message)
    {
        if (!expression)
        {
            throw new ServiceException(message);
        }
    }

    private MomMbomItem buildImportItem(MomMbomImport row, Long mbomId, String operName)
    {
        MomMaterial material = baseMapper.selectMaterialByCode(row.getMaterialCode().trim());
        ensure(material != null, "投料物料编码不存在：" + row.getMaterialCode());

        MomOperation operation = findOperation(row.getOperationCode().trim());
        ensure(operation != null, "工序编码不存在：" + row.getOperationCode());
        MomWorkStep step = findStep(operation.getOperationId(), row.getStepCode().trim());
        ensure(step != null, "工步编码不存在：" + row.getStepCode());

        MomMbomItem item = new MomMbomItem();
        item.setMbomId(mbomId);
        item.setParentItemId(0L);
        item.setMaterialId(material.getMaterialId());
        item.setItemSeq(row.getItemSeq());
        item.setQuantity(row.getQuantity());
        item.setScrapRate(row.getScrapRate());
        item.setOperationId(operation.getOperationId());
        item.setStepId(step.getStepId());
        item.setIssueType(defaultString(row.getIssueType(), "order"));
        item.setStatus("0");
        item.setRemark(row.getRemark());
        item.setCreateBy(operName);
        return item;
    }

    private MomOperation findOperation(String operationCode)
    {
        MomOperation query = new MomOperation();
        query.setOperationCode(operationCode);
        for (MomOperation operation : baseMapper.selectOperationList(query))
        {
            if (StringUtils.equals(operationCode, operation.getOperationCode()))
            {
                return operation;
            }
        }
        return null;
    }

    private MomWorkStep findStep(Long operationId, String stepCode)
    {
        MomWorkStep query = new MomWorkStep();
        query.setOperationId(operationId);
        query.setStepCode(stepCode);
        for (MomWorkStep step : baseMapper.selectStepList(query))
        {
            if (StringUtils.equals(stepCode, step.getStepCode()))
            {
                return step;
            }
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    private Map<Long, List<Map<String, Object>>> pbomItemsByResource(Map<String, Object> pbom)
    {
        Map<Long, List<Map<String, Object>>> result = new LinkedHashMap<>();
        Object items = pbom.get("items");
        if (!(items instanceof List))
        {
            return result;
        }
        for (Map<String, Object> item : (List<Map<String, Object>>) items)
        {
            Long resourceId = longValue(item.get("resourceId"));
            ensure(resourceId != null, "PBOM明细存在未维护工位的数据：" + value(item, "materialCode"));
            result.computeIfAbsent(resourceId, key -> new ArrayList<>()).add(item);
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    private int pbomItemCount(Map<String, Object> pbom)
    {
        Object items = pbom.get("items");
        return items instanceof List ? ((List<Map<String, Object>>) items).size() : 0;
    }

    private Long firstStepId(Long operationId)
    {
        MomWorkStep query = new MomWorkStep();
        query.setOperationId(operationId);
        List<MomWorkStep> steps = baseMapper.selectStepList(query);
        return steps == null || steps.isEmpty() ? null : steps.get(0).getStepId();
    }

    private MomOperation operationQuery(Long routingId)
    {
        MomOperation operation = new MomOperation();
        operation.setRoutingId(routingId);
        return operation;
    }

    private Long longValue(Object object)
    {
        if (object == null || StringUtils.isBlank(String.valueOf(object)))
        {
            return null;
        }
        return Long.valueOf(String.valueOf(object));
    }

    private BigDecimal decimalValue(Object object, BigDecimal defaultValue)
    {
        if (object == null || StringUtils.isBlank(String.valueOf(object)))
        {
            return defaultValue;
        }
        return new BigDecimal(String.valueOf(object));
    }

    private String value(Map<String, Object> map, String key)
    {
        Object object = map == null ? null : map.get(key);
        return object == null ? "" : String.valueOf(object);
    }

    private void checkImportRow(MomMbomImport row, int rowNum)
    {
        ensure(StringUtils.isNotBlank(row.getMbomCode()), "第" + rowNum + "行：MBOM编码不能为空");
        ensure(StringUtils.isNotBlank(row.getMbomName()), "第" + rowNum + "行：MBOM名称不能为空");
        ensure(StringUtils.isNotBlank(row.getProductCode()), "第" + rowNum + "行：成品物料编码不能为空");
        ensure(StringUtils.isNotBlank(row.getOperationCode()), "第" + rowNum + "行：工序编码不能为空");
        ensure(StringUtils.isNotBlank(row.getStepCode()), "第" + rowNum + "行：工步编码不能为空");
        ensure(StringUtils.isNotBlank(row.getMaterialCode()), "第" + rowNum + "行：投料物料编码不能为空");
        ensure(row.getItemSeq() != null, "第" + rowNum + "行：行号不能为空");
        ensure(row.getQuantity() != null, "第" + rowNum + "行：用量不能为空");
    }

    private boolean hasImportRows(List<MomMbomImport> rows)
    {
        if (rows == null || rows.isEmpty())
        {
            return false;
        }
        for (MomMbomImport row : rows)
        {
            if (!isBlankRow(row))
            {
                return true;
            }
        }
        return false;
    }

    private boolean isBlankRow(MomMbomImport row)
    {
        return row == null || StringUtils.isBlank(row.getMbomCode()) && StringUtils.isBlank(row.getMbomName())
                && StringUtils.isBlank(row.getProductCode()) && StringUtils.isBlank(row.getMaterialCode());
    }

    private String defaultString(String value, String defaultValue)
    {
        return StringUtils.isBlank(value) ? defaultValue : value.trim();
    }
}
