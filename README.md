# Project 2 — Containerized Hello App on Cloud Run (London)

**Project ID:** \`web-demo-473709\`  
**Region:** \`europe-west2\`  

## Overview
A minimal Flask app packaged as a Docker image, stored in Artifact Registry, and deployed to Cloud Run (fully managed). Shows containerization + serverless deploy.

## Quick Start (CLI)
```bash
gcloud config set project web-demo-473709
gcloud services enable run.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com

gcloud artifacts repositories create apps \
  --repository-format=docker --location=europe-west2

IMAGE="europe-west2-docker.pkg.dev/web-demo-473709/apps/hello:v1"
gcloud builds submit --tag "$IMAGE"

gcloud run deploy hello-run --image "$IMAGE" --region europe-west2 --allow-unauthenticated


