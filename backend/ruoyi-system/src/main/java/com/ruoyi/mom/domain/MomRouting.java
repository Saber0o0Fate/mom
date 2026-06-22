package com.ruoyi.mom.domain;

import java.util.List;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM工艺路线 mom_routing
 */
public class MomRouting extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "路线ID")
    private Long routingId;
    @Excel(name = "路线编码")
    private String routingCode;
    @Excel(name = "路线名称")
    private String routingName;
    @Excel(name = "产品ID")
    private Long productId;
    @Excel(name = "产品编码")
    private String productCode;
    @Excel(name = "产品名称")
    private String productName;
    @Excel(name = "版本")
    private String version;
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;
    private List<MomOperation> operations;

    public Long getRoutingId() { return routingId; }
    public void setRoutingId(Long routingId) { this.routingId = routingId; }
    public String getRoutingCode() { return routingCode; }
    public void setRoutingCode(String routingCode) { this.routingCode = routingCode; }
    @NotBlank(message = "路线名称不能为空")
    public String getRoutingName() { return routingName; }
    public void setRoutingName(String routingName) { this.routingName = routingName; }
    @NotNull(message = "产品不能为空")
    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    @NotBlank(message = "版本不能为空")
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<MomOperation> getOperations() { return operations; }
    public void setOperations(List<MomOperation> operations) { this.operations = operations; }
}
