# RunPod Container with Miniconda and SSH

This repository contains a Dockerfile for creating a RunPod-compatible container with:

- Ubuntu (latest version)
- Miniconda
- SSH server configured for RunPod compatibility
- Ubuntu user with sudo privileges

## Setup After Cloning

After cloning this repository, you need to create an `authorized_keys` file with your SSH public key:

```bash
# Create the authorized_keys file with your SSH public key
cp ~/.ssh/id_ed25519.pub authorized_keys
# Or manually create the file
echo "ssh-ed25519 YOUR_SSH_PUBLIC_KEY_HERE your_email@example.com" > authorized_keys
```

This file is excluded from git via .gitignore for security reasons.

## Building the Container

To build the container locally:

```bash
docker build -t runpod-scottsdev:latest .
```

## Pushing to Docker Hub

If you want to use this container on RunPod, you'll need to push it to a container registry:

```bash
# Tag the image
docker tag runpod-scottsdev:latest yourusername/runpod-scottsdev:latest

# Push to Docker Hub
docker push yourusername/runpod-scottsdev:latest
```

## Using on RunPod

1. Log into your RunPod account
2. Create a new pod with a custom container
3. Enter your Docker Hub image URL: `yourusername/runpod-scottsdev:latest`
4. Connect via RunPod SSH feature

## Features

- **Miniconda**: Pre-installed at `/opt/conda`
- **SSH Access**: Compatible with RunPod's SSH feature
- **Ubuntu User**: Pre-configured ubuntu user with sudo privileges
- **SSH Key Authentication**: Your SSH key is pre-installed for both root and ubuntu users
- **Workspace Directory**: Container includes a `/workspace` directory for your projects

## Customization

You can modify the Dockerfile to add additional packages or configurations as needed.

## Notes

- The container automatically starts the SSH server
- Your SSH key is pre-installed for both root and ubuntu users
- The ubuntu user has sudo privileges (no password required)
- RunPod will also handle additional SSH key injection for secure access
