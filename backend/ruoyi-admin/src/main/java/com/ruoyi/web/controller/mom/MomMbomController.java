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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.RequestParam;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.mom.domain.MomMbom;
import com.ruoyi.mom.domain.MomMbomGenerateRequest;
import com.ruoyi.mom.domain.MomMbomImport;
import com.ruoyi.mom.domain.MomMbomItem;
import com.ruoyi.mom.service.MomMbomService;

/**
 * MOM制造BOM接口
 */
@RestController
@RequestMapping("/mom/mbom")
public class MomMbomController extends BaseController
{
    @Autowired
    private MomMbomService service;

    @PreAuthorize("@ss.hasPermi('mom:mbom:list')")
    @GetMapping("/list")
    public TableDataInfo list(MomMbom mbom)
    {
        startPage();
        return getDataTable(service.selectMbomList(mbom));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:query')")
    @GetMapping("/{mbomId}")
    public AjaxResult getInfo(@PathVariable("mbomId") Long mbomId)
    {
        return success(service.selectMbomById(mbomId));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:query')")
    @GetMapping("/{mbomId}/detail")
    public AjaxResult detail(@PathVariable("mbomId") Long mbomId)
    {
        return success(service.selectMbomDetail(mbomId));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:add')")
    @Log(title = "MBOM维护", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MomMbom mbom)
    {
        mbom.setCreateBy(getUsername());
        return toAjax(service.insertMbom(mbom));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:add')")
    @Log(title = "MBOM自动生成", businessType = BusinessType.INSERT)
    @PostMapping("/generate")
    public AjaxResult generate(@Validated @RequestBody MomMbomGenerateRequest request)
    {
        return success(service.generateMbom(request, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:edit')")
    @Log(title = "MBOM维护", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MomMbom mbom)
    {
        mbom.setUpdateBy(getUsername());
        return toAjax(service.updateMbom(mbom));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:remove')")
    @Log(title = "MBOM维护", businessType = BusinessType.DELETE)
    @DeleteMapping("/{mbomIds}")
    public AjaxResult remove(@PathVariable("mbomIds") Long[] mbomIds)
    {
        return toAjax(service.deleteMbomByIds(mbomIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:export')")
    @Log(title = "MBOM维护", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MomMbom mbom)
    {
        new ExcelUtil<MomMbom>(MomMbom.class).exportExcel(response, service.selectMbomList(mbom), "MBOM数据");
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:add')")
    @Log(title = "MBOM维护", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(@RequestParam("file") MultipartFile file, @RequestParam(value = "updateSupport", defaultValue = "false") boolean updateSupport) throws Exception
    {
        ExcelUtil<MomMbomImport> util = new ExcelUtil<MomMbomImport>(MomMbomImport.class);
        String message = service.importMbom(util.importExcel(file.getInputStream()), updateSupport, getUsername());
        return success(message);
    }

    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response)
    {
        ExcelUtil<MomMbomImport> util = new ExcelUtil<MomMbomImport>(MomMbomImport.class);
        util.importTemplateExcel(response, "MBOM工步投料导入模板");
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:item:list')")
    @GetMapping("/item/list")
    public AjaxResult itemList(MomMbomItem item)
    {
        return success(service.selectItemList(item));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:item:query')")
    @GetMapping("/item/{itemId}")
    public AjaxResult item(@PathVariable("itemId") Long itemId)
    {
        return success(service.selectItemById(itemId));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:item:add')")
    @Log(title = "MBOM明细", businessType = BusinessType.INSERT)
    @PostMapping("/item")
    public AjaxResult addItem(@Validated @RequestBody MomMbomItem item)
    {
        item.setCreateBy(getUsername());
        return toAjax(service.insertItem(item));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:item:edit')")
    @Log(title = "MBOM明细", businessType = BusinessType.UPDATE)
    @PutMapping("/item")
    public AjaxResult editItem(@Validated @RequestBody MomMbomItem item)
    {
        item.setUpdateBy(getUsername());
        return toAjax(service.updateItem(item));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:item:remove')")
    @Log(title = "MBOM明细", businessType = BusinessType.DELETE)
    @DeleteMapping("/item/{itemIds}")
    public AjaxResult removeItem(@PathVariable("itemIds") Long[] itemIds)
    {
        return toAjax(service.deleteItemByIds(itemIds));
    }

    @PreAuthorize("@ss.hasPermi('mom:mbom:item:export')")
    @Log(title = "MBOM明细", businessType = BusinessType.EXPORT)
    @PostMapping("/item/export")
    public void exportItem(HttpServletResponse response, MomMbomItem item)
    {
        new ExcelUtil<MomMbomItem>(MomMbomItem.class).exportExcel(response, service.selectItemList(item), "MBOM明细数据");
    }
}
