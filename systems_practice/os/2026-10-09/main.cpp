#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>
enum class State { Runnable, Running, Sleeping };
struct Task { std::string name; State state; };
int schedule(std::vector<Task>& tasks) {
  for (std::size_t i = 0; i < tasks.size(); ++i) if (tasks[i].state == State::Runnable) { tasks[i].state = State::Running; return static_cast<int>(i); }
  return -1;
}
int main() {
  std::vector<Task> tasks{{"camera", State::Sleeping}, {"inference", State::Runnable}};
  const int next = schedule(tasks);
  if (next != 1 || tasks[1].state != State::Running || schedule(tasks) != -1) throw std::runtime_error("scheduler state");
  std::cout << "PASS runnable->running, sleeping skipped, no-runnable idle\n";
}
