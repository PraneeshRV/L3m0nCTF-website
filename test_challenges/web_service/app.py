from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "L3m0n{web_service_is_working}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
