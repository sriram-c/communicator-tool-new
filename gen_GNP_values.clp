;generates output file "GNP_values.dat" which contains gender number person information for nouns,pronouns, proper nouns etc.


(defglobal ?*rstr-fp* = open-file)
(defglobal ?*rstr-dbug* = debug_fp)

(load-facts "hin-clips-facts.dat")
(load-facts "initial-mrs_info.dat")
(load-facts "mrs_info_with_rstr_rstd_values.dat")
(load-facts "H_GNP_to_MRS_GNP.dat")
(load-facts "tam_mapping.dat")
(load-facts "mrs-rel-features.dat")
(load-facts "karaka_relation_preposition_default_mapping.dat")


;Generating GEN-NUM-PERS INFO of proper noun
(defrule gnp-of-eng_N_
(id-gen-num-pers ?id1 ?hg ?hn a)
(id-propn ?id1 yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(MRS_concept-H_G-Eng_G   *_n_*   ?hg  ?eg )
(MRS_concept-H_N-Eng_N   *_n_*   ?hn   ?en)
(MRS_concept-H_P-Eng_P   *_n_*   ?hp   3)
(test (neq (str-index _n_ ?mrsCon) FALSE))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " " ?hg " " ?en "  3 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_N_ id-GEN-NUM-PER "?id1 " " ?hg " " ?en " 3 )"crlf)
)


;Generating GEN-NUM-PERS INFO of noun : if mrsCon contains _n_ , then pick it's repective values from "H_GNP_to_MRS_GNP.dat" and generate (id-GEN-NUM-PER  ?id - ?n ?p)
(defrule gnp-of-eng_noun_
(id-gen-num-pers ?id1 ?hg ?hn a)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(MRS_concept-H_G-Eng_G   *_n_*   ?hg  ?eg )
(MRS_concept-H_N-Eng_N   *_n_*   ?hn   ?en)
(MRS_concept-H_P-Eng_P   *_n_*   ?hp   3)
(test (neq (str-index _n_ ?mrsCon) FALSE))
(not (id-pron ?id1 yes))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " -  " ?en "  3 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_N_ id-GEN-NUM-PER "?id1 " - " ?en " 3 )"crlf)
)

;Generating GEN-NUM-PERS INFO on pronoun :  if (id-pron ?id yes),then pick the repective values for the mrsCon from "H_GNP_to_MRS_GNP.dat" and generate (id-GEN-NUM-PER  ?id ?g ?n ?p)

(defrule gnp-of-eng_pron
(id-gen-num-pers ?id1 ?g ?n ?p)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-pron ?id1 yes)
(MRS_concept-H_G-Eng_G   pron   ?g  ?eg )
(MRS_concept-H_N-Eng_N   pron   ?n  ?en)
(MRS_concept-H_P-Eng_P   pron   ?p  ?ep)
=>
(if (or (neq (str-index u ?p) FALSE) (neq (str-index pl ?n) FALSE))
then
       (printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " - " ?n " " ?ep "  )"crlf)
       (printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron id-GEN-NUM-PER "?id1 "  " ?eg " " ?n " "?ep ")"crlf)

else
 	(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 "  "  ?eg " " ?n " " ?ep "  )"crlf)
	(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron id-GEN-NUM-PER "?id1 "  " ?eg " " ?n " "?ep ")"crlf)
)
)

(open "GNP_values.dat" open-file "w")
(open "GNP_values_debug.dat" debug_fp "w")

(run )
(exit)
