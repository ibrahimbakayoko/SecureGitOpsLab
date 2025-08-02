# ⚙️ ArgoCD GitOps Configuration

Ce dossier contient les ressources nécessaires au déploiement GitOps via ArgoCD, selon le modèle **App of Apps**.

## 📁 Structure

| Fichier/Dossier           | Rôle                                                                 |
|---------------------------|----------------------------------------------------------------------|
| `install.yaml` (optionnel)| Manifest officiel d'installation ArgoCD                             |
| `apps-of-apps.yaml`       | Application racine (Root App) pour ArgoCD (modèle App of Apps)      |
| `apps/`                   | Applications enfants déployées via ArgoCD (Trivy, Kyverno, etc.)    |

## 🚀 Installation

```bash
# Créer le namespace
kubectl create namespace argocd || true
```
# Installer ArgoCD via le manifest officiel
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
# Rendre l'interface accessible en local
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
🌍 Accès à l'interface Web
```bash
http://localhost:8081
```
🔐 Récupérer le mot de passe initial :

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```
📦 App of Apps
L’approche App of Apps permet à ArgoCD de gérer toutes les applications enfants à partir d’un seul manifest racine.

📄 apps-of-apps.yaml
Ce fichier référence les applications suivantes :

Nom de l'app	Description	Catégorie
trivy	Scan de vulnérabilités	Sécurité
kyverno	Validation de policies	Sécurité
prometheus	Monitoring des métriques	Observabilité
grafana	Dashboards graphiques	Observabilité
alertmanager	Gestion des alertes	Observabilité
gitlab-runner	Exécuteur GitLab CI auto-hébergé	CI/CD

🚀 Déploiement
```bash
kubectl apply -f argocd/apps/apps-of-apps.yaml
Les applications seront visibles dans l'interface web d’ArgoCD.
```
🔄 Commandes utiles
Voir toutes les applications :

```bash
kubectl get applications -n argocd
Forcer la synchronisation :
```
```bash
argocd app sync <app-name>
