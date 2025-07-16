FROM python:3.10-slim

# 📦 Install system dependencies needed to build wheels
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libffi-dev \
    libssl-dev \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    git \
    curl \
    libyaml-dev \
    python3-dev \
    && apt-get clean

# 🐍 Set workdir and copy requirements
WORKDIR /app
COPY requirements.txt .

# 🔧 Upgrade build tools BEFORE installing anything
RUN pip install --upgrade pip setuptools wheel

# 📥 Install everything including PyYAML (let rasa handle version)
RUN pip install --no-cache-dir -r requirements.txt

# 📁 Copy the rest of your code
COPY . .

# 🌐 Expose ports (Flask + Rasa + Actions)
EXPOSE 5000 5005 5055

# 🚀 Run everything
CMD ["sh", "-c", "rasa run actions & rasa run --enable-api --cors '*' & python app.py"]
