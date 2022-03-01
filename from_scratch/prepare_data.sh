#!/bin/bash


source_dir=/content/drive/MyDrive/khakas_russian_translator/experiments/data
num_operations=10000
voc_thr=50
bpe_dir=$source_dir/bpe_data_khak_ru
mkdir $bpe_dir


part='child_with_noisy'
tok_dir=$source_dir/tok_data/$part
mkdir $bpe_dir/$part

echo "learn_bpe.py on ${part}..."
subword-nmt learn-joint-bpe-and-vocab \
    --input $tok_dir/khak.train.tok $tok_dir/ru.train.tok \
    -s $num_operations \
    -o $bpe_dir/bpe.codes \
    --write-vocabulary $bpe_dir/bpe.vocab.khak $bpe_dir/bpe.vocab.ru


for lang in 'khak' 'ru'
do
  for mode in 'train' 'valid' 'test'
  do
      echo "apply_bpe.py to ${part}: ${lang}.${mode}..."
      subword-nmt apply-bpe -c $bpe_dir/bpe.codes \
          --vocabulary $bpe_dir/bpe.vocab.$lang \
          --vocabulary-threshold $voc_thr < $tok_dir/$lang.$mode.tok > $bpe_dir/$part/$mode.$lang
  done
done


data_dir=$bpe_dir/$part
src_lang='khak'
tgt_lang='ru'

echo "fairseq-preprocess to ${part}: ${src_lang}->${tgt_lang}..."
fairseq-preprocess --source-lang $src_lang --target-lang $tgt_lang \
    --trainpref $data_dir/train \
    --destdir $data_dir \
    --workers 20


src_lang='ru'
tgt_lang='khak'
src_dict=$bpe_dir/$part/dict.$src_lang.txt
tgt_dict=$bpe_dir/$part/dict.$tgt_lang.txt

echo "fairseq-preprocess to ${part}: ${src_lang}->${tgt_lang}..."
fairseq-preprocess --source-lang $src_lang --target-lang $tgt_lang \
    --srcdict $src_dict --tgtdict $tgt_dict \
    --trainpref $data_dir/train \
    --destdir $data_dir \
    --workers 20


for lang in 'khak' 'ru'
do
    src_lang=$lang
    tgt_lang='ru'
    if [[ $src_lang == 'ru' ]]; then
        tgt_lang='khak'
    fi

    src_dict=$bpe_dir/$part/dict.$src_lang.txt
    tgt_dict=$bpe_dir/$part/dict.$tgt_lang.txt

    echo "fairseq-preprocess to ${part}: ${src_lang}->${tgt_lang}..."
    fairseq-preprocess --source-lang $src_lang --target-lang $tgt_lang \
        --srcdict $src_dict --tgtdict $tgt_dict \
        --validpref $data_dir/valid --testpref $data_dir/test \
        --destdir $data_dir \
        --workers 20
done