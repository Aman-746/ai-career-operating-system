-- Question seed: Object-Oriented Design (OBJECT_ORIENTED_DESIGN)
--
-- Boundary rule: SOLID principles, GoF design patterns, inheritance vs
-- composition, polymorphism, encapsulation, and coupling/cohesion live HERE.
-- Language-specific syntax, concurrency, and database topics do not belong here.
--
-- Run manually once after Hibernate has created the questions table:
--   psql "$DATABASE_URL" -f src/main/resources/db/questions_seed_object_oriented_design.sql
--
-- NOT idempotent — running twice inserts duplicates. Apply once per environment.
-- 20 questions: 6 EASY / 8 MEDIUM / 6 HARD. Single-select, one defensible answer.
-- Correct answer distribution: a=5, b=5, c=5, d=5

-- ============================== EASY (6) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'EASY',
 'What does the Single Responsibility Principle (SRP) state?',
 '[{"id":"a","text":"A class should have only one method"},{"id":"b","text":"A class should inherit from at most one parent"},{"id":"c","text":"A class should have only one reason to change"},{"id":"d","text":"A class should depend on abstractions, not concretions"}]'::jsonb,
 'c',
 'SRP states that a class should have one, and only one, reason to change — meaning it should encapsulate a single responsibility. Multiple reasons to change indicate multiple responsibilities that should be split into separate classes.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'EASY',
 'What does the Open/Closed Principle (OCP) state?',
 '[{"id":"a","text":"Classes should be open to modification and closed to extension"},{"id":"b","text":"Software entities should be open for extension but closed for modification"},{"id":"c","text":"Classes should open resources when constructed and close them in a finally block"},{"id":"d","text":"Public methods should be open to all callers; private methods should be closed"}]'::jsonb,
 'b',
 'OCP means you should be able to add new behavior by extending code (subclasses, composition, plugins) rather than editing existing tested code. Editing existing code risks breaking existing behavior.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'EASY',
 'What is encapsulation in object-oriented programming?',
 '[{"id":"a","text":"Inheriting behavior from a parent class"},{"id":"b","text":"Having multiple classes implement the same interface"},{"id":"c","text":"Splitting a class into smaller subclasses"},{"id":"d","text":"Bundling data and the methods that operate on it while hiding internal details behind a public interface"}]'::jsonb,
 'd',
 'Encapsulation restricts direct access to an object''s internal state, exposing only what is necessary through a defined interface. This reduces coupling between classes and protects invariants.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'EASY',
 'What is the key difference between an abstract class and an interface in most object-oriented languages?',
 '[{"id":"a","text":"An abstract class can have instance state and concrete methods; an interface defines only a contract with no state"},{"id":"b","text":"An interface can be instantiated; an abstract class cannot"},{"id":"c","text":"An abstract class supports multiple inheritance; an interface does not"},{"id":"d","text":"Interfaces are slower at runtime because they require dynamic dispatch that abstract classes avoid"}]'::jsonb,
 'a',
 'Abstract classes can hold fields, constructors, and implemented methods, modeling an "is-a" relationship with shared state. Interfaces define a pure contract. A class can implement multiple interfaces but typically extend only one abstract class.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'EASY',
 'What does the Liskov Substitution Principle (LSP) require?',
 '[{"id":"a","text":"Every subclass must override all methods of its parent"},{"id":"b","text":"Subclasses should never add new methods beyond those in the parent"},{"id":"c","text":"Subtypes must be substitutable for their base types without altering the correctness of the program"},{"id":"d","text":"Superclass references should always be downcast to the subclass type before use"}]'::jsonb,
 'c',
 'LSP says that any code using a base type must work correctly when given a subtype. A subclass that weakens preconditions or strengthens postconditions violates this and causes subtle bugs when polymorphism is used.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'EASY',
 '"Favor composition over inheritance" is a classic OOP guideline. What is the primary reason?',
 '[{"id":"a","text":"Composition is always faster at runtime than inheritance"},{"id":"b","text":"Composition gives more flexible behavior at runtime and avoids tight coupling to a parent''s implementation"},{"id":"c","text":"Inheritance requires more lines of code than composition"},{"id":"d","text":"Composition allows a class to inherit from multiple parent classes simultaneously"}]'::jsonb,
 'b',
 'Inheritance couples a subclass to the parent''s internals — changes to the parent ripple down. Composition delegates to collaborators that can be swapped at runtime, making behavior more flexible and classes easier to test.',
 true);

-- ============================== MEDIUM (8) ==============================

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'MEDIUM',
 'When is the Factory Method pattern most appropriate?',
 '[{"id":"a","text":"When you need exactly one instance of a class throughout the application"},{"id":"b","text":"When you want to add behavior to an object without modifying its class"},{"id":"c","text":"When you need to notify multiple objects when one object changes state"},{"id":"d","text":"When the exact type of object to create must be decided by subclasses rather than the base class"}]'::jsonb,
 'd',
 'Factory Method defines a method for creating objects in a base class but lets subclasses override which class to instantiate. Singleton is for one instance; Decorator adds behavior; Observer notifies dependents.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'MEDIUM',
 'How does the Strategy pattern improve a class that contains a large if/else chain for behavior selection?',
 '[{"id":"a","text":"It extracts each behavior variant into its own class behind a common interface, allowing the behavior to be swapped at runtime"},{"id":"b","text":"It converts each branch into a subclass so the if/else is replaced by polymorphic dispatch"},{"id":"c","text":"It removes the need for any conditionals by pre-computing all decisions at startup"},{"id":"d","text":"It merges all variant behaviors into a single method using a lookup table"}]'::jsonb,
 'a',
 'Strategy encapsulates interchangeable algorithms behind an interface and injects the desired one at runtime. This eliminates the if/else, makes each variant independently testable, and allows new strategies without modifying the host class.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'MEDIUM',
 'In the Observer pattern, what is the relationship between the subject and its observers?',
 '[{"id":"a","text":"The subject inherits from each observer so it can call their update methods directly"},{"id":"b","text":"Observers register with the subject; when the subject''s state changes it notifies all registered observers"},{"id":"c","text":"The subject and observers share a common polling thread that checks for state changes"},{"id":"d","text":"The subject stores observer data directly in its own fields to avoid any coupling"}]'::jsonb,
 'b',
 'Observer defines a one-to-many dependency so that when one object changes state, its dependents are notified automatically. The subject holds a list of observers and calls their update method — it does not know the concrete type of each observer.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'MEDIUM',
 'A Square class extends Rectangle and overrides setWidth/setHeight to keep both sides equal. Why does this violate the Liskov Substitution Principle?',
 '[{"id":"a","text":"Square adds new methods that Rectangle does not have, which LSP forbids"},{"id":"b","text":"Square cannot extend Rectangle because squares are not rectangles in mathematics"},{"id":"c","text":"Code that expects a Rectangle and calls setWidth(5) then reads height will get an unexpected result when passed a Square"},{"id":"d","text":"LSP forbids overriding any inherited method, which Square does"}]'::jsonb,
 'c',
 'A Rectangle user reasonably expects width and height to be independent. Substituting a Square breaks that expectation — setWidth also changes height, violating the postcondition a caller relies on. The geometry argument is irrelevant; LSP is about behavioral contracts.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'MEDIUM',
 'The Decorator pattern is preferred over subclassing to add behavior. Why?',
 '[{"id":"a","text":"Decorators are faster than subclasses at runtime"},{"id":"b","text":"Decorators allow a class to implement multiple interfaces simultaneously"},{"id":"c","text":"Subclasses cannot add new methods, but decorators can"},{"id":"d","text":"Decorators compose behaviors at runtime without a combinatorial explosion of subclass variants for every combination"}]'::jsonb,
 'd',
 'With subclassing, adding N independent behaviors requires 2^N subclasses for every combination. Decorators wrap the same interface and stack at runtime — you compose any combination without new classes.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'MEDIUM',
 'What does the Dependency Inversion Principle (DIP) state?',
 '[{"id":"a","text":"High-level modules should not depend on low-level modules; both should depend on abstractions"},{"id":"b","text":"All dependencies should be injected through setter methods rather than constructors"},{"id":"c","text":"Low-level utility classes should never import high-level business classes"},{"id":"d","text":"All class dependencies must be declared in an external configuration file"}]'::jsonb,
 'a',
 'DIP decouples high-level policy from low-level detail by inserting an abstraction (interface) between them. This allows the low-level implementation to be swapped (e.g., for testing) without changing the high-level module.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'MEDIUM',
 'Which situation best illustrates a violation of the Interface Segregation Principle (ISP)?',
 '[{"id":"a","text":"A class implements two interfaces that have overlapping method names"},{"id":"b","text":"A class is forced to implement interface methods it does not use, leaving them empty or throwing UnsupportedOperationException"},{"id":"c","text":"A single interface is implemented by too many unrelated classes"},{"id":"d","text":"An interface has more than five method signatures"}]'::jsonb,
 'b',
 'ISP says clients should not be forced to depend on methods they do not use. A "fat" interface forces implementors to stub methods that are irrelevant to them. The fix is to split the interface into smaller, focused ones.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'MEDIUM',
 'In the Template Method pattern, what role does the abstract base class play?',
 '[{"id":"a","text":"It provides a factory method that subclasses override to create objects"},{"id":"b","text":"It acts as an observer that monitors subclass method calls"},{"id":"c","text":"It delegates all method calls to a strategy object held by the subclass"},{"id":"d","text":"It defines the skeleton of an algorithm in a concrete method, deferring specific steps to abstract methods that subclasses implement"}]'::jsonb,
 'd',
 'Template Method puts the invariant algorithm structure in the base class and leaves variable steps as abstract hook methods. Subclasses fill in the details without changing the overall flow. It is inheritance-based, unlike Strategy which uses composition.',
 true);

-- ============================== HARD (6) ==============================

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'HARD',
 'You need to add logging, caching, and validation around an existing service object without modifying its class. Which pattern applies?',
 '[{"id":"a","text":"Strategy — each behavior is an interchangeable algorithm variant that replaces the original"},{"id":"b","text":"Template Method — the service defines a skeleton and subclasses override the specific steps"},{"id":"c","text":"Decorator — behaviors are layered around the object at runtime without changing its class"},{"id":"d","text":"Facade — you want a simplified interface hiding the service subsystem"}]'::jsonb,
 'c',
 'Decorator wraps an object with the same interface, adding behavior before/after delegating to the wrapped object. Multiple decorators can be stacked. Strategy replaces the algorithm; Facade simplifies an interface; Template Method uses inheritance.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'HARD',
 'A design has high coupling and low cohesion. What does this indicate?',
 '[{"id":"a","text":"Classes depend heavily on each other''s internals and each class has multiple unrelated responsibilities — the design is fragile and hard to change"},{"id":"b","text":"The codebase is well-structured but uses too many design patterns, creating unnecessary abstraction"},{"id":"c","text":"Classes are independent but each class does only one thing — the design has too many small, single-purpose classes"},{"id":"d","text":"High coupling ensures performance by reducing inter-object communication overhead"}]'::jsonb,
 'a',
 'High coupling means classes know too much about each other''s internals — a change in one forces changes in others. Low cohesion means each class handles many unrelated concerns. Good OO design aims for the opposite: low coupling and high cohesion.',
 true);

-- correct: d
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'HARD',
 'The Singleton pattern is often called an anti-pattern in testable systems. Why?',
 '[{"id":"a","text":"Singletons cannot be serialised, which breaks persistence layers"},{"id":"b","text":"Singletons violate encapsulation by exposing a public getInstance() method"},{"id":"c","text":"Singletons prevent use of the Open/Closed Principle because their class cannot be extended"},{"id":"d","text":"Singletons introduce global mutable state, making tests order-dependent and difficult to isolate from each other"}]'::jsonb,
 'd',
 'A Singleton is effectively a global variable. Tests that mutate singleton state can contaminate later tests. Injecting a dependency through the constructor is preferred — it makes the dependency explicit and replaceable with a test double.',
 true);

-- correct: b
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'HARD',
 'The Adapter pattern and the Facade pattern both wrap other objects. What is the key distinction?',
 '[{"id":"a","text":"Adapter adds new behavior; Facade only delegates without changing the interface"},{"id":"b","text":"Adapter converts one incompatible interface into another expected by the client; Facade simplifies a complex subsystem behind a single unified interface"},{"id":"c","text":"Facade converts interfaces to match client expectations; Adapter simplifies subsystem complexity"},{"id":"d","text":"Adapter always wraps a single object; Facade always wraps exactly two collaborating objects"}]'::jsonb,
 'b',
 'Adapter solves an interface mismatch — it makes an incompatible class work where a specific interface is expected. Facade reduces complexity — it provides a simple entry point into a set of subsystem classes without necessarily changing interfaces.',
 true);

-- correct: c
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'HARD',
 'When does a deep inheritance hierarchy (5+ levels) become a design problem?',
 '[{"id":"a","text":"It is never a problem because polymorphism is always more efficient with deeper hierarchies"},{"id":"b","text":"Deep inheritance is only a problem in dynamically typed languages where method resolution is slow"},{"id":"c","text":"Changes to a base class ripple unpredictably through all descendants, and understanding behavior requires traversing the full chain"},{"id":"d","text":"Deep inheritance is a problem only when the number of methods per class exceeds 20"}]'::jsonb,
 'c',
 'Each additional level increases the surface area for unintended side effects when a base class changes. It also makes the code hard to reason about in isolation. Composition provides equivalent flexibility without the depth.',
 true);

-- correct: a
INSERT INTO questions (id, topic, difficulty, stem, options, correct_option_id, explanation, active) VALUES
(gen_random_uuid(), 'OBJECT_ORIENTED_DESIGN', 'HARD',
 'Which SOLID principle most directly addresses a 1000-line "God class" that handles authentication, email sending, and database access?',
 '[{"id":"a","text":"Single Responsibility Principle — the class has multiple reasons to change and should be split into focused, single-purpose classes"},{"id":"b","text":"Open/Closed Principle — the God class should be left unchanged and extended via subclassing"},{"id":"c","text":"Dependency Inversion Principle — the God class should depend on abstractions for each of its responsibilities"},{"id":"d","text":"Liskov Substitution Principle — the class should not override inherited behavior from its base class"}]'::jsonb,
 'a',
 'A God class violates SRP by accumulating many unrelated responsibilities. Each responsibility (auth, email, database) becomes a separate reason the class might change. Splitting into AuthService, EmailService, and a repository restores single responsibility.',
 true);
