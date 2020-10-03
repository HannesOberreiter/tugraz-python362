# Get our Python Version
# https://hub.docker.com/_/python
FROM "python:3.6.2-stretch"
LABEL maintainer="hoberreiter@gmail.com"

# Adding the user "docker" and switching to "docker" 
RUN useradd -ms /bin/bash docker
RUN su docker

# Various Python and C/build deps, mainly for openCV
# We need to change repository as there are some libs are not anymore available
# https://github.com/opencv/opencv/issues/8622
#RUN apt-get update && apt-get install -y software-properties-common
#RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
# https://chrisjean.com/fix-apt-get-update-the-following-signatures-couldnt-be-verified-because-the-public-key-is-not-available/
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
RUN apt-get update
# https://stackoverflow.com/questions/36403740/broken-packages-do-not-let-me-install-packages
RUN apt-get install -y aptitude 

# Install routine mostly for OpenCV based on
# as I run into problems with OpenCV I don't include them
# https://github.com/milq/milq/blob/master/scripts/bash/install-opencv.sh

# Build tools:
#RUN aptitude install -y build-essential cmake

# GUI (if you want GTK, change 'qt5-default' to 'libgtkglext1-dev' and remove '-DWITH_QT=ON'):
#RUN aptitude install -y qt5-default libvtk6-dev

# Media I/O:
#RUN aptitude install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper1 libjasper-dev \
#                        libopenexr-dev libgdal-dev

# Video I/O:
#RUN aptitude install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev \
#                        libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm \
#                        libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev

# Parallelism and linear algebra libraries:
#RUN aptitude install -y libtbb-dev libeigen3-dev

# Python:
#RUN aptitude install -y python3-tk pylint3 python3-numpy flake8

# Java:
#RUN aptitude install -y ant default-jdk

# Documentation and other:
RUN aptitude install -y doxygen unzip wget

# GDAL Libraries
RUN aptitude install -y libgdal-dev libgeos-dev
RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal && export C_INCLUDE_PATH=/usr/include/gdal
RUN aptitude install -y gdal-bin python-gdal python3-gdal

# OpenCV
# did run into errors with OpenCV, don't need it anyway for the moment
#RUN wget https://github.com/opencv/opencv/archive/3.0.0.zip && \
#    unzip 3.0.0.zip && rm 3.0.0.zip && \
#    mv opencv-3.0.0 OpenCV

#RUN cd OpenCV && mkdir build && cd build && \
#    cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON \
#      -DWITH_XINE=ON -DENABLE_PRECOMPILED_HEADERS=OFF .. && \
#    make -j8 && make install && ldconfig

# Copy the requirements.txt file to the container 
COPY requirements.txt /root/informatik/requirements.txt
WORKDIR /root/informatik

# Installing jupyter notebook
#RUN pip3 install --upgrade pip
RUN pip3 install notebook ipywidgets
RUN pip3 install jupyter_contrib_nbextensions
# We need to install cython seperately as it is a depency later
RUN pip3 install cython
# Installing modules defined in our requirements.txt
RUN pip3 install -r requirements.txt
# We need to install basemap from github archive not anymore in PyPi
# https://stackoverflow.com/questions/46560591/how-can-i-install-basemap-in-python-3-matplotlib-2-on-ubuntu-16-04
RUN pip3 install --user https://github.com/matplotlib/basemap/archive/v1.1.0.zip

# Setting Jupyter notebook configurations 
RUN jupyter notebook --generate-config --allow-root
# Uncomment for no authentication at all
#RUN echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py
#RUN echo "c.NotebookApp.password = ''" >> /root/.jupyter/jupyter_notebook_config.py
# Standard Passwort "root"
#RUN echo "c.NotebookApp.password = u'sha1:0c2a00d8851a:fbb1f9715d5c424c34c95be9c11e922a892c143a'" >> /root/.jupyter/jupyter_notebook_config.py
# There were some errors with extensions, this helps
RUN jupyter nbextension install --py widgetsnbextension --user
RUN jupyter nbextension enable widgetsnbextension --user --py
# better autocomplete
RUN jupyter contrib nbextension install --user
RUN jupyter nbextension enable hinterland/hinterland


# Jupyter Commands, to use current directory and set port
EXPOSE 8888
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=.", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
