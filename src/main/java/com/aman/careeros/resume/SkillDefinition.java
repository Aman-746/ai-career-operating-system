package com.aman.careeros.resume;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class SkillDefinition {

    private String canonical;
    private String category;
    private List<String> aliases = new ArrayList<>();
    private MatchMode matchMode = MatchMode.NORMAL;

    public enum MatchMode {
        /** canonical + all aliases matched with word-boundary regex */
        NORMAL,
        /** aliases only — canonical token is too ambiguous as a bare word (e.g. "Go", "R") */
        STRICT
    }
}
