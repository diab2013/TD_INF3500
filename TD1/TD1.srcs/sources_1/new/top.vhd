----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/06/2019 04:04:11 PM
-- Design Name: 
-- Module Name: top - top
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
  Port ( 
    input : in std_logic_vector(15 downto 0);
    output : out std_logic_vector(15 downto 0)
   );
end top;

architecture top of top is
    signal zero : std_logic_vector(15 downto 0);
    signal u1, u2, u3: std_logic_vector(31 downto 0);
    signal ext_input, ext_output : std_logic_vector(31 downto 0);
    
    begin
        zero <= "0000000000000000";
        ext_input <= zero&input;
        u1 <= std_logic_vector(ROTATE_RIGHT(unsigned(ext_input), 7));
        u2 <= std_logic_vector(ROTATE_RIGHT(unsigned(ext_input), 18));
        u3 <= std_logic_vector(SHIFT_RIGHT(unsigned(ext_input), 3));
        ext_output <= (u1 xor u2 xor u3);
        output <= ext_output(15 downto 0);

end top;
