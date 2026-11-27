import OMAReductions.R_MonochromaticQuantumGraph_eqSystem6_no_solution_ge3_R1
import OOReplayH1
import OOReplayH2

/- The six-vertex theorem, including every finite dimension D ≥ 3.
The first import supplies the accepted reduction and its original formal target.
The two step modules are built from the exact public PR files; for this joint
build, their identical exported OMA.solution names are changed to distinct names.
H1 is the monochromatic-sector proof by oo research. H2 is the platform port of
Rishi Rajasekaran's diagonal-rigidity proof, distributed under Apache 2.0. -/

theorem OOReplay.sixPhotonNoGo :
    type_of% @MonochromaticQuantumGraph.eqSystem6_no_solution_ge3 :=
  OMA.R_MonochromaticQuantumGraph_eqSystem6_no_solution_ge3_R1.main
    OOReplay.h1 OOReplay.h2

#print axioms OOReplay.sixPhotonNoGo
