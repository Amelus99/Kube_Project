  #                                                         Projeto Deploy Aplicação Kubernetes

  ## 👥 Integrantes da Equipe

- Samuel Araujo Cabral e Silva
- Ariele Laiane da Silva Amaral
- Maria Isabel
##
## 1. Objetivo do Projeto
Realizar o deploy de uma aplicação web fullstack (React no frontend, Flask no backend e PostgreSQL como banco de dados) em um cluster Kubernetes, garantindo:

- Alta disponibilidade para frontend e backend;
- Configuração segura via ConfigMap e Secrets;
- Persistência de dados no banco PostgreSQL via PVC;
- Acesso externo via NGINX Ingress Controller.

##
## 2. Estrutura do Projeto
    projeto-k8s-deploy/
    ├── README.md
    ├── frontend/
    │   └── deployment.yaml
    ├── backend/
    │   ├── deployment.yaml
    │   └── configmap.yaml
    ├── database/
    │   ├── statefulset.yaml
    │   ├── pvc.yaml
    │   └── secret.yaml
    ├── ingress/
    │   └── ingress.yaml
    └── namespace.yaml

