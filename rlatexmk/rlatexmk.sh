#!/bin/sh

# rlatexmk.sh
# Script for remote LaTeX compiling using rlatexmk
# 2019 (c) Marcel Kapfer <opensource@mmk2410.org>
# MIT License

# Importing variables from local rlatexmk_config.sh
import_config() {
    CONFIG="$(pwd)/rlatexmk_config.sh"

    if [ -f $CONFIG ]; then
	source $CONFIG
    else
	echo "Configuration file $CONFIG not available. Aborting."
	exit 1
    fi
}

# Provide local folder content to remote using rsync
sync_up() {
    rsync $RSYNC_OPTIONS ./ "$USER"@"$HOST":"$REMOTE_PATH"
}

# Get remote folder content using rsync
sync_down() {
    rsync $RSYNC_OPTIONS "$USER"@"$HOST":"$REMOTE_PATH"/ .
}

# Run latexmk remote using SSH
compile() {
    ssh "$USER"@"$HOST" <<EOF
cd $REMOTE_PATH
latexmk -C
latexmk $LATEXMK_OPTIONS $@
EOF
}

# Main function
main() {
    import_config
    sync_up
    compile
    sync_down
}

main
