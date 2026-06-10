#!/bin/bash

# Set region
export REGION=europe-west1
gcloud config set compute/region $REGION

# =========================
# Task 1: API Key (manual step)
# =========================
echo "Create API Key in Console and paste it below"
read -p "Enter API Key: " API_KEY
export API_KEY=$API_KEY

# =========================
# Task 2: Translate text
# =========================
TEXT="My%20name%20is%20Steve"

echo "Translating text..."
curl "https://translation.googleapis.com/language/translate/v2?target=es&key=${API_KEY}&q=${TEXT}"

echo ""

# =========================
# Task 3: Detect language
# =========================
TEXT_ONE="Meu%20nome%20é%20Steven"
TEXT_TWO="日本のグーグルのオフィスは、東京の六本木ヒルズにあります"

echo "Detecting language..."
curl -X POST "https://translation.googleapis.com/language/translate/v2/detect?key=${API_KEY}" \
-d "q=${TEXT_ONE}" \
-d "q=${TEXT_TWO}"

echo ""
echo "DONE"
