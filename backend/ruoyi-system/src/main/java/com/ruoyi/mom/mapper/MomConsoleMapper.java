package com.ruoyi.mom.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

public interface MomConsoleMapper
{
    public List<Map<String, Object>> selectPbomList(Map<String, Object> query);
    public Map<String, Object> selectPbomById(Long pbomId);
    public Map<String, Object> selectPbomByCode(String pbomCode);
    public int countPbomCode(@Param("pbomCode") String pbomCode, @Param("pbomId") Long pbomId);
    public int insertPbom(Map<String, Object> pbom);
    public int updatePbom(Map<String, Object> pbom);
    public int deletePbomByIds(Long[] pbomIds);
    public List<Map<String, Object>> selectPbomItems(Long pbomId);
    public int insertPbomItem(Map<String, Object> item);
    public int updatePbomItem(Map<String, Object> item);
    public int deletePbomItemByIds(Long[] itemIds);
    public int deletePbomItemByPbomIds(Long[] pbomIds);

    public List<Map<String, Object>> selectTrayList(Map<String, Object> query);
    public Map<String, Object> selectTrayByCode(String trayCode);
    public int countTrayCode(@Param("trayCode") String trayCode, @Param("trayId") Long trayId);
    public int insertTray(Map<String, Object> tray);
    public int updateTray(Map<String, Object> tray);
    public int deleteTrayByIds(Long[] trayIds);
    public List<Map<String, Object>> selectTrayItems(Long trayId);
    public int insertTrayItem(Map<String, Object> item);
    public int updateTrayItem(Map<String, Object> item);
    public int deleteTrayItemByIds(Long[] itemIds);
    public int deleteTrayItemByTrayIds(Long[] trayIds);

    public List<Map<String, Object>> selectDeviceCategoryList(Map<String, Object> query);
    public int countDeviceCategoryCode(@Param("categoryCode") String categoryCode, @Param("categoryId") Long categoryId);
    public int insertDeviceCategory(Map<String, Object> category);
    public int updateDeviceCategory(Map<String, Object> category);
    public int deleteDeviceCategoryByIds(Long[] categoryIds);
    public List<Map<String, Object>> selectDeviceList(Map<String, Object> query);
    public Map<String, Object> selectDeviceById(Long deviceId);
    public int countDeviceCode(@Param("deviceCode") String deviceCode, @Param("deviceId") Long deviceId);
    public int insertDevice(Map<String, Object> device);
    public int updateDevice(Map<String, Object> device);
    public int updateDeviceRuntime(@Param("deviceId") Long deviceId, @Param("status") String status, @Param("runtimeData") String runtimeData, @Param("updateBy") String updateBy);
    public int deleteDeviceByIds(Long[] deviceIds);

    public List<Map<String, Object>> selectWorkstationTasks(Map<String, Object> query);
    public Map<String, Object> selectWorkstationTaskById(Long scheduleId);
    public List<Map<String, Object>> selectTaskOperations(Long scheduleId);
    public List<Map<String, Object>> selectTaskSteps(Long scheduleId);
    public List<Map<String, Object>> selectTaskDevices(Long scheduleId);
    public List<Map<String, Object>> selectTaskMaterials(Long scheduleId);
    public List<Map<String, Object>> selectTaskLocations(Long scheduleId);
    public List<Map<String, Object>> selectMaterialBindings(Long scheduleId);
    public int insertMaterialBinding(Map<String, Object> binding);
    public int deleteMaterialBindingByIds(Long[] bindingIds);

    public int insertDutyLog(Map<String, Object> duty);
    public List<Map<String, Object>> selectDutyLogList(Map<String, Object> query);
    public int insertProductionTrace(Map<String, Object> trace);
    public List<Map<String, Object>> selectProductionTraceList(Map<String, Object> query);
    public List<Map<String, Object>> selectSerialTrace(String serialNo);
    public Map<String, Object> selectUserByRfid(String rfidCard);
}
