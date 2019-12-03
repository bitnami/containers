FROM bitnami/python:3 as builder

COPY requirements.txt /app

WORKDIR /app
RUN virtualenv . && \
    . bin/activate && \
    pip install -r requirements.txt

COPY . /app

RUN . bin/activate && \
    python manage.py migrate

FROM bitnami/python:3-prod
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 8000
CMD bash -c "source bin/activate && python manage.py runserver 0:8000"
