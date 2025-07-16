FROM python:3.10-slim

# 📦 Install OS-level dependencies needed to build Rasa + PyYAML properly
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

# 📁 Set working directory
WORKDIR /app

# 🐍 Copy and install Python dependencies
COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# 🗂️ Copy all source code
COPY . .

# 📡 Expose all ports used (Flask + Rasa HTTP + Rasa Actions)
EXPOSE 5000 5005 5055

# 🧠 Run Rasa actions, Rasa server, and Flask together
CMD ["sh", "-c", "rasa run actions & rasa run --enable-api --cors '*' & python app.py"]
