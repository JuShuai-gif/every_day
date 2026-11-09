"""独立执行时刻状态/offset数据例，不是机器人或VLA训练复现。"""
def roll(state, actions, delay):
    if delay<0 or delay>len(actions): raise ValueError('delay outside known chunk')
    return state+sum(actions[:delay])
state=1.0;actions=[.1,.2,-.1,.3];delay=2
future=roll(state,actions,delay)
# 一维确定性目标动作，未建立机器人动力学。
target=2.0
naive=target-state;aligned=target-future
assert abs(future+aligned-target)<1e-12
print('naive_target_error',abs(future+naive-target),'aligned_error',abs(future+aligned-target))
# 同一观测匹配不同未来state和对应action，不能只移动label。
samples=[('image_t',roll(state,actions,d),target-roll(state,actions,d)) for d in range(5)]
assert all(abs(s+a-target)<1e-12 for _,s,a in samples)
try:roll(state,actions,5)
except ValueError:print('PASS offset_pairs=5, excessive delay rejected, training_steps=0')
else:raise AssertionError('missing guard')
# 真实执行有扰动时，开环rollout仍会出错。
print('disturbed_endpoint_error',abs((future+.4)+aligned-target))
