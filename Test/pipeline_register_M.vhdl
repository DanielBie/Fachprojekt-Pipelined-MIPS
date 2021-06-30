library ieee;
use ieee.std_logic_1164.all;

entity pipeline_register_M is
    port (
        clk        : in std_logic;
        ZeroE      : in std_logic;
        ALUOutE    : in std_logic_vector(31 downto 0);
        WriteDataE : in std_logic_vector(31 downto 0);
        WriteRegE  : in std_logic_vector(4 downto 0);
        PCBranchE  : in std_logic_vector(31 downto 0);
        RegWriteE  : in std_logic;
        MemToRegE  : in std_logic;
        MemWriteE  : in std_logic;
        BranchE    : in std_logic;

        ZeroM      : out std_logic;
        ALUOutM    : out std_logic_vector(31 downto 0);
        WriteDataM : out std_logic_vector(31 downto 0);
        WriteRegM  : out std_logic_vector(4 downto 0);
        PCBranchM  : out std_logic_vector(31 downto 0);
        RegWriteM  : out std_logic;
        MemToRegM  : out std_logic;
        MemWriteM  : out std_logic;
        BranchM    : out std_logic
    );
end;

architecture structure of pipeline_register_M is
    type ramtype_32 is array (2 downto 0) of std_logic_vector(31 downto 0);
    type ramtype_5 is array (0 downto 0) of std_logic_vector(4 downto 0);
    type ramtype_1 is array (4 downto 0) of std_logic;
    signal mem_32 : ramtype_32;
    signal mem_5  : ramtype_5;
    signal mem_1  : ramtype_1;
begin
    process (clk) begin
        if rising_edge(clk) then
            mem_1(0) <= ZeroE;
            mem_1(1) <= RegWriteE;
            mem_1(2) <= MemToRegE;
            mem_1(3) <= MemWriteE;
            mem_1(4) <= BranchE;

            mem_5(0) <= WriteRegE;

            mem_32(0) <= ALUOutE;
            mem_32(1) <= WriteDataE;
            mem_32(2) <= PCBranchE;
        end if;
    end process;
    ZeroM     <= mem_1(0);
    RegWriteM <= mem_1(1);
    MemToRegM <= mem_1(2);
    MemWriteM <= mem_1(3);
    BranchM   <= mem_1(4);

    WriteRegM <= mem_5(0);

    ALUOutM    <= mem_32(0);
    WriteDataM <= mem_32(1);
    PCBranchM  <= mem_32(2);
end;