# Deploy de Aplicação Fullstack em Kubernetes

## Integrantes da Equipe
- Samuel [amelus99](https://hub.docker.com/u/amelus99)

## Objetivo do Projeto
Realizar o deploy de uma aplicação fullstack (React + Flask + PostgreSQL) em Kubernetes, com foco em alta disponibilidade, persistência de dados e boas práticas com uso de ConfigMap, Secrets e IngressController.

## Estrutura da Aplicação
- **Frontend (React):** Container React servindo aplicação estática.
- **Backend (Flask):** API REST para envio e listagem de mensagens.
- **Banco de Dados (PostgreSQL):** Persistência de dados com PVC.

### Componentes Kubernetes
- `Deployment` para frontend e backend com 2 réplicas (alta disponibilidade)
- `StatefulSet` para PostgreSQL com PVC
- `ConfigMap` para variáveis de configuração
- `Secrets` para credenciais sensíveis
- `IngressController` com rotas:
  - `/` → frontend
  - `/api/` → backend Flask

## Passos para Executar o Projeto

> Requisitos: cluster Kubernetes funcional (Minikube ou Kind), kubectl, Ingress NGINX instalado e ativo.

### 1. Criar Namespaces
```bash
kubectl apply -f namespace.yaml

