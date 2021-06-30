library ieee;
use ieee.std_logic_1164.all;

entity data_memory_tb is
end data_memory_tb;

architecture test of data_memory_tb is

    component data_memory is
        port (
            clk      : in std_logic;
            addr     : in std_logic_vector(31 downto 0);
            data_in  : in std_logic_vector(31 downto 0);
            memwrite : in std_logic;
            data_out : out std_logic_vector(31 downto 0)
        );
    end component;

    signal clk, memwrite           : std_logic;
    signal addr, data_in, data_out : std_logic_vector(31 downto 0);

begin

    data_mem : data_memory port map(clk => clk, addr => addr, data_in => data_in, memwrite => memwrite, data_out => data_out);

    process begin
        -- initialisation
        clk      <= '0';
        addr     <= x"00000000";
        data_in  <= x"00000000";
        memwrite <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;

        -- write C to 8
        clk      <= '0';
        addr     <= x"00000008";
        data_in  <= x"0000000C";
        memwrite <= '1';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;

        -- write 0A03070C to C
        clk      <= '0';
        addr     <= x"0000000C";
        data_in  <= x"0A03070C";
        memwrite <= '1';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;

        -- read from 8
        clk      <= '0';
        addr     <= x"00000008";
        data_in  <= x"00000000";
        memwrite <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;

        -- read from C
        clk  <= '0';
        addr <= x"0000000C";
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;

        -- read from 4C
        clk  <= '0';
        addr <= x"0000004C";
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;

        wait;
    end process;
end;