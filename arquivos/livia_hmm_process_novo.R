#HMM processing - Livia

#Library 
library(dplyr)
library(readr)
library(tidyr)
library(data.table)


#coverage_result

cover_CMP_livia_novo <-read.table("~/dados_Livia/fastq_files/novos_dados/Trimmomatic_result/Bowtie_result/unmapped_reads/flash_result/hmmer_results_Livia_sia/all_CMP_synthase_TYPE", 
                             header = FALSE, col.names = c("V1", "V2"))

head(cover_CMP_livia_novo)


cover_sialil_livia_novo <-read.table("~/dados_Livia/fastq_files/novos_dados/Trimmomatic_result/Bowtie_result/unmapped_reads/flash_result/hmmer_results_Livia_sia/all_sialil_old_gold_TYPE", 
                                header = FALSE, col.names = c("V1", "V2"))

head(cover_sialil_livia_novo)


cover_polisia_livia_novo <- read.table("~/dados_Livia/fastq_files/novos_dados/Trimmomatic_result/Bowtie_result/unmapped_reads/flash_result/hmmer_results_Livia_sia/all_polisia_TYPE", 
                                  header = FALSE, col.names = c("V1", "V2"))

cover_cazy_uniprot_novo <- read.table("~/dados_Livia/fastq_files/novos_dados/Trimmomatic_result/Bowtie_result/unmapped_reads/flash_result/hmmer_results_Livia_sia/all_sialil_caz_unip_TYPE",
                                 header = FALSE, col.names = c("V1", "V2"))

View(cover_cazy_uniprot_novo)


########################################################################################################################################

#filtering by coverage

#coverage by 40%

sialil_livia_cover_filter_novo <- cover_sialil_livia_novo %>% filter(cover_sialil_livia_novo$V1 >= 40.00)
CMP_sia_livia_cover_filter_novo <- cover_CMP_livia_novo %>% filter(cover_CMP_livia_novo$V1 >= 40.00)
poli_livia_cover_filter_novo <- cover_polisia_livia_novo %>% filter(cover_polisia_livia_novo$V1 >= 40.00)

cazy_uniprot_livia_cover_filter_novo <- cover_cazy_uniprot_novo %>% filter(cover_cazy_uniprot_novo$V1 >= 40.00)


#save result into a file

#write_tsv(CMP_cover_filter, "CMP_cover_filter.tsv")
write_tsv(CMP_sia_livia_cover_filter_novo, "~/dados_Livia/CD_HIT/hmmer_results_Livia_sia/hmm_all/CMP_livia_cover_filter_40_novo.tsv")

write_tsv(sialil_livia_cover_filter_novo, "~/dados_Livia/CD_HIT/hmmer_results_Livia_sia/hmm_all/sialil_livia_cover_filter_40_novo.tsv")

write_tsv(poli_livia_cover_filter_novo, "~/dados_Livia/CD_HIT/hmmer_results_Livia_sia/hmm_all/polisia_livia_cover_filter_40_novo.tsv")

write_tsv(cazy_uniprot_livia_cover_filter_novo, "~/dados_Livia/CD_HIT/hmmer_results_Livia_sia/hmm_all/cazy_uniprot_livia_cover_filter_40_novo.tsv")


###################################    HMMER result ####################################################################################
#Get data from CMP
View_CMP_out_novo <- fread("~/dados_Livia/fastq_files/novos_dados/Trimmomatic_result/Bowtie_result/unmapped_reads/flash_result/hmmer_results_Livia_sia/CMP_sia/all_CMP_synthase_novo.tsv",
                      fill=29)


View(View_CMP_out_novo)


View_CMP_out_novo <- View_CMP_out_novo[,-c(26:28)]

column_names <-c("target_ID", "accession_1", "tlen", "query_ID", "accession_2", "qlen", "e_value_seq",
                 "score_seq", "bias_seq", "#", "of", "c_value", "i_value", "score_dom", "bias_dom", 
                 "hmm_from", "hmm_to", "ali_from", "ali_to", "env_from", "env_to", "acc", "description",
                 "of_1", "target")

setnames(View_CMP_out_novo, column_names)


View_CMP_process_novo <-  View_CMP_out_novo  %>% distinct(View_CMP_out_novo$target_ID, .keep_all = TRUE)

final_CMP_process_novo <-View_CMP_process_novo %>% 
  filter(View_CMP_process_novo$e_value_seq <= 0.001 & View_CMP_process_novo$score_seq >= 50.0)

head(final_CMP_process_novo)


######################################sialil #######################################

View_sialil_out_novo <- fread("~/dados_Livia/fastq_files/novos_dados/Trimmomatic_result/Bowtie_result/unmapped_reads/flash_result/hmmer_results_Livia_sia/sialil/all_sialil_old_gold_novo.tsv",
                           fill=29)


View(View_sialil_out_novo)


#View_sialil_out_novo <- View_sialil_out_novo[,-c(27:29)]

column_names <-c("target_ID", "accession_1", "tlen", "query_ID", "accession_2", "qlen", "e_value_seq",
                 "score_seq", "bias_seq", "#", "of", "c_value", "i_value", "score_dom", "bias_dom", 
                 "hmm_from", "hmm_to", "ali_from", "ali_to", "env_from", "env_to", "acc", "description",
                 "of_1", "target")

setnames(View_sialil_out_novo, column_names)


View_sialil_process_novo <-  View_sialil_out_novo  %>% distinct(View_sialil_out_novo$target_ID, .keep_all = TRUE)

final_sialil_process_novo <-View_sialil_process_novo %>% 
  filter(View_sialil_process_novo$e_value_seq <= 0.001 & View_sialil_process_novo$score_seq >= 50.0)

head(final_sialil_process_novo)


################################################# polisia ##############################################################################


View_polisia_out_novo <- fread("~/dados_Livia/fastq_files/novos_dados/Trimmomatic_result/Bowtie_result/unmapped_reads/flash_result/hmmer_results_Livia_sia/polisia/all_polisia_novo.tsv",
                              fill=28)


View(View_polisia_out_novo)


View_polisia_out_novo <- View_polisia_out_novo[,-c(26:28)]

column_names <-c("target_ID", "accession_1", "tlen", "query_ID", "accession_2", "qlen", "e_value_seq",
                 "score_seq", "bias_seq", "#", "of", "c_value", "i_value", "score_dom", "bias_dom", 
                 "hmm_from", "hmm_to", "ali_from", "ali_to", "env_from", "env_to", "acc", "description",
                 "of_1", "target")

setnames(View_polisia_out_novo, column_names)


View_polisia_process_novo <-  View_polisia_out_novo %>% distinct(View_polisia_out_novo$target_ID, .keep_all = TRUE)

final_polisia_process_novo <-View_polisia_process_novo %>% 
  filter(View_polisia_process_novo$e_value_seq <= 0.001 & View_polisia_process_novo$score_seq >= 50.0)

head(final_polisia_process_novo)

#####################################  caz + uniprot


View_caz_uni_out_novo <- fread("~/dados_Livia/fastq_files/novos_dados/Trimmomatic_result/Bowtie_result/unmapped_reads/flash_result/hmmer_results_Livia_sia/caz_uniprot/all_sialil_caz_uni.tsv",
                               fill=28)


View(View_caz_uni_out_novo)


View_caz_uni_out_novo <- View_caz_uni_out_novo[,-c(26:27)]

column_names <-c("target_ID", "accession_1", "tlen", "query_ID", "accession_2", "qlen", "e_value_seq",
                 "score_seq", "bias_seq", "#", "of", "c_value", "i_value", "score_dom", "bias_dom", 
                 "hmm_from", "hmm_to", "ali_from", "ali_to", "env_from", "env_to", "acc", "description",
                 "of_1", "target")

setnames(View_caz_uni_out_novo, column_names)


View_caz_uni_process_novo <-  View_caz_uni_out_novo %>% distinct(View_caz_uni_out_novo$target_ID, .keep_all = TRUE)

final_caz_uni_process_novo <-View_caz_uni_process_novo %>% 
  filter(View_caz_uni_process_novo$e_value_seq <= 0.001 & View_caz_uni_process_novo$score_seq >= 50.0)

head(final_caz_uni_process_novo)


###############see what is commom ######################################################

#See uniques in coverage 40 for Polisia, CMP and sia - COMPLETE - COMPLETE ANALYSIS
#hmm_final_process - See what is commom between the files
#upload the data
#CMP versus sialil
CMP_plus_sia_comm_livia_novo  <- intersect(final_CMP_process_novo$target_ID, final_sialil_process_novo$target_ID)
CMP_plus_poli_comm_livia_novo  <- intersect(final_CMP_process_novo$target_ID, final_polisia_process_novo$target_ID)

CMP_plus_caz_uni_comm_livia_novo <- intersect(final_CMP_process_novo$target_ID, final_caz_uni_process_novo$target_ID)
