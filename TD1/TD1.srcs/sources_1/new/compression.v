library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Compression is
    port(
        X, Y, Z : in std_logic_vector(31 downto 0);
        result : out std_logic_vector(255 downto 0)
    );  
end Compression;

architecture compression1 of Compression is
    signal S1, S2 : std_logic_vector(31 downto 0);
    begin 
        S1 <= (X and Y);
        S2 <= (not(X) and Z);
        result <= (S1 xor S2);
end compression1;


