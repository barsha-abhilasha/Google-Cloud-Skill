# Speech-to-Text Lab (Google Cloud) – README

## 🚀 What this script does
This script automates Google Cloud Speech-to-Text API tasks:
- Creates `request.json` for English transcription
- Calls Speech-to-Text API (English)
- Updates request for French audio
- Calls API again (French)
- Saves results in `result.json`

---

## ⚙️ Prerequisites
- Google Cloud Qwiklabs VM (`linux-instance`)
- API Key for **Cloud Speech-to-Text API**
- SSH access to VM

---

## 🔑 Step 1: Connect to VM

Run in Cloud Shell:

```bash
export ZONE=$(gcloud compute instances list linux-instance --format 'csv[no-heading](zone)')
gcloud compute ssh linux-instance --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet
```
---
## 📄 Step 2: Create Script

Inside the VM, create a shell script file:

```bash
nano run.sh
```
---
## ▶️ Step 3: Run Script

Make the script executable:

```bash
chmod +x run.sh
```

Run the script:

```bash
./run.sh
```
