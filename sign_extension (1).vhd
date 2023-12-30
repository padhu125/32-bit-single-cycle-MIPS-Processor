library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity sign_extension is
port(
d_in: in std_logic_vector(15 downto 0); -- input1
d_out: out std_logic_vector(31 downto 0)); -- output, 1 bit wider
end sign_extension;

architecture sign of sign_extension is
signal d_R: std_logic_vector(31 downto 0); -- output register
begin
  process(d_in)
  begin
    if d_in(15) = '0' then
      d_R <= "0000000000000000" & d_in;
    else
      d_R <= "1111111111111111" & d_in;
    end if;
  end process;
  d_out <= d_R;
end sign;
