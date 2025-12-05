FROM python:3.11-alpine

WORKDIR /app

# Install Flask
RUN pip install --no-cache-dir flask

# Create the challenge app
COPY app.py .
COPY templates/ templates/

# Non-root user for security
RUN adduser -D -u 1000 ctf
USER ctf

EXPOSE 5000

CMD ["python", "app.py"]
