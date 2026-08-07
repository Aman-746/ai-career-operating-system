-- Question seed: Databases & SQL (DATABASES_AND_SQL)
--
-- Boundary rule: indexing, transactions, ACID, query optimization, and SQL vs NoSQL
-- live HERE. Caching strategies and sharding-for-scale belong in SYSTEM_DESIGN.
--
-- Run manually once after Hibernate has created the questions table:
--   psql "$DATABASE_URL" -f src/main/resources/db/questions_seed_databases_sql.sql
--
-- NOT idempotent — running twice inserts duplicates. Apply once per environment.
-- 20 questions: 6 EASY / 8 MEDIUM / 6 HARD. Single-select, one defensible answer.
-- Correct answer distribution: a=4, b=5, c=6, d=5

-- ============================== EASY (6) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'EASY',
 'What does the "A" in ACID stand for?',
 '[{"id":"a","text":"Authorization"},{"id":"b","text":"Availability"},{"id":"c","text":"Atomicity"},{"id":"d","text":"Asynchronous"}]'::jsonb,
 'c',
 'ACID stands for Atomicity, Consistency, Isolation, Durability. Atomicity means all operations in a transaction succeed or all are rolled back — no partial commit. Availability belongs to the CAP theorem, not ACID.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'EASY',
 'Which SQL clause filters rows AFTER aggregation has been applied?',
 '[{"id":"a","text":"WHERE"},{"id":"b","text":"HAVING"},{"id":"c","text":"GROUP BY"},{"id":"d","text":"ORDER BY"}]'::jsonb,
 'b',
 'HAVING filters groups after GROUP BY and aggregation. WHERE filters individual rows before aggregation and cannot reference aggregate functions. GROUP BY organises rows into groups; ORDER BY sorts the result.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'EASY',
 'What does a PRIMARY KEY constraint guarantee?',
 '[{"id":"a","text":"The column value matches a row in another table"},{"id":"b","text":"The column is automatically indexed in descending order"},{"id":"c","text":"The column value is always a positive integer"},{"id":"d","text":"Each row has a unique, non-null identifier"}]'::jsonb,
 'd',
 'A PRIMARY KEY enforces uniqueness and NOT NULL on the column(s). It does not constrain value type or sort order. A FOREIGN KEY (not PRIMARY KEY) creates a reference to another table.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'EASY',
 'Which JOIN type returns only rows where the join condition is satisfied in BOTH tables?',
 '[{"id":"a","text":"INNER JOIN"},{"id":"b","text":"FULL OUTER JOIN"},{"id":"c","text":"LEFT JOIN"},{"id":"d","text":"RIGHT JOIN"}]'::jsonb,
 'a',
 'INNER JOIN returns only matched rows from both tables. LEFT JOIN returns all rows from the left table plus matched rows from the right (unmatched right rows are NULL). FULL OUTER JOIN returns all rows from both tables.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'EASY',
 'What does database normalization primarily aim to reduce?',
 '[{"id":"a","text":"The number of tables in the schema"},{"id":"b","text":"Index storage size"},{"id":"c","text":"Data redundancy and update anomalies"},{"id":"d","text":"Query execution time"}]'::jsonb,
 'c',
 'Normalization organises data to eliminate redundancy and prevent anomalies (insert, update, delete). It often increases the number of tables and can slow certain queries by requiring joins.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'EASY',
 'Which NoSQL database type stores data as key-value pairs and is optimised for ultra-fast lookups?',
 '[{"id":"a","text":"Column-family store (e.g. Cassandra)"},{"id":"b","text":"Key-value store (e.g. Redis)"},{"id":"c","text":"Graph database (e.g. Neo4j)"},{"id":"d","text":"Document store (e.g. MongoDB)"}]'::jsonb,
 'b',
 'Key-value stores map keys to opaque values and are optimised for O(1) lookups. Document stores handle structured JSON-like documents. Column-family stores suit wide-column time-series data. Graph databases model relationships.',
 true);

-- ============================== MEDIUM (8) ==============================

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'MEDIUM',
 'A query on a large orders table filters by customer_id. No index exists on that column. What is the performance implication?',
 '[{"id":"a","text":"PostgreSQL automatically creates a temporary index for the query"},{"id":"b","text":"The query uses the PRIMARY KEY index as a fallback"},{"id":"c","text":"The query returns an error because the filter column is not indexed"},{"id":"d","text":"A full table scan is required, reading every row regardless of match"}]'::jsonb,
 'd',
 'Without an index on customer_id, the database must scan the entire table to find matching rows. Databases do not auto-create indexes on demand; the primary key index is only used when filtering by the primary key; missing indexes slow queries, they do not cause errors.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'MEDIUM',
 'Transaction A reads a row, Transaction B updates and commits it, then Transaction A reads the same row again and sees the new value. What anomaly is this?',
 '[{"id":"a","text":"Non-repeatable read"},{"id":"b","text":"Dirty read"},{"id":"c","text":"Lost update"},{"id":"d","text":"Phantom read"}]'::jsonb,
 'a',
 'A non-repeatable read occurs when the same row is read twice and returns different values because another committed transaction changed it between reads. A dirty read is reading an uncommitted change; a phantom read involves a changed set of rows.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'MEDIUM',
 'Which SQL isolation level prevents dirty reads but still allows non-repeatable reads?',
 '[{"id":"a","text":"READ UNCOMMITTED"},{"id":"b","text":"SERIALIZABLE"},{"id":"c","text":"READ COMMITTED"},{"id":"d","text":"REPEATABLE READ"}]'::jsonb,
 'c',
 'READ COMMITTED only sees committed data (no dirty reads) but does not lock rows between reads, allowing another transaction to change them (non-repeatable reads). REPEATABLE READ and SERIALIZABLE both prevent non-repeatable reads.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'MEDIUM',
 'A composite index exists on (last_name, first_name). Which query can use this index efficiently?',
 '[{"id":"a","text":"WHERE first_name = ''John''"},{"id":"b","text":"WHERE last_name = ''Smith''"},{"id":"c","text":"WHERE lower(last_name) = ''smith''"},{"id":"d","text":"WHERE first_name = ''John'' AND last_name = ''Smith'' ORDER BY id"}]'::jsonb,
 'b',
 'A B-tree composite index is ordered by the leftmost column first. Filtering on last_name alone can use the index. Filtering on first_name alone skips the leading column. Wrapping a column in a function (lower()) bypasses the index unless a functional index exists.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'MEDIUM',
 'What is the key difference between DELETE and TRUNCATE in SQL?',
 '[{"id":"a","text":"They are identical in behaviour and performance"},{"id":"b","text":"DELETE removes the table structure; TRUNCATE removes only the data"},{"id":"c","text":"TRUNCATE can include a WHERE clause; DELETE cannot"},{"id":"d","text":"DELETE is transactional and fires triggers; TRUNCATE is faster and typically non-transactional"}]'::jsonb,
 'd',
 'DELETE removes rows one at a time, fires row-level triggers, and participates in transactions. TRUNCATE removes all rows in bulk, is faster, does not fire row-level triggers, and is harder to roll back. Neither drops the table — DROP does that.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'MEDIUM',
 'When should you choose a NoSQL document store over a relational database?',
 '[{"id":"a","text":"When the data has a flexible or evolving schema and is read as a self-contained unit"},{"id":"b","text":"When you need multi-table JOIN queries with strong transactional guarantees"},{"id":"c","text":"When the data is highly relational with many foreign key relationships"},{"id":"d","text":"When you need a strict schema to prevent invalid data from being stored"}]'::jsonb,
 'a',
 'Document stores excel when entities map naturally to self-contained documents with flexible fields — product catalogs, user profiles. They are weak at complex multi-entity joins, cross-document transactions, and strict schema enforcement.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'MEDIUM',
 'What does the N+1 query problem describe?',
 '[{"id":"a","text":"A query that joins N+1 tables and times out"},{"id":"b","text":"Running the same query N times in a loop due to a bug"},{"id":"c","text":"Fetching a list of N records and then issuing one additional query per record to load related data"},{"id":"d","text":"Having more database connections open than the pool allows"}]'::jsonb,
 'c',
 'The N+1 problem occurs when loading N entities triggers N separate queries for their associations — one per entity. This is common in ORMs with lazy loading. The fix is eager loading (JOIN FETCH or an IN clause) to collapse it to one or two queries.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'MEDIUM',
 'A table has a B-tree index on the email column. Why does the query WHERE email LIKE ''%@gmail.com'' fail to use it?',
 '[{"id":"a","text":"LIKE operators are not supported with B-tree indexes"},{"id":"b","text":"A leading wildcard prevents index range scans because the prefix is unknown"},{"id":"c","text":"B-tree indexes do not store string values"},{"id":"d","text":"The index is only usable for exact equality checks"}]'::jsonb,
 'b',
 'B-tree indexes work by scanning from a known prefix. A leading wildcard (%) means the prefix is unknown so the database falls back to a full scan. A trailing wildcard (''gmail%'') does use the index. Trigram or full-text indexes handle leading wildcards.',
 true);

-- ============================== HARD (6) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'HARD',
 'Transaction A holds a lock on row 1 and waits for row 2. Transaction B holds a lock on row 2 and waits for row 1. What is this condition and how do databases resolve it?',
 '[{"id":"a","text":"Livelock — both transactions keep retrying and never complete"},{"id":"b","text":"Race condition — both transactions commit with inconsistent data"},{"id":"c","text":"Deadlock — the database detects the cycle and aborts one transaction"},{"id":"d","text":"Starvation — one transaction is indefinitely postponed"}]'::jsonb,
 'c',
 'This is a classic deadlock: a circular lock wait. Databases detect it via a wait-for graph and abort the transaction with the lowest cost (the victim). A livelock involves repeated retries without progress; starvation is unfair scheduling; a race condition allows both to commit incorrectly.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'HARD',
 'PostgreSQL''s MVCC (Multi-Version Concurrency Control) allows reads without blocking writes. How does it achieve this?',
 '[{"id":"a","text":"Reads acquire shared locks that block concurrent writes"},{"id":"b","text":"The database serialises all reads and writes into a single queue"},{"id":"c","text":"Writes are buffered in memory until all active readers complete"},{"id":"d","text":"Each write creates a new row version; readers see the snapshot as of their transaction start, ignoring newer versions"}]'::jsonb,
 'd',
 'MVCC stores multiple versions of each row with transaction timestamps. Readers see a consistent snapshot without taking locks; writers create new versions rather than overwriting. This eliminates read-write contention at the cost of storage for old versions, cleaned by VACUUM.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'HARD',
 'A query against a 50-million-row table uses an index on (created_at) but is still slow. EXPLAIN shows the index scan returning 8 million rows. What is the most likely fix?',
 '[{"id":"a","text":"Add a composite index on (created_at, status) to cover the full WHERE clause and reduce rows returned"},{"id":"b","text":"Drop and recreate the existing index to rebuild its statistics"},{"id":"c","text":"Partition the table by primary key"},{"id":"d","text":"Switch the table storage engine to an in-memory store"}]'::jsonb,
 'a',
 'Returning 8M rows means the index is not selective enough alone — adding a second filter column (status) makes it far more selective. Rebuilding statistics helps the planner choose correctly but does not fix a low-selectivity index. Partitioning by primary key would not help a time-based query.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'HARD',
 'You must transfer $500 between two bank accounts in the same PostgreSQL database. Which isolation level is the minimum required to prevent a lost-update anomaly where two concurrent transfers overlap?',
 '[{"id":"a","text":"READ UNCOMMITTED prevents lost updates by using optimistic locking"},{"id":"b","text":"REPEATABLE READ combined with SELECT FOR UPDATE to lock both rows"},{"id":"c","text":"No isolation level is needed — application-level retries handle lost updates"},{"id":"d","text":"READ COMMITTED is sufficient because each statement sees committed data"}]'::jsonb,
 'b',
 'READ COMMITTED does not re-read rows within a transaction, so two concurrent transfers can both read the same balance and overwrite each other. REPEATABLE READ with SELECT FOR UPDATE locks the rows at read time, preventing a second transaction from changing them until the first commits.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'HARD',
 'A table has 10 million rows. You need to add a NOT NULL column with a default value in PostgreSQL 11+. What is the performance implication?',
 '[{"id":"a","text":"NOT NULL columns with defaults cannot be added to tables with existing rows"},{"id":"b","text":"PostgreSQL must rewrite all 10M rows immediately, causing a long table lock"},{"id":"c","text":"PostgreSQL 11+ stores the default in the catalog and avoids rewriting rows — the ALTER is near-instant"},{"id":"d","text":"The default value is applied lazily as rows are read, causing slow first reads forever"}]'::jsonb,
 'c',
 'PostgreSQL 11 introduced the ability to store constant defaults in the system catalog without rewriting the table. Before PostgreSQL 11, this required a full table rewrite — a critical production concern. Rows without the new column are treated as having the default at read time.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATABASES_AND_SQL', 'HARD',
 'A write-heavy application has severe contention on a single auto-increment primary key sequence. Which strategy best reduces this hotspot?',
 '[{"id":"a","text":"Add a composite index on the primary key and a timestamp column"},{"id":"b","text":"Increase the sequence cache size to pre-allocate values in bulk"},{"id":"c","text":"Switch to READ UNCOMMITTED isolation to reduce lock contention"},{"id":"d","text":"Switch to UUID v4 primary keys to distribute inserts randomly across the B-tree index"}]'::jsonb,
 'd',
 'Sequential integer keys cause all new inserts to hit the rightmost B-tree page — a write hotspot. UUID v4 distributes inserts randomly, eliminating the hotspot. Increasing sequence cache reduces round-trips but does not address the B-tree page contention. Isolation level does not affect index structure contention.',
 true);
