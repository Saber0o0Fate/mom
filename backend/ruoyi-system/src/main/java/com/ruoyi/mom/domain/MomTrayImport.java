package com.ruoyi.mom.domain;

import java.math.BigDecimal;
import org.apache.poi.ss.usermodel.IndexedColors;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 形迹托盘导入导出行
 */
public class MomTrayImport extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "托盘编码", sort = 1, headerBackgroundColor = IndexedColors.RED)
    private String trayCode;

    @Excel(name = "托盘名称", sort = 2)
    private String trayName;

    @Excel(name = "工位编码", sort = 3)
    private String resourceCode;

    @Excel(name = "状态", sort = 4, readConverterExp = "0=正常,1=停用", defaultValue = "0")
    private String status;

    @Excel(name = "托盘位", sort = 5, headerBackgroundColor = IndexedColors.RED)
    private String locationCode;

    @Excel(name = "物料编码", sort = 6, headerBackgroundColor = IndexedColors.RED)
    private String materialCode;

    @Excel(name = "物料名称", sort = 7)
    private String materialName;

    @Excel(name = "数量", sort = 8, headerBackgroundColor = IndexedColors.RED)
    private BigDecimal quantity;

    @Excel(name = "备注", sort = 9)
    private String remark;

    public String getTrayCode() { return trayCode; }
    public void setTrayCode(String trayCode) { this.trayCode = trayCode; }
    public String getTrayName() { return trayName; }
    public void setTrayName(String trayName) { this.trayName = trayName; }
    public String getResourceCode() { return resourceCode; }
    public void setResourceCode(String resourceCode) { this.resourceCode = resourceCode; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getLocationCode() { return locationCode; }
    public void setLocationCode(String locationCode) { this.locationCode = locationCode; }
    public String getMaterialCode() { return materialCode; }
    public void setMaterialCode(String materialCode) { this.materialCode = materialCode; }
    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
