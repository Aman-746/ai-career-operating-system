-- Question seed: Testing & Code Quality (TESTING_AND_CODE_QUALITY)
--
-- Boundary rule: testing pyramid, TDD (red-green-refactor), test doubles
-- (mock/stub/spy/fake/dummy), code coverage (line/branch/mutation), code
-- smells (God class, feature envy, long method, magic number, duplicate
-- code), refactoring techniques (extract method, rename, inline), static
-- analysis tools (ESLint, SonarQube), CI quality gates, and F.I.R.S.T
-- principles for unit tests live HERE.
--
-- Run manually once after Hibernate has created the questions table:
--   psql "$DATABASE_URL" -f src/main/resources/db/questions_seed_testing_code_quality.sql
--
-- NOT idempotent — running twice inserts duplicates. Apply once per environment.
-- 20 questions: 6 EASY / 8 MEDIUM / 6 HARD. Single-select, one defensible answer.
-- Correct answer distribution: a=5, b=5, c=5, d=5

-- ============================== EASY (6) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'EASY',
 'What does the testing pyramid recommend?',
 '[{"id":"a","text":"Equal numbers of unit, integration, and end-to-end tests"},{"id":"b","text":"A single layer of end-to-end tests that exercise the full application stack"},{"id":"c","text":"Many fast unit tests at the base, fewer integration tests in the middle, and fewest end-to-end tests at the top"},{"id":"d","text":"A CI pipeline with three sequential quality gates that must all pass before deployment"}]'::jsonb,
 'c',
 'Unit tests are cheap and fast; end-to-end tests are slow and brittle. The pyramid optimises for fast feedback by keeping the base large (unit) and the apex small (e2e). Inverting it (the "ice-cream cone") leads to slow, fragile suites.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'EASY',
 'In Test-Driven Development (TDD), what does the "red-green-refactor" cycle mean?',
 '[{"id":"a","text":"Write a failing test (red), write just enough code to make it pass (green), then improve the implementation without changing behaviour (refactor)"},{"id":"b","text":"Mark failing tests red, passing tests green, and delete red tests during refactor"},{"id":"c","text":"Write all tests first (red phase), run them (green phase), then write the production code (refactor phase)"},{"id":"d","text":"Red = coverage below 80%; green = all linters pass; refactor = rewrite to 100% coverage"}]'::jsonb,
 'a',
 'TDD drives design through tests. Red: the test fails because the feature doesn''t exist yet. Green: write the simplest code to pass it. Refactor: clean up duplication and design without breaking the test. Repeat.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'EASY',
 'What is a test double?',
 '[{"id":"a","text":"A test that runs twice to verify it is deterministic"},{"id":"b","text":"A second developer who reviews test code for accuracy"},{"id":"c","text":"A test that covers both the happy path and error path in one function"},{"id":"d","text":"A generic term for any object that replaces a real dependency in a test (e.g., mock, stub, spy, fake, dummy)"}]'::jsonb,
 'd',
 'The term "test double" (coined by Gerard Meszaros) covers all stand-in collaborators. Specific types differ by purpose: stubs return pre-programmed values, mocks verify interactions, spies record calls, fakes have working lightweight implementations, dummies are never actually used.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'EASY',
 'What does line coverage measure?',
 '[{"id":"a","text":"The percentage of test assertions that check non-trivial conditions"},{"id":"b","text":"The percentage of executable source lines that were executed by the test suite"},{"id":"c","text":"The ratio of lines in the test file to lines in the production file"},{"id":"d","text":"The percentage of user-visible features covered by integration tests"}]'::jsonb,
 'b',
 'Line coverage (statement coverage) counts which lines ran during the test suite. It is the most basic coverage metric. It does not verify what was asserted — a line can be covered with no assertions and still count as covered.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'EASY',
 'What is a code smell?',
 '[{"id":"a","text":"A compile error indicating incorrect syntax"},{"id":"b","text":"A performance bottleneck causing slow execution"},{"id":"c","text":"A surface-level indicator in code that suggests a deeper design problem without being a bug itself"},{"id":"d","text":"A test that passes when it should fail, masking a defect"}]'::jsonb,
 'c',
 'Code smells (a term from Martin Fowler''s Refactoring) are symptoms that often indicate deeper structural problems. Examples: duplicate code, long methods, large classes. They are not bugs — the code may work — but they make the code harder to change.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'EASY',
 'What is the difference between a stub and a spy as test doubles?',
 '[{"id":"a","text":"A stub provides pre-programmed return values; a spy wraps a real (or partial) object and records how it was called"},{"id":"b","text":"A spy provides fixed return values; a stub records method invocations for later verification"},{"id":"c","text":"A stub verifies that a specific method was called; a spy only verifies the return value"},{"id":"d","text":"A spy completely replaces the real object; a stub intercepts only one specific method"}]'::jsonb,
 'a',
 'Stubs are passive — they return what you configure and do not track calls. Spies are active recorders — they delegate to the real implementation (or a partial one) and remember what methods were called with what arguments, enabling after-the-fact verification.',
 true);

-- ============================== MEDIUM (8) ==============================

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'MEDIUM',
 'When should you use a fake instead of a mock?',
 '[{"id":"a","text":"When you want to verify that a specific method was called with specific arguments"},{"id":"b","text":"When you need to stub a return value for a side-effect-free method"},{"id":"c","text":"When you want to skip all test setup by using the real production implementation"},{"id":"d","text":"When a lightweight working implementation (e.g., an in-memory repository) is simpler and more realistic than configuring a mock with many method stubs"}]'::jsonb,
 'd',
 'A fake has a real (simplified) implementation — e.g., a HashMap-backed repository. It is easier to set up than a mock when many methods are called, and it behaves more realistically. The trade-off is that fakes must be maintained alongside the real implementation.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'MEDIUM',
 'What does branch coverage measure that line coverage does not?',
 '[{"id":"a","text":"Branch coverage counts the total number of boolean conditions in the code"},{"id":"b","text":"Branch coverage verifies that both the true and false outcomes of every conditional have been exercised, not just that the line containing the conditional was reached"},{"id":"c","text":"Branch coverage tracks whether each public function was invoked at least once"},{"id":"d","text":"Branch coverage measures whether every loop body executed more than one iteration"}]'::jsonb,
 'b',
 'A line containing `if (x > 0) return a; else return b;` is line-covered if the true branch runs. Branch coverage requires both the true and false paths to execute. This catches bugs hidden in the untaken branch that line coverage misses.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'MEDIUM',
 'The "I" in F.I.R.S.T principles for unit tests stands for Isolated. What does this require?',
 '[{"id":"a","text":"Tests must not depend on each other''s state or execution order — each test sets up its own data and can pass or fail independently"},{"id":"b","text":"Test files must be in a package isolated from the production code"},{"id":"c","text":"Each test must verify exactly one line of production code"},{"id":"d","text":"Test source code must not be committed to the same repository as production code"}]'::jsonb,
 'a',
 'Isolated tests are independent: running test B after test A should give the same result as running test B alone. Shared state (static fields, database records left by previous tests) makes tests fragile and order-dependent. setUp/tearDown or fresh instances per test enforce isolation.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'MEDIUM',
 'What is mutation testing?',
 '[{"id":"a","text":"A technique for automatically generating tests from the production code''s type signatures"},{"id":"b","text":"A refactoring approach that replaces complex if/else chains with polymorphism"},{"id":"c","text":"A technique that introduces small code changes (mutations) and checks whether existing tests catch them — surviving mutations reveal weak assertions"},{"id":"d","text":"A process that converts hand-written tests into parameterised tests automatically"}]'::jsonb,
 'c',
 'Mutation testing tools (e.g., PIT, Stryker) systematically apply mutations (flip conditionals, remove statements, change constants) and run the test suite. A mutation that does not cause any test to fail is a "survivor" — evidence that no test actually asserts on that behaviour.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'MEDIUM',
 'The "feature envy" code smell describes a method that:',
 '[{"id":"a","text":"Accesses only its own class''s private fields and ignores all collaborators"},{"id":"b","text":"Uses data and behaviour from another class so heavily that it seems to belong in that class"},{"id":"c","text":"Provides too many public methods, violating the Interface Segregation Principle"},{"id":"d","text":"Is called by every other class in the system, creating an excessive fan-in dependency"}]'::jsonb,
 'b',
 'Feature envy (from Fowler''s Refactoring) is when a method is more interested in another class''s data than its own. The fix is usually Move Method — relocate it to the class whose data it actually uses, where it reduces coupling and improves cohesion.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'MEDIUM',
 'What does the "Extract Method" refactoring technique do?',
 '[{"id":"a","text":"Moves a method from one class to a more appropriate class without changing its name"},{"id":"b","text":"Pulls a method body into a new abstract base-class method for reuse by subclasses"},{"id":"c","text":"Extracts a method signature into an interface so the method can be mocked in tests"},{"id":"d","text":"Turns a code fragment inside a long method into its own named method, improving readability and enabling reuse"}]'::jsonb,
 'd',
 'Extract Method is one of the most common refactorings. It takes a cohesive code block, gives it a meaningful name, replaces the inline code with a call, and moves complexity behind a descriptive name — reducing method length and making intent explicit.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'MEDIUM',
 'What is the "God class" code smell?',
 '[{"id":"a","text":"A class that accumulates too many responsibilities — it knows too much and does too much, concentrating logic that should be spread across multiple classes"},{"id":"b","text":"A class used by every other class in the system as a shared utility provider"},{"id":"c","text":"A base class with too many subclasses, making the inheritance hierarchy unmanageable"},{"id":"d","text":"A class that holds global constants and application-wide configuration values"}]'::jsonb,
 'a',
 'A God class is the object-oriented equivalent of a big ball of mud. It violates SRP by accumulating responsibilities over time. Symptoms: huge file, many unrelated methods and fields, everything depending on it. Fix: identify distinct responsibilities and extract separate classes.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'MEDIUM',
 'Integration tests catch defects that unit tests typically miss. What is the most important category of such defects?',
 '[{"id":"a","text":"Arithmetic logic errors inside individual functions"},{"id":"b","text":"Off-by-one errors in loop boundary conditions"},{"id":"c","text":"Defects in the interactions between components — e.g., SQL queries that are syntactically valid but semantically wrong, or contract mismatches between services"},{"id":"d","text":"Naming errors in public API methods that violate the team''s coding conventions"}]'::jsonb,
 'c',
 'Unit tests verify logic in isolation. Integration tests verify that the pieces connect correctly: the ORM generates valid SQL, the API accepts the right payload shape, service A and service B agree on the contract. Mocks can mask these integration failures.',
 true);

-- ============================== HARD (6) ==============================

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'HARD',
 'Over-mocking in unit tests (mocking nearly every collaborator) creates false confidence. Why?',
 '[{"id":"a","text":"Mocked tests run slower than integration tests, making the build pipeline less efficient"},{"id":"b","text":"Mocks encode assumptions about collaborator behaviour; if those assumptions are wrong or the collaborator changes, the test still passes while the production integration breaks"},{"id":"c","text":"Using many mocks violates the Single Responsibility Principle for test classes"},{"id":"d","text":"Over-mocking makes tests non-deterministic because mock frameworks use random return values by default"}]'::jsonb,
 'b',
 'A test full of mocks is testing the test setup, not the system. If the real EmailService now throws on invalid addresses but the mock still returns success, the unit test passes while production fails. The fix is to use real collaborators or fakes where interactions matter, and reserve mocks for slow/external dependencies.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'HARD',
 'Mutation testing often shows many surviving mutations even when line coverage is 100%. What does this reveal?',
 '[{"id":"a","text":"The mutation testing tool is reporting false positives due to equivalent mutations"},{"id":"b","text":"100% line coverage implies full branch coverage, so surviving mutations indicate a tool bug"},{"id":"c","text":"The test suite has too many tests, causing false negatives in mutation scoring"},{"id":"d","text":"Coverage tells you which code was executed, not whether tests assert on the output — code can be executed without any assertion checking its effect"}]'::jsonb,
 'd',
 'Coverage is an execution metric, not an assertion metric. A test can call a function, cover every line, and assert nothing — the function runs but no failure is triggered when its output is wrong. Mutation testing reveals this by changing the code and checking if any test breaks.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'HARD',
 'TDD is claimed to improve design, not just coverage. What design benefit does writing tests first provide?',
 '[{"id":"a","text":"Tests auto-generate API documentation, reducing the need for manual docs"},{"id":"b","text":"The test is the first client of the production code — if it is hard to test, the design is too coupled, so TDD creates pressure toward simpler, more injectable interfaces"},{"id":"c","text":"Writing tests first eliminates the need for code review because tests specify all requirements"},{"id":"d","text":"TDD mandates dependency injection, which is always the optimal architectural pattern"}]'::jsonb,
 'b',
 'If a class is hard to instantiate in a test (needs five real dependencies), the design is sending a signal. TDD surfaces coupling problems before they are embedded in production. Classes designed to be testable are typically also more modular, focused, and easier to maintain.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'HARD',
 'What is the key trade-off when setting a CI quality gate that blocks merges if branch coverage drops below 90%?',
 '[{"id":"a","text":"The gate prevents all regressions including performance and security issues"},{"id":"b","text":"A 90% gate guarantees that 90% of bugs are caught before reaching production"},{"id":"c","text":"Branch coverage gates have zero false positives — every blocked merge is a genuine quality issue"},{"id":"d","text":"The gate may block valid work when untestable code (generated code, trivial getters) makes 90% hard to reach, while still allowing weak assertion-free tests that hit the threshold but catch nothing"}]'::jsonb,
 'd',
 'Coverage gates are a proxy, not a guarantee. They block work that cannot easily reach the threshold (boilerplate, framework glue) while permitting tests that hit lines with no assertions. They are most useful when combined with mutation testing or code review for test quality.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'HARD',
 'A team rewrites a messy module from scratch rather than refactoring incrementally. What is the main risk?',
 '[{"id":"a","text":"Rewriting is always faster, so the risk is only that refactoring was the better choice for learning"},{"id":"b","text":"The rewrite will produce code that is harder to read than the original"},{"id":"c","text":"The rewrite discards hard-won implicit knowledge — edge cases, bug fixes, and business rules buried in the existing code may be lost and the original bugs reproduced"},{"id":"d","text":"Static analysis tools cannot analyse freshly written modules, leaving quality blind spots"}]'::jsonb,
 'c',
 'Joel Spolsky''s "Never Rewrite" observation: production code accumulates fixes for real bugs that are not obvious from reading the code. A rewrite starts from a clean-room misunderstanding and typically reproduces old bugs or introduces new ones. Incremental refactoring is safer because tests catch regressions step by step.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'TESTING_AND_CODE_QUALITY', 'HARD',
 'Static analysis tools like ESLint and SonarQube have a false-positive cost. What is it?',
 '[{"id":"a","text":"Developers spend time investigating and suppressing warnings that are not real problems; if false positives are common, teams start ignoring all warnings — destroying the tool''s signal value"},{"id":"b","text":"False positives cause CI to fail and block all merges until the tool is reconfigured"},{"id":"c","text":"False positives increase test execution time because each warning triggers an additional test run"},{"id":"d","text":"Static analysis false positives always indicate real latent security vulnerabilities"}]'::jsonb,
 'a',
 'The danger of too many false positives is alert fatigue — when warnings are routinely wrong, developers silence them wholesale and the tool loses its value. Tuning rules to balance precision and recall, and using suppression comments sparingly with justification, preserves signal quality.',
 true);
