#!/bin/bash

################################################################################
# This script restarts the OpenClaw gateway.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n$STARS\n*\n* STARTED: $SCRIPT_NAME.\n*\n$STARS\n\n"

################################################################################
# Fix https://github.com/openclaw/openclaw/blob/main/src/auto-reply/reply/session-reset-prompt.ts
# Built-in value gets in the way of doing anything creative with the greeting.
################################################################################

SEARCH="const BARE_SESSION_RESET_PROMPT_BASE = \".*\";"
REPLACE="const BARE_SESSION_RESET_PROMPT_BASE = \"A new session was started via /new or /reset. Run your Session Startup sequence - read the required files before responding to the user. Then greet the user as instructed.\";"

FILE=$(grep -lr --include="*.js" "$SEARCH" "$HOME/.npm-global/lib/node_modules/openclaw/dist")
if [ -f "$FILE" ]; then
    $MMOJO_SED -i -e "s+${SEARCH}+${REPLACE}+g" $FILE
fi

################################################################################
# Fix LLM idle time out -- time before it receives any reply.
################################################################################

openclaw config set agents.defaults.llm.idleTimeoutSeconds 600

################################################################################
# Fix https://github.com/openclaw/openclaw/blob/main/src/hooks/llm-slug-generator.ts
# Tries to save a summary of the session before clearing it out and starting a new one.
################################################################################

SEARCH="timeoutMs: 15e3"
REPLACE="timeoutMs: 600e3"
FILE=$(grep -lr --include="llm-slug*.js" "$SEARCH" "$HOME/.npm-global/lib/node_modules/openclaw/dist")
if [ -f "$FILE" ]; then
    $MMOJO_SED -i -e "s+${SEARCH}+${REPLACE}+g" $FILE
fi

# printf "\n$STARS\n*\n* FINISHED: $SCRIPT_NAME.\n*\n$STARS\n\n"

################################################################################
#  This is an original script for the Mmojo Server repo. It is covered by
#  the repo's MIT-style LICENSE:
#
#  https://github.com/BradHutchings/Mmojo-Server/blob/main/LICENSE
#
#  Copyright (c) 2025-26 Brad Hutchings.
#  --
#  Brad Hutchings
#  brad@bradhutchings.com
################################################################################
