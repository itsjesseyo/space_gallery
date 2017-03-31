from flask import Flask
from flask import request
from flask import render_template
from flask import jsonify
import os
import json
from flask import Flask, request, redirect, url_for
from werkzeug.utils import secure_filename
from flask_sqlalchemy import SQLAlchemy
from flask import send_from_directory
import random, string

UPLOAD_FOLDER = 'uploaded_files'
ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

app = Flask(__name__)
app.config['DEBUG'] = True
app.config['host'] = '0.0.0.0'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test.db'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
db = SQLAlchemy(app)


class Room(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String(128))
	price = db.Column(db.Integer)
	feet = db.Column(db.Integer)
	images = db.relationship('Image', backref='room', lazy='dynamic')
	panos = db.relationship('Pano', backref='room', lazy='dynamic')

	def __repr__(self):
		return 'Room'

	@property
	def serialize(self):
		return{
			'id':self.id,
			'name':self.name,
			'price':self.price,
			'feet':self.feet
		}

class Image(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	filename = db.Column(db.String(128))
	room_id = db.Column(db.Integer, db.ForeignKey('room.id'))

	def __init__(self, filename):
		self.filename = filename

	def __repr__(self):
		return '<Slide %r>' % self.filename

	@property
	def serialize(self):
		return{
			'id':self.id,
			'filename':self.filename
		}


class Pano(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	filename = db.Column(db.String(128))
	room_id = db.Column(db.Integer, db.ForeignKey('room.id'))

	def __init__(self, filename):
		self.filename = filename

	def __repr__(self):
		return '<Slide %r>' % self.filename

	@property
	def serialize(self):
		return{
			'id':self.id,
			'filename':self.filename
		}

@app.route("/")
def index():
	return render_template('index.html')

@app.route("/admin")
def admin():
	return render_template('admin.html')

@app.route('/upload_image',methods=['GET', 'POST', 'OPTIONS'])
def upload_image():
	print request.method
	if request.method == 'POST':
		# check if the post request has the file part
		if 'file' not in request.files:
			print 'no files to upload'
			return redirect(request.url)
		file = request.files['file']
		room_id = request.form['room_id']
		print('fsds:'+room_id)
		# if user does not select file, browser also
		# submit a empty part without filename
		if file.filename == '':
			flash('No selected file')
			return redirect(request.url)
		if file and allowed_file(file.filename):
			filename = secure_filename(file.filename)
			#we'll dumbly add a hash if this file already exists
			if os.path.isfile( os.path.join(app.config['UPLOAD_FOLDER'], filename) ):
				print "EXISTS!"
				name_fragments = filename.rsplit('.', 1)
				name_fragments[0] = name_fragments[0].replace('.', '')
				name_fragments[1] = '.' + name_fragments[1]
				name_fragments[0] = name_fragments[0] + '_' + randomword(8) 
				filename = ''.join(name_fragments)

			file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
			new_slide = Image(filename)
			new_slide.room_id = room_id
			db.session.add(new_slide)
			db.session.commit()
			return redirect(url_for('admin'), code=303)
			
	#if GET
	return render_template('edit_slides.html')

@app.route('/upload_pano',methods=['GET', 'POST', 'OPTIONS'])
def upload_pano():
	print request.method
	if request.method == 'POST':
		# check if the post request has the file part
		if 'file' not in request.files:
			print 'no files to upload'
			return redirect(request.url)
		file = request.files['file']
		room_id = request.form['room_id']
		print('fsds:'+room_id)
		# if user does not select file, browser also
		# submit a empty part without filename
		if file.filename == '':
			flash('No selected file')
			return redirect(request.url)
		if file and allowed_file(file.filename):
			filename = secure_filename(file.filename)
			#we'll dumbly add a hash if this file already exists
			if os.path.isfile( os.path.join(app.config['UPLOAD_FOLDER'], filename) ):
				print "EXISTS!"
				name_fragments = filename.rsplit('.', 1)
				name_fragments[0] = name_fragments[0].replace('.', '')
				name_fragments[1] = '.' + name_fragments[1]
				name_fragments[0] = name_fragments[0] + '_' + randomword(8) 
				filename = ''.join(name_fragments)

			file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
			new_slide = Pano(filename)
			new_slide.room_id = room_id
			db.session.add(new_slide)
			db.session.commit()
			return redirect(url_for('admin'), code=303)
			
	#if GET
	return render_template('edit_slides.html')

@app.route('/api/<version>/get/<data_set>')
def api_get(version, data_set):
	if version is None:
		return jsonify(
			{status:"invalid_api_version"})
	if data_set is None:
		return jsonify({
			'status':'invalid_data_set'
			})
	#ROOMS
	if data_set == 'rooms':
		stats = Room.query.all()
		if len(stats) is 0:
			return jsonify({
				'status':'bad',
				'query':[
					{'id':1, 'name':'wegsdfsdfsdfsf', 'value':4},
					{'id':0, 'name':'hhhhh', 'value':1}
				]
				})
		return jsonify({
			'status':'good',
			'query':[item.serialize for item in stats]
			})
	#IMAGES
	if data_set == 'images':
		room_id = request.args.get('room_id','')
		stats = Image.query.filter_by(room_id=room_id).all()
		if len(stats) is 0:
			return jsonify({
				'status':'bad',
				'query':[
					{'id':1, 'name':'wegsdfsdfsdfsf', 'value':4},
					{'id':0, 'name':'hhhhh', 'value':1}
				]
				})
		return jsonify({
			'status':'good',
			'query':[item.serialize for item in stats]
			})
	#PANOS
	if data_set == 'panos':
		room_id = request.args.get('room_id','')
		stats = Pano.query.filter_by(room_id=room_id).all()
		if len(stats) is 0:
			return jsonify({
				'status':'bad',
				'query':[
					{'id':1, 'name':'wegsdfsdfsdfsf', 'value':4},
					{'id':0, 'name':'hhhhh', 'value':1}
				]
				})
		return jsonify({
			'status':'good',
			'query':[item.serialize for item in stats]
			})

	#ERROR
	return jsonify({
		"status":"unkown_error"
		})



@app.route('/api/<version>/update/<data_set>', methods=['POST'])
def api_update(version, data_set):

	if version is None:
		return jsonify(
			{status:"invalid_api_version"})
	if data_set is None:
		return jsonify({
			'status':'invalid_data_set'
			})

	status = 'bad'
	#ROOM
	if data_set == 'rooms':
		room_name = json.loads(request.data)['name']
		price  = json.loads(request.data)['price']
		feet  = json.loads(request.data)['feet']
		id = json.loads(request.data)['id']
		if id == -1:
			stat = Room()
			stat.name = room_name
			db.session.add(stat)
			db.session.commit()
		else:
			room = Room.query.get(id)
			room.price = price
			room.feet = feet
			db.session.commit()
		status = 'good'
	#IMAGE
	if data_set == 'images':
		room_name = json.loads(request.data)['name']
		price  = json.loads(request.data)['price']
		id = json.loads(request.data)['id']
		if id == -1:
			stat = Room()
			stat.name = room_name
			db.session.add(stat)
			db.session.commit()
		else:
			room = Room.query.get(id)
			room.price = price
			db.session.commit()
		status = 'good'


	return jsonify({
			'status':status
			})


def allowed_file(filename):
	return '.' in filename and \
		   filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def randomword(length):
   return ''.join(random.choice(string.lowercase) for i in range(length))


#this serves uplaoded files when requested
@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'],
                               filename)

if __name__ == "__main__":
	app.run()