package com.ruoyi.mom.service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.mom.domain.MomOperation;
import com.ruoyi.mom.domain.MomSchedule;
import com.ruoyi.mom.domain.MomStepReport;
import com.ruoyi.mom.domain.MomWorkOrder;
import com.ruoyi.mom.domain.MomWorkStep;
import com.ruoyi.mom.mapper.MomProductionMapper;
import com.ruoyi.mom.mapper.MomWorkOrderMapper;

@Service
public class MomProductionService
{
    public static final String SCHEDULE_DRAFT = "draft";
    public static final String SCHEDULE_RELEASED = "released";
    public static final String SCHEDULE_RUNNING = "running";
    public static final String SCHEDULE_FINISHED = "finished";
    public static final String SCHEDULE_CANCELLED = "cancelled";

    @Autowired
    private MomProductionMapper mapper;

    @Autowired
    private MomWorkOrderMapper workOrderMapper;

    public List<MomSchedule> selectScheduleList(MomSchedule schedule) { return mapper.selectScheduleList(schedule); }
    public MomSchedule selectScheduleById(Long id) { return mapper.selectScheduleById(id); }

    public int insertSchedule(MomSchedule schedule)
    {
        validateSchedule(schedule, null);
        if (schedule.getStatus() == null) schedule.setStatus(SCHEDULE_DRAFT);
        if (schedule.getReportedQty() == null) schedule.setReportedQty(BigDecimal.ZERO);
        return mapper.insertSchedule(schedule);
    }

    public int updateSchedule(MomSchedule schedule)
    {
        MomSchedule old = requireSchedule(schedule.getScheduleId());
        ensure(SCHEDULE_DRAFT.equals(old.getStatus()) || SCHEDULE_RELEASED.equals(old.getStatus()), "只能修改草稿或已下达排产");
        validateSchedule(schedule, schedule.getScheduleId());
        return mapper.updateSchedule(schedule);
    }

    public int deleteScheduleByIds(Long[] ids)
    {
        for (Long id : ids)
        {
            MomSchedule schedule = requireSchedule(id);
            ensure(SCHEDULE_DRAFT.equals(schedule.getStatus()), "只能删除草稿排产");
        }
        return mapper.deleteScheduleByIds(ids);
    }

    public int releaseSchedule(Long id, String username)
    {
        MomSchedule schedule = requireSchedule(id);
        ensure(SCHEDULE_DRAFT.equals(schedule.getStatus()), "只有草稿排产可以下达");
        return mapper.updateScheduleStatus(id, SCHEDULE_RELEASED, username);
    }

    public int startSchedule(Long id, String username)
    {
        MomSchedule schedule = requireSchedule(id);
        ensure(SCHEDULE_RELEASED.equals(schedule.getStatus()), "只有已下达排产可以开工");
        MomWorkOrder order = workOrderMapper.selectWorkOrderById(schedule.getWorkOrderId());
        if (order != null && MomWorkOrderService.STATUS_RELEASED.equals(order.getStatus()))
        {
            workOrderMapper.startWorkOrder(order.getWorkOrderId(), username);
        }
        return mapper.updateScheduleStatus(id, SCHEDULE_RUNNING, username);
    }

    public int finishSchedule(Long id, String username)
    {
        MomSchedule schedule = requireSchedule(id);
        ensure(SCHEDULE_RUNNING.equals(schedule.getStatus()) || SCHEDULE_RELEASED.equals(schedule.getStatus()), "只有已下达或生产中排产可以完工");
        return mapper.updateScheduleStatus(id, SCHEDULE_FINISHED, username);
    }

    public int cancelSchedule(Long id, String username)
    {
        MomSchedule schedule = requireSchedule(id);
        ensure(!SCHEDULE_FINISHED.equals(schedule.getStatus()) && !SCHEDULE_CANCELLED.equals(schedule.getStatus()), "已完工或已取消排产不能取消");
        return mapper.updateScheduleStatus(id, SCHEDULE_CANCELLED, username);
    }

    public List<MomStepReport> selectReportList(MomStepReport report) { return mapper.selectReportList(report); }
    public MomStepReport selectReportById(Long id) { return mapper.selectReportById(id); }

    public int insertReport(MomStepReport report)
    {
        MomWorkOrder order = workOrderMapper.selectWorkOrderById(report.getWorkOrderId());
        ensure(order != null, "工单不存在");
        ensure(MomWorkOrderService.STATUS_RELEASED.equals(order.getStatus()) || MomWorkOrderService.STATUS_RUNNING.equals(order.getStatus()), "只有已下达或生产中工单可以报工");
        BigDecimal goodQty = report.getGoodQty() == null ? BigDecimal.ZERO : report.getGoodQty();
        BigDecimal badQty = report.getBadQty() == null ? BigDecimal.ZERO : report.getBadQty();
        ensure(goodQty.compareTo(BigDecimal.ZERO) >= 0 && badQty.compareTo(BigDecimal.ZERO) >= 0, "报工数量不能小于0");
        ensure(goodQty.add(badQty).compareTo(BigDecimal.ZERO) > 0, "报工数量必须大于0");
        BigDecimal completed = order.getCompletedQty() == null ? BigDecimal.ZERO : order.getCompletedQty();
        ensure(completed.add(goodQty).compareTo(order.getPlanQty()) <= 0, "合格数量累计不能大于工单计划数量");
        if (report.getReportTime() == null) report.setReportTime(new Date());
        if (report.getStatus() == null) report.setStatus("confirmed");
        int rows = mapper.insertReport(report);
        mapper.addWorkOrderCompletedQty(report.getWorkOrderId(), goodQty, report.getReportUser());
        if (report.getScheduleId() != null)
        {
            mapper.addScheduleReportedQty(report.getScheduleId(), goodQty, report.getReportUser());
        }
        MomWorkOrder refreshed = workOrderMapper.selectWorkOrderById(report.getWorkOrderId());
        if (refreshed != null && refreshed.getCompletedQty() != null && refreshed.getCompletedQty().compareTo(refreshed.getPlanQty()) >= 0)
        {
            workOrderMapper.finishWorkOrder(refreshed.getWorkOrderId(), refreshed.getCompletedQty(), report.getReportUser());
        }
        else if (MomWorkOrderService.STATUS_RELEASED.equals(order.getStatus()))
        {
            workOrderMapper.startWorkOrder(order.getWorkOrderId(), report.getReportUser());
        }
        return rows;
    }

    public int deleteReportByIds(Long[] ids) { return mapper.deleteReportByIds(ids); }
    public List<MomOperation> selectOperationsByWorkOrderId(Long workOrderId) { return mapper.selectOperationsByWorkOrderId(workOrderId); }
    public List<MomWorkStep> selectStepsByWorkOrderId(Long workOrderId) { return mapper.selectStepsByWorkOrderId(workOrderId); }

    private MomSchedule requireSchedule(Long id)
    {
        MomSchedule schedule = mapper.selectScheduleById(id);
        ensure(schedule != null, "排产记录不存在");
        return schedule;
    }

    private void validateSchedule(MomSchedule schedule, Long scheduleId)
    {
        ensure(mapper.countScheduleCode(schedule.getScheduleCode(), scheduleId) == 0, "排产编码已存在");
        ensure(schedule.getPlanStartTime() != null && schedule.getPlanEndTime() != null, "计划时间不能为空");
        ensure(schedule.getPlanEndTime().after(schedule.getPlanStartTime()), "计划结束必须晚于计划开始");
        ensure(schedule.getPlanQty() != null && schedule.getPlanQty().compareTo(BigDecimal.ZERO) > 0, "计划数量必须大于0");
        ensure(mapper.countResourceConflict(schedule.getResourceId(), schedule.getPlanStartTime(), schedule.getPlanEndTime(), scheduleId) == 0, "同一资源计划时间存在冲突");
    }

    private void ensure(boolean expression, String message)
    {
        if (!expression) throw new ServiceException(message);
    }
}
