from flask import Flask, g
import sqlite3
import os

app = Flask(__name__)
DB_PATH = os.path.join(os.path.dirname(__file__), "db", "app.db")

def get_db():
    if "db" not in g:
        g.db = sqlite3.connect(DB_PATH)
        g.db.row_factory = sqlite3.Row
    return g.db

@app.teardown_appcontext
def close_db(exception):
    db = g.pop("db", None)
    if db is not None:
        db.close()

@app.route("/")
def index():
    db = get_db()
    db.execute("CREATE TABLE IF NOT EXISTS visits (count INTEGER)")
    row = db.execute("SELECT count FROM visits").fetchone()
    if row:
        count = row["count"] + 1
        db.execute("UPDATE visits SET count=?", (count,))
    else:
        count = 1
        db.execute("INSERT INTO visits (count) VALUES (?)", (count,))
    db.commit()
    return f"Hello! Visit count: {count}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

