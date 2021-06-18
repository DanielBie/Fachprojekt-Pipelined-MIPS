-- Some portions of this code are based on code from the book "Digital Design and Computer Architecture" by Harris and Harris.
-- For educational purposes in TU Dortmund only.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_mem is
  port (
    pc: in std_logic_vector(31 downto 0);
    instr: out std_logic_vector(31 downto 0)
  );
end;

architecture behavior of instr_mem is
  type ramtype is array (255 downto 0) of std_logic_vector(7 downto 0);
  signal mem: ramtype;
begin
    mem(0) <= "00000100"; -- addi $0 $2 4
	mem(1) <= "00000000";
	mem(2) <= "00000010";
	mem(3) <= "00100000";
	
	mem(4) <= "00001000"; -- addi $0 $3 8
	mem(5) <= "00000000";
	mem(6) <= "00000011";
	mem(7) <= "00100000";
	
	mem(8) <= "00100000"; -- add $2 $3 $4
	mem(9) <= "00100000";
	mem(10) <= "01000011";
	mem(11) <= "00000000";
	
	mem(12) <= "00001000"; -- addi $0 $2 4
	mem(13) <= "00000000";
	mem(14) <= "00001000";
	mem(15) <= "00100000";
	
	mem(16) <= "00000110"; -- jump 6
	mem(17) <= "00000000";
	mem(18) <= "00000000";
	mem(19) <= "00001000";
	
	mem(24) <= "00001100"; -- beq $3 $8 12
	mem(25) <= "00000000";
	mem(26) <= "01101000";
	mem(27) <= "00010000";
	
	mem(76) <= "00111000"; -- sw $3 $0(56)
	mem(77) <= "00000000";
	mem(78) <= "00000011";
	mem(79) <= "10101100";
	
	mem(80) <= "00010000"; -- sw $4 $0(16)
	mem(81) <= "00000000";
	mem(82) <= "00000100";
	mem(83) <= "10101100";
	
	mem(84) <= "00111000"; -- lw $5 $0(56)
	mem(85) <= "00000000";
	mem(86) <= "00000101";
	mem(87) <= "10001100";
	
	mem(88) <= "00010000"; -- lw $6 $0(16)
	mem(89) <= "00000000";
	mem(90) <= "00000110";
	mem(91) <= "10001100";
	
	

  process(pc) begin
	instr <= mem(to_integer(unsigned(pc))+3) &
			 mem(to_integer(unsigned(pc))+2) &
			 mem(to_integer(unsigned(pc))+1) &
			 mem(to_integer(unsigned(pc)));
	
  end process;
end;
