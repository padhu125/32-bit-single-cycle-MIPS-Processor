library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ShiftRegister is
    Port (
        Clock : in STD_LOGIC;
        Reset : in STD_LOGIC;
        DataIn : in STD_LOGIC_VECTOR(25 downto 0);
        Shift : in STD_LOGIC_VECTOR(1 downto 0);
        DataOut : out STD_LOGIC_VECTOR(25 downto 0)
    );
end ShiftRegister;

architecture Behavioral of ShiftRegister is
    signal Reg : STD_LOGIC_VECTOR(25 downto 0) := (others => '0');
begin
    process (Clock, Reset)
    begin
        if Reset = '1' then
            Reg <= (others => '0');
        elsif rising_edge(Clock) then
            Reg<= Reg(23 downto 0) & "00";
        end if;
    end process;
    DataOut <= Reg;
end Behavioral;
