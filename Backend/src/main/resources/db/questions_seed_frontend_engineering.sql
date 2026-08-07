-- Question seed: Frontend Engineering (FRONTEND_ENGINEERING)
--
-- Boundary rule: DOM, browser rendering pipeline, CSS specificity/cascade,
-- accessibility (a11y/ARIA), responsive design, build tools (tree-shaking,
-- code splitting), browser storage, Core Web Vitals, and React component
-- patterns live HERE.
-- JavaScript/TypeScript language features belong in JAVASCRIPT_AND_TYPESCRIPT.
--
-- Run manually once after Hibernate has created the questions table:
--   psql "$DATABASE_URL" -f src/main/resources/db/questions_seed_frontend_engineering.sql
--
-- NOT idempotent — running twice inserts duplicates. Apply once per environment.
-- 20 questions: 6 EASY / 8 MEDIUM / 6 HARD. Single-select, one defensible answer.
-- Correct answer distribution: a=5, b=5, c=5, d=5

-- ============================== EASY (6) ==============================

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'EASY',
 'What is the DOM (Document Object Model)?',
 '[{"id":"a","text":"A CSS preprocessor that converts SASS to native CSS"},{"id":"b","text":"A tree-like in-memory representation of an HTML page that scripts can read and modify"},{"id":"c","text":"The JavaScript engine that executes code in the browser"},{"id":"d","text":"A network protocol for transferring HTML documents"}]'::jsonb,
 'b',
 'The DOM is a programming interface for HTML documents. The browser parses HTML into a tree of node objects that JavaScript can traverse and manipulate. Changes to the DOM are reflected in the rendered page.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'EASY',
 'In CSS specificity, which selector type has the highest specificity weight?',
 '[{"id":"a","text":"A class selector (.my-class)"},{"id":"b","text":"A type (tag) selector (div)"},{"id":"c","text":"The universal selector (*)"},{"id":"d","text":"An inline style attribute (style=\"...\")"}]'::jsonb,
 'd',
 'Specificity order from highest to lowest: inline styles > IDs > classes/attributes/pseudo-classes > type selectors > universal selector. Inline styles win any specificity contest short of !important.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'EASY',
 'What does LCP (Largest Contentful Paint) measure?',
 '[{"id":"a","text":"The time until the largest visible content element (image or text block) has rendered"},{"id":"b","text":"The time until the browser has finished parsing all CSS files"},{"id":"c","text":"The total number of pixels repainted during page load"},{"id":"d","text":"The delay between a user input event and the browser''s first visual response"}]'::jsonb,
 'a',
 'LCP measures when the largest above-the-fold content element becomes visible — a key proxy for perceived load speed. A good LCP is under 2.5 seconds. FID/INP measures input delay; CLS measures layout stability.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'EASY',
 'What is tree-shaking in the context of JavaScript bundlers?',
 '[{"id":"a","text":"Removing duplicate node_modules dependencies from the final bundle"},{"id":"b","text":"Splitting the bundle into multiple chunks for lazy loading"},{"id":"c","text":"Eliminating dead code (unused exports) at build time to reduce bundle size"},{"id":"d","text":"Reordering import statements to improve initial parse time"}]'::jsonb,
 'c',
 'Tree-shaking statically analyses ES module import/export graphs and drops any exports that are never imported. It requires ES module syntax because CommonJS require() calls can be dynamic, making static analysis unreliable.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'EASY',
 'What is the key difference between localStorage and sessionStorage?',
 '[{"id":"a","text":"localStorage holds strings only; sessionStorage can store objects"},{"id":"b","text":"localStorage persists until explicitly cleared; sessionStorage is cleared when the browser tab is closed"},{"id":"c","text":"sessionStorage can be shared across tabs; localStorage cannot"},{"id":"d","text":"localStorage is encrypted at rest; sessionStorage is stored in plain text"}]'::jsonb,
 'b',
 'Both store string key-value pairs with ~5 MB limit per origin. sessionStorage is scoped to the browser tab and cleared on close. localStorage survives tab/browser restarts until cleared programmatically or by the user.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'EASY',
 'Why is semantic HTML (e.g., <main>, <nav>, <article>) preferred over generic <div> elements for page structure?',
 '[{"id":"a","text":"Semantic elements render faster because browsers apply built-in CSS optimisations"},{"id":"b","text":"Semantic elements guarantee mobile responsiveness without additional CSS"},{"id":"c","text":"Semantic elements have higher CSS specificity than <div>"},{"id":"d","text":"Semantic elements convey meaning to browsers, assistive technologies, and search engines — improving accessibility and SEO"}]'::jsonb,
 'd',
 'Screen readers use landmarks like <nav> and <main> to let users jump between sections. Search engines use semantic structure to understand content hierarchy. <div> carries no meaning — it is a generic container.',
 true);

-- ============================== MEDIUM (8) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'MEDIUM',
 'In the correct browser rendering pipeline order, which step immediately follows the construction of the Render Tree?',
 '[{"id":"a","text":"Parsing HTML to build the DOM"},{"id":"b","text":"Applying CSS rules to build the CSSOM"},{"id":"c","text":"Layout — calculating the position and size of each element"},{"id":"d","text":"Compositing — combining painted layers into the final frame"}]'::jsonb,
 'c',
 'The critical rendering path is: Parse HTML → DOM; Parse CSS → CSSOM; Combine → Render Tree; Layout (reflow); Paint; Composite. Layout computes geometry after the Render Tree is built. Compositing is the final step.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'MEDIUM',
 'In React, what is the difference between a controlled and an uncontrolled input?',
 '[{"id":"a","text":"A controlled input''s value is driven by React state via the value prop; an uncontrolled input manages its own value in the DOM"},{"id":"b","text":"A controlled input validates its value automatically; an uncontrolled input has no validation"},{"id":"c","text":"An uncontrolled input cannot be accessed via refs"},{"id":"d","text":"A controlled input always requires a defaultValue; an uncontrolled input requires a placeholder"}]'::jsonb,
 'a',
 'With a controlled input, every keystroke flows through state — the component is the single source of truth. Uncontrolled inputs keep their state in the DOM and are read via refs. Controlled inputs offer easier validation and conditional disabling.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'MEDIUM',
 'When two CSS rules have equal specificity and target the same element, which rule wins?',
 '[{"id":"a","text":"The rule with more individual property declarations"},{"id":"b","text":"The rule defined in a linked stylesheet rather than a <style> block"},{"id":"c","text":"The rule that appears earlier in the stylesheet"},{"id":"d","text":"The rule that appears later in the stylesheet (cascade order)"}]'::jsonb,
 'd',
 'When specificity is equal, the cascade applies: the last rule declared in source order wins. Stylesheet type (linked vs. embedded) does not change this — only specificity, origin, and order matter.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'MEDIUM',
 'When should you add an ARIA role attribute to an HTML element?',
 '[{"id":"a","text":"On every interactive element to improve SEO ranking"},{"id":"b","text":"When a native semantic HTML element is not available to convey the element''s role to assistive technologies"},{"id":"c","text":"On all <div> and <span> elements to make them keyboard-accessible"},{"id":"d","text":"Only when the element''s visual design differs from its default browser rendering"}]'::jsonb,
 'b',
 'The first rule of ARIA is: use native HTML elements whenever possible. ARIA roles are for cases where you must build custom widgets (e.g., a combobox from divs) and no native element conveys the same semantics.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'MEDIUM',
 'What is the main benefit of code splitting in a JavaScript application?',
 '[{"id":"a","text":"It reduces the number of HTTP requests by merging related bundles"},{"id":"b","text":"It removes unused CSS from the critical rendering path"},{"id":"c","text":"It defers loading non-critical code until needed, reducing initial page load time and time-to-interactive"},{"id":"d","text":"It compresses JavaScript using Brotli at the module boundary"}]'::jsonb,
 'c',
 'Code splitting breaks the bundle into chunks loaded on demand (route-based or component-based). Users download only what is needed for the current view, improving TTI. Compression and CSS removal are separate concerns.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'MEDIUM',
 'What problem does the virtual DOM solve in frameworks like React?',
 '[{"id":"a","text":"It batches and minimises direct DOM mutations by diffing a lightweight in-memory tree first, reducing expensive reflows and repaints"},{"id":"b","text":"It replaces the real DOM entirely so browsers no longer build a render tree"},{"id":"c","text":"It caches DOM queries so getElementById never hits the real DOM more than once"},{"id":"d","text":"It prevents layout thrashing by queuing all reads before all writes"}]'::jsonb,
 'a',
 'Direct DOM manipulation is expensive. The virtual DOM lets the framework compute the minimal set of changes in memory first, then apply only those changes to the real DOM in a single batch — reducing layout thrashing and repaints.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'MEDIUM',
 'What does the CSS media query `@media (max-width: 768px)` target?',
 '[{"id":"a","text":"Screens with a pixel density higher than 768 pixels per inch"},{"id":"b","text":"Printed pages that are wider than 768 millimetres"},{"id":"c","text":"Screens with a viewport width of exactly 768 pixels"},{"id":"d","text":"Viewports 768 pixels wide or narrower, typically used to apply mobile-specific styles"}]'::jsonb,
 'd',
 'max-width: 768px applies styles when the viewport is at most 768px wide — the canonical mobile breakpoint in many design systems. Pixel density uses resolution or -webkit-device-pixel-ratio media features.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'MEDIUM',
 'What causes Cumulative Layout Shift (CLS), and how is it commonly fixed?',
 '[{"id":"a","text":"CLS is caused by unminified JavaScript; it is fixed by minifying and deferring scripts"},{"id":"b","text":"CLS is caused by elements rendering without reserved space (e.g., images without width/height); it is fixed by specifying dimensions or using CSS aspect-ratio"},{"id":"c","text":"CLS is caused by too many HTTP redirects delaying resource loading"},{"id":"d","text":"CLS is caused by web fonts loading before CSS; it is fixed by inlining all web fonts"}]'::jsonb,
 'b',
 'CLS occurs when content shifts after initial render — most commonly images and ads without explicit dimensions that push content down when they load. Reserving space upfront (width/height attributes or aspect-ratio CSS) eliminates the shift.',
 true);

-- ============================== HARD (6) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'HARD',
 'For smooth 60fps animations, why should you prefer CSS `transform` and `opacity` over properties like `top`, `left`, or `width`?',
 '[{"id":"a","text":"`transform` is processed by the JavaScript engine, which is faster than the CSS engine processing geometric properties"},{"id":"b","text":"Browsers apply hardware acceleration only to `transform` because it is a newer CSS property"},{"id":"c","text":"`transform` and `opacity` can be handled by the compositor thread without triggering layout or paint; changing geometric properties forces the browser to recalculate layout for the entire document"},{"id":"d","text":"`top` and `left` changes always trigger a full-page repaint regardless of the element''s stacking context"}]'::jsonb,
 'c',
 'Changing `top`/`left`/`width` triggers layout (reflow) → paint → composite — the full pipeline. `transform` and `opacity` skip layout and paint and go straight to the compositor, which can run on the GPU independently of the main thread.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'HARD',
 'A custom interactive button is built from a <div>. Which combination of changes most directly makes it accessible to keyboard and screen reader users?',
 '[{"id":"a","text":"Add role=\"button\", tabindex=\"0\", and a keydown handler for Enter and Space so it is announced as a button, is keyboard-focusable, and responds to keyboard activation"},{"id":"b","text":"Add a CSS outline: 2px solid blue to make focus visible"},{"id":"c","text":"Wrap the <div> in a <section> element to give it landmark context"},{"id":"d","text":"Add aria-hidden=\"false\" to make the element visible to the accessibility tree"}]'::jsonb,
 'a',
 'A native <button> is better, but if a <div> must be used: role="button" announces it correctly, tabindex="0" puts it in the tab order, and the keydown handler enables keyboard activation. CSS focus styles improve visibility but do not fix semantics or keyboard support alone.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'HARD',
 'Tree-shaking relies on ES module syntax (import/export). Why does CommonJS (require/module.exports) make tree-shaking unreliable?',
 '[{"id":"a","text":"CommonJS modules are not supported by modern bundlers like Webpack or Vite"},{"id":"b","text":"require() calls are always inlined at the call site, preventing any dead code analysis"},{"id":"c","text":"CommonJS exports are plain objects, which bundlers cannot parse into individual export members"},{"id":"d","text":"CommonJS require() calls can be dynamic and conditional at runtime, so bundlers cannot statically determine which exports are used"}]'::jsonb,
 'd',
 'ES modules declare imports statically at the top level — bundlers can analyse the dependency graph at build time. CommonJS allows `require(someVariable)` and `if (condition) require(...)`, making it impossible to know statically which exports are needed.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'HARD',
 'A React component re-renders on every parent render even though its props have not changed. Which tool is specifically designed to prevent this?',
 '[{"id":"a","text":"useCallback — memoises a function reference so it does not change between renders"},{"id":"b","text":"React.memo — wraps a component and skips re-rendering if props are shallowly equal to the previous render"},{"id":"c","text":"useMemo — memoises the result of an expensive computation inside the component"},{"id":"d","text":"useRef — holds a mutable value without triggering re-renders when changed"}]'::jsonb,
 'b',
 'React.memo is a higher-order component that performs a shallow props comparison. If props are equal, the render is skipped. useCallback memoises functions (useful to stabilise props passed to memo-wrapped children); useMemo memoises computed values.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'HARD',
 'What is the relationship between Time to First Byte (TTFB) and the browser''s critical rendering path?',
 '[{"id":"a","text":"TTFB is the time before the browser receives the first byte of HTML — a slow TTFB delays the start of the entire critical rendering path since nothing can be parsed before the first byte arrives"},{"id":"b","text":"TTFB is measured after all render-blocking resources are resolved"},{"id":"c","text":"TTFB only affects static asset delivery; the critical rendering path begins independently of TTFB"},{"id":"d","text":"Improving TTFB only benefits the first HTML request; subsequent resource fetches are unaffected"}]'::jsonb,
 'a',
 'The critical rendering path cannot begin until the browser starts receiving HTML. A high TTFB (slow server, no CDN, cold function starts) delays everything: DOM parsing, CSS/JS fetching, and ultimately LCP. Reducing TTFB is often the highest-ROI performance fix.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'FRONTEND_ENGINEERING', 'HARD',
 'INP (Interaction to Next Paint) replaced FID as a Core Web Vital. What does INP measure that FID did not?',
 '[{"id":"a","text":"The total number of distinct user interactions during a page session"},{"id":"b","text":"The visual stability of the page in response to user interactions"},{"id":"c","text":"The latency of ALL user interactions throughout the session (not just the first), reported as the 75th-percentile worst case"},{"id":"d","text":"The delay between a touch event and the corresponding CSS transition starting"}]'::jsonb,
 'c',
 'FID only measured the delay of the very first interaction, which was easy to game by deferring work until after load. INP samples every interaction (clicks, taps, key presses) during the session and reports the worst-case 75th percentile, giving a truer picture of responsiveness.',
 true);
