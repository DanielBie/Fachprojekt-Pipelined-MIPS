library ieee;
use ieee.std_logic_1164.all;

entity mips_pipelined_tb is
end;

architecture structure of mips_pipelined_tb is

	component mips_pipelined is
		port (
			clk    : in std_logic;
			reset  : in std_logic;
			instrD : out std_logic_vector(31 downto 0)
		);
	end component;

	signal clk, reset : std_logic;
	signal instr : std_logic_vector(31 downto 0);
	signal count : integer;

begin
	mips : mips_pipelined port map(clk => clk, reset => reset, instrD => instr);

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
	while instr /= x"11111111" loop
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		count <= count + 1;
	end loop;
	
	assert false report "Cycles used for completion: " & integer'image(count);
	
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
