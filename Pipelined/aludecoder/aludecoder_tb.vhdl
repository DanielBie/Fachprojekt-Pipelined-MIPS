
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aludecoder_tb is
end;

architecture behavior of aludecoder_tb is
    component aludecoder
        port (
            funct       : in std_logic_vector(5 downto 0);
            aluop       : in std_logic_vector(1 downto 0);
            AluControlE : out std_logic_vector(2 downto 0)
        );
    end component;

    signal funct : std_logic_vector(5 downto 0);
    signal aluop       : std_logic_vector(1 downto 0);
    signal AluControlE : std_logic_vector(2 downto 0);

begin
    aludcdec : aludecoder port map(funct, aluop, AluControlE);
    process begin
        aluop <= "00";
        assert AluControlE /= "010" report "Error with aluop";
        wait for 10 ns;

        aluop <= "01";
        assert AluControlE /= "110" report "Error with aluop";
        wait for 10 ns;

        aluop <= "11";
        
        funct <= "100000";
        assert AluControlE /= "010" report "Error with funct";
        wait for 10 ns;

        funct <= "100010";
        assert AluControlE /= "110" report "Error with funct";
        wait for 10 ns;

        funct <= "100100";
        assert AluControlE /= "000" report "Error with funct";
        wait for 10 ns;

        funct <= "100101";
        assert AluControlE /= "001" report "Error with funct";
        wait for 10 ns;

        funct <= "101010";
        assert AluControlE /= "111" report "Error with funct";
        wait for 10 ns;

        wait;
    end process;
end;
