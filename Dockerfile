FROM ubuntu:16.04

USER root

ENV SUMO_VERSION 1.1.0
ENV SUMO_HOME /opt/sumo
ENV SUMO_USER romain

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3.5 \
    python3-pip
    
RUN apt-get install -y software-properties-common
RUN apt-get install -y cmake g++ libxerces-c-dev libfox-1.6-dev libgdal-dev libproj-dev libgl2ps-dev swig sudo wget

    
    
# Download and extract source code
RUN wget http://downloads.sourceforge.net/project/sumo/sumo/version%20$SUMO_VERSION/sumo-src-$SUMO_VERSION.tar.gz
RUN tar xzf sumo-src-$SUMO_VERSION.tar.gz && \
    mv sumo-$SUMO_VERSION $SUMO_HOME && \
    rm sumo-src-$SUMO_VERSION.tar.gz
    
RUN cd $SUMO_HOME && export SUMO_HOME="$PWD" && mkdir -p ./build/cmake-build && cd build/cmake-build && cmake ../.. && make -j$(nproc)
ENV PATH=$PATH:$SUMO_HOME/bin 

#Requirements
WORKDIR /launch

EXPOSE 8000

#xauth for gui
RUN apt-get -y update
RUN pip3 install --upgrade "pip < 21.0"
RUN pip3 --version
RUN pip3 install tensorflow==1.12.0
RUN pip3 install matplotlib
RUN pip3 install seaborn
RUN pip3 install traci

CMD /bin/bash
