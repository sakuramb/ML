# -*- coding: utf-8 -*-
from PIL import Image
import os, glob
import numpy as np
from sklearn import model_selection

classes = ['abe', 'sakaguchi', 'mokomichi']
num_classes = len(classes)
image_size = 50

# 少ない方のデータの数に合わせる
num_data = 140
num_testdata = 40

# 画像の読み込み,配列に変換
X_train = []
X_test = []
Y_train = []
Y_test = []

for index, classlabel in enumerate(classes):
    photos_dir = './' + classlabel
    files = glob.glob(photos_dir + '/*.jpg')
    for i, file in enumerate(files):
        if i >= num_data: break
        image = Image.open(file)
        image = image.convert('RGB')
        image = image.resize((image_size, image_size))
        data = np.asarray(image)
        # X.append(data)
        # Y.append(index)

        if i < num_testdata:
            X_test.append(data)
            Y_test.append(index)
        else:
            X_train.append(data)
            Y_train.append(index)
            for angle in range(-20, 20, 5):
                img_r = image.rotate(angle)
                data = np.asarray(img_r)
                X_train.append(data)
                Y_train.append(index)

                img_trans = image.transpose(Image.FLIP_LEFT_RIGHT)
                data = np.asarray(img_trans)
                X_train.append(data)
                Y_train.append(index)


# X = np.array(X)
# Y = np.array(Y)
X_train = np.array(X_train)
X_test = np.array(X_test)
y_train = np.array(Y_train)
y_test = np.array(Y_test)


# X_train, X_test, y_train, y_test = model_selection.train_test_split(X, Y)
xy = (X_train, X_test, y_train, y_test)
print(X_train.shape)
# % python gen_data_augmented.py
# (5083, 50, 50, 3)

np.save('./face_3.npy', xy)
        