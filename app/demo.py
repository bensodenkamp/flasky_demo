"""Module providingFunction Main App Entrypoint"""
from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello_world():
    """Handles the / route"""
    return "<p>Hello, World - Update 1</p>"
