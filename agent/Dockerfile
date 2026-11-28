FROM python:3.12-slim@sha256:5e2bdb1b0d542d5039cffb8181c65930093949194a65c365dfb1b0fe13a4fa5b
ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends git \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -m -u 1000 app
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt \
 && pip uninstall -y pytest pytest-asyncio ruff
RUN pip install "Django==2.2.0" 
COPY . .
USER app
EXPOSE 8000
CMD ["uvicorn","app.main:app","--host","0.0.0.0","--port","8000"]
