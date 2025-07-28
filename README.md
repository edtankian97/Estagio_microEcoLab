# Estagio_microEcoLab
Direção para curso de inverno


# Análise de sequências usando BLAST e HMMER

## Programas que serão necessários para download

### 1.1 Conda

### vá até o site do [Anaconda](https://www.anaconda.com/docs/getting-started/miniconda/install#linux-terminal-installer)

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

### Vamos criar um ambiente conda e instalar o python na versão 3.12

```
conda create --name estagio_ecolab python=3.12
```

### Em seguida, vamos ativar o ambiente conda
```
conda activate estagio_ecolab
```

### 1.2 BLAST, CD_HIT, MAFFT, PROKKA

```
conda install bioconda::blast
conda install bioconda::mafft
conda install bioconda::cd-hit
conda install -c conda-forge ncbi-datasets-cli
conda install bioconda::hmmer
```

##1.2 CD_HIT

### vamos ver primeiro os comandos do cd-hit

```
cd-hit --help

```

### [comandos](https://www.bioinformatics.org/cd-hit/cd-hit-user-guide) que vamos usar
```
mkdir cd_hit_results
cd-hit -i PATH/TO/OUTPUT/FILE/[NAME_OF_INPUT_FILE] -o [output_file_name]  -c 1.00 -n 5
mv [output_file_name] ./cd_hit_results

```
### cansativo fazer um por um, não é?! Então, vamos aprender a fazer isso de maneira mais automatizada
```
#! bin/bash

for file in ./*fasta; do
OUTPUT= basename $file .fasta 

cd-hit -i $file -o $OUTPUT"_out"  -c 1.00 -n 5
mv $OUTPUT"_out" ./cd_hit_results
done
```

### Passando esta parte, vamos fazer o alinhamento para HMMER usando o mafft. Primeiro, vamos ver seus comandos

```
mafft --help
```

### comando para alinhamento com o mafft
```
cd cd_hit_results
mkdir mafft_results
mafft --auto --thread -5 ./[FILE_OF_CD_HIT_RESULT] > [OUTPUT_FILE_MAFFT].fasta 
mv [OUTPUT_FILE_MAFFT].fasta   ./mafft_results
```

### Agora tente fazer isto para vários arquivos
```
nano meu_primeiro_script.sh
```
### rode seu primeiro script
```
bash meu_primeiro_script.sh
```
### Agora vamos rodar o HMMER. Primeiro temos que construir o modelo baseado no alinhamento
```
mkdir hmmer_results
hmmbuild --help
hmmbuild  "$output_file" "$mafft_file" 
```
### Agora novamente faça um script para rodar isso
```
nano script_hmmer.sh
bash script_hmmer.sh
```

### Vamos baixar os genomas de interesse. Tem arquivo no [repositório](https://github.com/edtankian97/microbiota_sialylation/tree/main/genomes_download/control_proteins) Baixe todos os arquivos.
```
mkdir proteins_data
datasets --help
datasets download --help
datasets download genome accession --inputfile control_proteomes.txt --include protein
unzip ncbi_datasets.zip
```

### Vemos que os arquivos têm nome parecidos: "protein.faa". Vamos renomear-los baseado em seus respectivos diretórios
```
nano rename_file.sh
bash rename_file.sh
```
### Agora vamos rodar o hmmsearch
```
 hmmsearch --cpu 15 --domtblout "$output_file" "$hmm_file" "$seq_file"
```
### análise de uma sequência. Ops! não tem como identificar, né?! rsrs. Para isso, vamos renomear o cabeçalho do arquivo 
```
nano rename_fasta.sh
bash rename_fasta.sh
```

## BLAST

### Vamos fazer a análise no blast. Primeiro vamos ver os comandos
```
makeblastdb -h

```
### Primeiro, temos que fazer o banco de dados das sequências de interesse. 
```
makeblastdb -dbtype prot -in [name_of_protein_fasta_file] -out banco_blast

```
### Vamos ver os comandos do blastp e rodar para análise
```
blastp -h
blastp
blastp -db ./banco_blast/banco_blast -query ./ncbi_dataset/data/GCF_000689235.1_renamed.faa -out blast_CMP_result  -outfmt "6  qseqid sseqid qlen qstart qend evalue bitscore length pident ppos"
```
### tarefa - fazer isso para vários input
```

```


