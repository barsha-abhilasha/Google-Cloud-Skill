#!/bin/bash

# Set region (change if lab specifies another region)
gcloud config set compute/region us-central1

# Enable API
gcloud services enable texttospeech.googleapis.com

# Install virtualenv
sudo apt-get update
sudo apt-get install -y virtualenv

# Create venv
python3 -m venv venv
source venv/bin/activate

# Create service account
gcloud iam service-accounts create tts-qwiklab

# Get project ID
PROJECT_ID=$(gcloud config get-value project)

# Create key
gcloud iam service-accounts keys create tts-qwiklab.json \
--iam-account tts-qwiklab@${PROJECT_ID}.iam.gserviceaccount.com

# Auth
export GOOGLE_APPLICATION_CREDENTIALS=tts-qwiklab.json

# Get voices
curl -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json; charset=utf-8" \
"https://texttospeech.googleapis.com/v1/voices" > voices.json

curl -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json; charset=utf-8" \
"https://texttospeech.googleapis.com/v1/voices?language_code=en" > voices-en.json

# Text request
cat > synthesize-text.json <<EOF
{
  "input": {
    "text": "Cloud Text-to-Speech API allows developers to include natural-sounding synthetic human speech."
  },
  "voice": {
    "languageCode": "en-GB",
    "name": "en-GB-Standard-A",
    "ssmlGender": "FEMALE"
  },
  "audioConfig": {
    "audioEncoding": "MP3"
  }
}
EOF

# Call API
curl -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json; charset=utf-8" \
-d @synthesize-text.json \
"https://texttospeech.googleapis.com/v1/text:synthesize" \
> synthesize-text.txt

# Decoder
cat > tts_decode.py <<EOF
import json
import argparse
from base64 import decodebytes

def decode(input_file, output_file):
    with open(input_file) as f:
        response = json.load(f)
        audio = response["audioContent"]

    with open(output_file, "wb") as out:
        out.write(decodebytes(audio.encode("utf-8")))

parser = argparse.ArgumentParser()
parser.add_argument("--input", required=True)
parser.add_argument("--output", required=True)
args = parser.parse_args()

decode(args.input, args.output)
EOF

# Create MP3
python3 tts_decode.py --input synthesize-text.txt --output synthesize-text-audio.mp3

# SSML request
cat > synthesize-ssml.json <<EOF
{
  "input": {
    "ssml": "<speak><s><emphasis level='moderate'>Cloud Text-to-Speech API</emphasis> allows natural speech.</s></speak>"
  },
  "voice": {
    "languageCode": "en-GB",
    "name": "en-GB-Standard-A",
    "ssmlGender": "FEMALE"
  },
  "audioConfig": {
    "audioEncoding": "MP3"
  }
}
EOF

# SSML call
curl -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json; charset=utf-8" \
-d @synthesize-ssml.json \
"https://texttospeech.googleapis.com/v1/text:synthesize" \
> synthesize-ssml.txt

python3 tts_decode.py --input synthesize-ssml.txt --output synthesize-ssml-audio.mp3

# Advanced settings
cat > synthesize-with-settings.json <<EOF
{
  "input": {
    "text": "The Text-to-Speech API converts text into natural speech."
  },
  "voice": {
    "languageCode": "en-US",
    "name": "en-GB-Standard-A",
    "ssmlGender": "FEMALE"
  },
  "audioConfig": {
    "speakingRate": 1.15,
    "pitch": -2,
    "audioEncoding": "OGG_OPUS",
    "effectsProfileId": ["headphone-class-device"]
  }
}
EOF

# Advanced call
curl -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json; charset=utf-8" \
-d @synthesize-with-settings.json \
"https://texttospeech.googleapis.com/v1beta1/text:synthesize" \
> synthesize-with-settings.txt

python3 tts_decode.py --input synthesize-with-settings.txt --output synthesize-with-settings-audio.mp3

echo "DONE: All tasks completed"
