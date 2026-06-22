package com.ruoyi.mom.domain;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM产品档案 mom_product
 */
public class MomProduct extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "产品ID")
    private Long productId;

    @Excel(name = "产品编码")
    private String productCode;

    @Excel(name = "产品名称")
    private String productName;

    @Excel(name = "关联物料ID")
    private Long materialId;

    @Excel(name = "关联物料编码")
    private String materialCode;

    @Excel(name = "规格型号")
    private String specModel;

    @Excel(name = "单位")
    private String unit;

    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    @NotBlank(message = "产品编码不能为空")
    @Size(max = 64, message = "产品编码长度不能超过64个字符")
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    @NotBlank(message = "产品名称不能为空")
    @Size(max = 100, message = "产品名称长度不能超过100个字符")
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public Long getMaterialId() { return materialId; }
    public void setMaterialId(Long materialId) { this.materialId = materialId; }
    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }
    public String getSpecModel() { return specModel; }
    public void setSpecModel(String specModel) { this.specModel = specModel; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
