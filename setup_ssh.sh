#!/bin/bash

# This script configures SSH for RunPod compatibility

# Create the authorized_keys files if they don't exist
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

touch /home/ubuntu/.ssh/authorized_keys
chmod 600 /home/ubuntu/.ssh/authorized_keys
chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys

# If SSH_PUBLIC_KEY environment variable is set, add it to authorized_keys for both users
if [ ! -z "$SSH_PUBLIC_KEY" ]; then
    echo "$SSH_PUBLIC_KEY" >> /root/.ssh/authorized_keys
    echo "$SSH_PUBLIC_KEY" >> /home/ubuntu/.ssh/authorized_keys
    chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys
    echo "Added SSH public key from environment variable to both root and ubuntu users"
fi

# RunPod injects the public key through the runpod-ssh mechanism
# This script can be extended for additional SSH configuration

# Start SSH service
/usr/sbin/sshd -D
