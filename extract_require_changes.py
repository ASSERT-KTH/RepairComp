import os
import re
import pandas as pd

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.join(SCRIPT_DIR, "results", "smartbugs")

OUTPUT_CSV = os.path.join(BASE_DIR, "data_analysis", "patches_w_require.csv")

GITHUB_BASE = (
    "https://github.com/ASSERT-KTH/RepairComp/blob/main/results/smartbugs"
)
MITIGATION_CSV = os.path.join(BASE_DIR, "data_analysis", "mitigated_exploits_contract_per_tool.csv")  


def clean_keys(df: pd.DataFrame) -> pd.DataFrame:
    for col in ("Tool", "Category", "Patch"):
        df[col] = (
            df[col]
            .astype(str)
            .str.strip()
            .str.lower()
            .str.replace(r"\s+", " ", regex=True)
        )
    return df

def is_real_require(line: str) -> bool:
    stripped = line.strip()[1:].strip() 
    has_require = "require(" in stripped
    full_comment = stripped.startswith("//") or stripped.startswith("/*")
    return has_require and not full_comment

def classify_require_type(line: str, inside_modifier: bool = False) -> str:
    if inside_modifier:
        return "modifier"
    stripped = line.strip()
    if "require(" in stripped:
        lower = stripped.lower()
        if any(x in lower for x in ["call.value", "send(", "transfer(", "success", "now", "block.timestamp"]):
            return "runtime check"
        if any(x in lower for x in ["balances", "limit", ">=", "<=", ">", "<", "!=", "=="]):
            return "invariant"
        return "invariant"
    return "invariant"

def flush_changes(
    added: list[str],
    removed: list[str],
    meta: dict[str, str],
    out: list[dict],
    added_flags: list[bool],
    removed_flags: list[bool],
) -> None:
    max_len = max(len(added), len(removed))
    for i in range(max_len):
        added_line = added[i] if i < len(added) else ""
        removed_line = removed[i] if i < len(removed) else ""
        added_flag = added_flags[i] if i < len(added_flags) else False
        removed_flag = removed_flags[i] if i < len(removed_flags) else False

        if added_line and removed_line:
            out.append({
                **meta,
                "ChangeType": "modified",
                "CodeLine": added_line,
                "RequireType": classify_require_type(added_line, inside_modifier=added_flag)
            })
        elif added_line:
            out.append({
                **meta,
                "ChangeType": "added",
                "CodeLine": added_line,
                "RequireType": classify_require_type(added_line, inside_modifier=added_flag)
            })
        elif removed_line:
            out.append({
                **meta,
                "ChangeType": "removed",
                "CodeLine": removed_line,
                "RequireType": classify_require_type(removed_line, inside_modifier=removed_flag)
            })

    added.clear()
    removed.clear()
    added_flags.clear()
    removed_flags.clear()

modifier_start_re = re.compile(r'\s*modifier\s+\w+\s*\([^)]*\)\s*{')

require_rows = []

for tool in os.listdir(BASE_DIR):
    tool_dir = os.path.join(BASE_DIR, tool)
    if not os.path.isdir(tool_dir):
        continue                                    
    for category in os.listdir(tool_dir):
        cat_dir = os.path.join(tool_dir, category)
        if not os.path.isdir(cat_dir):
            continue
        for patch in os.listdir(cat_dir):
            patch_dir = os.path.join(cat_dir, patch)
            diff_path = os.path.join(patch_dir, f"{patch}.diff")
            if not os.path.isfile(diff_path):
                continue

            added_requires = []
            removed_requires = []
            added_requires_flags = []
            removed_requires_flags = []

            inside_modifier = False
            brace_level = 0
            in_hunk = False

            with open(diff_path, encoding="utf-8") as diff:
                for line in diff:
                    if line.startswith("@@"):
                        flush_changes(
                            added_requires,
                            removed_requires,
                            {
                                "Tool": tool,
                                "Category": category,
                                "Patch": patch,
                                "GitHubLink": f"{GITHUB_BASE}/{tool}/{category}/{patch}/{patch}.diff",
                            },
                            require_rows,
                            added_requires_flags,
                            removed_requires_flags,
                        )
                        in_hunk = True
                        inside_modifier = False
                        brace_level = 0
                        continue
                    if not in_hunk:
                        continue

                    code_line = line[1:].strip() if len(line) > 1 else ""

                    if modifier_start_re.match(code_line):
                        inside_modifier = True
                        brace_level = 1
                    elif inside_modifier:
                        brace_level += code_line.count('{') - code_line.count('}')
                        if brace_level == 0:
                            inside_modifier = False

                    if line.startswith("+") and is_real_require(line):
                        added_requires.append(code_line)
                        added_requires_flags.append(inside_modifier)
                    elif line.startswith("-") and is_real_require(line):
                        removed_requires.append(code_line)
                        removed_requires_flags.append(inside_modifier)

            flush_changes(
                added_requires,
                removed_requires,
                {
                    "Tool": tool,
                    "Category": category,
                    "Patch": patch,
                    "GitHubLink": f"{GITHUB_BASE}/{tool}/{category}/{patch}/{patch}.diff",
                },
                require_rows,
                added_requires_flags,
                removed_requires_flags,
            )

require_df = clean_keys(pd.DataFrame(require_rows))
require_df.to_csv(OUTPUT_CSV, index=False)
