# 独立示例：按平均 bit 预算把通道分组；不是作者编译器。
bits=[2,3,4,8,16,4,3,2]; budget=4.5
chosen=[]; total=0
for b in sorted(bits):
 if total+b <= budget*len(bits): chosen.append(b); total+=b
print({'chosen':chosen,'average_bits':sum(chosen)/len(chosen),'budget':budget,'unassigned':len(bits)-len(chosen)})
