#!/usr/bin/env bash

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

# Shorten the path like zsh %~ (replace $HOME with ~)
home="$HOME"
short_cwd="${cwd/#$home/~}"

# Get git branch/status using git-prompt.sh if available
git_info=""
git_prompt_sh="/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh"
if [ -f "$git_prompt_sh" ]; then
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM="auto"
  # shellcheck source=/dev/null
  source "$git_prompt_sh"
  git_info=$(GIT_DIR="$cwd/.git" GIT_WORK_TREE="$cwd" __git_ps1 " (%s)" 2>/dev/null || true)
  if [ -z "$git_info" ]; then
    # fallback: walk up to find .git
    check_dir="$cwd"
    while [ "$check_dir" != "/" ]; do
      if [ -d "$check_dir/.git" ] || [ -f "$check_dir/.git" ]; then
        git_info=$(cd "$check_dir" && GIT_OPTIONAL_LOCKS=0 __git_ps1 " (%s)" 2>/dev/null || true)
        break
      fi
      check_dir=$(dirname "$check_dir")
    done
  fi
fi

ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_suffix=""
if [ -n "$ctx_pct" ]; then
  ctx_int=$(printf '%.0f' "$ctx_pct")
  if [ "$ctx_int" -ge 90 ]; then
    ctx_color='\033[31m'   # red
  elif [ "$ctx_int" -ge 70 ]; then
    ctx_color='\033[33m'   # yellow
  else
    ctx_color='\033[32m'   # green
  fi
  ctx_suffix=$(printf "${ctx_color}[%d%%]\033[0m" "$ctx_int")
fi

cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
cost_suffix=""
[ -n "$cost" ] && cost_suffix=$(printf ' $%.2f' "$cost")

# Compact token count (e.g. "14.2k tok")
tokens_suffix=""
total_tokens=$(echo "$input" | jq -r '.session.total_tokens // empty')
if [ -n "$total_tokens" ] && [ "$total_tokens" != "0" ]; then
  tok_int=$(printf '%.0f' "$total_tokens")
  if [ "$tok_int" -ge 1000000 ]; then
    tok_fmt=$(awk "BEGIN { printf \"%.1fM\", $tok_int/1000000 }")
  elif [ "$tok_int" -ge 1000 ]; then
    tok_fmt=$(awk "BEGIN { printf \"%.1fk\", $tok_int/1000 }")
  else
    tok_fmt="$tok_int"
  fi
  tokens_suffix=" ${tok_fmt} tok"
fi

# Rate limit info from JSON input (five_hour window preferred, fall back to seven_day)
rl_suffix=""
rl_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rl_label="5h"
if [ -z "$rl_pct" ]; then
  rl_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
  rl_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
  rl_label="7d"
fi
if [ -n "$rl_pct" ]; then
  rl_int=$(printf '%.0f' "$rl_pct")
  if [ "$rl_int" -ge 80 ]; then
    rl_color='\033[31m'   # red
  elif [ "$rl_int" -ge 50 ]; then
    rl_color='\033[33m'   # yellow
  else
    rl_color='\033[32m'   # green
  fi
  reset_str=""
  if [ -n "$rl_resets" ] && [ "$rl_resets" != "null" ]; then
    reset_str=$(date -r "$rl_resets" +"%H:%M" 2>/dev/null || date -d "@$rl_resets" +"%H:%M" 2>/dev/null || true)
  fi
  if [ -n "$reset_str" ]; then
    rl_suffix=$(printf " ${rl_color}RL(${rl_label}):%d%% rst %s\033[0m" "$rl_int" "$reset_str")
  else
    rl_suffix=$(printf " ${rl_color}RL(${rl_label}):%d%%\033[0m" "$rl_int")
  fi
fi

printf '\033[1m%s\033[0m%s %s%s%s%s' "$short_cwd" "$git_info" "$ctx_suffix" "$tokens_suffix" "$cost_suffix" "$rl_suffix"
