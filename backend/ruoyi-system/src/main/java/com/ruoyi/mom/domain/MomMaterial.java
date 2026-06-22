package com.ruoyi.mom.domain;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM物料档案 mom_material
 */
public class MomMaterial extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "物料ID")
    private Long materialId;

    @Excel(name = "物料编码")
    private String materialCode;

    @Excel(name = "物料名称")
    private String materialName;

    @Excel(name = "规格型号")
    private String specModel;

    @Excel(name = "单位")
    private String unit;

    @Excel(name = "物料分类")
    private String categoryName;

    private Long categoryId;

    @Excel(name = "物料类型")
    private String materialType;

    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    public Long getMaterialId()
    {
        return materialId;
    }

    public void setMaterialId(Long materialId)
    {
        this.materialId = materialId;
    }

    @NotBlank(message = "物料编码不能为空")
    @Size(max = 64, message = "物料编码长度不能超过64个字符")
    public String getMaterialCode()
    {
        return materialCode;
    }

    public void setMaterialCode(String materialCode)
    {
        this.materialCode = materialCode;
    }

    @NotBlank(message = "物料名称不能为空")
    @Size(max = 100, message = "物料名称长度不能超过100个字符")
    public String getMaterialName()
    {
        return materialName;
    }

    public void setMaterialName(String materialName)
    {
        this.materialName = materialName;
    }

    public String getSpecModel()
    {
        return specModel;
    }

    public void setSpecModel(String specModel)
    {
        this.specModel = specModel;
    }

    public String getUnit()
    {
        return unit;
    }

    public void setUnit(String unit)
    {
        this.unit = unit;
    }

    public String getCategoryName()
    {
        return categoryName;
    }

    public void setCategoryName(String categoryName)
    {
        this.categoryName = categoryName;
    }

    @NotNull(message = "物料分类不能为空")
    public Long getCategoryId()
    {
        return categoryId;
    }

    public void setCategoryId(Long categoryId)
    {
        this.categoryId = categoryId;
    }

    public String getMaterialType()
    {
        return materialType;
    }

    public void setMaterialType(String materialType)
    {
        this.materialType = materialType;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }
}
