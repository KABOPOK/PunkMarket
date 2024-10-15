from flask import Blueprint, request, jsonify
from werkzeug.utils import secure_filename
import os
from ..db import connect_db
from ..utils import allowed_file
from flask import current_app
login_bp = Blueprint('login', __name__)

@login_bp.route('/login_user', methods=['POST'])
def login_user():
    data = request.get_json()
    number = data.get('number')
    password = data.get('password')

    if not number or not password:
        return jsonify({'message': 'Missing number or password'}), 400

    conn = connect_db()
    cur = conn.cursor()

    try:
        # Check if user exists
        cur.execute("SELECT * FROM users WHERE number = %s", (number,))
        user = cur.fetchone()

        if user:
            # Verify password
            if(user[2] == password):
                user_data = {
                    'userID': user[0],  # Assuming userID is in the first column
                    'number': user[1],  # Assuming number is in the second column
                    'userName': user[3],  # Adjust indices based on your schema
                    'photoUrl': user[4],
                    'location': user[5],
                    'telegram': user[6],
                }
                return jsonify(user_data), 200
            else:
                return jsonify({'message': 'Incorrect password'}), 401
        else:
            return jsonify({'user_exists': False}), 405

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cur.close()
        conn.close()
