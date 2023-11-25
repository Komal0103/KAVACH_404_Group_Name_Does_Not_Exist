import os
import cv2
import albumentations as A
from albumentations.pytorch import ToTensorV2

# Path to the input image
input_image_path = '/images/training_images/rushi_pics/cd293163-3340-11ee-88ff-dd401cbfbff9.jpg'

# Path to the output folder where augmented images will be stored
output_folder = '/Users/rushi_jani/Downloads/facenet/images/rushi_pics3/'

# Create the output folder if it doesn't exist
os.makedirs(output_folder, exist_ok=True)

# Load the input image
input_image = cv2.imread(input_image_path)

# Define the augmentation pipeline
augmentation_pipeline = A.Compose([
    A.HorizontalFlip(p=0.5),             # Flip horizontally with a 50% chance
    A.Rotate(limit=(-25, 25)),           # Rotate the image by -25 to 25 degrees
    A.GaussianBlur(sigma_limit=(0, 1.0)),  # Apply Gaussian blur with a sigma between 0 and 1.0
    ToTensorV2()                          # Convert image to PyTorch tensor
])

# Generate and save augmented images
num_augmented_images = 30  # Number of augmented images to generate
for i in range(num_augmented_images):
    augmented = augmentation_pipeline(image=input_image)
    augmented_image = augmented['image']

    # Convert the NumPy array to the correct data type and range
    augmented_image_np = (augmented_image * 255).astype('uint8')

    output_path = os.path.join(output_folder, f'augmented_{i+1}.jpg')
    cv2.imwrite(output_path, augmented_image_np)

print(f'{num_augmented_images} augmented images saved in {output_folder}')