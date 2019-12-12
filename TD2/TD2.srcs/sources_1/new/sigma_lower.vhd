library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sigma_lower is
  generic(
        N : integer := 24
  );  
  Port ( 
    input : in std_logic_vector(N - 1 downto 0);
    output : out std_logic_vector(N - 1 downto 0)
  );
end sigma_lower;

architecture top of sigma_lower is
    signal u1, u2, u3: std_logic_vector(N - 1 downto 0);
    
    begin
        u1 <= std_logic_vector(ROTATE_RIGHT(unsigned(input), 7));
        u2 <= std_logic_vector(ROTATE_RIGHT(unsigned(input), 18));
        u3 <= std_logic_vector(SHIFT_RIGHT(unsigned(input), 3));
        output <= (u1 xor u2 xor u3);

end top;
