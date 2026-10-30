# 独立示例：把 T 个 token 的标量 LUT 访问合并为一次向量查表。
lut=[0.0,1.0,4.0,9.0]; indices=[[1,2,3],[3,1,0]]
vector=[[[lut[i] for i in row] for row in indices]]
print({'tokens':len(indices),'lookups_scalar':sum(map(len,indices)),'vector_shape':[len(indices),len(indices[0])]})
