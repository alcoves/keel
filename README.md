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
docker rm reef
docker run -d --name reef -p 80:3000 registry.digitalocean.com/bken/reef:latest
```

### API

Pier is deployed via Docker

```
ssh pier
docker pull registry.digitalocean.com/bken/pier:pier
docker stop pier
docker rm pier
docker run -d --name pier -p 80:3200 registry.digitalocean.com/bken/pier:latest
```

### Bootstrapping a cluster

- Start by creating leader and worker servers
- Once provisioned, in order to use the nomad provider we have to gain access
- Temporarily point the nomad provider to http address
- Configure nomad jobs
- Change Nomad provider to https with auth once fabio is configured

### Dockerfiles

aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 594206825329.dkr.ecr.us-east-2.amazonaws.com

```
docker build --file docker/ffmpeg.Dockerfile --platform linux/amd64 -t ffmpeg .
docker tag ffmpeg:latest 594206825329.dkr.ecr.us-east-2.amazonaws.com/ffmpeg:latest
docker push 594206825329.dkr.ecr.us-east-2.amazonaws.com/ffmpeg:latest
```

Test locally

```
docker run -p 9000:8080 ffmpeg
curl -XPOST \
"http://localhost:9000/2015-03-31/functions/echo/invocations" \
-d 'Hello from Container Lambda!'
```



nomad job dispatch \
  -meta "input=/mnt/houston/shack/media/gaming/tests/input.mkv" \
  -meta "output=/mnt/houston/shack/media/gaming/tests/output.mkv" \
  transcode

nomad job dispatch transcode