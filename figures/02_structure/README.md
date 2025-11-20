# Structure View (SysML)

## Purpose
This viewpoint shows **HOW** the system is physically and logically structured - components, interfaces, deployment architecture, and hardware configuration.

**SysML Standard:** Block Definition Diagrams (bdd), Internal Block Diagrams (ibd), and Package Diagrams fall under the Structure viewpoint, answering "What are the system's parts?"

**SysML Elements:** Block Definition Diagrams (BDD), Internal Block Diagrams (IBD), Deployment Diagrams

**Friedenthal Reference:** Chapters 5-6, 14 - Structural Models

---

## Hierarchy: Top-Down Abstraction

### Level 0: Top-Level System Boundary
**View:** Entire system as one block with external interfaces

- **sysml-bdd-00-top-level.png** ← **START HERE**
  - MundoVR Platform as single `<<system>>` block
  - 3 major subsystem ports: VR Client, Backend, Data Layer
  - External services: Cloud LLM, monitoring
  - System-level constraints: latency, availability

  **Why:** Understand the system boundary and highest-level decomposition

---

### Level 1: First Decomposition - Three Layers
**View:** System broken into 3 major packages

- **sysml-bdd-01-system.png**
  - Layer 1: VR Client (Unity 3D with on-device AI SDK)
  - Layer 2: Backend Services Platform (microservices)
  - Layer 3: Data Layer (databases + vector storage)
  - External dependencies: Cloud LLM, Kubernetes

  **Why:** See major system layers and their interactions

---

### Level 2a: Backend Decomposition
**View:** Backend Platform broken into service clusters

- **sysml-bdd-02-backend.png**
  - 9-10 microservices organized by responsibility
  - Core Services: API Gateway, User Management, Session Management
  - AI Services: STT, Conversation, TTS, Pronunciation
  - Support Services: Scenario, Analytics, Notifications
  - Data stores associated with each service

  **Why:** Understand microservice boundaries and responsibilities

---

### Level 2b: Data Layer Decomposition
**View:** Data storage systems and their purposes

- **sysml-bdd-04-data-layer.png**
  - PostgreSQL: Relational user/session data
  - Redis: Caching and pub/sub
  - Milvus: Vector embeddings for semantic search
  - Backup/archive strategy

  **Why:** Understand data persistence, caching, and indexing

---

### Level 2c: AI Engine Deep-Dive
**View:** AI services with detailed model specifications

- **sysml-bdd-03-ai-engine.png**
  - STT: Whisper Large v3 model, NVIDIA T4 GPU
  - LLM: Open-source models (Mistral, Llama 3.1) with FLOPS/memory specs
  - TTS: Piper model (multilingual)
  - Pronunciation: Phoneme analysis pipeline
  - **Computational requirements detailed:** TFLOPS, VRAM, latency targets

  **Why:** Understand AI model specifics for infrastructure planning

---

### Level 3: Internal Connections - Core Services
**View:** Inside API Gateway and Session Management

- **sysml-ibd-01-core.png**
  - Ports: HTTP/2 (8080), gRPC (50051)
  - Components: Auth Handler, Rate Limiter, Router
  - Data connections: PostgreSQL, Redis, Audit logs
  - Request flow through rate limiting to downstream services

  **Why:** Understand request routing, auth, and rate limiting mechanisms

---

### Level 3: Internal Connections - AI Services
**View:** Inside Conversation Service (main intelligence path)

- **sysml-ibd-02-ai.png**
  - User input → STT (Whisper) → Context Retrieval → LLM → Quality Check → TTS
  - Parallel operations: context lookup in Milvus, cache checks in Redis
  - Error handling and retry logic
  - Protocol details: gRPC for inter-service, HTTPS for cloud LLM

  **Why:** Understand the complete conversation flow and parallelization

---

### Level 3+: Ultra-Detailed LLM Connection
**View:** Inside LLM inference engine (hardware specifics)

- **sysml-ibd-03-llm-detailed.png**
  - LLM model selection logic (based on request load)
  - Token processing pipeline
  - GPU memory management
  - Fallback strategy when primary model overloaded
  - Latency breakdown per operation

  **Why:** For optimization and resource allocation decisions

---

### Deployment: Physical Infrastructure
**View:** Computers, networks, and hardware allocation

- **sysml-deployment-02-local.png** (On-Premises)
  - Server hardware: CPU cores, GPU cards (H100, A100), RAM
  - Network topology: Intra-datacenter communication
  - Local LLM deployment infrastructure
  - Storage arrays and backup systems

  **Why:** Understand physical deployment and hardware requirements

---

## Navigation by Use Case

### "I need to understand system decomposition"

1. Start: [sysml-bdd-00-top-level.png](sysml-bdd-00-top-level.png) - System boundary
2. Next: [sysml-bdd-01-system.png](sysml-bdd-01-system.png) - Three layers
3. Detail: [sysml-bdd-02-backend.png](sysml-bdd-02-backend.png) - Microservices

### "I need to add a new microservice"

1. Review: [sysml-bdd-02-backend.png](sysml-bdd-02-backend.png) - Current services
2. Check connections: [sysml-ibd-02-ai.png](sysml-ibd-02-ai.png) - Message flows
3. Validate: Use requirements traceability [../01_requirements/README.md](../01_requirements/README.md)

### "I need to optimize latency"

1. Path analysis: [sysml-ibd-02-ai.png](sysml-ibd-02-ai.png) - Critical path
2. AI bottleneck: [sysml-bdd-03-ai-engine.png](sysml-bdd-03-ai-engine.png) - Model specs
3. Detailed: [sysml-ibd-03-llm-detailed.png](sysml-ibd-03-llm-detailed.png) - LLM latency
4. Constraints: [../04_parametric/README.md](../04_parametric/README.md) - Latency budget

### "I need to plan hardware"

1. Overview: [sysml-deployment-02-local.png](sysml-deployment-02-local.png) - Server specs
2. AI specs: [sysml-bdd-03-ai-engine.png](sysml-bdd-03-ai-engine.png) - GPU requirements
3. Constraints: [../04_parametric/sysml-par-03-simple.png](../04_parametric/sysml-par-03-simple.png) - Resource limits

---

## SysML Concepts Used

**Block Definition Diagram (BDD):**
- Stereotypes: `<<system>>`, `<<block>>`, `<<service>>`, `<<component>>`, `<<database>>`
- Relationships: composition (`-*`), dependency (`..>`)
- Properties: ports (data flows), value types

**Internal Block Diagram (IBD):**
- Stereotypes: `<<part>>`, `<<port>>`, `<<flow>>`
- Connectors: solid arrows (synchronous), dotted arrows (asynchronous)
- Protocols: HTTP/2, gRPC, SQL, Redis, HTTPS

**Deployment Diagram:**
- Stereotypes: `<<executionEnvironment>>`, `<<artifact>>`, `<<node>>`
- Shows physical allocation of components to hardware
- Multi-zone redundancy, failover strategies

---

## Key Design Patterns

- **API Gateway Pattern:** Single entry point with auth, rate limiting, routing
- **Service Decomposition:** Functional isolation enabling independent scaling
- **Hybrid Edge-Cloud:** On-device for latency, cloud for complex AI
- **Data Locality:** Cache strategy (Redis) for frequent access patterns
- **GPU Allocation:** Dedicated hardware for STT and LLM inference

---

## Links to Other Viewpoints

- **Requirements Met By:** [../01_requirements/README.md](../01_requirements/README.md) - See which requirements each component satisfies
- **Behavior Flows:** [../03_behavior/README.md](../03_behavior/README.md) - See how components interact over time
- **Constraints Applied:** [../04_parametric/README.md](../04_parametric/README.md) - See resource limits and performance targets
