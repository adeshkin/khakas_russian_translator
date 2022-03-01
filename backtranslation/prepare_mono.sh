#!/bin/bash

source_dir=/content/drive/MyDrive/khakas_russian_translator/experiments/data
voc_thr=50
bpe_dir=$source_dir/bpe_data
dict_part='all'

part='mono'
tok_dir=$source_dir/tok_data/mono
mkdir $bpe_dir/$part

for lang in 'khak' 'ru'
do
    echo "apply_bpe.py to ${part}: ${lang}..."
    subword-nmt apply-bpe -c $bpe_dir/bpe.codes \
        --vocabulary $bpe_dir/bpe.vocab.$lang \
        --vocabulary-threshold $voc_thr < $tok_dir/$lang.tok > $bpe_dir/$part/mono.$lang
done


data_dir=$bpe_dir/$part

for lang in 'khak' 'ru'
do
    src_lang=$lang
    tgt_lang='ru'
    if [[ $src_lang == 'ru' ]]; then
        tgt_lang='khak'
    fi

    src_dict=$bpe_dir/$dict_part/dict.$src_lang.txt

    echo "fairseq-preprocess to ${part}: ${src_lang}->${tgt_lang}..."
    fairseq-preprocess \
        --only-source \
        --source-lang $src_lang --target-lang $tgt_lang \
        --srcdict $src_dict \
        --testpref $data_dir/mono \
        --destdir $data_dir \
        --workers 20
done