#include <iostream>
#include <string>
#if defined(__aarch64__) && defined(__linux__)
#include <sys/auxv.h>
#endif
int main() {
#if defined(__aarch64__) && defined(__linux__)
  unsigned long hw = getauxval(AT_HWCAP);
  std::cout << "arch=aarch64 hwcap=" << hw << " neon=" << ((hw >> 1) & 1) << "\n";
#else
#if defined(__aarch64__)
  std::cout << "arch=aarch64 host-no-linux-api fallback=scalar\n";
#else
  std::cout << "arch=non-aarch64 fallback=scalar\n";
#endif
#endif
  return 0;
}
