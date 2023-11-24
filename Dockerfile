FROM python:latest

WORKDIR /app

COPY . .

RUN pip install -r "requirements.txt"

ENV PORT=8080

EXPOSE ${PORT}

ENTRYPOINT ["python", "lbg.py"]
