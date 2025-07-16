FROM python:3.10-slim

# 📦 Install build tools and dependencies
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
    libyaml-dev \
    git \
    curl \
    && apt-get clean

# 📁 Set working directory
WORKDIR /app

# 🐍 Copy and install Python dependencies
COPY requirements.txt .

# Make sure pip, setuptools, and wheel are up-to-date
RUN pip install --upgrade pip setuptools wheel

# Install everything including PyYAML normally
RUN pip install --no-cache-dir -r requirements.txt

# 🗂️ Copy the rest of your code
COPY . .

# 🌐 Expose ports
EXPOSE 5000 5005 5055

# 🧠 Start the services
CMD ["sh", "-c", "rasa run actions & rasa run --enable-api --cors '*' & python app.py"]
