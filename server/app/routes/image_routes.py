from flask import Blueprint, send_from_directory, request

image_bp = Blueprint('image', __name__)

@image_bp.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(request.app.config['UPLOAD_FOLDER'], filename)
