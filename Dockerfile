FROM python:3.10-slim

# Install system dependencies
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

# Set working directory
WORKDIR /app

# Copy requirements first
COPY requirements.txt .

# Upgrade pip + setuptools + wheel to latest to avoid build failures
RUN pip install --upgrade pip setuptools wheel

# Install PyYAML from wheel manually (before Rasa touches it)
RUN pip install --only-binary=pyyaml pyyaml==5.4.1

# Install other requirements
RUN pip install --no-cache-dir -r requirements.txt

# Copy everything else
COPY . .

# Expose ports
EXPOSE 5000 5005 5055

# Start Rasa + Actions + Flask
CMD ["sh", "-c", "rasa run actions & rasa run --enable-api --cors '*' & python app.py"]
