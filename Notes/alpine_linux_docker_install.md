# Install Docker on Alpine Linux

## Step 1: Enable the Community Repository
Docker is available in Alpine's community repository. Enable it by running:

```sh
echo "https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
apk update
```

## Step 2: Install Docker
Once the repository is enabled, install Docker:

```sh
apk add docker
```

To install `docker-compose`, run:

```sh
apk add docker-compose
```

## Step 3: Start and Enable Docker
After installation, start and enable the Docker service:

```sh
service docker start
rc-update add docker boot
```

## Step 4: Verify Docker Installation
Check if Docker is running properly:

```sh
docker info
```

Run a test container to confirm Docker is working:

```sh
docker run hello-world
```

If you see a confirmation message from Docker, the installation was successful!

---

### Notes:
- Ensure you have root privileges or use `sudo` where necessary.
- If the `apk add docker` command fails, double-check that the community repository is correctly added.
