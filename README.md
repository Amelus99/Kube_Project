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
##
## 3. Tecnologias Utilizadas
- Kubernetes (Minikube ou Kind)
- Docker & DockerHub
- React.js (Frontend)
- Flask (Backend)
- PostgreSQL
- Ingress NGINX
- ConfigMap & Secrets
- PVC (PersistentVolumeClaim)
##
## 4. Passos para aplicar os arquivos
**1. Inicie o cluster Kubernetes:**

    minikube start
    minikube addons enable ingress
**2. Crie os namespaces:**

    kubectl apply -f namespace.yaml
**3. Aplique os manifests:**

    kubectl apply -f database/ -n db
    kubectl apply -f backend/ -n app
    kubectl apply -f frontend/ -n app
    kubectl apply -f ingress/ -n app
**4. Verifique o IP de acesso:**

    minikube ip
##
## 5. Endereço de Acesso Esperado via Ingress
A aplicação será acessível através do IP retornado pelo comando minikube ip. As rotas são:

- Frontend (React):

       http://<IP_DO_MINIKUBE>/

- Backend (Flask API):

      http://<IP_DO_MINIKUBE>/api/
##
## Descrição Breve da Arquitetura
A aplicação está estruturada em dois namespaces:
- app: para os pods do frontend e backend
- db: para o banco de dados PostgreSQL

Cada componente é deployado da seguinte forma:

    | Componente   | Kubernetes Resource                     | Extras                            |
    | ------------ | --------------------------------------- | --------------------------------- |
    | Frontend     | Deployment + Service (ClusterIP)        | 2 réplicas (alta disponibilidade) |
    | Backend      | Deployment + Service (ClusterIP)        | ConfigMap + Secret                |
    | PostgreSQL   | StatefulSet + PVC + Service (ClusterIP) | Secret + persistência             |
    | Configuração | ConfigMap + Secrets                     | DB\_HOST, senhas etc.             |
    | Ingress      | NGINX com rotas `/` e `/api`            | Acesso externo via IP             |


