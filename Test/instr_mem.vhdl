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

	mem(0)	<= "00100000000000010000000001100100";	--addi $1 $0 100
	mem(1)	<= "00100000000000100000000000000000";	--addi $2 $0 0
	mem(2)	<= "00100000000000110000000000000000";	--addi $3 $0 0
--	.Loop
	mem(3)	<= "00010000010000010000000000000011";	--beq $2 $1 .End
	mem(4)	<= "00100000010000100000000000000001";	--addi $2 $2 1
	mem(5)	<= "00000000011000100001100000100000";	--add $3 $3 $2
	mem(6)	<= "00001000000000000000000000000011";	--j .Loop
--	.End
	mem(7)	<= "10101100000000110000000000000000";	--sw $3 0($0)
	mem(8)	<= "11111111111111111111111111111111";	--exit

	process(pc) begin
		instr <= mem(to_integer(unsigned(pc(31 downto 2))));

	end process;
end;
