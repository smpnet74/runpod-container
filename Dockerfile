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
COPY authorized_keys /root/.ssh/authorized_keys
COPY authorized_keys /home/ubuntu/.ssh/authorized_keys

RUN chmod +x /root/setup_ssh.sh && \
    chmod 600 /root/.ssh/authorized_keys && \
    chmod 600 /home/ubuntu/.ssh/authorized_keys && \
    chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys

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

# Create a projects directory in the ubuntu user's home
RUN mkdir -p /home/ubuntu/projects && \
    chown -R ubuntu:ubuntu /home/ubuntu/projects

# Copy the projects directory contents from host to container
COPY --chown=ubuntu:ubuntu projects/ /home/ubuntu/projects/

WORKDIR /home/ubuntu/projects

# Expose SSH port
EXPOSE 22

# Start SSH service when container launches
CMD ["/usr/sbin/sshd", "-D"]
