package com.ruoyi.mom.domain;

import java.math.BigDecimal;
import java.util.List;
import jakarta.validation.constraints.NotNull;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM制造BOM明细 mom_mbom_item
 */
public class MomMbomItem extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "明细ID")
    private Long itemId;

    @Excel(name = "MBOM ID")
    private Long mbomId;

    @Excel(name = "上级明细ID")
    private Long parentItemId;

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

    @Excel(name = "行号")
    private Integer itemSeq;

    @Excel(name = "用量")
    private BigDecimal quantity;

    @Excel(name = "损耗率")
    private BigDecimal scrapRate;

    @Excel(name = "工序ID")
    private Long operationId;

    @Excel(name = "工序编码")
    private String operationCode;

    @Excel(name = "工步ID")
    private Long stepId;

    @Excel(name = "工步编码")
    private String stepCode;

    @Excel(name = "投料方式")
    private String issueType;

    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    private List<MomMbomItem> children;

    public Long getItemId() { return itemId; }
    public void setItemId(Long itemId) { this.itemId = itemId; }

    @NotNull(message = "MBOM不能为空")
    public Long getMbomId() { return mbomId; }
    public void setMbomId(Long mbomId) { this.mbomId = mbomId; }

    public Long getParentItemId() { return parentItemId; }
    public void setParentItemId(Long parentItemId) { this.parentItemId = parentItemId; }

    @NotNull(message = "物料不能为空")
    public Long getMaterialId() { return materialId; }
    public void setMaterialId(Long materialId) { this.materialId = materialId; }

    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }
    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }
    public String getSpecModel() { return specModel; }
    public void setSpecModel(String specModel) { this.specModel = specModel; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    @NotNull(message = "行号不能为空")
    public Integer getItemSeq() { return itemSeq; }
    public void setItemSeq(Integer itemSeq) { this.itemSeq = itemSeq; }

    @NotNull(message = "用量不能为空")
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }

    public BigDecimal getScrapRate() { return scrapRate; }
    public void setScrapRate(BigDecimal scrapRate) { this.scrapRate = scrapRate; }
    public Long getOperationId() { return operationId; }
    public void setOperationId(Long operationId) { this.operationId = operationId; }
    public String getOperationCode() { return operationCode; }
    public void setOperationCode(String operationCode) { this.operationCode = operationCode; }
    public Long getStepId() { return stepId; }
    public void setStepId(Long stepId) { this.stepId = stepId; }
    public String getStepCode() { return stepCode; }
    public void setStepCode(String stepCode) { this.stepCode = stepCode; }
    public String getIssueType() { return issueType; }
    public void setIssueType(String issueType) { this.issueType = issueType; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public List<MomMbomItem> getChildren() { return children; }
    public void setChildren(List<MomMbomItem> children) { this.children = children; }
}
