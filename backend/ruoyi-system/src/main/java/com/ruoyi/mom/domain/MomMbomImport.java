package com.ruoyi.mom.domain;

import java.math.BigDecimal;
import org.apache.poi.ss.usermodel.IndexedColors;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MBOM工步投料导入行
 */
public class MomMbomImport extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "MBOM编码", sort = 1, headerBackgroundColor = IndexedColors.RED)
    private String mbomCode;

    @Excel(name = "MBOM名称", sort = 2, headerBackgroundColor = IndexedColors.RED)
    private String mbomName;

    @Excel(name = "成品物料编码", sort = 3, headerBackgroundColor = IndexedColors.RED)
    private String productCode;

    @Excel(name = "版本", sort = 4, defaultValue = "V1")
    private String version;

    @Excel(name = "状态", sort = 5, readConverterExp = "0=正常,1=停用", defaultValue = "0")
    private String status;

    @Excel(name = "工序编码", sort = 6, headerBackgroundColor = IndexedColors.RED)
    private String operationCode;

    @Excel(name = "工步编码", sort = 7, headerBackgroundColor = IndexedColors.RED)
    private String stepCode;

    @Excel(name = "行号", sort = 8, headerBackgroundColor = IndexedColors.RED)
    private Integer itemSeq;

    @Excel(name = "投料物料编码", sort = 9, headerBackgroundColor = IndexedColors.RED)
    private String materialCode;

    @Excel(name = "用量", sort = 10, headerBackgroundColor = IndexedColors.RED)
    private BigDecimal quantity;

    @Excel(name = "损耗率", sort = 11)
    private BigDecimal scrapRate;

    @Excel(name = "投料方式", sort = 12, defaultValue = "order")
    private String issueType;

    @Excel(name = "备注", sort = 13)
    private String remark;

    public String getMbomCode() { return mbomCode; }
    public void setMbomCode(String mbomCode) { this.mbomCode = mbomCode; }
    public String getMbomName() { return mbomName; }
    public void setMbomName(String mbomName) { this.mbomName = mbomName; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getOperationCode() { return operationCode; }
    public void setOperationCode(String operationCode) { this.operationCode = operationCode; }
    public String getStepCode() { return stepCode; }
    public void setStepCode(String stepCode) { this.stepCode = stepCode; }
    public Integer getItemSeq() { return itemSeq; }
    public void setItemSeq(Integer itemSeq) { this.itemSeq = itemSeq; }
    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }
    public BigDecimal getScrapRate() { return scrapRate; }
    public void setScrapRate(BigDecimal scrapRate) { this.scrapRate = scrapRate; }
    public String getIssueType() { return issueType; }
    public void setIssueType(String issueType) { this.issueType = issueType; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
