import os
from xmlrpc import client
import requests
import logging
import google.cloud.logging
import sqlalchemy
from flask import Flask
from google.cloud.sql.connector import Connector, IPTypes

app = Flask(__name__)
connector = Connector()


def get_db_connection():
    return connector.connect(
        os.environ["INSTANCE_CONNECTION_NAME"],
        "pg8000",
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        db=os.environ["DB_NAME"],
        ip_type=IPTypes.PRIVATE,
    )


# Create the engine globally to benefit from connection pooling
engine = sqlalchemy.create_engine("postgresql+pg8000://", creator=get_db_connection)


@app.route("/")
def init_and_run():
    # 1. Initialize the Cloud Logging client
    client_log = google.cloud.logging.Client()

    # 2. This attaches the Google Cloud handler to the standard Python logger
    client_log.setup_logging()

    # 3. Use standard logging as usual
    logging.info("ETL Pipeline started....")
    try:
        with engine.connect() as db_conn:
            # Ensure the table exists (DDL)
            db_conn.execute(
                sqlalchemy.text(
                    """CREATE TABLE IF NOT EXISTS chapters (
                        id SERIAL PRIMARY KEY, 
                        chapter_id TEXT UNIQUE, 
                        chapter_name TEXT, 
                        city TEXT, 
                        state TEXT, 
                        coordinates POINT
                    );"""
                )
            )
            logging.info("Fetching data from ArcGIS API for California chapters...")
            # Fetch data from the ArcGIS API (EXTRACT)
            api_url = "https://services2.arcgis.com/5I7u4SJE1vUr79JC/arcgis/rest/services/UniversityChapters_Public/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
            # params = {
            #     "where": "State = 'CA'",
            #     "outFields": "ChapterID,University_Chapter,City,State",
            #     "f": "json",
            #     "returnGeometry": "true",
            # }

            response = requests.get(api_url)  # , params=params)
            data = response.json()

            # Transform and Load data into Postgres (LOAD)
            count = 0
            logging.info("Transforming and Inserting data into Postgres...")
            for feature in data.get("features", []):
                attr = feature["attributes"]
                geom = feature["geometry"]

                # Prepare data for insertion
                # Note: coordinates are stored as a string POINT (x y) for Postgres
                point_str = f"({geom['x']}, {geom['y']})"

                upsert_query = sqlalchemy.text("""
                    INSERT INTO chapters (chapter_id, chapter_name, city, state, coordinates)
                    VALUES (:cid, :name, :city, :state, :coords)
                    ON CONFLICT (chapter_id) DO UPDATE SET
                        chapter_name = EXCLUDED.chapter_name,
                        city = EXCLUDED.city,
                        coordinates = EXCLUDED.coordinates;
                """)

                db_conn.execute(
                    upsert_query,
                    {
                        "cid": attr.get("ChapterID"),
                        "name": attr.get("University_Chapter"),
                        "city": attr.get("City"),
                        "state": attr.get("State"),
                        "coords": point_str,
                    },
                )
                count += 1

            db_conn.commit()
            db_conn.close()
            logging.info(f"Totally records processed: {count}")

        return f"Successfully processed {count} California chapters.", 200

    except Exception as e:
        print(f"Pipeline Error: {e}")
        logging.info(f"The pipeline has experienced an error: {str(e)}")
        return f"Pipeline Failed: {str(e)}", 500


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
