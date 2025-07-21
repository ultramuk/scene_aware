#!/bin/sh

# ==============================================================================
#
# run_formatter.sh
#
# Description:
#   이 스크립트는 지정된 C++ 파일에 clang-format을 실행하고, 변경 사항을
#   보고하며, 요약을 제공합니다.
#
# Usage:
#   ./run_formatter.sh <path-to-clang-format> <file1> <file2> ...
#
# ==============================================================================

# --- 설정 및 초기화 ---

# 명령이 0이 아닌 상태로 종료되면 즉시 종료합니다.
set -e

# 가독성 있는 출력을 위한 ANSI 색상 코드입니다.
COLOR_RESET='\x1b[0m'
COLOR_GREEN='\x1b[32m'
COLOR_YELLOW='\x1b[33m'
COLOR_CYAN='\x1b[36m'
COLOR_GRAY='\x1b[90m'

# --- 인자 검증 ---

if [ -z "$1" ]; then
  printf "Error: clang-format path not provided.\n" >&2
  exit 1
fi
CLANG_FORMAT_EXE="$1"
shift

if [ $# -eq 0 ]; then
  printf "No C++ files to check. Exiting.\n"
  exit 0
fi
FILES_TO_CHECK="$@"

# --- 메인 로직 ---

main() {
  local modified_files=""
  local modified_count=0
  local total_count=0

  printf "%bRunning C++ code formatter...%b\n" "$COLOR_CYAN" "$COLOR_RESET"

  # 현재 모든 변경 사항을 스테이징합니다. 이렇게 하면 다음 단계에서 `git diff`가
  # clang-format에 의해 발생한 변경 사항만 표시하도록 보장합니다.
  git add .

  for file in $FILES_TO_CHECK; do
    total_count=$((total_count + 1))

    # clang-format을 인플레이스(in-place)로 실행합니다.
    "$CLANG_FORMAT_EXE" -i "$file"

    # clang-format이 파일을 수정했는지 확인합니다.
    if ! git diff --quiet -- "$file"; then
      modified_count=$((modified_count + 1))
      modified_files="${modified_files}\n  - ${file}"

      # 수정된 파일에 대한 명확한 헤더를 출력합니다.
      printf "\n%b--- Formatting applied to: %s ---%b\n" "$COLOR_YELLOW" "$file" "$COLOR_RESET"

      # git 관련 헤더 없이 깔끔한 diff를 보여줍니다.
      git --no-pager diff --no-prefix "$file" | sed '/^diff --git/d; /^index/d'

      printf "%b----------------------------------------------------%b\n" "$COLOR_YELLOW" "$COLOR_RESET"
    fi
  done

  print_summary "$total_count" "$modified_count" "$modified_files"

  # git 인덱스를 원래 상태로 복원합니다.
  printf "\n%bgit 인덱스를 복원 중입니다...%b\n" "$COLOR_GRAY" "$COLOR_RESET"
  git reset >/dev/null
}

# --- 헬퍼 함수 ---

print_summary() {
  local total_count=$1
  local modified_count=$2
  local modified_files=$3

  printf "\n%b=====================================%b\n" "$COLOR_GREEN" "$COLOR_RESET"
  printf "%b      Clang-Format 요약          %b\n" "$COLOR_GREEN" "$COLOR_RESET"
  printf "%b=====================================%b\n" "$COLOR_GREEN" "$COLOR_RESET"
  printf " 총 확인 파일 수: %s\n" "$total_count"
  printf " 자동 포맷된 파일 수: %s\n" "$modified_count"

  if [ "$modified_count" -gt 0 ]; then
    printf " 수정된 파일 목록:\\n"
    # printf와 %b를 사용하여 modified_files 문자열의 개행 문자를 해석합니다.
    printf "%b%b%b\n" "$COLOR_YELLOW" "$modified_files" "$COLOR_RESET"
    printf "\n%b참고: 포맷팅 변경 사항이 적용되었습니다. 검토 후 커밋해 주세요.%b\n" "$COLOR_YELLOW" "$COLOR_RESET"
  else
    printf "%b모든 파일이 올바르게 포맷되었습니다!%b\n" "$COLOR_GREEN" "$COLOR_RESET"
  fi
  printf "%b=====================================%b\n\n" "$COLOR_GREEN" "$COLOR_RESET"
}

# --- 스크립트 실행 ---

main
