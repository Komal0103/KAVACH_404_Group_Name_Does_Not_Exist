import os
# import wget
import object_detection
import tensorflow as tf
from object_detection.utils import label_map_util
from object_detection.utils import visualization_utils as viz_utils
from object_detection.builders import model_builder
from object_detection.utils import config_util
import numpy as np
import cv2
from matplotlib import pyplot as plt
import csv
import uuid
from matplotlib import ft2font
import pytesseract 

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
                gpu[0],[tf.config.experimental.VirtualDeviceConfiguration(memory_limit=2048)])
    except RunetimeError as e:
        print(e)

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
def filter_text(region, ocr_result, region_threshold):
    rectangle_size = region.shape[0] * region.shape[1]
    plate = []

    for result in ocr_result:
        length = np.sum(np.subtract(result[0][1], result[0][0]))
        height = np.sum(np.subtract(result[0][2], result[0][1]))

        if length * height / rectangle_size > region_threshold:
            plate.append(result[1])
    return plate

def ocr_it(image, detections, detection_threshold, region_threshold):
    scores = list(filter(lambda x: x > detection_threshold, detections['detection_scores']))
    boxes = detections['detection_boxes'][:len(scores)]
    classes = detections['detection_classes'][:len(scores)]
   
    width = image.shape[1]
    height = image.shape[0]

    for idx, box in enumerate(boxes):
        y_min, x_min, y_max, x_max = box
        roi =  [y_min*height, x_min*width, y_max*height,x_max* width]
        roi = [int(val) for val in roi]
        region = image[int(roi[0]):int(roi[2]), int(roi[1]):int(roi[3])]
       
        # Convert region to grayscale for Tesseract
        gray_region = cv2.cvtColor(region, cv2.COLOR_BGR2GRAY)
       
        # Perform OCR using Tesseract with multiple languages (Hindi and Marathi)
        ocr_result = pytesseract.image_to_data(gray_region, output_type=pytesseract.Output.DICT, lang='hin+mar')
       
        text = filter_text(region, ocr_result, region_threshold)
        cv2.imshow('Region', region)
        print(text)

        return text, region

def save_results(text, region, csv_filename, folder_path):
    img_name = f'{uuid.uuid1()}.jpg'

    cv2.imwrite(os.path.join(folder_path, img_name), region)

    with open(csv_filename, mode='a', newline='', encoding="utf-8") as f:
        csv_writer = csv.writer(f, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        csv_writer.writerow([img_name, text])

category_index = label_map_util.create_category_index_from_labelmap(files['LABELMAP'])


def image_detection(type):
    region_threshold = 0.1
    detection_threshold = 0.5

    if(type=='image'):
        category_index = label_map_util.create_category_index_from_labelmap(files['LABELMAP'])
        # IMAGE_PATH = os.path.join(paths['IMAGE_PATH'], 'test', 'Cars1.png')            
        IMAGE_PATH = os.path.join(paths['IMAGE_PATH'], 'test','Images' , 'night2.jpg')                  
        # detection happens here
        img = cv2.imread(IMAGE_PATH)
        image_np = np.array(img)

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
                    min_score_thresh=.8, # threshold for score (min 80% match)
                    agnostic_mode=False)

        plt.imshow(cv2.cvtColor(image_np_with_detections, cv2.COLOR_BGR2RGB))
        detections = {'detection_scores': [0.9], 'detection_boxes': [[0.1, 0.1, 0.9, 0.9]], 'detection_classes': [0]}
        detection_threshold = 0.7
        region_threshold = 0.1
        text, region = ocr_it(image_np_with_detections, detections, detection_threshold, region_threshold)

        save_results(text,region,'detection_results.csv','Detection_Images')
        print(text)
        cv2.imshow('object detection',  cv2.resize(image_np_with_detections, (800, 600)))
        cv2.waitKey(0)
        # closing all open windows
        cv2.destroyAllWindows()

    elif(type=='video'):
        category_index = label_map_util.create_category_index_from_labelmap(files['LABELMAP'])
        cap = cv2.VideoCapture(1)
        # cap = cv2.VideoCapture('Videos/1.mp4')
        width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

        while cap.isOpened(): 
            ret, frame = cap.read()
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
                text,region = ocr_it(image_np_with_detections,detections,detection_threshold,region_threshold)
                save_results(text,region,'realtime_results.csv','Detection_Images')
                plt.imshow(region)
            except:
                pass

            cv2.imshow('object detection',  cv2.resize(image_np_with_detections, (800, 600)))
    
            if cv2.waitKey(10) & 0xFF == ord('q'):
                cap.release()
                cv2.destroyAllWindows()


    
        




image_detection('image')

