package com.ruoyi.mom.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM生产工单 mom_work_order
 */
public class MomWorkOrder extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "工单ID")
    private Long workOrderId;

    @Excel(name = "工单编码")
    private String workOrderCode;

    @Excel(name = "工单名称")
    private String workOrderName;

    @Excel(name = "产品ID")
    private Long productId;

    @Excel(name = "产品编码")
    private String productCode;

    @Excel(name = "产品名称")
    private String productName;

    @Excel(name = "MBOM ID")
    private Long mbomId;

    @Excel(name = "MBOM编码")
    private String mbomCode;

    @Excel(name = "工艺路线ID")
    private Long routingId;

    @Excel(name = "路线编码")
    private String routingCode;

    @Excel(name = "资源ID")
    private Long resourceId;

    @Excel(name = "资源编码")
    private String resourceCode;

    @Excel(name = "资源名称")
    private String resourceName;

    @Excel(name = "计划数量")
    private BigDecimal planQty;

    @Excel(name = "完工数量")
    private BigDecimal completedQty;

    @Excel(name = "单位")
    private String unit;

    @Excel(name = "优先级")
    private String priority;

    @Excel(name = "来源单号")
    private String sourceOrderCode;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "计划开始", width = 30, dateFormat = "yyyy-MM-dd")
    private Date planStartDate;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "计划结束", width = 30, dateFormat = "yyyy-MM-dd")
    private Date planEndDate;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "实际开始", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date actualStartTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "实际结束", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date actualEndTime;

    @Excel(name = "工单状态")
    private String status;

    public Long getWorkOrderId() { return workOrderId; }
    public void setWorkOrderId(Long workOrderId) { this.workOrderId = workOrderId; }

    @NotBlank(message = "工单编码不能为空")
    public String getWorkOrderCode() { return workOrderCode; }
    public void setWorkOrderCode(String workOrderCode) { this.workOrderCode = workOrderCode; }

    @NotBlank(message = "工单名称不能为空")
    public String getWorkOrderName() { return workOrderName; }
    public void setWorkOrderName(String workOrderName) { this.workOrderName = workOrderName; }

    @NotNull(message = "产品不能为空")
    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public Long getMbomId() { return mbomId; }
    public void setMbomId(Long mbomId) { this.mbomId = mbomId; }
    public String getMbomCode() { return mbomCode; }
    public void setMbomCode(String mbomCode) { this.mbomCode = mbomCode; }
    public Long getRoutingId() { return routingId; }
    public void setRoutingId(Long routingId) { this.routingId = routingId; }
    public String getRoutingCode() { return routingCode; }
    public void setRoutingCode(String routingCode) { this.routingCode = routingCode; }
    public Long getResourceId() { return resourceId; }
    public void setResourceId(Long resourceId) { this.resourceId = resourceId; }
    public String getResourceCode() { return resourceCode; }
    public void setResourceCode(String resourceCode) { this.resourceCode = resourceCode; }
    public String getResourceName() { return resourceName; }
    public void setResourceName(String resourceName) { this.resourceName = resourceName; }

    @NotNull(message = "计划数量不能为空")
    public BigDecimal getPlanQty() { return planQty; }
    public void setPlanQty(BigDecimal planQty) { this.planQty = planQty; }

    public BigDecimal getCompletedQty() { return completedQty; }
    public void setCompletedQty(BigDecimal completedQty) { this.completedQty = completedQty; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }
    public String getSourceOrderCode() { return sourceOrderCode; }
    public void setSourceOrderCode(String sourceOrderCode) { this.sourceOrderCode = sourceOrderCode; }
    public Date getPlanStartDate() { return planStartDate; }
    public void setPlanStartDate(Date planStartDate) { this.planStartDate = planStartDate; }
    public Date getPlanEndDate() { return planEndDate; }
    public void setPlanEndDate(Date planEndDate) { this.planEndDate = planEndDate; }
    public Date getActualStartTime() { return actualStartTime; }
    public void setActualStartTime(Date actualStartTime) { this.actualStartTime = actualStartTime; }
    public Date getActualEndTime() { return actualEndTime; }
    public void setActualEndTime(Date actualEndTime) { this.actualEndTime = actualEndTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
