import main as app

def test_root_returns_hello_world():
    test_client = app.app.test_client()
    response = test_client.get("/")
    assert response.status_code == 200
    assert response.data.decode() == "Hello, World!"
