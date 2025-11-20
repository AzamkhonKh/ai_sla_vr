# ChatLearner System Diagrams - SysML Viewpoint Organization

## Overview
This directory contains **SysML 2.0 diagrams** organized by the **4 standard SysML viewpoints**, with **progressive abstraction levels** within each viewpoint. Each viewpoint answers a different question about the system.

---

## Quick Start: Choose Your Path

### 🎯 By Role

**Executives / Product Managers:**
→ Read [01_requirements/level_0/](01_requirements/level_0/) to understand WHAT the system must do (5 minutes)

**System Architects:**
→ Read [02_structure/level_0/](02_structure/level_0/) to see HOW components are organized (5-15 minutes)

**Developers:**
→ Read [03_behavior/level_1/](03_behavior/level_1/) to understand HOW the system behaves (15-30 minutes)

**ML Engineers / DevOps:**
→ Read [04_parametric/level_2/](04_parametric/level_2/) to see QUANTITATIVE constraints (30-45 minutes)

---

## 📚 The 4 SysML Viewpoints

### 1. **Requirements Viewpoint** (1 diagram)
**Path:** [01_requirements/](01_requirements/)

What functional and non-functional requirements drive system design?

**Start here:** [01_requirements/sysml-02-requirements.png](01_requirements/sysml-02-requirements.png)

**Covers:**
- Functional requirements (FR): Learn vocabulary, practice pronunciation, assess progress
- Non-functional requirements (NFR): Latency SLA, availability, scalability
- Traceability: Which components satisfy which requirements

---

### 2. **Structure Viewpoint** (10 diagrams)
**Path:** [02_structure/](02_structure/)

What components exist and how are they connected?

**Hierarchy (START → detailed):**
1. [sysml-bdd-00-top-level.png](02_structure/sysml-bdd-00-top-level.png) - Entire system as single block
2. [sysml-bdd-01-system.png](02_structure/sysml-bdd-01-system.png) - 3 layers: VR Client, Backend, Data
3. [sysml-bdd-02-backend.png](02_structure/sysml-bdd-02-backend.png) - 9 microservices
4. [sysml-bdd-03-ai-engine.png](02_structure/sysml-bdd-03-ai-engine.png) - AI models (STT, LLM, TTS)
5. [sysml-bdd-04-data-layer.png](02_structure/sysml-bdd-04-data-layer.png) - PostgreSQL, Redis, Milvus
6. [sysml-ibd-01-core.png](02_structure/sysml-ibd-01-core.png) - API Gateway internal structure
7. [sysml-ibd-02-ai.png](02_structure/sysml-ibd-02-ai.png) - Conversation service message flow
8. [sysml-ibd-03-llm-detailed.png](02_structure/sysml-ibd-03-llm-detailed.png) - LLM inference pipeline
9. [sysml-deployment-02-local.png](02_structure/sysml-deployment-02-local.png) - Hardware allocation

**Covers:**
- Component boundaries and responsibilities
- Port interfaces and message protocols
- Database schemas and storage
- Physical deployment and hardware allocation

---

### 3. **Behavior Viewpoint** (4 diagrams)
**Path:** [03_behavior/](03_behavior/)

How does the system behave over time? What are the interactions and state changes?

**Hierarchy (START → detailed):**
1. [sysml-usecase-01.png](03_behavior/sysml-usecase-01.png) - What can users do? (5 actors, 8+ use cases)
2. [sysml-seq-01-conversation.png](03_behavior/sysml-seq-01-conversation.png) - Message sequence during learning
3. [sysml-act-01-dialogue.png](03_behavior/sysml-act-01-dialogue.png) - Control flow and decision logic
4. [sysml-stm-01-interaction.png](03_behavior/sysml-stm-01-interaction.png) - State transitions and events

**Covers:**
- User stories and functional capabilities
- Step-by-step message interactions
- Parallel processing and error handling
- System state lifecycle

---

### 4. **Parametric Viewpoint** (6 diagrams)
**Path:** [04_parametric/](04_parametric/)

What are the quantities, constraints, and performance targets?

**Hierarchy (START → detailed):**
1. [sysml-par-03-simple.png](04_parametric/sysml-par-03-simple.png) - Top-level SLA (2s latency, 99.5% uptime)
2. [sysml-parametric-03-local-compute.png](04_parametric/sysml-parametric-03-local-compute.png) - Latency breakdown per component
3-6. [Detailed constraint blocks](04_parametric/README.md) - Computational power (TFLOPS), storage (GB), throughput (req/s)

**Covers:**
- **Latency budget:** 2.0 seconds end-to-end
  - STT: 300ms, Context: 200ms, LLM: 800ms, TTS: 400ms, Buffer: 300ms
- **Computational power:**
  - STT (Whisper): 1,550 TFLOPS
  - LLM (Llama 3.1 70B): 1,450 TFLOPS @ INT8
  - TTS (Piper): 120 TFLOPS
- **Hardware:**
  - 2× A100 80GB (LLM)
  - 1× T4 16GB (STT+TTS)
  - 4 vCPU, 256GB RAM orchestration
- **Data constraints:** 50GB PostgreSQL, 16GB Redis, 30GB Milvus

---

## Navigation Relationships

All viewpoints cross-reference each other. Example flows:

### Flow 1: "I need to add a new requirement"
1. Requirement: Add to [01_requirements/](01_requirements/)
2. Structure: Map to component in [02_structure/](02_structure/)
3. Behavior: Define interaction in [03_behavior/](03_behavior/)
4. Parametric: Add constraint to [04_parametric/](04_parametric/)

### Flow 2: "I need to trace a latency bottleneck"
1. Parametric: [sysml-parametric-03-local-compute.png](04_parametric/sysml-parametric-03-local-compute.png) - Find slow component
2. Behavior: [sysml-seq-01-conversation.png](03_behavior/sysml-seq-01-conversation.png) - See message sequence
3. Structure: [sysml-ibd-02-ai.png](02_structure/sysml-ibd-02-ai.png) - Find connections
4. Requirements: [01_requirements/](01_requirements/) - Check if optimizable

### Flow 3: "I need to plan hardware"
1. Parametric: [04_parametric/README.md](04_parametric/README.md) - Get TFLOPS, VRAM specs
2. Structure: [sysml-deployment-02-local.png](02_structure/sysml-deployment-02-local.png) - Physical allocation
3. Behavior: [03_behavior/](03_behavior/) - Understand concurrency needs

---

## File Organization

```
figures/
├── README.md (YOU ARE HERE)
│
├── 01_requirements/
│   ├── README.md
│   ├── sysml-02-requirements.mmd
│   └── sysml-02-requirements.png
│
├── 02_structure/
│   ├── README.md
│   ├── sysml-bdd-00-top-level.mmd/.png
│   ├── sysml-bdd-01-system.mmd/.png
│   ├── sysml-bdd-02-backend.mmd/.png
│   ├── sysml-bdd-03-ai-engine.mmd/.png
│   ├── sysml-bdd-04-data-layer.mmd/.png
│   ├── sysml-ibd-01-core.mmd/.png
│   ├── sysml-ibd-02-ai.mmd/.png
│   ├── sysml-ibd-03-llm-detailed.mmd/.png
│   └── sysml-deployment-02-local.mmd/.png
│
├── 03_behavior/
│   ├── README.md
│   ├── sysml-usecase-01.mmd/.png
│   ├── sysml-seq-01-conversation.mmd/.png
│   ├── sysml-act-01-dialogue.mmd/.png
│   └── sysml-stm-01-interaction.mmd/.png
│
└── 04_parametric/
    ├── README.md
    ├── sysml-par-03-simple.mmd/.png
    ├── sysml-parametric-03-local-compute.mmd/.png
    └── [4 more constraint blocks]
```

**Total: 21 diagrams, ~4.1MB**

---

## SysML Methodology

This documentation follows **SysML (Systems Modeling Language)** as defined by:
- **Friedenthal, Steward, & Delligatti (2014):** *Systems Engineering and Analysis with SysML*
- **OMG SysML v2.0 Specification** (formal reference)

**Why SysML?**
- Hierarchical abstraction: Scale from system overview to implementation details
- Multiple viewpoints: Requirements, structure, behavior, and parametric views
- Traceability: Link requirements to components to performance targets
- Industry standard: Used in aerospace, automotive, telecommunications, medical devices

---

## Abstraction Levels

All 4 viewpoints follow a consistent hierarchy:

**Level 0 (Top):** System overview at highest abstraction
- Single diagram showing entire system as one entity
- External interfaces and major subsystems
- Suitable for executives and project stakeholders

**Level 1 (Mid):** Component decomposition
- System broken into 3-4 major packages
- Each package has clear responsibility
- Suitable for architects and senior engineers

**Level 2 (Detailed):** Internal connections
- Inside components showing message flows, ports, protocols
- Performance annotations (latency, throughput)
- Suitable for implementation engineers

**Level 2+ (Ultra):** Hardware/algorithm specifics
- GPU memory management, token processing pipelines, cache strategies
- FLOPS calculations, VRAM allocation
- Suitable for performance engineers and operations teams

---

## Key Architectural Decisions

1. **Local On-Premises Deployment:**
   - All computation runs in customer's datacenter
   - No student data leaves facility (GDPR-friendly)
   - Latency advantage: No cloud round-trip

2. **Open-Source LLMs (Llama 3.1 70B):**
   - Fine-tuneable for educational domain
   - Lower operational costs vs closed-source APIs
   - Privacy: Model runs locally

3. **Hybrid Edge-Cloud:**
   - Mobile VR client: On-device STT cache + local models
   - Backend: Open-source LLM inference
   - Optional: Cloud LLM for peak load balancing (future)

4. **Microservice Architecture:**
   - Independent scaling per service
   - Fault isolation (one service failure ≠ system failure)
   - Technology diversity (different languages per service)

5. **2-Second Latency SLA:**
   - Research-backed: Cognitive load threshold
   - Achievable with local infrastructure
   - Requires careful resource allocation (documented in Parametric view)

---

## Generating Diagrams from Mermaid Source

All diagrams are defined in `.mmd` files (Mermaid syntax). Regenerate PNGs:

```bash
cd figures
for folder in 01_requirements 02_structure 03_behavior 04_parametric; do
  for f in $folder/*.mmd; do
    npx -p @mermaid-js/mermaid-cli mmdc -i "$f" -o "${f%.mmd}.png" \
      -b white -w 2200 -H 1800
  done
done
```

**Options:**
- `-b white`: White background (good for printing)
- `-w 2200 -H 1800`: Resolution for readable text
- Output: `.png` in same folder as `.mmd`

---

## Tips for Using These Diagrams

- **Print at 100% scale:** Text will be readable at 11pt font
- **Export to PowerPoint:** Copy `.png`, paste with "Keep Source Formatting"
- **Embed in technical specs:** All diagrams are royalty-free (created from SysML best practices)
- **Link in issue tracking:** Include diagram URLs in GitHub issues for context
- **Reference in meetings:** "See sysml-bdd-02-backend.png line 5" is more precise than verbal description

---

## Questions by Role

### **Project Manager:** "What does this project deliver?"
→ [03_behavior/sysml-usecase-01.png](03_behavior/sysml-usecase-01.png) - See 8+ use cases

### **Product Owner:** "What are the performance targets?"
→ [04_parametric/sysml-par-03-simple.png](04_parametric/sysml-par-03-simple.png) - 2s latency, 99.5% uptime

### **Architect:** "How are components connected?"
→ [02_structure/](02_structure/) - Full hierarchy of 10 diagrams

### **Backend Engineer:** "Where do I write code?"
→ [02_structure/sysml-bdd-02-backend.png](02_structure/sysml-bdd-02-backend.png) - See 9 microservices

### **AI Engineer:** "What models run where?"
→ [02_structure/sysml-bdd-03-ai-engine.png](02_structure/sysml-bdd-03-ai-engine.png) + [04_parametric/README.md](04_parametric/README.md) - TFLOPS specs

### **DevOps Engineer:** "What hardware do we need?"
→ [02_structure/sysml-deployment-02-local.png](02_structure/sysml-deployment-02-local.png) + [04_parametric/](04_parametric/) - GPU/CPU/storage allocation

### **QA Engineer:** "What scenarios should I test?"
→ [03_behavior/](03_behavior/) - See all interaction flows

### **Data Engineer:** "What's the data model?"
→ [02_structure/sysml-bdd-04-data-layer.png](02_structure/sysml-bdd-04-data-layer.png) - PostgreSQL, Redis, Milvus schema

---

## For Further Reading

Each folder's `README.md` contains:
- Detailed hierarchy explanations (Level 0 → Level 2+)
- Navigation by use case ("I need to...")
- SysML concepts and stereotypes used
- Cross-references to other viewpoints

**Start:** [02_structure/README.md](02_structure/README.md) - Most comprehensive

---

**Last Updated:** 2024 | **SysML Version:** v2.0 | **Mermaid Version:** 10.8+
