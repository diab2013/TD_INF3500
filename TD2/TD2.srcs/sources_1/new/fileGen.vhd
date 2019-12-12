library IEEE;
use STD.textio.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fileGen is
  	generic(
        N : integer := 24
  	);
end fileGen;

architecture gen of fileGen is

	function do_sigma_lower_0(x : std_logic_vector(N - 1 downto 0)) return std_logic_vector is
        variable x_u : unsigned(N - 1 downto 0) := unsigned(x);
    begin
        return std_logic_vector(rotate_right(x_u, 7) xor rotate_right(x_u, 18) xor shift_right(x_u, 3));
    end function;
	
	file fiel_vectors : text;
begin
	process
		variable seed1, seed2 : positive;
		variable output	: real;
		variable temp : integer range 0 to N-1;
		variable line : line;
		file_open(file_results, "vectors.txt", write_mode);
		
		begin
			for i in 0 to 255 loop
				uniform(seed1, seed2, output);
				temp := integer(output * real((2**N) - 1));
				
				write(line, integer'image(temp));
				write(line, string'(" "));
				write(line, integer'image(to_integer(do_sigma_lower_0(to_unsigned(temp, N)))));
				writeline(file_vectors, line);
				
				wait for 5 ns;
			end loop;				 
			
			file_close(file_vectors);
			assert (false)
				report "Simulation terminée." severity failure;
	end process;
end gen;