package com.ruoyi.system.domain;

import java.util.Date;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 编码规则 sys_code_rule
 */
public class SysCodeRule extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "规则ID")
    private Long ruleId;

    @Excel(name = "规则编码")
    private String ruleCode;

    @Excel(name = "规则名称")
    private String ruleName;

    @Excel(name = "编码前缀")
    private String prefix;

    @Excel(name = "日期格式")
    private String dateFormat;

    @Excel(name = "流水号位数")
    private Integer serialLength;

    @Excel(name = "分隔符")
    private String separator;

    @Excel(name = "重置周期")
    private String resetPeriod;

    @Excel(name = "当前序号")
    private Long currentSerial;

    @Excel(name = "最后生成时间", dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date lastGenerateTime;

    @Excel(name = "状态", readConverterExp = "0=启用,1=禁用")
    private String status;

    public Long getRuleId() { return ruleId; }
    public void setRuleId(Long ruleId) { this.ruleId = ruleId; }

    @NotBlank(message = "规则编码不能为空")
    @Size(max = 64, message = "规则编码长度不能超过64个字符")
    public String getRuleCode() { return ruleCode; }
    public void setRuleCode(String ruleCode) { this.ruleCode = ruleCode; }

    @NotBlank(message = "规则名称不能为空")
    @Size(max = 100, message = "规则名称长度不能超过100个字符")
    public String getRuleName() { return ruleName; }
    public void setRuleName(String ruleName) { this.ruleName = ruleName; }

    @Size(max = 32, message = "编码前缀长度不能超过32个字符")
    public String getPrefix() { return prefix; }
    public void setPrefix(String prefix) { this.prefix = prefix; }

    public String getDateFormat() { return dateFormat; }
    public void setDateFormat(String dateFormat) { this.dateFormat = dateFormat; }

    @NotNull(message = "流水号位数不能为空")
    public Integer getSerialLength() { return serialLength; }
    public void setSerialLength(Integer serialLength) { this.serialLength = serialLength; }

    @Size(max = 8, message = "分隔符长度不能超过8个字符")
    public String getSeparator() { return separator; }
    public void setSeparator(String separator) { this.separator = separator; }

    @NotBlank(message = "重置周期不能为空")
    public String getResetPeriod() { return resetPeriod; }
    public void setResetPeriod(String resetPeriod) { this.resetPeriod = resetPeriod; }

    public Long getCurrentSerial() { return currentSerial; }
    public void setCurrentSerial(Long currentSerial) { this.currentSerial = currentSerial; }

    public Date getLastGenerateTime() { return lastGenerateTime; }
    public void setLastGenerateTime(Date lastGenerateTime) { this.lastGenerateTime = lastGenerateTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
