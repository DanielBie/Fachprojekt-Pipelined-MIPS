#include<iostream>
#include<fstream>
#include <bitset>
#include <string>
#include <sstream>


enum Instr {rtype, lw, sw, beq, addi, j, idle};
enum RType {rAdd, rSub, rAnd, rOr, rSlt};

void assembleFile(std::string input, std::string output);
std::string rtypeInstr(int r1, int r2, int r3, RType type);
std::string lwInstr(int r1, int offset, int r2);
std::string swInstr(int r1, int offset, int r2);
std::string beqInstr(int r1, int r2, int offset);
std::string addiInstr(int r1, int r2, int offset);
std::string jInstr(int address);
std::string intToBitString(int i, int length);

int main(int argc, char **argv){
    std::string inPath;
    std::string outPath;

    if(argc == 2){
        inPath = argv[1];
        outPath = "out.txt";
    } else if(argc == 3){
        inPath = argv[1];
        outPath = argv[2];
    }
    assembleFile(inPath, outPath);

    return 0;
}

void assembleFile(std::string input, std::string output){
    std::ifstream in(input);
    std::ofstream out(output);

    int memloc = 0;


    std::string line;
    if(in.is_open()){
        while (std::getline(in, line)){
            std::stringstream ss(line);
            std::string entry;
            int num = 0;
            Instr inst;
            RType r;
            int r1;
            int r2;
            int r3;
            int offset;


            while( std::getline(ss, entry,' ') ) {
                std::string off;
                std::string reg;
                bool first = false;
                switch (num){
                    case 0:
                        if(entry.compare("lw") == 0){
                            inst = lw;
                        } else if(entry.compare("sw") == 0){
                            inst = sw;
                        } else if(entry.compare("beq") == 0){
                            inst = beq;
                        } else if(entry.compare("addi") == 0){
                            inst = addi;
                        } else if(entry.compare("j") == 0){
                            inst = j;
                        } else if(entry.compare("idle") == 0){
                            inst = idle;
                        } else {
                            inst = rtype;
                            if(entry.compare("add") == 0){
                                r = rAdd;
                            } else if(entry.compare("sub") == 0){
                                r = rSub;
                            } else if(entry.compare("and") == 0){
                                r = rAnd;
                            } else if(entry.compare("or") == 0){
                                r = rOr;
                            } else if(entry.compare("slt") == 0){
                                r = rSlt;
                            }
                        }
                        break;
                    
                    case 1:
                        switch (inst){
                            case rtype:
                            case lw:
                            case sw:
                            case beq:
                            case addi:
                                r1 = std::stoi(entry.substr(1, entry.size()));
                                break;

                            case j:
                                offset = std::stoi(entry);
                                break;

                            default:
                                break;
                        }
                        break;

                    case 2:
                        switch (inst){
                            case rtype:
                            case beq:
                            case addi:
                                r2 = std::stoi(entry.substr(1, entry.size()));
                                break;

                            case lw:
                            case sw:
                                first = true;
                                off = "";
                                reg="";
                                for(int i=0; i<entry.size(); ++i){
                                    if(first && entry[i] != '('){
                                        off += entry[i];
                                    } else if (entry[i] == '('){
                                        first = false;
                                    } else if(entry[i] != ')' && entry[i] != '$'){
                                        reg += entry[i];
                                    }
                                }
                                offset = std::stoi(off);
                                r2 = std::stoi(reg);

                            default:
                                break;
                        }
                        break;

                    case 3:
                        switch (inst){
                            case rtype:
                                r3 = std::stoi(entry.substr(1, entry.size()));
                                break;

                            case beq:
                            case addi:
                                offset = std::stoi(entry);

                                break;

                            default:
                                break;
                        }
                        break;
                    
                    default:
                        break;
                }
                
                num++;
            }

            switch (inst){
            case rtype:
                out << "mem(" << memloc++ << ") <= \"" << rtypeInstr(r1, r2, r3, r) << "\"; --" << line << std::endl;
                break;

            case lw:
                out << "mem(" << memloc++ << ") <= \"" << lwInstr(r1, offset, r2) << "\"; --" << line << std::endl;
                break;

            case sw:
                out << "mem(" << memloc++ << ") <= \"" << swInstr(r1, offset, r2) << "\"; --" << line << std::endl;
                break;

            case beq:
                out << "mem(" << memloc++ << ") <= \"" << beqInstr(r1, r2, offset) << "\"; --" << line << std::endl;
                break;

            case addi:
                out << "mem(" << memloc++ << ") <= \"" << addiInstr(r1, r2, offset) << "\"; --" << line << std::endl;
                break;

            case j:
                out << "mem(" << memloc++ << ") <= \"" << jInstr(offset) << "\"; --" << line << std::endl;
                break;

            case idle:
                out << "mem(" << memloc++ << ") <= \"00000000000000000000000000100000\"; --" << line << std::endl;
                break;
            
            default:
                break;
            }
        }
        
    }

    in.close();

    out.close();
}

std::string rtypeInstr(int r1, int r2, int r3, RType type){
    std::string out = "";

    out += "000000";
    out += intToBitString(r2, 5);
    out += intToBitString(r3, 5);
    out += intToBitString(r1, 5);
    out += "00000";
    switch (type){
    case rAdd:
        out += "100000";
        break;

    case rSub:
        out += "100010";
        break;

    case rAnd:
        out += "100100";
        break;

    case rOr:
        out += "100101";
        break;

    case rSlt:
        out += "101010";
        break;
    
    default:
        break;
    }
    
    return out;
}

std::string lwInstr(int r1, int offset, int r2){
    std::string out = "";

    out += "100011";
    out += intToBitString(r2, 5);
    out += intToBitString(r1, 5);
    out += intToBitString(offset, 16);

    
    return out;
}

std::string swInstr(int r1, int offset, int r2){
    std::string out = "";

    out += "101011";
    out += intToBitString(r2, 5);
    out += intToBitString(r1, 5);
    out += intToBitString(offset, 16);

    
    return out;
}

std::string beqInstr(int r1, int r2, int offset){
    std::string out = "";

    out += "000100";
    out += intToBitString(r1, 5);
    out += intToBitString(r2, 5);
    out += intToBitString(offset, 16);

    
    return out;
}

std::string addiInstr(int r1, int r2, int offset){
    std::string out = "";

    out += "001000";
    out += intToBitString(r2, 5);
    out += intToBitString(r1, 5);
    out += intToBitString(offset, 16);

    
    return out;
}

std::string jInstr(int address){
    std::string out = "";

    out += "000010";
    out += intToBitString(address, 26);

    
    return out;
}

std::string intToBitString(int i, int length){
    std::string s;
    switch (length){
    case 1:
        s = std::bitset< 1 >( i ).to_string();
        break;

    case 2:
        s = std::bitset< 2 >( i ).to_string();
        break;

    case 3:
        s = std::bitset< 3 >( i ).to_string();
        break;

    case 4:
        s = std::bitset< 4 >( i ).to_string();
        break;

    case 5:
        s = std::bitset< 5 >( i ).to_string();
        break;

    case 6:
        s = std::bitset< 6 >( i ).to_string();
        break;

    case 7:
        s = std::bitset< 7 >( i ).to_string();
        break;

    case 8:
        s = std::bitset< 8 >( i ).to_string();
        break;

    case 9:
        s = std::bitset< 9 >( i ).to_string();
        break;

    case 10:
        s = std::bitset< 10 >( i ).to_string();
        break;

    case 11:
        s = std::bitset< 11 >( i ).to_string();
        break;

    case 12:
        s = std::bitset< 12 >( i ).to_string();
        break;

    case 13:
        s = std::bitset< 13 >( i ).to_string();
        break;

    case 14:
        s = std::bitset< 14 >( i ).to_string();
        break;

    case 15:
        s = std::bitset< 15 >( i ).to_string();
        break;

    case 16:
        s = std::bitset< 16 >( i ).to_string();
        break;

    case 26:
        s = std::bitset< 26 >( i ).to_string();
        break;

    default:
        break;
    }
    
    return s;
}
