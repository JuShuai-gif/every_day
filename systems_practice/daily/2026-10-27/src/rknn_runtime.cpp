#include <rknn_api.h>

#include <cstdint>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>
static void ok(int rc, const char* n) {
  if (rc != RKNN_SUCC)
    throw std::runtime_error(std::string(n) + " rc=" + std::to_string(rc));
}
struct Ctx {
  rknn_context h = 0;
  ~Ctx() {
    if (h) {
      int rc = rknn_destroy(h);
      if (rc != RKNN_SUCC)
        std::cerr << "destroy rc=" << rc
                  << "
                     ";}}Ctx()=default;Ctx(const Ctx&)=delete;};
            int
            main(int ac, char** av) {
          try {
            if (ac != 2)
              throw std::invalid_argument("usage model.rknn");
            std::ifstream f(av[1], std::ios::binary | std::ios::ate);
            auto n = f.tellg();
            if (!f || n <= 0)
              throw std::runtime_error("model");
            std::vector<char> m(size_t(n));
            f.seekg(0);
            if (!f.read(m.data(), n))
              throw std::runtime_error("short model");
            Ctx c;
            ok(rknn_init(&c.h, m.data(), uint32_t(m.size()), 0, nullptr), "init");
            rknn_sdk_version v{};
            ok(rknn_query(c.h, RKNN_QUERY_SDK_VERSION, &v, sizeof(v)), "sdk");
          std::cout
              << "api=" << v.api_version << " driver=" << v.drv_version
              << "
                 ";std::vector<float>x(48,.25f);rknn_input "
                 "in{};in.type=RKNN_TENSOR_FLOAT32;in.fmt=RKNN_TENSOR_NCHW;in.size=uint32_t(x.size("
                 ")*sizeof(float));in.buf=x.data();ok(rknn_inputs_set(c.h,1,&in)," inputs_set
                 ");ok(rknn_run(c.h,nullptr)," run
                 ");rknn_output "
                 "out{};out.want_float=1;ok(rknn_outputs_get(c.h,1,&out,nullptr)," outputs_get
                 ");if(!out.buf||out.size<4)throw std::runtime_error(" empty output
                 ");std::cout<<" bytes = "<<out.size<<" first =
              "<<static_cast<float*>(out.buf)[0]<<"
              ";ok(rknn_outputs_release(c.h,1,&out)," outputs_release
              ");}catch(const std::exception&e){std::cerr<<e.what()<<"
              ";return 1;}}
