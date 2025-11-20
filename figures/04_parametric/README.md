# Parametric View (SysML)

## Purpose
This viewpoint captures **QUANTITATIVE CONSTRAINTS** - performance metrics, computational requirements, resource budgets, and mathematical relationships between parameters.

**SysML Standard:** Parametric Diagrams (par) fall under the Parametric viewpoint, answering "What are the mathematical relationships and constraints?" This is unique to SysML (not in UML).

**SysML Elements:** Parametric Diagrams, Constraint Blocks, Value Types

**Friedenthal Reference:** Chapter 11 - Parametric Models

---

## Hierarchy: Constraint Models

### Level 0: System-Level Constraints
**View:** Top-level performance and resource budgets

- **sysml-par-03-simple.png** ← **START HERE**
  - **Latency SLA:** End-to-end user request ≤ 2 seconds
  - **Throughput:** ≥ 100 concurrent students per region
  - **Availability:** ≥ 99.5% uptime (SLA target)
  - **Quality:** LLM response confidence ≥ 0.85
  - **Storage:** ≤ 500GB conversation history per 10K students
  - **Bandwidth:** ≤ 100 Mbps per region

  **Why:** Understand top-level targets driving all design decisions

---

### Level 1: Latency Breakdown
**View:** Where the 2-second budget is spent

- **sysml-parametric-03-local-compute.png**
  - **User Input → STT:** ≤ 300ms (Whisper Large v3, NVIDIA T4)
  - **STT → Context Retrieval:** ≤ 200ms (Redis cache hit + Milvus vector search)
  - **Context → LLM:** ≤ 800ms (Llama 3.1 70B, local deployment)
  - **LLM → TTS:** ≤ 400ms (Piper model, phoneme synthesis)
  - **TTS → Audio Output:** ≤ 100ms (buffer to VR headset)
  - **Total:** 1,800ms (90% of 2-second budget, 10% overhead)

  **Why:** Identify per-component latency targets and hardware requirements

---

### Level 2a: Computational Requirements (Local On-Premises)
**View:** Hardware specifications for all ML models

- **STT Model (Whisper Large v3):**
  - TFLOPS: 1,550 TFLOPS @ FP32
  - VRAM: 3.5GB (on NVIDIA T4)
  - GPU allocation: 1× T4 (16GB, shared with TTS)
  - Throughput: 100 requests/second
  - Latency: 200-500ms per request

- **LLM Model (Llama 3.1 70B - Primary):**
  - TFLOPS: 1,450 TFLOPS @ INT8 quantization
  - VRAM: 40GB (on NVIDIA A100 40GB)
  - GPU allocation: 2× A100 80GB (tensor parallel)
  - Throughput: 15 requests/second
  - Latency: 800-1200ms for typical response (200 tokens)
  - Context: 8K token window, 128K supported

- **TTS Model (Piper - Open Source):**
  - TFLOPS: 120 TFLOPS @ FP32
  - VRAM: 0.8GB (on NVIDIA T4, shared with STT)
  - GPU allocation: Shared T4 with STT
  - Throughput: 50 requests/second
  - Latency: 100-300ms per request (multilingual prosody)

- **Orchestration Compute:**
  - CPU cores: 4 vCPU (Intel Xeon, 3.5 GHz)
  - RAM: 256GB (for caching + buffer)
  - Storage IOPS: 10K IOPS for database

  **Why:** Determine exact hardware procurement

---

### Level 2b: Data Constraints
**View:** Storage, query performance, and data volume limits

- **PostgreSQL (Relational):**
  - Max tables: users, sessions, conversations, scores (4 main)
  - Max row size: ≤ 10KB per conversation turn
  - Query latency: ≤ 100ms for typical SELECT (with index)
  - Storage: ≤ 50GB per 10K concurrent students
  - Backup: Daily snapshots, 7-day retention

- **Redis (Cache):**
  - Memory: 16GB (TTL strategy, 1-hour default)
  - Ops/sec: ≥ 50K GET/SET operations
  - Latency: ≤ 5ms per operation
  - Eviction policy: LRU (least recently used)
  - Key format: user:{id}:session:{sid}:cache

- **Milvus (Vector Database):**
  - Dimensions: 768 (OpenAI text-embedding-3-small)
  - Collection size: ≤ 10M embeddings per region
  - Query latency: ≤ 100ms for top-k=5 search
  - Recall: ≥ 0.90 @ k=5
  - Backup: Weekly full export

  **Why:** Understand database constraints and scaling limits

---

### Level 2c: Network & Infrastructure
**View:** Communication and deployment resource constraints

- **Network Bandwidth:**
  - Intra-datacenter: 10 Gbps (LAN)
  - Inter-region: 1 Gbps (WAN, backup)
  - Student → Backend: ≤ 100 Mbps peak
  - Backend → LLM: ≤ 500 Mbps peak (batching for 100 concurrent)

- **Storage Architecture:**
  - PostgreSQL data: 50GB SSD (RAID 10)
  - Redis persistent: 8GB RDB snapshots (RAID 1)
  - Milvus vectors: 30GB SSD (RAID 10)
  - Backup archive: 100GB slow storage (monthly retention)

- **Deployment Topology:**
  - Primary zone: 2× servers (HA active-passive)
  - Standby zone: 1× server (failover)
  - Geographic: Europe (primary), N. America (secondary replication)

  **Why:** Plan for redundancy and disaster recovery

---

### Level 3: Quality Attributes
**View:** Non-functional requirements quantified

- **Performance:**
  - P50 latency (median): 1.2 seconds
  - P95 latency: 1.8 seconds
  - P99 latency: 2.0 seconds (SLA boundary)

- **Reliability:**
  - MTBF (Mean Time Between Failures): ≥ 720 hours (30 days)
  - MTTR (Mean Time To Recovery): ≤ 15 minutes (auto failover)
  - Error rate: ≤ 0.1% (acceptable errors per 1000 requests)
  - Data durability: RPO (Recovery Point Objective) = 1 hour

- **Scalability:**
  - Concurrent users per region: 100 → 1,000 (10× growth)
  - Horizontal scaling: Add GPU node → +15 req/s throughput
  - Vertical scaling: Upgrade H100 → +20% performance

- **Security:**
  - Auth token TTL: 1 hour (short-lived)
  - Password hash: bcrypt 12 rounds (≥128 bits entropy)
  - TLS version: ≥ 1.3 (encryption minimum)
  - GDPR compliance: Data deletion within 30 days

  **Why:** Quantify non-functional requirements for testing

---

## Formula & Derivations

### Latency Budget Equation
$$\text{Total Latency} = t_{\text{STT}} + t_{\text{context}} + t_{\text{LLM}} + t_{\text{TTS}} + t_{\text{network}}$$

$$2.0 \text{ seconds} = 0.3 + 0.2 + 0.8 + 0.4 + 0.3 \text{ seconds}$$

### Throughput Calculation (LLM)
$$\text{Throughput} = \frac{\text{Batch Size} \times \text{GPU Memory}}{(\text{Weights} + \text{Activations}) \times \text{Tensor Size}}$$

$$15 \text{ req/s} = \frac{2 \times 80\text{GB}}{(70\text{B} \times 2\text{ bytes INT8} + \text{activations})}$$

### Storage Growth Projection
$$\text{Storage}(t) = \text{Base} + (t \times \text{Users} \times \text{Records/User} \times \text{Record Size})$$

$$50\text{GB} = 10\text{GB} + (1 \text{ year} \times 10\text{K} \times 10 \text{ records} \times 400\text{B})$$

---

## Constraint Rationale

**Why 2-second SLA?**
- Cognitive load research: 1-2 seconds is threshold for perceived responsiveness
- Mobile network reality: WiFi latency adds ~200ms, cellular adds ~400ms
- VR headset comfort: Long waits cause motion sickness
- Learning effectiveness: >3 seconds breaks conversation flow

**Why Llama 3.1 70B instead of GPT-4o?**
- Local deployment: No cloud round-trip latency
- Cost per token: 70B open-source ≤ $0.005 per 1M tokens vs closed-source $0.03-0.06
- Privacy: All computation on-premises, no user data leaves facility
- Customization: Fine-tune on educational corpus

**Why 10 Gbps intra-datacenter network?**
- LLM model size: 70B parameters × 2 bytes (INT8) = 140GB/transfer at model reload
- Throughput math: 140GB ÷ 10 Gbps ≈ 112 seconds (acceptable for 24-hour reload cycle)
- Redundancy: Parallel data paths for HA failover

---

## Verification & Testing

**Latency Verification:**
- Load test: 100 concurrent users, measure P95 latency
- Requirement: ≤ 1.8 seconds → PASS if < 1800ms
- Profiling: Each component must log its portion

**Throughput Verification:**
- Stress test: Increase load until 15 req/s LLM throughput is reached
- Monitoring: Alert if queue depth > 10 (indicating bottleneck)

**Storage Verification:**
- Database size: Query `SELECT pg_database_size()` weekly
- Alert: If growth > 2GB/week (abnormal pattern)

---

## Links to Other Viewpoints

- **Requirements Defined By:** [../01_requirements/README.md](../01_requirements/README.md) - See which NFRs constrain this
- **Implemented In Structure:** [../02_structure/README.md](../02_structure/README.md) - See which components deliver these constraints
- **Executed In Behavior:** [../03_behavior/README.md](../03_behavior/README.md) - See how these latency targets are met
