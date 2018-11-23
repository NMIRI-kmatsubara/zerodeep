FROM ubuntu:18.04
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y sudo && \
    groupadd -g 1000 developer && \
    useradd  -g      developer -G sudo -m -s /bin/bash users && \
    echo 'users:nmiri' | chpasswd && \
    echo 'Defaults visiblepw'             >> /etc/sudoers && \
    echo 'users ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER users

RUN sudo apt-get install -y locales curl python3-distutils && \
    sudo curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    sudo python3 get-pip.py && \
    sudo pip install -U pip && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

WORKDIR /home/users
COPY requirements.txt /home/users
COPY file/code /home/users
RUN  sudo pip install -r requirements.txt && \
     jupyter notebook --generate-config

WORKDIR /home/users/.jupyter
COPY /file/jupyter_notebook_config.py /home/users/.jupyter/jupyter_notebook_config.py

WORKDIR /home/users
