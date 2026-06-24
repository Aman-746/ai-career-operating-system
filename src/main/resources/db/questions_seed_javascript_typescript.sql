-- Question seed: JavaScript & TypeScript (JAVASCRIPT_AND_TYPESCRIPT)
--
-- Boundary rule: JS language features (closures, prototypes, event loop,
-- promises, async/await, hoisting, `this`, generators), ES6+ features
-- (destructuring, spread, arrow functions, optional chaining, nullish
-- coalescing), and the TypeScript type system (generics, utility types,
-- type narrowing, interfaces vs type aliases, declaration merging) live HERE.
-- DOM/browser APIs and framework component patterns belong in FRONTEND_ENGINEERING.
--
-- Run manually once after Hibernate has created the questions table:
--   psql "$DATABASE_URL" -f src/main/resources/db/questions_seed_javascript_typescript.sql
--
-- NOT idempotent — running twice inserts duplicates. Apply once per environment.
-- 20 questions: 6 EASY / 8 MEDIUM / 6 HARD. Single-select, one defensible answer.
-- Correct answer distribution: a=5, b=5, c=5, d=5

-- ============================== EASY (6) ==============================

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'EASY',
 'What is a closure in JavaScript?',
 '[{"id":"a","text":"A function that is immediately invoked after it is defined"},{"id":"b","text":"A function that runs in strict mode by default"},{"id":"c","text":"A design pattern for encapsulating private data in a class"},{"id":"d","text":"A function that retains access to variables from its outer (enclosing) scope even after that scope has returned"}]'::jsonb,
 'd',
 'A closure is formed when a function captures variables from its lexical environment. The inner function holds a reference to the outer scope''s variables, keeping them alive even after the outer function has returned.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'EASY',
 'How does `var` differ from `let` in terms of hoisting?',
 '[{"id":"a","text":"var is hoisted and initialised to undefined; let is hoisted but stays in the temporal dead zone until its declaration is reached"},{"id":"b","text":"var is block-scoped; let is function-scoped"},{"id":"c","text":"let can be re-declared in the same scope; var cannot"},{"id":"d","text":"var is not hoisted at all; let is hoisted with its initial value"}]'::jsonb,
 'a',
 'Both var and let are hoisted, but var is initialised to undefined immediately — so accessing it before the declaration works but returns undefined. let is in the temporal dead zone, causing a ReferenceError if accessed before its declaration line.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'EASY',
 'What are the three states a Promise can be in?',
 '[{"id":"a","text":"Open, resolved, errored"},{"id":"b","text":"Created, running, terminated"},{"id":"c","text":"Pending, fulfilled, rejected"},{"id":"d","text":"Waiting, done, failed"}]'::jsonb,
 'c',
 'A Promise starts as pending. It settles to fulfilled (with a value) on success or rejected (with a reason) on failure. Once settled it cannot transition to another state.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'EASY',
 'What does `===` check that `==` does not?',
 '[{"id":"a","text":"Whether two objects reference the same memory address"},{"id":"b","text":"Both value and type — === never coerces types before comparing"},{"id":"c","text":"Whether two values are truthy"},{"id":"d","text":"Whether a value is defined in the current scope"}]'::jsonb,
 'b',
 'The strict equality operator (===) compares value and type without coercion. == applies type coercion first — e.g., "1" == 1 is true. For objects, both check reference equality regardless of ==/',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'EASY',
 'What does `typeof null` return in JavaScript?',
 '[{"id":"a","text":"\"null\""},{"id":"b","text":"\"undefined\""},{"id":"c","text":"\"void\""},{"id":"d","text":"\"object\" — a longstanding language quirk from the original implementation"}]'::jsonb,
 'd',
 'typeof null === "object" is a historical bug in JavaScript that was kept for backwards compatibility. null is not an object; it is a primitive. Use === null to reliably check for null.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'EASY',
 'How does an arrow function differ from a regular function regarding the `this` keyword?',
 '[{"id":"a","text":"Arrow functions do not have their own `this`; they inherit `this` from the enclosing lexical scope at definition time"},{"id":"b","text":"Arrow functions bind `this` to the global object regardless of the call site"},{"id":"c","text":"Arrow functions create a new `this` binding on every call, identical to regular functions"},{"id":"d","text":"Arrow functions only use `this` when explicitly bound with .call() or .apply()"}]'::jsonb,
 'a',
 'Regular functions bind `this` dynamically based on how they are called. Arrow functions capture `this` from the surrounding lexical context when they are defined — useful in callbacks and class methods where you want to preserve the outer `this`.',
 true);

-- ============================== MEDIUM (8) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'MEDIUM',
 'In JavaScript''s event loop, which runs first after the call stack empties — a resolved Promise callback or a setTimeout(fn, 0) callback?',
 '[{"id":"a","text":"setTimeout(fn, 0) always runs first because it was registered before the Promise resolved"},{"id":"b","text":"They run in the order they were registered, regardless of type"},{"id":"c","text":"The Promise callback runs first — Promise callbacks are microtasks, which drain completely before the macrotask queue (where setTimeout resides) is processed"},{"id":"d","text":"Both run simultaneously on separate internal threads"}]'::jsonb,
 'c',
 'The event loop processes all pending microtasks (Promise callbacks, queueMicrotask) after each task completes and before picking the next macrotask (setTimeout, setInterval, I/O). Microtasks always run before the next macrotask.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'MEDIUM',
 'How does JavaScript''s prototype chain work when you access a property not found directly on an object?',
 '[{"id":"a","text":"JavaScript throws a ReferenceError immediately if the property is not own"},{"id":"b","text":"JavaScript traverses the chain of prototype objects (via [[Prototype]]) until it finds the property or reaches null"},{"id":"c","text":"JavaScript copies the property from the nearest ancestor at object creation time"},{"id":"d","text":"JavaScript returns undefined without traversing any prototype chain"}]'::jsonb,
 'b',
 'Property lookup walks the prototype chain: own object → its prototype → prototype''s prototype → ... → Object.prototype → null. The first match is returned; if null is reached, the result is undefined (not an error).',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'MEDIUM',
 'In async/await, how do you correctly catch an error thrown by an awaited Promise?',
 '[{"id":"a","text":"Wrap the await expression in a try/catch block"},{"id":"b","text":"Chain .catch() after the await expression on the same line"},{"id":"c","text":"Pass an error-first callback as the second argument to await"},{"id":"d","text":"Use process.on(\"uncaughtException\") to intercept all Promise rejections"}]'::jsonb,
 'a',
 'When an awaited Promise rejects, it throws at the await point — so a surrounding try/catch is the correct way to handle it. .catch() chained after an await expression chains from undefined (the resolved value), not the Promise.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'MEDIUM',
 'In TypeScript, what does the generic constraint `<T extends Serializable>` mean?',
 '[{"id":"a","text":"T must be a subclass of Serializable at runtime via the class hierarchy"},{"id":"b","text":"T must implement all methods of Serializable exactly once with no overloads"},{"id":"c","text":"T will be serialised to JSON automatically before being passed to the function"},{"id":"d","text":"T must be a type assignable to Serializable — it must have at least the same members (structural subtyping)"}]'::jsonb,
 'd',
 'TypeScript uses structural (duck) typing. `T extends Serializable` constrains T to types that have at least the members of Serializable — it is not about class inheritance at runtime. Any object with the required shape satisfies the constraint.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'MEDIUM',
 'What does the TypeScript utility type `Partial<T>` produce?',
 '[{"id":"a","text":"A new type with all properties of T made required"},{"id":"b","text":"A new type where every property of T becomes optional"},{"id":"c","text":"A new type containing only the string-valued properties of T"},{"id":"d","text":"A type that picks a partial subset of T''s properties that you specify"}]'::jsonb,
 'b',
 'Partial<T> maps every property of T to optional (adds ?). Useful for update payloads or partial config objects. Required<T> does the opposite. Pick<T, K> selects named keys. Record<K, V> creates a mapped type.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'MEDIUM',
 'How does TypeScript''s type narrowing work with `typeof`?',
 '[{"id":"a","text":"typeof at runtime is replaced by a TypeScript-only type guard evaluated only at compile time"},{"id":"b","text":"TypeScript uses typeof to walk the prototype chain of an object"},{"id":"c","text":"Inside a branch where typeof x === \"string\" is true, TypeScript narrows the type of x to string within that scope"},{"id":"d","text":"typeof narrows union types only when all members share the same primitive type"}]'::jsonb,
 'c',
 'TypeScript performs control-flow analysis. After `if (typeof x === "string")`, the compiler knows x is string inside the if block and treats it accordingly, allowing string-specific methods without casting.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'MEDIUM',
 'What is the difference between `Promise.all` and `Promise.allSettled`?',
 '[{"id":"a","text":"Promise.all rejects immediately when any input rejects; Promise.allSettled always resolves with an array of outcome descriptors regardless of rejections"},{"id":"b","text":"Promise.all resolves when one promise resolves; Promise.allSettled resolves only when all resolve"},{"id":"c","text":"Promise.allSettled resolves faster because it does not wait for all promises to complete"},{"id":"d","text":"Promise.all and Promise.allSettled behave identically — they differ only in naming convention"}]'::jsonb,
 'a',
 'Promise.all is fail-fast: one rejection short-circuits the whole result. Promise.allSettled waits for every promise and returns [{status: "fulfilled", value}, {status: "rejected", reason}, ...] — useful when you need all results regardless of individual failures.',
 true);

-- ============================== HARD (6) ==============================

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'HARD',
 'The classic closure-in-a-loop problem: `for (var i = 0; i < 3; i++) { setTimeout(() => console.log(i), 0); }` prints `3 3 3`. Why?',
 '[{"id":"a","text":"setTimeout callbacks are promoted to microtasks, which run after i has incremented past the loop condition"},{"id":"b","text":"var inside a for-loop creates a new variable for each iteration, all initialised to 3"},{"id":"c","text":"Arrow functions capture a snapshot of i''s value at the time setTimeout is called"},{"id":"d","text":"All three closures close over the same single var-scoped i; by the time the callbacks fire, the loop has finished and i is 3"}]'::jsonb,
 'd',
 'var is function-scoped, so there is one shared i. Each callback captures a reference to the same i, not a copy of its current value. By the time the event loop runs the callbacks, the loop has incremented i to 3. Fix: use let (block-scoped, new binding per iteration) or an IIFE.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'HARD',
 'What is a JavaScript generator function used for?',
 '[{"id":"a","text":"Generating cryptographically random values suitable for security contexts"},{"id":"b","text":"Producing a sequence of values lazily, pausing execution at each yield and resuming on the next .next() call"},{"id":"c","text":"Running multiple async operations in parallel using a managed thread pool"},{"id":"d","text":"Creating factory functions that stamp out typed objects at runtime"}]'::jsonb,
 'b',
 'A generator (function*) returns an iterator. Each yield suspends the function and hands a value to the caller. Execution resumes from the same point on the next .next() call. Useful for lazy sequences, infinite streams, and implementing async iterators.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'HARD',
 'In TypeScript, what is a discriminated union and why is it useful?',
 '[{"id":"a","text":"A union of types sharing a common literal property (discriminant) that TypeScript uses to narrow the type exhaustively in switch/if blocks"},{"id":"b","text":"A union type where all members extend the same base class, enabling runtime instanceof checks"},{"id":"c","text":"A union that automatically removes duplicate member types at compile time"},{"id":"d","text":"A union where only the first matching type is used, discarding the remaining alternatives"}]'::jsonb,
 'a',
 'Discriminated unions (tagged unions) work because each member has a shared literal field (e.g., `type: "circle" | "square"`). TypeScript narrows to the correct member inside each case branch and can enforce exhaustiveness with a `never` check.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'HARD',
 'What is declaration merging in TypeScript, and which construct supports it?',
 '[{"id":"a","text":"Two type aliases with the same name are automatically intersected into one combined type"},{"id":"b","text":"Classes can be merged with interfaces to add instance members at compile time"},{"id":"c","text":"Interfaces with the same name are automatically merged into one combined interface; type aliases with duplicate names produce a compile error"},{"id":"d","text":"Declaration merging refers to combining separate .d.ts files into a single ambient type bundle"}]'::jsonb,
 'c',
 'TypeScript merges multiple interface declarations with the same name in the same scope into a single interface with all their members combined. This enables augmenting third-party types (e.g., Express Request). type aliases cannot be merged — a duplicate causes an error.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'HARD',
 'What does the TypeScript utility type `ReturnType<T>` extract?',
 '[{"id":"a","text":"The parameter types of function type T as a tuple"},{"id":"b","text":"The return type of function type T, inferred at compile time"},{"id":"c","text":"Whether T extends Promise and, if so, the resolved value type"},{"id":"d","text":"A constructor type corresponding to function T''s instance shape"}]'::jsonb,
 'b',
 'ReturnType<T> uses conditional types and the infer keyword internally: `type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never`. It extracts whatever type T returns. Useful for deriving types from functions without duplicating annotations.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'JAVASCRIPT_AND_TYPESCRIPT', 'HARD',
 'When does the JavaScript event loop move a callback from the macrotask queue to the call stack?',
 '[{"id":"a","text":"Immediately when the macrotask is registered, regardless of current call stack depth"},{"id":"b","text":"After a fixed 4ms minimum delay enforced by the browser"},{"id":"c","text":"After all synchronous code in the current module has finished loading"},{"id":"d","text":"After the call stack is empty AND all pending microtasks have been completely drained"}]'::jsonb,
 'd',
 'The event loop picks a macrotask only when the call stack is empty. Before picking the next macrotask, it drains the entire microtask queue (which may itself enqueue more microtasks, all of which run first). This is why Promise chains always resolve before the next setTimeout fires.',
 true);
