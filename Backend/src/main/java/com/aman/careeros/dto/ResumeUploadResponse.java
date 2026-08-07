package com.aman.careeros.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * ResumeUploadResponse - The response body returned after a resume upload, or on lookup.
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ResumeUploadResponse {
    private UUID id;
    private String originalFilename;
    private Long fileSizeBytes;
    private LocalDateTime uploadedAt;
}
