
cd Pipelined
./runPipelined.sh $1

cd ../Pipelined-Only-Stalls
./runOnlyStalls.sh $1

cd ../SCP
./runSingleCycle.sh $1