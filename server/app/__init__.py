from flask import Flask
import os
from .routes import registration_bp, image_bp, login_bp

def create_app():
    app = Flask(__name__)

    # Configuration for the app
    UPLOAD_FOLDER = r'C:\\server_punk_\\uploads'
    app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

    # Register Blueprints
    app.register_blueprint(registration_bp)
    app.register_blueprint(login_bp)
    app.register_blueprint(image_bp)

    return app
