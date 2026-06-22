package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SysCodeRule;

/**
 * 编码规则 服务层
 */
public interface ISysCodeRuleService
{
    public List<SysCodeRule> selectCodeRuleList(SysCodeRule rule);

    public SysCodeRule selectCodeRuleById(Long ruleId);

    public int insertCodeRule(SysCodeRule rule);

    public int updateCodeRule(SysCodeRule rule);

    public int deleteCodeRuleByIds(Long[] ruleIds);

    public int resetCodeRule(Long ruleId);

    public String previewCode(Long ruleId);

    public String nextCode(String ruleCode);
}
