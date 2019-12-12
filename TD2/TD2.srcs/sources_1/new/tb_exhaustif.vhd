library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use std.textio.all;

entity tb_exhaustif is
	generic (
		N : integer := 24
	);
end tb_exhaustif;

architecture tb_exhaustif of tb_exhaustif is

    function do_sigma_lower_0(x : std_logic_vector(N - 1 downto 0)) return std_logic_vector is
        variable x_u : unsigned(N - 1 downto 0) := unsigned(x);
    begin
        return std_logic_vector(rotate_right(x_u, 7) xor rotate_right(x_u, 18) xor shift_right(x_u, 3));
    end function;

signal input, output, output_function, x : std_logic_vector(N - 1 downto 0);

begin
    UUT: entity work.sigma_lower
        port map (
            input, output
        );
    process
	begin
		-- Completer
		for k in 0 to 2 ** N - 1 loop
		  x <= std_logic_vector(to_unsigned(k, N));
		  input <= x;
		  output_function <= do_sigma_lower_0(x);
		  wait for 10 ns;
		  assert output = output_function
		      report "Erreur, résultat différent pour " severity error;
		end loop;
		assert (false)	
			report "La simulation est terminee." severity failure;
	end process;
	
end tb_exhaustif;