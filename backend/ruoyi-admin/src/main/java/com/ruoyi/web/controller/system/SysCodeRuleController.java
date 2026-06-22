package com.ruoyi.web.controller.system;

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
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.SysCodeRule;
import com.ruoyi.system.service.ISysCodeRuleService;

/**
 * 编码规则 信息操作处理
 */
@RestController
@RequestMapping("/system/codeRule")
public class SysCodeRuleController extends BaseController
{
    @Autowired
    private ISysCodeRuleService codeRuleService;

    @PreAuthorize("@ss.hasPermi('system:codeRule:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysCodeRule rule)
    {
        startPage();
        List<SysCodeRule> list = codeRuleService.selectCodeRuleList(rule);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('system:codeRule:export')")
    @Log(title = "编码规则", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysCodeRule rule)
    {
        ExcelUtil<SysCodeRule> util = new ExcelUtil<SysCodeRule>(SysCodeRule.class);
        util.exportExcel(response, codeRuleService.selectCodeRuleList(rule), "编码规则数据");
    }

    @PreAuthorize("@ss.hasPermi('system:codeRule:query')")
    @GetMapping(value = "/{ruleId}")
    public AjaxResult getInfo(@PathVariable("ruleId") Long ruleId)
    {
        return success(codeRuleService.selectCodeRuleById(ruleId));
    }

    @PreAuthorize("@ss.hasPermi('system:codeRule:add')")
    @Log(title = "编码规则", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SysCodeRule rule)
    {
        rule.setCreateBy(getUsername());
        return toAjax(codeRuleService.insertCodeRule(rule));
    }

    @PreAuthorize("@ss.hasPermi('system:codeRule:edit')")
    @Log(title = "编码规则", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SysCodeRule rule)
    {
        rule.setUpdateBy(getUsername());
        return toAjax(codeRuleService.updateCodeRule(rule));
    }

    @PreAuthorize("@ss.hasPermi('system:codeRule:remove')")
    @Log(title = "编码规则", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ruleIds}")
    public AjaxResult remove(@PathVariable("ruleIds") Long[] ruleIds)
    {
        return toAjax(codeRuleService.deleteCodeRuleByIds(ruleIds));
    }

    @PreAuthorize("@ss.hasPermi('system:codeRule:edit')")
    @Log(title = "编码规则", businessType = BusinessType.UPDATE)
    @PutMapping("/reset/{ruleId}")
    public AjaxResult reset(@PathVariable("ruleId") Long ruleId)
    {
        return toAjax(codeRuleService.resetCodeRule(ruleId));
    }

    @PreAuthorize("@ss.hasPermi('system:codeRule:query')")
    @GetMapping("/preview/{ruleId}")
    public AjaxResult preview(@PathVariable("ruleId") Long ruleId)
    {
        return AjaxResult.success().put(AjaxResult.DATA_TAG, codeRuleService.previewCode(ruleId));
    }

    @PreAuthorize("@ss.hasPermi('system:codeRule:query')")
    @GetMapping("/next/{ruleCode}")
    public AjaxResult next(@PathVariable("ruleCode") String ruleCode)
    {
        return AjaxResult.success().put(AjaxResult.DATA_TAG, codeRuleService.nextCode(ruleCode));
    }
}
