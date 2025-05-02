#!/bin/bash

<< comment
This is the script written by nithin

Usage:
./backup.sh <path to your source> <path to your backup folder>
comment

source_dir="$1"
backup_dir="$2"
timestamp=$(date '+%Y-%m-%d_%H-%M-%S')

create_backup() {
    zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null
    if [ $? -eq 0 ]; then
        echo "backup generated successfully at ${timestamp}"
    else
        echo "some error in your zip command"
    fi
}

perform_rotation() {
    mapfile -t backups < <(ls -t "${backup_dir}"/backup_*.zip 2>/dev/null)

    if [ ${#backups[@]} -ge 5 ]; then
        echo "performing rotation for 5 days"
        backups_to_remove=("${backups[@]:5}")
        for backup in "${backups_to_remove[@]}"; do
            echo "Deleting: $backup"
            rm -r "$backup"
        done
    fi
}

display_usage() {
    echo "Usage: ./backup.sh <path to your source> <path to your backup folder>"
}

if [ $# -ne 2 ]; then
    display_usage
    exit 1
fi

create_backup
perform_rotation

