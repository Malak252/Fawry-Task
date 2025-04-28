#!/bin/bash

# Show script usage
usage() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "Options:"
    echo "  -n     Show line numbers"
    echo "  -v     Invert match (show lines that do NOT match)"
    echo "  --help Show help message"
}

# If no arguments, show usage and exit
if [[ $# -eq 0 ]]; then
    usage
    exit 1
fi

# Default options
show_line_numbers=false
invert_match=false

# Handle options
while [[ "$1" == -* ]]; do
    case "$1" in
        -n)
            show_line_numbers=true
            ;;
        -v)
            invert_match=true
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
    shift
done

# Check if search string and filename are given
search="$1"
file="$2"

if [[ -z "$search" || -z "$file" ]]; then
    echo "Error: Missing search string or filename."
    usage
    exit 1
fi

# Check if file exists
if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Read the file line by line
line_num=0
while IFS= read -r line; do
    ((line_num++))
    
    # Check for match (case insensitive)
    if echo "$line" | grep -iq "$search"; then
        matched=true
    else
        matched=false
    fi

    # Invert if -v is used
    if $invert_match; then
        if $matched; then
            matched=false
        else
            matched=true
        fi
    fi

    # Print if match is true
    if $matched; then
        if $show_line_numbers; then
            echo "${line_num}:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"
