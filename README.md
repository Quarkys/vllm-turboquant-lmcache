# vLLM + TurboQuant + LMCache

Minimal image: the container sets only the vLLM OpenAI server entrypoint, and all model and KV options are passed at `docker run` time.

## Build

```bash
./build.sh
```

Or directly:

```bash
docker build -t joaoeudes7/vllm-turboquant-lmcache:latest -f Dockerfile .
```

Override the tag if needed:

```bash
IMAGE_TAG=v0.1.0 ./build.sh
```

## Push

```bash
./push.sh
```

Or directly:

```bash
docker push joaoeudes7/vllm-turboquant-lmcache:latest
```

## Run

Recommended flags for RTX 4090:

```bash
docker run --runtime nvidia --gpus all \
  --shm-size=16g --ipc=host \
  -p 8000:8000 \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -e HF_TOKEN=your_hf_token_here \
  joaoeudes7/vllm-turboquant-lmcache:latest \
  --model Qwen/Qwen3-14B \
  --kv-cache-dtype turboquant_k8v4 \
  --enable-prefix-caching \
  --kv-transfer-config '{"kv_connector":"LMCacheConnectorV1","kv_role":"kv_both"}' \
  --gpu-memory-utilization 0.87 \
  --max-model-len 131072 \
  --max-num-batched-tokens 8192
```

More aggressive variant:

```bash
docker run --runtime nvidia --gpus all \
  --shm-size=16g --ipc=host \
  -p 8000:8000 \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -e HF_TOKEN=your_hf_token_here \
  joaoeudes7/vllm-turboquant-lmcache:latest \
  --model Qwen/Qwen3-14B \
  --kv-cache-dtype turboquant_4bit_nc \
  --enable-prefix-caching \
  --kv-transfer-config '{"kv_connector":"LMCacheConnectorV1","kv_role":"kv_both"}' \
  --gpu-memory-utilization 0.87 \
  --max-model-len 131072 \
  --max-num-batched-tokens 8192
```

## KV Variants

- `turboquant_k8v4`: best starting point for 4090, asymmetric K/V with stronger key precision
- `turboquant_4bit_nc`: default sweet spot for long context
- `turboquant_k3v4_nc`: more aggressive memory savings
- `turboquant_3bit_nc`: extreme compression, validate output quality first

## Notes

- Pass any extra vLLM flags after the image name, for example `--enforce-eager`
- LMCache is enabled by passing `--kv-transfer-config`
- This image does not bake in model-specific defaults
