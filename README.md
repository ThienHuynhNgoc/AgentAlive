# AgentAlive

Repository for **_Perpetual Cognition for Real-Time Collaboration: Graph-Based Reasoning in Human-Machine Teamwork_**.

This repo contains the system prompts, evaluation datasets, and supporting scripts for the TRA (Thinker–Reflection–Action) agent architecture.

---

## Repository structure

```
AgentAlive/
├── data/                  Evaluation datasets (see data/README.md)
│   ├── locomo/            LoCoMo benchmark (Maharana et al., 2024)
│   ├── longmemeval/       LongMemEval-S benchmark (Wu et al., 2024)
│   └── industrial/        Synthetic industrial monitoring dataset (this paper)
│
├── prompts/               TRA agent system prompts (see prompts/README.md)
│   ├── thinker.md         THINKER — Gemini 3 Flash
│   ├── reflection.md      REFLECTION — GPT-5.4
│   ├── action.md          ACTION — Claude Opus 4.6
│   └── industrial_context.md  Shared industrial-domain context
│
├── .gitattributes         Git LFS tracking rules for large binary/data files
└── .gitignore             Excludes build artifacts and local paper drafts
```

---

## Agents

The system uses three cooperating LLM agents in a loop:

| Agent      | Model                         | Role                                           |
| ---------- | ----------------------------- | ---------------------------------------------- |
| THINKER    | Gemini 3 Flash (`gemini -p`)  | Graph-based reasoning over the knowledge graph |
| REFLECTION | GPT-5.4 (`codex exec`)        | Self-critique and belief revision              |
| ACTION     | Claude Opus 4.6 (`claude -p`) | Response generation and tool invocation        |

A shared **Neo4j knowledge graph** is maintained across sessions, enabling perpetual memory in both **Hot Brain** (live update) and **Freeze Brain** (static snapshot) modes.

---

## Datasets

| Dataset      | Samples | Description                                  | Setup                                     |
| ------------ | ------- | -------------------------------------------- | ----------------------------------------- |
| LoCoMo       | 1,986   | Long-context multi-session conversational QA | `cd data/locomo && bash download.sh`      |
| LongMemEvalS | 500     | QA over >100K-token conversation histories   | `cd data/longmemeval && bash download.sh` |
| Industrial   | 50      | Generated manufacturing facility dialogues   | Included directly in repo                 |

See [`data/README.md`](data/README.md) for the full dataset documentation and common evaluation schema.

---

## Large files

Large data files (`.json`, `.png`, `.pyc`, etc.) are tracked via **Git LFS** (see `.gitattributes`). To pull them after cloning:

```bash
git lfs pull
```

---

## Citation

```bibtex
@article{agentalive2026,
  title={Perpetual Cognition for Real-Time Collaboration: Graph-Based Reasoning in Human-Machine Teamwork},
  year={2026}
}
```
