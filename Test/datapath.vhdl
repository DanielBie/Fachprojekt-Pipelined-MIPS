-- Some portions of this code are based on code from the book "Digital Design and Computer Architecture" by Harris and Harris.
-- For educational purposes in TU Dortmund only.

library ieee;
use ieee.std_logic_1164.all;

entity datapath is
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
    port(
      clk: in std_logic;
      reset: in std_logic;
      d: in std_logic_vector(31 downto 0);
      q: buffer std_logic_vector(31 downto 0)
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

  component data_memory is
	generic (size : Integer := 63);
	port (
	  clk : in std_logic;
	  addr: in std_logic_vector(31 downto 0);
	  data_in: in std_logic_vector(31 downto 0);
	  memwrite : in std_logic;
	  data_out: out std_logic_vector(31 downto 0)
	);
  end component;

  component instr_mem is
	port (
	  pc: in std_logic_vector(31 downto 0);
	  instr: out std_logic_vector(31 downto 0)
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
		RsD: in std_logic_vector(4 downto 0);
		RtD: in std_logic_vector(4 downto 0);
		RdD: in std_logic_vector(4 downto 0);
		SignExtendD: in std_logic_vector(31 downto 0);
		PCPlus4D: in std_logic_vector(31 downto 0);
		RegWriteD: in std_logic;
		MemToRegD: in std_logic;
		MemWriteD: in std_logic;
		BranchD: in std_logic;
		ALUControlD: in std_logic_vector(2 downto 0);
		ALUSrcD: in std_logic;
		RegDstD: in std_logic;
		SrcAE: out std_logic_vector(31 downto 0);
		WriteDataE: out std_logic_vector(31 downto 0);
		RsE: out std_logic_vector(4 downto 0);
		RtE: out std_logic_vector(4 downto 0);
		RdE: out std_logic_vector(4 downto 0);
		SignImmE: out std_logic_vector(31 downto 0);
		PCPlus4E: out std_logic_vector(31 downto 0);
		RegWriteE: out std_logic;
		MemToRegE: out std_logic;
		MemWriteE: out std_logic;
		BranchE: out std_logic;
		ALUControlE: out std_logic_vector(2 downto 0);
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
		ReadDataM: in std_logic_vector(31 downto 0);
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

  component mux4 is
    generic(w: integer := 8);
    port(
	  d0: in std_logic_vector(w-1 downto 0);
	  d1: in std_logic_vector(w-1 downto 0);
	  d2: in std_logic_vector(w-1 downto 0);
	  d3: in std_logic_vector(w-1 downto 0);
	  s: in std_logic_vector(1 downto 0);
	  y: out std_logic_vector(w-1 downto 0)
    );
  end component;



--F
signal pc, pcf, PCPlus4F, instrF, PCBranchF: std_logic_vector(31 downto 0);
--D
-- signal RegWriteD, MemToRegD, MemWriteD, BranchD, ALUControlD, ALUSrcD, RegDstD: std_logic;
signal not_clk: std_logic;
signal RtD, RdD: std_logic_vector(4 downto 0);
signal RD1, RD2, SignExtendD, PCPlus4D, instrD, PCJumpD: std_logic_vector(31 downto 0);
--E
signal ZeroE, RegWriteE, MemWriteE, MemToRegE, BranchE, ALUSrcE, RegDstE: std_logic;
signal ALUControlE: std_logic_vector(2 downto 0);
signal WriteRegE, RdE, RtE, RsE: std_logic_vector(4 downto 0);
signal RD1E, RD2E, SrcAE, SrcBE, WriteDataE, SignImmE, PCPlus4E, SignImmEsh, ALUOutE, WriteBranchE, PCBranchE: std_logic_vector(31 downto 0);
--M
signal PCSrcM, ZeroM, MemToRegM, MemWriteM, BranchM, RegWriteM: std_logic;
signal WriteRegM: std_logic_vector(4 downto 0);
signal ALUOutM, WriteDataM, WriteBranchM, PCBranchM, ReadDataM: std_logic_vector(31 downto 0);
--W
signal MemToRegW, RegWriteW: std_logic;
signal WriteRegW: std_logic_vector(4 downto 0);
signal AluoutW, ReaddataW, ResultW: std_logic_vector(31 downto 0);


begin
  --instr zerstueckeln
  OpD <= instrD(31 downto 26);
  
  FunctD <= instrD(5 downto 0);
  
  RtD <= instrD(20 downto 16);
  
  RdD <= instrD(15 downto 11);
  
  -- next pc logic
  PCJumpD <= PCPlus4D(31 downto 28) & InstrD(25 downto 0) & "00";
  
  -- pc register
  pcreg: syncresff port map(clk => clk, reset => reset, d => pc, q => pcf);
  
  -- adder for pc+4
  pcadd1: adder port map(pcf, x"00000004", PCPlus4F);
  
  -- shift left2
  immsh: sl2 port map(SignImmE, SignImmEsh);
  
  -- adder to add immediate to pc+4 as an option for branch
  pcadd2: adder port map(PCPlus4E, SignImmEsh, PCBranchE);
  
  -- mux to chose between branch address or pc+4
  PCSrcM <= BranchM and ZeroM;
  pcbrmux: mux2 generic map(32) port map(PCPlus4F, PCBranchM, PCSrcM, PCBranchF);
  
  -- chose signimmsh+pc+4 or jump address as next pc value
  pcmux: mux2 generic map(32) port map(PCBranchF, PCJumpD, jump, pc);
  
  -- invert clk
  not_clk <= not clk;
  
  -- register file logic
  rf: regfile port map(clk => not_clk, we3 => RegWriteW, a1 => instrD(25 downto 21), a2 => instrD(20 downto 16), a3 => WriteRegW, wd3 => ResultW, rd1 => RD1, rd2 => RD2);
  
  -- mux for deciding into which register (out of the two specified in the instruction) to write
  wrmux: mux2 generic map(5) port map(d0 => RtE, d1 => RdE, s => RegDstE, y => WriteRegE);
  
  -- chose to store value from alu or memory to register
  resmux: mux2 generic map(32) port map(AluoutW, ReaddataW, MemToRegW, ResultW);
  
  -- sign extender
  se: signext port map(instrD(15 downto 0), SignExtendD);
  
  -- chose rd2 or sign extended value (add immediate to a register or add two values in registers)
  srcbmux: mux2 generic map(32) port map(WriteDataE, SignImmE, ALUSrcE, SrcBE);
  
  -- alu
  mainalu: alu port map(SrcAE, SrcBE, ALUControlE, ALUOutE, ZeroE);

  --instruction memory
  instMem: instr_mem port map(pcf, instrF);

  --data memory
  dataMem: data_memory port map(clk, ALUOutM, WriteDataM, MemWriteM, ReadDataM);
  

  
  --Register:
  --Decode
  decode: pipeline_register_D port map(clk => clk, instr => instrF, PCPlus4 => PCPlus4F, instrD => instrD, PCPlus4D => PCPlus4D);
  
  --Execute
  execute: pipeline_register_E port map(
						clk => clk,
						RD1 => RD1,
						RD2 => RD2,
						RsD => instrD(25 downto 21),
						RtD => RtD,
						RdD => RdD,
						SignExtendD => SignExtendD,
						PCPlus4D => PCPlus4D,
						RegWriteD => RegWriteD,
						MemToRegD => MemToRegD,
						MemWriteD => MemWriteD,
						BranchD => BranchD,
						ALUControlD => ALUControlD,
						ALUSrcD => ALUSrcD,
						RegDstD => RegDstD,
						SrcAE => RD1E,
						WriteDataE => RD2E,
						RsE => RsE,
						RtE => RtE,
						RdE => RdE,
						SignImmE => SignImmE,
						PCPlus4E => PCPlus4E,
						RegWriteE => RegWriteE,
						MemWriteE => MemWriteE,
						MemToRegE => MemToRegE,
						BranchE => BranchE,
						ALUControlE => ALUControlE,
						ALUSrcE => ALUSrcE,
						RegDstE => RegDstE );
						
  --Memory
  memory: pipeline_register_M port map(
						clk => clk,
						ZeroE => ZeroE,
						ALUOutE => ALUOutE,
						WriteDataE => WriteDataE,
						WriteRegE => WriteRegE,
						PCBranchE => PCBranchE,
						RegWriteE => RegWriteE,
						MemToRegE => MemToRegE,
						MemWriteE => MemWriteE,
						BranchE => BranchE,
						ZeroM => ZeroM,
						ALUOutM => ALUOutM,
						WriteDataM => WriteDataM,
						WriteRegM => WriteRegM,
						PCBranchM => PCBranchM,
						RegWriteM => RegWriteM,
						MemToRegM => MemToRegM,
						MemWriteM => MemWriteM,
						BranchM => BranchM );
						
  --Writeback
  writeback: pipeline_register_W port map(
										clk => clk, 
										AluoutM => AluoutM, 
										ReadDataM => ReadDataM, 
										RegWriteM => RegWriteM, 
										MemToRegM => MemToRegM,
										WriteRegM => WriteRegM, 
										AluoutW => AluoutW, 
										ReaddataW => ReaddataW, 
										RegWriteW => RegWriteW,
										MemToRegW => MemToRegW, 
										WriteRegW => WriteRegW);
										
						
	RegWriteM_out <= RegWriteM;
	RegWriteW_out <= RegWriteW;
	WriteRegM_out <= WriteRegM;
	WriteRegW_out <= WriteRegW;
	RtE_out <= RtE;
	RsE_out <= RsE;

  --Regarding Hazard-Unit
  muxAE: mux4 generic map(w => 32) port map(d0 => RD1E, d1 => ResultW, d2 => ALUOutM, d3 => x"00000000", s => ForwardAE, y => SrcAE);
  
  muxBE: mux4 generic map(w => 32) port map(d0 => RD2E, d1 => ResultW, d2 => ALUOutM, d3 => x"00000000", s => ForwardBE, y => WriteDataE);
  
  
end;




















