;generates output file "mrs_info_with_rstr_rstd_values.dat" and contains information of all the restrictor restricted and MRS relation features values
(defglobal ?*rstr-rstd* = open-rstr)
(defglobal ?*rstr-rstd-dbg* = debug_rstr)

(load-facts "hin-clips-facts.dat")
(load-facts "initial-mrs_info.dat")
(load-facts "mrs_info_with_rstr_values.dat")

;This rule deletes a fact that belongs to a set id but the fact should not have the max ID and its MRS concept value should not end with "_q". For example, out of the following 3 facts for the phrase 'a new book' in the sentence: "The boy is reading a new book." "f-2' would be deleted.
  ;f-1    (initial_MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 21000 _a_q h8 x9 h10 h11)
  ;f-2    (initial_MRS_info id-MRS_concept-LBL-ARG0-ARG1 22000 _new_a_1 h16 x17 x18)
  ;f-3    (initial_MRS_info id-MRS_concept-LBL-ARG0-ARG1 23000 _book_n_of h5 x6 x7)
;Deleting the facts prevents from generating unwanted "Restr-Restricted * *" relations by the "initial-mrs-info" rule.
(defrule rm-info
(declare (salience 10000))
?f1<-(MRS_info ?rel1 ?id1 ?noendsq  ?lbl1 ?arg   ?arg1)
?f2<-(MRS_info ?rel2 ?id2 ?noendsq1 ?lbl2 ?arg0 ?arg11)
(test (eq (sub-string 1 1 (implode$ (create$ ?id1))) (sub-string 1 1 (implode$ (create$ ?id2)))))
(test (neq (sub-string (- (str-length ?noendsq1)    1) (str-length ?noendsq1) ?noendsq1) "_q"))
(test (neq (sub-string (- (str-length ?noendsq)    1) (str-length ?noendsq) ?noendsq) "_q"))
(test (> ?id2 ?id1))
=>
(retract ?f1)
(printout ?*rstr-rstd*   "(MRS_info  "?rel1 " " ?id1 " " ?noendsq " " ?lbl1 " " ?arg " " ?arg1 ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  rm-info MRS_info  "?rel1 " " ?id1 " " ?noendsq " " ?lbl1 " " ?arg " " ?arg1 ")"crlf)
)

;If id of two facts are identical or they are of the same set and id of one fact has value *_q for MRS_Rel,
;	then Generate (Restr-Restricted RSTR_of_*_q LBL_the_other_fact)
;	     Replace ARG0 value of *_q with ARG0 value of the other fact 	
(defrule initial-mrs-info
;(declare (salience 1000))
?f<-(MRS_info ?rel1 ?id1 ?endsWith_q ?lbl1 ?x ?rstr $?vars)
(MRS_info ?rel2 ?id2 ?mrsCon ?lbl2 ?ARG_0 $?v)

(test (neq ?endsWith_q ?mrsCon))
(test (eq (sub-string 1 1 (implode$ (create$ ?id1))) (sub-string 1 1 (implode$ (create$ ?id2)))))
(test (eq (sub-string (- (str-length ?endsWith_q) 1) (str-length ?endsWith_q) ?endsWith_q) "_q"))
(test (neq (sub-string (- (str-length ?mrsCon) 1) (str-length ?mrsCon) ?mrsCon) "_p"))
;(test (> ?id2 ?id1))
=>
(retract ?f)
;(assert (MRS_info Restr-Restricted    ?rstr   ?lbl2 ))
(printout ?*rstr-rstd* "(Restr-Restricted     "?rstr  "  " ?lbl2 ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  initial-mrs-info  Restr-Restricted  "?rstr"  "?lbl2 ")"crlf)

;(assert (MRS_info  ?rel1 ?id1  ?endsWith_q  ?lbl1 ?ARG_0 ?rstr  $?vars))
(printout ?*rstr-rstd*   "(MRS_info  "?rel1 " " ?id1 " " ?endsWith_q " " ?lbl1 " " ?ARG_0 " " ?rstr " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  initial-mrs-info "?rel1 " " ?id1 " " ?endsWith_q " " ?lbl1 " "?ARG_0 " " ?rstr " " (implode$ (create$ $?vars)) ")"crlf)
)


;Restrictor for LTOP Restrictor-Restricted when neg is present
(defrule LTOP-neg-rstd
(MRS_info ?rel	?id ?mrsCon ?lbl $?vars)
(test (neq (str-index neg ?mrsCon) FALSE))
=>
        (printout ?*rstr-rstd* "(Restr-Restricted  h0 "?lbl ")" crlf)
     
        (printout ?*rstr-rstd-dbg* "(rule-initial_MRS_info  LTOP-rstd MRS_info Restr-Restricted  h0 "?lbl ")"crlf)
)

;;Restrictor for LTOP Restrictor-Restricted default value

(defrule LTOP-rstd
(MRS_info ?rel	?id ?mrsCon ?lbl $?vars)
(not (MRS_info ?rel1 ?id1 neg ?lbl1 $?v))
=>
(if (or (neq (str-index possible_ ?mrsCon) FALSE) (neq (str-index sudden_ ?mrsCon) FALSE) )
then
        (printout ?*rstr-rstd* "(Restr-Restricted  h0 "?lbl ")" crlf)
        (printout ?*rstr-rstd-dbg* "(rule-initial_MRS_info  LTOP-rstd MRS_info Restr-Restricted  h0 "?lbl ")"crlf)

else
        (if (neq (str-index _v_ ?mrsCon) FALSE)
then
        (printout ?*rstr-rstd* "(Restr-Restricted  h0  "?lbl ")" crlf))  
        (printout ?*rstr-rstd-dbg* "(rule-initial_MRS_info  LTOP-rstd MRS_info Restr-Restricted  h0 "?lbl ")"crlf)

)     
)


(defrule print-mrs-info
(declare (salience -1000))
?f1<-(MRS_info ?rel1  $?vars)
=>
(retract ?f1)
(printout ?*rstr-rstd*   "(MRS_info  "?rel1 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  print-mrs-info MRS_info "?rel1 " " (implode$ (create$ $?vars)) ")"crlf)
)


(open "mrs_info_with_rstr_rstd_values.dat" open-rstr "w")
(open "mrs_info_with_rstr_rstd_values_debug.dat" debug_rstr "w")

;(agenda)
;(watch rules)
;(watch facts)
(run)
;(facts)
(exit)
