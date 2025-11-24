# ---- Base: small, stable Python runtime ----
FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# ---- System deps required for Prophet/CmdStan build ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    g++ \
    make \
    git \
    curl \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# ---- Python deps ----
RUN pip install --upgrade pip setuptools wheel

WORKDIR /app

# 1) Copy requirements first for layer caching
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

# ---- Install CmdStan via cmdstanpy ----
ENV CMDSTAN=/opt/cmdstan
RUN python -c "from cmdstanpy import install_cmdstan; install_cmdstan(dir='/opt/cmdstan', version='2.34.1', cores=2)" \
 && chmod -R a+rX /opt/cmdstan

ENV PATH="${CMDSTAN}/bin:${PATH}"

# 2) Now copy the rest of your code
COPY . /app

CMD ["python", "-c", "import prophet; print('Prophet import OK')"]
