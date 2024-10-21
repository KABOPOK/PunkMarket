import os
from io import BytesIO
from flask import Blueprint, request, jsonify, current_app
from uuid import uuid4
from werkzeug.utils import secure_filename
from ..MinIO import minio_client, bucket_name
from ..db import connect_db
from app.utils import allowed_file
import json

pushProduct_bp = Blueprint('pushProduct', __name__)

@pushProduct_bp.route('/create-product', methods=['POST'])
def create_product():
    try:
        product_data = request.form.get('product')
        product = json.loads(product_data)
    except (TypeError, json.JSONDecodeError) as e:
        return jsonify({"error": "Invalid JSON data"}), 400

        # Extract individual fields from the product object
    productID = uuid4()
    price = float(product.get('price', 0))  # Convert price to float, default to 0
    title = product.get('title', '').strip()
    owner_name = product.get('ownerName', '').strip()
    location = product.get('location', '').strip()
    description = product.get('description', '').strip()
    category = product.get('category', '').strip()
    userID = product.get('userID', None)

    images = request.files.getlist('images[]')
    image_urls = []
    if not images:
        image_urls = ['null']  # Placeholder if no images are provided
    else:
        for image in images:
            if image and allowed_file(image.filename):
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
                image_urls.append(photoUrl)

    # Join all image URLs with '&'
    photoUrl = '&'.join(image_urls)
    conn = connect_db()
    if conn is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = conn.cursor()
    try:
        # Convert the list of image URLs to a JSON string to store in the database
        cursor.execute(
            "INSERT INTO products (productID, price, title, ownerName, photoUrl, location, description, category, userID) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
            (productID, price, title, owner_name, photoUrl, location, description, category, userID)
        )
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 400
    finally:
        cursor.close()
        conn.close()

    return jsonify({"message": "Product created successfully!", "photoUrls": image_urls})
