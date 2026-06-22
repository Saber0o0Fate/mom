package com.ruoyi.system.service.impl;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysCodeRule;
import com.ruoyi.system.mapper.SysCodeRuleMapper;
import com.ruoyi.system.service.ISysCodeRuleService;

/**
 * 编码规则 服务层实现
 */
@Service
public class SysCodeRuleServiceImpl implements ISysCodeRuleService
{
    @Autowired
    private SysCodeRuleMapper ruleMapper;

    @Override
    public List<SysCodeRule> selectCodeRuleList(SysCodeRule rule)
    {
        return ruleMapper.selectCodeRuleList(rule);
    }

    @Override
    public SysCodeRule selectCodeRuleById(Long ruleId)
    {
        return ruleMapper.selectCodeRuleById(ruleId);
    }

    @Override
    public int insertCodeRule(SysCodeRule rule)
    {
        checkRule(rule);
        if (rule.getCurrentSerial() == null)
        {
            rule.setCurrentSerial(0L);
        }
        return ruleMapper.insertCodeRule(rule);
    }

    @Override
    public int updateCodeRule(SysCodeRule rule)
    {
        checkRule(rule);
        return ruleMapper.updateCodeRule(rule);
    }

    @Override
    public int deleteCodeRuleByIds(Long[] ruleIds)
    {
        return ruleMapper.deleteCodeRuleByIds(ruleIds);
    }

    @Override
    public int resetCodeRule(Long ruleId)
    {
        return ruleMapper.resetCodeRule(ruleId);
    }

    @Override
    public String previewCode(Long ruleId)
    {
        SysCodeRule rule = mustGetRule(ruleId);
        return buildCode(rule, nextSerial(rule, false));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public synchronized String nextCode(String ruleCode)
    {
        SysCodeRule rule = ruleMapper.selectCodeRuleByCode(ruleCode);
        if (rule == null)
        {
            throw new ServiceException("编码规则不存在");
        }
        if ("1".equals(rule.getStatus()))
        {
            throw new ServiceException("编码规则已禁用");
        }
        Long serial = nextSerial(rule, true);
        for (int i = 0; i < 10; i++)
        {
            String code = buildCode(rule, serial);
            try
            {
                ruleMapper.insertCodeRuleRecord(rule.getRuleCode(), code);
                rule.setCurrentSerial(serial);
                rule.setLastGenerateTime(new Date());
                ruleMapper.updateCodeRule(rule);
                return code;
            }
            catch (DuplicateKeyException e)
            {
                serial++;
            }
        }
        throw new ServiceException("编码生成失败，请检查规则流水号");
    }

    private void checkRule(SysCodeRule rule)
    {
        Long ruleId = rule.getRuleId() == null ? -1L : rule.getRuleId();
        if (ruleMapper.countRuleCode(rule.getRuleCode(), ruleId) > 0)
        {
            throw new ServiceException("规则编码已存在");
        }
        if (rule.getSerialLength() == null || rule.getSerialLength() < 1 || rule.getSerialLength() > 12)
        {
            throw new ServiceException("流水号位数需在1到12之间");
        }
    }

    private SysCodeRule mustGetRule(Long ruleId)
    {
        SysCodeRule rule = ruleMapper.selectCodeRuleById(ruleId);
        if (rule == null)
        {
            throw new ServiceException("编码规则不存在");
        }
        return rule;
    }

    private Long nextSerial(SysCodeRule rule, boolean consume)
    {
        Long current = rule.getCurrentSerial() == null ? 0L : rule.getCurrentSerial();
        if (shouldReset(rule) && consume)
        {
            current = 0L;
        }
        return current + 1L;
    }

    private boolean shouldReset(SysCodeRule rule)
    {
        if (rule.getLastGenerateTime() == null || StringUtils.equals(rule.getResetPeriod(), "NONE"))
        {
            return false;
        }
        LocalDate last = rule.getLastGenerateTime().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate now = LocalDate.now();
        if (StringUtils.equals(rule.getResetPeriod(), "DAILY"))
        {
            return !last.equals(now);
        }
        if (StringUtils.equals(rule.getResetPeriod(), "MONTHLY"))
        {
            return last.getYear() != now.getYear() || last.getMonthValue() != now.getMonthValue();
        }
        if (StringUtils.equals(rule.getResetPeriod(), "YEARLY"))
        {
            return last.getYear() != now.getYear();
        }
        return false;
    }

    private String buildCode(SysCodeRule rule, Long serial)
    {
        String separator = StringUtils.defaultString(rule.getSeparator());
        StringBuilder code = new StringBuilder();
        appendPart(code, rule.getPrefix(), separator);
        appendPart(code, formatDate(rule.getDateFormat()), separator);
        appendPart(code, String.format("%0" + rule.getSerialLength() + "d", serial), separator);
        return code.toString();
    }

    private void appendPart(StringBuilder code, String value, String separator)
    {
        if (StringUtils.isBlank(value))
        {
            return;
        }
        if (code.length() > 0)
        {
            code.append(separator);
        }
        code.append(value);
    }

    private String formatDate(String format)
    {
        if (StringUtils.isBlank(format) || StringUtils.equals(format, "NONE"))
        {
            return "";
        }
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern(format));
    }
}
