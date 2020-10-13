# -*- coding: utf-8 -*-
import glob
import cv2
import os

# HaarCascade識別器が参照するXMLファイルパス
XML_PATH = "./haarcascades/haarcascade_frontalface_default.xml"

name = ['not_sakaguchi']

def face_detect(img_list, classlabel):   

    # 顔領域識別器をセット
    classifier = cv2.CascadeClassifier(XML_PATH)

    # 顔領域を検出すれば顔画像生成
    img_count = 1
    for img_path in img_list:

        # トリミング用カラー画像
        org_img = cv2.imread(img_path, cv2.IMREAD_COLOR)

        # 識別器入力用グレースケール画像
        gray_img = cv2.imread(img_path, cv2.IMREAD_GRAYSCALE)

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
            face_img = cv2.resize(dst_img, (64,64))
            new_img_name = str(img_count) + '.jpg'
            dirname = str(classlabel)
            if not os.path.exists(dirname):
                os.mkdir(dirname)

            cv2.imwrite(os.path.join(dirname, new_img_name), face_img)
            # cv2.imwrite(new_img_name, face_img)
            img_count += 1

    return


if __name__ == '__main__':
    for index, classlabel in enumerate(classes):
        #候補画像を格納したディレクトリパス
        IMG_PATH = './image/' + classlabel
        #指定ディレクトリより候補画像を取得、API等を用いて顔画像生成
        images = glob.glob(IMG_PATH + '/*.jpg')
        # print(images)  
        face_detect(images, classlabel)