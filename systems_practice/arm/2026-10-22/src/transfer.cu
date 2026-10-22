#include <cuda_runtime.h>

#include <algorithm>
#include <iostream>
#include <stdexcept>
#include <string>
void check(cudaError_t e, const char* operation) {
  if (e != cudaSuccess) {
    throw std::runtime_error(std::string(operation) + ": " + cudaGetErrorString(e));
  }
}
void cleanup(cudaError_t e) noexcept {
  if (e != cudaSuccess) {
    std::cerr << "CUDA cleanup: " << cudaGetErrorString(e) << '\n';
  }
}
// 成员初始化逐步取得资源；构造失败同样走回收，先同步再释放内存。
class Transfer {
 public:
  explicit Transfer(std::size_t count) : n(count) {
    if (n == 0 || n > 1048576) {
      throw std::invalid_argument("count");
    }
    try {
      check(cudaStreamCreateWithFlags(&stream, cudaStreamNonBlocking), "stream");
      check(cudaEventCreateWithFlags(&done, cudaEventDisableTiming), "event");
      check(cudaMallocHost(reinterpret_cast<void**>(&host), n * sizeof(float)), "pinned");
      check(cudaMalloc(reinterpret_cast<void**>(&device), n * sizeof(float)), "device");
    } catch (...) {
      release();
      throw;
    }
  }
  ~Transfer() {
    release();
  }
  Transfer(const Transfer&) = delete;
  Transfer& operator=(const Transfer&) = delete;
  void roundtrip(float value) {
    std::fill(host, host + n, value);
    check(cudaMemcpyAsync(device, host, n * sizeof(float), cudaMemcpyHostToDevice, stream), "H2D");
    check(cudaMemcpyAsync(host, device, n * sizeof(float), cudaMemcpyDeviceToHost, stream), "D2H");
    check(cudaEventRecord(done, stream), "record after final use");
    // 客户端在此取消也不能释放host/device；完成事件在同一stream最后。
    auto status = cudaEventQuery(done);
    if (status != cudaSuccess && status != cudaErrorNotReady) {
      check(status, "query");
    }
    check(cudaEventSynchronize(done), "complete");
    if (!std::all_of(host, host + n, [&](float x) {
          return x == value;
        })) {
      throw std::runtime_error("roundtrip mismatch");
    }
  }

 private:
  void release() noexcept {
    if (stream) {
      auto e = cudaStreamSynchronize(stream);
      // 若无法证明设备结束，不继续正常回收；进程退出交由驱动清理。
      if (e != cudaSuccess) {
        cleanup(e);
        std::terminate();
      }
    }
    if (device) {
      cleanup(cudaFree(device));
      device = nullptr;
    }
    if (host) {
      cleanup(cudaFreeHost(host));
      host = nullptr;
    }
    if (done) {
      cleanup(cudaEventDestroy(done));
      done = nullptr;
    }
    if (stream) {
      cleanup(cudaStreamDestroy(stream));
      stream = nullptr;
    }
  }
  std::size_t n;
  float* host = nullptr;
  float* device = nullptr;
  cudaStream_t stream = nullptr;
  cudaEvent_t done = nullptr;
};
int main() {
  try {
    int dev = 0;
    check(cudaGetDevice(&dev), "get device");
    cudaDeviceProp prop{};
    check(cudaGetDeviceProperties(&prop, dev), "properties");
    if (prop.major != 11 || prop.minor != 0) {
      throw std::runtime_error("requires Thor SM110");
    }
    for (std::size_t n : {1U, 17U, 4096U}) {
      Transfer t(n);
      t.roundtrip(3.25f);
      t.roundtrip(-7.0f);
    }
    std::cout << "PASS Thor SM110 transfer-only 6 roundtrips; no inference/kernel timing\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
