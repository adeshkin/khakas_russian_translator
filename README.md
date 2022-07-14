# Translator 
1. **Khakas - russian**
2. **Russian - khakas**

> Khakas is a Turkic language spoken by the Khakas people, who mainly live in the southwestern Siberian Khakas Republic, in Russia. The Khakas number 73,000, of whom 42,000 speak the Khakas language. Most of Khakas speakers are bilingual in Russian.

### Libraries:
- [fairseq](https://github.com/pytorch/fairseq)
- [subword-nmt](https://github.com/rsennrich/subword-nmt)

### Usage:
- Pipeline [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1CcW4NMZlw1vGCGWLhEaJuPr7ueR8KIWO?usp=sharing)
<details>
  <summary>Environment setup</summary>

```bash
https://github.com/adeshkin/khakas_russian_translator.git 
cd khakas_russian_translator
python3 -m venv ./venv
source venv/bin/activate
pip install -r requirements.txt
```
</details>

<details>
  <summary>Data layout</summary>


1. Splitting into training, validation and test samples;
2. Word tokenization (ex., `nltk.tokenize.WordPunctTokenizer`);
3. Joining parent and child training samples to create shared dictionary and put them into directory `all`.

```
experiments
    data
        tok_data
            all
                ru.train.tok
                kaz_khak.train.tok
            parent
                ru.train.tok
                kaz.train.tok
                ru.valid.tok
                kaz.valid.tok
                ru.test.tok
                kaz.test.tok
            child_with_noisy
                ru.train.tok
                khak.train.tok
                ru.valid.tok
                khak.valid.tok
                ru.test.tok
                khak.test.tok 
            mono 
                ru.tok
                khak.tok
```
</details>

<details>
  <summary>From scratch</summary>

```bash
cd from_scratch
bash prepare_data.sh
bash train.sh
```

</details>

<details>
  <summary>Transfer learning</summary>

```bash
cd transfer_learning
bash prepare_data.sh
bash train.sh
bash finetune.sh
```

</details>

<details>
  <summary>Transfer learning + Backtranslation</summary>

```bash
cd transfer_learning
bash prepare_data.sh
bash train.sh
bash finetune.sh

cd backtranslation
bash prepare_mono.sh
bash translate_mono.sh
bash prepare_data.sh
bash finetune.sh
```
</details>

<details>
  <summary>Evaluation</summary>

```bash
cd transfer_learning
bash evaluate.sh
```
</details>

### Data: 
**Number of sentences:**

|                | train | valid | test | 
|:--------------:|:-----:|:-----:|:----:|
| kazakh-russian |  1M   |  1k   |  1k  |
| khakas-russian |  29k  |  1k   |  1k  |
|    khakas*     | 150k  |   -   |  -   |
|    russian*    | 739k  |   -   |  -   |

**monolingual*

### Experimental results:
**BLEU scores:**

|                |    Model    | From scratch | Transfer learning | Transfer learning <br/> + Backtranslation | 
|:--------------:|:-----------:|:------------:|:-----------------:|:-----------------------------------------:|
| khakas-russian | transformer |     2.37     |       17.78       |                   18.73                   |
|                |    lstm     |     5.68     |       8.32        |                   9.41                    |
| russian-khakas | transformer |     2.85     |       17.20       |                   20.24                   |
|                |    lstm     |     6.95     |       9.09        |                   12.40                   |



**Examples by transformer:**

| Ground truth                                  | Transfer learning                                                | Transfer learning <br/> + Backtranslation                | 
|:----------------------------------------------|:-----------------------------------------------------------------|:---------------------------------------------------------|
| Сейчас он пасет более семисот овец .          | Сейчас он стал пасти овец более семи раз .                       | В настоящее время он пасет отару более семи сотен овец . |
| Кто скажет , что завтра будет хорошая жизнь ? | Кто скажет , завтра будет хорошая жизнь ?                        | Кто скажет , что завтра будет хорошая жизнь ?            |
| Вот когда настал долгожданный радостный час ! | Вот когда - нибудь добренно , радостно , когда наступило время ! | Вот когда пришло радостное время !                       |



### References:
* Data:
  * [TIL Corpus](https://github.com/turkic-interlingua/til-mt/tree/master/til_corpus)
* Code:
  * [Translation](https://github.com/pytorch/fairseq/tree/main/examples/translation)
  * [Backtranslation](https://github.com/pytorch/fairseq/tree/main/examples/backtranslation)
* Papers:
  * [Understanding Back-Translation at Scale](https://arxiv.org/abs/1808.09381)
* Articles:
  * [Передача знания и Нейронный машинный перевод на практике](https://habr.com/ru/post/475750/)
  * [Обратный перевод для Нейронного машинного перевода](https://habr.com/ru/post/491794/)

### Future work:
* [Выравнивание параллельных текстов для малоресурсных языков](https://habr.com/ru/post/581272/)
* [Optimizing Transformer for Low-Resource Neural Machine Translation](https://arxiv.org/abs/2011.02266)
* [Tagged Back-Translation](https://arxiv.org/abs/1906.06442)
