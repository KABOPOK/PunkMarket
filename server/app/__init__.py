from flask import Flask
import os
from .routes import registration_bp, image_bp, login_bp, pushProduct_bp
from .migration import create_table
from .db import connect_db
def create_app():
    app = Flask(__name__)
    create_table(app)
    # Configuration for the app
    if os.name == 'nt':  # Windows
        UPLOAD_FOLDER = r'C:\\server_punk_\\uploads'
    else:  # Assuming Unix-based OS (like Ubuntu)
        UPLOAD_FOLDER = '/home/kabopok/repositories/PunkMarket/server/uploads'
    app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

    # Register Blueprints
    app.register_blueprint(registration_bp)
    app.register_blueprint(login_bp)
    app.register_blueprint(image_bp)
    app.register_blueprint(pushProduct_bp)

    return app
