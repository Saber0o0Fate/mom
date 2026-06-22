package com.ruoyi.mom.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MOM班次日历 mom_shift_calendar
 */
public class MomShiftCalendar extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "日历ID")
    private Long calendarId;
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "日期", dateFormat = "yyyy-MM-dd")
    private Date calendarDate;
    @Excel(name = "班次编码")
    private String shiftCode;
    @Excel(name = "班次名称")
    private String shiftName;
    @Excel(name = "开始时间")
    private String startTime;
    @Excel(name = "结束时间")
    private String endTime;
    @Excel(name = "是否工作日", readConverterExp = "Y=是,N=否")
    private String isWorkday;
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    public Long getCalendarId() { return calendarId; }
    public void setCalendarId(Long calendarId) { this.calendarId = calendarId; }
    @NotNull(message = "日历日期不能为空")
    public Date getCalendarDate() { return calendarDate; }
    public void setCalendarDate(Date calendarDate) { this.calendarDate = calendarDate; }
    @NotBlank(message = "班次编码不能为空")
    public String getShiftCode() { return shiftCode; }
    public void setShiftCode(String shiftCode) { this.shiftCode = shiftCode; }
    @NotBlank(message = "班次名称不能为空")
    public String getShiftName() { return shiftName; }
    public void setShiftName(String shiftName) { this.shiftName = shiftName; }
    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }
    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }
    public String getIsWorkday() { return isWorkday; }
    public void setIsWorkday(String isWorkday) { this.isWorkday = isWorkday; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
