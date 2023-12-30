library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity multiplexer is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           C : out  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC);
end multiplexer;

architecture MUX1 of multiplexer is
begin
    process(A, B, Sel)
    begin
        if Sel = '0' then 
            C <= A;
        else
            C <= B;
        end if;
    end process;
end MUX1;

