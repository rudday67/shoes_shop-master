import os
from flask import Blueprint, jsonify, request, send_file
from helper.db_helper import get_connection
from helper.form_validation import get_form_data

user_endpoints = Blueprint('user', __name__)
UPLOAD_FOLDER = "img"

def get_image_path(id_user):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT foto FROM user WHERE id_user = %s", (id_user,))
    result = cursor.fetchone()
    cursor.close()
    connection.close()
    return result[0] if result else None

@user_endpoints.route('/read', methods=['GET'])
def read():
    """Routes for module get list users"""
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    select_query = "SELECT * FROM user"
    cursor.execute(select_query)
    results = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify({"message": "OK", "datas": results}), 200

@user_endpoints.route('/photo/<int:id_user>', methods=['GET'])
def get_user_photo(id_user):
    """Route to get the user's photo by user ID"""
    try:
        image_path = get_image_path(id_user)
        
        if image_path and os.path.exists(image_path):
            return send_file(image_path, mimetype='image/jpeg')
        else:
            return jsonify({"err_message": "User not found or photo not available"}), 404

    except Exception as e:
        return jsonify({"message": "Failed to retrieve photo", "error": str(e)}), 500

@user_endpoints.route('/read_by_user', methods=['GET'])
def read_by_user():
    """Route to get user data based on id_user"""
    id_user = request.args.get('id_user')
    if not id_user:
        return jsonify({"message": "id_user is required"}), 400
    
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    select_query = "SELECT * FROM user WHERE id_user = %s"
    cursor.execute(select_query, (id_user,))
    results = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify({"message": "OK", "datas": results}), 200

@user_endpoints.route('/create', methods=['POST'])
def create():
    try:
        email = request.form['email']
        password = request.form['password']

        connection = get_connection()
        cursor = connection.cursor()

        insert_query = """
        INSERT INTO user (email, password) 
        VALUES (%s, %s)
        """
        insert_data = (email, password)

        cursor.execute(insert_query, insert_data)
        connection.commit()

        cursor.close()
        connection.close()

        return jsonify({
            "message": "Successfully Create Data"
        }), 200

    except Exception as e:
        return jsonify({
            "message": "Failed to Create Data!",
            "error": str(e)
        }), 500

@user_endpoints.route('/update/<int:id_user>', methods=['PUT'])
def update(id_user):
    connection = None
    cursor = None
    try:
        email = request.form['email']
        password = request.form['password']
        uploaded_file = request.files.get('file')

        connection = get_connection()
        cursor = connection.cursor()

        if uploaded_file and uploaded_file.filename != '':
            file_path = os.path.join(UPLOAD_FOLDER, uploaded_file.filename)
            uploaded_file.save(file_path)

            update_query = """
            UPDATE user 
            SET email = %s, password = %s, foto = %s
            WHERE id_user = %s
            """
            update_request = (email, password, file_path, id_user)
        else:
            update_query = """
            UPDATE user 
            SET email = %s, password = %s
            WHERE id_user = %s
            """
            update_request = (email, password, id_user)

        cursor.execute(update_query, update_request)
        connection.commit()

        return jsonify({"message": "Successfully updated data"}), 200

    except Exception as e:
        return jsonify({"message": "An unexpected error occurred", "error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()

@user_endpoints.route('/upload', methods=['POST'])
def upload():
    """Routes for upload file and update user photo"""
    if 'file' not in request.files or 'id_user' not in request.form:
        return jsonify({"err_message": "File or id_user is missing"}), 400

    uploaded_file = request.files['file']
    id_user = request.form['id_user']

    if uploaded_file.filename == '':
        return jsonify({"err_message": "No file selected"}), 400

    try:
        file_path = os.path.join(UPLOAD_FOLDER, uploaded_file.filename)
        uploaded_file.save(file_path)

        connection = get_connection()
        cursor = connection.cursor()
        update_query = "UPDATE user SET foto = %s WHERE id_user = %s"
        cursor.execute(update_query, (file_path, id_user))
        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({"message": "File uploaded successfully", "file_path": file_path}), 200

    except Exception as e:
        return jsonify({"message": "Failed to upload file", "error": str(e)}), 500
