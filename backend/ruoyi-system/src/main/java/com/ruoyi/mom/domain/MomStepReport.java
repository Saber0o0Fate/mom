package com.ruoyi.mom.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotNull;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM工步报工 mom_step_report
 */
public class MomStepReport extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "报工ID")
    private Long reportId;
    @Excel(name = "工单ID")
    private Long workOrderId;
    @Excel(name = "工单编码")
    private String workOrderCode;
    @Excel(name = "产品名称")
    private String productName;
    @Excel(name = "排产ID")
    private Long scheduleId;
    @Excel(name = "工序ID")
    private Long operationId;
    @Excel(name = "工序编码")
    private String operationCode;
    @Excel(name = "工序名称")
    private String operationName;
    @Excel(name = "工步ID")
    private Long stepId;
    @Excel(name = "工步编码")
    private String stepCode;
    @Excel(name = "工步名称")
    private String stepName;
    @Excel(name = "资源ID")
    private Long resourceId;
    @Excel(name = "资源名称")
    private String resourceName;
    @Excel(name = "合格数量")
    private BigDecimal goodQty;
    @Excel(name = "不良数量")
    private BigDecimal badQty;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "报工时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date reportTime;
    @Excel(name = "报工人")
    private String reportUser;
    @Excel(name = "状态")
    private String status;

    public Long getReportId() { return reportId; }
    public void setReportId(Long reportId) { this.reportId = reportId; }
    @NotNull(message = "工单不能为空")
    public Long getWorkOrderId() { return workOrderId; }
    public void setWorkOrderId(Long workOrderId) { this.workOrderId = workOrderId; }
    public String getWorkOrderCode() { return workOrderCode; }
    public void setWorkOrderCode(String workOrderCode) { this.workOrderCode = workOrderCode; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public Long getScheduleId() { return scheduleId; }
    public void setScheduleId(Long scheduleId) { this.scheduleId = scheduleId; }
    @NotNull(message = "工序不能为空")
    public Long getOperationId() { return operationId; }
    public void setOperationId(Long operationId) { this.operationId = operationId; }
    public String getOperationCode() { return operationCode; }
    public void setOperationCode(String operationCode) { this.operationCode = operationCode; }
    public String getOperationName() { return operationName; }
    public void setOperationName(String operationName) { this.operationName = operationName; }
    @NotNull(message = "工步不能为空")
    public Long getStepId() { return stepId; }
    public void setStepId(Long stepId) { this.stepId = stepId; }
    public String getStepCode() { return stepCode; }
    public void setStepCode(String stepCode) { this.stepCode = stepCode; }
    public String getStepName() { return stepName; }
    public void setStepName(String stepName) { this.stepName = stepName; }
    public Long getResourceId() { return resourceId; }
    public void setResourceId(Long resourceId) { this.resourceId = resourceId; }
    public String getResourceName() { return resourceName; }
    public void setResourceName(String resourceName) { this.resourceName = resourceName; }
    @NotNull(message = "合格数量不能为空")
    public BigDecimal getGoodQty() { return goodQty; }
    public void setGoodQty(BigDecimal goodQty) { this.goodQty = goodQty; }
    public BigDecimal getBadQty() { return badQty; }
    public void setBadQty(BigDecimal badQty) { this.badQty = badQty; }
    public Date getReportTime() { return reportTime; }
    public void setReportTime(Date reportTime) { this.reportTime = reportTime; }
    public String getReportUser() { return reportUser; }
    public void setReportUser(String reportUser) { this.reportUser = reportUser; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
