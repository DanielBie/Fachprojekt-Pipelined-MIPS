-- Some portions of this code are based on code from the book "Digital Design and Computer Architecture" by Harris and Harris.
-- For educational purposes in TU Dortmund only.

library ieee;
use ieee.std_logic_1164.all;

entity mips_pipelined is
  port(
    clk: in std_logic;
    reset: in std_logic
  );
end;

architecture structure of mips_pipelined is
  component controller is
    port(
      op: in std_logic_vector(5 downto 0);
      funct: in std_logic_vector(5 downto 0);
      RegWriteD: out std_logic;
      MemToRegD: out std_logic;
      MemWriteD: out std_logic;
      BranchD: out std_logic;
      ALuControlD: out std_logic_vector(2 downto 0);
      AluSrcD: out std_logic;
      RegDstD: out std_logic;
      JumpD: out std_logic
    );
  end component;

  component datapath is
    port(
      clk: in std_logic;
		reset: in std_logic;
		ForwardAE: in std_logic_vector(1 downto 0);
		ForwardBE: in std_logic_vector(1 downto 0);
		MemToRegD: std_logic;
		ALUSrcD: in std_logic;
		RegDstD: in std_logic;
		RegWriteD: in std_logic;
		jump: in std_logic;
		MemWriteD: in std_logic;
		BranchD: in std_logic;
		ALUControlD: in std_logic_vector(2 downto 0);
		OpD: out std_logic_vector(5 downto 0);
		FunctD: out std_logic_vector(5 downto 0);
		RsE_out: buffer std_logic_vector(4 downto 0);
		RtE_out: buffer std_logic_vector(4 downto 0);
		RegWriteM_out: buffer std_logic;
		RegWriteW_out: buffer std_logic;
		WriteRegM_out: buffer std_logic_vector(4 downto 0);
		WriteRegW_out: buffer std_logic_vector(4 downto 0)
    );
  end component;
  
  component Hazard_Unit is
    port(
      RsE: in std_logic_vector(4 downto 0);
      RtE: in std_logic_vector(4 downto 0);
      RegWriteM: in std_logic;
      RegWriteW: in std_logic;
      WriteRegM: in std_logic_vector(4 downto 0);
      WriteRegW: in std_logic_vector(4 downto 0);
	  ForwardAE: out std_logic_vector(1 downto 0);
	  ForwardBE: out std_logic_vector(1 downto 0)
    );
  end component;

  signal RegWriteM, RegWriteW, RegWriteD, MemToRegD, MemWriteD, BranchD, ALUSrcD, RegDstD, JumpD: std_logic;
  signal ForwardAE, ForwardBE: std_logic_vector(1 downto 0);
  signal ALUControlD: std_logic_vector(2 downto 0);
  signal RsE, RtE, WriteRegM, WriteRegW: std_logic_vector(4 downto 0);
  signal OpD, FunctD: std_logic_vector(5 downto 0);
begin
  mips_control: controller port map(
    OpD,
    FunctD,
    RegWriteD,
    MemToRegD,
    MemWriteD,
    BranchD,
    ALUControlD,
    ALUSrcD,
    RegDstD,
    JumpD
    );
  mips_datapath: datapath port map(
    clk,
    reset,
	ForwardAE,
	ForwardBE,
    MemToRegD,
    ALUSrcD,
    RegDstD,
    RegWriteD,
    JumpD,
    MemWriteD,
    BranchD,
    ALUControlD,
    OpD,
    FunctD,
	RsE,
	RtE,
	RegWriteM,
	RegWriteW,
	WriteRegM,
	WriteRegW
  );
  hazard_mips: Hazard_Unit port map(
    RsE,
	RtE,
	RegWriteM,
	RegWriteW,
	WriteRegM,
	WriteRegW,
	ForwardAE,
	ForwardBE
  );
  
  
end;
