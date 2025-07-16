FROM python:3.10-slim

# Install OS build tools
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    git \
    curl \
    gcc \
    libyaml-dev \
    && apt-get clean

# Set working dir
WORKDIR /app

# Copy and install deps
COPY requirements.txt .

# UPGRADE pip and force wheel usage for pyyaml (this is the 🔑)
RUN pip install --upgrade pip \
 && pip install --only-binary=:all: --no-cache-dir pyyaml==5.4.1 \
 && pip install --no-cache-dir -r requirements.txt

# Copy rest of app
COPY . .

EXPOSE 5000 5005 5055

CMD ["sh", "-c", "rasa run actions & rasa run --enable-api --cors '*' & python app.py"]
