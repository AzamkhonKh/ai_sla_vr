# Requirements View (SysML)

## Purpose
This viewpoint captures **WHAT** the ChatLearner system must do - functional requirements, non-functional requirements, and use cases showing user interactions.

**SysML Standard:** Requirements diagrams and Use Case diagrams fall under the Requirements viewpoint, answering "What must the system provide?"

**SysML Diagram Types:** Requirement Diagram

**Friedenthal Reference:** Chapter 11 - Modeling Requirements

---

## Diagrams in this Folder

### REQ-01: Requirements Traceability
**File:** `sysml-02-requirements.mmd` → `sysml-02-requirements.png`

**Description:** Complete requirements traceability matrix showing:
- **Main Research Question** → 3 Sub-RQs
  - RQ1: Microservices decomposition for latency/scalability
  - RQ2: AI service integration (STT, LLM, TTS)
  - RQ3: VR-backend latency optimization
- **6 Functional Requirements (FR):**
  - FR1: STT accuracy >90%
  - FR2: LLM-based dialogue generation
  - FR3: TTS with prosody
  - FR4: Phoneme-level pronunciation analysis
  - FR5: Adaptive difficulty adjustment
  - FR6: User profile persistence
- **5 Non-Functional Requirements (NFR):**
  - NFR1: Latency p99 ≤1.5s
  - NFR2: 10K concurrent users
  - NFR3: 99.5% availability
  - NFR4: Data retention 12 months (RPO 1h, RTO 4h)
  - NFR5: Security (TLS 1.3, GDPR compliance)
- **Traceability Links:**
  - Derivation: RQ `-.derives.->` FR/NFR
  - Satisfaction: FR/NFR `==>|satisfied by|` Components

**Stereotypes:** `<<requirement>>`

**Relationships:** 
- `derives` (requirement decomposition)
- `satisfies` (component allocation)

---

## Next Level: Navigate to Structure

Once requirements are defined, proceed to:
- **`../02_structure/`** - See how requirements map to system components (BDD/IBD)
- **`../03_behavior/`** - See how requirements drive behavioral specifications
- **`../04_parametric/`** - See how NFRs translate to quantitative constraints

---

## Usage

To generate PNG from this diagram:
```bash
npx -p @mermaid-js/mermaid-cli mmdc -i sysml-02-requirements.mmd -o sysml-02-requirements.png -b white -w 2400 -H 2000
```
