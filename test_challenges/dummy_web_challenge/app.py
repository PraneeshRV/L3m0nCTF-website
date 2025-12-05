from flask import Flask, render_template, request
import os

app = Flask(__name__)

# Dynamic flag support - reads from environment variable
# CTFd's docker_challenges plugin injects FLAG=L3m0n{random} when FLAG=DYNAMIC is set
FLAG = os.environ.get('FLAG', 'L3m0n{dummy_ch4ll3ng3_1nfr4_t3st_succ3ss!}')
SECRET_PATH = "/s3cr3t_l3m0n_p4th"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/robots.txt')
def robots():
    return f"""User-agent: *
Disallow: {SECRET_PATH}
# Nothing to see here... or is there? 🍋
"""

@app.route(SECRET_PATH)
def secret():
    return render_template('secret.html', flag=FLAG)

@app.route('/hint')
def hint():
    return """
    <html>
    <head><title>Hint</title></head>
    <body style="background: #1a1a2e; color: #e0e0e0; font-family: monospace; padding: 40px;">
        <h1 style="color: #f7dc6f;">🍋 Hint</h1>
        <p>Every good hacker checks what the robots say...</p>
        <p><a href="/" style="color: #f7dc6f;">Back to home</a></p>
    </body>
    </html>
    """

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
