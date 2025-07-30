  #                                                         Projeto Deploy Aplicação Kubernetes

  ## 👥 Integrantes da Equipe

- [Samuel Araujo Cabral e Silva](https://github.com/Amelus99)
- [Ariele Laiane da Silva Amaral](https://github.com/arielelaiane2017)
- [Maria Isabel](https://github.com/Bellsatu)
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
    │
    ├── namespace.yaml                        # Definição dos namespaces utilizados no cluster
    ├── README.md                             # Instruções de deploy, uso e observações técnicas
    │
    ├── backend/                              # Manifests do backend (Flask API)
    │   ├── configmap.yaml                    # Variáveis de ambiente (.env)
    │   ├── deployment.yaml                   # Deployment do backend
    │   ├── secret.yaml                       # Credenciais sensíveis (DB, API keys, etc.)
    │   └── service.yaml                      # Service do backend (tipo ClusterIP)
    │
    ├── database/                             # Manifests do banco de dados PostgreSQL
    │   ├── pvc.yaml                          # Volume persistente (1Gi+)
    │   ├── secret.yaml                       # Senha e configs sensíveis do banco
    │   ├── service.yaml                      # Service para expor o PostgreSQL
    │   └── statefulset.yaml                  # StatefulSet para garantir identidade e persistência
    │
    ├── frontend/                             # Manifests do frontend (React/Vite)
    │   └── deployment.yaml                   # Deployment do frontend
    │
    ├── ingress/                              # Regras de entrada HTTP/HTTPS
    │   └── ingress.yaml                      # Definição do host/path (ex: meuprojeto.local/api)
    │
    └── debug/                                # Pods utilitários para troubleshooting
        ├── degug-pod.yaml                    # Pod para testes básicos (shell)
        ├── dnsutils.yaml                     # Ferramentas DNS (dig, nslookup)
        └── netshoot.yaml                     # Ferramentas de rede (curl, ping, tcpdump etc)
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

    Apaga tudo do Minikube e Docker
    minikube delete --all --purge
    kubectl delete all --all -n app-database
    kubectl delete all --all -n app-frontend-backend
    docker system prune -a --volumes

**2. Iniciar Minikube com configuração ideal:**

    Iniciar Minikube com 4 CPUs e 8GB de RAM (driver Docker)
    minikube start --cpus=4 --memory=8192 --driver=docker
    
    Ativar o Ingress Controller
    minikube addons enable ingress
    
    (Opcional) especificar versão do Kubernetes
    minikube start --kubernetes-version=v1.28.3 --driver=docker
    
    Verificar status do cluster
    minikube status

**3.Aplicar Namespaces e YAMLs:**

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
    
## Inspeção de Recursos

    kubectl get pods -n app
    Lista todos os Pods no namespace app. Útil para verificar status (Running, CrashLoopBackOff) e identificar instâncias em execução.
    
    
    kubectl get svc -n app
    Exibe os Services do namespace app. Permite ver IP interno (ClusterIP), portas e mapeamentos para os Pods.
    
    
    kubectl get pods -A
    Lista todos os Pods de todos os namespaces. Excelente para auditorias e diagnósticos amplos, como erros no kube-system.
    
    
    kubectl get deployments -n app
    Mostra os Deployments no namespace app, comparando réplicas desejadas e ativas — ideal para identificar falhas de rollout.

**📜 Logs e Diagnóstico**

    kubectl logs deployment/backend -n app
    Consolida os logs dos Pods gerenciados pelo Deployment backend. Útil para diagnóstico unificado.
    
    
    kubectl logs <podname> -n app
    Retorna os logs de um Pod específico. Ajuda a rastrear falhas pontuais ou mensagens de erro.

**🔁 Atualização de Deployments**

    kubectl rollout restart deployment backend -n app
    kubectl rollout restart deployment frontend -n app
    Realiza um rolling restart dos Deployments, aplicando novas variáveis ou imagens. Não há downtime perceptível.

**🔎 Debug Detalhado**

    kubectl describe pod <podname> -n app
    Exibe detalhes completos do Pod, incluindo eventos, node, variáveis, volumes e probes.
    
    
    kubectl exec -it <podname> -n app -- /bin/sh
    Abre um shell interativo no contêiner. Permite depuração manual e execução de comandos como curl, ping, psql, etc.

**🌐 Testes Internos de Conectividade**

    kubectl exec -n app -it <podname> -- curl http://backend:5000/api/mensagens
    Verifica conectividade de um Pod para o serviço backend. Simula uma chamada de API dentro do cluster.
    
    
    kubectl exec <podname> -n app -- curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/api/mensagens
    Testa apenas o código de status HTTP. Muito usado em scripts de readiness e health checks.

**⚡ Comando Dinâmico**

    kubectl exec -it $(kubectl get pod -n app -l app=backend -o jsonpath='{.items[0].metadata.name}') -n app -- sh
    Executa sh automaticamente no primeiro Pod com o label app=backend. Evita precisar copiar o nome do Pod manualmente.

**🔌 Acesso Local à API sem Ingress**

    kubectl port-forward deployment/backend 5000:5000 -n app
    Cria um túnel do seu localhost:5000 para o Pod backend. Permite testar a API mesmo sem Ingress.

**📡 DNS Interno do Cluster**
      
      http://backend-service.app.svc.cluster.local:5000
      Nome DNS interno do Service backend-service no namespace app. Usado por aplicações internas para se comunicarem diretamente com o backend.

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

[Analogias](https://github.com/Amelus99/Kube_Project/blob/main/Analogias.md)
