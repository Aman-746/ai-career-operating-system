package com.aman.careeros.resume;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import org.yaml.snakeyaml.Yaml;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Loads skills.yml at startup and compiles one regex per skill.
 *
 * Word-boundary strategy:
 *   Standard \b breaks on tech tokens that contain +, #, or . (C++, C#, Node.js).
 *   Instead we use custom lookaround boundaries that treat those characters as
 *   part of the token, preventing "asp.net" from matching inside "my.asp.net.app"
 *   while still matching ".NET" following a space.
 *
 * Match modes:
 *   NORMAL  – canonical name + aliases are all included in the pattern.
 *   STRICT  – aliases only. Used for tokens too ambiguous as bare words (Go, R, dbt).
 */
@Component
@Slf4j
public class SkillTaxonomy {

    // Left boundary: not preceded by a word char or any tech-token punctuation.
    private static final String L = "(?<![\\w+#.])";
    // Right boundary: not followed by a word char or any tech-token punctuation.
    private static final String R = "(?![\\w+#.])";

    private List<CompiledSkill> compiledSkills = new ArrayList<>();

    @PostConstruct
    void load() {
        try (InputStream in = new ClassPathResource("skills.yml").getInputStream()) {
            Yaml yaml = new Yaml();
            Map<String, Object> root = yaml.load(in);
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> rawSkills = (List<Map<String, Object>>) root.get("skills");

            List<CompiledSkill> built = new ArrayList<>(rawSkills.size());
            for (Map<String, Object> raw : rawSkills) {
                SkillDefinition def = parse(raw);
                built.add(new CompiledSkill(def, compile(def)));
            }
            compiledSkills = Collections.unmodifiableList(built);
            log.info("Loaded {} skills from taxonomy", compiledSkills.size());
        } catch (Exception e) {
            log.error("Failed to load skill taxonomy — skill extraction will return empty results: {}", e.getMessage(), e);
        }
    }

    public List<CompiledSkill> compiled() {
        return compiledSkills;
    }

    @SuppressWarnings("unchecked")
    private SkillDefinition parse(Map<String, Object> raw) {
        SkillDefinition def = new SkillDefinition();
        def.setCanonical((String) raw.get("canonical"));
        def.setCategory((String) raw.getOrDefault("category", "General"));

        if (raw.get("aliases") instanceof List<?> list) {
            def.setAliases(list.stream().map(Object::toString).toList());
        }

        String mode = (String) raw.getOrDefault("matchMode", "NORMAL");
        def.setMatchMode(SkillDefinition.MatchMode.valueOf(mode.toUpperCase()));
        return def;
    }

    private Pattern compile(SkillDefinition def) {
        Stream<String> terms = def.getMatchMode() == SkillDefinition.MatchMode.STRICT
                ? def.getAliases().stream()
                : Stream.concat(Stream.of(def.getCanonical()), def.getAliases().stream());

        String alternation = terms
                .map(t -> Pattern.quote(t.toLowerCase()))
                .collect(Collectors.joining("|"));

        return Pattern.compile(L + "(?:" + alternation + ")" + R, Pattern.CASE_INSENSITIVE);
    }
}
