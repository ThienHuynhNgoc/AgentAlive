# Data

All datasets used in the paper _"Perpetual Cognition for Real-Time Collaboration: Graph-Based Reasoning in Human-Machine Teamwork"_.

---

## Directory structure

```
data/
├── locomo/                   LoCoMo benchmark (Maharana et al., 2024)
│   ├── README.md
│   ├── download.sh           Fetch official data; writes qa_pairs.json
│   └── sessions_sample.json  5 representative samples (4 per category)
│
├── longmemeval/              LongMemEval benchmark — LongMemEvalS split (Wu et al., 2024)
│   ├── README.md
│   ├── download.sh           Fetch official data; writes qa_pairs.json
│   └── sessions_sample.json  6 representative samples (1 per question type)
│
└── industrial/               Synthetic industrial monitoring dataset (this paper)
    ├── sessions.json         50 operator–agent dialogues (6-week span)
    ├── qa_pairs.json         50 QA pairs across 4 categories
    └── ground_truth.json     50 ground-truth answers with graph evidence
```

---

## Datasets

### LoCoMo

Long-context multi-session conversational QA. 1,986 samples across 5 cognitive categories (~9K tokens/conversation).  
**Source:** https://github.com/snap-research/locomo  
**Setup:** `cd locomo && bash download.sh`

### LongMemEval (LongMemEvalS)

500 QA questions over >100K-token conversation histories. 6 question types; we use the **S** (longest) split (~115K tokens, ~40 sessions per question).  
**Source:** https://github.com/xiaowu0162/LongMemEval  
**Setup:** `cd longmemeval && bash download.sh`

### Industrial Monitoring (synthetic)

50 synthetic operator–agent dialogues modelling a discrete manufacturing facility (3 CNC machines, 2 hydraulic pumps, 1 compressor, 12 sensors, 4 rotating-shift operators) over 6 weeks. Inspired by IEEE DataPort HVAC/industrial operational-log datasets.  
50 QA pairs across: _Temporal_ (12), _Knowledge-Update_ (13), _Multi-Session_ (13), _Causal_ (12).  
Data is included directly in this repository — no download needed.

---

## Common evaluation format

All three datasets are converted to a common JSON schema before evaluation:

```json
{
  "id":           "<dataset>-<index>",
  "category":     "<question type or category>",
  "sessions":     [ { "session_id": "...", "date": "...", "turns": [...] } ],
  "question":     "...",
  "ground_truth": "...",
  "session_refs": ["session-N", ...]
}
```

Evaluation scripts consume this unified format and submit each conversation through the TRA loop (Gemini 3 Flash → GPT-5.4 → Claude Opus 4.6), building the Neo4j knowledge graph, then run QA in **Hot Brain** and **Freeze Brain** modes, scored with LLM-as-Judge following the MAGMA evaluation protocol.

---

## Citation

If you use this data, please also cite the original benchmarks:

```bibtex
@inproceedings{maharana2024locomo,
  title={{LoCoMo}: Long-Context Modular Memory for LLM Agent Conversations},
  author={Maharana, Adyasha and Lee, Dong-Ho and Tulyakov, Sergey and Bansal, Mohit and Barbieri, Francesco and Cho, Yuwei},
  booktitle={ACL},
  year={2024}
}

@inproceedings{wu2024longmemeval,
  title={{LongMemEval}: Benchmarking Chat Assistants on Long-Term Interactive Memory},
  author={Wu, Di and Wang, Hongwei and Yu, Wenhao and Zhang, Yuwei and Chang, Kai-Wei and Yu, Dong},
  booktitle={ICLR},
  year={2025}
}
```
