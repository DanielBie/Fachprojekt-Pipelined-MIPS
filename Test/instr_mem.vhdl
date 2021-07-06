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

	mem(0)	<= "00100000000000010000000000000010";	--addi $1 $0 2
	mem(1)	<= "00100000000000100000000000000110";	--addi $2 $0 6
	mem(2)	<= "00100000000000110000000000001001";	--addi $3 $0 9
	mem(3)	<= "00010000001000100000000010000000";	--beq $1 $2 128
	mem(4)	<= "00010000011000110000000000000010";	--beq $3 $3 2
	mem(5)	<= "00000000000000000000000000100000";	--idle
	mem(6)	<= "00000000000000000000000000100000";	--idle
	mem(7)	<= "00000000010000110000100000100000";	--add $1 $2 $3
	mem(8)	<= "00000000000000000000000000100000";	--idle
	mem(9)	<= "00000000000000000000000000100000";	--idle
	mem(10)	<= "00000000000000000000000000100000";	--idle
	mem(11)	<= "00000000000000000000000000100000";	--idle
	mem(12)	<= "00000000010000110000100000100000";	--add $1 $2 $3

	process(pc) begin
		instr <= mem(to_integer(unsigned(pc(31 downto 2))));

	end process;
end;
