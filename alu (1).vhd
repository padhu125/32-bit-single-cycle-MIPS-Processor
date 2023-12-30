library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is

  port(
    SrcA   : in std_logic_vector(31 downto 0);
    SrcB   : in std_logic_vector(31 downto 0);
    ALUControl : in std_logic_vector(2 downto 0);  -- 3-bit ALU control
    ALUResult      : out std_logic_vector(31 downto 0);
    Zero        : out std_logic
  );
end ALU;

architecture Behavioral of ALU is
  signal temp : std_logic_vector(31 downto 0);

begin
  process (ALUControl, SrcA, SrcB)
  begin
    case ALUControl is
      when "010" =>                                                -- Addition
        temp <= std_logic_vector(unsigned(SrcA) + unsigned(SrcB)); 
      when "110" =>                                                -- Subtraction
        temp <= std_logic_vector(unsigned(SrcA) - unsigned(SrcB)); 
      when "000" =>                                                -- AND Operation
        temp <= SrcA AND SrcB;                                     
      when "001" =>                                                -- OR Operation
        temp <= SrcA OR SrcB;                                      
      when "111" =>                                                -- slt (set less than)
        if SrcA < SrcB then
          temp <= "00000000000000000000000000000001";
        else
          temp <= "00000000000000000000000000000000";
        end if;
      when others =>
        temp <= (others => '0'); -- Handle unsupported ALU control codes here temp signal to a vector where all bits are set to '0'
    end case;
  end process;

  Zero <= '1' when (temp <= "00000000000000000000000000000000") else '0';
  ALUResult <= temp;

end Behavioral;