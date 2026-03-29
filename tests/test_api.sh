#!/bin/bash
set -euo pipefail

# ============================================================================
# Test script for Cohere Transcribe Server
# Compatible with whisper.cpp server API
# ============================================================================

SERVER="http://127.0.0.1:8080"
AUDIO_FILE="${1:-test.wav}"

echo "============================================"
echo "  Cohere Transcribe Server — API Tests"
echo "============================================"
echo ""
echo "Server: ${SERVER}"
echo "Audio:  ${AUDIO_FILE}"
echo ""

# --- Test 1: Server info page ---
echo "━━━ Test 1: GET / (server info) ━━━"
curl -fsS "${SERVER}/" | head -5
echo ""
echo ""

# --- Test 2: /inference JSON (whisper.cpp format) ---
echo "━━━ Test 2: POST /inference (json) ━━━"
curl -fsS "${SERVER}/inference" \
  -H "Content-Type: multipart/form-data" \
  -F file="@${AUDIO_FILE}" \
  -F temperature="0.0" \
  -F temperature_inc="0.2" \
  -F response_format="json" \
  -F language="en"
echo ""
echo ""

# --- Test 3: /inference text format ---
echo "━━━ Test 3: POST /inference (text) ━━━"
curl -fsS "${SERVER}/inference" \
  -F file="@${AUDIO_FILE}" \
  -F response_format="text" \
  -F language="en"
echo ""

# --- Test 4: /inference verbose_json format ---
echo "━━━ Test 4: POST /inference (verbose_json) ━━━"
curl -fsS "${SERVER}/inference" \
  -F file="@${AUDIO_FILE}" \
  -F response_format="verbose_json" \
  -F language="en"
echo ""
echo ""

# --- Test 5: /inference SRT format ---
echo "━━━ Test 5: POST /inference (srt) ━━━"
curl -fsS "${SERVER}/inference" \
  -F file="@${AUDIO_FILE}" \
  -F response_format="srt" \
  -F language="en"
echo ""

# --- Test 6: /inference VTT format ---
echo "━━━ Test 6: POST /inference (vtt) ━━━"
curl -fsS "${SERVER}/inference" \
  -F file="@${AUDIO_FILE}" \
  -F response_format="vtt" \
  -F language="en"
echo ""

# --- Test 7: OpenAI compatible endpoint ---
echo "━━━ Test 7: POST /v1/audio/transcriptions (OpenAI) ━━━"
curl -fsS "${SERVER}/v1/audio/transcriptions" \
  -F file="@${AUDIO_FILE}" \
  -F model="CohereLabs/cohere-transcribe-03-2026" \
  -F language="en"
echo ""
echo ""

# --- Test 8: Polish language ---
echo "━━━ Test 8: POST /inference (Polish) ━━━"
curl -fsS "${SERVER}/inference" \
  -F file="@${AUDIO_FILE}" \
  -F response_format="json" \
  -F language="pl"
echo ""
echo ""

echo "============================================"
echo "  All tests completed!"
echo "============================================"
