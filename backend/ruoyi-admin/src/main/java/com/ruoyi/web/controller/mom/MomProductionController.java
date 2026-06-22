package com.ruoyi.web.controller.mom;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.mom.domain.MomSchedule;
import com.ruoyi.mom.domain.MomStepReport;
import com.ruoyi.mom.service.MomProductionService;

/**
 * MOM生产排产和工步报工接口
 */
@RestController
@RequestMapping("/mom/production")
public class MomProductionController extends BaseController
{
    @Autowired
    private MomProductionService service;

    @PreAuthorize("@ss.hasPermi('mom:schedule:list')")
    @GetMapping("/schedule/list")
    public TableDataInfo scheduleList(MomSchedule schedule)
    {
        startPage();
        return getDataTable(service.selectScheduleList(schedule));
    }

    @PreAuthorize("@ss.hasPermi('mom:schedule:query')")
    @GetMapping("/schedule/{scheduleId}")
    public AjaxResult getSchedule(@PathVariable("scheduleId") Long scheduleId)
    {
        return success(service.selectScheduleById(scheduleId));
    }

    @PreAuthorize("@ss.hasPermi('mom:schedule:add')")
    @Log(title = "生产排产", businessType = BusinessType.INSERT)
    @PostMapping("/schedule")
    public AjaxResult addSchedule(@Validated @RequestBody MomSchedule schedule)
    {
        schedule.setCreateBy(getUsername());
        return toAjax(service.insertSchedule(schedule));
    }

    @PreAuthorize("@ss.hasPermi('mom:schedule:edit')")
    @Log(title = "生产排产", businessType = BusinessType.UPDATE)
    @PutMapping("/schedule")
    public AjaxResult editSchedule(@Validated @RequestBody MomSchedule schedule)
    {
        schedule.setUpdateBy(getUsername());
        return toAjax(service.updateSchedule(schedule));
    }

    @PreAuthorize("@ss.hasPermi('mom:schedule:remove')")
    @Log(title = "生产排产", businessType = BusinessType.DELETE)
    @DeleteMapping("/schedule/{scheduleIds}")
    public AjaxResult removeSchedule(@PathVariable("scheduleIds") Long[] scheduleIds)
    {
        return toAjax(service.deleteScheduleByIds(scheduleIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:schedule:export')")
    @Log(title = "生产排产", businessType = BusinessType.EXPORT)
    @PostMapping("/schedule/export")
    public void exportSchedule(HttpServletResponse response, MomSchedule schedule)
    {
        new ExcelUtil<MomSchedule>(MomSchedule.class).exportExcel(response, service.selectScheduleList(schedule), "生产排产数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:schedule:release')")
    @Log(title = "排产下达", businessType = BusinessType.UPDATE)
    @PostMapping("/schedule/{scheduleId}/release")
    public AjaxResult releaseSchedule(@PathVariable("scheduleId") Long scheduleId)
    {
        return toAjax(service.releaseSchedule(scheduleId, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:schedule:start')")
    @Log(title = "排产开工", businessType = BusinessType.UPDATE)
    @PostMapping("/schedule/{scheduleId}/start")
    public AjaxResult startSchedule(@PathVariable("scheduleId") Long scheduleId)
    {
        return toAjax(service.startSchedule(scheduleId, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:schedule:finish')")
    @Log(title = "排产完工", businessType = BusinessType.UPDATE)
    @PostMapping("/schedule/{scheduleId}/finish")
    public AjaxResult finishSchedule(@PathVariable("scheduleId") Long scheduleId)
    {
        return toAjax(service.finishSchedule(scheduleId, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:schedule:cancel')")
    @Log(title = "排产取消", businessType = BusinessType.UPDATE)
    @PostMapping("/schedule/{scheduleId}/cancel")
    public AjaxResult cancelSchedule(@PathVariable("scheduleId") Long scheduleId)
    {
        return toAjax(service.cancelSchedule(scheduleId, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:report:list')")
    @GetMapping("/report/list")
    public TableDataInfo reportList(MomStepReport report)
    {
        startPage();
        return getDataTable(service.selectReportList(report));
    }

    @PreAuthorize("@ss.hasPermi('mom:report:query')")
    @GetMapping("/report/{reportId}")
    public AjaxResult getReport(@PathVariable("reportId") Long reportId)
    {
        return success(service.selectReportById(reportId));
    }

    @PreAuthorize("@ss.hasPermi('mom:report:add')")
    @Log(title = "工步报工", businessType = BusinessType.INSERT)
    @PostMapping("/report")
    public AjaxResult addReport(@Validated @RequestBody MomStepReport report)
    {
        report.setCreateBy(getUsername());
        report.setReportUser(getUsername());
        return toAjax(service.insertReport(report));
    }

    @PreAuthorize("@ss.hasPermi('mom:report:remove')")
    @Log(title = "工步报工", businessType = BusinessType.DELETE)
    @DeleteMapping("/report/{reportIds}")
    public AjaxResult removeReport(@PathVariable("reportIds") Long[] reportIds)
    {
        return toAjax(service.deleteReportByIds(reportIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:report:export')")
    @Log(title = "工步报工", businessType = BusinessType.EXPORT)
    @PostMapping("/report/export")
    public void exportReport(HttpServletResponse response, MomStepReport report)
    {
        new ExcelUtil<MomStepReport>(MomStepReport.class).exportExcel(response, service.selectReportList(report), "工步报工数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:report:query')")
    @GetMapping("/workorder/{workOrderId}/operations")
    public AjaxResult workOrderOperations(@PathVariable("workOrderId") Long workOrderId)
    {
        return success(service.selectOperationsByWorkOrderId(workOrderId));
    }

    @PreAuthorize("@ss.hasPermi('mom:report:query')")
    @GetMapping("/workorder/{workOrderId}/steps")
    public AjaxResult workOrderSteps(@PathVariable("workOrderId") Long workOrderId)
    {
        return success(service.selectStepsByWorkOrderId(workOrderId));
    }
}
