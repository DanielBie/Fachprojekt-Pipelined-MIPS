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

	mem(0)	<= "00100000000000010000000000000101";	--addi $1 $0 5
	mem(1)	<= "00100000000000100000000000000010";	--addi $2 $0 2
	mem(2)	<= "00000000010000010000100000100000";	--add $1 $2 $1
	mem(3)	<= "11111111111111111111111111111111";	--exit

	process(pc) begin
		instr <= mem(to_integer(unsigned(pc(31 downto 2))));

	end process;
end;
