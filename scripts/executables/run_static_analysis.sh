#!/bin/sh

# ==============================================================================
#
# run_static_analysis.sh
#
# 설명:
#   이 스크립트는 지정된 C++ 파일에 대해 clang-tidy를 실행하여 정적
#   분석을 수행합니다.
#
# 사용법:
#   ./run_static_analysis.sh <clang-tidy-경로> <빌드-디렉터리-경로> <파일1> <파일2> ...
#
# ==============================================================================

# --- Configuration and Setup ---

# Do not exit on the first non-zero status – we want to analyze every file.
set +e

# ANSI Color Codes for readable output.
COLOR_RESET='\x1b[0m'
COLOR_GREEN='\x1b[32m'
COLOR_YELLOW='\x1b[33m'
COLOR_CYAN='\x1b[36m'
COLOR_RED='\x1b[31m'

# --- Argument Validation ---

if [ -z "$1" ]; then
  printf "Error: clang-tidy path not provided.\n" >&2
  exit 1
fi
CLANG_TIDY_EXE="$1"
shift

if [ -z "$1" ]; then
  printf "Error: Build path (containing compile_commands.json) not provided.\n" >&2
  exit 1
fi
BUILD_PATH="$1"
shift

if [ $# -eq 0 ]; then
  printf "No C++ files to check. Exiting.\n"
  exit 0
fi
FILES_TO_CHECK="$@"

# Determine project root (directory containing this script two levels up)
PROJECT_ROOT="$(cd "$(dirname "$0")"/../.. && pwd)"

# Clang-tidy options:
#   --system-headers      : still show issues in system headers if useful
#   -header-filter <regex>: restrict diagnostics to project files, effectively
#                           skipping build/_deps and other externals.
#   Note: we allow include/, source/, executables/, tests/ subdirs.
HEADER_FILTER_REGEX="^${PROJECT_ROOT}/(include|source|executables|tests)/"
CLANG_TIDY_OPTS="--system-headers -header-filter=${HEADER_FILTER_REGEX}"

# --- Main Logic ---

main() {

  local overall_status=0 # 0 => success
  local modified_files=""
  local modified_count=0
  local total_count=0
  local total_files=$(echo "$FILES_TO_CHECK" | wc -w | tr -d ' ')

  for file in $FILES_TO_CHECK; do
    total_count=$((total_count + 1))
    printf "%b[%3s/%3s] Checking %s%b\n" "$COLOR_CYAN" "$total_count" "$total_files" "$file" "$COLOR_RESET"

    # Run clang-tidy but filter out noise about suppressed warnings / header-filter hints.
    tmp_out=$(mktemp)
    "$CLANG_TIDY_EXE" $CLANG_TIDY_OPTS -p "$BUILD_PATH" "$file" >"$tmp_out" 2>&1
    local tidy_status=$?

    # Display all output from clang-tidy without filtering.
    cat "$tmp_out"
    rm -f "$tmp_out"

    if [ $tidy_status -ne 0 ]; then
      overall_status=1
    fi

    # Stage file to detect fixes created by -fix options if enabled in .clang-tidy
    git add "$file"
    if ! git diff --quiet -- "$file"; then
      modified_count=$((modified_count + 1))
      modified_files="${modified_files}\n  - ${file}"
      printf "%b--- Applied fixes in %s --- %b\n" "$COLOR_YELLOW" "$file" "$COLOR_RESET"
      git diff --color -- "$file"
      printf "%b----------------------------------------%b\n\n" "$COLOR_YELLOW" "$COLOR_RESET"
    fi
  done

  print_summary "$total_count" "$modified_count" "$modified_files"

  # Restore git index
  git reset >/dev/null

  if [ $overall_status -ne 0 ]; then
    printf "%bClang-tidy reported issues in one or more files.%b\n" "$COLOR_RED" "$COLOR_RESET"
  fi

  exit $overall_status
}

# --- Helper Functions ---

print_summary() {
  local total_count=$1
  local modified_count=$2
  local modified_files=$3

  printf "\n%b=====================================%b\n" "$COLOR_GREEN" "$COLOR_RESET"
  printf "%b        Clang-Tidy Summary         %b\n" "$COLOR_GREEN" "$COLOR_RESET"
  printf "%b=====================================%b\n" "$COLOR_GREEN" "$COLOR_RESET"
  printf " Total files checked: %s\n" "$total_count"

  if [ "$modified_count" -gt 0 ]; then
    printf " Files auto-fixed: %s\n" "$modified_count"
    printf " Fixed files list:\n"
    printf "%b%b%b\n" "$COLOR_YELLOW" "$modified_files" "$COLOR_RESET"
    printf "\n%bNOTE: clang-tidy applied fixes. Please review and commit them.%b\n" "$COLOR_YELLOW" "$COLOR_RESET"
  else
    printf "%bNo issues found that could be auto-fixed.%b\n" "$COLOR_GREEN" "$COLOR_RESET"
  fi
  printf "%b=====================================%b\n\n" "$COLOR_GREEN" "$COLOR_RESET"
}

# --- Script Execution ---

main
