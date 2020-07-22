FROM ubuntu:16.04
MAINTAINER Vlad Savelyev "https://github.com/vladsaveliev"
LABEL "repository"="https://github.com/vladsaveliev/conda-publish-action"
LABEL "maintainer"="Vlad Savelyev"

RUN apt-get update
RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# install miniconda
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && mkdir /root/.conda \
    && bash miniconda.sh -b \
    && rm miniconda.sh
ENV PATH=$HOME/miniconda3/bin:${PATH}
ARG PATH=$HOME/miniconda3/bin:${PATH}
RUN conda config --set always_yes yes --set changeps1 no
RUN conda install -c conda-forge mamba
RUN mamba update conda
RUN mamba config --add channels defaults --add channels vladsaveliev --add channels bioconda --add channels conda-forge
RUN mamba install -y pip versionpy conda-build conda-verify anaconda-client
