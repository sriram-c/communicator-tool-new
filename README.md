# communicator-tool-new
New version of communicator tool 

#Readme to generate english sentence using a CHL input ######################################################

Pre-requisites:
pydelphin needs to be installed in $HOME/
Ace parser 0.24 version in $HOME/
Link: http://sweaglesw.org/linguistics/ace/download/
download ace-0.9.24-x86-64.tar.gz and erg-1214-x86-64-0.9.24.dat.bz2 from the above link. Keep erg-1214-x86-64-0.9.24.dat.bz2 in ACE directory.
 
Clips needs to be installed.

Set pydelphin path in ~/.bashrc:
Copy below lines at the end of ~/.bashrc 
export PYDELPHIN=$HOME/pydelphin
source ~/.bashrc

How to Run:
1) generate a user csv for a sentence manually.

{NOTE:THE FILES H_concept-to-mrs-rels.dat AND mrs-rel-features.dat SHOULD HAVE THE NECESSARY INFORMATION) 

2) run the shell file lc.sh in the terminal. Command for the same is:

sh lc.sh <path of the user_csv> <path of output file>

example:

sh lc.sh $HOME/communicator-tool-new/they_are_watcing_a_movie_user.csv $HOME/communicator-tool-new/output_facts
