vllm serve \
  --uvicorn-log-level=info \
  Qwen/Qwen3-30B-A3B-FP8 \
  --revision 4504c1329df104a4b299f0db05882e84da88830b \
  --host 0.0.0.0 \
  --port 8000 \
  --api-key h3110w0r1d \
  --enable-reasoning \
  --reasoning-parser deepseek_r1 \
  --gpu-memory-utilization 0.95 \
  --enable-auto-tool-choice \
  --tool-call-parser hermes \
  --max-model-len 131072 \
  --rope-scaling '{"rope_type": "yarn", "factor": 4.0, "original_max_position_embeddings": 32768}'

export VLLM_USE_V1=0