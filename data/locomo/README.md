# LoCoMo — Long-Context Conversations with Memory

**Paper:** _LoCoMo: Long-Context Modular Memory for LLM Agent Conversations_ (Maharana et al., 2024)  
**Official repo:** https://github.com/snap-research/locomo  
**License:** CC BY 4.0

## Dataset summary

| Property                  | Value                   |
| ------------------------- | ----------------------- |
| Total samples             | 1,986                   |
| Context length            | ~9K tokens/conversation |
| Sessions per conversation | Multiple (up to ~10)    |

### Category breakdown

| Category    | Count |
| ----------- | ----- |
| Single-Hop  | 841   |
| Adversarial | 446   |
| Temporal    | 321   |
| Multi-Hop   | 282   |
| Open Domain | 96    |

## Download

```bash
bash download.sh
```

This places the official dataset under `raw/` and generates `qa_pairs.json` in our evaluation format.

## Evaluation format

`qa_pairs.json` contains objects of the form:

```json
{
  "id": "locomo-0001",
  "category": "temporal",
  "conversation_id": "conv-042",
  "sessions": [...],
  "question": "When did Alex first mention changing jobs?",
  "ground_truth": "Alex mentioned changing jobs in session 3 on March 14.",
  "session_refs": ["session-3"]
}
```

`sessions_sample.json` contains 20 representative conversations (4 per category) in the same format used by the TRA loop.

## Usage in paper

We process each conversation through the TRA loop (Gemini 3 Flash → GPT-5.4 → Claude Opus 4.6) to build the Neo4j knowledge graph, then evaluate QA against it in both Hot Brain and Freeze Brain modes. Scores are LLM-as-Judge on a [0,1] continuous scale following the MAGMA evaluation protocol.
