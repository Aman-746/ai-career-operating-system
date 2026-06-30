package com.aman.careeros.dto;

import jakarta.validation.constraints.NotBlank;

public record UpdateItemStatusRequest(
        @NotBlank String status) {
}
