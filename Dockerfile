FROM vllm/vllm-openai:latest

RUN pip install --no-cache-dir lmcache turboquant-vllm[vllm]

ENTRYPOINT ["python", "-m", "vllm.entrypoints.openai.api_server"]
