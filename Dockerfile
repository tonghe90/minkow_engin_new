FROM nvidia/cuda:10.1-devel-ubuntu18.04

RUN apt-get update && apt-get install -y libglib2.0-0 && apt-get clean

RUN apt-get install -y wget htop byobu git gcc g++ vim libsm6 libxext6 libxrender-dev lsb-core

RUN cd /root && wget https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh

RUN cd /root && bash Anaconda3-2020.07-Linux-x86_64.sh -b -p ./anaconda3

RUN bash -c "source /root/anaconda3/etc/profile.d/conda.sh && conda install pytorch==1.4.0 torchvision==0.5.0 cudatoolkit=10.1 -c pytorch"

RUN bash -c "source /root/anaconda3/etc/profile.d/conda.sh && conda activate base && conda install openblas-devel -c anaconda && conda install -c bioconda google-sparsehash && pip install easydict plyfile tensorboardX pyyaml scipy"

RUN bash -c "/root/anaconda3/bin/conda init bash"

ENV PATH /usr/local/cuda/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib:/usr/local/cuda/lib64

WORKDIR /root/code
RUN git clone https://github.com/tonghe90/minkow_engin_new.git mink
ARG TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"
ENV TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST}"

WORKDIR mink
RUN bash -c "source /root/anaconda3/etc/profile.d/conda.sh && conda activate base && git checkout mink0.4.2 && python setup.py install --blas=openblas "


RUN rm /root/Anaconda3-2020.07-Linux-x86_64.sh


