package com.ruoyi.mom.mapper;

import java.math.BigDecimal;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.mom.domain.MomOperation;
import com.ruoyi.mom.domain.MomSchedule;
import com.ruoyi.mom.domain.MomStepReport;
import com.ruoyi.mom.domain.MomWorkStep;

public interface MomProductionMapper
{
    public List<MomSchedule> selectScheduleList(MomSchedule schedule);
    public MomSchedule selectScheduleById(Long scheduleId);
    public int countScheduleCode(@Param("scheduleCode") String scheduleCode, @Param("scheduleId") Long scheduleId);
    public int countResourceConflict(@Param("resourceId") Long resourceId, @Param("planStartTime") java.util.Date planStartTime, @Param("planEndTime") java.util.Date planEndTime, @Param("scheduleId") Long scheduleId);
    public int insertSchedule(MomSchedule schedule);
    public int updateSchedule(MomSchedule schedule);
    public int deleteScheduleByIds(Long[] scheduleIds);
    public int updateScheduleStatus(@Param("scheduleId") Long scheduleId, @Param("status") String status, @Param("updateBy") String updateBy);
    public int addScheduleReportedQty(@Param("scheduleId") Long scheduleId, @Param("qty") BigDecimal qty, @Param("updateBy") String updateBy);

    public List<MomStepReport> selectReportList(MomStepReport report);
    public MomStepReport selectReportById(Long reportId);
    public int insertReport(MomStepReport report);
    public int deleteReportByIds(Long[] reportIds);
    public int addWorkOrderCompletedQty(@Param("workOrderId") Long workOrderId, @Param("qty") BigDecimal qty, @Param("updateBy") String updateBy);
    public List<MomOperation> selectOperationsByWorkOrderId(Long workOrderId);
    public List<MomWorkStep> selectStepsByWorkOrderId(Long workOrderId);
}
