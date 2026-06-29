from flask import Flask, jsonify, request

app = Flask(__name__) 

users = [
    {"id": 1, "name": "Boss", "email": "Boss@gmail.com"},
    {"id": 2, "name": "neBoss", "email": "neBoss@gmail.com"}
]
@app.route('/', methods=['GET'])
def index():
    return jsonify ({"message": "Hello, World!"})
@app.route ('/health', methods=['GET'])
def health():
    return jsonify ({"status": "ok"})
@app.route('/api/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = next((u for u in users if u['id'] == user_id), None)
    if user is None:
        return jsonify({"message": "User not found"}), 404
    return jsonify(user)
@app.route ('/api/users', methods=['GET'])
def get_users():
    return jsonify({"users": users})
@app.route('/api/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    global users
    user = next((u for u in users if u['id'] == user_id), None)
    if user is None:
        return jsonify({"error": "User not found"}), 404
    users = [u for u in users if u['id'] != user_id]
    return jsonify({"message": f"User {user_id} deleted"}), 200
@app.route ('/api/users', methods=['POST'])
def create_user():
    data = request.get_json() or {}
    if 'name' not in data or 'email' not in data:
        return jsonify({"error": "Missing required fields"}), 400
    new_id = max([u['id'] for u in users], default=0)+1
    new_user = {"id": new_id, "name":data['name'], "email": data['email']}
    users.append(new_user)
    return jsonify(new_user),201
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)