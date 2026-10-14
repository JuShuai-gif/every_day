"""独立query加权VQ例子；没有RoPE、跨头scale、协方差matching或作者kernel。"""
import json
import math
import random
import struct
from pathlib import Path

def distance(x,c,w):return sum(wi*(xi-ci)**2 for xi,ci,wi in zip(x,c,w))
def encode(x,centers,w):return min(range(len(centers)),key=lambda j:distance(x,centers[j],w))
def fit(data,w):
    centers=[list(data[i]) for i in (0,8,16,24)]
    for _ in range(20):
        bins=[[] for _ in centers]
        for x in data:bins[encode(x,centers,w)].append(x)
        centers=[([sum(x[d] for x in rows)/len(rows) for d in range(2)] if rows else old) for old,rows in zip(centers,bins)]
    return centers

def main():
    rng=random.Random(14)
    cal=[(rng.gauss(0,1),rng.gauss(0,2)) for _ in range(128)]
    test=[(rng.gauss(0,1),rng.gauss(0,2)) for _ in range(64)]
    # 校准query second moments；eval没有参与中心或参数选择。
    queries=[(rng.gauss(0,4),rng.gauss(0,.2)) for _ in range(128)]
    w=[sum(q[j]**2 for q in queries)/len(queries) for j in range(2)]
    rows=[]
    b=Path(__file__).parent/'build';b.mkdir(exist_ok=True)
    for name,weights in [('euclidean',[1,1]),('query_weighted',w)]:
        c=fit(cal,weights);ids=[encode(x,c,weights) for x in test]
        packed=bytes(sum(ids[i+j]<<(2*j) for j in range(4)) for i in range(0,len(ids),4))
        payload=packed+struct.pack('<8f',*(z for row in c for z in row))
        path=b/(name+'.bin');path.write_bytes(payload)
        decoded=[(packed[i//4]>>(2*(i%4)))&3 for i in range(len(ids))];assert ids==decoded
        kerr=sum(distance(x,c[j],[1,1]) for x,j in zip(test,ids))/len(test)
        qerr=sum(distance(x,c[j],w) for x,j in zip(test,ids))/len(test)
        # 新query方向变化，原校准权重可能不再合适。
        shifted=sum(distance(x,c[j],[.04,16]) for x,j in zip(test,ids))/len(test)
        rows.append(dict(method=name,key_mse=kerr,diagonal_qk_error=qerr,shifted_query_error=shifted,index_bytes=len(packed),codebook_bytes=32,file_bytes=path.stat().st_size))
    assert all(r['file_bytes']==48 for r in rows)
    print(json.dumps(dict(rows=rows,learned_query_weights=w,index_bits_per_channel=1,actual_bits_per_channel=48*8/(64*2),full_tasq_reproduction=False),indent=2))
if __name__=='__main__':main()
