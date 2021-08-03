library ieee;use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_mem is
	port (
		pc: in std_logic_vector(31 downto 0);
		instr: out std_logic_vector(31 downto 0)
	);
end;

architecture behavior of instr_mem is
	type ramtype is array (255 downto 0) of std_logic_vector(31 downto 0);
	signal mem: ramtype;
begin

	mem(0)	<= "10101100000000000000000000000000";	--sw $0 0($0) 
	mem(1)	<= "00100000000000010000000000000001";	--addi $1 $0 1
	mem(2)	<= "10101100000000010000000000000100";	--sw $1 4($0) 
	mem(3)	<= "00100000000000010000000000101110";	--addi $1 $0 46  
	mem(4)	<= "00100000000000100000000000000010";	--addi $2 $0 2    
	mem(5)	<= "00010000000000010000000000010100";	--beq $0 $1 .End
	mem(6)	<= "00100000000000110000000000000001";	--addi $3 $0 1
	mem(7)	<= "00010000011000010000000000010010";	--beq $3 $1 .End
--	.Loop
	mem(8)	<= "00100000000000110000000000000001";	--addi $3 $0 1
	mem(9)	<= "00100000000001000000000000000010";	--addi $4 $0 2
	mem(10)	<= "00000000010000110010100000100010";	--sub $5 $2 $3
	mem(11)	<= "00000000010001000011000000100010";	--sub $6 $2 $4
	mem(12)	<= "00000000101001010010100000100000";	--add $5 $5 $5
	mem(13)	<= "00000000101001010010100000100000";	--add $5 $5 $5
	mem(14)	<= "00000000110001100011000000100000";	--add $6 $6 $6
	mem(15)	<= "00000000110001100011000000100000";	--add $6 $6 $6
	mem(16)	<= "10001100101000110000000000000000";	--lw $3 0($5) 
	mem(17)	<= "10001100110001000000000000000000";	--lw $4 0($6) 
	mem(18)	<= "00000000011001000010100000100000";	--add $5 $3 $4
	mem(19)	<= "00100000010001100000000000000000";	--addi $6 $2 0
	mem(20)	<= "00000000110001100011000000100000";	--add $6 $6 $6
	mem(21)	<= "00000000110001100011000000100000";	--add $6 $6 $6
	mem(22)	<= "10101100110001010000000000000000";	--sw $5 0($6)
	mem(23)	<= "00010000001000100000000000000010";	--beq $1 $2 .End
	mem(24)	<= "00100000010000100000000000000001";	--addi $2 $2 1
	mem(25)	<= "00001000000000000000000000001000";	--j .Loop
--	.End
	mem(26)	<= "00100000010000110000000000000000";	--addi $3 $2 0
	mem(27)	<= "00000000011000110001100000100000";	--add $3 $3 $3
	mem(28)	<= "00000000011000110001100000100000";	--add $3 $3 $3
	mem(29)	<= "10001100011010100000000000000000";	--lw $10 0($3)
	mem(30)	<= "11111111111111111111111111111111";	--exit

	process(pc) begin
		instr <= mem(to_integer(unsigned(pc(31 downto 2))));

	end process;
end;
