#!/bin/bash
set -e

echo "[INFO] Aplicando namespace..."
kubectl apply -f namespace.yaml

echo "[INFO] Aplicando recursos do banco de dados..."
kubectl apply -n db -f database/secret.yaml
kubectl apply -n db -f database/pvc.yaml
kubectl apply -n db -f database/service.yaml
kubectl apply -n db -f database/statefulset.yaml

echo "[INFO] Aplicando recursos do backend..."
kubectl apply -n app -f backend/secret.yaml
kubectl apply -n app -f backend/configmap.yaml
kubectl apply -n app -f backend/service.yaml
kubectl apply -n app -f backend/deployment.yaml

echo "[INFO] Aplicando recursos do frontend..."
kubectl apply -n app -f frontend/deployment.yaml

echo "[INFO] Aplicando ingress..."
kubectl apply -n app -f ingress/ingress.yaml

echo "[OK] Deploy concluído com sucesso."
