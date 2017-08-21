FROM andrewssobral/dlm3

WORKDIR /root

RUN git clone https://github.com/andrewssobral/darknet.git

WORKDIR /root/darknet

RUN make

RUN wget https://pjreddie.com/media/files/yolo.weights

RUN ./darknet detect cfg/yolo.cfg yolo.weights data/dog.jpg