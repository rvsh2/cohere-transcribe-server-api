#!/bin/bash
set -euo pipefail

AUDIO_FILE="${COHERE_TRANSCRIBE_TEST_AUDIO:-/opt/cohere-transcribe/Recording.wav}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
API_SCRIPT="${ROOT_DIR}/tests/test_api.sh"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="$3"

  if [[ "${haystack}" != *"${needle}"* ]]; then
    echo "FAIL: ${message}" >&2
    exit 1
  fi
}

echo "============================================"
echo "  Cohere Transcribe Server — Integration Test"
echo "============================================"
echo "Audio:   ${AUDIO_FILE}"
echo ""

if [[ ! -f "${AUDIO_FILE}" ]]; then
  echo "FAIL: audio fixture not found at ${AUDIO_FILE}" >&2
  exit 1
fi

if [[ ! -x "${API_SCRIPT}" ]]; then
  echo "FAIL: API smoke script is missing or not executable at ${API_SCRIPT}" >&2
  exit 1
fi

output="$("${API_SCRIPT}" "${AUDIO_FILE}")"
echo "${output}"

assert_contains "${output}" "<!DOCTYPE html>" "GET / should render HTML"
assert_contains "${output}" '"text":"' "transcription endpoints should return text payloads"
assert_contains "${output}" "POST /v1/audio/transcriptions" "OpenAI-compatible endpoint should be exercised"
assert_contains "${output}" "All tests completed!" "integration flow should reach the end"

echo "============================================"
echo "  Integration test passed"
echo "============================================"
