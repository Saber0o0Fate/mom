package com.ruoyi.mom.domain;

import java.util.List;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM工序 mom_operation
 */
public class MomOperation extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "工序ID")
    private Long operationId;
    @Excel(name = "路线ID")
    private Long routingId;
    @Excel(name = "路线编码")
    private String routingCode;
    @Excel(name = "工序编码")
    private String operationCode;
    @Excel(name = "工序名称")
    private String operationName;
    @Excel(name = "工序顺序")
    private Integer operationSeq;
    @Excel(name = "标准工时")
    private Integer standardMinutes;
    @Excel(name = "资源类型")
    private String resourceType;
    private Long resourceId;
    @Excel(name = "工位编码")
    private String resourceCode;
    @Excel(name = "工位名称")
    private String resourceName;
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;
    private List<MomWorkStep> steps;

    public Long getOperationId() { return operationId; }
    public void setOperationId(Long operationId) { this.operationId = operationId; }
    @NotNull(message = "工艺路线不能为空")
    public Long getRoutingId() { return routingId; }
    public void setRoutingId(Long routingId) { this.routingId = routingId; }
    public String getRoutingCode() { return routingCode; }
    public void setRoutingCode(String routingCode) { this.routingCode = routingCode; }
    public String getOperationCode() { return operationCode; }
    public void setOperationCode(String operationCode) { this.operationCode = operationCode; }
    @NotBlank(message = "工序名称不能为空")
    public String getOperationName() { return operationName; }
    public void setOperationName(String operationName) { this.operationName = operationName; }
    @NotNull(message = "工序顺序不能为空")
    public Integer getOperationSeq() { return operationSeq; }
    public void setOperationSeq(Integer operationSeq) { this.operationSeq = operationSeq; }
    public Integer getStandardMinutes() { return standardMinutes; }
    public void setStandardMinutes(Integer standardMinutes) { this.standardMinutes = standardMinutes; }
    public String getResourceType() { return resourceType; }
    public void setResourceType(String resourceType) { this.resourceType = resourceType; }
    public Long getResourceId() { return resourceId; }
    public void setResourceId(Long resourceId) { this.resourceId = resourceId; }
    public String getResourceCode() { return resourceCode; }
    public void setResourceCode(String resourceCode) { this.resourceCode = resourceCode; }
    public String getResourceName() { return resourceName; }
    public void setResourceName(String resourceName) { this.resourceName = resourceName; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<MomWorkStep> getSteps() { return steps; }
    public void setSteps(List<MomWorkStep> steps) { this.steps = steps; }
}
