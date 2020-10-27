#!/usr/bin/env bash

PROJECT="mintak"
LOCATION="us-central1-a"
CLUSTER="mintaklinebot"
SEALED_SECRET_VERSION="v0.12.6"

# Client Install
brew install kubeseal

# Cluster Install
gcloud config set project ${PROJECT}
gcloud container clusters get-credentials ${CLUSTER} --zone ${LOCATION} --project ${PROJECT}
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/${SEALED_SECRET_VERSION}/controller.yaml
