package com.ruoyi.mom.domain;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM生产资源 mom_resource
 */
public class MomResource extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "资源ID")
    private Long resourceId;
    @Excel(name = "资源编码")
    private String resourceCode;
    @Excel(name = "资源名称")
    private String resourceName;
    @Excel(name = "资源类型")
    private String resourceType;
    @Excel(name = "上级资源")
    private Long parentId;
    @Excel(name = "车间")
    private String workshop;
    @Excel(name = "产线编码")
    private String lineCode;
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;
    @Excel(name = "是否报工备注", readConverterExp = "Y=是,N=否")
    private String stationNoteFlag;
    @Excel(name = "是否打印箱码", readConverterExp = "Y=是,N=否")
    private String printBoxFlag;
    @Excel(name = "是否打印铭牌", readConverterExp = "Y=是,N=否")
    private String printNameplateFlag;
    @Excel(name = "产线类型")
    private String lineType;
    @Excel(name = "工位类型")
    private String stationType;
    @Excel(name = "工位技能要求")
    private String skillRequire;
    @Excel(name = "在制品容量")
    private Integer wipCapacity;

    public Long getResourceId() { return resourceId; }
    public void setResourceId(Long resourceId) { this.resourceId = resourceId; }

    @Size(max = 64, message = "资源编码长度不能超过64个字符")
    public String getResourceCode() { return resourceCode; }
    public void setResourceCode(String resourceCode) { this.resourceCode = resourceCode; }

    @NotBlank(message = "资源名称不能为空")
    @Size(max = 100, message = "资源名称长度不能超过100个字符")
    public String getResourceName() { return resourceName; }
    public void setResourceName(String resourceName) { this.resourceName = resourceName; }
    public String getResourceType() { return resourceType; }
    public void setResourceType(String resourceType) { this.resourceType = resourceType; }
    public Long getParentId() { return parentId; }
    public void setParentId(Long parentId) { this.parentId = parentId; }
    public String getWorkshop() { return workshop; }
    public void setWorkshop(String workshop) { this.workshop = workshop; }
    public String getLineCode() { return lineCode; }
    public void setLineCode(String lineCode) { this.lineCode = lineCode; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getStationNoteFlag() { return stationNoteFlag; }
    public void setStationNoteFlag(String stationNoteFlag) { this.stationNoteFlag = stationNoteFlag; }
    public String getPrintBoxFlag() { return printBoxFlag; }
    public void setPrintBoxFlag(String printBoxFlag) { this.printBoxFlag = printBoxFlag; }
    public String getPrintNameplateFlag() { return printNameplateFlag; }
    public void setPrintNameplateFlag(String printNameplateFlag) { this.printNameplateFlag = printNameplateFlag; }
    public String getLineType() { return lineType; }
    public void setLineType(String lineType) { this.lineType = lineType; }
    public String getStationType() { return stationType; }
    public void setStationType(String stationType) { this.stationType = stationType; }
    public String getSkillRequire() { return skillRequire; }
    public void setSkillRequire(String skillRequire) { this.skillRequire = skillRequire; }
    public Integer getWipCapacity() { return wipCapacity; }
    public void setWipCapacity(Integer wipCapacity) { this.wipCapacity = wipCapacity; }
}
