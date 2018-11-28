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
    sudo localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    sudo apt-get -y update && \
    sudo apt-get -y upgrade && \
    sudo apt-get install -y git

ENV LANG en_US.utf8

WORKDIR /home/users
COPY requirements.txt code /home/users
RUN  sudo pip install -r requirements.txt && \
     jupyter notebook --generate-config && \
     echo “c.NotebookApp.ip =\'0.0.0.0\' “ >> jupyter_notebook_config.py && \
     git clone https://github.com/oreilly-japan/deep-learning-from-scratch.git && \
     git clone https://github.com/oreilly-japan/deep-learning-from-scratch-2.git && \
     git clone https://github.com/yohokuno/deeplearning.git

