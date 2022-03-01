#!/bin/bash

arch='transformer_iwslt_de_en'
source_dir=/content/drive/MyDrive/khakas_russian_translator/experiments
data_dir=$source_dir/data/bpe_data/mono
model_dir=$source_dir/checkpoints/$arch
save_dir=$source_dir/data/bpe_data/bt
mkdir $save_dir


for lang in 'khak' 'ru'
do
    src_lang=$lang
    tgt_lang='ru'
    if [[ $src_lang == 'ru' ]]; then
        tgt_lang='khak'
    fi

    model_path=$model_dir/"$src_lang"2"$tgt_lang"/checkpoint_best.pt

    echo "fairseq-generate: ${src_lang}->${tgt_lang}..."
    fairseq-generate \
        $data_dir \
        --source-lang $src_lang \
        --target-lang $tgt_lang \
        --path $model_path \
        --skip-invalid-size-inputs-valid-test \
        --max-tokens 4096 \
        --beam 5 \
    > $save_dir/$lang.out

    echo "extract_bt_data.py: ${src_lang}->${tgt_lang}..."
    filepath=$save_dir/$src_lang.out
    python extract_bt_data.py \
        --minlen 2 --maxlen 250 --ratio 1.5 \
        --output $save_dir/source_$src_lang \
        --srclang $tgt_lang --tgtlang $src_lang \
        $filepath
done
