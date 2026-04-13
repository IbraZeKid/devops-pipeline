# 🚀 DevOps Pipeline — Flask App

![CI/CD Pipeline](https://github.com/IbraZeKid/devops-pipeline/actions/workflows/ci-cd.yml/badge.svg)
![Docker Image](https://img.shields.io/docker/v/ibrazekid/flask-devops-app?label=Docker%20Hub&color=0db7ed)
![Python](https://img.shields.io/badge/Python-3.11-blue)
![License](https://img.shields.io/badge/license-MIT-green)

Pipeline CI/CD complet déployant une application Python Flask via GitHub Actions.
Du commit au déploiement automatique, avec scan de sécurité et monitoring intégré.

---

## Architecture
GitHub Push
│
▼
GitHub Actions
├── 1. Tests (pytest + flake8)        ✅
├── 2. Scan sécurité (Trivy CVE)      ✅
├── 3. Build image Docker multi-stage ✅
└── 4. Push Docker Hub                ✅
Stack de production (Docker Compose)
├── Nginx          → Reverse proxy (port 80)
├── Flask App      → API Python (port 5000, interne)
├── PostgreSQL     → Base de données
├── Prometheus     → Collecte des métriques
└── Grafana        → Dashboard monitoring (port 3000)

---

## Stack technique

| Couche | Technologie | Pourquoi ce choix |
|--------|-------------|-------------------|
| CI/CD | GitHub Actions | Intégré à GitHub, gratuit, YAML déclaratif |
| Qualité | pytest + flake8 | Tests unitaires + lint avant tout merge |
| Sécurité | Trivy (Aqua Security) | Scan CVE sur l'image Docker à chaque build |
| Build | Docker multi-stage | Image prod ~120MB au lieu de ~800MB |
| Registry | Docker Hub | Standard industrie, intégration CI native |
| IaC | Terraform + Ansible | Infrastructure et configuration as code |
| Monitoring | Prometheus + Grafana | Stack observabilité production standard |

---

## Lancer en local

```bash
# Prérequis : Docker Desktop installé

git clone https://github.com/IbraZeKid/devops-pipeline.git
cd devops-pipeline

docker compose up --build

# Accès :
# App        → http://localhost
# Grafana    → http://localhost:3000  (admin/admin)
# Prometheus → http://localhost:9090
```

---

## Commandes

```bash
make help      # Voir toutes les commandes disponibles
make test      # Lancer les tests pytest localement
make build     # Construire l'image Docker
make scan      # Scanner les vulnérabilités avec Trivy
make clean     # Nettoyer l'environnement local
```

---

## Pipeline CI/CD — Fonctionnement

Chaque push sur `main` déclenche automatiquement :

1. **Tests & Lint** — pytest + flake8 — si un test échoue, le pipeline s'arrête
2. **Scan sécurité** — Trivy analyse l'image Docker et rapporte les CVE HIGH/CRITICAL
3. **Build & Push** — Image taguée avec le SHA du commit et poussée sur Docker Hub
4. **Deploy** *(en cours)* — Déploiement automatique sur VPS via SSH

---

## État du projet

### ✅ Phase 1 — Pipeline CI/CD (terminée)
- [x] Application Flask avec endpoints `/`, `/health`, `/metrics`
- [x] Tests unitaires pytest (3 tests)
- [x] Dockerfile multi-stage (image prod légère)
- [x] Docker Compose complet (Flask + Nginx + PostgreSQL + Prometheus + Grafana)
- [x] Pipeline GitHub Actions (tests + scan Trivy + build + push Docker Hub)
- [x] Infrastructure as Code (Terraform + Ansible — prêt à déployer)
- [x] Makefile pour unifier les commandes

### 🔄 Phase 2 — Kubernetes (à venir)
- [ ] Manifestes Kubernetes (Deployment, Service, Ingress)
- [ ] Horizontal Pod Autoscaler (HPA)
- [ ] ConfigMap et Secrets K8s
- [ ] Déploiement sur cluster (kind local ou EKS Free Tier)
- [ ] Pipeline GitOps avec ArgoCD

### 📋 Phase 3 — Cloud AWS avec Terraform (à venir)
- [ ] VPC, subnets publics/privés
- [ ] EC2 + Auto Scaling Group
- [ ] RDS PostgreSQL managé
- [ ] Application Load Balancer
- [ ] State Terraform distant (S3 + DynamoDB lock)
- [ ] Workspaces Terraform (dev / prod)
- [ ] Certification AWS Solutions Architect Associate

---

## Structure du projet
devops-pipeline/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # Pipeline GitHub Actions
├── app/
│   ├── main.py                # Application Flask
│   ├── requirements.txt
│   └── tests/
│       └── test_main.py       # Tests pytest
├── docker/
│   ├── Dockerfile             # Multi-stage build
│   └── nginx.conf             # Reverse proxy
├── infra/
│   ├── terraform/
│   │   └── main.tf            # Provision VPS Oracle/AWS
│   └── ansible/
│       ├── playbook.yml       # Configuration serveur
│       └── inventory.ini
├── monitoring/
│   └── prometheus.yml         # Config scraping métriques
├── docker-compose.yml         # Stack locale dev
├── docker-compose.prod.yml    # Stack production
└── Makefile                   # Commandes unifiées

---

## Auteur

**Ibrahim Amadou DICKO**
Alternant DevOps/Cloud — Recherche alternance à partir d'octobre 2026
Rythme : 3 semaines entreprise / 1 semaine école

[![LinkedIn](https://img.shields.io/badge/LinkedIn-ia--dicko-0077B5?logo=linkedin)](https://www.linkedin.com/in/ia-dicko/)
[![Email](https://img.shields.io/badge/Email-ibrahimdicko006%40gmail.com-D14836?logo=gmail)](mailto:ibrahimdicko006@gmail.com)