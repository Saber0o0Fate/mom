package com.ruoyi.mom.domain;

import org.apache.poi.ss.usermodel.IndexedColors;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 工艺路线按工步导入数据
 */
public class MomRoutingStepImport extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "路线编码")
    private String routingCode;
    @Excel(name = "路线名称", headerBackgroundColor = IndexedColors.RED)
    private String routingName;
    @Excel(name = "成品物料编码", headerBackgroundColor = IndexedColors.RED)
    private String productCode;
    @Excel(name = "产品编码", type = Excel.Type.IMPORT)
    private String legacyProductCode;
    @Excel(name = "版本")
    private String version;
    @Excel(name = "路线状态", readConverterExp = "0=正常,1=停用")
    private String routingStatus;
    @Excel(name = "路线备注")
    private String routingRemark;

    @Excel(name = "工序编码")
    private String operationCode;
    @Excel(name = "工序名称", headerBackgroundColor = IndexedColors.RED)
    private String operationName;
    @Excel(name = "工序顺序")
    private Integer operationSeq;
    @Excel(name = "工序标准分钟")
    private Integer operationStandardMinutes;
    @Excel(name = "资源类型")
    private String resourceType;
    @Excel(name = "工位编码", headerBackgroundColor = IndexedColors.RED)
    private String resourceCode;
    @Excel(name = "工序备注")
    private String operationRemark;

    @Excel(name = "工步编码")
    private String stepCode;
    @Excel(name = "工步名称", headerBackgroundColor = IndexedColors.RED)
    private String stepName;
    @Excel(name = "工步顺序")
    private Integer stepSeq;
    @Excel(name = "工步标准分钟")
    private Integer stepStandardMinutes;
    @Excel(name = "是否报工点", readConverterExp = "Y=是,N=否")
    private String isReportPoint;
    @Excel(name = "作业指导")
    private String stepDesc;
    @Excel(name = "作业类型")
    private String operationType;
    @Excel(name = "螺孔检测次数")
    private Integer screwCheckCount;
    @Excel(name = "2D视觉程序")
    private String visionProgram;
    @Excel(name = "指引软件ID")
    private String guideTaskId;
    @Excel(name = "图片地址")
    private String imageUrl;
    @Excel(name = "工步状态", readConverterExp = "0=正常,1=停用")
    private String stepStatus;
    @Excel(name = "工步备注")
    private String stepRemark;

    public String getRoutingCode() { return routingCode; }
    public void setRoutingCode(String routingCode) { this.routingCode = routingCode; }
    public String getRoutingName() { return routingName; }
    public void setRoutingName(String routingName) { this.routingName = routingName; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public String getLegacyProductCode() { return legacyProductCode; }
    public void setLegacyProductCode(String legacyProductCode) { this.legacyProductCode = legacyProductCode; }
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getRoutingStatus() { return routingStatus; }
    public void setRoutingStatus(String routingStatus) { this.routingStatus = routingStatus; }
    public String getRoutingRemark() { return routingRemark; }
    public void setRoutingRemark(String routingRemark) { this.routingRemark = routingRemark; }
    public String getOperationCode() { return operationCode; }
    public void setOperationCode(String operationCode) { this.operationCode = operationCode; }
    public String getOperationName() { return operationName; }
    public void setOperationName(String operationName) { this.operationName = operationName; }
    public Integer getOperationSeq() { return operationSeq; }
    public void setOperationSeq(Integer operationSeq) { this.operationSeq = operationSeq; }
    public Integer getOperationStandardMinutes() { return operationStandardMinutes; }
    public void setOperationStandardMinutes(Integer operationStandardMinutes) { this.operationStandardMinutes = operationStandardMinutes; }
    public String getResourceType() { return resourceType; }
    public void setResourceType(String resourceType) { this.resourceType = resourceType; }
    public String getResourceCode() { return resourceCode; }
    public void setResourceCode(String resourceCode) { this.resourceCode = resourceCode; }
    public String getOperationRemark() { return operationRemark; }
    public void setOperationRemark(String operationRemark) { this.operationRemark = operationRemark; }
    public String getStepCode() { return stepCode; }
    public void setStepCode(String stepCode) { this.stepCode = stepCode; }
    public String getStepName() { return stepName; }
    public void setStepName(String stepName) { this.stepName = stepName; }
    public Integer getStepSeq() { return stepSeq; }
    public void setStepSeq(Integer stepSeq) { this.stepSeq = stepSeq; }
    public Integer getStepStandardMinutes() { return stepStandardMinutes; }
    public void setStepStandardMinutes(Integer stepStandardMinutes) { this.stepStandardMinutes = stepStandardMinutes; }
    public String getIsReportPoint() { return isReportPoint; }
    public void setIsReportPoint(String isReportPoint) { this.isReportPoint = isReportPoint; }
    public String getStepDesc() { return stepDesc; }
    public void setStepDesc(String stepDesc) { this.stepDesc = stepDesc; }
    public String getOperationType() { return operationType; }
    public void setOperationType(String operationType) { this.operationType = operationType; }
    public Integer getScrewCheckCount() { return screwCheckCount; }
    public void setScrewCheckCount(Integer screwCheckCount) { this.screwCheckCount = screwCheckCount; }
    public String getVisionProgram() { return visionProgram; }
    public void setVisionProgram(String visionProgram) { this.visionProgram = visionProgram; }
    public String getGuideTaskId() { return guideTaskId; }
    public void setGuideTaskId(String guideTaskId) { this.guideTaskId = guideTaskId; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getStepStatus() { return stepStatus; }
    public void setStepStatus(String stepStatus) { this.stepStatus = stepStatus; }
    public String getStepRemark() { return stepRemark; }
    public void setStepRemark(String stepRemark) { this.stepRemark = stepRemark; }
}
