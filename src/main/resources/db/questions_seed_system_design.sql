-- Question seed: System Design (SYSTEM_DESIGN)
--
-- Boundary rule: caching strategies, sharding-for-scale, and message queues
-- live HERE. Indexing and transactions belong in DATABASES_AND_SQL.
-- Auth concepts belong in API_AND_WEB_FUNDAMENTALS.
--
-- Run manually once after Hibernate has created the questions table:
--   psql "$DATABASE_URL" -f src/main/resources/db/questions_seed_system_design.sql
--
-- NOT idempotent — running twice inserts duplicates. Apply once per environment.
-- 20 questions: 6 EASY / 8 MEDIUM / 6 HARD. Single-select, one defensible answer.
-- Correct answer distribution: a=4, b=6, c=5, d=5

-- ============================== EASY (6) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'EASY',
 'What does horizontal scaling (scaling out) mean?',
 '[{"id":"a","text":"Upgrading an existing machine with more CPU and RAM"},{"id":"b","text":"Partitioning a database into smaller tables"},{"id":"c","text":"Adding more machines to distribute load"},{"id":"d","text":"Enabling round-robin DNS across two servers"}]'::jsonb,
 'c',
 'Horizontal scaling adds more nodes to spread load. Vertical scaling (scaling up) upgrades a single machine. Partitioning is a data strategy; round-robin DNS is a routing technique, not a scaling direction.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'EASY',
 'What is the primary purpose of a Content Delivery Network (CDN)?',
 '[{"id":"a","text":"Balance API requests across application servers"},{"id":"b","text":"Cache and serve static content from servers close to users"},{"id":"c","text":"Distribute database writes across multiple regions"},{"id":"d","text":"Encrypt traffic between clients and the origin server"}]'::jsonb,
 'b',
 'A CDN caches assets (images, JS, CSS) at edge nodes geographically close to users, reducing latency and origin load. It does not handle write distribution, request routing to app servers, or encryption on its own.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'EASY',
 'What is a load balancer''s core function?',
 '[{"id":"a","text":"Cache database query results"},{"id":"b","text":"Encrypt traffic between services"},{"id":"c","text":"Persist user session data"},{"id":"d","text":"Distribute incoming requests across multiple servers"}]'::jsonb,
 'd',
 'A load balancer routes each incoming request to one of several backend servers to spread load and improve availability. Caching, session storage, and encryption are separate concerns handled by other components.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'EASY',
 'What is a cache hit?',
 '[{"id":"a","text":"The requested data is found in the cache"},{"id":"b","text":"The cache evicts an item to make room"},{"id":"c","text":"The request bypasses the cache and goes to the database"},{"id":"d","text":"The cache and database are in sync"}]'::jsonb,
 'a',
 'A cache hit means the data was present in the cache, avoiding a slower database call. A cache miss means the data was not found, requiring a fetch from the underlying store.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'EASY',
 'What do the three letters in the CAP theorem stand for?',
 '[{"id":"a","text":"Caching, Availability, Persistence"},{"id":"b","text":"Concurrency, Atomicity, Performance"},{"id":"c","text":"Consistency, Availability, Partition tolerance"},{"id":"d","text":"Consistency, Atomicity, Partitioning"}]'::jsonb,
 'c',
 'CAP stands for Consistency (every read gets the latest write), Availability (every request gets a response), and Partition tolerance (the system continues despite network splits). You can guarantee at most two during a partition.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'EASY',
 'What problem does a message queue primarily solve in a distributed system?',
 '[{"id":"a","text":"Routes HTTP requests to the correct service"},{"id":"b","text":"Decouples producers from consumers so they can work at different rates"},{"id":"c","text":"Provides persistent storage for relational data"},{"id":"d","text":"Synchronises clocks across distributed nodes"}]'::jsonb,
 'b',
 'A message queue buffers messages so producers can publish without waiting for consumers to process them, absorbing traffic spikes and decoupling service lifecycles. It is not a database, a clock sync tool, or an HTTP router.',
 true);

-- ============================== MEDIUM (8) ==============================

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'MEDIUM',
 'A read-heavy API is hitting database capacity limits. What is the most direct first step to scale reads?',
 '[{"id":"a","text":"Add read replicas and route read queries to them"},{"id":"b","text":"Enable full-text search on all columns"},{"id":"c","text":"Increase the primary database''s CPU and RAM"},{"id":"d","text":"Shard the database across multiple primary nodes"}]'::jsonb,
 'a',
 'Read replicas offload SELECT queries from the primary at low cost and risk. Sharding is a larger architectural change best deferred until replicas are insufficient. Vertical scaling has a ceiling; full-text indexing addresses query type, not throughput.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'MEDIUM',
 'In a write-through cache strategy, what happens when data is written?',
 '[{"id":"a","text":"Data is written to the cache; the database is never updated"},{"id":"b","text":"Data is written to the cache only; the database is updated lazily"},{"id":"c","text":"Data is written directly to the database; the cache is updated on the next read"},{"id":"d","text":"Data is written to the cache and the database simultaneously"}]'::jsonb,
 'd',
 'Write-through keeps the cache and database in sync on every write, reducing stale reads at the cost of write latency. Write-behind (lazy) risks data loss. Cache-aside updates the cache on read, not write.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'MEDIUM',
 'Your service needs to send one million notification emails after a large event. Why should this be processed asynchronously via a queue rather than synchronously in the request handler?',
 '[{"id":"a","text":"It guarantees emails are delivered in alphabetical order"},{"id":"b","text":"It prevents the request from timing out and decouples email throughput from the API"},{"id":"c","text":"It ensures emails are encrypted before delivery"},{"id":"d","text":"It reduces the size of each email payload"}]'::jsonb,
 'b',
 'Sending a million emails synchronously would far exceed any HTTP timeout and block the thread. Offloading to a queue lets the API respond instantly. Encryption, ordering, and payload size are unrelated to sync vs async.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'MEDIUM',
 'When is a least-connections load balancing algorithm preferable to round-robin?',
 '[{"id":"a","text":"When the server pool is homogeneous and stateless"},{"id":"b","text":"When sticky sessions are required"},{"id":"c","text":"When requests have highly variable processing times"},{"id":"d","text":"When all requests take roughly the same time to process"}]'::jsonb,
 'c',
 'Least-connections routes to the server with the fewest active connections, preventing slow-request buildup on one node when latency varies. Round-robin works well when request cost is uniform. Neither specifically helps with sticky sessions.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'MEDIUM',
 'A token bucket rate limiter allows bursting while a fixed-window limiter does not. What problem does the fixed-window approach suffer from that the token bucket avoids?',
 '[{"id":"a","text":"Boundary bursts — a client can double the limit by sending requests at the end and start of adjacent windows"},{"id":"b","text":"It requires a distributed lock for every request"},{"id":"c","text":"It cannot enforce per-user limits"},{"id":"d","text":"It permits unlimited requests within the window"}]'::jsonb,
 'a',
 'With a fixed window a client can send n requests just before reset and n more just after, effectively sending 2n in a short period. A token bucket or sliding window avoids this by smoothing the rate over time.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'MEDIUM',
 'Which type of database sharding assigns rows based on a hash of the key rather than a value range?',
 '[{"id":"a","text":"Directory sharding"},{"id":"b","text":"Geo sharding"},{"id":"c","text":"Range sharding"},{"id":"d","text":"Hash sharding"}]'::jsonb,
 'd',
 'Hash sharding applies a hash function to the key and routes to the shard based on the result, distributing data more evenly. Range sharding partitions by value ranges and is prone to hotspots if writes are skewed.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'MEDIUM',
 'Why do stateless services scale horizontally more easily than stateful ones?',
 '[{"id":"a","text":"Stateless services do not require a database"},{"id":"b","text":"Any node can handle any request because no session data is held in memory"},{"id":"c","text":"Stateless services use less CPU than stateful ones"},{"id":"d","text":"Load balancers can only route to stateless backends"}]'::jsonb,
 'b',
 'Because a stateless service keeps no session state in memory, any node is equivalent and the load balancer can route freely. Stateful services require sticky sessions or shared state coordination.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'MEDIUM',
 'A cache entry has a TTL of 60 seconds. A cached item is updated in the database. What is the worst-case duration of stale reads?',
 '[{"id":"a","text":"Zero — TTL eviction is immediate on DB write"},{"id":"b","text":"Until the service restarts"},{"id":"c","text":"Up to 60 seconds"},{"id":"d","text":"Up to 120 seconds due to cache replication lag"}]'::jsonb,
 'c',
 'With TTL-based expiry only, the cache serves the old value until the TTL expires — up to 60 seconds. Immediate eviction on write requires an explicit invalidation call, not just a TTL.',
 true);

-- ============================== HARD (6) ==============================

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'HARD',
 'A payment processing system experiences a network partition between two data centers. According to CAP theorem, what is the correct trade-off?',
 '[{"id":"a","text":"Sacrifice partition tolerance — prevent the partition from occurring"},{"id":"b","text":"Achieve all three — use a saga pattern to satisfy CAP simultaneously"},{"id":"c","text":"Sacrifice consistency — allow both data centers to accept writes and reconcile later"},{"id":"d","text":"Sacrifice availability — reject or queue requests to prevent inconsistent balances"}]'::jsonb,
 'd',
 'Financial data requires strong consistency — showing a wrong balance is worse than an error message. So during a partition, a CP system rejects or defers writes rather than risk divergent state. You cannot prevent partitions in a distributed system; the saga pattern coordinates transactions but does not override CAP.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'HARD',
 'A hot cache key expires and dozens of threads simultaneously miss the cache and query the database. What pattern prevents this cache stampede?',
 '[{"id":"a","text":"Increasing the TTL to avoid expiration"},{"id":"b","text":"Probabilistic early expiration — refresh the key slightly before it expires"},{"id":"c","text":"Switching from LRU to LFU eviction"},{"id":"d","text":"Using a write-behind cache to delay database writes"}]'::jsonb,
 'b',
 'Probabilistic early expiration refreshes the cache before expiry so a miss never happens simultaneously for many requests. Longer TTLs increase staleness; write-behind addresses write latency, not read stampedes; eviction policy does not prevent simultaneous misses.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'HARD',
 'Why is consistent hashing preferred over modular hashing (key mod N) when nodes are added or removed from a cache cluster?',
 '[{"id":"a","text":"Consistent hashing eliminates the need for a hash function"},{"id":"b","text":"Modular hashing cannot distribute keys across more than one node"},{"id":"c","text":"Consistent hashing remaps only ~1/N of keys per change, while modular hashing remaps almost all keys"},{"id":"d","text":"Consistent hashing guarantees zero cache misses during rebalancing"}]'::jsonb,
 'c',
 'With modular hashing, adding or removing a node changes N and remaps nearly every key, causing a mass cache miss storm. Consistent hashing places keys and nodes on a ring so only ~1/N of keys move. It still uses a hash function and still causes some misses.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'HARD',
 'In a microservices architecture, why is a database-per-service pattern preferred over a shared database, even though it introduces data duplication?',
 '[{"id":"a","text":"It enforces service boundaries, allows independent schema changes, and prevents tight coupling through the database layer"},{"id":"b","text":"It reduces total data storage requirements across the system"},{"id":"c","text":"It eliminates the need for any inter-service communication"},{"id":"d","text":"It guarantees strong consistency across services without distributed transactions"}]'::jsonb,
 'a',
 'A shared database creates hidden coupling — any service can read or alter another''s schema, breaking independent deployability. Database-per-service enforces bounded contexts but increases storage and typically requires eventual consistency via events.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'HARD',
 'A system processes 10k writes per second and downstream consumers cannot keep up. Which architectural decision best decouples producers from consumers while preserving message ordering per user?',
 '[{"id":"a","text":"Scale consumers until they match producer throughput"},{"id":"b","text":"Switch to synchronous request-response so ordering is implicit"},{"id":"c","text":"Use a single global queue and instruct consumers to process in arrival order"},{"id":"d","text":"Partition the message queue by user ID so ordering is guaranteed within a partition"}]'::jsonb,
 'd',
 'Partitioning by user ID (as in Kafka) ensures all messages for a given user flow through one partition in order, while different users'' messages are processed in parallel. A single queue is a bottleneck; matching consumer throughput does not guarantee ordering; synchronous calls defeat decoupling.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'SYSTEM_DESIGN', 'HARD',
 'You are designing an API gateway that must enforce a global rate limit of 1000 req/s across 20 horizontally scaled gateway nodes. What is the main challenge?',
 '[{"id":"a","text":"HTTP does not carry enough metadata to identify the client"},{"id":"b","text":"Each node only sees its own traffic, so local counters would allow 20x the intended limit"},{"id":"c","text":"The load balancer must pin each client to one gateway node permanently"},{"id":"d","text":"Rate limiting is impossible without a single gateway node"}]'::jsonb,
 'b',
 'With 20 nodes and local counters, each node allows 1000 req/s, yielding a true limit of 20k req/s. The solution is a shared counter in a fast store (e.g., Redis). HTTP headers carry client identity; sticky sessions are one workaround but break other properties.',
 true);
