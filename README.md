# ccminer-docker

[![GitHub](https://img.shields.io/github/license/ebiiim/ccminer-docker)](https://github.com/ebiiim/ccminer-docker/blob/main/LICENSE)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/ebiiim/ccminer-docker)](https://github.com/ebiiim/ccminer-docker/releases/latest)
[![Release](https://github.com/ebiiim/ccminer-docker/actions/workflows/release.yaml/badge.svg)](https://github.com/ebiiim/ccminer-docker/actions/workflows/release.yaml)


Yet another Docker image for [tpruvot/ccminer](https://github.com/tpruvot/ccminer) with Kubernetes support.

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

## Kubernetes

### Deploy with Kustomize

> 💡 Please make sure GPUs are enabled on your cluster.

First, download `kustomization.yaml` and copy your `config.json` to it.

```sh
curl -Lo https://raw.githubusercontent.com/ebiiim/ccminer-docker/main/k8s/kustomization.yaml
```

```diff
  patchesStrategicMerge:
    # [ConfigMap] Put your config.json here. {{hostname}} will be replaced with the hostname of the Node.
    - |-
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: ccminer-config
      data:
        config.json: |-
-         {
-           "algo": "lyra2v2",
-           "url": "stratum+tcp://hoge.example.com:9200",
-           "user": "hoge.ccminer-{{hostname}}",
-           "pass": "hoge"
-         }
+         PUT YOUR config.json HERE
```

Then create the namespace, 
```sh
kubectl create ns ccminer
```

and apply manifests.

```sh
kubectl apply -k kustomization.yaml
```

## Changelog

**1.0.0 - 2023-03-??**

- initial release
- tpruvot/ccminer: [1eb8dc686cbd93bd1692a3ae1ca0840c9e6547e5](https://github.com/tpruvot/ccminer/tree/1eb8dc686cbd93bd1692a3ae1ca0840c9e6547e5) 2020-12-13
