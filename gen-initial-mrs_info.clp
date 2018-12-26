;generates output file "initial-mrs_info.dat" which contains id,MRS concept and their respective relation features.


(defglobal ?*mrs-fp* = mrs-file)
(defglobal ?*mrs-dbug* = mrs-dbug)
(defglobal ?*count* = 1)


(load-facts "id-concept_label-mrs_concept.dat")
(load-facts "mrs-rel-features.dat")
(load-facts "mrs_info.dat")
(load-facts "mrs_info-prep.dat")
(load-facts "mrs_info-pron.dat")

;Rule for generating initial mrs info for concepts in file "id-concept_label-mrs_concept.dat"
(defrule initial-mrs-info
(id-hin_concept-MRS_concept ?id  ?conLbl  ?mrsCon)
(MRS_concept-label-feature_values ?mrsCon $?vars)
=>
	(bind ?val (length$ (create$ $?vars)))
	(bind ?rel (create$ ))
	(bind ?v (create$ ))
	(loop-for-count (?i 1 ?val)
		(if (eq (oddp ?i) TRUE) then
			(bind ?rel_name (string-to-field (sub-string 1 (- (str-length (nth$ ?i $?vars)) 1) (nth$ ?i $?vars))))
			(bind ?rel (create$ ?rel ?rel_name))
		else
			(bind ?v1 (string-to-field (str-cat (sub-string 1 1 (nth$ ?i $?vars)) ?*count*)))
			(bind ?*count* (+ ?*count* 1))
			(bind ?v (create$ ?v ?v1))
		)
	)
        (bind ?l (length$ $?rel) )
        (bind ?str "")
	(loop-for-count (?i 1 ?l )
        	(bind ?str (str-cat ?str (nth$ ?i $?rel) "-")) 
	)
	(bind ?f (sub-string 1 (- (str-length ?str)1) ?str))
	(bind ?f1 (explode$ (str-cat "id-MRS_concept-"  ?f)))

        (printout ?*mrs-fp* "(MRS_info "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
        (printout ?*mrs-dbug* "(rule-rel-values initial_MRS_info "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
)

;Generate initial MRS info for concepts in "mrs_info.dat"
(defrule initial-mrs-info-def
(MRS_info id-MRS_concept ?id  ?mrsCon )
(MRS_concept-label-feature_values ?mrsCon $?vars)
=>
	(bind ?val (length$ (create$ $?vars)))
	(bind ?rel (create$ ))
	(bind ?v (create$ ))
	(loop-for-count (?i 1 ?val)
		(if (eq (oddp ?i) TRUE) then
			(bind ?rel_name (string-to-field (sub-string 1 (- (str-length (nth$ ?i $?vars)) 1) (nth$ ?i $?vars))))
			(bind ?rel (create$ ?rel ?rel_name))
		else
			(bind ?v1 (string-to-field (str-cat (sub-string 1 1 (nth$ ?i $?vars)) ?*count*)))
			(bind ?*count* (+ ?*count* 1))
			(bind ?v (create$ ?v ?v1))
		)
	)
        (bind ?l (length$ $?rel) )
        (bind ?str "")
	(loop-for-count (?i 1 ?l )
        	(bind ?str (str-cat ?str (nth$ ?i $?rel) "-")) 
	)
	(bind ?f (sub-string 1 (- (str-length ?str)1) ?str))
	(bind ?f1 (explode$ (str-cat "id-MRS_concept-"  ?f)))

        (printout ?*mrs-fp* "(MRS_info "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
        (printout ?*mrs-dbug* "(rule-rel-values initial_MRS_info-def "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
)

(open "initial-mrs_info.dat" mrs-file "w")
(open "initial-mrs_info_debug.dat" mrs-dbug "w")

;(agenda)
;(watch rules)
;(watch facts)
(run)
;(save-facts "initial-mrs_info.dat")
(exit)

