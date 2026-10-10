# 2026-10-09 C++17 11：哈希表插入成本与避免隐式构造

推理路由表把模型名映射到已发布版本。`operator[]` 在 miss 时会插入默认 mapped value，既改变状态又可能构造昂贵对象；C++17 `try_emplace` 只在 key 不存在时构造 mapped value，`find` 则完全不插入。实际读取 LLVM libc++ `llvmorg-20.1.0` 的 `libcxx/include/__hash_table`：`__emplace_unique_key_args` 的唯一键插入路径与 `find` 的 bucket 查询路径；Apache-2.0 WITH LLVM-exception。示例是独立标准 API 调用，不复制实现。

`sh run.sh` 已在 Mac C++17 编译运行，验证首次插入、重复 key 保持旧值以及 miss 查找不插入。工程边界：rehash 会使 iterator 失效；并发读写须外部同步；hash collision 影响成本，不能从这个小例子推断吞吐。下一课是负载因子、reserve 与 rehash 的可预测性。
