library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity datapath is -- single cycle control decoder
port (
clk, reset: in STD_LOGIC;
op, funct: out STD_LOGIC_VECTOR (5 downto 0);
zero: out STD_LOGIC;
memtoreg, memwrite: in STD_LOGIC;
pcsrc, alusrc: in STD_LOGIC;
regdst, regwrite: in STD_LOGIC;
jump: in STD_LOGIC;
alucontrol: in STD_LOGIC_VECTOR (2 downto 0);
pcout: out STD_LOGIC_VECTOR (31 downto 0);
instruction: in STD_LOGIC_VECTOR (31 downto 0); 
aluout : out STD_LOGIC_VECTOR (31 downto 0);
readdata : in STD_LOGIC_VECTOR (31 downto 0);
writedata : out STD_LOGIC_VECTOR (31 downto 0));
end;

architecture data of datapath is

component regis is
port (clk: in std_logic;
rst: in std_logic;
d_in: in std_logic_vector(31 downto 0); 
d_out: out std_logic_vector(31 downto 0)); 
end component;

component Adder is
port(
d_in1: in std_logic_vector(31 downto 0); 
d_in2: in std_logic_vector(31 downto 0); 
d_out: out std_logic_vector(31 downto 0)); 
end component;

component  multiplexer is
port ( 
A : in  STD_LOGIC_VECTOR (31 downto 0);
B : in  STD_LOGIC_VECTOR (31 downto 0);
C : out  STD_LOGIC_VECTOR (31 downto 0);
Sel : in  STD_LOGIC);
end component;

component sign_extension is
port(
d_in: in std_logic_vector(15 downto 0); -- input1
d_out: out std_logic_vector(31 downto 0)); -- output, 1 bit wider
end component;

component ShiftRegister is
port (
Clock : in STD_LOGIC;
Reset : in STD_LOGIC;
DataIn : in STD_LOGIC_VECTOR(25 downto 0);
Shift : in STD_LOGIC_VECTOR(1 downto 0);
DataOut : out STD_LOGIC_VECTOR(25 downto 0)
);
end component;

component regisfile is
port(
clk: in std_logic;
RegWrite: in std_logic;
ra1: in std_logic_vector(4 downto 0); -- input1
ra2: in std_logic_vector(4 downto 0); -- input2
wa3: in std_logic_vector(4 downto 0); -- input3
wd3: in std_logic_vector(31 downto 0); 
rd1: out std_logic_vector(31 downto 0);
rd2: out std_logic_vector(31 downto 0)
);
end component;

component ALU is
  GENERIC(n : integer := 32);
  port(
    SrcA   : in std_logic_vector(n - 1 downto 0);
    SrcB   : in std_logic_vector(n - 1 downto 0);
    ALUControl : in std_logic_vector(2 downto 0);  -- 3-bit ALU control
    ALUResult      : out std_logic_vector(n - 1 downto 0);
    Zero        : out std_logic
  );
end component;


signal d_in:STD_LOGIC_VECTOR (15 downto 0);-- for sign extension
signal d_out:STD_LOGIC_VECTOR (31 downto 0);
signal datain: STD_LOGIC_VECTOR (31 downto 0);--for shift register
signal dataout: STD_LOGIC_VECTOR (31 downto 0);
signal four : STD_LOGIC_VECTOR(31 downto 0);
signal pcplus4: STD_LOGIC_VECTOR (31 downto 0);
signal pcbranch: STD_LOGIC_VECTOR (31 downto 0);
signal pcminus:STD_LOGIC_VECTOR (31 downto 0);
signal rd1:STD_LOGIC_VECTOR (31 downto 0);
signal rd2: STD_LOGIC_VECTOR (31 downto 0);
signal srcB: STD_LOGIC_VECTOR (31 downto 0);
signal wa3: STD_LOGIC_VECTOR (4 downto 0);
signal wd3: STD_LOGIC_VECTOR (31 downto 0);
signal pcjump: STD_LOGIC_VECTOR (31 downto 0);
signal pcplus: STD_LOGIC_VECTOR (31 downto 0);
signal shift : std_logic_vector(1 downto 0) := "00";
signal pcoutreg: STD_LOGIC_VECTOR (31 downto 0);
signal aluoutreg: STD_LOGIC_VECTOR (31 downto 0);
begin
process
begin
    pcjump <= pcplus4(31 downto 28) & instruction(25 downto 0) & "00"; 
	 four<="00000000000000000000000000000100";
end process;



	rg: regis port map (clk, reset, pcminus , pcoutreg);
	sr: ShiftRegister port map (clk, reset, datain, shift, dataout);
	se: sign_extension port map(d_in, d_out);
	pcadd: Adder port map(pcoutreg, four, pcplus4);
	pcbranchadd: Adder port map(pcplus4, dataout,pcbranch);
	pcmx1: multiplexer port map(pcplus4,pcbranch,pcplus,pcsrc);
	pcmx2: multiplexer port map(pcplus,pcjump,pcminus,jump);
	srcBmx:multiplexer port map(rd2, d_out, srcB,alusrc);
	writeregmux: multiplexer port map(instruction(20 downto 16), instruction(15 downto 11), wa3, regdst);
	resultmux: multiplexer port map(aluoutreg, readdata, wd3, memtoreg);
	aluone: ALU port map(rd1, srcB, alucontrol,aluoutreg, zero);
	rf:regisfile port map(clk,regwrite,instruction(25 downto 21), instruction(20 downto 16), wa3,wd3,rd1,rd2);
	
pcout <= pcoutreg;
aluout<=aluoutreg;
writedata<=	rd2;
end;
