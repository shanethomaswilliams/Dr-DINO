#!/bin/bash
module load anaconda
module load cuda/11.6
module load gcc/11.2.0

conda deactivate
conda activate
# Create new conda environment named grounding_dino with Python 3.7.11
conda create -n grounding_dino python=3.7.11 -y

# Activate the environment
conda activate grounding_dino

# Install conda packages
conda install -y \
    _libgcc_mutex=0.1 \
    _openmp_mutex=5.1 \
    blas=1.0 \
    brotlipy=0.7.0 \
    bzip2=1.0.8 \
    ca-certificates=2024.9.24 \
    certifi=2022.12.7 \
    cffi=1.15.1 \
    charset-normalizer=2.0.4 \
    cryptography=39.0.1 \
    cudatoolkit=11.3.1 \
    ffmpeg=4.3 \
    flit-core=3.6.0 \
    freetype=2.12.1 \
    giflib=5.2.2 \
    gmp=6.2.1 \
    gnutls=3.6.15 \
    intel-openmp=2021.4.0 \
    jpeg=9e \
    lame=3.100 \
    lcms2=2.12 \
    lerc=3.0 \
    libdeflate=1.17 \
    libffi=3.3 \
    libgcc-ng=11.2.0 \
    libiconv=1.16 \
    libidn2=2.3.4 \
    libpng=1.6.39 \
    libstdcxx-ng=11.2.0 \
    libtasn1=4.19.0 \
    libtiff=4.5.1 \
    libunistring=0.9.10 \
    libuv=1.48.0 \
    libwebp=1.2.4 \
    libwebp-base=1.2.4 \
    lz4-c=1.9.4 \
    mkl=2021.4.0 \
    mkl-service=2.4.0 \
    mkl_fft=1.3.1 \
    mkl_random=1.2.2 \
    ncurses=6.4 \
    nettle=3.7.3 \
    numpy=1.21.5 \
    numpy-base=1.21.5 \
    openh264=2.1.1 \
    openssl=1.1.1w \
    pillow=9.4.0 \
    pip=22.3.1 \
    pycparser=2.21 \
    pyopenssl=23.0.0 \
    pysocks=1.7.1 \
    readline=8.2 \
    setuptools=59.5.0 \
    six=1.16.0 \
    sqlite=3.45.3 \
    tk=8.6.14 \
    urllib3=1.26.14 \
    wheel=0.38.4 \
    xz=5.4.6 \
    zlib=1.2.13 \
    zstd=1.5.6

# Install PyPI packages
pip install \
    addict==2.4.0 \
    cloudpickle==2.2.1 \
    colorlog==6.9.0 \
    cycler==0.11.0 \
    cython==3.0.11 \
    filelock==3.12.2 \
    fonttools==4.38.0 \
    fsspec==2023.1.0 \
    huggingface-hub==0.16.4 \
    importlib-metadata==6.7.0 \
    kiwisolver==1.4.5 \
    matplotlib==3.5.3 \
    ninja==1.11.1.1 \
    opencv-python==4.10.0.84 \
    packaging==24.0 \
    platformdirs==4.0.0 \
    pycocotools==2.0.7 \
    pyparsing==3.1.4 \
    python-dateutil==2.9.0.post0 \
    pyyaml==6.0.1 \
    regex==2024.4.16 \
    safetensors==0.4.5 \
    scipy==1.7.3 \
    submitit==1.4.6 \
    supervision==0.6.0 \
    termcolor==2.3.0 \
    timm==0.9.12 \
    tokenizers==0.13.3 \
    tomli==2.0.1 \
    tqdm==4.67.0 \
    transformers==4.30.2 \
    typing-extensions==4.7.1 \
    yapf==0.40.1 \
    zipp==3.15.0

pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html

echo "Environment setup complete!"
