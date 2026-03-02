import os
import sqlalchemy
from flask import Flask
from google.cloud.sql.connector import Connector, IPTypes

# Initialize Flask and the Connector
app = Flask(__name__)
connector = Connector()


def get_db_connection():
    # The variables below are set in the Cloud Run environment variables and
    # passed to the container in Terraform
    conn = connector.connect(
        os.environ["INSTANCE_CONNECTION_NAME"],
        "pg8000",
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        db=os.environ["DB_NAME"],
        ip_type=IPTypes.PRIVATE,  # uses Private IP for VPC
    )
    return conn


# Define a route. When you visit the Cloud Run URL, this code runs.
@app.route("/")
def start_db():
    try:
        engine = sqlalchemy.create_engine(
            "postgresql+pg8000://",
            creator=get_db_connection,
        )

        with engine.connect() as db_conn:
            db_conn.execute(
                sqlalchemy.text(
                    """CREATE TABLE IF NOT EXISTS chapters (
                        id SERIAL PRIMARY KEY, 
                        chapter_id TEXT, 
                        chapter_name TEXT, 
                        city TEXT, 
                        state TEXT, 
                        coordinates POINT
                    );"""
                )
            )
            db_conn.commit()
        return (
            "Successfully connected to Private Cloud SQL and ensured table exists!",
            200,
        )
    except Exception as e:
        print(f"Error: {e}")
        return f"Database Connection Failed: {str(e)}", 500


if __name__ == "__main__":
    # Keeps the container alive on port 8080
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
