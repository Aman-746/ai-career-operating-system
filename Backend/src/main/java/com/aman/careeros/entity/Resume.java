package com.aman.careeros.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Resume Entity - Represents the 'resumes' table.
 * Many-to-one with User so re-uploads keep history; onboarding/resume analysis
 * use the most recent row for a given user.
 */
@Entity
@Table(name = "resumes")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Resume {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "original_filename", nullable = false, length = 255)
    private String originalFilename;

    @Column(name = "storage_path", nullable = false, length = 500)
    private String storagePath;

    @Column(name = "content_type", nullable = false, length = 100)
    private String contentType;

    @Column(name = "file_size_bytes", nullable = false)
    private Long fileSizeBytes;

    @CreationTimestamp
    @Column(name = "uploaded_at", nullable = false, updatable = false)
    private LocalDateTime uploadedAt;

    // --- Resume Analysis Fields (populated synchronously after upload) ---

    @Convert(converter = StringListConverter.class)
    @Column(name = "detected_skills", length = 1000)
    private List<String> detectedSkills;

    @Enumerated(EnumType.STRING)
    @Column(name = "experience_level", length = 20)
    private ExperienceLevel experienceLevel;
}
