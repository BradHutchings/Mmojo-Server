#!/bin/bash

################################################################################
# This script adds certs from the Mmojo Share to the mmojo-server.zip packaging
# file.
#
# See licensing note at end.
################################################################################

SCRIPT_NAME=$(basename -- "$0")
# printf "\n**********\n*\n* STARTED: $SCRIPT_NAME $1.\n*\n**********\n\n"

rm -f "$HOME/Desktop/Mmojo Server ON"
rm -f "$HOME/Desktop/Mmojo Server OFF"

# 'EOF' means don't substitute $ variables.
cat << 'EOF' > "$HOME/Desktop/Start-Mmojo-Server.sh"
#!/bin/bash

# When this is run by double clicking on the Desktop, it doesn't have the environment set up.
. $HOME/mm-scripts/mm-environment-variables.sh
$HOME/mm-scripts/mm-mmojo-server-start.sh background

echo $(dirname -- "${BASH_SOURCE[0]}")
# echo ${BASH_SOURCE[0]}

check=$(dirname -- "${BASH_SOURCE[0]}")/"Check-Mmojo-Server.sh"
echo $check
sh $check

# Keep the window up for a moment if run in Terminal.
sleep 5s
EOF

# 'EOF' means don't substitute $ variables.
cat << 'EOF' > "$HOME/Desktop/Stop-Mmojo-Server.sh"
#!/bin/bash

# When this is run by double clicking on the Desktop, it doesn't have the environment set up.
. $HOME/mm-scripts/mm-environment-variables.sh
$HOME/mm-scripts/mm-mmojo-server-stop.sh
sleep 5s

echo $(dirname -- "${BASH_SOURCE[0]}")
# echo ${BASH_SOURCE[0]}

check=$(dirname -- "${BASH_SOURCE[0]}")/"Check-Mmojo-Server.sh"
echo $check
sh $check

# Keep the window up for a moment if run in Terminal.
sleep 5s
EOF

# 'EOF' means don't substitute $ variables.
cat << 'EOF' > "$HOME/Desktop/Check-Mmojo-Server.sh"
#!/bin/bash

SCRIPT_DIR="$(dirname -- "$(realpath -- "$0")")"
# echo "\$SCRIPT_DIR: $SCRIPT_DIR"

rm -f "$SCRIPT_DIR/Mmojo Server OFF"
rm -f "$SCRIPT_DIR/Mmojo Server ON"

mmojoServerRunning=$(pgrep "mmojo-server")
if [ -z "$mmojoServerRunning" ] ; then
    touch "$SCRIPT_DIR/Mmojo Server OFF"
else
    touch "$SCRIPT_DIR/Mmojo Server ON"
fi

# Keep the window up for a moment if run in Terminal.
sleep 5s
EOF

chmod a+x "$HOME/Desktop/Start-Mmojo-Server.sh"
chmod a+x "$HOME/Desktop/Stop-Mmojo-Server.sh"
chmod a+x "$HOME/Desktop/Check-Mmojo-Server.sh"

# printf "\n**********\n*\n* FINISHED: $SCRIPT_NAME.\n*\n**********\n\n"

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
