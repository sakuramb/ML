from keras.models import Sequential, load_model
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Activation, Dropout, Flatten, Dense
# from keras.utils import np_utils
import keras,sys
import numpy as np
from PIL import Image

import glob
import cv2
import os

os.environ['KMP_DUPLICATE_LIB_OK']='TRUE'

# HaarCascade識別器が参照するXMLファイルパス
XML_PATH = "./haarcascades/haarcascade_frontalface_default.xml"
classifier = cv2.CascadeClassifier(XML_PATH)


classes = ['abe', 'sakaguchi', 'mokomichi']
num_classes = len(classes)
image_size = 50

def build_model():
    model = Sequential()
    model.add(Conv2D(32,(3,3), padding='same',input_shape=(50,50,3)))
    model.add(Activation('relu'))
    model.add(Conv2D(32,(3,3)))
    model.add(Activation('relu'))
    model.add(MaxPooling2D(pool_size=(2,2)))
    model.add(Dropout(0.25))

    model.add(Conv2D(64,(3,3), padding='same'))
    model.add(Activation('relu'))
    model.add(Conv2D(64,(3,3)))
    model.add(Activation('relu'))
    model.add(MaxPooling2D(pool_size=(2,2)))
    model.add(Dropout(0.25))

    model.add(Flatten())
    model.add(Dense(512))
    model.add(Activation('relu'))
    model.add(Dropout(0.5))
    model.add(Dense(num_classes))
    model.add(Activation('softmax'))

    opt = keras.optimizers.rmsprop(lr=0.0001, decay=1e-6)

    model.compile(loss='categorical_crossentropy',optimizer=opt,metrics=['accuracy'])

    # モデルのロード
    model = load_model('./cnn_face3.h5')

    return model

def main():
    # image = Image.open(sys.argv[1])
    # トリミング用カラー画像
    org_img = cv2.imread(sys.argv[1], cv2.IMREAD_COLOR)

    # 識別器入力用グレースケール画像
    gray_img = cv2.imread(sys.argv[1], cv2.IMREAD_GRAYSCALE)

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
        cv2.imwrite('predict.jpg', face_img)

    # image = image.convert('RGB')
    # image = image.resize((image_size, image_size))
    data = np.asarray(face_img)/255
    X = []
    X.append(data)
    X = np.array(X)
    model = build_model()

    # 各クラスの確率を表示
    result = model.predict([X])[0]
    for index, classlabel in enumerate(classes):
        percentage = int(result[index] * 100)
        print("{0} ({1} %)".format(classlabel, percentage))

    # 最も確率の高いクラスを表示
    # result = model.predict([X])[0]
    # predicted = result.argmax()
    # percentage = int(result[predicted] * 100)
    # print("{0} ({1} %)".format(classes[predicted], percentage))

if __name__ == "__main__":
    main()
