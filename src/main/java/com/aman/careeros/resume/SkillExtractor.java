package com.aman.careeros.resume;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.regex.Matcher;

/**
 * Scans resume text against the compiled taxonomy and returns ranked SkillMatch results.
 *
 * Confidence scoring:
 *   1 occurrence  → 0.55
 *   2 occurrences → 0.70
 *   3 occurrences → 0.85
 *   4+            → 1.00 (capped)
 *
 * Ranking by confidence means skills mentioned multiple times (e.g. in a Skills
 * section AND in project descriptions) naturally outrank skills mentioned once in passing.
 */
@Component
@RequiredArgsConstructor
public class SkillExtractor {

    private static final int MAX_SKILLS = 12;

    private final SkillTaxonomy taxonomy;

    public List<SkillMatch> extract(String text) {
        if (text == null || text.isBlank()) return Collections.emptyList();

        List<SkillMatch> matches = new ArrayList<>();
        for (CompiledSkill cs : taxonomy.compiled()) {
            int count = countMatches(cs.pattern().matcher(text));
            if (count > 0) {
                matches.add(new SkillMatch(
                        cs.definition().getCanonical(),
                        cs.definition().getCategory(),
                        count,
                        confidence(count)));
            }
        }

        matches.sort(Comparator.comparingDouble(SkillMatch::confidence).reversed());
        return matches.size() > MAX_SKILLS ? matches.subList(0, MAX_SKILLS) : matches;
    }

    private int countMatches(Matcher m) {
        int n = 0;
        while (m.find()) n++;
        return n;
    }

    private double confidence(int occurrences) {
        return Math.min(1.0, 0.55 + 0.15 * (occurrences - 1));
    }
}
