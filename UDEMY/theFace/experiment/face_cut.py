#OpenCVのインポート
import cv2
 
#カスケード型分類器に使用する分類器のデータ（xmlファイル）を読み込み
HAAR_FILE = './haarcascades/haarcascade_frontalface_default.xml'
cascade = cv2.CascadeClassifier(HAAR_FILE)
 
#画像ファイルの読み込み
image_picture = "./image/_1.jpg_rect490.jpg"
 
img = cv2.imread(image_picture)
 
#グレースケールに変換する
img_g = cv2.imread(image_picture,0)
 
#カスケード型分類器を使用して画像ファイルから顔部分を検出する
face = cascade.detectMultiScale(img_g)
 
#顔の座標を表示する
print(face)
 
#顔部分を切り取る
for x,y,w,h in face:
    face_cut = img[y:y+h, x:x+w]
 
#白枠で顔を囲む
# for x,y,w,h in face:
#     cv2.rectangle(img,(x,y),(x+w,y+h),(255,255,255),2)
 
#画像の出力
cv2.imwrite('face_cut.jpg', face_cut)
cv2.imwrite('face_rectangle.jpg', img)