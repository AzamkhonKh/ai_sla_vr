# 03. Behavior Viewpoint - System Dynamics

**Purpose:** Define HOW the system behaves over time (interactions, sequences, state transitions)

**SysML Elements:** Sequence Diagrams, Activity Diagrams, Use Case Diagrams, State Machine Diagrams

**Friedenthal Reference:** Chapters 7-10 - Behavioral Models

---

## Hierarchy: Interaction Paths

### Level 0: Use Case Overview
**View:** What users do with the system

- **sysml-usecase-01.png** ← **START HERE**
  - 5 primary actors: Student, Instructor, System Admin, External LLM, Mobile VR Client
  - 8-10 use cases: Learn vocabulary, Practice pronunciation, Assess progress, etc.
  - System boundary: MundoVR Platform
  - High-level functional goals

  **Why:** Understand user stories and system capabilities at a glance

---

### Level 1: Conversation Flow - Sequence Diagram
**View:** Step-by-step message interactions during learning

- **sysml-seq-01-conversation.png**
  - Actors: Student, VR Client, Backend Services, LLM, Data Store
  - Main sequence: User speaks → transcribed → LLM processes → response generated → TTS → student hears
  - Parallel flows: Database lookups, cache checks, confidence scoring
  - Error handling branches: Invalid input, LLM timeout, TTS failure

  **Why:** See exact timing and message passing between components

---

### Level 2a: Learning Session Activity
**View:** Decision logic and control flow during learning

- **sysml-act-01-dialogue.png**
  - Start: Student initiates conversation
  - Decision nodes: Is input valid? Language detected? Confidence sufficient?
  - Activities: Process request, query database, call LLM, generate response
  - Parallel: Update statistics, store to history, send notifications
  - End: Student receives feedback

  **Why:** Understand conditional branching and process flow

---

### Level 2b: System State Transitions
**View:** How system states change based on events

- **sysml-stm-01-interaction.png**
  - States: Idle, Listening, Processing, Speaking, Recording, Analyzing
  - Transitions: Based on events (audio received, LLM responds, error occurs)
  - Guard conditions: [confidence > threshold], [request_time < SLA]
  - Actions: Start timer, emit event, log interaction

  **Why:** Understand when system changes states and what triggers transitions

---

## Navigation by Use Case

### "I need to understand a user story"

1. Find: [sysml-usecase-01.png](sysml-usecase-01.png) - Locate the use case
2. Detail: [sysml-seq-01-conversation.png](sysml-seq-01-conversation.png) - Message flow
3. Validate: [../01_requirements/README.md](../01_requirements/README.md) - Check requirements trace

### "I need to add error handling"

1. Current flow: [sysml-act-01-dialogue.png](sysml-act-01-dialogue.png) - Activity diagram
2. Transitions: [sysml-stm-01-interaction.png](sysml-stm-01-interaction.png) - State machine
3. Sequence impact: [sysml-seq-01-conversation.png](sysml-seq-01-conversation.png) - Message changes

### "I need to optimize response time"

1. Sequence analysis: [sysml-seq-01-conversation.png](sysml-seq-01-conversation.png) - Find latency points
2. Activity analysis: [sysml-act-01-dialogue.png](sysml-act-01-dialogue.png) - Find serial bottlenecks
3. Constraints: [../04_parametric/README.md](../04_parametric/README.md) - Latency budget
4. Structure impact: [../02_structure/README.md](../02_structure/README.md) - Component optimization

### "I need to trace a specific flow"

1. Use case: [sysml-usecase-01.png](sysml-usecase-01.png) - What does user do?
2. Sequence: [sysml-seq-01-conversation.png](sysml-seq-01-conversation.png) - What messages?
3. Activity: [sysml-act-01-dialogue.png](sysml-act-01-dialogue.png) - What decisions?
4. States: [sysml-stm-01-interaction.png](sysml-stm-01-interaction.png) - What state changes?

---

## SysML Concepts Used

**Use Case Diagram:**
- Stereotypes: `<<actor>>`, `<<usecase>>`, `<<system>>`
- Relationships: `include` (mandatory), `extend` (optional), `generalization`
- Describes functional requirements from user perspective

**Sequence Diagram:**
- Lifelines: Vertical lines representing objects/components
- Messages: Arrows showing synchronous (`→`) and asynchronous (`-->`) calls
- Combined fragments: `alt` (alternatives), `par` (parallel), `loop`, `ref` (references)
- Timing constraints: Latency annotations on messages

**Activity Diagram:**
- Actions: Rounded rectangles representing operations
- Decision nodes: Diamond shapes for conditional logic
- Merges: Join points for control flow
- Fork/Join: Parallel execution representations
- Object flows: Data passing between actions

**State Machine Diagram:**
- States: Circles representing modes of operation
- Transitions: Arrows labeled with `event [guard] / action`
- Initial/Final: Filled circle and target symbol
- Composite states: States containing substates

---

## Execution Contexts

**STT Execution Context:**
- Input: Audio stream from VR microphone
- Processing: Whisper model transcribes in real-time
- Output: Text transcript with confidence score
- Timeout: 10 seconds max per utterance

**LLM Execution Context:**
- Input: User transcript + conversation history + context vectors
- Processing: Token generation loop with max 200 tokens
- Output: Response text with quality score
- Timeout: 5 seconds max (2 seconds for mobile cache hit)

**TTS Execution Context:**
- Input: Response text + language selection
- Processing: Piper model synthesizes speech with prosody
- Output: Audio stream to VR headphone
- Timeout: 3 seconds max (300ms for cached audio)

---

## Error Scenarios Covered

1. **STT Timeout:** No audio input within 10 seconds → ask user to repeat
2. **LLM Overload:** Response time > 5 seconds → fall back to cached answer
3. **TTS Failure:** Speech generation fails → provide text transcript instead
4. **Network Latency:** Backend response > SLA → show spinner + retry
5. **Invalid Input:** User input not recognized → clarification prompt

---

## Key Interaction Patterns

- **Request-Response:** Most common (VR client → Backend services)
- **Publish-Subscribe:** Event notifications (pronunciation assessed → update UI)
- **Cache-Aside:** Check Redis before querying Milvus
- **Bulkhead:** STT, LLM, TTS run in separate thread pools
- **Circuit Breaker:** Disable LLM calls if error rate > 50%

---

## Links to Other Viewpoints

- **Requirements Implemented By:** [../01_requirements/README.md](../01_requirements/README.md) - See which FR/NFR each sequence satisfies
- **Realized By Structure:** [../02_structure/README.md](../02_structure/README.md) - See which components execute each activity
- **Constrained By:** [../04_parametric/README.md](../04_parametric/README.md) - See timing and resource budgets per interaction
