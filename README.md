![Dockerfile Lint](https://github.com/ibhadeA/project2-cloud-run-hello/actions/workflows/docker-lint.yml/badge.svg)

![Docker Build & Test](https://github.com/ibhadeA/project2-cloud-run-hello/actions/workflows/docker-build-test.yml/badge.svg)

# Project 2 — Containerized Hello App on Cloud Run (London)

**Project ID:** `web-demo-473709`  
**Region:** `europe-west2` (London)

---

## Overview
A minimal **Flask** web app packaged as a **Docker** image, stored in **Artifact Registry**, and deployed to **Cloud Run (fully managed)** behind HTTPS. This project demonstrates containerization + serverless deployment and uses **Cloud Build** to build/push the image.

---

## Architecture

Dev machine (Cloud Shell)
├── Build container (Cloud Build)
│ └── Image → Artifact Registry (repo: apps)
└── Deploy → Cloud Run service (hello-run, europe-west2) → HTTPS URL


---

## Quick Start (CLI)

> Assumes: project `web-demo-473709`, region `europe-west2`, repo `apps`.


###  Set context
gcloud config set project web-demo-473709
gcloud config set run/region europe-west2

###  Enable APIs
gcloud services enable run.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com

###  Create Artifact Registry (one-time)
gcloud artifacts repositories create apps \
  --repository-format=docker \
  --location=europe-west2 \
  --description="App images"  || true   # ok if already exists

###  Build + push image with Cloud Build
IMAGE="europe-west2-docker.pkg.dev/web-demo-473709/apps/hello:v1"
gcloud builds submit --tag "$IMAGE"

###  Deploy to Cloud Run (public)
gcloud run deploy hello-run \
  --image "$IMAGE" \
  --region europe-west2 \
  --allow-unauthenticated

###  Get URL
gcloud run services describe hello-run --region europe-west2 --format='value(status.url)'
Test

URL=$(gcloud run services describe hello-run --region europe-west2 --format='value(status.url)')
curl -s "$URL"
###  -> Hello from Cloud Run! Service=hello-run, Region=europe-west2

---
## Troubleshooting
Build failed? Console → Cloud Build → History → open the failed build and read logs.

Deploy blocked? Ensure run.googleapis.com, artifactregistry.googleapis.com, cloudbuild.googleapis.com are enabled.

Runtime error? Console → Cloud Run → hello-run → Logs.

---
## Cleanup

###  Remove the Cloud Run service
gcloud run services delete hello-run --region europe-west2 --quiet

###  Remove image (and tags)
gcloud artifacts docker images delete \
  "europe-west2-docker.pkg.dev/web-demo-473709/apps/hello:v1" \
  --delete-tags --quiet

## (Optional) delete the entire Artifact Registry repo (if empty)
###  gcloud artifacts repositories delete apps --location=europe-west2 --quiet

---
## Key Learnings
- Build immutable Docker images and store them in Artifact Registry.

- Use Cloud Build for reproducible, logged builds.

- Deploy containers to Cloud Run for fully managed, autoscaled HTTPS services.

## Next Steps
- Add a CI workflow to lint the Dockerfile (Hadolint) ⇒ see .github/workflows/docker-lint.yml.

- Add another workflow to build the image on PR, and (optionally) deploy on merge.



---

## B) GitHub Action: **Dockerfile Lint** (Hadolint)

This runs on every push/PR and fails if your Dockerfile has common issues.


###  .github/workflows/docker-lint.yml
name: Dockerfile Lint
on:
  push:
  pull_request:

jobs:
  hadolint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Install hadolint (static binary)
      - name: Install hadolint
        run: |
          curl -sSLo /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
          chmod +x /usr/local/bin/hadolint

      - name: Lint Dockerfile
        run: hadolint Dockerfile
Add a badge to the top of your README (first line):


![Dockerfile Lint](https://github.com/ibhadeA/project2-cloud-run-hello/actions/workflows/docker-lint.yml/badge.svg)

## C) Do it from Cloud Shell (commands)
From your Project 2 folder:


cd ~/project2-cloud-run-hello

###  1) Write README.md (if you haven’t already)
same as above

### 2) Create the workflow
mkdir -p .github/workflows
cat > .github/workflows/docker-lint.yml <<'EOF'
name: Dockerfile Lint
on:
  push:
  pull_request:

jobs:
  hadolint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install hadolint
        run: |
          curl -sSLo /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64
          chmod +x /usr/local/bin/hadolint
      - name: Lint Dockerfile
        run: hadolint Dockerfile
EOF

### 3) Add the badge at the very top of README
  (Open in nano if you want to place it nicely)
 nano README.md

## 4) Commit & push
git add README.md .github/workflows/docker-lint.yml
git commit -m "Add Project 2 README and Dockerfile lint workflow"
git push

## D) Or do it in the GitHub Web UI
Open your repo: project2-cloud-run-hello.

Add file → Create new file → name: .github/workflows/docker-lint.yml → paste the YAML → Commit.

Open README.md → pencil → paste the README content → Commit.

Add the badge as the very first line of README.md → Commit.

Click the Actions tab → see Dockerfile Lint running; fix anything it flags.
