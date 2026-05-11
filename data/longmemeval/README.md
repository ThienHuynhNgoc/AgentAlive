# LongMemEval — Long-Term Memory Evaluation for Chat Assistants

**Paper:** _LongMemEval: Benchmarking Chat Assistants on Long-Term Interactive Memory_ (Wu et al., 2024)  
**Official repo:** https://github.com/xiaowu0162/LongMemEval  
**License:** MIT

## Dataset summary

| Property        | Value                                                  |
| --------------- | ------------------------------------------------------ |
| Total questions | 500                                                    |
| Average context | >100K tokens                                           |
| Variant used    | **LongMemEvalS** (~115K tokens, ~40 sessions/question) |

### Question-type breakdown

| Type                        | Description                                  |
| --------------------------- | -------------------------------------------- |
| `single-session-preference` | User preferences stated in one session       |
| `single-session-assistant`  | Assistant behaviour within one session       |
| `temporal-reasoning`        | Time-dependent fact retrieval                |
| `multi-session`             | Synthesis across multiple sessions           |
| `knowledge-update`          | Handling contradictory / updated information |
| `single-session-user`       | Specific user statements within one session  |

## Download

```bash
bash download.sh
```

This clones the official repo under `raw/`, selects the LongMemEvalS split, and writes `qa_pairs.json` in our evaluation format.

## Evaluation format

`qa_pairs.json` entries:

```json
{
  "id": "lme-0001",
  "type": "temporal-reasoning",
  "sessions": [...],
  "question": "When did the user change their dietary preference?",
  "ground_truth": "The user switched to a vegan diet in March 2023.",
  "session_refs": ["session-12"]
}
```

`sessions_sample.json` provides 12 representative examples (2 per question type).

## Usage in paper

We use the **LongMemEvalS** split (longest context variant, ~115K tokens, ~40 sessions per question). Each conversation is processed through the TRA loop and evaluated in Hot Brain and Freeze Brain modes. Accuracy (%) is reported per question type and as a macro average, following the MAGMA evaluation protocol.
