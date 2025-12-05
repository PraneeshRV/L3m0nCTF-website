FROM ubuntu:22.04

# Install necessary tools
RUN apt-get update && apt-get install -y \
    socat \
    gcc \
    python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /challenge

# Copy challenge files
COPY vuln.c flag.txt ./

# Compile the vulnerable binary with specific flags to make it exploitable
RUN gcc -fno-stack-protector -z execstack -no-pie -o vuln vuln.c

# Create non-root user
RUN useradd -m -u 1000 ctf
RUN chown -R ctf:ctf /challenge
RUN chmod 400 flag.txt
RUN chmod +x vuln

USER ctf

EXPOSE 9000

# Serve the binary over TCP
CMD ["socat", "TCP-LISTEN:9000,fork,reuseaddr", "EXEC:./vuln,stderr"]
