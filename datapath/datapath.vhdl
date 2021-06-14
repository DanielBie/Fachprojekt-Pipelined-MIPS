-- Some portions of this code are based on code from the book "Digital Design and Computer Architecture" by Harris and Harris.
-- For educational purposes in TU Dortmund only.

library ieee;
use ieee.std_logic_1164.all;

entity datapath is
  port(
    clk: in std_logic;
    reset: in std_logic;
    memtoregD: std_logic;
    alusrcD: in std_logic;
    regdstD: in std_logic;
    regwriteD: in std_logic;
    --jump: in std_logic;
	memwriteD: in std_logic;
	branchD: in std_logic;
    alucontrolD: in std_logic_vector(2 downto 0);
  );
end;

architecture structure of datapath is
  component alu
    port(
      a: in std_logic_vector(31 downto 0);
      b: in std_logic_vector(31 downto 0);
      alucontrol: in std_logic_vector(2 downto 0);
      result: buffer std_logic_vector(31 downto 0);
      zero: out std_logic
    );
    end component;

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

  component adder
    port(
      a: in std_logic_vector(31 downto 0);
      b: in std_logic_vector(31 downto 0);
      y: out std_logic_vector(31 downto 0)
    );
  end component;

  component sl2
    port(
      a: in std_logic_vector(31 downto 0);
      y: out std_logic_vector(31 downto 0)
    );
  end component;

  component signext
    port(
      a: in std_logic_vector(15 downto 0);
      aext: out std_logic_vector(31 downto 0)
    );
  end component;

  component syncresff
    generic(w: integer);
    port(
      clk: in std_logic;
      reset: in std_logic;
      d: in std_logic_vector(w-1 downto 0);
      q: buffer std_logic_vector(w-1 downto 0)
    );
  end component;

  component mux2
    generic(w: integer := 8);
    port(
      d0: in std_logic_vector(w-1 downto 0);
      d1: in std_logic_vector(w-1 downto 0);
      s: in std_logic;
      y: out std_logic_vector(w-1 downto 0)
    );
  end component;
  
  component pipeline_register_D is
	  port (
		clk: in std_logic;
		instr: in std_logic_vector(31 downto 0);
		PCPlus4: in std_logic_vector(31 downto 0);
		instrD: out std_logic_vector(31 downto 0);
		PCPlus4D: out std_logic_vector(31 downto 0)
	  );
  end component;
  
  component pipeline_register_E is
	  port(
		clk: in std_logic;
		RD1: in std_logic_vector(31 downto 0);
		RD2: in std_logic_vector(31 downto 0);
		RtD: in std_logic_vector(4 downto 0);
		RdD: in std_logic_vector(4 downto 0);
		SignExtendD: in std_logic_vector(31 downto 0);
		PCPlus4D: in std_logic_vector(31 downto 0);
		RegWriteD: in std_logic;
		MemToRegD: in std_logic;
		MemWriteD: in std_logic;
		BranchD: in std_logic;
		ALUControlD: in std_logic;
		ALUSrcD: in std_logic;
		RegDstD: in std_logic;
		SrcAE: out std_logic_vector(31 downto 0);
		WriteDataE: out std_logic_vector(31 downto 0);
		RtE: out std_logic_vector(4 downto 0);
		RdE: out std_logic_vector(4 downto 0);
		SignImmE: out std_logic_vector(31 downto 0);
		PCPlus4E: out std_logic_vector(31 downto 0);
		RegWriteE: out std_logic;
		MemToRegE: out std_logic;
		MemWriteE: out std_logic;
		BranchE: out std_logic;
		ALUControlE: out std_logic;
		ALUSrcE: out std_logic;
		RegDstE: out std_logic
	  );
  end component;
  
  component pipeline_register_M is
	  port(
		clk: in std_logic;
		ZeroE: in std_logic;
		ALUOutE: in std_logic_vector(31 downto 0);
		WriteDataE: in std_logic_vector(31 downto 0);
		WriteRegE: in std_logic_vector(4 downto 0);
		PCBranchE: in std_logic_vector(31 downto 0);
		RegWriteE: in std_logic;
		MemToRegE: in std_logic;
		MemWriteE: in std_logic;
		BranchE: in std_logic;

		ZeroM: out std_logic;
		ALUOutM: out std_logic_vector(31 downto 0);
		WriteDataM: out std_logic_vector(31 downto 0);
		WriteRegM: out std_logic_vector(4 downto 0);
		PCBranchM: out std_logic_vector(31 downto 0);
		RegWriteM: out std_logic;
		MemToRegM: out std_logic;
		MemWriteM: out std_logic;
		BranchM: out std_logic
	  );
  end component;
  
  component pipeline_register_W is
	  port (
		clk: in std_logic;
		AluoutM: in std_logic_vector(31 downto 0);
		ReaddataM: in std_logic_vector(31 downto 0);
		RegWriteM: in std_logic;
		MemToRegM: in std_logic;
		WriteRegM: in std_logic_vector(4 downto 0);
		AluoutW: out std_logic_vector(31 downto 0);
		ReaddataW: out std_logic_vector(31 downto 0);
		RegWriteW: out std_logic;
		MemToRegW: out std_logic;
		WriteRegW: out std_logic_vector(4 downto 0)
	  );
  end component;

signal writereg: std_logic_vector(4 downto 0);
signal pc, pcf, pcnextbr, pcplus4, pcbranch: std_logic_vector(31 downto 0);
signal signimm, SignImmEsh: std_logic_vector(31 downto 0);
signal srca, srcb, result: std_logic_vector(31 downto 0);

signal SrcBE std_logic_vector(31 downto 0);
signal ResultW std_logic_vector(31 downto 0);
signal PCSrcM std_logic;
signal PCPlus4F std_logic_vector(31 downto 0);
--D
signal instr, instrD, PCPlus4, PCPlus4D: std_logic_vector(31 downto 0);
--E
signal RegWriteD, MemToRegD, MemWriteD, BranchD, ALUControlD, ALUSrcD, RegDstD, RegWriteE, MemWriteE, MemToRegE, BranchE, ALUControlE, ALUSrcE, RegDstE: std_logic;
signal RtD, RdD, RtE, RdE: std_logic_vector(4 downto 0);
signal RD1, RD2, SignExtendD, PCPlus4D, SrcAE, WriteDataE, SignImmE, PCPlus4E: std_logic_vector(31 downto 0);
--M
signal ZeroE, RegWriteE, MemToRegE, MemWriteE, BranchE, ZeroM, RegWriteM, MemToRegM, MemWriteM, BranchM: std_logic;
signal WriteRegE, WriteRegM: std_logic_vector(4 downto 0);
signal ALUOutE, WriteDataE, WriteBranchE, PCBranchE, ALUOutM, WriteDataM, WriteBranchM, PCBranchM : std_logic_vector(31 downto 0);
--W
signal RegWriteM, RegWriteW, MemToRegM, MemToRegW: std_logic;
signal AluoutM, AluoutW, ReaddataM, ReaddataW: std_logic_vector(31 downto 0);
signal WriteRegM, WriteRegW: std_logic_vector(4 downto 0);


-- clk: in std_logic;
-- reset: in std_logic;
-- memtoreg: std_logic;
-- pcsrc: std_logic;
-- alusrc: in std_logic;
-- regdst: in std_logic;
-- regwrite: in std_logic;
-- jump: in std_logic;
-- alucontrol: in std_logic_vector(2 downto 0);
-- readdata: in std_logic_vector(31 downto 0);
-- instr: in std_logic_vector(31 downto 0);
-- zero: out std_logic;
-- pc: buffer std_logic_vector(31 downto 0);
-- aluout: buffer std_logic_vector(31 downto 0);
-- writedata: buffer std_logic_vector(31 downto 0)


begin
  
  -- next pc logic
  -- pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00";
  -- pc register
  -- [1]
  pcreg: syncresff generic map(32) port map(clk => clk, reset => reset, d => pc, q => pcf);
  -- adder for pc+4
  -- [2]
  pcadd1: adder port map(pcf, x"00000004", PCPlus4F);
  -- shift left2
  -- [3]
  immsh: sl2 port map(SignImmE, SignImmEsh);
  -- adder to add immediate to pc+4 as an option for branch
  -- [4]
  pcadd2: adder port map(PCPlus4E, SignImmEsh, PCBranchE);
  -- mux to chose between branch address or pc+4
  -- [5]
  pcbrmux: mux2 generic map(32) port map(PCPlus4F, PCBranchM, PCSrcM, pc);
  -- chose signimmsh+pc+4 or jump address as next pc value
  -- [6]
  -- pcmux: mux2 generic map(32) port map(pcnextbr, pcjump, jump,
  -- pcnext);
  -- register file logic
  -- [7]
  rf: regfile port map(clk => clk, we3 => RegWriteW, a1 => instrD(25 downto 21), a2 => instrD(20 downto 16), a3 => WriteRegW, wd3 => ResultW, rd1 => RD1, rd2 => RD2);
  -- mux for deciding into which register (out of the two specified in the instruction) to write
  -- [8]
  wrmux: mux2 generic map(5) port map(d0 => RtE, d1 => RdE, s => RegDstE, y => WriteRegE);
  -- chose to store value from alu or memory to register
  -- [9]
  resmux: mux2 generic map(32) port map(AluoutW, ReaddataW, MemToRegW, ResultW);
  -- sign extender
  -- [10]
  se: signext port map(instrD(15 downto 0), SignExtendD);
  -- chose rd2 or sign extended value (add immediate to a register or add two values in registers)
  -- [11]
  srcbmux: mux2 generic map(32) port map(WriteDataE, SignImmE, ALUSrcE, SrcBE);
  -- alu
  --[12]
  mainalu: alu port map(SrcAE, SrcBE, ALUControlE, ALUOutE, ZeroE);
end;




















