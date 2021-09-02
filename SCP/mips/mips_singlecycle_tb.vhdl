library ieee;
use ieee.std_logic_1164.all;

entity mips_singlecycle_tb is
end;

architecture structure of mips_singlecycle_tb is

	component mips_mem is
	port(
		clk: in std_logic;
		reset: in std_logic;
		instr_out: out std_logic_vector(31 downto 0)
	);
	end component;

	signal clk, reset : std_logic;
	signal instr : std_logic_vector(31 downto 0);
	signal count : integer;

begin
	mips : mips_mem port map(clk => clk, reset => reset, instr_out => instr);

	process begin
	
		count <= 0;
		-- reset
		clk   <= '0';
		reset <= '1';
		wait for 10 ns;
		clk   <= '0';
		reset <= '0';
		wait for 10 ns;

	-- do cylces until end instruction
	while instr /= x"FFFFFFFF" loop
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		count <= count + 1;
	end loop;
	
	assert false report "Cycles used for completion: " & integer'image(count);
	
		-- last cycle for end instruction
		clk <= '1';
		wait for 10 ns;

		wait;
	end process;

end;
