library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
library work;
    use work.all;

entity topA is
    Generic(
        CLK_DIV : integer := 100000000
    );
    Port ( 
        clk, reset : in std_logic;
        LED : out std_logic
    );
end topA;

architecture topA of topA is
    signal clk_en : std_logic := '1';
begin
    UUT: entity work.clock_divider
        generic map(
            CLK_DIV => CLK_DIV
        )
        port map(
            clk_in => clk,
            clken => clk_en,
            rst => reset,
            clk_out => LED
        );

end topA;
