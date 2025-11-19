import os
from dotenv import load_dotenv
import psycopg2
from psycopg2.extras import RealDictCursor

load_dotenv()

DB_USER = os.getenv("POSTGRES_USER", "postgres")
DB_PASS = os.getenv("POSTGRES_PASSWORD", "senha")
DB_NAME = os.getenv("POSTGRES_DB", "postgres")
DB_HOST = os.getenv("POSTGRES_HOST", "localhost")
DB_PORT = int(os.getenv("POSTGRES_PORT_EXTERNAL", 64321))

def get_connection():
    return psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        host=DB_HOST,
        port=DB_PORT
    )

def query_all(sql, params=None):
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(sql, params or ())
            return cur.fetchall()

def main():
    sql = "SELECT * FROM pessoa;"
    print(f"Tentando conectar em {DB_HOST}:{DB_PORT} como {DB_USER} (db={DB_NAME})")
    try:
        rows = query_all(sql)
        for r in rows:
            print(r)
    except Exception as e:
        print("Falha na consulta:", e)


if __name__ == "__main__":
    main()