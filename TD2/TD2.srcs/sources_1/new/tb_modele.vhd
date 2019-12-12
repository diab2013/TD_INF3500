library IEEE;
use STD.textio.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_modele is
  	generic(
        N : integer := 24
  	);
end tb_modele;

architecture tb of tb_modele is
	
	file file_vectors : text;
	file file_results : text;
	signal input, output, output_function, x : std_logic_vector(N - 1 downto 0);
	
begin
	UUT: entity work.sigma_lower
        port map (
            input, output
        );
	process
		variable lineRead : line;
		variable line : line;
		variable randomTerm : std_logic_vector(N - 1 downto 0);
		variable expectedTerm : std_logic_vector(N - 1 downto 0);
		variable space : character;
		
		begin
			file_open(file_vectors, "vectors.txt", read_mode);
			file_open(file_results, "results.txt", write_mode);
			
			while not endfile(file_vectors) loop
				readline(file_vectors, lineRead);
				read(lineRead, randomTerm);
				read(lineRead, space);			-- Sauter l'espace
				read(lineRead, expectedTerm);
				
				input <= randomTerm;
				wait for 10 ns;
				
				if output == expectedTerm then
					write(line, string'("OK: "));
					write(line, integer'image(randomTerm));
					write(line, integer'image(output));
					writeline(file_results, line);	
				else
					write(line, string'("Erreur: "));
					write(line, integer'image(randomTerm));
					write(line, integer'image(output));
					write(line, integer'image(expectedTerm));
					writeline(file_results, line);
			end loop;
			
			file_close(file_vectors);
			file_close(file_results);
			assert (false)
				report "Simulation terminée." severity failure;
		end process;
end tb;