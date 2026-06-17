package com.aman.careeros.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

/**
 * FileStorageService - Saves uploaded files to local disk.
 *
 * This is intentionally a thin, local-disk implementation for now (no AWS/S3
 * dependency exists in the project yet). The storage path returned is opaque
 * to callers, so swapping this for a cloud-backed implementation later won't
 * require changes anywhere else.
 */
@Service
public class FileStorageService {

    private final Path rootLocation;

    public FileStorageService(@Value("${app.resume.upload-dir:uploads/resumes}") String uploadDir) {
        this.rootLocation = Paths.get(uploadDir).toAbsolutePath().normalize();
        try {
            Files.createDirectories(rootLocation);
        } catch (IOException e) {
            throw new IllegalStateException("Could not initialize resume storage directory", e);
        }
    }

    /**
     * Stores the file under a generated name (never the user-supplied original
     * filename) and returns the absolute path it was saved to. The extension
     * must come from a server-side whitelist, not the raw upload, to avoid
     * path traversal via a crafted filename.
     */
    public String store(MultipartFile file, UUID userId, String extension) {
        String storedFilename = userId + "_" + UUID.randomUUID() + extension;
        Path destination = rootLocation.resolve(storedFilename).normalize();

        try {
            file.transferTo(destination);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to store resume file", e);
        }

        return destination.toString();
    }
}
