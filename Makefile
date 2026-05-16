# =========================
# VARIABLES
# =========================
CLUSTER_NAME=securegitops
ARGOCD_NAMESPACE=argocd
ARGOCD_MANIFEST_URL=https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# =========================
# CLUSTER K3D
# =========================
k3d-up:
	k3d cluster delete $(CLUSTER_NAME) || true
	k3d cluster create $(CLUSTER_NAME) --agents 2 --api-port 6550 -p "8081:80@loadbalancer"
	kubectl cluster-info

# =========================
# BOOTSTRAP ARGOCD
# =========================
bootstrap:
	kubectl create namespace $(ARGOCD_NAMESPACE) || true

	kubectl apply -n $(ARGOCD_NAMESPACE) -f $(ARGOCD_MANIFEST_URL)

	kubectl -n $(ARGOCD_NAMESPACE) wait --for=condition=available deployment argocd-server --timeout=180s
	kubectl -n $(ARGOCD_NAMESPACE) wait --for=condition=available deployment argocd-repo-server --timeout=180s
	kubectl -n $(ARGOCD_NAMESPACE) wait --for=condition=available deployment argocd-application-controller --timeout=180s

	kubectl patch svc argocd-server -n $(ARGOCD_NAMESPACE) -p '{"spec": {"type": "LoadBalancer"}}'

# =========================
# DEPLOY APPS (GITOPS ROOT)
# =========================
deploy:
	kubectl apply -f argocd/apps/apps-of-apps.yaml
	kubectl get applications -n $(ARGOCD_NAMESPACE)

# =========================
# STATUS CHECK
# =========================
status:
	kubectl get nodes
	kubectl get pods -n $(ARGOCD_NAMESPACE)
	kubectl get applications -n $(ARGOCD_NAMESPACE)
	k3d cluster list

# =========================
# FULL PIPELINE
# =========================
all: k3d-up bootstrap deploy status

# # Makefile
# k3d-up:
# 	k3d cluster create securegitops --agents 2 --api-port 6550 -p "8081:80@loadbalancer"

# # bootstrap:
# # 	kubectl create namespace argocd || true
# # 	kubectl apply -n argocd -f argocd/install.yaml

# bootstrap:
# 	kubectl create namespace argocd || true
# 	curl -sSL https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml | kubectl apply -n argocd -f -
# 	kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# deploy:
# 	kubectl apply -f argocd/apps/apps-of-apps.yaml
