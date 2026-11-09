"""独立一维机制例：聚类中心+末级残差；不是作者模型复现。"""
import struct

def encode(xs, stages):
    residual=list(xs); tables=[]
    for _ in range(stages):
        centers=[min(residual),max(residual)]
        for _ in range(8):
            ids=[min(range(2),key=lambda j:abs(x-centers[j])) for x in residual]
            centers=[sum(x for x,i in zip(residual,ids) if i==j)/max(1,ids.count(j)) if j in ids else centers[j] for j in range(2)]
        tables.append((centers,ids))
        residual=[x-centers[i] for x,i in zip(residual,ids)]
    scale=max(map(abs,residual),default=0) or 1.0
    # 对称2bit使用-1/0/1；每4个码真实打包一个字节。
    codes=[max(-1,min(1,round(x/scale)))+1 for x in residual]
    packed=bytes(sum(code<<(2*j) for j,code in enumerate(codes[i:i+4])) for i in range(0,len(codes),4))
    out=[(((packed[i//4]>>(2*(i%4)))&3)-1)*scale for i in range(len(xs))]
    for centers,ids in reversed(tables): out=[x+centers[i] for x,i in zip(out,ids)]
    # 实际metadata使用float32中心、uint8索引，故小张量可能负压缩。
    metadata=struct.pack('<f',scale)+b''.join(struct.pack('<2f',*c)+bytes(ids) for c,ids in tables)
    return out,len(packed)+len(metadata)
xs=[(-8 if i<32 else 8)+(i%8-3.5)*.03 for i in range(64)]
for stages in (0,1,2):
    y,n=encode(xs,stages);mse=sum((a-b)**2 for a,b in zip(xs,y))/len(xs)
    assert len(y)==len(xs)
    print('stages',stages,'mse',mse,'payload_and_metadata_bytes',n,'fp32_reference',4*len(xs))
assert encode([],0)==([],4)
assert encode([0]*4,1)[0]==[0]*4
print('PASS empty and constant inputs; no attention/video/GPU reproduction')
