library ieee;
use ieee.std_logic_1164.all;

entity mips_mem_tb is
end mips_mem_tb;

architecture test of mips_mem_tb is

  component mips_mem is
    port(
		clk: in std_logic;
		reset: in std_logic
	);
  end component;

  signal clk, reset : std_logic;
  
begin

	data_mem : mips_mem port map(clk => clk, reset => reset);
	
  process begin
	-- reset
	clk <= '0';
    reset <= '1';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	reset <= '0';
	wait for 10 ns;
	-- start
	
	-- addi $0 $2 4
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	-- addi $0 $3 8
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	-- add $2 $3 $4
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	-- addi $0 $8 8
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	-- jump 6
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	-- beq $3 $8 12
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	-- sw $3 $0(56)
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	-- sw $4 $0(16)
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	-- lw $5 $0(56)
	clk <= '1';
	wait for 10 ns;
	clk <= '0';
	wait for 10 ns;
	-- lw $6 $0(16)
	clk <= '1';
	wait for 10 ns;
	
	wait;
  end process;
end;
