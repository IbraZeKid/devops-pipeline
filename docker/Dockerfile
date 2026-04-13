# ════════════════════════════════════════════════════════
# ÉTAPE 1 : BUILDER
# Cette étape installe tout, lance les tests.
# Elle ne sera PAS dans l'image finale.
# ════════════════════════════════════════════════════════
 
# On part d'une image Python officielle légère (slim = sans extras)
# 'AS builder' = on nomme cette étape 'builder'
FROM python:3.11-slim AS builder
 
# On définit le dossier de travail dans le container
WORKDIR /app
 
# On copie UNIQUEMENT requirements.txt en premier.
# Pourquoi ? Docker cache chaque étape. Si requirements.txt
# n'a pas changé, Docker réutilise le cache → build plus rapide.
COPY app/requirements.txt .
 
# On installe les dépendances Python
# --no-cache-dir = ne pas garder le cache pip (réduit la taille)
RUN pip install --no-cache-dir -r requirements.txt
 
# On copie le reste du code de l'app
COPY app/ .
 
# On lance les tests. Si un test échoue, le build échoue.
# C'est intentionnel : on ne déploie JAMAIS du code cassé.
RUN python -m pytest tests/ -v
 
# ════════════════════════════════════════════════════════
# ÉTAPE 2 : PRODUCTION
# Image finale légère, sans les outils de dev ni les tests.
# ════════════════════════════════════════════════════════
 
FROM python:3.11-slim AS production
 
WORKDIR /app
 
# On copie UNIQUEMENT ce qui vient de l'étape 'builder'
# --from=builder = depuis l'étape précédente
COPY --from=builder /app/main.py .
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
 
# On documente le port que l'app utilise (informatif, ne suffit pas)
EXPOSE 5000
 
# Variable d'environnement : mode production (désactive le debug)
ENV FLASK_ENV=production
ENV APP_VERSION=1.0.0
 
# Commande lancée quand le container démarre
CMD ["python", "main.py"]
