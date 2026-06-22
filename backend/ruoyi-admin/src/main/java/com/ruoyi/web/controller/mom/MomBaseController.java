package com.ruoyi.web.controller.mom;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.mom.domain.MomMaterial;
import com.ruoyi.mom.domain.MomMaterialCategory;
import com.ruoyi.mom.domain.MomOperation;
import com.ruoyi.mom.domain.MomProduct;
import com.ruoyi.mom.domain.MomResource;
import com.ruoyi.mom.domain.MomRouting;
import com.ruoyi.mom.domain.MomRoutingStepImport;
import com.ruoyi.mom.domain.MomShiftCalendar;
import com.ruoyi.mom.domain.MomWorkStep;
import com.ruoyi.mom.service.MomBaseService;

/**
 * MOM基础数据接口
 */
@RestController
@RequestMapping("/mom/base")
public class MomBaseController extends BaseController
{
    @Autowired
    private MomBaseService service;

    @PreAuthorize("@ss.hasPermi('mom:base:materialCategory:list')")
    @GetMapping("/materialCategory/list")
    public AjaxResult materialCategoryList(MomMaterialCategory category)
    {
        return success(service.selectMaterialCategoryList(category));
    }

    @GetMapping("/materialCategory/tree")
    public AjaxResult materialCategoryTree()
    {
        return success(service.selectMaterialCategoryTree());
    }

    @PreAuthorize("@ss.hasPermi('mom:base:materialCategory:query')")
    @GetMapping("/materialCategory/{categoryId}")
    public AjaxResult materialCategory(@PathVariable("categoryId") Long categoryId)
    {
        return success(service.selectMaterialCategoryById(categoryId));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:materialCategory:add')")
    @Log(title = "物料分类", businessType = BusinessType.INSERT)
    @PostMapping("/materialCategory")
    public AjaxResult addMaterialCategory(@Validated @RequestBody MomMaterialCategory category)
    {
        category.setCreateBy(getUsername());
        return toAjax(service.insertMaterialCategory(category));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:materialCategory:edit')")
    @Log(title = "物料分类", businessType = BusinessType.UPDATE)
    @PutMapping("/materialCategory")
    public AjaxResult editMaterialCategory(@Validated @RequestBody MomMaterialCategory category)
    {
        category.setUpdateBy(getUsername());
        return toAjax(service.updateMaterialCategory(category));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:materialCategory:remove')")
    @Log(title = "物料分类", businessType = BusinessType.DELETE)
    @DeleteMapping("/materialCategory/{categoryIds}")
    public AjaxResult removeMaterialCategory(@PathVariable("categoryIds") Long[] categoryIds)
    {
        return toAjax(service.deleteMaterialCategoryByIds(categoryIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:material:list')")
    @GetMapping("/material/list")
    public TableDataInfo materialList(MomMaterial material)
    {
        startPage();
        return getDataTable(service.selectMaterialList(material));
    }

    @GetMapping("/material/optionselect")
    public AjaxResult materialOptions()
    {
        return success(service.selectMaterialAll());
    }

    @PreAuthorize("@ss.hasPermi('mom:base:material:query')")
    @GetMapping("/material/{materialId}")
    public AjaxResult material(@PathVariable("materialId") Long materialId)
    {
        return success(service.selectMaterialById(materialId));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:material:add')")
    @Log(title = "物料数据", businessType = BusinessType.INSERT)
    @PostMapping("/material")
    public AjaxResult addMaterial(@Validated @RequestBody MomMaterial material)
    {
        material.setCreateBy(getUsername());
        return toAjax(service.insertMaterial(material));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:material:edit')")
    @Log(title = "物料数据", businessType = BusinessType.UPDATE)
    @PutMapping("/material")
    public AjaxResult editMaterial(@Validated @RequestBody MomMaterial material)
    {
        material.setUpdateBy(getUsername());
        return toAjax(service.updateMaterial(material));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:material:remove')")
    @Log(title = "物料数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/material/{materialIds}")
    public AjaxResult removeMaterial(@PathVariable("materialIds") Long[] materialIds)
    {
        return toAjax(service.deleteMaterialByIds(materialIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:material:export')")
    @Log(title = "物料数据", businessType = BusinessType.EXPORT)
    @PostMapping("/material/export")
    public void exportMaterial(HttpServletResponse response, MomMaterial material)
    {
        new ExcelUtil<MomMaterial>(MomMaterial.class).exportExcel(response, service.selectMaterialList(material), "物料数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:base:material:import')")
    @Log(title = "物料数据", businessType = BusinessType.IMPORT)
    @PostMapping("/material/importData")
    public AjaxResult importMaterial(@RequestParam("file") MultipartFile file, @RequestParam(value = "updateSupport", defaultValue = "false") boolean updateSupport) throws Exception
    {
        ExcelUtil<MomMaterial> util = new ExcelUtil<MomMaterial>(MomMaterial.class);
        List<MomMaterial> materialList = util.importExcel(file.getInputStream());
        String message = service.importMaterial(materialList, updateSupport, getUsername());
        return success(message);
    }

    @PostMapping("/material/importTemplate")
    public void importMaterialTemplate(HttpServletResponse response)
    {
        ExcelUtil<MomMaterial> util = new ExcelUtil<MomMaterial>(MomMaterial.class);
        util.importTemplateExcel(response, "物料数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:base:product:list')")
    @GetMapping("/product/list")
    public TableDataInfo productList(MomProduct product)
    {
        startPage();
        return getDataTable(service.selectProductList(product));
    }

    @GetMapping("/product/optionselect")
    public AjaxResult productOptions()
    {
        return success(service.selectProductAll());
    }

    @PreAuthorize("@ss.hasPermi('mom:base:product:query')")
    @GetMapping("/product/{productId}")
    public AjaxResult product(@PathVariable("productId") Long productId)
    {
        return success(service.selectProductById(productId));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:product:add')")
    @Log(title = "产品维护", businessType = BusinessType.INSERT)
    @PostMapping("/product")
    public AjaxResult addProduct(@Validated @RequestBody MomProduct product)
    {
        product.setCreateBy(getUsername());
        return toAjax(service.insertProduct(product));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:product:edit')")
    @Log(title = "产品维护", businessType = BusinessType.UPDATE)
    @PutMapping("/product")
    public AjaxResult editProduct(@Validated @RequestBody MomProduct product)
    {
        product.setUpdateBy(getUsername());
        return toAjax(service.updateProduct(product));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:product:remove')")
    @Log(title = "产品维护", businessType = BusinessType.DELETE)
    @DeleteMapping("/product/{productIds}")
    public AjaxResult removeProduct(@PathVariable("productIds") Long[] productIds)
    {
        return toAjax(service.deleteProductByIds(productIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:product:export')")
    @Log(title = "产品维护", businessType = BusinessType.EXPORT)
    @PostMapping("/product/export")
    public void exportProduct(HttpServletResponse response, MomProduct product)
    {
        new ExcelUtil<MomProduct>(MomProduct.class).exportExcel(response, service.selectProductList(product), "产品数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:base:resource:list')")
    @GetMapping("/resource/list")
    public TableDataInfo resourceList(MomResource resource)
    {
        startPage();
        return getDataTable(service.selectResourceList(resource));
    }

    @GetMapping("/resource/optionselect")
    public AjaxResult resourceOptions()
    {
        return success(service.selectResourceAll());
    }

    @PreAuthorize("@ss.hasPermi('mom:base:resource:query')")
    @GetMapping("/resource/{resourceId}")
    public AjaxResult resource(@PathVariable("resourceId") Long resourceId)
    {
        return success(service.selectResourceById(resourceId));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:resource:add')")
    @Log(title = "生产资源", businessType = BusinessType.INSERT)
    @PostMapping("/resource")
    public AjaxResult addResource(@Validated @RequestBody MomResource resource)
    {
        resource.setCreateBy(getUsername());
        return toAjax(service.insertResource(resource));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:resource:edit')")
    @Log(title = "生产资源", businessType = BusinessType.UPDATE)
    @PutMapping("/resource")
    public AjaxResult editResource(@Validated @RequestBody MomResource resource)
    {
        resource.setUpdateBy(getUsername());
        return toAjax(service.updateResource(resource));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:resource:remove')")
    @Log(title = "生产资源", businessType = BusinessType.DELETE)
    @DeleteMapping("/resource/{resourceIds}")
    public AjaxResult removeResource(@PathVariable("resourceIds") Long[] resourceIds)
    {
        return toAjax(service.deleteResourceByIds(resourceIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:resource:export')")
    @Log(title = "生产资源", businessType = BusinessType.EXPORT)
    @PostMapping("/resource/export")
    public void exportResource(HttpServletResponse response, MomResource resource)
    {
        new ExcelUtil<MomResource>(MomResource.class).exportExcel(response, service.selectResourceList(resource), "生产资源数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:base:calendar:list')")
    @GetMapping("/calendar/list")
    public TableDataInfo calendarList(MomShiftCalendar calendar)
    {
        startPage();
        return getDataTable(service.selectCalendarList(calendar));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:calendar:query')")
    @GetMapping("/calendar/{calendarId}")
    public AjaxResult calendar(@PathVariable("calendarId") Long calendarId)
    {
        return success(service.selectCalendarById(calendarId));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:calendar:add')")
    @Log(title = "班次日历", businessType = BusinessType.INSERT)
    @PostMapping("/calendar")
    public AjaxResult addCalendar(@Validated @RequestBody MomShiftCalendar calendar)
    {
        calendar.setCreateBy(getUsername());
        return toAjax(service.insertCalendar(calendar));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:calendar:edit')")
    @Log(title = "班次日历", businessType = BusinessType.UPDATE)
    @PutMapping("/calendar")
    public AjaxResult editCalendar(@Validated @RequestBody MomShiftCalendar calendar)
    {
        calendar.setUpdateBy(getUsername());
        return toAjax(service.updateCalendar(calendar));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:calendar:remove')")
    @Log(title = "班次日历", businessType = BusinessType.DELETE)
    @DeleteMapping("/calendar/{calendarIds}")
    public AjaxResult removeCalendar(@PathVariable("calendarIds") Long[] calendarIds)
    {
        return toAjax(service.deleteCalendarByIds(calendarIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:calendar:export')")
    @Log(title = "班次日历", businessType = BusinessType.EXPORT)
    @PostMapping("/calendar/export")
    public void exportCalendar(HttpServletResponse response, MomShiftCalendar calendar)
    {
        new ExcelUtil<MomShiftCalendar>(MomShiftCalendar.class).exportExcel(response, service.selectCalendarList(calendar), "班次日历数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:base:routing:list')")
    @GetMapping("/routing/list")
    public TableDataInfo routingList(MomRouting routing)
    {
        startPage();
        return getDataTable(service.selectRoutingList(routing));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:routing:query')")
    @GetMapping("/routing/{routingId}")
    public AjaxResult routing(@PathVariable("routingId") Long routingId)
    {
        return success(service.selectRoutingById(routingId));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:routing:query')")
    @GetMapping("/routing/{routingId}/detail")
    public AjaxResult routingDetail(@PathVariable("routingId") Long routingId)
    {
        return success(service.selectRoutingDetail(routingId));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:routing:add')")
    @Log(title = "工艺路线", businessType = BusinessType.INSERT)
    @PostMapping("/routing")
    public AjaxResult addRouting(@Validated @RequestBody MomRouting routing)
    {
        routing.setCreateBy(getUsername());
        return toAjax(service.insertRouting(routing));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:routing:edit')")
    @Log(title = "工艺路线", businessType = BusinessType.UPDATE)
    @PutMapping("/routing")
    public AjaxResult editRouting(@Validated @RequestBody MomRouting routing)
    {
        routing.setUpdateBy(getUsername());
        return toAjax(service.updateRouting(routing));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:routing:remove')")
    @Log(title = "工艺路线", businessType = BusinessType.DELETE)
    @DeleteMapping("/routing/{routingIds}")
    public AjaxResult removeRouting(@PathVariable("routingIds") Long[] routingIds)
    {
        return toAjax(service.deleteRoutingByIds(routingIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:routing:export')")
    @Log(title = "工艺路线", businessType = BusinessType.EXPORT)
    @PostMapping("/routing/export")
    public void exportRouting(HttpServletResponse response, MomRouting routing)
    {
        new ExcelUtil<MomRoutingStepImport>(MomRoutingStepImport.class).exportExcel(response, service.selectRoutingStepExportList(routing), "工艺路线工步数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:base:routing:add')")
    @Log(title = "工艺路线", businessType = BusinessType.IMPORT)
    @PostMapping("/routing/importData")
    public AjaxResult importRouting(@RequestParam("file") MultipartFile file, @RequestParam(value = "updateSupport", defaultValue = "false") boolean updateSupport) throws Exception
    {
        ExcelUtil<MomRoutingStepImport> util = new ExcelUtil<MomRoutingStepImport>(MomRoutingStepImport.class);
        List<MomRoutingStepImport> importList = util.importExcel(file.getInputStream());
        String message = service.importRoutingBySteps(importList, updateSupport, getUsername());
        return success(message);
    }

    @PostMapping("/routing/importTemplate")
    public void importRoutingTemplate(HttpServletResponse response)
    {
        ExcelUtil<MomRoutingStepImport> util = new ExcelUtil<MomRoutingStepImport>(MomRoutingStepImport.class);
        util.importTemplateExcel(response, "工艺路线工步导入模板");
    }

    @PreAuthorize("@ss.hasPermi('mom:base:operation:list')")
    @GetMapping("/operation/list")
    public TableDataInfo operationList(MomOperation operation)
    {
        startPage();
        return getDataTable(service.selectOperationList(operation));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:operation:query')")
    @GetMapping("/operation/{operationId}")
    public AjaxResult operation(@PathVariable("operationId") Long operationId)
    {
        return success(service.selectOperationById(operationId));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:operation:add')")
    @Log(title = "工序维护", businessType = BusinessType.INSERT)
    @PostMapping("/operation")
    public AjaxResult addOperation(@Validated @RequestBody MomOperation operation)
    {
        operation.setCreateBy(getUsername());
        return toAjax(service.insertOperation(operation));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:operation:edit')")
    @Log(title = "工序维护", businessType = BusinessType.UPDATE)
    @PutMapping("/operation")
    public AjaxResult editOperation(@Validated @RequestBody MomOperation operation)
    {
        operation.setUpdateBy(getUsername());
        return toAjax(service.updateOperation(operation));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:operation:remove')")
    @Log(title = "工序维护", businessType = BusinessType.DELETE)
    @DeleteMapping("/operation/{operationIds}")
    public AjaxResult removeOperation(@PathVariable("operationIds") Long[] operationIds)
    {
        return toAjax(service.deleteOperationByIds(operationIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:operation:export')")
    @Log(title = "工序维护", businessType = BusinessType.EXPORT)
    @PostMapping("/operation/export")
    public void exportOperation(HttpServletResponse response, MomOperation operation)
    {
        new ExcelUtil<MomOperation>(MomOperation.class).exportExcel(response, service.selectOperationList(operation), "工序数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:base:step:list')")
    @GetMapping("/step/list")
    public TableDataInfo stepList(MomWorkStep step)
    {
        startPage();
        return getDataTable(service.selectStepList(step));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:step:query')")
    @GetMapping("/step/{stepId}")
    public AjaxResult step(@PathVariable("stepId") Long stepId)
    {
        return success(service.selectStepById(stepId));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:step:add')")
    @Log(title = "工步维护", businessType = BusinessType.INSERT)
    @PostMapping("/step")
    public AjaxResult addStep(@Validated @RequestBody MomWorkStep step)
    {
        step.setCreateBy(getUsername());
        return toAjax(service.insertStep(step));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:step:edit')")
    @Log(title = "工步维护", businessType = BusinessType.UPDATE)
    @PutMapping("/step")
    public AjaxResult editStep(@Validated @RequestBody MomWorkStep step)
    {
        step.setUpdateBy(getUsername());
        return toAjax(service.updateStep(step));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:step:remove')")
    @Log(title = "工步维护", businessType = BusinessType.DELETE)
    @DeleteMapping("/step/{stepIds}")
    public AjaxResult removeStep(@PathVariable("stepIds") Long[] stepIds)
    {
        return toAjax(service.deleteStepByIds(stepIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:base:step:export')")
    @Log(title = "工步维护", businessType = BusinessType.EXPORT)
    @PostMapping("/step/export")
    public void exportStep(HttpServletResponse response, MomWorkStep step)
    {
        new ExcelUtil<MomWorkStep>(MomWorkStep.class).exportExcel(response, service.selectStepList(step), "工步数据");
    }
}
