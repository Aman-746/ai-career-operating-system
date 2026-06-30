package com.aman.careeros.repository;

import com.aman.careeros.entity.DailyUpdate;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface DailyUpdateRepository extends JpaRepository<DailyUpdate, UUID> {

    Optional<DailyUpdate> findByUserIdAndDate(UUID userId, LocalDate date);

    List<DailyUpdate> findAllByUserIdOrderByDateDesc(UUID userId);

    List<DailyUpdate> findAllByUserIdAndDateAfterOrderByDateAsc(UUID userId, LocalDate afterDate);

    long countByUserId(UUID userId);

    long countByUserIdAndDateAfter(UUID userId, LocalDate afterDate);
}
