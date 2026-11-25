"""Regression checks for the monitoring/export boundary and editorial release gate."""
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

from ops.pipeline_feed import OPTICAL, build


class PipelineFeedTest(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)
        self.card = dict(id=OPTICAL,role="external_problem",source="https://arxiv.org/html/1234.56789v1",
                         question="Does Q hold for every state?",significance="Physical consequence.",
                         full_vs_partial="One violating state would disprove Q.")
        self.put("discovery/targets.json",[self.card])
        self.ledger = dict(solutions=[],partial_results=[])
        self.put("discovery/pipeline-results.json",self.ledger)

    def put(self, path, data):
        f = self.root/path
        f.parent.mkdir(exist_ok=True,parents=True)
        f.write_text(json.dumps(data))

    def git(self,*args):
        return subprocess.check_output(["git",*args],cwd=self.root,text=True,stderr=subprocess.DEVNULL).strip()

    def report(self):
        return build(self.root,"2026-01-01T00:00:00+00:00")

    def test_empty_and_duplicate_intake(self):
        self.assertEqual(self.report()["activity"],[])
        self.put("campaign/intake/2026-W01.json",[
            dict(id="version2",title="Already assigned",source="https://arxiv.org/abs/1234.56789v2",question="Q?"),
            dict(id="lead",title="Other",source="https://arxiv.org/abs/1234.55555",question="R?")])
        self.assertEqual([x["id"] for x in self.report()["leads"]],["lead"])

    def test_candidate_is_never_solution(self):
        self.put("campaign/coherent-bands/00000001.json",
                 dict(levels=[0,3],tested=14,status="needs_rigorous_enclosure"))
        r=self.report()
        self.assertEqual((r["counts"]["attempts"],r["counts"]["candidates"],r["counts"]["solutions"]),(14,1,0))
        self.put("campaign/coherent-bands/00000001.json",dict(levels=[0,3],tested=-1,status="accepted"))
        with self.assertRaises(ValueError):
            self.report()

    def test_prior_art_disposition_preserves_parent(self):
        excluded = dict(id="multimode",problem_id=OPTICAL,title="Scoped claim",status="prior_art",
                        detail="An earlier theorem implies this claim.",reviewed_on="2026-11-25",
                        proof="checks/proof.md",math_review="checks/math.md",priority_audit="checks/prior.md")
        for field in ("proof","math_review","priority_audit"):
            self.put(excluded[field],field)
        self.ledger["exclusions"] = [excluded]
        self.put("discovery/pipeline-results.json",self.ledger)
        feed = self.report()
        self.assertEqual((feed["counts"]["exclusions"],feed["counts"]["partial_results"],
                          feed["counts"]["solutions"]),(1,0,0))
        self.assertEqual(feed["problems"][0]["status"],"under_investigation")
        self.assertEqual(len(feed["exclusions"][0]["evidence"]),3)
        self.ledger["partial_results"].append([OPTICAL,"multimode","Duplicate","Same claim",excluded["proof"]])
        self.put("discovery/pipeline-results.json",self.ledger)
        with self.assertRaises(ValueError):
            self.report()

    def test_publication_gate(self):
        self.git("init","-q")
        self.git("config","user.name","Fixture")
        self.git("config","user.email","fixture@example.invalid")
        base = "discovery/resolutions/"
        manifest = dict(problem_id=OPTICAL,scope="full",statement=self.card["question"],
                        source=self.card["source"],decision="accepted",title="Resolution of Q",
                        proof_author="solver",math_reviewer="reviewer",math_verdict="accepted",
                        prior_art_verdict="cleared",proof=base+"proof.md",independent_review=base+"review.md",
                        priority_audit=base+"priority.md")
        for key in ("proof","independent_review","priority_audit"):
            self.put(manifest[key],f"Fixture {key}")
        def revision(scope):
            self.put(base+OPTICAL+".json",dict(manifest,scope=scope))
            self.git("add",base)
            self.git("commit","-qm",scope)
            sha = self.git("rev-parse","HEAD")
            self.ledger["solutions"] = [dict(problem_id=OPTICAL,publication_commit=sha)]
            self.put("discovery/pipeline-results.json",self.ledger)
            return sha

        first=revision("partial")
        self.git("update-ref","refs/remotes/origin/main",first)
        with self.assertRaises(ValueError):
            self.report()
        second=revision("full")
        with self.assertRaises(subprocess.CalledProcessError):
            self.report()
        self.git("update-ref","refs/remotes/origin/main",second)
        result=self.report()
        self.assertEqual(result["counts"]["solutions"],1)
        self.assertIn(second,result["solutions"][0]["evidence"]["independent_review"])
