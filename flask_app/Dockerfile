FROM python:3.13.5-alpine

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8080

ENV FLASK_APP=main.py

ENTRYPOINT ["flask"]
CMD ["run", "--host=0.0.0.0", "--port=8080"]
