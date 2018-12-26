;generates output file "info_neg_rstr-rstd.dat" which has info of restrictor-restricted for negation.

(defglobal ?*rstr-rstd* = open-rstr)
(defglobal ?*rstr-rstd-dbg* = debug_rstr)

(load-facts "initial-mrs_info.dat")
(load-facts "mrs_info_with_rstr_values.dat")

;Restrictor-Restricted for neg: in (MRS_info ?rel1 ?id1 ?mrsCon ?lbl ?ARG0 ?ARG1) check ?mrsCon is equal to neg and ARG1 value of kriyA should be equal to ARG0 value of karwA 
(defrule neg-rstd
(MRS_info ?rel1 ?id1 ?mrsCon ?lbl ?ARG0_1 ?ARG1)
(MRS_info ?rel3 ?id3 ?mrsCon3 ?lbl1 ?ARG0_3 $?vars)
(MRS_info ?rel2 ?id2 ?mrsCon2 ?lbl2 ?ARG0_2 ?ARG0_3 $?v)
(LTOP-INDEX h0 ?index)
(test (neq (str-index neg ?mrsCon) FALSE))
(test (neq (str-index ?index ?ARG0_2) FALSE))
=>
(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1  "  " ?lbl2 ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  initial-mrs-info  Restr-Restricted  "?ARG1"  "?lbl2")"crlf)

)

(open "info_neg_rstr-rstd.dat" open-rstr "w")
(open "info_neg_rstr-rstd_debug.dat" debug_rstr "w")

;(agenda)
;(watch rules)
;(watch facts)
(run)
;(facts)
(exit)
