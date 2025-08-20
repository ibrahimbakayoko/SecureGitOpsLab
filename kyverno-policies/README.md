# 🛡️ Kyverno Policies pour Secure GitOps Lab

Ce dépôt contient les **policies Kyverno** utilisées pour renforcer la sécurité et la conformité des déploiements Kubernetes dans le cadre du projet **Secure GitOps Lab**.  
Les policies sont appliquées et testées automatiquement dans le pipeline GitLab CI/CD avant déploiement via ArgoCD.

---

## 📂 Structure du dépôt
```yaml
.
├── kyverno-test-policy.yaml # Policy de test simple (label obligatoire)
└── nodejs-basic-policy.yaml # Policy spécifique à l'application Node.js

```
---

## 📌 Note importante

👉 **NB : Le pipeline GitLab CI/CD associé à ces policies se trouve dans le dépôt de l’application test Node.js**.  
🔗 [Lien vers le dépôt GitLab]()  

Les policies de ce dépôt sont **référencées et utilisées directement par ce pipeline** pour valider les manifests Kubernetes.


---

## 📌 Extrait du pipeline
```yaml
stages:
  - build
  - scan
  - kyverno_validate
  - deploy

variables:
  IMAGE_NAME: registry.gitlab.com/grouptest2480246/my-test-app
  IMAGE_TAG: $CI_COMMIT_SHORT_SHA
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: ""

# ---------- Job : build_image ----------
build_image:
  stage: build
  image: docker:27.0.3
  services:
    - docker:27.0.3-dind
  script:
    - echo "🐳 Build & tag de l'image"
    - docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY
    - docker build -t "$IMAGE_NAME:$IMAGE_TAG" -t "$IMAGE_NAME:latest" .
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

# ---------- Job : scan_image ----------
scan_image:
  stage: scan
  image: docker:24.0.6
  services:
    - docker:24.0.6-dind
  variables:
    DOCKER_HOST: tcp://docker:2375/
    DOCKER_TLS_CERTDIR: ""
  before_script:
    - apk add --no-cache curl bash
    # Installer Trivy dans /usr/local/bin pour qu'il soit globalement accessible
    - curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
    - docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY
  script:
    - echo "🐳 Build local image pour scan"
    - docker build -t $IMAGE_NAME:$IMAGE_TAG .
    - echo "🔍 Scanning image $IMAGE_NAME:$IMAGE_TAG avec Trivy"
    - trivy image --exit-code 0 --severity HIGH --no-progress $IMAGE_NAME:$IMAGE_TAG
  needs:
    - build_image
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

# ------------ Job scan kyverno ----------------
kyverno_validate:
  stage: scan   # ou "kyverno_validate" si tu veux un stage dédié
  image: alpine:latest
  before_script:
    - apk add --no-cache curl git bash tar openssl
    - curl -L https://github.com/kyverno/kyverno/releases/download/v1.11.0/kyverno-cli_v1.11.0_linux_x86_64.tar.gz -o kyverno.tar.gz
    - tar -xzf kyverno.tar.gz
    - mv kyverno /usr/local/bin/
    - curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    - git clone https://oauth2:${GITOPS_TOKEN}@github.com/username/SecureGitOpsLab.git
  script:
    - echo "📦 Rendu des templates Helm avec les valeurs de dev"
    - |
      helm template my-app \
        SecureGitOpsLab/argocd/helm-deploy/overlays/chart \
        -f SecureGitOpsLab/argocd/helm-deploy/overlays/dev/dev-values.yaml \
        > rendered.yaml
    - grep -q "kind:" rendered.yaml || (echo "❌ Aucun manifest détecté" && exit 1)
    - echo "🔍 Validation des manifests avec Kyverno"
    - |
      kyverno apply SecureGitOpsLab/kyverno-policies/kyverno-test-policy.yaml \
        --resource rendered.yaml \
        --namespace default

  needs:
    - scan_image
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'


# ---------- Template : deploy_gitops ----------
.deploy_template: &deploy_template
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache git curl
    - curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq
    - chmod +x /usr/local/bin/yq
  script:
    - echo "🚀 Déploiement GitOps vers $ENV"
    - git clone https://oauth2:${GITOPS_TOKEN}@github.com/username/SecureGitOpsLab.git
    - cd SecureGitOpsLab
    - yq -i ".image.tag = \"$IMAGE_TAG\"" argocd/helm-deploy/overlays/$ENV/$ENV-values.yaml
    - git config user.name "votre_user_name"
    - git config user.email "votre_email"
    - git commit -am "Update image to $IMAGE_NAME:$IMAGE_TAG for $ENV" || echo "No changes to commit"
    - git push

# ---------- Job : deploy_dev ----------
deploy_dev:
  <<: *deploy_template
  variables:
    ENV: dev
  needs:
    - scan_image
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

# ---------- Job : deploy_staging ----------
deploy_staging:
  <<: *deploy_template
  variables:
    ENV: staging
  needs:
    - deploy_dev
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

# ---------- Job : deploy_prod ----------
deploy_prod:
  <<: *deploy_template
  variables:
    ENV: prod
  needs:
    - deploy_staging
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'

```


---

## 🎯 Objectif

- Vérifier la conformité des manifests Kubernetes générés par Helm.
- Empêcher l’introduction de mauvaises pratiques dans les déploiements.
- Intégrer une validation automatisée **en amont du déploiement** (shift-left security).

---

## ⚙️ Intégration dans GitLab CI/CD

Un job dédié (`kyverno_validate`) est exécuté dans le pipeline GitLab pour :

1. Rendre les manifests Kubernetes avec Helm (selon l’environnement choisi).
2. Appliquer les policies Kyverno en local avec Kyverno CLI.
3. Stopper le pipeline si les règles ne sont pas respectées.

---

## 🔍 Étape Kyverno Validation dans le pipeline

### Définition du job

```yaml
# ------------ Job scan kyverno ----------------
kyverno_validate:
  stage: scan
  image: alpine:latest
  before_script:
    - apk add --no-cache curl git bash tar openssl
    - curl -L https://github.com/kyverno/kyverno/releases/download/v1.11.0/kyverno-cli_v1.11.0_linux_x86_64.tar.gz -o kyverno.tar.gz
    - tar -xzf kyverno.tar.gz
    - mv kyverno /usr/local/bin/
    - curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    - git clone https://oauth2:${GITOPS_TOKEN}@github.com/username/SecureGitOpsLab.git
  script:
    - echo "📦 Rendu des templates Helm avec les valeurs de dev"
    - |
      helm template my-app \
        SecureGitOpsLab/argocd/helm-deploy/overlays/chart \
        -f SecureGitOpsLab/argocd/helm-deploy/overlays/dev/dev-values.yaml \
        > rendered.yaml
    - grep -q "kind:" rendered.yaml || (echo "❌ Aucun manifest détecté" && exit 1)
    - echo "🔍 Validation des manifests avec Kyverno"
    - |
      kyverno apply SecureGitOpsLab/kyverno-policies/kyverno-test-policy.yaml \
        --resource rendered.yaml \
        --namespace default

  needs:
    - scan_image
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

Explications étape par étape
Image et outils installés

alpine:latest → image légère.

Installation de Kyverno CLI, Helm v3 et Git.

Clonage du repo GitOps

Récupération des charts Helm (helm-deploy/) et des policies (kyverno-policies/).

Rendu Helm

Génère les manifests Kubernetes avec helm template.

Vérifie qu’ils contiennent bien des ressources (grep "kind:").

Validation Kyverno

Applique les policies définies dans kyverno-policies/ sur le rendu.

Exemple : vérifier qu’un label app est présent sur chaque Pod.

Conditions d’exécution

Le job dépend de l’étape scan_image (Trivy).

Le job s’exécute uniquement sur la branche main.

🧪 Reproduction locale
Pour tester en local, exécuter :

```bash

# Générer les manifests avec Helm
helm template my-app ./helm-deploy/overlays/chart \
  -f ./helm-deploy/overlays/dev/dev-values.yaml > rendered.yaml

# Valider avec Kyverno
kyverno apply ./kyverno-policies/nodejs-basic-policy.yaml \
  --resource rendered.yaml --namespace default

```
✅ Bénéfices

Shift-left security : détection des problèmes tôt dans le cycle CI/CD.

Automatisation : aucune validation manuelle requise.

Conformité : s’assure que les déploiements respectent les règles fixées.

Reproductibilité : mêmes commandes utilisables en local et dans le pipeline.