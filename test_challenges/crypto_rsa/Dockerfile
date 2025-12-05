FROM python:3.11-alpine

WORKDIR /challenge

# Install dependencies
RUN pip install --no-cache-dir pycryptodome flask

# Copy challenge files
COPY server.py flag.txt ./

# Create non-root user
RUN adduser -D -u 1000 ctf
RUN chown -R ctf:ctf /challenge
RUN chmod 400 flag.txt

USER ctf

EXPOSE 5000

CMD ["python", "server.py"]
