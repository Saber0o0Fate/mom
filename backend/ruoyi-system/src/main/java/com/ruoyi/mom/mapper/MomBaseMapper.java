package com.ruoyi.mom.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.mom.domain.MomMaterial;
import com.ruoyi.mom.domain.MomMaterialCategory;
import com.ruoyi.mom.domain.MomOperation;
import com.ruoyi.mom.domain.MomProduct;
import com.ruoyi.mom.domain.MomResource;
import com.ruoyi.mom.domain.MomRouting;
import com.ruoyi.mom.domain.MomShiftCalendar;
import com.ruoyi.mom.domain.MomWorkStep;

/**
 * MOM基础数据Mapper
 */
public interface MomBaseMapper
{
    public List<MomMaterialCategory> selectMaterialCategoryList(MomMaterialCategory category);
    public MomMaterialCategory selectMaterialCategoryById(Long categoryId);
    public MomMaterialCategory selectMaterialCategoryByCode(@Param("categoryCode") String categoryCode);
    public MomMaterialCategory selectMaterialCategoryByName(@Param("categoryName") String categoryName);
    public int countMaterialCategoryCode(@Param("categoryCode") String categoryCode, @Param("categoryId") Long categoryId);
    public int insertMaterialCategory(MomMaterialCategory category);
    public int updateMaterialCategory(MomMaterialCategory category);
    public int deleteMaterialCategoryByIds(Long[] categoryIds);
    public int countMaterialByCategoryIds(Long[] categoryIds);

    public List<MomMaterial> selectMaterialList(MomMaterial material);
    public List<MomMaterial> selectMaterialAll();
    public MomMaterial selectMaterialById(Long materialId);
    public MomMaterial selectMaterialByCode(@Param("materialCode") String materialCode);
    public int countMaterialCode(@Param("materialCode") String materialCode, @Param("materialId") Long materialId);
    public int insertMaterial(MomMaterial material);
    public int updateMaterial(MomMaterial material);
    public int deleteMaterialByIds(Long[] materialIds);

    public List<MomProduct> selectProductList(MomProduct product);
    public List<MomProduct> selectProductAll();
    public MomProduct selectProductById(Long productId);
    public MomProduct selectProductByCode(@Param("productCode") String productCode);
    public int countProductCode(@Param("productCode") String productCode, @Param("productId") Long productId);
    public int insertProduct(MomProduct product);
    public int updateProduct(MomProduct product);
    public int deleteProductByIds(Long[] productIds);

    public List<MomResource> selectResourceList(MomResource resource);
    public List<MomResource> selectResourceAll();
    public MomResource selectResourceById(Long resourceId);
    public MomResource selectResourceByCode(@Param("resourceCode") String resourceCode);
    public int countResourceCode(@Param("resourceCode") String resourceCode, @Param("resourceId") Long resourceId);
    public int insertResource(MomResource resource);
    public int updateResource(MomResource resource);
    public int deleteResourceByIds(Long[] resourceIds);

    public List<MomShiftCalendar> selectCalendarList(MomShiftCalendar calendar);
    public MomShiftCalendar selectCalendarById(Long calendarId);
    public int countCalendarShift(@Param("calendarDate") java.util.Date calendarDate, @Param("shiftCode") String shiftCode, @Param("calendarId") Long calendarId);
    public int insertCalendar(MomShiftCalendar calendar);
    public int updateCalendar(MomShiftCalendar calendar);
    public int deleteCalendarByIds(Long[] calendarIds);

    public List<MomRouting> selectRoutingList(MomRouting routing);
    public MomRouting selectRoutingById(Long routingId);
    public MomRouting selectRoutingByCode(@Param("routingCode") String routingCode);
    public int countRoutingCode(@Param("routingCode") String routingCode, @Param("routingId") Long routingId);
    public int countRoutingVersion(@Param("productId") Long productId, @Param("version") String version, @Param("routingId") Long routingId);
    public int insertRouting(MomRouting routing);
    public int updateRouting(MomRouting routing);
    public int deleteRoutingByIds(Long[] routingIds);

    public List<MomOperation> selectOperationList(MomOperation operation);
    public MomOperation selectOperationById(Long operationId);
    public int countOperationCode(@Param("routingId") Long routingId, @Param("operationCode") String operationCode, @Param("operationId") Long operationId);
    public int countOperationSeq(@Param("routingId") Long routingId, @Param("operationSeq") Integer operationSeq, @Param("operationId") Long operationId);
    public int insertOperation(MomOperation operation);
    public int updateOperation(MomOperation operation);
    public int deleteOperationByIds(Long[] operationIds);
    public int deleteOperationByRoutingIds(Long[] routingIds);

    public List<MomWorkStep> selectStepList(MomWorkStep step);
    public MomWorkStep selectStepById(Long stepId);
    public int countStepCode(@Param("operationId") Long operationId, @Param("stepCode") String stepCode, @Param("stepId") Long stepId);
    public int countStepSeq(@Param("operationId") Long operationId, @Param("stepSeq") Integer stepSeq, @Param("stepId") Long stepId);
    public int insertStep(MomWorkStep step);
    public int updateStep(MomWorkStep step);
    public int deleteStepByIds(Long[] stepIds);
    public int deleteStepByOperationIds(Long[] operationIds);
    public int deleteStepByRoutingIds(Long[] routingIds);
}
