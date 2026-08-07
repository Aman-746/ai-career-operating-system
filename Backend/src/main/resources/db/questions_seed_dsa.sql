-- Question seed: Data Structures & Algorithms (DATA_STRUCTURES_ALGORITHMS)
--
-- Run manually once after Hibernate has created the questions table:
--   psql "$DATABASE_URL" -f src/main/resources/db/questions_seed_dsa.sql
--
-- NOT idempotent — running twice inserts duplicates. Apply once per environment.
-- 20 questions: 6 EASY / 8 MEDIUM / 6 HARD. Single-select, one defensible answer.
-- Correct answer distribution: a=4, b=5, c=5, d=6

-- ============================== EASY (6) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'EASY',
 'What is the time complexity of accessing an array element by its index?',
 '[{"id":"a","text":"O(n)"},{"id":"b","text":"O(log n)"},{"id":"c","text":"O(1)"},{"id":"d","text":"O(n log n)"}]'::jsonb,
 'c',
 'Arrays provide constant-time random access by computing base address + (index x element size). O(n) and O(n log n) describe search or sort costs; O(log n) describes binary search — none apply to indexed access.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'EASY',
 'Which data structure follows Last-In-First-Out (LIFO) ordering?',
 '[{"id":"a","text":"Queue"},{"id":"b","text":"Stack"},{"id":"c","text":"Binary search tree"},{"id":"d","text":"Linked list"}]'::jsonb,
 'b',
 'A stack pushes and pops at the same end, so the last element added is the first removed (LIFO). A queue is FIFO; the others are not defined by LIFO ordering.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'EASY',
 'What is the average-case time complexity of a lookup in a hash table?',
 '[{"id":"a","text":"O(log n)"},{"id":"b","text":"O(n^2)"},{"id":"c","text":"O(n)"},{"id":"d","text":"O(1)"}]'::jsonb,
 'd',
 'With a good hash function and a reasonable load factor, lookups are constant time on average. Worst case degrades to O(n) under heavy collisions, but the average case is O(1).',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'EASY',
 'Binary search on a sorted array of n elements runs in what time?',
 '[{"id":"a","text":"O(log n)"},{"id":"b","text":"O(n)"},{"id":"c","text":"O(1)"},{"id":"d","text":"O(n log n)"}]'::jsonb,
 'a',
 'Binary search halves the remaining search space on each comparison, giving logarithmic time. It requires the array to already be sorted; O(n) is linear scan; O(1) would be direct access.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'EASY',
 'Which data structure processes elements in First-In-First-Out (FIFO) order?',
 '[{"id":"a","text":"Heap"},{"id":"b","text":"Hash map"},{"id":"c","text":"Stack"},{"id":"d","text":"Queue"}]'::jsonb,
 'd',
 'A queue enqueues at the rear and dequeues from the front, so the first element added is the first removed (FIFO). A stack is LIFO; a heap is ordered by priority; a hash map has no ordering.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'EASY',
 'What is the worst-case time to determine whether a value exists in an UNSORTED array of n elements?',
 '[{"id":"a","text":"O(1)"},{"id":"b","text":"O(n)"},{"id":"c","text":"O(log n)"},{"id":"d","text":"O(n log n)"}]'::jsonb,
 'b',
 'With no ordering to exploit, you may have to scan every element, giving linear worst-case time. Binary search O(log n) only applies to sorted data; O(1) requires a hash structure.',
 true);

-- ============================== MEDIUM (8) ==============================

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'MEDIUM',
 'Which technique detects a cycle in a singly linked list using O(1) extra space?',
 '[{"id":"a","text":"Reversing the list in place"},{"id":"b","text":"Sorting nodes by their memory address"},{"id":"c","text":"Storing visited nodes in a hash set"},{"id":"d","text":"Floyd''s slow and fast pointers"}]'::jsonb,
 'd',
 'Floyd''s two-pointer (tortoise and hare) approach detects a cycle in O(1) space. A hash set also works but uses O(n) space; reversing and sorting do not reliably detect cycles.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'MEDIUM',
 'Which combination of structures supports an LRU cache with O(1) get and put?',
 '[{"id":"a","text":"Hash map + doubly linked list"},{"id":"b","text":"Singly linked list only"},{"id":"c","text":"Sorted array + binary search"},{"id":"d","text":"Min-heap + hash map"}]'::jsonb,
 'a',
 'The hash map gives O(1) key lookup and the doubly linked list gives O(1) removal and move-to-front for recency. A heap would make updates O(log n); a sorted array makes updates O(n).',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'MEDIUM',
 'Merging two already-sorted arrays of sizes n and m into one sorted array takes what time?',
 '[{"id":"a","text":"O(n log m)"},{"id":"b","text":"O(n * m)"},{"id":"c","text":"O(n + m)"},{"id":"d","text":"O((n + m) log(n + m))"}]'::jsonb,
 'c',
 'A single linear pass with two pointers compares and copies each element once, giving O(n + m). Re-sorting from scratch would be the log-linear option, but it is unnecessary when both inputs are already sorted.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'MEDIUM',
 'In an UNWEIGHTED graph, which algorithm finds the shortest path (fewest edges) between two nodes?',
 '[{"id":"a","text":"In-order traversal"},{"id":"b","text":"Breadth-first search"},{"id":"c","text":"Topological sort"},{"id":"d","text":"Depth-first search"}]'::jsonb,
 'b',
 'BFS explores nodes in order of distance, so it reaches each node via the fewest edges first. DFS does not guarantee shortest paths; topological sort requires a DAG; in-order traversal is for binary trees.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'MEDIUM',
 'What is the time complexity of extracting the minimum element from a binary min-heap of n elements?',
 '[{"id":"a","text":"O(log n)"},{"id":"b","text":"O(n log n)"},{"id":"c","text":"O(n)"},{"id":"d","text":"O(1)"}]'::jsonb,
 'a',
 'Extraction removes the root and sifts the replacement down the tree height, which is O(log n). Peeking at the minimum without removing it is O(1), but extraction requires re-heapifying.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'MEDIUM',
 'Which approach finds the k-th largest element in an unsorted array with the best AVERAGE time?',
 '[{"id":"a","text":"Fully sort the array, then index (O(n log n))"},{"id":"b","text":"Binary search over the array values (O(log n))"},{"id":"c","text":"A single linear scan tracking one maximum (O(n))"},{"id":"d","text":"Quickselect (average O(n))"}]'::jsonb,
 'd',
 'Quickselect partitions around a pivot to locate the k-th order statistic in O(n) average time. Sorting is O(n log n); a single-max scan only finds the 1st largest; binary search needs sorted data.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'MEDIUM',
 'Which sorting algorithm is stable AND guarantees O(n log n) in the worst case?',
 '[{"id":"a","text":"Quicksort"},{"id":"b","text":"Merge sort"},{"id":"c","text":"Heapsort"},{"id":"d","text":"Selection sort"}]'::jsonb,
 'b',
 'Merge sort preserves the relative order of equal keys (stable) and is O(n log n) even in the worst case. Quicksort is O(n^2) worst case and unstable; heapsort is unstable; selection sort is O(n^2).',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'MEDIUM',
 'What is the most time-efficient way to check whether any two numbers in an unsorted array sum to a given target?',
 '[{"id":"a","text":"Sort, then use two pointers (O(n log n))"},{"id":"b","text":"Check every pair with two nested loops (O(n^2))"},{"id":"c","text":"Sort, then binary search each complement (O(n log n))"},{"id":"d","text":"One pass with a hash set (O(n))"}]'::jsonb,
 'd',
 'A single pass storing seen values in a hash set lets you check each complement in O(1), giving O(n) overall. Sort-based approaches are correct but slower at O(n log n); brute force is O(n^2).',
 true);

-- ============================== HARD (6) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'HARD',
 'After counting frequencies, returning the k most frequent elements using a size-k heap over up to n distinct keys costs what time?',
 '[{"id":"a","text":"O(n log n)"},{"id":"b","text":"O(k log n)"},{"id":"c","text":"O(n log k)"},{"id":"d","text":"O(n)"}]'::jsonb,
 'c',
 'Each of up to n distinct keys is pushed against a heap capped at size k, costing O(log k) per operation, so O(n log k) overall. A full sort is O(n log n); guaranteed O(n) needs bucket sort, not a heap.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'HARD',
 'A dynamic array doubles its capacity when full. What is the amortized time per append?',
 '[{"id":"a","text":"O(log n) amortized"},{"id":"b","text":"O(1) amortized"},{"id":"c","text":"O(n) amortized"},{"id":"d","text":"O(n) per append"}]'::jsonb,
 'b',
 'Although an individual resize copies all elements in O(n), doubling makes resizes exponentially rare. The total copy cost across n appends is O(n), so each append is O(1) amortized.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'HARD',
 'For a graph with V vertices and E edges where E is far smaller than V^2 (sparse), which representation minimises space?',
 '[{"id":"a","text":"Adjacency matrix, O(V^2)"},{"id":"b","text":"A V x V weight matrix"},{"id":"c","text":"Adjacency list, O(V + E)"},{"id":"d","text":"A V x V boolean grid"}]'::jsonb,
 'c',
 'An adjacency list stores only existing edges, using O(V + E) space, which is far smaller for sparse graphs. All matrix forms use O(V^2) regardless of how few edges exist.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'HARD',
 'A problem exhibits both optimal substructure AND overlapping subproblems. Which technique is most appropriate?',
 '[{"id":"a","text":"A greedy algorithm"},{"id":"b","text":"Plain divide and conquer without memoization"},{"id":"c","text":"Brute-force over all permutations"},{"id":"d","text":"Dynamic programming"}]'::jsonb,
 'd',
 'Overlapping subproblems are exactly what dynamic programming exploits by caching solutions. Greedy requires the greedy-choice property (not implied here); plain divide and conquer recomputes overlaps; brute force is exponential.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'HARD',
 'Dijkstra''s algorithm using a binary heap on a graph with V vertices and E edges runs in what time?',
 '[{"id":"a","text":"O(V^2)"},{"id":"b","text":"O(V * E)"},{"id":"c","text":"O((V + E) log V)"},{"id":"d","text":"O(V + E)"}]'::jsonb,
 'c',
 'Each vertex is extracted once and each edge may trigger a heap update, each costing O(log V), giving O((V + E) log V). The O(V^2) figure is the simpler array-based implementation without a heap.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'DATA_STRUCTURES_ALGORITHMS', 'HARD',
 'A recurrence splits a problem into two halves and does O(n) work to combine at each level (e.g. merge sort). By the Master Theorem, its time complexity is?',
 '[{"id":"a","text":"O(n log n)"},{"id":"b","text":"O(n)"},{"id":"c","text":"O(n^2)"},{"id":"d","text":"O(log n)"}]'::jsonb,
 'a',
 'T(n) = 2T(n/2) + O(n) falls into the Master Theorem case where split and combine costs balance, yielding O(n log n) — log n levels each doing O(n) combine work.',
 true);
