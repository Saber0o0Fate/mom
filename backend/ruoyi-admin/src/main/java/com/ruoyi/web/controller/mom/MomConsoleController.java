package com.ruoyi.web.controller.mom;

import java.io.IOException;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.mom.domain.MomPbomImport;
import com.ruoyi.mom.service.MomConsoleService;

/**
 * MOM操作台、设备、PBOM、托盘和追溯接口
 */
@RestController
@RequestMapping("/mom")
public class MomConsoleController extends BaseController
{
    @Autowired
    private MomConsoleService service;

    @PreAuthorize("@ss.hasPermi('mom:pbom:list')")
    @GetMapping("/pbom/list")
    public TableDataInfo pbomList(@RequestParam Map<String, Object> query)
    {
        startPage();
        return getDataTable(service.selectPbomList(query));
    }

    @PreAuthorize("@ss.hasPermi('mom:pbom:query')")
    @GetMapping("/pbom/{pbomId}")
    public AjaxResult getPbom(@PathVariable("pbomId") Long pbomId)
    {
        return success(service.selectPbomById(pbomId));
    }

    @PreAuthorize("@ss.hasPermi('mom:pbom:add')")
    @Log(title = "PBOM维护", businessType = BusinessType.INSERT)
    @PostMapping("/pbom")
    public AjaxResult addPbom(@RequestBody Map<String, Object> pbom)
    {
        pbom.put("createBy", getUsername());
        return service.insertPbom(pbom) > 0 ? success(pbom) : error();
    }

    @PreAuthorize("@ss.hasPermi('mom:pbom:edit')")
    @Log(title = "PBOM维护", businessType = BusinessType.UPDATE)
    @PutMapping("/pbom")
    public AjaxResult editPbom(@RequestBody Map<String, Object> pbom)
    {
        pbom.put("updateBy", getUsername());
        return toAjax(service.updatePbom(pbom));
    }

    @PreAuthorize("@ss.hasPermi('mom:pbom:remove')")
    @Log(title = "PBOM维护", businessType = BusinessType.DELETE)
    @DeleteMapping("/pbom/{pbomIds}")
    public AjaxResult removePbom(@PathVariable("pbomIds") Long[] pbomIds)
    {
        return toAjax(service.deletePbomByIds(pbomIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:pbom:export')")
    @Log(title = "PBOM维护", businessType = BusinessType.EXPORT)
    @PostMapping("/pbom/export")
    public void exportPbom(HttpServletResponse response, @RequestParam Map<String, Object> query) throws IOException
    {
        response.setContentType("text/csv;charset=utf-8");
        response.setHeader("Content-Disposition", "attachment; filename=pbom.csv");
        response.getWriter().println("pbomCode,pbomName,productName,version,status");
        for (Map<String, Object> row : service.selectPbomList(query))
        {
            response.getWriter().println(row.get("PBOMCODE") + "," + row.get("PBOMNAME") + "," + row.get("PRODUCTNAME") + "," + row.get("VERSION") + "," + row.get("STATUS"));
        }
    }

    @PreAuthorize("@ss.hasPermi('mom:pbom:add')")
    @Log(title = "PBOM维护", businessType = BusinessType.IMPORT)
    @PostMapping("/pbom/importData")
    public AjaxResult importPbom(@RequestParam("file") MultipartFile file, @RequestParam(value = "updateSupport", defaultValue = "false") boolean updateSupport) throws Exception
    {
        ExcelUtil<MomPbomImport> util = new ExcelUtil<MomPbomImport>(MomPbomImport.class);
        String message = service.importPbom(util.importExcel(file.getInputStream()), updateSupport, getUsername());
        return success(message);
    }

    @PostMapping("/pbom/importTemplate")
    public void importPbomTemplate(HttpServletResponse response)
    {
        ExcelUtil<MomPbomImport> util = new ExcelUtil<MomPbomImport>(MomPbomImport.class);
        util.importTemplateExcel(response, "PBOM物料导入模板");
    }

    @PreAuthorize("@ss.hasPermi('mom:pbom:query')")
    @GetMapping("/pbom/{pbomId}/items")
    public AjaxResult pbomItems(@PathVariable("pbomId") Long pbomId)
    {
        return success(service.selectPbomItems(pbomId));
    }

    @PreAuthorize("@ss.hasPermi('mom:pbom:add')")
    @PostMapping("/pbom/item")
    public AjaxResult addPbomItem(@RequestBody Map<String, Object> item)
    {
        item.put("createBy", getUsername());
        return toAjax(service.insertPbomItem(item));
    }

    @PreAuthorize("@ss.hasPermi('mom:pbom:edit')")
    @PutMapping("/pbom/item")
    public AjaxResult editPbomItem(@RequestBody Map<String, Object> item)
    {
        item.put("updateBy", getUsername());
        return toAjax(service.updatePbomItem(item));
    }

    @PreAuthorize("@ss.hasPermi('mom:pbom:remove')")
    @DeleteMapping("/pbom/item/{itemIds}")
    public AjaxResult removePbomItem(@PathVariable("itemIds") Long[] itemIds)
    {
        return toAjax(service.deletePbomItemByIds(itemIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:tray:list')")
    @GetMapping("/tray/list")
    public TableDataInfo trayList(@RequestParam Map<String, Object> query)
    {
        startPage();
        return getDataTable(service.selectTrayList(query));
    }

    @PreAuthorize("@ss.hasPermi('mom:tray:add')")
    @PostMapping("/tray")
    public AjaxResult addTray(@RequestBody Map<String, Object> tray)
    {
        tray.put("createBy", getUsername());
        return toAjax(service.insertTray(tray));
    }

    @PreAuthorize("@ss.hasPermi('mom:tray:edit')")
    @PutMapping("/tray")
    public AjaxResult editTray(@RequestBody Map<String, Object> tray)
    {
        tray.put("updateBy", getUsername());
        return toAjax(service.updateTray(tray));
    }

    @PreAuthorize("@ss.hasPermi('mom:tray:remove')")
    @DeleteMapping("/tray/{trayIds}")
    public AjaxResult removeTray(@PathVariable("trayIds") Long[] trayIds)
    {
        return toAjax(service.deleteTrayByIds(trayIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:tray:query')")
    @GetMapping("/tray/{trayId}/items")
    public AjaxResult trayItems(@PathVariable("trayId") Long trayId)
    {
        return success(service.selectTrayItems(trayId));
    }

    @PreAuthorize("@ss.hasPermi('mom:tray:add')")
    @PostMapping("/tray/item")
    public AjaxResult addTrayItem(@RequestBody Map<String, Object> item)
    {
        item.put("createBy", getUsername());
        return toAjax(service.insertTrayItem(item));
    }

    @PreAuthorize("@ss.hasPermi('mom:tray:edit')")
    @PutMapping("/tray/item")
    public AjaxResult editTrayItem(@RequestBody Map<String, Object> item)
    {
        item.put("updateBy", getUsername());
        return toAjax(service.updateTrayItem(item));
    }

    @PreAuthorize("@ss.hasPermi('mom:tray:remove')")
    @DeleteMapping("/tray/item/{itemIds}")
    public AjaxResult removeTrayItem(@PathVariable("itemIds") Long[] itemIds)
    {
        return toAjax(service.deleteTrayItemByIds(itemIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:device:list')")
    @GetMapping("/device/category/list")
    public TableDataInfo deviceCategoryList(@RequestParam Map<String, Object> query)
    {
        startPage();
        return getDataTable(service.selectDeviceCategoryList(query));
    }

    @PreAuthorize("@ss.hasPermi('mom:device:add')")
    @PostMapping("/device/category")
    public AjaxResult addDeviceCategory(@RequestBody Map<String, Object> category)
    {
        category.put("createBy", getUsername());
        return toAjax(service.insertDeviceCategory(category));
    }

    @PreAuthorize("@ss.hasPermi('mom:device:edit')")
    @PutMapping("/device/category")
    public AjaxResult editDeviceCategory(@RequestBody Map<String, Object> category)
    {
        category.put("updateBy", getUsername());
        return toAjax(service.updateDeviceCategory(category));
    }

    @PreAuthorize("@ss.hasPermi('mom:device:remove')")
    @DeleteMapping("/device/category/{categoryIds}")
    public AjaxResult removeDeviceCategory(@PathVariable("categoryIds") Long[] categoryIds)
    {
        return toAjax(service.deleteDeviceCategoryByIds(categoryIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:device:list')")
    @GetMapping("/device/list")
    public TableDataInfo deviceList(@RequestParam Map<String, Object> query)
    {
        startPage();
        return getDataTable(service.selectDeviceList(query));
    }

    @GetMapping("/device/options")
    public AjaxResult deviceOptions(@RequestParam Map<String, Object> query)
    {
        return success(service.selectDeviceList(query));
    }

    @PreAuthorize("@ss.hasPermi('mom:device:add')")
    @PostMapping("/device")
    public AjaxResult addDevice(@RequestBody Map<String, Object> device)
    {
        device.put("createBy", getUsername());
        return toAjax(service.insertDevice(device));
    }

    @PreAuthorize("@ss.hasPermi('mom:device:edit')")
    @PutMapping("/device")
    public AjaxResult editDevice(@RequestBody Map<String, Object> device)
    {
        device.put("updateBy", getUsername());
        return toAjax(service.updateDevice(device));
    }

    @PreAuthorize("@ss.hasPermi('mom:device:remove')")
    @DeleteMapping("/device/{deviceIds}")
    public AjaxResult removeDevice(@PathVariable("deviceIds") Long[] deviceIds)
    {
        return toAjax(service.deleteDeviceByIds(deviceIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:device:operate')")
    @PostMapping("/device/{deviceId}/{action}")
    public AjaxResult operateDevice(@PathVariable("deviceId") Long deviceId, @PathVariable("action") String action, @RequestBody(required = false) Map<String, Object> payload)
    {
        return success(service.operateDevice(deviceId, action, payload, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:workstation:list')")
    @GetMapping("/workstation/tasks")
    public AjaxResult workstationTasks(@RequestParam Map<String, Object> query)
    {
        return success(service.selectWorkstationTasks(query));
    }

    @PreAuthorize("@ss.hasPermi('mom:workstation:query')")
    @GetMapping("/workstation/task/{scheduleId}")
    public AjaxResult workstationTask(@PathVariable("scheduleId") Long scheduleId)
    {
        return success(service.selectWorkstationTaskDetail(scheduleId));
    }

    @PreAuthorize("@ss.hasPermi('mom:workstation:query')")
    @GetMapping("/workstation/task/{scheduleId}/prepare")
    public AjaxResult prepareInfo(@PathVariable("scheduleId") Long scheduleId)
    {
        return success(service.selectPrepareInfo(scheduleId));
    }

    @PreAuthorize("@ss.hasPermi('mom:workstation:edit')")
    @PostMapping("/workstation/binding")
    public AjaxResult bindMaterialBox(@RequestBody Map<String, Object> binding)
    {
        binding.put("createBy", getUsername());
        return toAjax(service.insertMaterialBinding(binding));
    }

    @PreAuthorize("@ss.hasPermi('mom:workstation:edit')")
    @DeleteMapping("/workstation/binding/{bindingIds}")
    public AjaxResult removeBinding(@PathVariable("bindingIds") Long[] bindingIds)
    {
        return toAjax(service.deleteMaterialBindingByIds(bindingIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:workstation:edit')")
    @PostMapping("/workstation/task/{scheduleId}/start")
    public AjaxResult startWorkstationTask(@PathVariable("scheduleId") Long scheduleId)
    {
        return toAjax(service.startWorkstationTask(scheduleId, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:workstation:edit')")
    @PostMapping("/workstation/task/{scheduleId}/finish")
    public AjaxResult finishWorkstationTask(@PathVariable("scheduleId") Long scheduleId)
    {
        return toAjax(service.finishWorkstationTask(scheduleId, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:workstation:edit')")
    @PostMapping("/workstation/report")
    public AjaxResult workstationReport(@RequestBody Map<String, Object> report)
    {
        report.put("createBy", getUsername());
        report.put("reportUser", getUsername());
        return toAjax(service.insertWorkstationReport(report));
    }

    @PreAuthorize("@ss.hasPermi('mom:workstation:edit')")
    @PostMapping("/workstation/duty/on")
    public AjaxResult dutyOn(@RequestBody Map<String, Object> duty)
    {
        return success(service.dutyOn(duty, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:workstation:edit')")
    @PostMapping("/workstation/duty/off")
    public AjaxResult dutyOff(@RequestBody Map<String, Object> duty)
    {
        return success(service.dutyOff(duty, getUsername()));
    }

    @Anonymous
    @PostMapping("/workstation/rfid")
    public AjaxResult rfid(@RequestBody Map<String, Object> payload)
    {
        return success(service.selectUserByRfid(payload));
    }

    @PreAuthorize("@ss.hasPermi('mom:trace:list')")
    @GetMapping("/trace/duty/list")
    public TableDataInfo dutyLogList(@RequestParam Map<String, Object> query)
    {
        startPage();
        return getDataTable(service.selectDutyLogList(query));
    }

    @PreAuthorize("@ss.hasPermi('mom:trace:list')")
    @GetMapping("/trace/production/list")
    public TableDataInfo productionTraceList(@RequestParam Map<String, Object> query)
    {
        startPage();
        return getDataTable(service.selectProductionTraceList(query));
    }

    @PreAuthorize("@ss.hasPermi('mom:trace:query')")
    @GetMapping("/trace/serial/{serialNo}")
    public AjaxResult serialTrace(@PathVariable("serialNo") String serialNo)
    {
        return success(service.selectSerialTrace(serialNo));
    }
}
