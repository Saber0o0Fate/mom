package com.ruoyi.mom.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM生产排产 mom_schedule
 */
public class MomSchedule extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "排产ID")
    private Long scheduleId;
    @Excel(name = "排产编码")
    private String scheduleCode;
    @Excel(name = "工单ID")
    private Long workOrderId;
    @Excel(name = "工单编码")
    private String workOrderCode;
    @Excel(name = "产品名称")
    private String productName;
    @Excel(name = "工序ID")
    private Long operationId;
    @Excel(name = "工序编码")
    private String operationCode;
    @Excel(name = "工序名称")
    private String operationName;
    @Excel(name = "资源ID")
    private Long resourceId;
    @Excel(name = "资源编码")
    private String resourceCode;
    @Excel(name = "资源名称")
    private String resourceName;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "计划开始", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date planStartTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "计划结束", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date planEndTime;
    @Excel(name = "计划数量")
    private BigDecimal planQty;
    @Excel(name = "已报工数量")
    private BigDecimal reportedQty;
    @Excel(name = "状态")
    private String status;

    public Long getScheduleId() { return scheduleId; }
    public void setScheduleId(Long scheduleId) { this.scheduleId = scheduleId; }
    @NotBlank(message = "排产编码不能为空")
    public String getScheduleCode() { return scheduleCode; }
    public void setScheduleCode(String scheduleCode) { this.scheduleCode = scheduleCode; }
    @NotNull(message = "工单不能为空")
    public Long getWorkOrderId() { return workOrderId; }
    public void setWorkOrderId(Long workOrderId) { this.workOrderId = workOrderId; }
    public String getWorkOrderCode() { return workOrderCode; }
    public void setWorkOrderCode(String workOrderCode) { this.workOrderCode = workOrderCode; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public Long getOperationId() { return operationId; }
    public void setOperationId(Long operationId) { this.operationId = operationId; }
    public String getOperationCode() { return operationCode; }
    public void setOperationCode(String operationCode) { this.operationCode = operationCode; }
    public String getOperationName() { return operationName; }
    public void setOperationName(String operationName) { this.operationName = operationName; }
    @NotNull(message = "生产资源不能为空")
    public Long getResourceId() { return resourceId; }
    public void setResourceId(Long resourceId) { this.resourceId = resourceId; }
    public String getResourceCode() { return resourceCode; }
    public void setResourceCode(String resourceCode) { this.resourceCode = resourceCode; }
    public String getResourceName() { return resourceName; }
    public void setResourceName(String resourceName) { this.resourceName = resourceName; }
    @NotNull(message = "计划开始时间不能为空")
    public Date getPlanStartTime() { return planStartTime; }
    public void setPlanStartTime(Date planStartTime) { this.planStartTime = planStartTime; }
    @NotNull(message = "计划结束时间不能为空")
    public Date getPlanEndTime() { return planEndTime; }
    public void setPlanEndTime(Date planEndTime) { this.planEndTime = planEndTime; }
    @NotNull(message = "计划数量不能为空")
    public BigDecimal getPlanQty() { return planQty; }
    public void setPlanQty(BigDecimal planQty) { this.planQty = planQty; }
    public BigDecimal getReportedQty() { return reportedQty; }
    public void setReportedQty(BigDecimal reportedQty) { this.reportedQty = reportedQty; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
