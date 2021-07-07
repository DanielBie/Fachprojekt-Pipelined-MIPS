num=0

for d in *;
do
    if [ -d "${d}" ];
    then
        if [ $d != "Test" -a $d != "Assembler" -a $d != "Documentation" ]
        then
            cd $d
            for filename in *.vhdl;
            do
                if [[ "$filename" != *"_tb"* ]];
                then
                    cd ..
                    cp -R $d/$filename Test/
                fi
            done
        fi
    fi
done


cp -R mips-pipelined/mips_pipelined_tb.vhdl Test/

cd Assembler

num=$(wc -l "../$1" | awk '{ print $1 }')
num="$((num*4))"
g++ tbGenerator.cpp -o tbGenerator.out
./tbGenerator.out ../Test/mips_pipelined_tb.vhdl $num

g++ Assembler.cpp -o Assembler.out
./Assembler.out "../$1" ../Test/instr_mem.vhdl
cd ..

cd Test

./compileAll.sh
echo
./compile.sh mips_pipelined_tb.vhdl