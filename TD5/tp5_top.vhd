library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common_pkg.all;

entity tp5_top is
    Port ( 
        uart_input : in std_logic;
        reset : in std_logic;
        clk : in std_logic;
        LED : out std_logic_vector(1 downto 0);
        cathods : out std_logic_vector(6 downto 0);
        enable : out std_logic_vector(7 downto 0);
        res : out vector8(7 downto 0)
    );
end tp5_top;

architecture tp5_top of tp5_top is
    signal clk_divided : std_logic;
    signal input : std_logic_vector(7 downto 0);
    signal message : vector8(7 downto 0) := (others => "0000000");

begin
    divider: entity work.clock_divider
        generic map(
            CLK_DIV => 868
        )
        port map(
            clk_in => clk,
            clken => '1',
            rst => reset,
            clk_out => clk_divided
        );
        
    uart: entity work.topB
        port map(
            clk => clk,
            reset => reset,
            clk_uart => clk_divided,
            rx_sdata => uart_input,
            rx_frame_err => LED(0),
            rx_parity_err => LED(1),
            display_cathods => message,
            display_enable => input      
        );
        
    display: entity work.display
        port map(
            clk => clk,
            message => res,
            cathods => cathods,
            enable => enable 
        );

end tp5_top;
