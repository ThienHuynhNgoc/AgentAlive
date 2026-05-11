#!/usr/bin/env bash
# Download the official LoCoMo dataset and convert to our evaluation format.
# Usage: bash download.sh

set -euo pipefail

REPO_URL="https://github.com/snap-research/locomo"
RAW_DIR="raw"
OUT_FILE="qa_pairs.json"

echo "[1/3] Cloning LoCoMo repository..."
if [ -d "$RAW_DIR" ]; then
  echo "  '$RAW_DIR' already exists — skipping clone."
else
  git clone --depth 1 "$REPO_URL" "$RAW_DIR"
fi

echo "[2/3] Converting to evaluation format..."
python3 - <<'PYEOF'
import json, pathlib, sys

raw_dir = pathlib.Path("raw")
dataset_path = raw_dir / "data" / "locomo10.json"
if not dataset_path.exists():
    sys.exit(f"Expected {dataset_path} — check the repo structure.")

with open(dataset_path) as f:
    raw = json.load(f)

# Category integer -> canonical name (verified against published counts)
# 1=multi-hop(282), 2=temporal(321), 3=open-domain(96), 4=single-hop(841), 5=adversarial(446)
CATEGORY_MAP = {1: "multi-hop", 2: "temporal", 3: "open-domain", 4: "single-hop", 5: "adversarial"}

out = []
for item in raw:
    conv_id = item.get("sample_id", f"conv-{len(out):03d}")
    sessions = item.get("conversation", {})
    for qa in item.get("qa", []):
        # Adversarial entries (category 5) use adversarial_answer instead of answer
        answer = qa.get("answer", qa.get("adversarial_answer", ""))
        out.append({
            "id": f"locomo-{len(out):04d}",
            "category": CATEGORY_MAP.get(qa.get("category"), str(qa.get("category"))),
            "conversation_id": conv_id,
            "question": qa["question"],
            "ground_truth": str(answer),
            "session_refs": qa.get("evidence", []),
        })

with open("qa_pairs.json", "w") as f:
    json.dump(out, f, indent=2, ensure_ascii=False)

print(f"  Written {len(out)} QA pairs to qa_pairs.json")
PYEOF

echo "[3/3] Done. Files:"
echo "  raw/           — official LoCoMo repository"
echo "  qa_pairs.json  — evaluation-ready QA pairs"
