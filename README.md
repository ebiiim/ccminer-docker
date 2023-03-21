# ccminer-docker

Yet another Docker image for [tpruvot/ccminer](https://github.com/tpruvot/ccminer).

## Usage

**Start mining**

> 💡 Please read [ccminer docs](https://github.com/tpruvot/ccminer/blob/linux/README.txt) before using this image.

```sh
docker run --rm --gpus all \
  ghcr.io/ebiiim/ccminer \
  -a lyra2v2 \
  -o stratum+tcp://example.com:9200 \
  -u username \
  -p password
```

**Start mining with `config.json`**

```sh
docker run --rm --gpus all \
  -v "$(pwd)"/config.json:/work/config.json \
  ghcr.io/ebiiim/ccminer \
  -c config.json
```
