Limpa tudo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
minikube delete --all --purge
kubectl delete all --all -n app-database
kubectl delete all --all -n app-frontend-backend
docker system prune -a --volumes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Inicia
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
minikube start --cpus=4 --memory=8192 --driver=docker
minikube status
minikube addons enable ingress
minikube start --kubernetes-version=v1.28.3 --driver=docker
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


Roda todos os YAMLs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
for f in namespace.yaml \
         database/*.yaml \
         backend/*.yaml \
         frontend/*.yaml \
         ingress/*.yaml; do
  kubectl apply -f "$f"
done
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

# Comandos Utilizados

Segue a descrição objetiva de cada comando, em termos técnicos e corporativos:

kubectl get pods -n app
Lista todos os Pods no namespace app. Útil para verificar status (Running/CrashLoopBackOff) e identificar nomes de instâncias em produção.

kubectl get svc -n app
Exibe todos os Services no mesmo namespace. Permite conferir endereço (ClusterIP), porta exposta e mapeamento para os Pods backend/front.

kubectl get pods -A
Enumera Pods em todos os namespaces (-A = all namespaces). Ideal para auditoria global ou diagnóstico de DNS/CoreDNS no kube-system.

kubectl get deployments -n app
Lista as Deployments no namespace app. Mostra o número de réplicas desejadas versus as em execução, servindo para checar se há divergência (ex: falha de rolling update).

kubectl logs deployment/backend -n app
Exibe o stdout dos Pods gerenciados pela Deployment backend. Consolida logs de todas as réplicas, facilitando análise centralizada.

kubectl logs <podname> -n app
Captura logs do Pod específico <podname>. Útil quando você deseja rastrear falhas pontuais ou mensagens de erro num nó determinado.

kubectl rollout restart deployment backend -n app-namespace
Inicia um rolling restart na Deployment backend (namespace app-namespace), recriando os Pods sem downtime perceptível. Use para aplicar variáveis de ambiente ou atualizar a imagem.

kubectl rollout restart deployment frontend -n app-namespace
Mesma lógica acima, porém para a Deployment frontend. Garante que o novo bundle React (com o .env atualizado) seja carregado.

kubectl describe pod <podname> -n namespace
Fornece informações detalhadas (events, condições, node alvo, volumes, environment variables) do Pod <podname> em namespace. Ferramenta essencial para debug de ConfigMaps, Secrets e liveness/readiness probes.

kubectl exec -it <podname> -n app -- /bin/sh
Abre um shell interativo dentro do Pod <podname> no namespace app. Permite inspeção manual do filesystem, variáveis e execução de comandos de debug.

kubectl exec -n app -it <podname> -- curl http://backend:5000/api/mensagens
A partir de dentro do Pod <podname>, executa curl contra o serviço backend no cluster. Verifica connectivity e resposta da API internamente.

kubectl exec <podname> -n app-namespace -- curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/api/mensagens
Roda curl silencioso (-s), sem output do body (-o /dev/null), retornando apenas o HTTP status code (-w "%{http_code}"). Útil para testes de health check e readiness probe.

kubectl exec -it $(kubectl get pod -n app -l app=backend -o jsonpath='{.items[0].metadata.name}') -n app -- sh
Combina dois comandos:

kubectl get pod -l app=backend → busca o nome do primeiro Pod cujo label app=backend;

kubectl exec -it … -- sh → abre shell no Pod identificado. Automatiza a seleção do Pod.

kubectl port-forward deployment/backend 5000:5000 -n app
Cria um túnel local que mapeia sua máquina (localhost:5000) para o contêiner backend (pod:5000). Permite testar a API localmente sem expor NodePort ou configurar Ingress.

http://backend-service.app.svc.cluster.local:5000
Endereço DNS interno do Kubernetes para o Service chamado backend-service no namespace app. Usado quando aplicações rodando dentro do cluster precisam acessar o backend diretamente, sem passar por Ingress ou NodePort.
