FROM python:3.10-slim

# Avoid frontend errors during debconf (optional but helps Render)
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
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

WORKDIR /app

COPY requirements.txt .

# Pin pip + setuptools + wheel to known good versions
RUN pip install --upgrade pip==23.2.1 setuptools==65.5.1 wheel

# Install everything normally (no manual PyYAML)
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000 5005 5055

CMD ["sh", "-c", "rasa run actions & rasa run --enable-api --cors '*' & python app.py"]
