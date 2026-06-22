package com.ruoyi.mom.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.mom.domain.MomWorkOrder;

/**
 * MOM生产工单 Mapper
 */
public interface MomWorkOrderMapper
{
    public List<MomWorkOrder> selectWorkOrderList(MomWorkOrder workOrder);
    public MomWorkOrder selectWorkOrderById(Long workOrderId);
    public MomWorkOrder selectWorkOrderByCode(String workOrderCode);
    public int countWorkOrderCode(@Param("workOrderCode") String workOrderCode, @Param("workOrderId") Long workOrderId);
    public int insertWorkOrder(MomWorkOrder workOrder);
    public int updateWorkOrder(MomWorkOrder workOrder);
    public int deleteWorkOrderByIds(Long[] workOrderIds);
    public int updateWorkOrderStatus(@Param("workOrderId") Long workOrderId, @Param("status") String status, @Param("updateBy") String updateBy);
    public int startWorkOrder(@Param("workOrderId") Long workOrderId, @Param("updateBy") String updateBy);
    public int finishWorkOrder(@Param("workOrderId") Long workOrderId, @Param("completedQty") java.math.BigDecimal completedQty, @Param("updateBy") String updateBy);
}
