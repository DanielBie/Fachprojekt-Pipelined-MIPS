library ieee;
use ieee.std_logic_1164.all;

entity instr_mem_tb is
end instr_mem_tb;

architecture test of instr_mem_tb is

    component instr_mem is
        port (
            pc    : in std_logic_vector(31 downto 0);
            instr : out std_logic_vector(31 downto 0)
        );
    end component;

    signal pc, instr : std_logic_vector(31 downto 0);

begin

    intr_m : instr_mem port map(pc => pc, instr => instr);

    process begin

    pc <= x"00000000";
    wait for 10 ns;
    pc <= x"00000004";
    wait for 10 ns;
    pc <= x"00000008";
    wait for 10 ns;
    pc <= x"0000000C";
    wait for 10 ns;
    pc <= x"00000010";
    wait for 10 ns;
    pc <= x"00000014";
    wait for 10 ns;
    pc <= x"00000018";
    wait for 10 ns;

    wait;
  end process;
end;