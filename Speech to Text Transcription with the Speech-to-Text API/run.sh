#!/bin/bash

# Exit on error
set -e

echo "===================================="
echo "Speech-to-Text Lab Automation Script"
echo "===================================="

# 1. Get API key from user
echo "Enter your API Key:"
read API_KEY

export API_KEY=$API_KEY
echo "API Key set."

# 2. Create request.json (English)
cat > request.json <<EOF
{
  "config": {
    "encoding": "FLAC",
    "languageCode": "en-US"
  },
  "audio": {
    "uri": "gs://cloud-samples-data/speech/brooklyn_bridge.flac"
  }
}
EOF

echo "request.json created (English)"

# 3. Call Speech API (English)
curl -s -X POST \
  -H "Content-Type: application/json" \
  --data-binary @request.json \
  "https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" \
  > result.json

echo "English transcription done."
cat result.json

# 4. Modify for French
cat > request.json <<EOF
{
  "config": {
    "encoding": "FLAC",
    "languageCode": "fr"
  },
  "audio": {
    "uri": "gs://cloud-samples-data/speech/corbeau_renard.flac"
  }
}
EOF

echo "request.json updated (French)"

# 5. Call Speech API (French)
curl -s -X POST \
  -H "Content-Type: application/json" \
  --data-binary @request.json \
  "https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" \
  > result.json

echo "French transcription done."
cat result.json

echo "DONE"
