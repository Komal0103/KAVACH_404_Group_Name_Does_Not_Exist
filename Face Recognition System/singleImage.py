import cv2 as cv
import numpy as np
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
from sklearn.preprocessing import LabelEncoder
import pickle
from keras_facenet import FaceNet

def perform_face_recognition(image_path):
    # Initialize FaceNet
    facenet = FaceNet()

    # Load face embeddings and other necessary data
    faces_embeddings = np.load("faces_embeddings_done_4classes.npz")
    Y = faces_embeddings['arr_1']
    encoder = LabelEncoder()
    encoder.fit(Y)
    haarcascade = cv.CascadeClassifier("haarcascade_frontalface_default.xml")
    model = pickle.load(open("svm_model_160x160.pkl", 'rb'))

    frame = cv.imread(image_path)
    rgb_img = cv.cvtColor(frame, cv.COLOR_BGR2RGB)
    gray_img = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
    faces = haarcascade.detectMultiScale(gray_img, 1.3, 5)

    for x, y, w, h in faces:
        img = rgb_img[y:y+h, x:x+w]
        img = cv.resize(img, (160, 160))
        img = np.expand_dims(img, axis=0)
        ypred = facenet.embeddings(img)
        face_name = model.predict(ypred)
        confidence = model.decision_function(ypred)
        print(confidence)
        if np.max(confidence) < 8.29:
            final_name = "Face Not Found"
        else:
            final_name = encoder.inverse_transform(face_name)[0]

        cv.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 255), 10)
        cv.putText(frame, str(final_name), (x, y-10), cv.FONT_HERSHEY_SIMPLEX,
                   1, (0, 0, 255), 3, cv.LINE_AA)
        print(final_name)

    cv.imshow("Face Recognition:", frame)
    cv.waitKey(0)
    cv.destroyAllWindows()

# Testing
input_image_path = "/Users/rushi_jani/Downloads/FRS_Model/images/testing_images/3.jpeg"
perform_face_recognition(input_image_path)