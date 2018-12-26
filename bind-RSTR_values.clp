;generates output file "mrs_info_with_rstr_values.dat" which contains LTOP , kriyA-TAM and id-MRS-Rel_features


(defglobal ?*rstr-fp* = open-file)
(defglobal ?*rstr-dbug* = debug_fp)

(load-facts "hin-clips-facts.dat")
(load-facts "initial-mrs_info.dat")
(load-facts "H_GNP_to_MRS_GNP.dat")
(load-facts "tam_mapping.dat")
(load-facts "mrs-rel-features.dat")
(load-facts "karaka_relation_preposition_default_mapping.dat")


;Rule for adjective and noun : for (viSeRya-viSeRaNa 	? ?)
;		replace LBL value of viSeRaNa with the LBL value of viSeRya
;		Replace ARG1 value of viSeRaNa with ARG0 value of viSeRya
(defrule viya-viNa
(viSeRya-viSeRaNa ?viya ?viNa)
(MRS_info ?rel1 ?viya ?c ?lbl1 ?arg0_viya ?arg1_viya $?var)
(MRS_info ?rel2 ?viNa ?co ?lbl2 ?arg0_viNa ?arg1_viNa $?vars)
=>
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values viya-viNa  MRS_info  "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viya " " ?arg1_viya " "(implode$ (create$ $?vars)) ")"crlf)
)

;Rule for verb when only karta is present : for (kriyA-k1 ? ?) and  (kriyA-k2 ? ?) is not present
;                                           replace ARG2 of kriyA with ARG0 of karwA
(defrule v-kartA
(kriyA-k1	?kriyA ?karwA)
(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
(MRS_concept-H_P-Eng_P   *_n_*   ?hp   3)
(test (eq (str-index _q ?mrsCon1) FALSE))
(not (kriyA-k2 ?kriyA ?karma))

=>
(printout ?*rstr-fp* "(MRS_info  "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " " ?arg0 " " ?argwA_0 " "(implode$ (create$ $?v))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-karwA MRS_info "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " " ?argwA_0 " "(implode$ (create$ $?v))")"crlf)
)


;Rule for verb and its arguments(when both karta and karma are present),Replace ARG1 value of kriyA with ARG0 value of karwA and ARG2 value of kriyA with ARG0 value of karma
(defrule v-karwA
(kriyA-k1		?kriyA ?karwA)
(kriyA-k2       	?kriyA ?karma)
(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
(MRS_info ?rel2 ?karma ?mrsCon2 ?lbl2 ?argma_0 $?vars1)
(test (eq (str-index _q ?mrsCon1) FALSE))
(test (eq (str-index _q ?mrsCon2) FALSE))


=>
(printout ?*rstr-fp* "(MRS_info  "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " " ?arg0 " " ?argwA_0 " " ?argma_0 " "(implode$ (create$ $?v))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-karwA MRS_info "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " " ?argwA_0 " " ?argma_0 " "(implode$ (create$ $?v))")"crlf)
)


;Rule for preposition for noun : for (kriyA-k*/r* ?1 ?2) and (id-MRS_Rel ?2 k*/r* corresponding prep_rel from dic)
;Replace ARG1 value of prep_rel with ARG0 value of ?1 and ARG2 value of prep_rel with ARG0 value of ?2)
(defrule prep-noun
(rel_name-ids ?relp ?kriyA ?prep)
(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info ?rel1 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?prep ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (eq (sub-string (- (str-length ?endsWith_p) 1)  (- (str-length ?endsWith_p) 0)  ?endsWith_p) "_p"))
(test (eq (sub-string (- (str-length ?mrsCon2) 3)  (- (str-length ?mrsCon2) 1)  ?mrsCon2) "_n_"))

=>
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-yes MRS_info "?rel_name " " ?kriyA " " ?endsWith_p " " ?lbl " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
)


;Rule for preposition for pronoun : when (id-pron ? yes) for (kriyA-k*/r* ?1 ?2) and (id-MRS_Rel ?2 k*/r* corresponding prep_rel from dic)
;Replace ARG1 value of prep_rel with ARG0 value of ?1 and ARG2 value of prep_rel with ARG0 value of ?2)

(defrule prep-pron
(rel_name-ids ?relp ?kriyA ?prep)
(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info ?rel1 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?prep ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (eq (sub-string (- (str-length ?endsWith_p) 1)  (- (str-length ?endsWith_p) 0)  ?endsWith_p) "_p"))
(test (neq (sub-string (- (str-length ?mrsCon2) 1)  (- (str-length ?mrsCon2) 0)  ?mrsCon2) "_q"))
(test (neq (str-index pron ?mrsCon2)FALSE))
=>
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-yes MRS_info "?rel_name " " ?kriyA " " ?endsWith_p " " ?lbl " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
)

;Rule for sentence and tam info: (if (kriyA-TAM), value of id = value of kriyA from the facts kriyA-TAM, SF from sentence_type and the rest from tam_mapping.csv)
;for asssertive sentence information
(defrule kri-tam-asser
(kriyA-TAM ?kri ?tam)
(sentence_type  assertive)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense ?tam ?e_tam ?perf ?prog ?tense)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-asser id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;for negation sentence information
(defrule kri-tam-neg
(kriyA-TAM ?kri ?tam)
(sentence_type  negation)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense ?tam ?e_tam ?perf ?prog ?tense)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-asser id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
)
;for imperative sentence information
(defrule kri-tam-imper
(kriyA-TAM ?kri ?tam)
(sentence_type  imperative)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense  ?tam ?e_tam ?perf ?prog ?tense)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " comm " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-imper id-SF-MOOD-PROG-PERF "?kri " comm " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;for imperative question information
(defrule kri-tam-q
(kriyA-TAM ?kri ?tam)
(sentence_type  question)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense  ?tam ?e_tam ?perf ?prog ?tense)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " ques " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-q id-SF-TENSE-MOOD-PROG-PERF "?kri " ques " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;Rule for LTOP: The LBL value and ARG0 value of *_v_* becomes the value of LTOP and INDEX if the following words are not there in the sentence: "possibly", "suddenly". "not".If they exist, the LTOP value becomes the LBL value of that word and INDEX value is the ARG0 value of *_v_*. For "not" we get a node "neg" in the MRS

(defrule v-LTOP
(MRS_info ?rel ?kri_id ?mrsCon ?lbl ?arg0 $?vars)
=>
(if (or (neq (str-index possible_ ?mrsCon) FALSE) (neq (str-index sudden_ ?mrsCon) FALSE))
then
        (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
        (printout ?*rstr-dbug* "(rule-initial_MRS_info  v-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)

else
        (if (neq (str-index _v_ ?mrsCon) FALSE)
then
        (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
        (printout ?*rstr-dbug* "(rule-initial_MRS_info  v-LTOP LTOP-INDEX h0 "?arg0 ")"crlf))  
)     
)


(open "mrs_info_with_rstr_values.dat" open-file "w")
(open "mrs_info_with_rstr_values_debug.dat" debug_fp "w")

(run )
(exit)
