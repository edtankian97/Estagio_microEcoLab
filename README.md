# Estagio_microEcoLab
Direção para curso de inverno


# Análise de sequências usando BLAST e HMMER

## Programas que serão necessários para download

### 1.1 Conda

### vá até o site do [Anaconda]([https://www.anaconda.com/download/success](https://www.anaconda.com/docs/getting-started/miniconda/install#linux-terminal-installer)

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

### comandos que vamos usar
```


```
