#!/bin/bash

# PreToolUse hook: docker 명령을 sg docker -c "..."로 래핑
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

# docker로 시작하는 명령만 래핑 (sg docker로 이미 래핑된 경우 제외)
if [[ "$COMMAND" == docker* ]]; then
  # 명령 내 쌍따옴표 이스케이프
  ESCAPED=$(echo "$COMMAND" | sed 's/"/\\"/g')
  WRAPPED="sg docker -c \"$ESCAPED\""

  # jq로 JSON 생성하여 안전하게 출력
  jq -n --arg cmd "$WRAPPED" '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "allow",
      "updatedInput": {
        "command": $cmd
      }
    }
  }'
fi
