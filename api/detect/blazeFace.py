import numpy as np
import math
import timeit
import os
from PIL import Image
import cv2
import timeit
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Circle
import mediapipe as mp
from mediapipe import ImageFormat
from mediapipe.tasks import python
from mediapipe.tasks.python import vision


class BlazeFace:
    detector = vision.FaceDetector.create_from_options(
        vision.FaceDetectorOptions(
            base_options=python.BaseOptions(
                model_asset_path="api/detect/model/.blazeface_model/blaze_face_short_range.tflite"
            )
        )
    )

    def NormalizeKeypoint(self, nX, nY, imageWidth, imageHeight):
        x = min(math.floor(nX * imageWidth), imageWidth - 1)
        y = min(math.floor(nY * imageHeight), imageHeight - 1)

        return x, y

    def EuclideanDistance(self, a, b):
        x1 = a[0]
        y1 = a[1]
        x2 = b[0]
        y2 = b[1]

        return math.sqrt(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))

    def AlignImage(self, leftEye, rightEye, image):
        if leftEye[1] < rightEye[1]:
            thirdPoint = (leftEye[0], rightEye[1])
            direction = 1
        else:
            thirdPoint = (rightEye[0], leftEye[1])
            direction = -1

        a = self.EuclideanDistance(leftEye, thirdPoint)
        b = self.EuclideanDistance(rightEye, leftEye)
        c = self.EuclideanDistance(rightEye, thirdPoint)

        if c == 0:
            return image

        cosA = (b * b + c * c - a * a) / (2 * b * c)
        angle = np.arccos(cosA)
        angle = (angle * 180) / math.pi

        if direction == -1:
            angle = 90 - angle

        rotatedImage = cv2.cvtColor(
            np.array(Image.fromarray(image).rotate(direction * angle)),
            cv2.COLOR_BGR2RGB,
        )

        return rotatedImage

    def DetectAndAlignFace(self, image):
        imageHeight, imageWidth, _ = image.shape

        detection = self.detector.detect(
            mp.Image(image_format=ImageFormat.SRGB, data=image)
        )

        if detection.detections:
            boundingBox = detection.detections[0].bounding_box
            x1, y1, width, height = (
                boundingBox.origin_x,
                boundingBox.origin_y,
                boundingBox.width,
                boundingBox.height,
            )

            keypoints = detection.detections[0].keypoints
            leftEye = self.NormalizeKeypoint(
                keypoints[0].x, keypoints[0].y, imageWidth, imageHeight
            )
            rightEye = self.NormalizeKeypoint(
                keypoints[1].x, keypoints[1].y, imageWidth, imageHeight
            )

            rotatedImage = self.AlignImage(leftEye, rightEye, image)
            detection = self.detector.detect(
                mp.Image(image_format=ImageFormat.SRGB, data=rotatedImage)
            )

            if detection.detections:
                boundingBox = detection.detections[0].bounding_box
                x1, y1, width, height = (
                    boundingBox.origin_x,
                    boundingBox.origin_y,
                    boundingBox.width,
                    boundingBox.height,
                )

                return Image.fromarray(rotatedImage[y1 : y1 + height, x1 : x1 + width])
            else:
                return Image.fromarray(image[y1 : y1 + height, x1 : x1 + width])
        else:
            raise ValueError("Face not identified!") ## ! VERIFICAR OS CASOS DE ERRO
