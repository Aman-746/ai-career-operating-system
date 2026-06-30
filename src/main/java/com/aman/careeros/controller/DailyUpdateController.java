package com.aman.careeros.controller;

import com.aman.careeros.dto.DailyUpdateRequest;
import com.aman.careeros.dto.DailyUpdateResponse;
import com.aman.careeros.dto.ProgressAnalysisResponse;
import com.aman.careeros.entity.User;
import com.aman.careeros.service.DailyUpdateService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/daily-updates")
@RequiredArgsConstructor
public class DailyUpdateController {

    private final DailyUpdateService dailyUpdateService;

    @PostMapping
    public ResponseEntity<DailyUpdateResponse> save(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody DailyUpdateRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(dailyUpdateService.save(user, request));
    }

    @PutMapping("/{date}")
    public ResponseEntity<DailyUpdateResponse> update(
            @AuthenticationPrincipal User user,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @Valid @RequestBody DailyUpdateRequest request) {
        return ResponseEntity.ok(dailyUpdateService.update(user, date, request));
    }

    @GetMapping
    public ResponseEntity<List<DailyUpdateResponse>> list(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(dailyUpdateService.list(user));
    }

    @GetMapping("/{date}")
    public ResponseEntity<DailyUpdateResponse> getByDate(
            @AuthenticationPrincipal User user,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return ResponseEntity.ok(dailyUpdateService.getByDate(user, date));
    }

    @GetMapping("/analysis")
    public ResponseEntity<ProgressAnalysisResponse> getAnalysis(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(dailyUpdateService.getOrGenerateAnalysis(user));
    }
}
