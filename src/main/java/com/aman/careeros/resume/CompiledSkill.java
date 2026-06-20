package com.aman.careeros.resume;

import java.util.regex.Pattern;

/** Internal pairing of a skill definition with its compiled regex. Package-private. */
record CompiledSkill(SkillDefinition definition, Pattern pattern) {}
