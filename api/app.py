from flask import Flask, jsonify, request
import json
from PIL import Image
import requests
import cv2
from detect.blazeFace import BlazeFace
import matplotlib.pyplot as plt
from numpy.linalg import norm
import numpy as np
from detect.faceViT import FaceViT
from scipy.spatial.distance import cosine
from io import BytesIO

detector = BlazeFace()
features = FaceViT()

app = Flask(__name__)

@app.route("/extractFeatures", methods = ["POST"])
def extractFeatures():
    global response
    
    if request.method == "POST":
        imagem = request.files['imagem']
        imagem = Image.open(BytesIO(imagem.read())).transpose(Image.Transpose.ROTATE_90)

        croppedImage = detector.DetectAndAlignFace(cv2.cvtColor(np.array(imagem), cv2.COLOR_BGR2RGB))

        faceEmbeddings = features.extractFeatures(croppedImage)
        faceEmbeddings = faceEmbeddings.tolist()

        return jsonify({"features": faceEmbeddings})

@app.route("/verifyUser", methods = ["POST"])
def verifyUser():
    global response

    imagem = request.files['imagem']
    imagem = Image.open(BytesIO(imagem.read())).transpose(Image.Transpose.ROTATE_90)

    croppedImage = detector.DetectAndAlignFace(cv2.cvtColor(np.array(imagem), cv2.COLOR_BGR2RGB))

    faceEmbeddings = features.extractFeatures(croppedImage)
    originalFeatures = np.array(json.loads(request.form['features']))

    similarity = np.dot(faceEmbeddings, originalFeatures) / (norm(faceEmbeddings) * norm(originalFeatures))

    return jsonify({"similarity": similarity})

@app.route("/identifyUser", methods = ["POST"])
def identifyUser():
    global response

    imagem = request.files['imagem']
    imagem = Image.open(BytesIO(imagem.read())).transpose(Image.Transpose.ROTATE_90)

    croppedImage = detector.DetectAndAlignFace(cv2.cvtColor(np.array(imagem), cv2.COLOR_BGR2RGB))

    faceEmbeddings = features.extractFeatures(croppedImage)
    usersFeatures = json.loads(request.form.get('usersFeatures'))

    maxSimilarity = -2
    maxID = ''

    for userFeature in usersFeatures:
        originalFeatures = np.array(userFeature['features'])
        similarity = np.dot(faceEmbeddings, originalFeatures) / (norm(faceEmbeddings) * norm(originalFeatures))

        if similarity > maxSimilarity:
            maxSimilarity = similarity
            maxID = userFeature['id']

    return jsonify({"userID": maxID, "similarity": maxSimilarity})

if __name__ == "__main__":
    app.run(debug = True)
