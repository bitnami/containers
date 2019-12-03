FROM bitnami/python:3 as builder
COPY . /app
WORKDIR /app
RUN virtualenv . && \
    . bin/activate && \
    pip install django && \
    python manage.py migrate

FROM bitnami/python:3-prod
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 8000
CMD bash -c "source bin/activate && python manage.py runserver 0:8000"
