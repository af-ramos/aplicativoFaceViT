from PIL import Image
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

import math
import torch.nn as nn
from torch.utils.mobile_optimizer import optimize_for_mobile
import os
import torch
import torch.optim.lr_scheduler as sch
import timm
import shutil
import timm.optim as opt

from sklearn.model_selection import StratifiedKFold
from torchinfo import summary
from pathlib import Path
from torchvision import transforms as T
from torch.utils.data import DataLoader, Subset
from torchvision import datasets
from pytorch_metric_learning import losses
from pytorch_metric_learning import regularizers

class FaceViT:
    model = torch.jit.load('api/detect/model/faceViT.pt')
    model.eval()

    def extractFeatures(self, image):
        TRANSFORM_TEST = T.Compose([
            T.Resize((224, 224)),
            T.ToTensor(),
            T.Normalize(mean = [0.6233, 0.3960, 0.2472], std = [0.2469, 0.1667, 0.1347]),
        ])

        image = TRANSFORM_TEST(image).unsqueeze(0)

        return self.model(image).cpu().detach().numpy()[0]