FROM --platform=linux/amd64 ubuntu:latest

# Set non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    vim \
    openssh-server \
    sudo \
    python3 \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Setup SSH for RunPod compatibility
RUN mkdir -p /run/sshd

# Setup ubuntu user with sudo privileges
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu

# Setup SSH for both root and ubuntu user
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
RUN mkdir -p /home/ubuntu/.ssh && chmod 700 /home/ubuntu/.ssh && chown ubuntu:ubuntu /home/ubuntu/.ssh

COPY setup_ssh.sh /root/setup_ssh.sh

# Create empty authorized_keys files if they don't exist
RUN touch /root/.ssh/authorized_keys && \
    touch /home/ubuntu/.ssh/authorized_keys && \
    chmod +x /root/setup_ssh.sh && \
    chmod 600 /root/.ssh/authorized_keys && \
    chmod 600 /home/ubuntu/.ssh/authorized_keys && \
    chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys

# Copy authorized_keys if it exists (will be skipped in CI/CD if file doesn't exist)
COPY authorized_keys* /root/.ssh/
COPY authorized_keys* /home/ubuntu/.ssh/

# Install Miniconda
RUN curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# Make conda accessible system-wide
ENV PATH="/opt/conda/bin:${PATH}"

# Set up conda for ubuntu user with a simpler approach
RUN mkdir -p /home/ubuntu/.conda && \
    mkdir -p /home/ubuntu/.local/bin && \
    echo 'export PATH="/home/ubuntu/.local/bin:/opt/conda/bin:$PATH"' >> /home/ubuntu/.bashrc && \
    echo '. /opt/conda/etc/profile.d/conda.sh' >> /home/ubuntu/.bashrc && \
    echo 'conda activate base' >> /home/ubuntu/.bashrc && \
    chown -R ubuntu:ubuntu /home/ubuntu/.conda && \
    chown -R ubuntu:ubuntu /home/ubuntu/.local && \
    chown ubuntu:ubuntu /home/ubuntu/.bashrc

# Create a workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Expose SSH port
EXPOSE 22

# Start SSH service when container launches
CMD ["/usr/sbin/sshd", "-D"]
