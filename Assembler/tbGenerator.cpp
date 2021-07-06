#include<iostream>
#include<fstream>
#include <bitset>
#include <string>
#include <sstream>


int main(int argc, char **argv){
    std::string outPath;
    int num;

    if(argc == 3){
        outPath = argv[1];
        num = std::stoi(argv[2]);
    }

    std::cout << "called -----------------------" << std::endl;
    
    std::ofstream out(outPath);

    out <<  "library ieee;\n"
            "use ieee.std_logic_1164.all;\n"
            "\n"
            "entity mips_pipelined_tb is\n"
            "end;\n"
            "\n"
            "architecture structure of mips_pipelined_tb is\n"
            "\n"
            "\tcomponent mips_pipelined is\n"
            "\t\tport (\n"
            "\t\t\tclk   : in std_logic;\n"
            "\t\t\treset : in std_logic\n"
            "\t\t);\n"
            "\tend component;\n"
            "\n"
            "\tsignal clk, reset : std_logic;\n"
            "\n"
            "begin\n"
            "\tmips : mips_pipelined port map(clk => clk, reset => reset);\n"
            "\n"
            "\tprocess begin\n"
            "\t\t-- reset\n"
            "\t\tclk   <= '0';\n"
            "\t\treset <= '1';\n"
            "\t\twait for 10 ns;\n"
            "\t\tclk   <= '0';\n"
            "\t\treset <= '0';\n"
            "\t\twait for 10 ns;\n"
            "\n"
            "\t-- do cycles\n"
            "\tfor i in 1 to ";
                    
    out << num;
                    
    out <<  " loop\n"
            "\t\tclk <= '1';\n"
            "\t\twait for 10 ns;\n"
            "\t\tclk <= '0';\n"
            "\t\twait for 10 ns;\n"
            "\t\tend loop;\n"
            "\n"
            "\t\t-- last 4 cycles of last instruction\n"
            "\t\tclk <= '1';\n"
            "\t\twait for 10 ns;\n"
            "\t\tclk <= '0';\n"
            "\t\twait for 10 ns;\n"
            "\t\tclk <= '1';\n"
            "\t\twait for 10 ns;\n"
            "\t\tclk <= '0';\n"
            "\t\twait for 10 ns;\n"
            "\t\tclk <= '1';\n"
            "\t\twait for 10 ns;\n"
            "\t\tclk <= '0';\n"
            "\t\twait for 10 ns;\n"
            "\t\tclk <= '1';\n"
            "\t\twait for 10 ns;\n"
            "\t\tclk <= '0';\n"
            "\t\twait for 10 ns;\n"
            "\n"
            "\t\twait;\n"
            "\tend process;\n"
            "\n"
            "end;\n";





    out.close();

    return 0;
}

