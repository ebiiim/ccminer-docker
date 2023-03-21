# ccminer-docker

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
