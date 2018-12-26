python usr_csv_to_clips_modified.py $1 hin-clips-facts.dat
#python usr_csv_to_clips_modified.py $1csv/baccA_Pala_KAwA_hE_user.csv hin-clips-facts.dat

clips -f gen-hin_concept-to-mrs_concept.clp
clips -f gen-mrs_info.clp
clips -f gen-prp-info.clp
clips -f gen-mrs-info-pron.clp
clips -f gen-initial-mrs_info.clp
clips -f gen_GNP_values.clp
clips -f bind-RSTR_values.clp
clips -f gen-neg_rstr-rstd.clp
clips -f bind-RSTR_RSTD-values.clp
sort -u mrs_info_with_rstr_rstd_values.dat -o mrs_info_with_rstr_rstd_values.dat
grep "(MRS_info  id-MRS_concept-LBL" mrs_info_with_rstr_values.dat > temp.txt
cut -d " " -f 1-5 temp.txt > temp2.txt
sh final_step.sh
sed -n wfile.merge mrs_info_with_rstr_values.dat id-concept_label-mrs_concept.dat GNP_values.dat mrs_info_with_rstr_rstd_values.dat_tmp info_neg_rstr-rstd.dat
sed -n wdebug.merge mrs_info_with_rstr_values_debug.dat id-concept_label-mrs_concept_debug.dat GNP_values_debug.dat info_neg_rstr-rstd_debug.dat initial-mrs_info_debug.dat mrs_info_debug.dat mrs_info-prep_debug.dat mrs_info-pron_debug.dat mrs_info_with_rstr_rstd_values_debug.dat info_neg_rstr-rstd_debug.dat
python MRS_facts_gen_frn_clips.py file.merge $2-lc.out
$HOME/ace-0.9.24/ace -g $HOME/ace-0.9.24/erg-1214-x86-64-0.9.24.dat -e $2-lc.out


