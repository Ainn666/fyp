FROM python:3.10-slim

# 📦 Install OS-level build tools
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

# 🐍 Copy and install Python dependencies (install PyYAML manually first!)
COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir pyyaml==5.4.1
RUN pip install --no-cache-dir -r requirements.txt

# 🗂️ Copy all other source code
COPY . .

# 🌐 Expose ports for Flask, Rasa HTTP, and Rasa Actions
EXPOSE 5000 5005 5055

# 🧠 Run everything together: Rasa Actions, Rasa Core API, Flask
CMD ["sh", "-c", "rasa run actions & rasa run --enable-api --cors '*' & python app.py"]
