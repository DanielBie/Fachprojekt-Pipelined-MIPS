library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile_tb is
end regfile_tb;

architecture test of regfile_tb is
  component regfile
    port (
      clk: in std_logic;
      we3: in std_logic;
      a1: in std_logic_vector(4 downto 0);
      a2: in std_logic_vector(4 downto 0);
      a3: in std_logic_vector(4 downto 0);
      wd3: in std_logic_vector(31 downto 0);
      rd1: buffer std_logic_vector(31 downto 0);
      rd2: buffer std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, we3 : std_logic;
  signal a1, a2, a3 : std_logic_vector(4 downto 0);
  signal wd3, rd1, rd2 : std_logic_vector(31 downto 0);

begin

  reg: regfile port map(clk=>clk, we3=>we3, a1=>a1, a2=>a2, a3=>a3, wd3=>wd3, rd1=>rd1, rd2=>rd2);

  process begin
    clk <= '0';
    we3 <= '1';
    wd3 <= x"00000002";
    a3 <= "00001";
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    a3 <= "00010";
    wd3 <= x"00000004";
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    a1 <= "00001";
    a2 <= "00010";
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;

    assert false report "End of test";
    wait;
  end process;

end test;