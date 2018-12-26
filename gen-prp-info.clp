;generate output file "mrs_info-prep.dat" and gives id and MRS concept for prepositions

(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

(load-facts "hin-clips-facts.dat")
(load-facts "mrs-rel-features.dat")
(load-facts "karaka_relation_preposition_default_mapping.dat")
;Rule for prepositions : if (kriyA-k*/r* ?id1 ?id2) and is present in "karaka_relation_preposition_default_mapping.dat", generate (id-MRS_Rel ?id ?respective preposition_p)
(defrule mrsPrep
(rel_name-ids ?rel ?kri ?k-id)
(Karaka_Relation-Preposition    ?karaka  ?prep)
(test (eq (sub-string (+ (str-index "-" ?rel)1) (str-length ?rel) ?rel) (implode$ (create$ ?karaka))))
=>
(bind ?myprep (str-cat "_" ?prep "_p"))
(printout ?*mrsdef* "(MRS_info id-MRS_concept " ?k-id " " ?myprep")"crlf)
(printout ?*defdbug* "(rule-rel-values mrsPrep id-MRS_concept "?k-id " " ?myprep")"crlf)
)


(open "mrs_info-prep.dat" mrs-def-fp "w")
(open "mrs_info-prep_debug.dat" mrs-def-dbug "w")

(run )
(exit)
