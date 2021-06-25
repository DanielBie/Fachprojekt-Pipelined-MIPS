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
  type ramtype is array (255 downto 0) of std_logic_vector(31 downto 0);
  signal mem: ramtype;
begin
    mem(0) <= "00100000000000010000000000000011"; -- addi $1 $0 3
	
	mem(1) <= "00100000000000100000000000000110"; -- addi $2 $0 6
	
	mem(2) <= "00100000000000110000000000001001"; -- addi $3 $0 9
	
	mem(3) <= "00000000000000000000000000100000"; -- idle
	
	mem(4) <= "00000000001000100010000000100000"; -- add $4 $1 $2
	
	mem(5) <= "00100000000001010000000000001111"; -- addi $5 $0 15
	
	-- mem(5) <= "00100000000001100000000000010010"; -- addi $6 $0 18
	
	mem(6) <= "00000000001000100011100000100000"; -- add $7 $1 $2
	
	mem(7) <= "00000000001000110100000000100100"; -- and $8 $1 $3
	
	mem(8) <= "10101100000001000000000000000000"; -- sw $4 0($0)
	
	mem(9) <= "10101100000001010000000000000100"; -- sw $5 4($0)
	
	mem(10) <= "10101100000001100000000000001000"; -- sw $6 8($0)
	
	mem(11) <= "00000000000000000000000000100000"; -- idle
	
	mem(12) <= "00000000000000000000000000100000"; -- idle
	
	mem(13) <= "10001100000010010000000000000000"; -- lw $9 0($0)
	
	mem(14) <= "10001100000010100000000000000100"; -- lw $10 4($0)
	
	mem(15) <= "10001100000010110000000000001000"; -- lw $11 8($0)
	
	mem(16) <= "00010000001000100000000000001000"; -- beq $1 $2 +8
	
	-- mem(17) <= "00010000011001110000000010000000"; -- beq $3 $7 +128

	mem(17) <= "00001000000000000000000000000000"; -- jmp 0
	
	mem(18) <= "00000000000000000000000000100000"; -- idle
	
	mem(19) <= "00000000000000000000000000100000"; -- idle
	
	mem(20) <= "00000000000000000000000000100000"; -- idle
	
	mem(21) <= "00000000000000000000000000100000"; -- idle

	
	--mem(10) <= "101011 00000 00100 0000000000001000"; -- sw $6 8
	
	--mem(5) <= "00000000000000000000000000100000"; -- idle

  process(pc) begin
	instr <= mem(to_integer(unsigned(pc(31 downto 2))));
	
  end process;
end;
