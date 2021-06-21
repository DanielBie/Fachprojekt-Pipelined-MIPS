library ieee;
use ieee.std_logic_1164.all;

entity mips_pipelined_tb is
end;

architecture structure of mips_pipelined_tb is

component mips_pipelined is
  port(
    clk: in std_logic;
    reset: in std_logic
  );
end component;

signal clk, reset : std_logic;

begin
mips : mips_pipelined port map(clk => clk, reset => reset);

process begin
-- reset
clk <= '0';
reset <= '1';
wait for 10 ns;
clk <= '0';
reset <= '0';
wait for 10 ns;

-- addi $1 $0 3
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- addi $2 $0 6
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- addi $3 $0 9
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- addi $4 $0 12
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- addi $5 $0 15
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;


-- add $7 $1 $2
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- and $8 $1 $3
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;


-- sw $4 0
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- sw $5 4
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- sw $6 8
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;

-- idle
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- idle
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;

-- lw $9 0
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- lw $10 4
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- lw $11 8
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;

-- beq $1 $2 +8
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
-- beq $3 $7 +128
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;


-- last 4 cycles of last instruction
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;
clk <= '1';
wait for 10 ns;
clk <= '0';
wait for 10 ns;

wait;
end process;
  
end;