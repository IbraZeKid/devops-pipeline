# On importe pytest, le framework de tests Python
import pytest
 
# On importe notre application Flask
from main import app
 
# 'fixture' = objet réutilisable dans plusieurs tests.
# Ici on crée un 'client de test' qui peut faire des requêtes HTTP
# sans avoir à démarrer un vrai serveur.
@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client
 
# Test 1 : la route principale répond-elle correctement ?
def test_home_returns_200(client):
    response = client.get('/')
    # On vérifie que le code HTTP est 200 (succès)
    assert response.status_code == 200
    # On vérifie que la réponse contient bien 'ok'
    data = response.get_json()
    assert data['status'] == 'ok'
 
# Test 2 : la route /health répond-elle ?
def test_health_returns_healthy(client):
    response = client.get('/health')
    assert response.status_code == 200
    data = response.get_json()
    # On vérifie que 'healthy' est bien True
    assert data['healthy'] == True
 
# Test 3 : les routes inexistantes retournent-elles 404 ?
def test_unknown_route_returns_404(client):
    response = client.get('/route-qui-nexiste-pas')
    assert response.status_code == 404
