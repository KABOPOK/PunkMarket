import psycopg2

def connect_db():
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="postgres",
            user="postgres",
            password="9"
        )
        return conn
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return None
