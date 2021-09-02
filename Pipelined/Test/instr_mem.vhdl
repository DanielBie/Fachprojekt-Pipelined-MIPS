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

	mem(0)	<= "00100000000000010000000001100101";	--addi $1 $0 101
	mem(1)	<= "00100000000000100000000000000000";	--addi $2 $0 0
	mem(2)	<= "00100000000000110000000000000000";	--addi $3 $0 0
--	.loop
	mem(3)	<= "00010000001000100000000000000110";	--beq $1 $2 .end
	mem(4)	<= "00000000011000100001100000100000";	--add $3 $3 $2
	mem(5)	<= "00000000010000100010000000100000";	--add $4 $2 $2
	mem(6)	<= "00000000100001000010000000100000";	--add $4 $4 $4
	mem(7)	<= "10101100100000110000000000000000";	--sw $3 0($4)
	mem(8)	<= "00100000010000100000000000000001";	--addi $2 $2 1
	mem(9)	<= "00001000000000000000000000000011";	--j .loop
--	.end
	mem(10)	<= "10001100100001010000000000000000";	--lw $5 0($4)
	mem(11)	<= "11111111111111111111111111111111";	--exit

	process(pc) begin
		instr <= mem(to_integer(unsigned(pc(31 downto 2))));

	end process;
end;
