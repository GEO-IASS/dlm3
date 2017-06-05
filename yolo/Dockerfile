FROM andrewssobral/dlm3

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        wget \
        git \
        unzip \
        && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN git clone https://github.com/andrewssobral/darknet.git

WORKDIR /root/darknet

RUN make

RUN wget https://pjreddie.com/media/files/yolo.weights

RUN ./darknet detect cfg/yolo.cfg yolo.weights data/dog.jpg