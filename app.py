import dash
from dash import html
from dash.dependencies import Input, Output
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import signal
import sys

# Database setup
DATABASE_URL = "sqlite:///database.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

class Visit(Base):
    __tablename__ = "visits"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)

Base.metadata.create_all(bind=engine)

# Initialize Dash app
app = dash.Dash(__name__)
server = app.server  # WSGI callable for Gunicorn

app.layout = html.Div([
    html.H1("Hello Dash + SQLAlchemy + Docker + Gunicorn!"),
    html.Button("Add Visit", id="btn"),
    html.Div(id="output")
])

@app.callback(
    Output("output", "children"),
    Input("btn", "n_clicks")
)
def add_visit(n_clicks):
    session = SessionLocal()
    if n_clicks:
        session.add(Visit(name=f"Visitor {n_clicks}"))
        session.commit()
    count = session.query(Visit).count()
    session.close()
    return f"Total visits: {count}"

# Graceful shutdown for local runs (Gunicorn handles SIGTERM automatically)
def handle_sigint(signal_received, frame):
    print("SIGINT received, shutting down gracefully...")
    sys.exit(0)

signal.signal(signal.SIGINT, handle_sigint)

if __name__ == "__main__":
    app.run_server(host="0.0.0.0", port=8050)

