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
**1. Limpar ambiente (opcional, antes de um novo deploy):**

    **Apaga tudo do Minikube e Docker**
    minikube delete --all --purge
    kubectl delete all --all -n app-database
    kubectl delete all --all -n app-frontend-backend
    docker system prune -a --volumes

**2. Iniciar Minikube com configuração ideal:**

       **Iniciar Minikube com 4 CPUs e 8GB de RAM (driver Docker)**
    minikube start --cpus=4 --memory=8192 --driver=docker
    
    **Ativar o Ingress Controller**
    minikube addons enable ingress
    
    **(Opcional) especificar versão do Kubernetes**
    minikube start --kubernetes-version=v1.28.3 --driver=docker
    
    **Verificar status do cluster**
    minikube status

**3. Aplique os manifests:**

    kubectl apply -f database/ -n db
    kubectl apply -f backend/ -n app
    kubectl apply -f frontend/ -n app
    kubectl apply -f ingress/ -n app
**4. Aplicar Namespaces e YAMLs:**

    **Aplicar os namespaces primeiro**
    kubectl apply -f namespace.yaml
    
    **Aplicar todos os arquivos YAML do projeto**
    for f in namespace.yaml \
             database/*.yaml \
             backend/*.yaml \
             frontend/*.yaml \
             ingress/*.yaml; do
      kubectl apply -f "$f"
    done

##
## 5. Endereço de Acesso Esperado via Ingress
A aplicação será acessível através do IP retornado pelo comando minikube ip. As rotas são:

- Frontend (React):

       http://meuprojeto.local/

- Backend (Flask API):

      http://meuprojeto.local/api/
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


