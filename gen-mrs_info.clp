;generates output file "mrs_info.dat" that contains id and MRS concept for a and the.
;udef_q for plural noun and mass noun.
;neg for negation.

(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

(load-facts "hin-clips-facts.dat")
(load-facts "mrs-rel-features.dat")

;Rules for common noun with the as a determiner : if (id-def ? yes), generate (id-MRS_Rel ?id _the_q)
(defrule mrsDef_yes
(id-def  ?id  yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " _the_q )"crlf)
(printout ?*defdbug* "(rule-rel-values mrsDef_yes initial_MRS_info id-MRS_concept "?id " _the_q )"crlf)
)

;Rule for a as a determiner : if the is not present,is not a mass noun and not plural then generate (id-MRS_Rel ?id _a_q)
(defrule mrsDef_not
(id-gen-num-pers ?id ?g ?n ?p)
(not (id-def ?id yes))
(not (id-mass ?id yes))
(test (neq ?n  pl))
(not(id-pron ?id yes))
(not (viSeRya-saMKyA_viSeRaNa ?id $?v))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " _a_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrsDef_yes initial_MRS_info id-MRS_concept "?id " _a_q)"crlf)
)

;Rule for plural noun : if (?n is pl) generate ((id-MRS_Rel ?id _udef_q)
(defrule mrs_pl_notDef
(id-gen-num-pers ?id ?g ?n ?p)
(not (id-def ?id yes))
(not (id-mass ?id yes))
(test (eq ?n pl))
(not(id-pron ?id yes))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrsDef_yes initial_MRS_info id-MRS_concept "?id " udef_q)"crlf)
)

;Rule for mass noun : if (id-mass ?id yes) , generate (id-MRS_Rel ?id _udef_q)
(defrule mrs_mass_notDef
(id-gen-num-pers ?id ?g ?n ?p)
(id-mass ?id yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrsDef_yes initial_MRS_info id-MRS_concept "?id " udef_q)"crlf)
)

;Rule for negation : if (kriya-NEG ?id1 ?id2) is present, generate (id-MRS_Rel ?id _udef_q)
(defrule mrs_neg_notDef
(kriyA-NEG  ?kid ?negid)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?negid " neg)"crlf)
(printout ?*defdbug* "(rule-rel-values mrsDef_yes initial_MRS_info id-MRS_concept "?negid " neg)"crlf)
)


(open "mrs_info.dat" mrs-def-fp "w")
(open "mrs_info_debug.dat" mrs-def-dbug "w")

(run )
(exit)

