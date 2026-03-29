# Release Notes

## 2026-03-29

### Native Production Backend

- Switched production inference to the native `transformers==5.4.0` path using `AutoProcessor` and `AutoModelForSpeechSeq2Seq`.
- Removed production dependence on `trust_remote_code=True`.
- Kept GPU execution on the CUDA 12.4 / PyTorch 2.6.0 stack validated on RTX 3090.

### Audio Normalization

- Standardized all incoming audio to mono `16 kHz` before inference.
- Confirmed support for mixed source sample rates such as `16 kHz`, `22.05 kHz`, `44.1 kHz`, and `48 kHz`.
- Preserved support for common upload formats including WAV, MP3, FLAC, and OGG.

### Verification

- Revalidated the API with endpoint tests and Docker runtime checks.
- Confirmed successful native-backend transcription for:
  - `Recording2.wav` -> `Dzien dobry wszystkim.`
  - `Recording.wav` -> meaningful Polish transcription with minor ASR errors only

### Notes

- `whisper.cpp` route compatibility remains unchanged.
- Compatibility-only request parameters are still accepted where already supported by the API wrapper.
