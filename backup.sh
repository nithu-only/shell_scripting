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

<< croncomment

	To Automate this script type "$ crontab -e" 
	--> It will open a prompt asking you to enter the ( 1-4 ) to choose the editor [choose 2 for vim]
	--> Once you choose one Editor will open
	--> Go to Last line and write the command there
	--> Command will be: * * * * * [ This will run the script each minute] <script_path> <source_dir> <dest_dir>
	--> Save and Exit ['Esc' + ':' + 'w' + 'q' ]
	--> Thats it your script will run each minute

Note: For setting the time for the script you can visit 'https://crontab.guru/' website

croncomment
