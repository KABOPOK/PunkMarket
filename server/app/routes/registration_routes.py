from flask import Blueprint, request, jsonify
from sqlalchemy import nullsfirst
from werkzeug.utils import secure_filename
import os
from ..db import connect_db
from ..utils import allowed_file
from flask import current_app
from ..MinIO import minio_client,bucket_name
from io import BytesIO

registration_bp = Blueprint('registration', __name__)

@registration_bp.route('/create-user', methods=['POST'])
def create_user():
    data = request.form
    userID = data.get('userID')  # Assuming this is also part of the incoming JSON
    number = data.get('number')
    password = data.get('password')
    user_name = data.get('userName')
    location = data.get('location')
    telegramID = data.get('telegramID')
    image = nullsfirst
    if 'image' not in request.files:
        image = 'null'
        photoUrl = 'null'
    else:
        image = request.files['image']

    if image and image != 'null' and allowed_file(image.filename):
        # filename = secure_filename(image.filename)
        # image_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
        # image.save(image_path)
        # photoUrl = f"http://192.168.50.20:5000/uploads/{filename}"
        filename = secure_filename(image.filename)
        image_bytes = BytesIO(image.read())  # Read image into memory

        # Upload directly to MinIO from memory
        minio_client.put_object(
            bucket_name,
            filename,
            image_bytes,
            length=image_bytes.getbuffer().nbytes,
            content_type=image.content_type
        )

        # Generate public URL for the uploaded image
        photoUrl = f"http://localhost:9000/{bucket_name}/{filename}"

    conn = connect_db()
    if conn is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = conn.cursor()
    try:
        cursor.execute(
            "INSERT INTO users (userID, number,password,  username, photoUrl, location, telegramID ) VALUES (%s, %s, %s, %s, %s, %s, %s)",
            (userID, number, password, user_name, photoUrl, location, telegramID)
        )
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 400
    finally:
        cursor.close()
        conn.close()

    return jsonify({"message": "User created successfully!", "photoUrl": photoUrl})

    return jsonify({"error": "Invalid image format"}), 400
