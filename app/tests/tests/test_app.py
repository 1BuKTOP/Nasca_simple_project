import pytest
from app.main import app as flask_app

@pytest.fixture 
def client ():
    flask_app.config ['TESTING'] = True
    with flask_app.test_client() as client:
        yield client

def test_index (client):
    response = client.get ('/')
    assert response.status_code == 200
    assert response.get_json () == {"message": "Hello, World!"}

def test_health (client):
    response = client.get ('/health')
    assert response.status_code == 200
    assert response.get_json () == {"status": "ok"}

def test_get_users (client):
    response = client.get ('/api/users')
    assert response.status_code == 200
    data = response.get_json()
    assert "users" in data
    assert len(data["users"]) == 2

def test_post_user (client):
    new_user_data = {"name": "Banek", "email": "ningo332@mail.ru"}
    response = client.post ('/api/users', json = new_user_data)
    assert response.status_code == 201
    data = response.get_json()
    assert data ["name"] == "Banek"
    assert "id" in data

def test_create_user_validation_error (client):
    invalid_user_data = {"name": "Ghost"}
    response = client.post ('api/users', json = invalid_user_data)
    assert response.status_code == 400
    assert response.get_json() == {"error": "Missing required fields"}