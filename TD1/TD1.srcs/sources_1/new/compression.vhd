----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/06/2019 02:10:35 PM
-- Design Name: 
-- Module Name: compression - Behavioral
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

entity compression is
    Port ( X, Y, Z : in STD_LOGIC_VECTOR (31 downto 0);
           ch, maj, sig3_0, sig4_1, sig5_0, sig6_1  : out STD_LOGIC_VECTOR(31 downto 0)
           );
end compression;

architecture compression1 of compression is
    signal ch1, ch2 : std_logic_vector(31 downto 0);
    signal maj1, maj2, maj3 : std_logic_vector(31 downto 0);
    signal s1, s2, s3: std_logic_vector(31 downto 0);
    signal t1, t2, t3: std_logic_vector(31 downto 0);
    signal u1, u2, u3: std_logic_vector(31 downto 0);
    signal v1, v2, v3: std_logic_vector(31 downto 0);
    
    begin 
        ch1 <= (X and Y);
        ch2 <= (not(X) and Z);
        ch <= (ch1 xor ch2);
        
        maj1 <= (X and Y);
        maj2 <= (X and Z);
        maj3 <= (Y and Z);
        maj <= (maj1 xor maj2 xor maj3);
        
        s1 <= std_logic_vector(ROTATE_RIGHT(unsigned(X), 2));
        s2 <= std_logic_vector(ROTATE_RIGHT(unsigned(X), 13));
        s3 <= std_logic_vector(ROTATE_RIGHT(unsigned(X), 22));
        sig3_0 <= (s1 xor s2 xor s3);
        
        t1 <= std_logic_vector(ROTATE_RIGHT(unsigned(X), 6));
        t2 <= std_logic_vector(ROTATE_RIGHT(unsigned(X), 11));
        t3 <= std_logic_vector(ROTATE_RIGHT(unsigned(X), 25));
        sig4_1 <= (t1 xor t2 xor t3);
        
        u1 <= std_logic_vector(ROTATE_RIGHT(unsigned(X), 7));
        u2 <= std_logic_vector(ROTATE_RIGHT(unsigned(X), 18));
        u3 <= std_logic_vector(SHIFT_RIGHT(unsigned(X), 3));
        sig5_0 <= (u1 xor u2 xor u3);
        
        v1 <= std_logic_vector(ROTATE_RIGHT(unsigned(X), 17));
        v2 <= std_logic_vector(ROTATE_RIGHT(unsigned(X), 19));
        v3 <= std_logic_vector(SHIFT_RIGHT(unsigned(X), 10));
        sig6_1 <= (v1 xor v2 xor v3);
end compression1;