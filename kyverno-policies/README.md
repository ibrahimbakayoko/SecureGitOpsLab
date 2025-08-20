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
    - git clone https://oauth2:${GITOPS_TOKEN}@github.com/ibrahimbakayoko/SecureGitOpsLab.git
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