import unittest
from fractions import Fraction as Q

import numpy as np

from lab import catalog, verify_record
from verify import lower_bound, thomson, werner


class CertificateChecks(unittest.TestCase):
    def test_continuum_and_coeff_sign(self):
        self.assertEqual(lower_bound(2,[500000000]),Q(1,2))
        for bad in ([500000001],[300000000,-1],[700000000,150000000]):
            with self.assertRaises(ValueError):
                lower_bound(10,bad)
        # Passes at both r=0 and r=2; fails at an interior distance.
        with self.assertRaises(ValueError):
            lower_bound(10,[850000000,400000000])

    def test_sphere_geometry(self):
        w={'coeff':[500000000], 'points':[[1,0,0],[-1,0,0]]}
        self.assertEqual(thomson({'n':2},w)['upper'],'1/2')
        w['points'][1]=[1,0,0]
        with self.assertRaises(ValueError):
            thomson({'n':2},w)

    def test_algebraic_energy_enclosure(self):
        w={'coeff':[500000000], 'points':[[1,0,0],[1,10000000,0]]}
        result=thomson({'n':2},w)
        self.assertLess(Q(result['configuration_lower'])**2,Q(1,2))
        self.assertGreater(Q(result['upper'])**2,Q(1,2))

    def test_werner_against_dense_tensor(self):
        # Independent dense Kronecker action in interleaved copy order.
        d,k,p,q=3,2,1,2
        omega=np.eye(d,dtype=int).ravel()
        one=q*np.eye(d*d,dtype=int)-p*np.outer(omega,omega)
        op=np.kron(one,one)
        w={'terms':[[[[1,2],[6,-1]],[[3,1],[7,2]]], [[[5,1]],[[1,-1],[6,2]]]]}
        a=np.zeros((d**k,d**k),dtype=int)
        for left,right in w['terms']:
            for i,x in left:
                for j,y in right:
                    a[i,j]+=x*y
        vec=a.reshape(d,d,d,d).transpose(0,2,1,3).ravel()
        expected=Q(int(vec@op@vec),q**k*int(vec@vec))
        self.assertEqual(Q(werner(dict(d=d,copies=k,alpha=[p,q]),w)['score']),expected)

    def test_multicopy_search_rejects_padded_incumbent(self):
        from complex_search import matrix,search,varied_on_every_site
        padded=[[[[i,1,0]],[[i,1,0]]] for i in (0,1)]
        self.assertFalse(varied_on_every_site(matrix(padded,3,4),3,4))
        r=search(3,4,211,150,padded)
        self.assertTrue(varied_on_every_site(matrix(r["witness"],3,4),3,4))

    def test_werner_sign_controls(self):
        c=dict(d=3,copies=1,alpha=[2,3])
        w={'terms':[[[[0,1]],[[0,1]]],[[[1,1]],[[1,1]]]]}
        self.assertEqual(werner(c,w)['score'],'-1/3')
        w['terms']=w['terms'][:1]
        self.assertEqual(werner(c,w)['score'],'1/3')
        with self.assertRaises(ValueError):
            werner(c,{'terms':w['terms']*3})

    def test_statement_substitution(self):
        card=next(c for c in catalog() if c['id']=='sphere-2')
        w={'points':[[1,0,0],[-1,0,0]], 'coeff':[500000000]}
        record=dict(problem=dict(card),witness=w,result=thomson(card,w))
        verify_record(record)
        record['problem']['question']='Every integer orbit eventually changes.'
        with self.assertRaisesRegex(ValueError,"registry"):
            verify_record(record)


if __name__=='__main__':
    unittest.main()
