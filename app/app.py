from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data/servers.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Server(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    ip = db.Column(db.String(80), nullable=False)

@app.before_first_request
def create_tables():
    db.create_all()

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        name = request.form['name']
        ip = request.form['ip']
        server = Server(name=name, ip=ip)
        db.session.add(server)
        db.session.commit()
        return redirect(url_for('index'))
    servers = Server.query.all()
    return render_template('index.html', servers=servers)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True) # Had to add host="0.0.0.0" to be able to lauch it from the docker container
