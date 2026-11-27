import Std

namespace TriangularRecord

def cycleSites : List (Int × Int) :=
  [(-1,0), (-1,1), (-1,2), (0,1), (0,2), (1,1),
   (1,0), (2,0), (2,-1), (1,-1), (0,-1), (0,0)]

def normSq (x y : Int) := x*x + x*y + y*y

def isUnit (p q : Int × Int) : Bool :=
  normSq (p.1-q.1) (p.2-q.2) == 1

-- Relative to (1/3,1/3), scaling coordinates by three multiplies squared
-- radii by nine. Bound 21 therefore means actual squared radius 7/3.
def inSmallDisk (p : Int × Int) : Bool :=
  normSq (3*p.1-1) (3*p.2-1) ≤ 21

theorem cycleCertificate :
    cycleSites.length = 12 ∧ cycleSites.Nodup ∧
    (cycleSites.zipWith isUnit (cycleSites.drop 1 ++ cycleSites.take 1)).all id = true ∧
    cycleSites.all inSmallDisk = true := by decide

-- Center, six nearest neighbors, six next-nearest, six distance-two sites.
def nineteenSites : List (Int × Int) :=
  [(0,0), (1,0), (0,1), (-1,1), (-1,0), (0,-1), (1,-1),
   (1,1), (-1,2), (-2,1), (-1,-1), (1,-2), (2,-1),
   (2,0), (0,2), (-2,2), (-2,0), (0,-2), (2,-2)]

theorem radiusTwoCertificate :
    nineteenSites.length = 19 ∧ nineteenSites.Nodup ∧
    nineteenSites.all (fun p => normSq p.1 p.2 ≤ 4) = true := by decide

end TriangularRecord

#print axioms TriangularRecord.cycleCertificate
#print axioms TriangularRecord.radiusTwoCertificate
