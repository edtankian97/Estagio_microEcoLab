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
conda install -c bioconda phylophlan
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
### vamos adicionar cabeçalho ao arquivo
```
HEADER="qseqid\tsseqid\tqlen\tqstart\tqend\tevalue\tbitscore\tlength\tpident\tppos"
cat blast_CMP_result >> new_file.tsv
```

### tarefa - fazer isso para vários input
```
nano blast_data.sh
bash blast_data.sh
```

### Vamos preparar os resultados do HMMER
### Primeiro, vamos concatenar os resultados do coverage
```
cat *_coverage > all_coverage
```

### Siga a etapa do R para cobertura e filtre no bash, os arquivos a serem submetidos
```
for file in $(cat ./CMP_complete_cover_filter_40.tsv); do mv "$file" ./filter_cover_CMP/; done
cd filter_cover_CMP
cat CMP*output > all_CMP_output.tsv
sed -i '/#/d' all_CMP_output.tsv
sed  's/ \{1,\}/\t/g' all_CMP_output.tsv > file_output_CMP.tsv
```

### Faça a mesma etapa, só que para a sialiltransferase
### Siga o passo para filtragem do R por e-value e bit-score


### Agora que você descobriu quem tem o passo de sialilação, vamos fazer a árvore com phylophlan. 

### Primeiro vamos baixar o banco de dados do phylophlan
```
cd proteins/
mkdir protein_tree && cd protein_tree
mkdir phylophlan_database && cd phylophlan_database
wget https://zenodo.org/record/4005620/files/phylophlan.tar?download=1
tar -xf phylophlan.tar
bunzip2 -k phylophlan/phylophlan.faa.bz2
cd ..

```
### Vamos configurar a forma como vamos fazer a análise

```
phylophlan_write_config_file.py --db_aa diamond --map_aa diamond --msa mafft \
--trim trimal --tree1 fasttree --tree2 raxml -o genome_estagio_config.cfg \
--db_type a
```

### Rode a análise (copie e cole o script abaixo e coloque o arquivo do script em um diretório abaixo do diretório "proteins")
```
#! bin/bash


phylophlan -i ./proteins --db_type a -d phylophlan --databases_folder ./proteins/protein_tree/phylophlan_database/ --diversity low --accurate -f ./proteins/protein_tree/genome_ed_config.cfg -o ./proteins/protein_tree/phylo_result/  --nproc 15  --verbose 2>&1 | tee ./proteins/protein_tree/logs/phylophlan_output_phylophlan.log
```

### Pegue o resultado da árvore e submeta no iTOL

### Tarefa - anotação de árvore: 1. quem é Gram positiva e Gram negativa; 2. Virulência; 3. Presença ou ausência de sialilação

### Passo para virulência: Fazer manualmente ou por análise de bioinfo (devemos baixar os genomas das bactérias)
```
conda install -c conda-forge -c bioconda -c defaults abricate

abricate ./genomes_unique/ --db vfdb --csv --minid 70 --mincov 60 > out_70id_60cov.csv
mv out_70id_60cov.csv ../plots_data/itol/

```
https://github.com/biobakery/phylophlan/wiki#databases
