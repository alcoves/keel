# keel
The infrastructure that powers bken.io

## Initialize Terraform

- Create a terraform.tfvars file with the digitalocean token inside

```
tf init
tf plan
tf apply
```

## Deployment

### Initialize Droplet

```
ssh new-drop
doctl registry login
sudo apt update
sudo apt install -y zip unzip curl htop wget docker.io
sudo apt autoremove -y

# Install doctl
sudo snap install doctl
sudo snap connect doctl:dot-docker
doctl auth init
```

### Reef

Reef is deployed via Docker

```
ssh reef
doctl registry login
docker pull registry.digitalocean.com/bken/reef:latest
docker stop reef
docker run --name reef -p 80:3100 registry.digitalocean.com/bken/reef:latest
```

### API

Pier is deployed via Docker

```
ssh pier
docker pull registry.digitalocean.com/bken/pier:pier
docker stop pier
docker run --name pier -p 80:3200 registry.digitalocean.com/bken/pier:latest
```