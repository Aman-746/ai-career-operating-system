-- Question seed: API & Web Fundamentals (API_AND_WEB_FUNDAMENTALS)
--
-- Boundary rule: HTTP methods/codes, REST principles, auth mechanisms (JWT, OAuth2,
-- API keys), CORS, idempotency, pagination, API versioning, WebSockets, and
-- rate-limiting concepts from the API-consumer perspective live HERE.
-- Rate limiting infrastructure (Redis shared counters, gateway nodes) belongs
-- in SYSTEM_DESIGN.
--
-- Run manually once after Hibernate has created the questions table:
--   psql "$DATABASE_URL" -f src/main/resources/db/questions_seed_api_web_fundamentals.sql
--
-- NOT idempotent — running twice inserts duplicates. Apply once per environment.
-- 20 questions: 6 EASY / 8 MEDIUM / 6 HARD. Single-select, one defensible answer.
-- Correct answer distribution: a=5, b=5, c=5, d=5

-- ============================== EASY (6) ==============================

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'EASY',
 'Which HTTP method is designed for PARTIAL updates to an existing resource?',
 '[{"id":"a","text":"PUT — replaces the entire resource representation"},{"id":"b","text":"PATCH — applies a partial update to the resource"},{"id":"c","text":"POST — creates a new resource"},{"id":"d","text":"DELETE — removes the resource"}]'::jsonb,
 'b',
 'PATCH modifies only the fields included in the request body, leaving others unchanged. PUT replaces the entire resource representation — omitting a field in PUT typically nulls or removes it. POST creates; DELETE removes.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'EASY',
 'A client sends a request with a malformed JSON body the server cannot parse. Which HTTP status code should the server return?',
 '[{"id":"a","text":"500 Internal Server Error"},{"id":"b","text":"404 Not Found"},{"id":"c","text":"401 Unauthorized"},{"id":"d","text":"400 Bad Request"}]'::jsonb,
 'd',
 '400 Bad Request signals a client-side error — malformed syntax, invalid JSON, or bad parameters. 401 means the client is unauthenticated; 404 means the resource does not exist; 500 indicates a server fault unrelated to the request content.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'EASY',
 'What does the "stateless" constraint in REST mean?',
 '[{"id":"a","text":"Each request must contain all information needed to process it; the server holds no client session state between requests"},{"id":"b","text":"The API never persists data to a database"},{"id":"c","text":"All responses are cached by the server to improve performance"},{"id":"d","text":"Every endpoint must return the same response regardless of the input"}]'::jsonb,
 'a',
 'Stateless means the server treats each request independently — no stored session, no remembered context. All authentication, identifiers, and parameters must be included in each request. This makes servers easy to scale horizontally because any node can handle any request.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'EASY',
 'Which HTTP status code should a REST API return when a POST request successfully creates a new resource?',
 '[{"id":"a","text":"200 OK"},{"id":"b","text":"204 No Content"},{"id":"c","text":"201 Created"},{"id":"d","text":"202 Accepted"}]'::jsonb,
 'c',
 '201 Created signals a resource was successfully created. The Location header typically accompanies it with the new resource URL. 200 OK suits retrievals and updates; 204 No Content means success with no response body; 202 Accepted means the request was received but processing is deferred.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'EASY',
 'Which HTTP method is idempotent, meaning calling it multiple times produces the same server state as calling it once?',
 '[{"id":"a","text":"POST"},{"id":"b","text":"DELETE"},{"id":"c","text":"PATCH"},{"id":"d","text":"None — no HTTP method is defined as idempotent"}]'::jsonb,
 'b',
 'DELETE is idempotent: after the first call the resource is gone, and subsequent calls leave the state unchanged (resource is still absent). POST is not idempotent — each call may create a new resource. PATCH is generally not idempotent. GET, PUT, and DELETE are all idempotent by the HTTP spec.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'EASY',
 'A JSON Web Token (JWT) consists of three Base64URL-encoded parts separated by dots. What are they?',
 '[{"id":"a","text":"Username, password, and signature"},{"id":"b","text":"Issuer, audience, and expiry claim"},{"id":"c","text":"Algorithm, claims, and public key"},{"id":"d","text":"Header, payload, and signature"}]'::jsonb,
 'd',
 'A JWT is header.payload.signature. The header declares the token type and signing algorithm (e.g. RS256). The payload carries claims (sub, exp, roles). The signature verifies the token has not been tampered with. The payload is encoded, NOT encrypted by default — anyone can decode it without the secret.',
 true);

-- ============================== MEDIUM (8) ==============================

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'MEDIUM',
 'What problem does CORS (Cross-Origin Resource Sharing) solve?',
 '[{"id":"a","text":"It enables browsers to make requests to a different origin than the loaded page, subject to permissions the server declares via response headers"},{"id":"b","text":"It encrypts HTTP traffic between the browser and a remote API server"},{"id":"c","text":"It prevents servers from setting cookies for cross-origin requests"},{"id":"d","text":"It authenticates the user identity across multiple domains"}]'::jsonb,
 'a',
 'Browsers block cross-origin XHR/fetch by default (same-origin policy). CORS lets the server opt in by returning headers like Access-Control-Allow-Origin, selectively relaxing this restriction. CORS is enforced by the browser, not the server. It does not encrypt traffic or handle authentication.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'MEDIUM',
 'In the OAuth 2.0 Authorization Code flow, what does the authorization code represent?',
 '[{"id":"a","text":"A long-lived access token returned directly to the browser after user consent"},{"id":"b","text":"The user''s hashed password sent from the authorization server to the client"},{"id":"c","text":"A short-lived, single-use code the client exchanges at the token endpoint to receive an access token"},{"id":"d","text":"The authorization server''s public key certificate for verifying token signatures"}]'::jsonb,
 'c',
 'The authorization code is a short-lived opaque credential. Exchanging it at the back channel (client server to auth server) keeps the access token out of the browser URL and history. Returning a token directly to the browser (Implicit flow) risks interception. The code itself is worthless without the client secret or PKCE verifier.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'MEDIUM',
 'Why is cursor-based pagination preferred over offset pagination for large, frequently-updated datasets?',
 '[{"id":"a","text":"Cursor pagination requires simpler SQL and eliminates the need for a COUNT(*) query"},{"id":"b","text":"New records inserted between pages shift row offsets, causing offset pagination to skip rows or return duplicates; a cursor resumes from a stable position"},{"id":"c","text":"Offset pagination performs a full table scan on every request regardless of indexes"},{"id":"d","text":"Cursor pagination transmits fewer bytes per response because it omits total row count metadata"}]'::jsonb,
 'b',
 'Offset pagination uses LIMIT n OFFSET m. If a row is inserted before position m after page 1 was served, page 2 misses one row or duplicates a boundary row. A cursor anchors on a stable value such as an ID or timestamp, so concurrent inserts do not affect the next page position.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'MEDIUM',
 'A client receives a response with ETag: "v3". On the next request for the same resource, which header should it send to avoid re-downloading unchanged data?',
 '[{"id":"a","text":"Cache-Control: no-cache"},{"id":"b","text":"ETag: \"v3\""},{"id":"c","text":"Last-Modified: v3"},{"id":"d","text":"If-None-Match: \"v3\""}]'::jsonb,
 'd',
 'If-None-Match sends the previously received ETag back to the server. If the resource has not changed, the server returns 304 Not Modified with no body, saving bandwidth. ETag is a response header set by the server. Cache-Control: no-cache bypasses cached responses and always revalidates. Last-Modified is a different, date-based caching mechanism.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'MEDIUM',
 'Which API versioning strategy is most cache-friendly and most visible in logs, but pollutes URI paths with version numbers?',
 '[{"id":"a","text":"URI path versioning (e.g. /api/v2/users)"},{"id":"b","text":"Custom request header versioning (e.g. API-Version: 2)"},{"id":"c","text":"Query parameter versioning (e.g. /users?v=2)"},{"id":"d","text":"Content negotiation versioning (e.g. Accept: application/vnd.api.v2+json)"}]'::jsonb,
 'a',
 'URI path versioning embeds the version in the URL, making it trivially visible in browser address bars, server logs, and curl commands, and enabling CDN caching by URL. The downside is that changing the version requires all clients to update their base URL. Header and content-negotiation versioning keep URIs stable but are harder to test and less cache-friendly.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'MEDIUM',
 'When is WebSocket the appropriate protocol choice over REST over HTTP?',
 '[{"id":"a","text":"When the client needs to upload large binary files efficiently"},{"id":"b","text":"When the API must remain stateless and horizontally scalable"},{"id":"c","text":"When the server needs to push real-time events to the client without the client continuously polling"},{"id":"d","text":"When end-to-end payload encryption beyond TLS is required"}]'::jsonb,
 'c',
 'WebSocket establishes a persistent bidirectional channel — ideal for live notifications, collaborative editing, chat, and financial tickers. REST is request-response: the server cannot push without the client asking. Long-polling simulates push but wastes connections. WebSocket connections are stateful, which complicates horizontal scaling.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'MEDIUM',
 'An API returns HTTP 429 Too Many Requests. Which standard response header tells the client when it may safely retry?',
 '[{"id":"a","text":"X-RateLimit-Limit"},{"id":"b","text":"Retry-After"},{"id":"c","text":"X-Backoff-Until"},{"id":"d","text":"Rate-Limit-Reset"}]'::jsonb,
 'b',
 'Retry-After is the IETF-standardised header for both 429 and 503 responses. It can be an integer (seconds to wait) or an HTTP-date. X-RateLimit-Limit, X-RateLimit-Remaining, and X-RateLimit-Reset are common conventions for communicating quota state but are not standardised and do not specify a retry window.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'MEDIUM',
 'Which URL design best follows REST resource-oriented conventions for retrieving orders belonging to a specific user?',
 '[{"id":"a","text":"GET /getUserOrders?userId=42"},{"id":"b","text":"POST /orders/search with body {\"userId\":42}"},{"id":"c","text":"GET /orders?filter=user_id&value=42"},{"id":"d","text":"GET /users/42/orders"}]'::jsonb,
 'd',
 'REST models resources as nouns in hierarchical URIs. /users/42/orders clearly expresses the ownership relationship and is cacheable. Verbs in URLs (/getUserOrders) are RPC style, not RESTful. Using POST for read operations conflicts with HTTP semantics and prevents proxy caching. Excessive query parameters for structural relationships obscure the resource hierarchy.',
 true);

-- ============================== HARD (6) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'HARD',
 'A JWT access token is stored in localStorage on a browser client. What is the primary security risk compared to storing it in an HttpOnly cookie?',
 '[{"id":"a","text":"localStorage tokens expire faster because browsers enforce shorter max-age limits than cookies"},{"id":"b","text":"localStorage is cleared when the browser tab closes, causing unexpected session loss"},{"id":"c","text":"Any JavaScript on the page — including malicious injected scripts — can read localStorage, making the token vulnerable to XSS attacks"},{"id":"d","text":"localStorage cannot hold strings larger than 4 KB, truncating tokens that carry many claims"}]'::jsonb,
 'c',
 'HttpOnly cookies are inaccessible to JavaScript by design, so XSS cannot exfiltrate them. localStorage is fully readable by any script on the page. An XSS vulnerability in a localStorage-based app gives the attacker the raw token. Prefer HttpOnly, Secure, SameSite=Strict cookies for auth tokens. localStorage persistence and size limits are unrelated to the security concern.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'HARD',
 'OAuth 2.0 recommends the PKCE extension for public clients such as SPAs and mobile apps. What attack does PKCE prevent?',
 '[{"id":"a","text":"Authorization code interception — an attacker who captures the code in transit cannot exchange it without the code_verifier that only the legitimate client holds"},{"id":"b","text":"Token replay attacks where a stolen access token is reused after its expiry"},{"id":"c","text":"CSRF attacks where a forged state parameter tricks the user into authorising a malicious client"},{"id":"d","text":"Man-in-the-middle attacks on the TLS-protected token endpoint connection"}]'::jsonb,
 'a',
 'PKCE binds the authorization request to a secret the client generates (code_verifier). The client sends its hash (code_challenge) upfront and proves knowledge of the verifier at token exchange. An attacker who intercepts the authorization code cannot use it without the verifier. Public clients cannot keep a client secret safe, making PKCE the replacement security mechanism.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'HARD',
 'What is the key performance improvement HTTP/2 provides over HTTP/1.1 when loading a page with many resources?',
 '[{"id":"a","text":"HTTP/2 automatically gzip-compresses all response bodies, reducing transfer size"},{"id":"b","text":"HTTP/2 removes the TLS requirement, eliminating handshake overhead for internal services"},{"id":"c","text":"HTTP/2 switches from TCP to UDP, cutting connection setup latency"},{"id":"d","text":"HTTP/2 multiplexes multiple request and response streams over a single TCP connection, eliminating head-of-line blocking and the parallel-connection workarounds of HTTP/1.1"}]'::jsonb,
 'd',
 'HTTP/1.1 processes requests sequentially per connection; browsers open 6-8 parallel connections to work around this. HTTP/2 sends multiple streams concurrently over one connection and adds HPACK header compression. HTTP/2 still uses TCP; HTTP/3 introduces QUIC (UDP-based). TLS is technically optional by spec but required in practice by every browser.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'HARD',
 'A client retries a POST /payments request after a network timeout and the charge fires twice. What API design pattern prevents this double-charge?',
 '[{"id":"a","text":"Change the endpoint method to PUT because PUT is idempotent by the HTTP spec"},{"id":"b","text":"Require clients to send a unique Idempotency-Key header; the server stores the result and returns it for duplicate requests without reprocessing"},{"id":"c","text":"Set a short server processing timeout so the client always retries before the charge completes"},{"id":"d","text":"Return HTTP 202 Accepted so the client knows to poll a status endpoint rather than retry"}]'::jsonb,
 'b',
 'Idempotency keys solve inherently non-idempotent operations like payments. The server persists the key and result; on retry it returns the cached result without reprocessing. Stripe, PayPal, and Adyen all implement this pattern. Switching to PUT does not help — charging a card is semantically non-idempotent regardless of HTTP method. 202 defers processing but does not prevent duplicate execution.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'HARD',
 'What problem does GraphQL''s field selection mechanism solve that traditional REST APIs commonly encounter?',
 '[{"id":"a","text":"GraphQL enforces per-field authorisation policies that REST endpoint designs cannot express"},{"id":"b","text":"GraphQL responses are automatically cached at the CDN edge layer"},{"id":"c","text":"Fixed REST endpoint shapes cause over-fetching (unused fields sent) or under-fetching (multiple round trips needed); GraphQL lets clients specify exactly the fields they need in one request"},{"id":"d","text":"GraphQL eliminates the N+1 query problem server-side by default through its execution model"}]'::jsonb,
 'c',
 'REST endpoints return a fixed shape regardless of what the caller needs. A mobile client requiring only name and avatar still receives the full user object (over-fetching). If it also needs the user''s posts, it makes a second request (under-fetching). GraphQL collapses both into one request declaring precisely the needed fields. GraphQL does not automatically cache (standard HTTP caching is harder) and does not solve N+1 without DataLoader.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'API_AND_WEB_FUNDAMENTALS', 'HARD',
 'A REST API can serve both JSON and XML. What is the HTTP-standard mechanism for a client to declare its preferred response format?',
 '[{"id":"a","text":"The Accept request header listing acceptable media types (e.g. Accept: application/json)"},{"id":"b","text":"The Content-Type header on the request body, which the server mirrors in its response"},{"id":"c","text":"A ?format= query parameter — the only approach portable across all HTTP versions and proxies"},{"id":"d","text":"Separate base paths for each format (e.g. /json/users and /xml/users)"}]'::jsonb,
 'a',
 'Content negotiation uses the Accept header to specify desired response media types with optional quality weights (e.g. Accept: application/json;q=0.9, application/xml;q=0.8). The server picks the best match and echoes the chosen type in Content-Type. Content-Type on the request describes the body being sent, not the response format desired. Query parameters and separate paths are common but are not part of the HTTP standard for format negotiation.',
 true);
