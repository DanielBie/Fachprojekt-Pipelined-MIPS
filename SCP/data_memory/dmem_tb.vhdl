library ieee;
use ieee.std_logic_1164.all;

entity dmem_tb is
end dmem_tb;

architecture test of dmem_tb is
  component dmem
    port (
      clk, we: in std_logic;
      a, wd: in std_logic_vector (31 downto 0);
      rd: out std_logic_vector (31 downto 0)
    );
  end component;

signal clk, we: std_logic;
signal a, wd, rd: std_logic_vector(31 downto 0);
begin
  dmem_test: dmem port map(clk => clk, we => we, a => a, wd => wd, rd => rd);

  process begin
    clk <= '0';
    a <= x"0000000f";
    wait for 10 ns;
    we <= '1';
    wd <= x"ffffffff";
    clk <= '1';
    wait for 10 ns;

    clk <= '0';
    wait for 10 ns;

    a <= x"000000f0";
    we <= '1';
    wd <= x"fffffff0";
    clk <= '1';
    wait for 10 ns;

    clk <= '0';
    we <= '0';
    a <= x"000000f0";
    wait for 10 ns;
    a <= x"00000000";
    wait for 10 ns;
    wait;
  end process;
end test;
