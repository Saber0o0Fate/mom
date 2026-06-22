package com.ruoyi.mom.domain;

import java.math.BigDecimal;
import org.apache.poi.ss.usermodel.IndexedColors;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * PBOM物料导入行
 */
public class MomPbomImport extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "PBOM编码", sort = 1, headerBackgroundColor = IndexedColors.RED)
    private String pbomCode;

    @Excel(name = "PBOM名称", sort = 2, headerBackgroundColor = IndexedColors.RED)
    private String pbomName;

    @Excel(name = "成品物料编码", sort = 3, headerBackgroundColor = IndexedColors.RED)
    private String productCode;

    @Excel(name = "版本", sort = 4, defaultValue = "V1")
    private String version;

    @Excel(name = "状态", sort = 5, readConverterExp = "0=正常,1=停用", defaultValue = "0")
    private String status;

    @Excel(name = "行号", sort = 6, headerBackgroundColor = IndexedColors.RED)
    private Integer itemSeq;

    @Excel(name = "物料编码", sort = 7, headerBackgroundColor = IndexedColors.RED)
    private String materialCode;

    @Excel(name = "工位编码", sort = 8, headerBackgroundColor = IndexedColors.RED)
    private String resourceCode;

    @Excel(name = "数量", sort = 9, headerBackgroundColor = IndexedColors.RED)
    private BigDecimal quantity;

    @Excel(name = "备注", sort = 10)
    private String remark;

    public String getPbomCode() { return pbomCode; }
    public void setPbomCode(String pbomCode) { this.pbomCode = pbomCode; }
    public String getPbomName() { return pbomName; }
    public void setPbomName(String pbomName) { this.pbomName = pbomName; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getItemSeq() { return itemSeq; }
    public void setItemSeq(Integer itemSeq) { this.itemSeq = itemSeq; }
    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }
    public String getResourceCode() { return resourceCode; }
    public void setResourceCode(String resourceCode) { this.resourceCode = resourceCode; }
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
