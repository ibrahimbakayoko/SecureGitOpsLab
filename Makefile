# Makefile
k3d-up:
	k3d cluster create securegitops --agents 2 --api-port 6550 -p "8081:80@loadbalancer"

# bootstrap:
# 	kubectl create namespace argocd || true
# 	kubectl apply -n argocd -f argocd/install.yaml

bootstrap:
	kubectl create namespace argocd || true
	curl -sSL https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml | kubectl apply -n argocd -f -
	kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

deploy:
	kubectl apply -f argocd/apps/apps-of-apps.yaml
