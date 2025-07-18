from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# In-memory storage for servers
servers = []

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        name = request.form['name']
        ip = request.form['ip']
        server = {'name': name, 'ip': ip}
        servers.append(server)
        return redirect(url_for('index'))
    return render_template('index.html', servers=servers)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True) # Had to add host="0.0.0.0" to be able to lauch it from the docker container
