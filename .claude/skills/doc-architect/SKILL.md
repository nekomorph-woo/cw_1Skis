---
name: doc-architect
description: This skill should be used when the user asks to "organize brainstorming notes", "convert ideas to documents", "generate engineering documents from discussions", "structure thoughts into specs", or mentions transforming unstructured content (meeting notes, brainstorming sessions, conversation logs) into standardized engineering documentation (PRD, architecture docs, API specs, etc.).
version: 1.0.0
---

# Doc Architect - Document Standard Operating Procedure

This skill transforms unstructured brainstorming notes, meeting records, or conversation logs into standardized engineering documentation through a systematic "Thinking Funnel" workflow.

## Core Workflow

Execute the following phases in order when this skill is triggered:

---

### Phase 0: User Intent Confirmation & Input Collection

**Goal:** Gather necessary information to proceed with document generation.

**Actions:**

1. **Confirm Input Source**
   - Ask user to provide the path to the brainstorming document
   - OR detect `*.md` files in current directory and present selection
   - Accept formats: Markdown (`.md`), Text (`.txt`)

2. **Confirm Output Directory**
   - Default: `./docs/`
   - Allow user to specify custom path

**Output:** Validated input file path and output directory path

---

### Phase 1: Template Scheme Selection

**Goal:** Determine which document template structure to use.

**Present the following options to the user:**

```
[A] General Engineering Documentation (Recommended)
    ├── 01_PRD.md (Product Requirements)
    ├── 02_System_Architecture.md
    └── 03_API_Documentation.md

[B] Simplified Universal Template
    ├── 01_Problem_Definition.md
    ├── 02_Solution_Design.md
    └── 03_Action_Plan.md

[C] Custom Template Path
    → User provides template directory path
```

**Actions:**

- Wait for user selection (A/B/C)
- If A or B: Load corresponding templates from `templates/option-a/` or `templates/option-b/`
- If C: Prompt user for custom template path and load from that location

**Output:** Selected template scheme loaded into memory

---

### Phase 2: Raw Capture (Fragment Collection)

**Input:** User-specified brainstorming document

**Actions:**

1. Read the entire input document
2. Execute extraction logic from `prompts/1_extraction.md`
3. Generate Key Points List with the following structure:
   - Keyword list
   - New concepts list
   - Decision points list
   - Question points list
4. **Write intermediate output** to `OUTPUT_DIR/00_Key_Points_List.md`

**Reference:** Use `prompts/1_extraction.md` for detailed extraction rules

**Output:**
- `00_Key_Points_List.md` - Visible intermediate product for user verification
- Key Points List loaded in memory for next phase

---

### Phase 3: Core Extraction & Categorization

**Input:** Key Points List from Phase 2

**Actions:**

Apply the three-dimensional classification framework:

```
[Dimension 1] Business / Value
├── Pain Points (Why is this needed?)
├── Core Interaction (How does user operate it?)
└── Value Proposition (What makes it better?)

[Dimension 2] Technical / Architecture
├── Data Flow (Where does data come from? How is it processed?)
├── Key Components (Which modules are involved?)
└── Constraints (Security policies? Performance requirements?)

[Dimension 3] Specs / Constraints
├── Input/Output (What are the formats?)
├── Directory Structure (Where should files be placed?)
└── Error Handling (What happens on failure?)
```

4. **Write intermediate output** to `OUTPUT_DIR/01_Structured_Notes.md`

**Output:**
- `01_Structured_Notes.md` - Visible intermediate product for user verification
- Structured Notes loaded in memory for document mapping

---

### Phase 4: Document Mapping & Generation

**Input:** Structured Notes from Phase 3, selected templates from Phase 1

**For each template file T in selected template scheme:**

1. **Load Template Skeleton**
   - Read T's markdown structure
   - Identify placeholders/sections to fill

2. **Apply Mapping Logic**
   - Use `prompts/2_mapping.md` for mapping rules
   - Map Structured Notes to corresponding sections in template

3. **Check Target File**
   - IF file exists: Read existing content → Perform diff → Merge differences → Preserve non-conflicting parts
   - IF file doesn't exist: Create new file directly

4. **Write File**
   - Output path: `OUTPUT_DIR/T.md`

**Mapping Relationships:**

- Template A (General Engineering) ← Structured Notes
- Template B (Simplified Universal) ← Structured Notes
- Template C (User Custom) ← Structured Notes

**Reference:** Use `prompts/2_mapping.md` for detailed mapping rules

**Output:** Generated/updated document files in output directory

---

### Phase 4.5: Value Detail Capture (Long-Tail Content Preservation)

**Goal:** Capture valuable details that don't fit into template structure but may be important later.

**Input:**
- Structured Notes from Phase 3 (`01_Structured_Notes.md`)
- Key Points List from Phase 2 (`00_Key_Points_List.md`)
- Original brainstorming document
- Generated final documents from Phase 4

**Actions:**

1. **Identify Unmapped Content**
   - Compare `01_Structured_Notes.md` against all generated final documents
   - Identify Structured Notes entries that were NOT mapped to any final document
   - Check `00_Key_Points_List.md` for items not represented in final documents

2. **Assess Value of Unmapped Content**
   For each unmapped item, evaluate:
   - **Relevance**: Could this be useful in future iterations?
   - **Uniqueness**: Is this a unique insight or perspective?
   - **Implementability**: Could this become a feature/requirement later?
   - **Context Value**: Does this provide important context?

3. **Categorize Unmapped Value Details**
   Organize valuable unmapped content into categories:
   - **Future Considerations**: Ideas for future versions
   - **Alternative Approaches**: Discarded options worth documenting
   - **Implementation Details**: Technical nuances not fitting templates
   - **User Insights**: User feedback or preferences
   - **Edge Cases**: Corner cases or special scenarios
   - **Dependencies**: External factors or relationships
   - **Open Questions**: Unresolved items needing attention

4. **Generate Value Details Document**
   Write to `OUTPUT_DIR/99_Value_Details_Outside_Template.md` with structure:
   ```markdown
   # Value Details Outside Template Scope

   This document captures valuable details from the original brainstorming
   that did not fit into the standardized template structure but may be
   important for future reference or iteration.

   ## Generation Context
   - Input File: [INPUT_FILE]
   - Template Scheme: [A/B/C]
   - Generated On: [DATE]

   ## Future Considerations
   | Idea | Description | Potential Value |
   |------|-------------|-----------------|
   | [Idea] | [Detail] | [Why valuable] |

   ## Alternative Approaches
   | Approach | Why Discarded | When to Reconsider |
   |----------|---------------|-------------------|
   | [Approach] | [Reason] | [Condition] |

   ## Implementation Details
   | Detail | Context | Reference |
   |--------|---------|-----------|
   | [Detail] | [Context] | [Source] |

   ## User Insights
   | Insight | Source | Implication |
   |---------|--------|-------------|
   | [Insight] | | |

   ## Edge Cases
   | Case | Description | Handling Consideration |
   |------|-------------|------------------------|
   | [Case] | | |

   ## Dependencies
   | Dependency | Type | Impact |
   |-------------|------|--------|
   | [Dependency] | | |

   ## Open Questions
   | Question | Priority | Suggested Resolution |
   |----------|----------|----------------------|
   | [Question] | | |
   ```

5. **Cross-Reference Validation**
   - Ensure no duplication with final documents
   - Verify accuracy against original source
   - Tag each item with source reference (e.g., `[Source: Original Doc, Line 45]`)

**Output:**
- `99_Value_Details_Outside_Template.md` - Mandatory output for all template schemes

**Quality Criteria:**
- Every valuable unmapped item should be captured
- Clear categorization for easy reference
- Source traceability maintained
- Non-redundant with final documents

---

### Phase 5-A: Iterative Validation & Correction

**Goal:** Ensure documents accurately reflect original intent

**Fact Sources (Priority Order):**
1. ✓ Original brainstorming document (Primary - `INPUT_FILE`)
2. ✓ `00_Key_Points_List.md` (Secondary - raw extraction)
3. ✓ `01_Structured_Notes.md` (Tertiary - categorized extraction)
4. ✗ Generated documents (`02_*.md`, `03_*.md`, etc.) - NOT allowed as reference

**For each generated document D:**

```
Iteration 1: Error Check
→ Compare against original document
→ Check for misinterpretations
→ Mark suspicious content
→ Correct or ask user for clarification

Iteration 2: Omission Check
→ Compare against original document
→ Check for missing key points
→ Supplement omitted content

Iteration 3: Contradiction Check
→ Check for internal contradictions within document
→ Check for contradictions with original document
→ Resolve contradictions or mark for discussion
```

**Output:** Validated and corrected documents

---

### Phase 5-B: Cross-Document Consistency Check

**Constraint:** Never use generated documents to cross-reference each other. Always use original document and intermediate products as the source of truth.

**Fact Sources:**
1. ✓ Original brainstorming document (`INPUT_FILE`) - Primary
2. ✓ `00_Key_Points_List.md` - Raw extraction reference
3. ✓ `01_Structured_Notes.md` - Categorized extraction reference
4. ✗ Generated documents - NOT allowed for cross-reference

**Execute the following checks:**

```
Check 1: Concept Consistency
→ Are definitions of the same concept consistent across documents?
→ Verify against original document

Check 2: Process Consistency
→ Do workflows described in different documents align?
→ Verify against original document

Check 3: Constraint Consistency
→ Are technical/business constraints consistent across documents?
→ Verify against original document
```

**IF conflicts found:**
- Record conflict points
- Return to original document to verify facts
- Correct relevant documents

**Output:** Consistent document set with no cross-document conflicts

---

### Phase 6: Execution Report

**Generate comprehensive report including:**

**1. File Creation Summary**
```
✓ Intermediate Products Created:
  - 00_Key_Points_List.md (Raw extraction)
  - 01_Structured_Notes.md (Categorized extraction)

✓ Final Documents Created: [list]
✓ Final Documents Updated: [list] with merge statistics

✓ Value Details Document (Mandatory):
  - 99_Value_Details_Outside_Template.md
    - Future Considerations: N items
    - Alternative Approaches: N items
    - Implementation Details: N items
    - User Insights: N items
    - Edge Cases: N items
    - Dependencies: N items
    - Open Questions: N items
```

**2. Diff Summary**
For each updated file:
```
→ [filename.md]
  - Added: N sections
  - Modified: N sections
  - Deleted: N sections
  - Unchanged: N sections
```

**3. Quality Report**
```
→ Errors Corrected: N items
→ Omissions Supplemented: N items
→ Contradictions Resolved: N items
→ Cross-Document Conflicts: N items
```

**4. Action Items**
```
→ Manual Review Points: [list]
→ Information Still Needed: [list]
```

**Output:** Print report to user for review

---

## Constraints & Guidelines

### Writing Style

- Use **imperative/infinitive form** (verb-first instructions)
- Avoid second person ("You should...")
- Be objective and instructional

### Fact Source Rules

| Phase | Fact Sources | NOT Allowed |
|-------|--------------|-------------|
| **P5-A** | Original doc → `00_Key_Points_List.md` → `01_Structured_Notes.md` | ❌ Using generated docs (`02_*.md`+) as reference |
| **P5-B** | Original doc → `00_Key_Points_List.md` → `01_Structured_Notes.md` | ❌ Cross-referencing generated docs |

### Merge Strategy

| Strategy | Behavior |
|----------|----------|
| **Diff** | Identify added/modified/deleted sections |
| **Merge** | Merge differences into existing document |
| **Preserve** | Keep non-conflicting parts unchanged |

### Progressive Disclosure

- **SKILL.md** (this file): Core workflow and process (keep lean, ~2,000 words)
- **prompts/1_extraction.md**: Detailed extraction rules
- **prompts/2_mapping.md**: Detailed mapping rules and templates
- **templates/**: Actual document templates

---

## Additional Resources

### Prompt Files

- **`prompts/1_extraction.md`** - Raw capture and categorization logic
- **`prompts/2_mapping.md`** - Document mapping and generation rules

### Template Directories

- **`templates/option-a/`** - General engineering documentation templates
- **`templates/option-b/`** - Simplified universal templates

---

## Usage Example

```bash
# In Claude Code CLI
> "Use doc-architect skill to process brainstorm.md and generate engineering docs"
```

The skill will:
1. Ask for input file path (or detect markdown files)
2. Present template options (A/B/C)
3. Execute the Thinking Funnel workflow
4. Generate **intermediate products** in `./docs/`:
   - `00_Key_Points_List.md` - Raw extraction from brainstorm
   - `01_Structured_Notes.md` - Categorized extraction
5. Generate **final documents** in `./docs/`:
   - `02_PRD.md`, `03_System_Architecture.md`, etc. (based on selected template)
6. Generate **value details document** (mandatory for all template schemes):
   - `99_Value_Details_Outside_Template.md` - Valuable details not fitting templates
7. Provide execution report with diff summary

### Output File Structure

```
docs/
├── 00_Key_Points_List.md              # Intermediate: Raw extraction
├── 01_Structured_Notes.md             # Intermediate: Categorized extraction
├── 02_PRD.md                          # Final: Product Requirements
├── 03_System_Architecture.md          # Final: Architecture Design
├── 04_API_Documentation.md            # Final: API Documentation
└── 99_Value_Details_Outside_Template.md  # Long-tail valuable details
```
