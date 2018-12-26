;generates output file "mrs_info-pron.dat" which contains id, pron and pronoun_q for all the pronouns


(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

(load-facts "hin-clips-facts.dat")
(load-facts "mrs-rel-features.dat")

;Rule for pronoun : if (id-pron ?id yes) generate (id-MRS_Rel ?id pronoun_q) and (id-MRS_Rel ?id pron)
(defrule mrsPron_yes
(id-pron  ?id  yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " pronoun_q )"crlf)
(printout ?*defdbug* "(rule-rel-values mrsDef_yes initial_MRS_info id-MRS_concept "?id " pronoun_q )"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " pron )"crlf)
(printout ?*defdbug* "(rule-rel-values mrsDef_yes initial_MRS_info id-MRS_concept "?id " pron )"crlf)
)

(open "mrs_info-pron.dat" mrs-def-fp "w")
(open "mrs_info-pron_debug.dat" mrs-def-dbug "w")

(run )
(exit)

