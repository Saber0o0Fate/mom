package com.ruoyi.mom.domain;

import java.math.BigDecimal;
import java.util.Date;
import org.apache.poi.ss.usermodel.IndexedColors;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 生产工单导入行
 */
public class MomWorkOrderImport extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "工单编码", sort = 1, headerBackgroundColor = IndexedColors.RED)
    private String workOrderCode;

    @Excel(name = "工单名称", sort = 2, headerBackgroundColor = IndexedColors.RED)
    private String workOrderName;

    @Excel(name = "成品物料编码", sort = 3, headerBackgroundColor = IndexedColors.RED)
    private String productCode;

    @Excel(name = "MBOM编码", sort = 4)
    private String mbomCode;

    @Excel(name = "路线编码", sort = 5)
    private String routingCode;

    @Excel(name = "资源编码", sort = 6)
    private String resourceCode;

    @Excel(name = "计划数量", sort = 7, headerBackgroundColor = IndexedColors.RED)
    private BigDecimal planQty;

    @Excel(name = "单位", sort = 8)
    private String unit;

    @Excel(name = "优先级", sort = 9, readConverterExp = "normal=普通,urgent=加急,critical=紧急", defaultValue = "normal")
    private String priority;

    @Excel(name = "来源单号", sort = 10)
    private String sourceOrderCode;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "计划开始", sort = 11, width = 30, dateFormat = "yyyy-MM-dd")
    private Date planStartDate;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "计划结束", sort = 12, width = 30, dateFormat = "yyyy-MM-dd")
    private Date planEndDate;

    @Excel(name = "状态", sort = 13, readConverterExp = "draft=草稿,released=已下达,running=生产中,finished=已完工,closed=已关闭", defaultValue = "draft")
    private String status;

    @Excel(name = "备注", sort = 14)
    private String remark;

    public String getWorkOrderCode() { return workOrderCode; }
    public void setWorkOrderCode(String workOrderCode) { this.workOrderCode = workOrderCode; }
    public String getWorkOrderName() { return workOrderName; }
    public void setWorkOrderName(String workOrderName) { this.workOrderName = workOrderName; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public String getMbomCode() { return mbomCode; }
    public void setMbomCode(String mbomCode) { this.mbomCode = mbomCode; }
    public String getRoutingCode() { return routingCode; }
    public void setRoutingCode(String routingCode) { this.routingCode = routingCode; }
    public String getResourceCode() { return resourceCode; }
    public void setResourceCode(String resourceCode) { this.resourceCode = resourceCode; }
    public BigDecimal getPlanQty() { return planQty; }
    public void setPlanQty(BigDecimal planQty) { this.planQty = planQty; }
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
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
