package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.SysCodeRule;

/**
 * 编码规则 数据层
 */
public interface SysCodeRuleMapper
{
    public List<SysCodeRule> selectCodeRuleList(SysCodeRule rule);

    public SysCodeRule selectCodeRuleById(Long ruleId);

    public SysCodeRule selectCodeRuleByCode(String ruleCode);

    public int countRuleCode(@Param("ruleCode") String ruleCode, @Param("ruleId") Long ruleId);

    public int insertCodeRule(SysCodeRule rule);

    public int updateCodeRule(SysCodeRule rule);

    public int deleteCodeRuleByIds(Long[] ruleIds);

    public int resetCodeRule(Long ruleId);

    public int insertCodeRuleRecord(@Param("ruleCode") String ruleCode, @Param("generatedCode") String generatedCode);
}
