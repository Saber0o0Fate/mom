package com.ruoyi.web.controller.mom;

import java.math.BigDecimal;
import java.util.List;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.mom.domain.MomWorkOrder;
import com.ruoyi.mom.domain.MomWorkOrderImport;
import com.ruoyi.mom.service.MomWorkOrderService;

/**
 * MOM生产工单接口
 */
@RestController
@RequestMapping("/mom/workorder")
public class MomWorkOrderController extends BaseController
{
    @Autowired
    private MomWorkOrderService service;

    @PreAuthorize("@ss.hasPermi('mom:workorder:list')")
    @GetMapping("/list")
    public TableDataInfo list(MomWorkOrder workOrder)
    {
        startPage();
        return getDataTable(service.selectWorkOrderList(workOrder));
    }

    @PreAuthorize("@ss.hasPermi('mom:workorder:query')")
    @GetMapping("/{workOrderId}")
    public AjaxResult getInfo(@PathVariable("workOrderId") Long workOrderId)
    {
        return success(service.selectWorkOrderById(workOrderId));
    }

    @PreAuthorize("@ss.hasPermi('mom:workorder:add')")
    @Log(title = "生产工单", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MomWorkOrder workOrder)
    {
        workOrder.setCreateBy(getUsername());
        return toAjax(service.insertWorkOrder(workOrder));
    }

    @PreAuthorize("@ss.hasPermi('mom:workorder:edit')")
    @Log(title = "生产工单", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MomWorkOrder workOrder)
    {
        workOrder.setUpdateBy(getUsername());
        return toAjax(service.updateWorkOrder(workOrder));
    }

    @PreAuthorize("@ss.hasPermi('mom:workorder:remove')")
    @Log(title = "生产工单", businessType = BusinessType.DELETE)
    @DeleteMapping("/{workOrderIds}")
    public AjaxResult remove(@PathVariable("workOrderIds") Long[] workOrderIds)
    {
        return toAjax(service.deleteWorkOrderByIds(workOrderIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:workorder:export')")
    @Log(title = "生产工单", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MomWorkOrder workOrder)
    {
        new ExcelUtil<MomWorkOrder>(MomWorkOrder.class).exportExcel(response, service.selectWorkOrderList(workOrder), "生产工单数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:workorder:add')")
    @Log(title = "生产工单", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(@RequestParam("file") MultipartFile file, @RequestParam(value = "updateSupport", defaultValue = "false") boolean updateSupport) throws Exception
    {
        ExcelUtil<MomWorkOrderImport> util = new ExcelUtil<MomWorkOrderImport>(MomWorkOrderImport.class);
        List<MomWorkOrderImport> importList = util.importExcel(file.getInputStream());
        String message = service.importWorkOrder(importList, updateSupport, getUsername());
        return success(message);
    }

    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response)
    {
        ExcelUtil<MomWorkOrderImport> util = new ExcelUtil<MomWorkOrderImport>(MomWorkOrderImport.class);
        util.importTemplateExcel(response, "生产工单导入模板");
    }

    @PreAuthorize("@ss.hasPermi('mom:workorder:release')")
    @Log(title = "生产工单下达", businessType = BusinessType.UPDATE)
    @PostMapping("/{workOrderId}/release")
    public AjaxResult release(@PathVariable("workOrderId") Long workOrderId)
    {
        return toAjax(service.release(workOrderId, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:workorder:start')")
    @Log(title = "生产工单开工", businessType = BusinessType.UPDATE)
    @PostMapping("/{workOrderId}/start")
    public AjaxResult start(@PathVariable("workOrderId") Long workOrderId)
    {
        return toAjax(service.start(workOrderId, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:workorder:finish')")
    @Log(title = "生产工单完工", businessType = BusinessType.UPDATE)
    @PostMapping("/{workOrderId}/finish")
    public AjaxResult finish(@PathVariable("workOrderId") Long workOrderId, @RequestParam(required = false) BigDecimal completedQty)
    {
        return toAjax(service.finish(workOrderId, completedQty, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:workorder:close')")
    @Log(title = "生产工单关闭", businessType = BusinessType.UPDATE)
    @PostMapping("/{workOrderId}/close")
    public AjaxResult close(@PathVariable("workOrderId") Long workOrderId)
    {
        return toAjax(service.close(workOrderId, getUsername()));
    }
}
