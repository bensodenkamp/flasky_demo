"""Module providingFunction Dev WSGI"""
from demo import app

if __name__ == "__main__":
    app.run(host="0.0.0.0")
