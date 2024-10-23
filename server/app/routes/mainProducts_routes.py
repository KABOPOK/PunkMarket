from flask import Blueprint, request, jsonify
from ..db import connect_db
mainProducts_bp = Blueprint('main_products', __name__)

@mainProducts_bp.route('/main_products', methods=['GET'])
def get_main_products():
    # Pagination parameters
    page = request.args.get('page', default=1, type=int)
    limit = request.args.get('limit', default=20, type=int)

    # Connect to the database
    conn = connect_db()
    cursor = conn.cursor()

    # Calculate offset
    offset = (page - 1) * limit

    # SQL query to fetch products
    cursor.execute("SELECT productID, price, title, ownerName, photoUrl, location, description, category, userID FROM products ORDER BY productID LIMIT %s OFFSET %s",
                   (limit, offset))
    rows = cursor.fetchall()

    # Convert rows to a list of dictionaries
    products = []
    for row in rows:
        product = {
            "productID": row[0],
            "price": row[1],
            "title": row[2],
            "ownerName": row[3],
            "photoUrl": row[4],
            "location": row[5],
            "description": row[6],
            "category": row[7],
            "userID": row[8]
        }
        products.append(product)

    # Close the cursor and connection
    cursor.close()
    conn.close()

    return jsonify(products), 200

