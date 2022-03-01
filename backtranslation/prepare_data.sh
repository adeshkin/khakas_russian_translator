#!/bin/bash

source_dir=/content/drive/MyDrive/khakas_russian_translator/experiments/data/bpe_data

for lang in 'khak' 'ru'
do
    src_lang=$lang
    tgt_lang='ru'
    if [[ $src_lang == 'ru' ]]; then
        tgt_lang='khak'
    fi

    # backtranslation
    bt_lang=$tgt_lang

    src_dict=$source_dir/mono/dict.$src_lang.txt
    tgt_dict=$source_dir/mono/dict.$tgt_lang.txt

    echo "fairseq-preprocess: ${src_lang}->${tgt_lang}..."
    fairseq-preprocess --source-lang $src_lang --target-lang $tgt_lang \
        --srcdict $src_dict --tgtdict $tgt_dict \
        --trainpref $save_dir/source_$bt_lang \
        --destdir $save_dir \
        --workers 20
done


PARA_DATA=$source_dir/child_with_noisy
BT_DATA=$source_dir/bt
COMB_DATA=$source_dir/child_with_noisy_plus_bt
mkdir $COMB_DATA

echo "copy files..."
for LANG in 'khak' 'ru'
do
    cp ${PARA_DATA}/dict.$LANG.txt ${COMB_DATA}/dict.$LANG.txt
    for EXT in bin idx
    do
        cp ${PARA_DATA}/train.ru-khak.$LANG.$EXT ${COMB_DATA}/train.ru-khak.$LANG.$EXT
        cp ${BT_DATA}/train.ru-khak.$LANG.$EXT ${COMB_DATA}/train1.ru-khak.$LANG.$EXT
        cp ${PARA_DATA}/valid.ru-khak.$LANG.$EXT ${COMB_DATA}/valid.ru-khak.$LANG.$EXT
        cp ${PARA_DATA}/test.ru-khak.$LANG.$EXT ${COMB_DATA}/test.ru-khak.$LANG.$EXT

        cp ${PARA_DATA}/train.khak-ru.$LANG.$EXT ${COMB_DATA}/train.khak-ru.$LANG.$EXT
        cp ${BT_DATA}/train.khak-ru.$LANG.$EXT ${COMB_DATA}/train1.khak-ru.$LANG.$EXT
        cp ${PARA_DATA}/valid.khak-ru.$LANG.$EXT ${COMB_DATA}/valid.khak-ru.$LANG.$EXT
        cp ${PARA_DATA}/test.khak-ru.$LANG.$EXT ${COMB_DATA}/test.khak-ru.$LANG.$EXT
    done
done