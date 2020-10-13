import os
from flask import Flask, flash, request, redirect, url_for
from werkzeug.utils import secure_filename

from keras.models import Sequential, load_model
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Activation, Dropout, Flatten, Dense
# from keras.utils import np_utils
import keras,sys
import numpy as np
from PIL import Image

os.environ['KMP_DUPLICATE_LIB_OK']='TRUE'

# https://flask.palletsprojects.com/en/1.1.x/patterns/fileuploads/

UPLOAD_FOLDER = './uploads'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'gif'])

classes = ['abe', 'sakaguchi', 'mokomichi']
num_classes = len(classes)
image_size = 50

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        # if user does not select file, browser also
        # submit an empty part without filename
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)

            model = load_model('./cnn_face3.h5')

            # image = Image.open(sys.argv[1])
            # トリミング用カラー画像
            org_img = cv2.imread(filepath, cv2.IMREAD_COLOR)

            # 識別器入力用グレースケール画像
            gray_img = cv2.imread(filepath, cv2.IMREAD_GRAYSCALE)

            #候補画像（グレースケール画像）を識別器に入力、顔領域と思われる座標情報取得
            face_points = classifier.detectMultiScale(
                gray_img, scaleFactor=1.2, minNeighbors=2, minSize=(1,1))

            #識別結果（矩形座標情報）よりカラー画像をトリミングして顔画像生成　
            for points in face_points:

                # 顔領域の座標点取得
                x, y, width, height =  points

                # 顔領域トリミング
                dst_img = org_img[y:y+height, x:x+width]

                # 顔画像サイズ正規化して保存
                face_img = cv2.resize(dst_img, (image_size, image_size))
                # cv2.imwrite('predict.jpg', face_img)

            data = np.asarray(face_img)/255
            X = []
            X.append(data)
            X = np.array(X)

            result = model.predict([X])[0]
            
            for index, classlabel in enumerate(classes):
                percentage = int(result[index] * 100)
                return "{0} ({1} %)".format(classlabel, percentage)
                    
            # return 'クラス:'+ classes[predicted] + ' 確率：' + str(percentage) + '%'

            # return redirect(url_for('uploaded_file',filename=filename))


    return '''
    <!doctype html>
    <html>
    <head>
    <meta charset='UTE-8'>
    <title>Upload new File</title></head>
    <body>
    <h1>Upload new File</h1>
    <form method=post enctype=multipart/form-data>
      <p><input type=file name=file>
      <input type=submit value=Upload>
    </form>
    </body>
    </html>
    '''

from flask import send_from_directory

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'],
                               filename)
