package com.ruoyi.mom.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.mom.domain.MomMaterial;
import com.ruoyi.mom.domain.MomPbomImport;
import com.ruoyi.mom.domain.MomProduct;
import com.ruoyi.mom.domain.MomResource;
import com.ruoyi.mom.domain.MomStepReport;
import com.ruoyi.mom.mapper.MomBaseMapper;
import com.ruoyi.mom.mapper.MomConsoleMapper;
import com.ruoyi.system.service.ISysCodeRuleService;

@Service
public class MomConsoleService
{
    private static final String RULE_PBOM = "PBOM";

    @Autowired
    private MomConsoleMapper mapper;

    @Autowired
    private MomBaseMapper baseMapper;

    @Autowired
    private MomProductionService productionService;

    @Autowired
    private ISysCodeRuleService codeRuleService;

    public List<Map<String, Object>> selectPbomList(Map<String, Object> query) { return normalizeList(mapper.selectPbomList(query)); }
    public Map<String, Object> selectPbomById(Long pbomId)
    {
        Map<String, Object> pbom = normalize(mapper.selectPbomById(pbomId));
        ensure(pbom != null, "PBOM不存在");
        pbom.put("items", normalizeList(mapper.selectPbomItems(pbomId)));
        return pbom;
    }
    public int insertPbom(Map<String, Object> pbom)
    {
        require(pbom, "pbomName", "PBOM名称不能为空");
        require(pbom, "productId", "产品不能为空");
        if (StringUtils.isBlank(value(pbom, "pbomCode")))
        {
            pbom.put("pbomCode", nextUniquePbomCode());
        }
        if (!pbom.containsKey("status") || pbom.get("status") == null) pbom.put("status", "0");
        ensure(mapper.countPbomCode(value(pbom, "pbomCode"), null) == 0, "PBOM编码已存在");
        return mapper.insertPbom(pbom);
    }
    public int updatePbom(Map<String, Object> pbom)
    {
        Long id = longValue(pbom.get("pbomId"));
        ensure(id != null, "PBOM ID不能为空");
        ensure(mapper.countPbomCode(value(pbom, "pbomCode"), id) == 0, "PBOM编码已存在");
        return mapper.updatePbom(pbom);
    }
    @Transactional
    public int deletePbomByIds(Long[] ids)
    {
        mapper.deletePbomItemByPbomIds(ids);
        return mapper.deletePbomByIds(ids);
    }

    @Transactional
    public String importPbom(List<MomPbomImport> rows, boolean updateSupport, String operName)
    {
        ensure(hasPbomImportRows(rows), "导入数据不能为空");
        Map<String, List<MomPbomImport>> groups = new LinkedHashMap<>();
        int rowNum = 1;
        for (MomPbomImport row : rows)
        {
            rowNum++;
            if (isBlankPbomRow(row))
            {
                continue;
            }
            checkPbomImportRow(row, rowNum);
            groups.computeIfAbsent(row.getPbomCode().trim(), key -> new ArrayList<>()).add(row);
        }
        ensure(!groups.isEmpty(), "导入数据不能为空");

        int success = 0;
        for (Map.Entry<String, List<MomPbomImport>> entry : groups.entrySet())
        {
            List<MomPbomImport> groupRows = entry.getValue();
            MomPbomImport first = groupRows.get(0);
            MomProduct product = baseMapper.selectProductByCode(first.getProductCode().trim());
            ensure(product != null, "成品物料编码不存在：" + first.getProductCode());

            Map<String, Object> pbom = normalize(mapper.selectPbomByCode(entry.getKey()));
            if (pbom != null)
            {
                ensure(updateSupport, "PBOM编码已存在：" + entry.getKey());
                pbom.put("pbomName", first.getPbomName());
                pbom.put("productId", product.getProductId());
                pbom.put("version", defaultString(first.getVersion(), "V1"));
                pbom.put("status", defaultString(first.getStatus(), "0"));
                pbom.put("remark", first.getRemark());
                pbom.put("updateBy", operName);
                updatePbom(pbom);
                mapper.deletePbomItemByPbomIds(new Long[] { longValue(pbom.get("pbomId")) });
            }
            else
            {
                pbom = new LinkedHashMap<>();
                pbom.put("pbomCode", entry.getKey());
                pbom.put("pbomName", first.getPbomName());
                pbom.put("productId", product.getProductId());
                pbom.put("version", defaultString(first.getVersion(), "V1"));
                pbom.put("status", defaultString(first.getStatus(), "0"));
                pbom.put("remark", first.getRemark());
                pbom.put("createBy", operName);
                insertPbom(pbom);
            }

            Long pbomId = longValue(pbom.get("pbomId"));
            for (MomPbomImport row : groupRows)
            {
                insertPbomItem(buildPbomImportItem(row, pbomId, operName));
            }
            success++;
        }
        return "导入成功，共处理 " + success + " 个PBOM，" + groups.values().stream().mapToInt(List::size).sum() + " 条物料明细";
    }

    public List<Map<String, Object>> selectPbomItems(Long pbomId) { return normalizeList(mapper.selectPbomItems(pbomId)); }
    public int insertPbomItem(Map<String, Object> item)
    {
        require(item, "pbomId", "PBOM不能为空");
        require(item, "materialId", "物料不能为空");
        require(item, "resourceId", "工位不能为空");
        require(item, "itemSeq", "行号不能为空");
        if (!item.containsKey("quantity") || item.get("quantity") == null) item.put("quantity", BigDecimal.ONE);
        if (!item.containsKey("parentItemId") || item.get("parentItemId") == null) item.put("parentItemId", 0L);
        return mapper.insertPbomItem(item);
    }
    public int updatePbomItem(Map<String, Object> item) { return mapper.updatePbomItem(item); }
    public int deletePbomItemByIds(Long[] ids) { return mapper.deletePbomItemByIds(ids); }

    private String nextUniquePbomCode()
    {
        for (int i = 0; i < 10; i++)
        {
            String code = codeRuleService.nextCode(RULE_PBOM);
            if (mapper.countPbomCode(code, null) == 0)
            {
                return code;
            }
        }
        throw new ServiceException("PBOM编码自动生成失败，请检查编码规则");
    }

    public List<Map<String, Object>> selectTrayList(Map<String, Object> query) { return normalizeList(mapper.selectTrayList(query)); }
    public int insertTray(Map<String, Object> tray)
    {
        require(tray, "trayCode", "托盘编码不能为空");
        if (!tray.containsKey("status") || tray.get("status") == null) tray.put("status", "0");
        ensure(mapper.countTrayCode(value(tray, "trayCode"), null) == 0, "托盘编码已存在");
        return mapper.insertTray(tray);
    }
    public int updateTray(Map<String, Object> tray)
    {
        Long id = longValue(tray.get("trayId"));
        ensure(id != null, "托盘ID不能为空");
        ensure(mapper.countTrayCode(value(tray, "trayCode"), id) == 0, "托盘编码已存在");
        return mapper.updateTray(tray);
    }
    @Transactional
    public int deleteTrayByIds(Long[] ids)
    {
        mapper.deleteTrayItemByTrayIds(ids);
        return mapper.deleteTrayByIds(ids);
    }
    public List<Map<String, Object>> selectTrayItems(Long trayId) { return normalizeList(mapper.selectTrayItems(trayId)); }
    public int insertTrayItem(Map<String, Object> item)
    {
        require(item, "trayId", "托盘不能为空");
        require(item, "materialId", "物料不能为空");
        return mapper.insertTrayItem(item);
    }
    public int updateTrayItem(Map<String, Object> item) { return mapper.updateTrayItem(item); }
    public int deleteTrayItemByIds(Long[] ids) { return mapper.deleteTrayItemByIds(ids); }

    public List<Map<String, Object>> selectDeviceCategoryList(Map<String, Object> query) { return normalizeList(mapper.selectDeviceCategoryList(query)); }
    public int insertDeviceCategory(Map<String, Object> category)
    {
        require(category, "categoryCode", "设备类别编码不能为空");
        require(category, "categoryName", "设备类别名称不能为空");
        if (!category.containsKey("status") || category.get("status") == null) category.put("status", "0");
        ensure(mapper.countDeviceCategoryCode(value(category, "categoryCode"), null) == 0, "设备类别编码已存在");
        return mapper.insertDeviceCategory(category);
    }
    public int updateDeviceCategory(Map<String, Object> category)
    {
        Long id = longValue(category.get("categoryId"));
        ensure(id != null, "设备类别ID不能为空");
        ensure(mapper.countDeviceCategoryCode(value(category, "categoryCode"), id) == 0, "设备类别编码已存在");
        return mapper.updateDeviceCategory(category);
    }
    public int deleteDeviceCategoryByIds(Long[] ids) { return mapper.deleteDeviceCategoryByIds(ids); }
    public List<Map<String, Object>> selectDeviceList(Map<String, Object> query) { return normalizeList(mapper.selectDeviceList(query)); }
    public int insertDevice(Map<String, Object> device)
    {
        require(device, "deviceCode", "设备编码不能为空");
        require(device, "deviceName", "设备名称不能为空");
        if (!device.containsKey("status") || device.get("status") == null) device.put("status", "offline");
        ensure(mapper.countDeviceCode(value(device, "deviceCode"), null) == 0, "设备编码已存在");
        return mapper.insertDevice(device);
    }
    public int updateDevice(Map<String, Object> device)
    {
        Long id = longValue(device.get("deviceId"));
        ensure(id != null, "设备ID不能为空");
        ensure(mapper.countDeviceCode(value(device, "deviceCode"), id) == 0, "设备编码已存在");
        return mapper.updateDevice(device);
    }
    public int deleteDeviceByIds(Long[] ids) { return mapper.deleteDeviceByIds(ids); }

    @Transactional
    public Map<String, Object> operateDevice(Long deviceId, String action, Map<String, Object> payload, String username)
    {
        Map<String, Object> device = normalize(mapper.selectDeviceById(deviceId));
        ensure(device != null, "设备不存在");
        String status = "online";
        if ("disconnect".equals(action) || "reset".equals(action)) status = "offline";
        if ("capture".equals(action) || "preview".equals(action) || "template".equals(action) || "guide".equals(action) || "coordinate".equals(action))
        {
            status = "online";
        }
        mapper.updateDeviceRuntime(deviceId, status, mockDeviceData(action, payload), username);
        Map<String, Object> trace = new HashMap<>();
        trace.put("traceType", "device");
        trace.put("eventName", "设备操作-" + action);
        trace.put("deviceId", deviceId);
        trace.put("operatorName", username);
        trace.put("result", "OK");
        trace.put("eventData", mockDeviceData(action, payload));
        trace.put("createBy", username);
        mapper.insertProductionTrace(trace);
        Map<String, Object> result = normalize(mapper.selectDeviceById(deviceId));
        result.put("action", action);
        result.put("message", "模拟设备操作成功");
        return result;
    }

    public List<Map<String, Object>> selectWorkstationTasks(Map<String, Object> query) { return normalizeList(mapper.selectWorkstationTasks(query)); }
    public Map<String, Object> selectWorkstationTaskDetail(Long scheduleId)
    {
        Map<String, Object> detail = normalize(mapper.selectWorkstationTaskById(scheduleId));
        ensure(detail != null, "生产任务不存在");
        detail.put("operations", normalizeList(mapper.selectTaskOperations(scheduleId)));
        detail.put("steps", normalizeList(mapper.selectTaskSteps(scheduleId)));
        detail.put("devices", normalizeList(mapper.selectTaskDevices(scheduleId)));
        detail.put("materials", normalizeList(mapper.selectTaskMaterials(scheduleId)));
        detail.put("bindings", normalizeList(mapper.selectMaterialBindings(scheduleId)));
        return detail;
    }
    public Map<String, Object> selectPrepareInfo(Long scheduleId)
    {
        Map<String, Object> info = new HashMap<>();
        info.put("task", normalize(mapper.selectWorkstationTaskById(scheduleId)));
        info.put("materials", normalizeList(mapper.selectTaskMaterials(scheduleId)));
        info.put("bindings", normalizeList(mapper.selectMaterialBindings(scheduleId)));
        info.put("locations", normalizeList(mapper.selectTaskLocations(scheduleId)));
        info.put("trays", mapper.selectTrayList(new HashMap<>()));
        return info;
    }
    @Transactional
    public int insertMaterialBinding(Map<String, Object> binding)
    {
        require(binding, "scheduleId", "生产任务不能为空");
        require(binding, "materialId", "物料不能为空");
        require(binding, "boxCode", "料盒或托盘编码不能为空");
        if (!binding.containsKey("bindingType") || binding.get("bindingType") == null) binding.put("bindingType", "box");
        int rows = mapper.insertMaterialBinding(binding);
        Map<String, Object> trace = new HashMap<>();
        trace.put("scheduleId", binding.get("scheduleId"));
        trace.put("materialId", binding.get("materialId"));
        trace.put("traceType", "prepare");
        trace.put("eventName", "备料绑定");
        trace.put("operatorName", binding.get("createBy"));
        trace.put("result", "OK");
        trace.put("eventData", "料盒/托盘 " + binding.get("boxCode") + " 已绑定");
        trace.put("createBy", binding.get("createBy"));
        mapper.insertProductionTrace(trace);
        return rows;
    }
    public int deleteMaterialBindingByIds(Long[] ids) { return mapper.deleteMaterialBindingByIds(ids); }
    public int startWorkstationTask(Long scheduleId, String username) { return productionService.startSchedule(scheduleId, username); }
    public int finishWorkstationTask(Long scheduleId, String username) { return productionService.finishSchedule(scheduleId, username); }

    @Transactional
    public int insertWorkstationReport(Map<String, Object> payload)
    {
        MomStepReport report = new MomStepReport();
        report.setWorkOrderId(longValue(payload.get("workOrderId")));
        report.setScheduleId(longValue(payload.get("scheduleId")));
        report.setOperationId(longValue(payload.get("operationId")));
        report.setStepId(longValue(payload.get("stepId")));
        report.setResourceId(longValue(payload.get("resourceId")));
        report.setGoodQty(decimalValue(payload.get("goodQty")));
        report.setBadQty(decimalValue(payload.get("badQty")));
        report.setRemark(value(payload, "remark"));
        report.setCreateBy(value(payload, "createBy"));
        report.setReportUser(value(payload, "reportUser"));
        int rows = productionService.insertReport(report);
        Map<String, Object> trace = new HashMap<>();
        trace.put("workOrderId", report.getWorkOrderId());
        trace.put("scheduleId", report.getScheduleId());
        trace.put("operationId", report.getOperationId());
        trace.put("stepId", report.getStepId());
        trace.put("resourceId", report.getResourceId());
        trace.put("serialNo", value(payload, "serialNo"));
        trace.put("traceType", "report");
        trace.put("eventName", "工步报工");
        trace.put("operatorName", report.getReportUser());
        trace.put("result", "OK");
        trace.put("eventData", "合格 " + report.getGoodQty() + "，不良 " + report.getBadQty());
        trace.put("createBy", report.getCreateBy());
        mapper.insertProductionTrace(trace);
        return rows;
    }

    public Map<String, Object> dutyOn(Map<String, Object> duty, String username)
    {
        duty.put("userName", username);
        duty.put("status", "on");
        duty.put("createBy", username);
        mapper.insertDutyLog(duty);
        return duty;
    }
    public Map<String, Object> dutyOff(Map<String, Object> duty, String username)
    {
        duty.put("userName", username);
        duty.put("status", "off");
        duty.put("createBy", username);
        mapper.insertDutyLog(duty);
        return duty;
    }
    public Map<String, Object> selectUserByRfid(Map<String, Object> payload)
    {
        require(payload, "rfidCard", "RFID卡号不能为空");
        Map<String, Object> user = normalize(mapper.selectUserByRfid(value(payload, "rfidCard")));
        ensure(user != null, "未找到绑定该RFID的用户");
        return user;
    }

    public List<Map<String, Object>> selectDutyLogList(Map<String, Object> query) { return normalizeList(mapper.selectDutyLogList(query)); }
    public List<Map<String, Object>> selectProductionTraceList(Map<String, Object> query) { return normalizeList(mapper.selectProductionTraceList(query)); }
    public Map<String, Object> selectSerialTrace(String serialNo)
    {
        Map<String, Object> result = new HashMap<>();
        result.put("serialNo", serialNo);
        result.put("events", normalizeList(mapper.selectSerialTrace(serialNo)));
        return result;
    }

    private String mockDeviceData(String action, Map<String, Object> payload)
    {
        if ("capture".equals(action)) return "抓拍完成，图片地址 /profile/mom/capture/mock-" + System.currentTimeMillis() + ".jpg";
        if ("coordinate".equals(action)) return "X=120,Y=80";
        if ("guide".equals(action)) return "激光指引已发送";
        if ("template".equals(action)) return "模板参数已保存";
        if ("preview".equals(action)) return "视频预览已开启";
        return payload == null ? "设备状态已更新" : payload.toString();
    }

    private void require(Map<String, Object> map, String key, String message)
    {
        if (map == null || map.get(key) == null || String.valueOf(map.get(key)).trim().isEmpty()) throw new ServiceException(message);
    }
    private void ensure(boolean expression, String message)
    {
        if (!expression) throw new ServiceException(message);
    }
    private String value(Map<String, Object> map, String key)
    {
        Object value = map == null ? null : map.get(key);
        return value == null ? null : String.valueOf(value);
    }
    private Long longValue(Object value)
    {
        if (value == null || String.valueOf(value).isEmpty()) return null;
        return Long.valueOf(String.valueOf(value));
    }
    private BigDecimal decimalValue(Object value)
    {
        if (value == null || String.valueOf(value).isEmpty()) return BigDecimal.ZERO;
        return new BigDecimal(String.valueOf(value));
    }

    private List<Map<String, Object>> normalizeList(List<Map<String, Object>> rows)
    {
        List<Map<String, Object>> result = new ArrayList<>();
        if (rows == null) return result;
        for (Map<String, Object> row : rows) result.add(normalize(row));
        return result;
    }

    private Map<String, Object> normalize(Map<String, Object> row)
    {
        if (row == null) return null;
        Map<String, Object> result = new LinkedHashMap<>();
        for (Map.Entry<String, Object> entry : row.entrySet())
        {
            result.put(normalizeKey(entry.getKey()), entry.getValue());
        }
        return result;
    }

    private String normalizeKey(String key)
    {
        String k = key == null ? "" : key.toLowerCase();
        Map<String, String> names = new HashMap<>();
        names.put("pbomid", "pbomId"); names.put("pbomcode", "pbomCode"); names.put("pbomname", "pbomName");
        names.put("productid", "productId"); names.put("productcode", "productCode"); names.put("productname", "productName");
        names.put("itemid", "itemId"); names.put("parentitemid", "parentItemId"); names.put("materialid", "materialId");
        names.put("materialcode", "materialCode"); names.put("materialname", "materialName"); names.put("specmodel", "specModel");
        names.put("itemseq", "itemSeq"); names.put("trayid", "trayId"); names.put("traycode", "trayCode"); names.put("trayname", "trayName");
        names.put("traytype", "trayType"); names.put("resourceid", "resourceId"); names.put("resourcename", "resourceName");
        names.put("categoryid", "categoryId"); names.put("categorycode", "categoryCode"); names.put("categoryname", "categoryName");
        names.put("devicetype", "deviceType"); names.put("deviceid", "deviceId"); names.put("devicecode", "deviceCode");
        names.put("devicename", "deviceName"); names.put("ipaddress", "ipAddress"); names.put("runtimedata", "runtimeData");
        names.put("lastconnecttime", "lastConnectTime"); names.put("scheduleid", "scheduleId"); names.put("schedulecode", "scheduleCode");
        names.put("workorderid", "workOrderId"); names.put("workordercode", "workOrderCode"); names.put("operationid", "operationId");
        names.put("operationcode", "operationCode"); names.put("operationname", "operationName"); names.put("operationseq", "operationSeq");
        names.put("stepid", "stepId"); names.put("stepcode", "stepCode"); names.put("stepname", "stepName"); names.put("stepseq", "stepSeq");
        names.put("standardminutes", "standardMinutes"); names.put("isreportpoint", "isReportPoint"); names.put("stepdesc", "stepDesc");
        names.put("operationtype", "operationType"); names.put("screwcheckcount", "screwCheckCount"); names.put("visionprogram", "visionProgram");
        names.put("guidetaskid", "guideTaskId"); names.put("imageurl", "imageUrl"); names.put("planstarttime", "planStartTime");
        names.put("planendtime", "planEndTime"); names.put("planqty", "planQty"); names.put("reportedqty", "reportedQty");
        names.put("workorderplanqty", "workOrderPlanQty"); names.put("completedqty", "completedQty"); names.put("resourcecode", "resourceCode");
        names.put("bindingid", "bindingId"); names.put("boxcode", "boxCode"); names.put("bindingtype", "bindingType");
        names.put("logid", "logId"); names.put("username", "userName"); names.put("rfidcard", "rfidCard"); names.put("dutytype", "dutyType");
        names.put("traceid", "traceId"); names.put("serialno", "serialNo"); names.put("tracetype", "traceType"); names.put("eventname", "eventName");
        names.put("operatorname", "operatorName"); names.put("eventdata", "eventData"); names.put("createtime", "createTime");
        names.put("createby", "createBy"); names.put("updateby", "updateBy"); names.put("updatetime", "updateTime"); names.put("nickname", "nickName");
        return names.getOrDefault(k, key);
    }

    private Map<String, Object> buildPbomImportItem(MomPbomImport row, Long pbomId, String operName)
    {
        MomMaterial material = baseMapper.selectMaterialByCode(row.getMaterialCode().trim());
        ensure(material != null, "物料编码不存在：" + row.getMaterialCode());
        MomResource station = baseMapper.selectResourceByCode(row.getResourceCode().trim());
        ensure(station != null, "工位编码不存在：" + row.getResourceCode());
        ensure(StringUtils.equals(station.getResourceType(), "station"), "资源不是工位类型：" + row.getResourceCode());
        Map<String, Object> item = new LinkedHashMap<>();
        item.put("pbomId", pbomId);
        item.put("parentItemId", 0L);
        item.put("materialId", material.getMaterialId());
        item.put("resourceId", station.getResourceId());
        item.put("itemSeq", row.getItemSeq());
        item.put("quantity", row.getQuantity());
        item.put("status", "0");
        item.put("remark", row.getRemark());
        item.put("createBy", operName);
        return item;
    }

    private void checkPbomImportRow(MomPbomImport row, int rowNum)
    {
        ensure(StringUtils.isNotBlank(row.getPbomCode()), "第" + rowNum + "行：PBOM编码不能为空");
        ensure(StringUtils.isNotBlank(row.getPbomName()), "第" + rowNum + "行：PBOM名称不能为空");
        ensure(StringUtils.isNotBlank(row.getProductCode()), "第" + rowNum + "行：成品物料编码不能为空");
        ensure(StringUtils.isNotBlank(row.getMaterialCode()), "第" + rowNum + "行：物料编码不能为空");
        ensure(StringUtils.isNotBlank(row.getResourceCode()), "第" + rowNum + "行：工位编码不能为空");
        ensure(row.getItemSeq() != null, "第" + rowNum + "行：行号不能为空");
        ensure(row.getQuantity() != null, "第" + rowNum + "行：数量不能为空");
    }

    private boolean hasPbomImportRows(List<MomPbomImport> rows)
    {
        if (rows == null || rows.isEmpty())
        {
            return false;
        }
        for (MomPbomImport row : rows)
        {
            if (!isBlankPbomRow(row))
            {
                return true;
            }
        }
        return false;
    }

    private boolean isBlankPbomRow(MomPbomImport row)
    {
        return row == null || StringUtils.isBlank(row.getPbomCode()) && StringUtils.isBlank(row.getPbomName())
                && StringUtils.isBlank(row.getProductCode()) && StringUtils.isBlank(row.getMaterialCode());
    }

    private String defaultString(String value, String defaultValue)
    {
        return StringUtils.isBlank(value) ? defaultValue : value.trim();
    }
}
