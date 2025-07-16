FROM python:3.10

# 📦 Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libffi-dev \
    libssl-dev \
    git \
    curl \
    build-essential \
    libyaml-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    && apt-get clean

# 📁 Set working directory
WORKDIR /app

# 📄 Copy requirements and install them
COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# 📂 Copy the full project
COPY . .

# 🌍 Expose necessary ports
EXPOSE 5000 5005 5055

# 🚀 Start Rasa Actions, Rasa Server, and Flask App
CMD ["sh", "-c", "rasa run actions & rasa run --enable-api --cors '*' & python app.py"]
