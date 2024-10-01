from flask import Blueprint, request, jsonify
from werkzeug.utils import secure_filename
import os
from ..db import connect_db
from ..utils import allowed_file
from flask import current_app

registration_bp = Blueprint('registration', __name__)

@registration_bp.route('/create-user', methods=['POST'])
def create_user():
    data = request.form
    name = data.get('name')
    password = data.get('password')
    number = data.get('number')
    telegram = data.get('telegram')

    if 'image' not in request.files:
        return jsonify({"error": "No image file in the request"}), 400

    image = request.files['image']

    if image and allowed_file(image.filename):
        filename = secure_filename(image.filename)
        image_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
        image.save(image_path)

        image_url = f"http://192.168.50.20:5000/uploads/{filename}"

        conn = connect_db()
        if conn is None:
            return jsonify({"error": "Database connection failed"}), 500

        cursor = conn.cursor()
        try:
            cursor.execute(
                "INSERT INTO users (name, password, number, telegram, image_url) VALUES (%s, %s, %s, %s, %s)",
                (name, password, number, telegram, image_url)
            )
            conn.commit()
        except Exception as e:
            conn.rollback()
            return jsonify({"error": str(e)}), 400
        finally:
            cursor.close()
            conn.close()

        return jsonify({"message": "User created successfully!", "image_url": image_url})

    return jsonify({"error": "Invalid image format"}), 400
