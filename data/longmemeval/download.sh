#!/usr/bin/env bash
# Download the official LongMemEval S split from HuggingFace and convert.
# Usage: bash download.sh

set -euo pipefail

HF_BASE="https://huggingface.co/datasets/xiaowu0162/longmemeval-cleaned/resolve/main"
RAW_DIR="raw/data"
SPLIT_FILE="longmemeval_s_cleaned.json"

echo "[1/3] Downloading LongMemEval S split from HuggingFace..."
mkdir -p "$RAW_DIR"
if [ -f "$RAW_DIR/$SPLIT_FILE" ]; then
  echo "  '$RAW_DIR/$SPLIT_FILE' already exists — skipping download."
else
  curl -L --progress-bar -o "$RAW_DIR/$SPLIT_FILE" "$HF_BASE/$SPLIT_FILE"
fi

echo "[2/3] Converting LongMemEvalS to evaluation format..."
python3 - <<'PYEOF'
import json, pathlib, sys

data_path = pathlib.Path("raw/data/longmemeval_s_cleaned.json")
if not data_path.exists():
    sys.exit(f"Expected {data_path} — run the download step again.")

with open(data_path) as f:
    raw = json.load(f)

TYPE_MAP = {
    "single_session_preference": "single-session-preference",
    "single_session_assistant":  "single-session-assistant",
    "temporal_reasoning":        "temporal-reasoning",
    "multi_session":             "multi-session",
    "knowledge_update":          "knowledge-update",
    "single_session_user":       "single-session-user",
}

out = []
for item in raw:
    q_type = item.get("question_type", "")
    out.append({
        "id": item.get("question_id", f"lme-{len(out):04d}"),
        "type": TYPE_MAP.get(q_type, q_type),
        "question": item["question"],
        "ground_truth": item["answer"],
        "session_refs": item.get("answer_session_ids", []),
    })

with open("qa_pairs.json", "w") as f:
    json.dump(out, f, indent=2, ensure_ascii=False)

print(f"  Written {len(out)} QA pairs to qa_pairs.json")
PYEOF

echo "[3/3] Done. Files:"
echo "  raw/data/longmemeval_s_cleaned.json  — official LongMemEvalS data"
echo "  qa_pairs.json                        — evaluation-ready QA pairs"
