import os
from flask import Blueprint, jsonify, request, send_file
from werkzeug.utils import secure_filename
from helper.db_helper import get_connection

produk_endpoints = Blueprint('produk', __name__)
UPLOAD_FOLDER = "img"
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def get_image_path(id_user):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT foto FROM user WHERE id_user = %s", (id_user,))
    result = cursor.fetchone()
    cursor.close()
    connection.close()
    return result[0] if result else None

@produk_endpoints.route('/read', methods=['GET'])
def read():
    """Route untuk mendapatkan daftar produk"""
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    select_query = "SELECT * FROM produk"
    cursor.execute(select_query)
    results = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify({"message": "OK", "datas": results}), 200

@produk_endpoints.route('/read/<int:id_produk>', methods=['GET'])
def read_by_id(id_produk):
    """Route untuk mendapatkan produk berdasarkan id_produk"""
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    select_query = "SELECT * FROM produk WHERE id_produk = %s"
    cursor.execute(select_query, (id_produk,))
    result = cursor.fetchone()
    cursor.close()
    connection.close()
    if result:
        return jsonify({"message": "OK", "data": result}), 200
    else:
        return jsonify({"message": "Data tidak ditemukan"}), 404

@produk_endpoints.route('/create', methods=['POST'])
def create():
    try:
        nama_produk = request.form['nama_produk']
        harga = request.form['harga']
        if 'gambar' not in request.files:
            return jsonify({"message": "Gambar diperlukan"}), 400
        file = request.files['gambar']
        if file.filename == '':
            return jsonify({"message": "Tidak ada file yang dipilih"}), 400
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file_path = os.path.join(UPLOAD_FOLDER, filename)
            file.save(file_path)

            connection = get_connection()
            cursor = connection.cursor()
            insert_query = """
                INSERT INTO produk (nama_produk, harga, gambar) 
                VALUES (%s, %s, %s)
            """
            insert_request = (nama_produk, harga, file_path)
            cursor.execute(insert_query, insert_request)
            connection.commit()
            cursor.close()
            connection.close()
            return jsonify({"message": "Berhasil membuat data"}), 200
        else:
            return jsonify({"message": "File tidak diizinkan"}), 400
    except Exception as e:
        return jsonify({"message": "Gagal membuat data!", "error": str(e)}), 500

@produk_endpoints.route('/update/<int:id_produk>', methods=['PUT'])
def update(id_produk):
    try:
        nama_produk = request.form['nama_produk']
        harga = request.form['harga']
        file_path = None
        if 'gambar' in request.files:
            file = request.files['gambar']
            if file.filename != '' and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                file_path = os.path.join(UPLOAD_FOLDER, filename)
                file.save(file_path)

        connection = get_connection()
        cursor = connection.cursor()
        if file_path:
            update_query = """
                UPDATE produk 
                SET nama_produk = %s, harga = %s, gambar = %s
                WHERE id_produk = %s
            """
            update_request = (nama_produk, harga, file_path, id_produk)
        else:
            update_query = """
                UPDATE produk 
                SET nama_produk = %s, harga = %s
                WHERE id_produk = %s
            """
            update_request = (nama_produk, harga, id_produk)
        cursor.execute(update_query, update_request)
        connection.commit()
        cursor.close()
        connection.close()
        return jsonify({"message": "Berhasil memperbarui data"}), 200
    except Exception as e:
        return jsonify({"message": "Terjadi kesalahan yang tidak terduga", "error": str(e)}), 500

@produk_endpoints.route('/delete/<int:id_produk>', methods=['DELETE'])
def delete(id_produk):
    try:
        connection = get_connection()
        cursor = connection.cursor()
        delete_query = "DELETE FROM produk WHERE id_produk = %s"
        cursor.execute(delete_query, (id_produk,))
        connection.commit()
        cursor.close()
        connection.close()
        if cursor.rowcount == 0:
            return jsonify({"message": "Data tidak ditemukan"}), 404
        return jsonify({"message": "Berhasil menghapus data"}), 200
    except Exception as e:
        return jsonify({"message": "Terjadi kesalahan yang tidak terduga", "error": str(e)}), 500

@produk_endpoints.route('/photo/<int:id_user>', methods=['GET'])
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

@produk_endpoints.route('/upload', methods=['POST'])
def upload():
    """Routes for upload file and update user photo"""
    if 'file' not in request.files or 'id_user' not in request.form:
        return jsonify({"err_message": "File or id_user is missing"}), 400

    uploaded_file = request.files['file']
    id_user = request.form['id_user']

    if uploaded_file.filename == '':
        return jsonify({"err_message": "No file selected"}), 400

    try:
        filename = secure_filename(uploaded_file.filename)
        file_path = os.path.join(UPLOAD_FOLDER, filename)
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
