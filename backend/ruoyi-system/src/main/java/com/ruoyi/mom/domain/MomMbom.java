package com.ruoyi.mom.domain;

import java.util.Date;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM制造BOM mom_mbom
 */
public class MomMbom extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "MBOM ID")
    private Long mbomId;

    @Excel(name = "MBOM编码")
    private String mbomCode;

    @Excel(name = "MBOM名称")
    private String mbomName;

    @Excel(name = "产品ID")
    private Long productId;

    @Excel(name = "产品编码")
    private String productCode;

    @Excel(name = "产品名称")
    private String productName;

    @Excel(name = "版本")
    private String version;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "生效日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date effectiveDate;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "失效日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date expireDate;

    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    private List<MomMbomItem> items;

    public Long getMbomId() { return mbomId; }
    public void setMbomId(Long mbomId) { this.mbomId = mbomId; }

    @NotBlank(message = "MBOM编码不能为空")
    public String getMbomCode() { return mbomCode; }
    public void setMbomCode(String mbomCode) { this.mbomCode = mbomCode; }

    @NotBlank(message = "MBOM名称不能为空")
    public String getMbomName() { return mbomName; }
    public void setMbomName(String mbomName) { this.mbomName = mbomName; }

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

    public Date getEffectiveDate() { return effectiveDate; }
    public void setEffectiveDate(Date effectiveDate) { this.effectiveDate = effectiveDate; }
    public Date getExpireDate() { return expireDate; }
    public void setExpireDate(Date expireDate) { this.expireDate = expireDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<MomMbomItem> getItems() { return items; }
    public void setItems(List<MomMbomItem> items) { this.items = items; }
}
