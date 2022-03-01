#!/bin/bash


arch='transformer_iwslt_de_en'
src_lang='ru'
tgt_lang='khak'

source_dir=/content/drive/MyDrive/khakas_russian_translator/experiments
data_dir=$source_dir/data/bpe_data/child_with_noisy
path=$source_dir/checkpoints/$arch/"$src_lang"2"$tgt_lang"/checkpoint_best.pt


fairseq-generate $data_dir \
    --source-lang $src_lang \
    --target-lang $tgt_lang \
    --path $path \
    --beam 5 --remove-bpe --quiet --scoring bleu
