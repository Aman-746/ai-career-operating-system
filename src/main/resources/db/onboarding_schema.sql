-- Reference schema for the onboarding module.
--
-- This file is NOT executed automatically. The project has no migration
-- tool (Flyway/Liquibase) configured yet; tables are created/updated by
-- Hibernate via `spring.jpa.hibernate.ddl-auto: update` (see application.yml),
-- same as the existing `users` table. This file exists purely as a
-- human-readable reference for the shape Hibernate will produce, and as a
-- starting point if/when the project adopts a real migration tool.

CREATE TABLE onboarding_profiles (
    id                   UUID PRIMARY KEY,
    user_id              UUID NOT NULL UNIQUE REFERENCES users (id) ON DELETE CASCADE,
    current_role         VARCHAR(100) NOT NULL,  -- same curated dropdown vocabulary as target_role
    target_role          VARCHAR(100) NOT NULL,
    target_company       VARCHAR(150),
    timeline             VARCHAR(20) NOT NULL,   -- ZERO_TO_THREE_MONTHS | THREE_TO_SIX_MONTHS | SIX_TO_TWELVE_MONTHS | JUST_EXPLORING
    years_of_experience  INT NOT NULL,
    status               VARCHAR(20) NOT NULL DEFAULT 'IN_PROGRESS', -- IN_PROGRESS | COMPLETED
    created_at           TIMESTAMP NOT NULL DEFAULT now(),
    updated_at           TIMESTAMP NOT NULL DEFAULT now()
);

-- MIGRATION NOTE (2026-06-17): current_role was added after onboarding_profiles
-- already existed. Hibernate's ddl-auto=update will emit a plain
-- `ALTER TABLE onboarding_profiles ADD COLUMN current_role VARCHAR(100) NOT NULL`
-- with no default. In Postgres, that statement fails outright if the table
-- already has rows, since existing rows have no value to satisfy NOT NULL.
--   - Dev DB with no real onboarding rows yet: no action needed, the ALTER
--     will succeed on an empty table.
--   - Dev/prod DB with existing rows: run a manual backfill before the app
--     boots against it, e.g.:
--       ALTER TABLE onboarding_profiles ADD COLUMN current_role VARCHAR(100);
--       UPDATE onboarding_profiles SET current_role = 'Unspecified' WHERE current_role IS NULL;
--       ALTER TABLE onboarding_profiles ALTER COLUMN current_role SET NOT NULL;
--     then let Hibernate manage it as NOT NULL going forward.

CREATE TABLE resumes (
    id                   UUID PRIMARY KEY,
    user_id              UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    original_filename    VARCHAR(255) NOT NULL,
    storage_path         VARCHAR(500) NOT NULL,
    content_type         VARCHAR(100) NOT NULL,
    file_size_bytes      BIGINT NOT NULL,
    uploaded_at          TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_resumes_user_id ON resumes (user_id);

-- MIGRATION NOTE (2026-06-19): Three analysis columns added to resumes.
-- Hibernate ddl-auto=update will emit:
--   ALTER TABLE resumes ADD COLUMN detected_skills  VARCHAR(1000);
--   ALTER TABLE resumes ADD COLUMN detected_role    VARCHAR(100);
--   ALTER TABLE resumes ADD COLUMN experience_level VARCHAR(20);
-- All three are nullable, so the ALTER succeeds on tables with existing rows.
-- Existing resume rows will have NULL values for these columns; analysis only
-- runs for resumes uploaded after this change is deployed.
