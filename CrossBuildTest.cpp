#include <fmt/core.h>
#include <fmt/ranges.h>
#include <vector>

int main()
{
  std::vector<uint32_t> sampleVector{10, 20, 30, 40, 50};
  fmt::print("Sample Vector : {}\n", sampleVector);
}