
import cv2
import threading
import queue
import os
# import wget
# import object_detection
import tensorflow as tf
from object_detection.utils import label_map_util
from object_detection.utils import visualization_utils as viz_utils
from object_detection.builders import model_builder
from object_detection.utils import config_util
import numpy as np
from matplotlib import pyplot as plt
import easyocr
import csv
import uuid
from sklearn.preprocessing import LabelEncoder
import pickle
from keras_facenet import FaceNet

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
CUSTOM_MODEL_NAME = 'my_faster_rcnn'
PRETRAINED_MODEL_NAME = 'faster_rcnn_resnet101_v1_640x640_coco17_tpu-8'
PRETRAINED_MODEL_URL = 'http://download.tensorflow.org/models/object_detection/tf2/20200711/faster_rcnn_resnet101_v1_640x640_coco17_tpu-8.tar.gz'
TF_RECORD_SCRIPT_NAME = 'generate_tfrecord.py'
LABEL_MAP_NAME = 'label_map.pbtxt'
paths = {
        'WORKSPACE_PATH': os.path.join('Tensorflow', 'workspace'),
        'SCRIPTS_PATH': os.path.join('Tensorflow','scripts'),
        'APIMODEL_PATH': os.path.join('Tensorflow','models'),
        'ANNOTATION_PATH': os.path.join('Tensorflow', 'workspace','annotations'),
        'IMAGE_PATH': os.path.join('Tensorflow', 'workspace','images'),
        'MODEL_PATH': os.path.join('Tensorflow', 'workspace','models'),
        'PRETRAINED_MODEL_PATH': os.path.join('Tensorflow', 'workspace','pre-trained-models'),
        'CHECKPOINT_PATH': os.path.join('Tensorflow', 'workspace','models',CUSTOM_MODEL_NAME), 
        'OUTPUT_PATH': os.path.join('Tensorflow', 'workspace','models',CUSTOM_MODEL_NAME, 'export'), 
        'TFJS_PATH':os.path.join('Tensorflow', 'workspace','models',CUSTOM_MODEL_NAME, 'tfjsexport'), 
        'TFLITE_PATH':os.path.join('Tensorflow', 'workspace','models',CUSTOM_MODEL_NAME, 'tfliteexport'), 
        'PROTOC_PATH':os.path.join('Tensorflow','protoc')
    }

files = {
        'PIPELINE_CONFIG':os.path.join('Tensorflow', 'workspace','models', CUSTOM_MODEL_NAME, 'pipeline.config'),
        'TF_RECORD_SCRIPT': os.path.join(paths['SCRIPTS_PATH'], TF_RECORD_SCRIPT_NAME), 
        'LABELMAP': os.path.join(paths['ANNOTATION_PATH'], LABEL_MAP_NAME)
    }

    # limiting gpu
gpus = tf.config.list_physical_devices('GPU')
print(gpus)
if gpus:
    try:
            # allocating 5gb for tensorflow on gpu
        tf.config.experimental.set_virtual_device_configuration(
                gpu[0],[tf.config.experimental.VirtualDeviceConfiguration(memory_limit=4096)])
    except RunetimeError as e:
        print(e)

    # Load pipeline config and build a detection model
configs = config_util.get_configs_from_pipeline_file(files['PIPELINE_CONFIG'])
detection_model = model_builder.build(model_config=configs['model'], is_training=False)

    # Restore checkpoint
ckpt = tf.compat.v2.train.Checkpoint(model=detection_model)
ckpt.restore(os.path.join(paths['CHECKPOINT_PATH'], 'ckpt-10')).expect_partial()

@tf.function
def detect_fn(image):
    image, shapes = detection_model.preprocess(image)
    prediction_dict = detection_model.predict(image, shapes)
    detections = detection_model.postprocess(prediction_dict, shapes)
    return detections

# applying filtering to remove redundent texts on licence plate
def filter_text(region,ocr_result,region_threshold):
    rectangle_size = region.shape[0]*region.shape[1]
    plate = []
    for result in ocr_result:
        length = np.sum(np.subtract(result[0][1],result[0][0]))
        height = np.sum(np.subtract(result[0][2],result[0][1]))
        print(length,height)
            
        if length*height / rectangle_size > region_threshold:
            plate.append(result[1])
    
    return plate



def ocr_it(image,detections,detection_threshold,region_threshold):
    # scores , boxes and classes above detection threshold
    scores = list(filter(lambda x: x > detection_threshold, detections['detection_scores']))  #extracting scores whose score is greater than threshold
    boxes = detections['detection_boxes'][:len(scores)]  # filtering box coordinates (4 coordinates)
    classes = detections['detection_classes'][:len(scores)] # filtering classes => 0 - represent license
        
    # image dimensions
    width = image.shape[1]
    height = image.shape[0]
        
    # applying ROI filtering and OCR
    for idx,box in enumerate(boxes):
        roi = box * [height,width,height,width]
        region = image[int(roi[0]):int(roi[2]),int(roi[1]):int(roi[3])]

            # easy ocr setup
        reader = easyocr.Reader(['en'], gpu = True)
        ocr_result = reader.readtext(region)
        #     print(ocr_result)
        
        text = filter_text(region,ocr_result,region_threshold)
        plt.imshow(cv2.cvtColor(region,cv2.COLOR_BGR2RGB))
        print(text)

        return text,region


    # Saving Images
def save_results(text,region,csv_filename,folder_path):
    img_name = f'{uuid.uuid1()}.jpg'
        
    cv2.imwrite(os.path.join(folder_path,img_name),region)
        
    with open(csv_filename,mode='a',newline='',encoding="utf-8") as f:
        csv_writer = csv.writer(f,delimiter=',',quotechar='"',quoting=csv.QUOTE_MINIMAL)
        csv_writer.writerow([img_name,text])

category_index = label_map_util.create_category_index_from_labelmap(files['LABELMAP'])

def model1_process_frame(frame):
    region_threshold = 0.1
    detection_threshold = 0.7

    image_np = np.array(frame)         
    input_tensor = tf.convert_to_tensor(np.expand_dims(image_np, 0), dtype=tf.float32)
    detections = detect_fn(input_tensor)
            
    num_detections = int(detections.pop('num_detections'))
    detections = {key: value[0, :num_detections].numpy()
                for key, value in detections.items()}
    detections['num_detections'] = num_detections

    # detection_classes should be ints.
    detections['detection_classes'] = detections['detection_classes'].astype(np.int64)

    label_id_offset = 1
    image_np_with_detections = image_np.copy()

    viz_utils.visualize_boxes_and_labels_on_image_array(
                        image_np_with_detections,
                        detections['detection_boxes'],
                        detections['detection_classes']+label_id_offset,
                        detections['detection_scores'],
                        category_index,
                        use_normalized_coordinates=True,
                        max_boxes_to_draw=5,
                        min_score_thresh=.8,
                        agnostic_mode=False)
    try:
        ext,region = ocr_it(image_np_with_detections,detections,detection_threshold,region_threshold)
        # save_results(text,region,'realtime_results.csv','Detection_Images')
        plt.imshow(region)
    except:
        pass
    return image_np_with_detections
    


facenet = FaceNet()
faces_embeddings = np.load("faces_embeddings_done_4classes.npz")
Y = faces_embeddings['arr_1']
encoder = LabelEncoder()
encoder.fit(Y)
haarcascade = cv2.CascadeClassifier("haarcascade_frontalface_default.xml")
model = pickle.load(open("svm_model_160x160.pkl", 'rb'))

def model2_process_frame(frame):
    # Your code to process frame with model 2
    # Convert the image to RGB and grayscale
    rgb_img = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    gray_img = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Detect faces in the grayscale image
    faces = haarcascade.detectMultiScale(gray_img, 1.3, 5)

    for x, y, w, h in faces:
        img = rgb_img[y:y+h, x:x+w]
        img = cv2.resize(img, (160, 160)) # 1x160x160x3
        img = np.expand_dims(img, axis=0)
        ypred = facenet.embeddings(img)
        face_name = model.predict(ypred)
        final_name = encoder.inverse_transform(face_name)[0]
        cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 255), 10)
        cv2.putText(frame, str(final_name), (x, y-10), cv2.FONT_HERSHEY_SIMPLEX,
                   1, (0, 0, 255), 3, cv2.LINE_AA)

    return frame



def main():
    video_path = 'Videos/2.mp4'
    cap = cv2.VideoCapture(video_path)  # 0 for default webcam
    while True:
        ret, frame = cap.read()
        if not ret:
            print("Not working")
            break
        # Process the frame with both models
        processed_frame1 = model1_process_frame(frame)
        processed_frame2 = model2_process_frame(frame)


    # Close any remaining OpenCV windows
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()

