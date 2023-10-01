from flask import Flask, jsonify, request
import json
from PIL import Image
import requests
import cv2
from detect.blazeFace import BlazeFace
import matplotlib.pyplot as plt
import numpy as np
from detect.faceViT import FaceViT
from io import BytesIO

detector = BlazeFace()
features = FaceViT()

app = Flask(__name__)


@app.route("/extractFeatures", methods=["GET", "POST"])
def nameRoute():
    global response

    ## ! VERIFICAR OS CASOS DE ERRO

    if request.method == "POST":
        imagem = request.files['imagem']
        imagem = Image.open(BytesIO(imagem.read())).transpose(Image.Transpose.ROTATE_90)

        croppedImage = detector.DetectAndAlignFace(cv2.cvtColor(np.array(imagem), cv2.COLOR_BGR2RGB))

        faceEmbeddings = features.extractFeatures(croppedImage)
        faceEmbeddings = faceEmbeddings.tolist()

        return jsonify({"features": faceEmbeddings})


if __name__ == "__main__":
    app.run(debug=True)
