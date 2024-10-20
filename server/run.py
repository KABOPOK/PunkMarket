from app import create_app
app = create_app()

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0')
'''
 sudo docker run -p 9000:9000 -p 9001:9001 minio/minio server /data --console-address ":9001"
'''
