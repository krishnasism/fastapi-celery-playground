FROM python:3.11

WORKDIR /celery_app

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . /celery_app/

EXPOSE 8000

CMD ["celery", "-A", "app.app", "worker", "-l", "INFO"]
