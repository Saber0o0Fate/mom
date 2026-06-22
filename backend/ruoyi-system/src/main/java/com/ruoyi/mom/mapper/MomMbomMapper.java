package com.ruoyi.mom.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.mom.domain.MomMbom;
import com.ruoyi.mom.domain.MomMbomItem;

/**
 * MOM制造BOM Mapper
 */
public interface MomMbomMapper
{
    public List<MomMbom> selectMbomList(MomMbom mbom);
    public MomMbom selectMbomById(Long mbomId);
    public MomMbom selectMbomByCode(String mbomCode);
    public int countMbomCode(@Param("mbomCode") String mbomCode, @Param("mbomId") Long mbomId);
    public int countMbomVersion(@Param("productId") Long productId, @Param("version") String version, @Param("mbomId") Long mbomId);
    public int insertMbom(MomMbom mbom);
    public int updateMbom(MomMbom mbom);
    public int deleteMbomByIds(Long[] mbomIds);

    public List<MomMbomItem> selectItemList(MomMbomItem item);
    public MomMbomItem selectItemById(Long itemId);
    public int countItemSeq(@Param("mbomId") Long mbomId, @Param("parentItemId") Long parentItemId, @Param("itemSeq") Integer itemSeq, @Param("itemId") Long itemId);
    public int insertItem(MomMbomItem item);
    public int updateItem(MomMbomItem item);
    public int deleteItemByIds(Long[] itemIds);
    public int deleteItemByMbomIds(Long[] mbomIds);
}
