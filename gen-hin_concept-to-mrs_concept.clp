;generates output file "id-concept_label-mrs_concept.dat" which contains id,hindi concept label, and MRS concept for the hindi user csv by matching concepts from hindi clips facts from the file hin-clips-facts.dat.

(defglobal ?*mrsCon* = mrs-file)
(defglobal ?*mrs-dbug* = mrs-dbug)

(load-facts "hin-clips-facts.dat")
(load-facts "H_concept-to-mrs-rels.dat")

;(matches concept from hin-clips-facts.dat)
(defrule mrs-rels
?f <-(id-concept_label ?id ?conLabel)
(concept_label-concept_in_Eng-MRS_concept ?conLabel ?enCon ?mrsConcept)
=>
(retract ?f)
(printout ?*mrsCon* "(id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values mrs-rels id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf))

(open "id-concept_label-mrs_concept.dat" mrs-file "w")
(open "mrs_info_with_rstr_values_debug.dat" mrs-dbug "w")

(run)
(exit)


