library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
entity Adder is
port(
d_in1: in std_logic_vector(31 downto 0); 
d_in2: in std_logic_vector(31 downto 0); 
d_out: out std_logic_vector(31 downto 0)); 
end Adder;
architecture add of Adder is
signal d_R: std_logic_vector(31 downto 0); -- output register
begin
  d_R <= std_logic_vector(unsigned(d_in1) + unsigned(d_in2));
  d_out <= d_R;
end add;