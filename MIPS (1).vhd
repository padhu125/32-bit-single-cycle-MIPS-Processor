library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 

entity MIPS_top is 
port (
  MIPS_clk, MIPS_reset:                          in  std_logic                     ;
  MIPS_instro, MIPS_read_data:                   in  std_logic_vector (31 downto 0);
  MIPS_PCout:                                    out std_logic_vector (31 downto 0);
  MIPS_mem_write:                                out std_logic                      ;
  MIPS_aluout:                                   out std_logic_vector (31 downto 0);
  MIPS_write_data:                               out std_logic_vector (31 downto 0)
); 
end MIPS_top;

 

architecture MIPS_arch of MIPS_top is

 

  component datapath is 
    port (
      clk, reset:                        in std_logic;
      op, funct:    out std_logic_vector (5 downto 0);
      zero:                             out std_logic;
      memtoreg, memwrite:                in std_logic;
      pcsrc, alusrc:                     in std_logic;
      regdst, regwrite:                  in std_logic;
      jump:                              in std_logic;
      alucontrol:    in std_logic_vector (2 downto 0);
      pcout:        out std_logic_vector (31 downto 0);
      instruction:  in std_logic_vector (31 downto 0); 
      aluout:      out std_logic_vector (31 downto 0);
      readdata:     in std_logic_vector (31 downto 0);
      writedata:   out std_logic_vector (31 downto 0)
    );
  end component;

 

  -- Almost all signals in controller are inputs to datapath

 

  component controller is 
    port (
      op, funct:     in std_logic_vector (5 downto 0);
      zero:                              in std_logic;
      memtoreg, memwrite:               out std_logic;
      pcsrc, alusrc:                    out std_logic;
      regdst, regwrite:                 out std_logic;
      jump:                             out std_logic;
      alucontrol:   out std_logic_vector (2 downto 0)
    );
  end component;

  signal op             : std_logic_vector(5 downto 0);
  signal funct          : std_logic_vector(5 downto 0);
  signal zero           : std_logic                   ;
  signal memtoreg       : std_logic                   ;
  signal memwrite       : std_logic                   ;
  signal pcsrc          : std_logic                   ;
  signal alusrc         : std_logic                   ;
  signal regdst         : std_logic                   ;
  signal regwrite       : std_logic                   ;
  signal jump           : std_logic                    ;
  signal alucontrol     : std_logic_vector (2 downto 0);

  signal memwrite_reg   : std_logic                     ; 
  signal PCout_reg      : std_logic_vector (31 downto 0) ;
  signal instro_reg     : std_logic_vector (31 downto 0);
  signal aluout_reg     : std_logic_vector (31 downto 0);
  signal read_data_reg  : std_logic_vector (31 downto 0);
  signal write_data_reg : std_logic_vector (31 downto 0); 




 

begin 
  comp1: datapath port map (
    clk               => MIPS_clk,
    reset             => MIPS_reset,
    op                => op,
    funct             => funct,
    zero              => zero,
    memtoreg          => memtoreg,
    memwrite          => memwrite_reg,
    pcsrc             => pcsrc,
    alusrc            => alusrc,
    regdst            => regdst,
    regwrite          => regwrite,
    jump              => jump,
    alucontrol        => alucontrol,
    pcout             => PCout_reg,
    instruction       => MIPS_instro,
    aluout            => aluout_reg,
    readdata          => MIPS_read_data,
    writedata         => write_data_reg
  );

 

  comp2: controller port map (
    op                => op,
    funct             => funct,
    zero              => zero,
    memtoreg          => memtoreg,
    memwrite          => memwrite_reg,
    pcsrc             => pcsrc,
    alusrc            => alusrc,
    regdst            => regdst,
    regwrite          => regwrite,
    jump              => jump,
    alucontrol        => alucontrol
  );

MIPS_mem_write  <= memwrite_reg;
MIPS_PCout      <= PCout_reg;
--MIPS_instro     <= instro_reg;
MIPS_aluout     <= aluout_reg;
--MIPS_read_data  <= read_data_reg;
MIPS_write_data <= write_data_reg;

end MIPS_arch;