from flask import Flask, jsonify, request
import json
from PIL import Image
import requests
import cv2
from detect.blazeFace import BlazeFace
import matplotlib.pyplot as plt
import numpy as np
from detect.faceViT import FaceViT

detector = BlazeFace()
features = FaceViT()

app = Flask(__name__)


@app.route("/extractFeatures", methods=["GET", "POST"])
def nameRoute():
    global response

    if request.method == "POST":
        request_data = json.loads(request.data.decode("utf-8"))
        imageUrl = request_data["imageUrl"]

        image = Image.open(requests.get(imageUrl, stream=True).raw).transpose(
            Image.Transpose.ROTATE_90
        )

        croppedImage = detector.DetectAndAlignFace(
            cv2.cvtColor(np.array(image), cv2.COLOR_BGR2RGB)
        )

        faceEmbeddings = features.extractFeatures(croppedImage)
        faceEmbeddings = faceEmbeddings.tolist()

        return jsonify({"features": faceEmbeddings})


if __name__ == "__main__":
    app.run(debug=True)
