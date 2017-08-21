FROM continuumio/miniconda3

# Install dependencies for OpenCV
RUN apt-get update && apt-get install -y \
        build-essential \
        cmake \
        pkg-config \
        wget \
        git \
        unzip \
        nano \
        libjpeg-dev \
        libtiff-dev \
        libjasper-dev \
        libpng-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev \
        libatlas-base-dev \
        gfortran \
        libhdf5-dev \
        libtbb2 \
        libtbb-dev \
        libgl1-mesa-glx \
        && apt-get autoclean && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install deep learning libraries 
RUN conda install -y numpy
RUN conda install -y tensorflow
RUN conda install -y keras
#RUN conda install -y opencv
#RUN conda install -y caffe
RUN conda install -y scikit-learn
RUN conda install -y scikit-image
RUN pip install visdom
RUN conda install -y pytorch torchvision -c soumith

# Build OpenCV

# Download OpenCV 3.3.0
RUN cd ~ && \ 
    wget https://github.com/Itseez/opencv/archive/3.3.0.zip && \
    unzip 3.3.0.zip && \
    mv ~/opencv-3.3.0/ ~/opencv/ && \
    rm -rf ~/3.3.0.zip

# Download contrib module for OpenCV 3.3.0
RUN cd ~ && \
    wget https://github.com/opencv/opencv_contrib/archive/3.3.0.zip -O 3.3.0-contrib.zip && \
    unzip 3.3.0-contrib.zip && \
    mv opencv_contrib-3.3.0 opencv_contrib && \
    rm -rf ~/3.3.0-contrib.zip

# For Python2
# -D PYTHON2_EXECUTABLE=$(which python2) \
# -D PYTHON2_INCLUDE_DIR=$(python2 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
# -D PYTHON2_PACKAGES_PATH=$(python2 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \

# For Python3
# -D PYTHON3_EXECUTABLE=$(which python3) \
# -D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
# -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \

# Default Python
# -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
# -D PYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
# -D PYTHON_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \

# Configure OpenCV (Force python3 from anaconda instead of local python2)
RUN cd ~/opencv && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_C_EXAMPLES=OFF \
        -D INSTALL_PYTHON_EXAMPLES=ON \
	    -D WITH_IPP=OFF \
	    -D WITH_TBB=ON \
        -D ENABLE_AVX=ON \
        -D WITH_CUDA=OFF \
        -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
	    -D PYTHON_EXECUTABLE=$(which python3) \
        -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
        -D PYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON_LIBRARY=$(python3 -c "import sysconfig; print(sysconfig.get_config_var('LIBDIR')+'/'+sysconfig.get_config_var('LDLIBRARY'))") \
        -D PYTHON3_EXECUTABLE=$(which python3) \
        -D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON3_INCLUDE_PATH=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON3_LIBRARIES=$(python3 -c "import sysconfig; print(sysconfig.get_config_var('LIBDIR')+'/'+sysconfig.get_config_var('LDLIBRARY'))") \
        -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
        -D BUILD_EXAMPLES=OFF ..

# Build OpenCV
RUN cd ~/opencv/build && \
    make -j $(nproc) && \
    make install && \
    ldconfig

# Clean OpenCV repos
RUN rm -rf ~/opencv/build && \
    rm -rf ~/opencv/3rdparty && \
    rm -rf ~/opencv/doc && \
    rm -rf ~/opencv/include && \
    rm -rf ~/opencv/platforms && \
    rm -rf ~/opencv/modules && \
    rm -rf ~/opencv_contrib/build && \
    rm -rf ~/opencv_contrib/doc

WORKDIR /root
