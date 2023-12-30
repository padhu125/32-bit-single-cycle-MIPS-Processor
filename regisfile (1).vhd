library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
entity regisfile is
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
end regisfile;

architecture arch1 of regisfile is
type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
signal mem: ramtype;
begin
process(clk)
begin
if clk'EVENT AND clk='1' then
if RegWrite = '1' then
mem(to_integer(unsigned(wa3))) <= wd3;
end if;
end if;
end process;

process(clk)
begin
if (to_integer(unsigned(ra1)) = 0) then 
	rd1 <= X"00000000";
else 
	rd1 <= mem(to_integer(unsigned(ra1)));
end if;
if (to_integer(unsigned(ra2)) = 0) then 
	rd2 <= X"00000000";
else 
	rd2 <= mem(to_integer(unsigned(ra2)));
end if;
end process;
end arch1;