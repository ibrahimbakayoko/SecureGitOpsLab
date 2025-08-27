# 🔐 SecureGitOpsLab

🚀 Projet GitOps sécurisé et observable de bout en bout, dans le cadre de mon parcours #DevOpsOpenJourney.

<img src="./Docs/securegitopslab-illustration.png" alt="SecureGitOpsLab Architecture" style="width:100%;"/>

---

## 🎯 Objectif

Déployer une architecture Kubernetes complète, automatisée et sécurisée avec :

- ✅ **GitOps avec ArgoCD**
- ✅ **Sécurité DevSecOps intégrée (Trivy, Kyverno, Cosign, SBOM)**
- ✅ **Observabilité avancée (Prometheus, Grafana, Loki, Alerting)**
- ✅ **Packaging Helm & Kustomize pour multi-environnement**
- ✅ **Automatisation via CI/CD**

---

## 🗂️ Structure du projet

| Dossier         | Contenu |
|----------------|---------|
| `/terraform`   | Déploiement d’infrastructure cloud (EKS) ou local |
| `/argocd`      | Manifests App of Apps & bootstrap GitOps |
| `/kustomize`   | Manifests Kubernetes avec `base` et `overlays` |
| `/helm-charts` | Charts Helm utilisés ou personnalisés |
| `/security`    | Scans Trivy, policies Kyverno, signature Cosign |
| `/observability` | Stack Prometheus / Grafana / Loki |
| `/ci-cd`       | Pipelines GitLab CI ou GitHub Actions |
| `/docs`        | Diagrammes, captures d’écran, README |

---

## 🧱 Technologies

- 🛠️ Terraform, Ansible (infra + provision)
- ☸️ Kubernetes (K3d local / EKS cloud)
- 🎯 ArgoCD (GitOps)
- 🔐 Trivy, Kyverno, Cosign, SBOM
- 📈 Prometheus, Grafana, Loki
- 📦 Helm & Kustomize
- 🔁 GitLab CI ou GitHub Actions

---

## 📌 Continuité de #DevOpsOpenJourney

Ce projet est la **suite directe** du projet [#DevOpsOpenJourney]([https://github.com/ton-projet-aws](https://github.com/ibrahimbakayoko/aws-devops-journey.git)), où j’ai automatisé l’infrastructure cloud avec **Terraform + Ansible**.

---

🙌 Auteur
Développé par brahima Bakayoko
📬 Contributions, retours et échanges bienvenus !
