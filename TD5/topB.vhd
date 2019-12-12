library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.common_pkg.all;

entity topB is
    Generic(
        clk_per_bit : integer := 868
    );
    Port (
        clk, reset : in std_logic;  
        clk_uart : out std_logic;
        -- TX pi
        tx_sdata : out std_logic;       
      
        -- RX pi
        rx_sdata : in std_logic;
        rx_frame_err : out std_logic;
        rx_parity_err : out std_logic;
      
        display_cathods : out vector8(7 downto 0);
        display_enable : out std_logic_vector(7 downto 0)  
    );
end topB;

architecture topB of topB is

    type etats is (IDLE, START, READ, PARITY, STOP, BREAK);
    signal etat : etats := IDLE;
    signal char : std_logic_vector(7 downto 0);
    signal bit_parity, error : std_logic := '0';
    signal clk_count : integer range 0 to clk_per_bit - 1 := 0;
    signal index : integer range 0 to 7 := 0;

begin

    process(clk, reset)
    variable counter_read, counter_sync : natural := 0;
    
    begin
        display_cathods(0) <= "0001000";
        if(reset = '1') then
            char <= (others => '0');
            bit_parity <= '0';
            error <= '0';
            etat <= IDLE;
        else
            if(rising_edge(clk)) then
                case etat is
                    when IDLE =>
                        clk_count <= 0;
                        index <= 0;
                        char <= (others => '0');
                        bit_parity <= '0';
                        error <= '0';
                        display_enable <= (others => '0');
                        if(rx_sdata = '0') then
                            etat <= START;
                        end if;
                    when START =>
                        if(clk_count = (clk_per_bit-1)/2) then
                            if(rx_sdata = '0') then
                                clk_count <= 0;
                                etat <= READ;
                            else 
                                --DIRE QUE C'EST UNE ERREUR
                            end if;
                        else 
                            clk_count <= clk_count + 1;
                        end if;
                    when READ =>
                        if( clk_count <= clk_per_bit-1) then
                            clk_count <= clk_count + 1;
                        else 
                            clk_count <= 0;
                            char(index) <= rx_sdata;
                            bit_parity <= bit_parity xor rx_sdata;
                            display_enable <= char;
                            
                            if(index < 7) then
                                index <= index + 1;
                            else
                                index <= 0;
                                etat <= PARITY;
                            end if;
                        end if;
                    when PARITY =>
                        if( clk_count < clk_per_bit-1) then
                            clk_count <= clk_count + 1;
                        else 
                            if(bit_parity /= rx_sdata) then
                                error <= '1';
                            end if;
                            clk_count <= 0;
                            etat <= STOP;
                        end if;
                    when STOP =>
                        if( clk_count < clk_per_bit-1) then
                            clk_count <= clk_count + 1;
                        else 
                            if(rx_sdata = '0') then
                                error <= '1';
                            else 
                                error <= '0';
                                display_enable <= char;
                                
                            end if;
                            clk_count <= 0;
                            etat <= BREAK;
                        end if;
                    when BREAK =>
                        if( clk_count < clk_per_bit-1) then
                            clk_count <= clk_count + 1;
                        else 
                            clk_count <= 0;
                            etat <= IDLE;
                        end if;
                    when others =>
                        etat <= IDLE;
                end case;           
            end if;        
        end if;
        
    end process;

end topB;
