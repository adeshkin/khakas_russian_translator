#!/bin/bash


arch='transformer_iwslt_de_en'
src_lang='ru'
tgt_lang='kaz'
source_dir=/content/drive/MyDrive/khakas_russian_translator/experiments
data_dir=$source_dir/data/bpe_data/parent
save_dir=$source_dir/checkpoints/$arch/"$src_lang"2"$tgt_lang"
mkdir -p $save_dir


fairseq-train \
    $data_dir \
    -s $src_lang \
    -t $tgt_lang \
    --max-epoch 3 \
    --no-epoch-checkpoints \
    --arch $arch --share-decoder-input-output-embed \
    --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
    --lr 5e-4 --lr-scheduler inverse_sqrt --warmup-updates 4000 \
    --dropout 0.3 --weight-decay 0.0001 \
    --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
    --max-tokens 4096 \
    --best-checkpoint-metric 'ppl' \
    --save-dir $save_dir