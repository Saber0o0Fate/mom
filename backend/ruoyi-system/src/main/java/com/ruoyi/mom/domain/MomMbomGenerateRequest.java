package com.ruoyi.mom.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * MBOM按PBOM和工艺路线自动生成请求
 */
public class MomMbomGenerateRequest
{
    @NotBlank(message = "MBOM编码不能为空")
    private String mbomCode;

    @NotBlank(message = "MBOM名称不能为空")
    private String mbomName;

    @NotNull(message = "关联PBOM不能为空")
    private Long pbomId;

    @NotNull(message = "工艺路线不能为空")
    private Long routingId;

    private Long productId;
    private String version;
    private String status;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date effectiveDate;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date expireDate;

    private String remark;
    private Boolean updateSupport;

    public String getMbomCode() { return mbomCode; }
    public void setMbomCode(String mbomCode) { this.mbomCode = mbomCode; }
    public String getMbomName() { return mbomName; }
    public void setMbomName(String mbomName) { this.mbomName = mbomName; }
    public Long getPbomId() { return pbomId; }
    public void setPbomId(Long pbomId) { this.pbomId = pbomId; }
    public Long getRoutingId() { return routingId; }
    public void setRoutingId(Long routingId) { this.routingId = routingId; }
    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }
    public String getVersion() { return version; }
    public void setVersion(String version) { this.version = version; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getEffectiveDate() { return effectiveDate; }
    public void setEffectiveDate(Date effectiveDate) { this.effectiveDate = effectiveDate; }
    public Date getExpireDate() { return expireDate; }
    public void setExpireDate(Date expireDate) { this.expireDate = expireDate; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public Boolean getUpdateSupport() { return updateSupport; }
    public void setUpdateSupport(Boolean updateSupport) { this.updateSupport = updateSupport; }
}
