package com.aman.careeros.entity;

public enum ExperienceLevel {
    JUNIOR,
    MID,
    SENIOR,
    STAFF;

    public static ExperienceLevel fromYearsOfExperience(int years) {
        if (years <= 1) return JUNIOR;
        if (years <= 5) return MID;
        if (years <= 10) return SENIOR;
        return STAFF;
    }
}
