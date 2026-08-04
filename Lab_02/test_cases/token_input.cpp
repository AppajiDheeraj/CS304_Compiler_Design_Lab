#include <iostream>
#include <string>

extern int globalCount;
static float interestRate = 7.25f;

int main()
{
    int studentCount = 42;
    double average = 83.5;
    char grade = 'A';
    std::string message = "Compiler Lab";

    if (studentCount > 0) {
        std::cout << message << average << grade << '\n';
    }
    return 0;
}
