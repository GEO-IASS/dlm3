FROM continuumio/miniconda3

RUN apt-get update

RUN conda install -y tensorflow
RUN conda install -y keras
RUN conda install -y opencv
RUN conda install -y caffe
RUN conda install -y scikit-learn
RUN conda install -y scikit-image
RUN conda install -y pytorch torchvision -c soumith

WORKDIR /root