package com.ruoyi.mom.domain;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM工步 mom_work_step
 */
public class MomWorkStep extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "工步ID")
    private Long stepId;
    @Excel(name = "工序ID")
    private Long operationId;
    @Excel(name = "工序编码")
    private String operationCode;
    @Excel(name = "工步编码")
    private String stepCode;
    @Excel(name = "工步名称")
    private String stepName;
    @Excel(name = "工步顺序")
    private Integer stepSeq;
    @Excel(name = "标准工时")
    private Integer standardMinutes;
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
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    public Long getStepId() { return stepId; }
    public void setStepId(Long stepId) { this.stepId = stepId; }
    @NotNull(message = "工序不能为空")
    public Long getOperationId() { return operationId; }
    public void setOperationId(Long operationId) { this.operationId = operationId; }
    public String getOperationCode() { return operationCode; }
    public void setOperationCode(String operationCode) { this.operationCode = operationCode; }
    public String getStepCode() { return stepCode; }
    public void setStepCode(String stepCode) { this.stepCode = stepCode; }
    @NotBlank(message = "工步名称不能为空")
    public String getStepName() { return stepName; }
    public void setStepName(String stepName) { this.stepName = stepName; }
    @NotNull(message = "工步顺序不能为空")
    public Integer getStepSeq() { return stepSeq; }
    public void setStepSeq(Integer stepSeq) { this.stepSeq = stepSeq; }
    public Integer getStandardMinutes() { return standardMinutes; }
    public void setStandardMinutes(Integer standardMinutes) { this.standardMinutes = standardMinutes; }
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
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
