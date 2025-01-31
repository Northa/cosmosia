### setup swarm cluster
Follow [Getting started with swarm mode](https://docs.docker.com/engine/swarm/swarm-tutorial/) tutorial to setup a swarm cluster

```bash
# set utc timezone
timedatectl set-timezone UTC

# set resource limits
echo "root hard nofile 500000" >> /etc/security/limits.conf
echo "root soft nofile 500000" >> /etc/security/limits.conf
echo "* hard nofile  500000" >> /etc/security/limits.conf
echo "* soft nofile 500000" >> /etc/security/limits.conf
```

#### config log rotation
- config log rotation on all swarm nodes by editing (creating if not exist) the file `/etc/docker/daemon.json` with the content bellow.
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

- Then restart docker:
```bash
systemctl restart docker
```

### setup cosmosia

- create `cosmosia` overlay network:

```bash
docker network create -d overlay --attachable cosmosia
```

- clone repos to a manager node to $HOME:
```bash
cd $HOME
git clone https://github.com/notional-labs/cosmosia
```

### LVM
see [LVM](./lvm.md)
