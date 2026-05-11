# AgentAlive — System Prompts

This repository contains the full production system prompts for the three TRA (Thinker–Reflection–Action) agents used in _Perpetual Cognition for Real-Time Collaboration: Graph-Based Reasoning in Human-Machine Teamwork_.

| File                    | Agent                            | Model                         |
| ----------------------- | -------------------------------- | ----------------------------- |
| `thinker.md`            | THINKER                          | Gemini 3 Flash (`gemini -p`)  |
| `reflection.md`         | REFLECTION                       | GPT-5.4 (`codex exec`)        |
| `action.md`             | ACTION                           | Claude Opus 4.6 (`claude -p`) |
| `industrial_context.md` | Shared industrial-domain context | All agents                    |

## Usage

Each file is injected as the system prompt for the corresponding agent in the TRA loop. The `industrial_context.md` file is prepended to all three agents' prompts when operating in an industrial monitoring scenario.

## Dataset

Evaluation data (50-session industrial scenario, 50 QA pairs, ground truth) is at:  
<https://github.com/agentalive/data>
