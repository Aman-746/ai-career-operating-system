package com.aman.careeros.resume;

/**
 * A skill detected in a resume.
 *
 * @param canonical  display name returned in API responses (e.g. "React", "PostgreSQL")
 * @param category   taxonomy grouping (e.g. "Frontend", "Databases")
 * @param occurrences how many times the skill (or any alias) appeared in the text
 * @param confidence  0–1 score derived from occurrence count; used to rank results
 */
public record SkillMatch(String canonical, String category, int occurrences, double confidence) {}
