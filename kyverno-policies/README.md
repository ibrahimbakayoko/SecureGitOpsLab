# Kyverno Policies for NodeJS Application

Ce dépôt contient les politiques **Kyverno** utilisées pour sécuriser et valider les manifests Kubernetes de l'application **NodeJS Basic App** dans un pipeline **CI/CD GitLab**.

---

## 📂 Structure du dépôt

kyverno-policies/
├── kyverno-test-policy.yaml # Politique de test pour démonstration
└── nodejs-basic-policy.yaml # Politique principale appliquée sur l'app NodeJS

```yaml

- **`nodejs-basic-policy.yaml`** : Politique Kyverno principale pour valider les manifests générés par Helm pour l’application NodeJS.  
- **`kyverno-test-policy.yaml`** : Politique de test pour expérimentations et validations locales.  
```
---

## 🎯 Objectif

L'objectif de cette politique est de :

- ✅ Assurer que tous les manifests Kubernetes respectent les **bonnes pratiques de sécurité**.  
- ✅ Valider que les déploiements Helm pour l’application NodeJS suivent les **standards définis**.  
- ✅ Intégrer Kyverno dans le pipeline CI/CD pour un **contrôle automatisé avant le déploiement**.  

---

## ⚙️ Intégration CI/CD GitLab

Le pipeline **GitLab** (`.gitlab-ci.yml`) est structuré en **quatre stages** :

1. **Build** : Construction et tagging de l’image Docker.  
2. **Scan** : Analyse de sécurité de l’image avec Trivy.  
3. **Kyverno Validation** : Validation des manifests Kubernetes générés par Helm via Kyverno.  
4. **Deploy** : Déploiement GitOps vers les environnements `dev`, `staging` et `prod`.  

---

## 🔑 Variables principales

```yaml
variables:
  IMAGE_NAME: registry.gitlab.com/grouptest2480246/my-test-app
  IMAGE_TAG: $CI_COMMIT_SHORT_SHA
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: ""
```

🛠️ Étapes détaillées
1. Build Image (build_image)
Image Docker : docker:27.0.3

Services : docker:27.0.3-dind

Actions :

Connexion au registry GitLab

Build et tag de l’image Docker

Ajout du tag latest pour la branche main

2. Scan Image (scan_image)
Image Docker : docker:24.0.6

Installation de Trivy pour l’analyse de sécurité

Build de l’image localement puis scan

Vérifie les vulnérabilités de niveau HIGH ou supérieures

Dépendance : build_image

3. Validation Kyverno (kyverno_validate)
Image : alpine:latest

Installation de Kyverno CLI et Helm

Clonage du repo GitOps contenant les charts Helm et les policies Kyverno

📌 Rendu Helm pour l’environnement dev :

```bash
helm template my-app \
  SecureGitOpsLab/argocd/helm-deploy/overlays/chart \
  -f SecureGitOpsLab/argocd/helm-deploy/overlays/dev/dev-values.yaml \
  > rendered.yaml
📌 Validation via Kyverno :
```
```bash
kyverno apply SecureGitOpsLab/kyverno-policies/nodejs-basic-policy.yaml \
  --resource rendered.yaml \
  --namespace default
Dépendance : scan_image

```
4. Déploiement GitOps (deploy_dev, deploy_staging, deploy_prod)
Mise à jour des valeurs de l’image dans les fichiers Helm (yq)

Commit et push vers le repo GitOps

Déploiement automatisé selon l’ordre : dev → staging → prod

Chaque job dépend du précédent pour garantir une promotion contrôlée de l’image

💻 Exemple de commande pour validation locale
```bash
# Appliquer la policy Kyverno sur un manifest local
kyverno apply nodejs-basic-policy.yaml --resource rendered.yaml --namespace default
```
✅ Bonnes pratiques
Toujours valider les manifests avec Kyverno avant tout déploiement.

Scanner régulièrement les images Docker avec Trivy pour détecter les vulnérabilités.

Utiliser un pipeline GitLab structuré pour automatiser build, scan, validation et déploiement.

Maintenir les policies Kyverno à jour avec les standards Kubernetes et les exigences de sécurité de l’entreprise.