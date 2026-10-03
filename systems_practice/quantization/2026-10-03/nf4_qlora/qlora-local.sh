#!/bin/sh
set -eu
# 只允许本地已有模型/数据；使用固定版本原仓库CLI，缺任何输入就失败。
: "${QLORA_SOURCE:?set verified checkout path}"
: "${LOCAL_MODEL:?set existing local model directory}"
: "${LOCAL_DATA:?set local alpaca JSON/JSONL path}"
test -d "$LOCAL_MODEL"
test -f "$LOCAL_DATA"
test "$(git -C "$QLORA_SOURCE" rev-parse HEAD)" = 7f4e95a68dc076bea9b3a413d2b512eca6d004e5
lesson=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
mkdir -p "$lesson/build"
export HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1 HF_HOME="$lesson/build/hf" TORCH_CUDA_ARCH_LIST=11.0
python3 -c 'import torch; assert torch.cuda.get_device_capability() == (11,0), "Thor SM110 required"'
cd "$QLORA_SOURCE"
python3 qlora.py --model_name_or_path "$LOCAL_MODEL" --dataset "$LOCAL_DATA" \
 --dataset_format alpaca --output_dir "$lesson/build/qlora" --bits 4 --quant_type nf4 \
 --double_quant True --bf16 True --lora_r 4 --lora_alpha 8 --lora_dropout 0.0 \
 --max_steps 20 --per_device_train_batch_size 1 --gradient_accumulation_steps 1 \
 --source_max_len 32 --target_max_len 32 --eval_dataset_size 8 --do_train True --do_eval True \
 --evaluation_strategy steps --eval_steps 10 --save_steps 10 --report_to none
