// 无系统头文件的编译观察探针：Clang/GCC扩展，只生成Linux A64汇编，不链接/执行。
// C++语义与并发验证见main.cpp；这里的指针必须满足int对齐且指向有效原子访问对象。
extern "C" int probe_acquire(int* p) {
  return __atomic_load_n(p, __ATOMIC_ACQUIRE);
}
extern "C" void probe_release(int* p, int v) {
  __atomic_store_n(p, v, __ATOMIC_RELEASE);
}
extern "C" int probe_ticket(int* p) {
  return __atomic_fetch_add(p, 1, __ATOMIC_RELAXED);
}
