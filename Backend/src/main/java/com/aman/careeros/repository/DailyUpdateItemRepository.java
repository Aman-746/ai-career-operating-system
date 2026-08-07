package com.aman.careeros.repository;

import com.aman.careeros.entity.DailyUpdateItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DailyUpdateItemRepository extends JpaRepository<DailyUpdateItem, UUID> {

    List<DailyUpdateItem> findAllByDailyUpdateId(UUID dailyUpdateId);

    void deleteAllByDailyUpdateId(UUID dailyUpdateId);
}
