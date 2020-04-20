FROM ubuntu:latest

# To customize, try removing packages below not needed for your research.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --fix-missing \
    default-jdk \
    bzip2 \
    curl \
    ca-certificates \
    gcc \
    git \
    emacs \
    libz-dev \
    libbz2-dev \
    locales \
    nano \
    r-base \
    r-base-dev\
    unzip \
    wget \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/

# Install BWA
ADD https://github.com/lh3/bwa/archive/v0.7.17.zip .
RUN unzip v0.7.17.zip
RUN cd bwa-0.7.17/ && make
RUN ln -s bwa-0.7.17/bwa bwa
RUN rm v0.7.17.zip

# Install Samtools
ADD https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2 .
RUN bunzip2 samtools-1.6.tar.bz2
RUN tar xf samtools-1.6.tar
RUN cd samtools-1.6 && ./configure --without-curses --disable-bz2 --disable-lzma && make && make install
RUN rm samtools-1.6.tar

# Install Miniconda3
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# Install Miniconda3
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

WORKDIR /
COPY test.py /
COPY Dockerfile /
COPY README.md /

# Checks if JDK 11, vim, python, R, emacs, nano, samtools, and conda installed correctly.
RUN python -m unittest test.py

# use LSF_DOCKER_PRESERVE_ENVIRONMENT=false before bsub if you want to presrve path in compute1
ENV PATH=/opt:/opt/scripts:/opt/scripts/common:$PATH

