package com.aman.careeros.controller;

import com.aman.careeros.dto.GenerateRoadmapRequest;
import com.aman.careeros.dto.RoadmapItemDto;
import com.aman.careeros.dto.RoadmapResponse;
import com.aman.careeros.dto.UpdateItemStatusRequest;
import com.aman.careeros.entity.User;
import com.aman.careeros.service.RoadmapService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/roadmap")
@RequiredArgsConstructor
public class RoadmapController {

    private final RoadmapService roadmapService;

    /**
     * POST /api/roadmap/generate
     * Generates a personalized roadmap from the user's resume, assessment, and gap analysis.
     * Archives any existing active roadmap.
     */
    @PostMapping("/generate")
    public ResponseEntity<RoadmapResponse> generate(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody GenerateRoadmapRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(roadmapService.generate(user, request));
    }

    /**
     * GET /api/roadmap
     * Returns the user's active roadmap grouped by week, with current completion %.
     */
    @GetMapping
    public ResponseEntity<RoadmapResponse> getActive(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(roadmapService.getActive(user));
    }

    /**
     * PATCH /api/roadmap/items/{id}
     * Toggles a single item's status (NOT_STARTED / IN_PROGRESS / COMPLETED).
     * Drives the Roadmap Completion % on the roadmap screen and dashboard.
     */
    @PatchMapping("/items/{id}")
    public ResponseEntity<RoadmapItemDto> updateItemStatus(
            @AuthenticationPrincipal User user,
            @PathVariable UUID id,
            @Valid @RequestBody UpdateItemStatusRequest request) {
        return ResponseEntity.ok(roadmapService.updateItemStatus(user, id, request));
    }
}
