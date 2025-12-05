FROM python:3.11-slim

# Install socat for TCP service
RUN apt-get update && apt-get install -y \
    socat \
    && rm -rf /var/lib/apt/lists/*

# Create challenge directory
WORKDIR /challenge

# Copy challenge files
COPY challenge.py /challenge/challenge.py

# Make the challenge executable
RUN chmod +x /challenge/challenge.py

# Create a non-root user for security
RUN useradd -m -s /bin/bash ctfuser

# Set ownership
RUN chown -R ctfuser:ctfuser /challenge

# The FLAG environment variable will be injected by CTFd docker_challenges plugin
# Default flag for testing only
ENV FLAG="L3m0nCTF{default_test_flag}"

# Expose the challenge port
EXPOSE 9000

# Run the challenge server using socat
# socat will spawn the Python script for each incoming connection
USER ctfuser
CMD ["socat", "-T60", "TCP-LISTEN:9000,reuseaddr,fork", "EXEC:python3 /challenge/challenge.py,pty,stderr,setsid,sigint,sane"]
