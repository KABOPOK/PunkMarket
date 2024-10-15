import os

from flask import Blueprint, request, jsonify, current_app
from werkzeug.utils import secure_filename

from ..db import connect_db
from app.utils import allowed_file

pushProduct_bp = Blueprint('pushProduct', __name__)

@pushProduct_bp.route('/create-product', methods=['POST'])
def create_product():
    data = request.get_json()

    # Extract the product data from the JSON
    productID = data.get('productID')
    price = data.get('price')
    title = data.get('title')
    owner_name = data.get('ownerName')
    location = data.get('location')
    description = data.get('description')
    category = data.get('category')
    userID = data.get('userID')

    if 'image' not in request.files:
        return jsonify({"error": "No image file in the request"}), 400

    image = request.files['image']

    if image and allowed_file(image.filename):
        filename = secure_filename(image.filename)
        image_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
        image.save(image_path)

        photoUrl = f"http://192.168.50.20:5000/uploads/{filename}"

        conn = connect_db()
        if conn is None:
            return jsonify({"error": "Database connection failed"}), 500

        cursor = conn.cursor()
        try:
            cursor.execute(
                "INSERT INTO products (productID, price, title, ownerName, photoUrl, location, description, category, userID) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
                    (productID, price, title, owner_name, photoUrl, location, description, category, userID)
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