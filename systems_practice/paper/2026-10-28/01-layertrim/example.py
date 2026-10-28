# 独立小例：不是作者完整训练/推理复现。

def choose(scores, budget):
    order=sorted(range(len(scores)), key=lambda i:scores[i])
    return order[:budget]

if __name__ == "__main__":
    scores=[0.2,0.8,0.1,0.6]
    kept=choose(scores,2)
    print("kept",kept,"removed",[i for i in range(4) if i not in kept])
