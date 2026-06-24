-- Question seed: Concurrency & Parallelism (CONCURRENCY_AND_PARALLELISM)
--
-- Boundary rule: threads, processes, locks/mutexes/semaphores, race conditions,
-- deadlocks, thread pools, async I/O vs blocking I/O, Java concurrency utilities
-- (ExecutorService, CompletableFuture, synchronized, volatile, AtomicInteger,
-- ConcurrentHashMap), event-driven vs multi-threaded models, and the Java memory
-- model live HERE.
-- Database transactions/isolation belong in DATABASES_AND_SQL.
-- Message queues at architectural scale belong in SYSTEM_DESIGN.
--
-- Run manually once after Hibernate has created the questions table:
--   psql "$DATABASE_URL" -f src/main/resources/db/questions_seed_concurrency_parallelism.sql
--
-- NOT idempotent — running twice inserts duplicates. Apply once per environment.
-- 20 questions: 6 EASY / 8 MEDIUM / 6 HARD. Single-select, one defensible answer.
-- Correct answer distribution: a=5, b=5, c=5, d=5

-- ============================== EASY (6) ==============================

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'EASY',
 'What is a race condition?',
 '[{"id":"a","text":"A bug where the program outcome depends on the non-deterministic ordering of concurrent operations accessing shared state"},{"id":"b","text":"A performance problem caused by two threads executing the same code at the same time"},{"id":"c","text":"A deadlock where two threads wait for each other indefinitely"},{"id":"d","text":"A condition where one thread always runs faster than others in the same pool"}]'::jsonb,
 'a',
 'A race condition occurs when the correctness of a computation depends on the timing or interleaving of operations — different orderings produce different (and potentially wrong) results. The fix is synchronisation that enforces a deterministic ordering.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'EASY',
 'What is the difference between a mutex and a semaphore?',
 '[{"id":"a","text":"A mutex allows multiple threads to acquire it simultaneously; a semaphore allows only one"},{"id":"b","text":"A mutex is used for inter-process communication; a semaphore is for intra-thread signalling"},{"id":"c","text":"A mutex allows only one thread at a time and must be released by the acquiring thread; a semaphore can allow a configurable number of concurrent holders"},{"id":"d","text":"A semaphore blocks the entire CPU core; a mutex only blocks the waiting thread"}]'::jsonb,
 'c',
 'A mutex (binary semaphore with ownership) enforces mutual exclusion: only the locking thread may unlock it. A counting semaphore tracks a resource count — multiple threads can hold it up to the limit. Semaphores are also used for signalling between threads.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'EASY',
 'What does Java''s `synchronized` keyword do when applied to an instance method?',
 '[{"id":"a","text":"It schedules the method to run on a dedicated background thread from the common pool"},{"id":"b","text":"It acquires the intrinsic lock of the object before the method body runs and releases it on exit, preventing concurrent execution by other threads"},{"id":"c","text":"It converts the method into an asynchronous operation that returns a Future"},{"id":"d","text":"It ensures the method is called only once per JVM lifetime"}]'::jsonb,
 'b',
 'synchronized on an instance method locks on `this`. Only one thread can hold an object''s intrinsic lock at a time, so concurrent callers of synchronized methods on the same instance are serialised. synchronized on a static method locks on the Class object.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'EASY',
 'What is the key difference between concurrency and parallelism?',
 '[{"id":"a","text":"Concurrency requires multiple CPU cores; parallelism works on a single core"},{"id":"b","text":"Parallelism means tasks share memory; concurrency means tasks have separate memory spaces"},{"id":"c","text":"Concurrency and parallelism mean the same thing — tasks run simultaneously"},{"id":"d","text":"Concurrency means tasks make progress by interleaving (possibly on one core); parallelism means tasks literally execute at the same instant on multiple cores"}]'::jsonb,
 'd',
 'A single-core CPU can be concurrent (context-switching between tasks) but not truly parallel. Parallelism requires multiple processing units. Concurrent code is often written to be parallel-friendly, but the concepts are distinct.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'EASY',
 'What is the primary benefit of using a thread pool over creating a new thread for every task?',
 '[{"id":"a","text":"Thread pools reuse a fixed set of threads, avoiding the overhead of creation and destruction per task and bounding resource consumption"},{"id":"b","text":"Thread pools guarantee tasks complete in the order they were submitted"},{"id":"c","text":"Thread pools automatically parallelise tasks across all available CPU cores without any configuration"},{"id":"d","text":"Thread pools eliminate race conditions by serialising all submitted tasks"}]'::jsonb,
 'a',
 'Thread creation is expensive (stack allocation, OS scheduling). A pool pre-creates threads and queues tasks to them, capping the number of live threads. This prevents thread exhaustion under load and reduces per-task latency.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'EASY',
 'What does the `volatile` keyword guarantee in Java?',
 '[{"id":"a","text":"It makes the variable immutable after its first assignment"},{"id":"b","text":"It synchronises the variable using a mutex, preventing concurrent access"},{"id":"c","text":"It guarantees that reads and writes go directly to main memory, preventing threads from using a stale CPU-cached value"},{"id":"d","text":"It converts a primitive variable into an atomic compare-and-swap operation"}]'::jsonb,
 'c',
 'volatile enforces memory visibility: every write is flushed to main memory and every read fetches from main memory. It does NOT make compound operations atomic (e.g., i++ is still a race condition on a volatile). Use AtomicInteger or synchronized for atomicity.',
 true);

-- ============================== MEDIUM (8) ==============================

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'MEDIUM',
 'What are the four Coffman conditions all required for a deadlock to occur?',
 '[{"id":"a","text":"Starvation, priority inversion, mutual exclusion, and livelock"},{"id":"b","text":"Mutual exclusion, hold and wait, no preemption, and circular wait"},{"id":"c","text":"Race condition, context switch, lock contention, and thread exhaustion"},{"id":"d","text":"Resource starvation, thread blocking, busy-waiting, and lock timeout"}]'::jsonb,
 'b',
 'All four must hold simultaneously: (1) mutual exclusion — a resource can only be held by one thread; (2) hold and wait — holding one resource while waiting for another; (3) no preemption — resources cannot be forcibly taken; (4) circular wait — a cycle of threads each waiting for the next.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'MEDIUM',
 'What is the difference between `ExecutorService.submit()` and `ExecutorService.execute()` in Java?',
 '[{"id":"a","text":"submit() blocks until the task completes; execute() submits and returns immediately"},{"id":"b","text":"execute() is for Callable tasks; submit() is only for Runnable tasks"},{"id":"c","text":"submit() runs the task synchronously on the calling thread; execute() offloads it to the pool"},{"id":"d","text":"submit() returns a Future for retrieving the result or detecting exceptions; execute() accepts only Runnable and returns void"}]'::jsonb,
 'd',
 'submit() accepts both Runnable and Callable and returns a Future — you can call .get() to block for the result or catch exceptions. execute() accepts only Runnable and returns nothing; unchecked exceptions thrown by the task are swallowed by the default handler.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'MEDIUM',
 'How does `CompletableFuture.thenCompose` differ from `thenApply`?',
 '[{"id":"a","text":"thenCompose runs the next stage synchronously; thenApply always runs it asynchronously"},{"id":"b","text":"thenApply chains stages that return CompletableFutures; thenCompose chains simple value transformations"},{"id":"c","text":"thenApply transforms the result with a plain function; thenCompose chains a function that returns a CompletableFuture, flatly unwrapping it to avoid nested futures"},{"id":"d","text":"thenCompose is used only for error handling; thenApply is used for the success path"}]'::jsonb,
 'c',
 'thenApply is like map: it transforms the value. thenCompose is like flatMap: when the next step itself returns a CompletableFuture, thenCompose unwraps it — preventing CompletableFuture<CompletableFuture<T>>.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'MEDIUM',
 'Why is `ConcurrentHashMap` preferred over a `Collections.synchronizedMap` wrapper in high-concurrency Java code?',
 '[{"id":"a","text":"ConcurrentHashMap uses fine-grained (bucket-level) locking, allowing concurrent reads and independent writes to different buckets; synchronizedMap locks the entire map for every operation"},{"id":"b","text":"ConcurrentHashMap stores values in off-heap memory, reducing garbage collection pressure"},{"id":"c","text":"ConcurrentHashMap allows null keys and values; synchronizedMap prohibits them"},{"id":"d","text":"ConcurrentHashMap avoids garbage collection pauses by reusing internal bucket arrays"}]'::jsonb,
 'a',
 'synchronizedMap wraps every method in a single mutex — reads block writes and vice versa. ConcurrentHashMap segments its buckets so concurrent reads never block and concurrent writes to different buckets proceed in parallel, giving much higher throughput.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'MEDIUM',
 'What is busy-waiting and why is it problematic?',
 '[{"id":"a","text":"Busy-waiting is when a thread holds a lock longer than expected, causing other threads to queue"},{"id":"b","text":"Busy-waiting occurs when too many threads are created, exhausting system memory"},{"id":"c","text":"Busy-waiting is a deadlock variant where one thread is perpetually preempted by another"},{"id":"d","text":"Busy-waiting is a loop where a thread continuously checks a condition without yielding — it consumes CPU cycles that other threads or processes could use"}]'::jsonb,
 'd',
 'Busy-waiting (spin-waiting) burns CPU while the condition is unsatisfied. It can be appropriate for very short waits on multicore systems (spin locks), but generally blocking primitives (wait/notify, LockSupport.park) are preferred because they yield the CPU.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'MEDIUM',
 'When should you use `AtomicInteger` instead of a `synchronized` int counter in Java?',
 '[{"id":"a","text":"AtomicInteger should always replace synchronized counters because it is faster in all scenarios"},{"id":"b","text":"AtomicInteger is appropriate for isolated operations like increment, decrement, or compare-and-swap on a single variable, avoiding lock acquisition overhead"},{"id":"c","text":"AtomicInteger is required when the counter is shared between OS processes, not just threads"},{"id":"d","text":"AtomicInteger is only useful when the counter value exceeds Integer.MAX_VALUE / 2"}]'::jsonb,
 'b',
 'AtomicInteger uses hardware CAS (compare-and-swap) instructions — no lock acquisition or context switch. For single-variable atomic operations it is faster and simpler. But when you need atomicity across multiple variables, synchronized (or a lock) is still required.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'MEDIUM',
 'In the Java Memory Model, what does the "happens-before" relationship guarantee?',
 '[{"id":"a","text":"It guarantees that code executes in the exact top-to-bottom order it appears in source"},{"id":"b","text":"It means any thread can see any write made by any other thread at any time"},{"id":"c","text":"If action A happens-before action B, all memory writes visible to A are guaranteed to be visible to B — even across threads"},{"id":"d","text":"Happens-before guarantees that locks are acquired in the order they are declared"}]'::jsonb,
 'c',
 'Happens-before is the JMM''s formal mechanism for reasoning about memory visibility. A synchronized block, volatile write, or thread start establishes a happens-before edge. Without it, a thread may see stale values due to CPU caches or reordering.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'MEDIUM',
 'A method reads a volatile field, increments it, and writes it back. Why is this still a race condition despite volatile?',
 '[{"id":"a","text":"volatile fields are read-only once written; the write throws an exception"},{"id":"b","text":"volatile prevents the JVM from optimising the increment, making it slower but not a race condition"},{"id":"c","text":"The read and write are each individually atomic on volatile fields, so there is no race condition"},{"id":"d","text":"volatile guarantees visibility but not atomicity — the three-step read-increment-write is not a single atomic operation, so two threads can interleave and lose an update"}]'::jsonb,
 'd',
 'volatile ensures each read/write is individually atomic and visible, but i++ is three operations: read, add 1, write. Two threads can both read the same value, both compute value+1, and both write the same result — losing one increment. Use AtomicInteger.incrementAndGet() instead.',
 true);

-- ============================== HARD (6) ==============================

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'HARD',
 'How can you break the "circular wait" Coffman condition to prevent deadlocks when multiple threads need the same locks?',
 '[{"id":"a","text":"Enforce a consistent global lock ordering — all threads must always acquire locks in the same predefined sequence, eliminating the possibility of a circular dependency"},{"id":"b","text":"Use try-lock with a timeout and retry indefinitely until all locks are acquired"},{"id":"c","text":"Increase the thread pool size so the probability of circular wait is statistically negligible"},{"id":"d","text":"Replace all locks with volatile variables so no thread ever blocks"}]'::jsonb,
 'a',
 'If every thread acquires Lock A before Lock B before Lock C, no thread can be waiting for A while holding B — breaking circular wait. Timeouts reduce the duration of deadlocks but do not prevent them. volatile does not provide mutual exclusion.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'HARD',
 'For I/O-bound tasks (HTTP calls, file reads), why is an async/non-blocking model more resource-efficient than a thread-per-request model?',
 '[{"id":"a","text":"The event loop runs on multiple CPU cores simultaneously while platform threads are restricted to one core"},{"id":"b","text":"In a thread-per-request model, threads block waiting for I/O while consuming stack memory; async/non-blocking models resume work on the same thread when I/O completes, multiplexing many requests over a small thread pool"},{"id":"c","text":"Async models guarantee stronger data consistency because all operations execute sequentially on one thread"},{"id":"d","text":"Thread-per-request has O(n^2) overhead for thread creation when n requests arrive concurrently"}]'::jsonb,
 'b',
 'A blocked thread occupies ~1 MB of stack and a kernel scheduling slot while doing nothing. Non-blocking I/O parks the logical task and frees the thread to serve other requests. At 10k concurrent I/O-bound requests, this is the difference between 10 GB and a handful of threads.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'HARD',
 'Java 21 introduced virtual threads. What is their key difference from platform (OS) threads?',
 '[{"id":"a","text":"Virtual threads run entirely in user space and completely bypass the OS scheduler"},{"id":"b","text":"Virtual threads are pinned to a single CPU core, eliminating context-switching overhead"},{"id":"c","text":"Virtual threads are capped at 10,000 per JVM to prevent memory exhaustion"},{"id":"d","text":"Virtual threads are JVM-managed — they are extremely cheap to create (millions are feasible) and automatically unmount from their carrier OS thread when blocking, allowing a small pool of OS threads to serve many concurrent tasks"}]'::jsonb,
 'd',
 'Platform threads have a 1:1 mapping with OS threads — expensive to create and blocked threads waste OS resources. Virtual threads are multiplexed onto a small carrier pool. When a virtual thread blocks on I/O, the JVM parks it and lets the carrier thread run another virtual thread.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'HARD',
 'The double-checked locking pattern for a Singleton requires the instance field to be `volatile`. Why?',
 '[{"id":"a","text":"volatile ensures only one instance is created by preventing concurrent class loading"},{"id":"b","text":"volatile makes the null-check and assignment a single atomic operation"},{"id":"c","text":"Without volatile, the JVM may reorder the write so the reference is published before the constructor body completes, allowing another thread to observe a partially initialised object"},{"id":"d","text":"volatile is needed to flush the singleton reference to disk so it survives JVM restarts"}]'::jsonb,
 'c',
 'Object publication without synchronisation or volatile is unsafe because the JVM can reorder the store to the field with stores inside the constructor. A thread that reads a non-null reference may still see default field values. volatile establishes a happens-before edge on the write.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'HARD',
 'A thread pool sized at N = number of CPU cores performs poorly when used for I/O-bound tasks. Why?',
 '[{"id":"a","text":"I/O-bound tasks block threads waiting for I/O, leaving CPU cores idle — a larger pool (or async I/O) is needed to keep CPUs busy while some threads wait"},{"id":"b","text":"CPU-bound pools use a round-robin scheduler that is incompatible with I/O task priorities"},{"id":"c","text":"I/O-bound tasks require more stack memory per thread than the pool''s configured limit allows"},{"id":"d","text":"CPU-bound pools acquire exclusive access to disk I/O channels, starving other tasks of I/O bandwidth"}]'::jsonb,
 'a',
 'The N-cores heuristic assumes threads are always computing. For I/O-bound tasks, threads spend most time blocked — the CPU is idle. The heuristic is N_threads = N_cores * (1 + wait_time / compute_time). High wait ratios require much larger pools.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'CONCURRENCY_AND_PARALLELISM', 'HARD',
 'Thread starvation differs from deadlock. What causes thread starvation?',
 '[{"id":"a","text":"Starvation occurs when all threads are blocked waiting for a lock held by a thread that has already terminated"},{"id":"b","text":"Starvation is when low-priority threads never get CPU time because high-priority threads or an unfair lock implementation continuously monopolise execution"},{"id":"c","text":"Starvation occurs when a thread acquires too many locks and the JVM forces it to release them"},{"id":"d","text":"Starvation happens when the thread pool queue overflows and incoming tasks are silently dropped"}]'::jsonb,
 'b',
 'In a deadlock, threads are mutually blocked and no one makes progress. In starvation, some threads make progress but one or more never get scheduled — typically due to unfair lock acquisition or high-priority threads consuming all available CPU. Java''s ReentrantLock has a fair mode to mitigate this.',
 true);
