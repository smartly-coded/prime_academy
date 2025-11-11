import cv2
import numpy as np
import os

input_folder = "frames"
output_folder = "frames_no_bg"

os.makedirs(output_folder, exist_ok=True)

for filename in os.listdir(input_folder):
    if filename.endswith(".png"):
        img_path = os.path.join(input_folder, filename)
        img = cv2.imread(img_path)

        # حول الصورة إلى رمادية
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        # اعمل threshold لعزل الخلفية السوداء
        _, alpha = cv2.threshold(gray, 10, 255, cv2.THRESH_BINARY)

        # أضف قناة شفافية بناءً على threshold
        b, g, r = cv2.split(img)
        rgba = cv2.merge([b, g, r, alpha])

        out_path = os.path.join(output_folder, filename)
        cv2.imwrite(out_path, rgba)

print("✅ Done! كل الصور اتعملها خلفية شفافة في:", output_folder)
