# ChatLearner System Diagrams - SysML Viewpoint Organization

## Overview
This directory contains **SysML 2.0 diagrams** that document the MundoVR system architecture. Diagrams are organized by file purpose and can be viewed directly in the `figures/` folder.

---

## Quick Start: Diagram Collections

### Overview Diagrams (`overview.png`)
System-level architecture, use cases, and deployment structure:
- **Use Cases** - What users can do (actors and interactions)
- **BDD System Context** - System boundary and external interfaces
- **BDD Platform Structure** - 3-layer architecture (VR Client, Backend, Data)
- **BDD Deployment** - Physical hardware allocation
- **Requirements** - Platform functional and non-functional requirements
- **AI Engine Specifications** - STT, LLM, TTS models and parameters

### Activity Diagrams (`activity.png`)
Detailed behavioral flows for key scenarios:
- **IBD Internal Structure** - MundoVR game component composition
- **Complete Session Activity** - End-to-end learning flow
- **Define Tasks Activity** - Task creation and assignment logic
- **Feedback Activity** - Assessment and corrective feedback loop
- **NPC Interaction Activity** - Real-time conversation flow

---

## 📚 Architecture Components

### System Layers (3-Layer Architecture)

**Layer 1: VR Client**
- Unity 3D with on-device AI SDK
- Speech input capture, NPC interaction interface
- Local pronunciation analysis, immediate visual feedback

**Layer 2: Backend Services**
- 9 microservices: API Gateway, User Management, Session Management, STT, Conversation Engine, TTS, Pronunciation Analysis, Scenario Service, Analytics
- Kubernetes-orchestrated deployment
- REST/WebSocket APIs for VR client communication

**Layer 3: Data Layer**
- **PostgreSQL:** User profiles, session history, learning analytics (50GB)
- **Redis:** Conversation context cache, session management, pub/sub (16GB)
- **Milvus:** Vector embeddings for semantic similarity search (30GB)

### AI Models & Performance Constraints

**Speech-to-Text (STT):**
- Model: Whisper Large v3
- Hardware: NVIDIA T4 16GB
- Computational: 1,550 TFLOPS
- Latency Budget: 300ms

**Language Model (LLM):**
- Models: Llama 3.1 70B or Mistral 7B (INT8 quantization)
- Hardware: 2× A100 80GB
- Computational: 1,450 TFLOPS @ INT8
- Latency Budget: 800ms

**Text-to-Speech (TTS):**
- Model: Piper (multilingual)
- Computational: 120 TFLOPS
- Latency Budget: 400ms

**Pronunciation Analysis:**
- Custom phoneme analysis pipeline
- Latency Budget: Part of context retrieval (200ms)

### End-to-End Latency Budget: 2.0 seconds (Hard Constraint)
- STT: 300ms
- Context retrieval (Redis): 200ms
- LLM inference: 800ms
- TTS generation: 400ms
- Buffer/Network: 300ms

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
├── overview.png - System architecture, use cases, deployment, requirements
├── activity.png - Behavioral flows for key scenarios
├── figure10_pedagogical_loop.puml - Pedagogical feedback loop
├── figure10_pedagogical_loop.png - Rendered pedagogical loop
├── PRISMA (1).csv - Research methodology data
├── prisma.png - PRISMA flow diagram
├── regenerate_all.sh - Script to regenerate diagrams
└── render_mermaid.js - Mermaid rendering utility
```lligatti (2014):** *Systems Engineering and Analysis with SysML*
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
- SMethodology

This documentation follows **MBSE (Model-Based Systems Engineering)** with **SysML 2.0** principles:
- Single source of truth: Diagrams define the authoritative system design
- Traceability: Requirements link to components, which link to constraints
- Viewpoint separation: Architecture, behavior, and performance concerns separated
- Progressive detail: From system overview to implementation specifics

See `SCOPE_OF_WORK_SYSML.md` for full methodology documentation and `../index.tex` for academic framing.
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
