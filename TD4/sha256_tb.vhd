-------------------------------------------------------------------------------
-- sha256_tb.vhd: TB SHA256
-- Jeferson S. Silva
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
    use ieee.math_real.all;

entity sha256_tb is
end sha256_tb;

architecture sha256_tb of sha256_tb is
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal din      : std_logic_vector(15 downto 0);
    signal dout     : std_logic_vector(15 downto 0);
    signal dv       : std_logic;
    signal din_en   : std_logic;

begin

    uut: entity work.sha256_top
        port map (
            clk             => clk,
            rst             => rst,
    
            sha256_din_en   => din_en,
            sha256_din      => din,
            sha256_dout     => dout,
            sha256_dout_val => dv
        );

    clk <= not clk after 5 ns;
    rst <= '1', '0' after 20 ns;

    process
    begin
        wait until rst = '0';
        
        din <= x"6162";
        din_en <= '1';
        wait until rising_edge(clk);
        din_en <= '0';

        wait until dv = '1';
        wait for 100 ns;
        assert dout = x"0603"
        report "Hash ab error" severity failure;

        din <= x"6364";
        din_en <= '1';
        wait until rising_edge(clk);
        din_en <= '0';
        
        wait until dv = '1';
        wait for 100 ns;
        assert dout = x"bed4"
        report "Hash cd error" severity failure;

        din <= x"4142";
        din_en <= '1';
        wait until rising_edge(clk);
        din_en <= '0';
        
        wait until dv = '1';
        wait for 100 ns;
        assert dout = x"4153"
        report "Hash AB error" severity failure;

        din <= x"4344";
        din_en <= '1';
        wait until rising_edge(clk);
        din_en <= '0';
        
        wait until dv = '1';
        wait for 100 ns;
        assert dout = x"e236"
        report "Hash CD error" severity failure;

        wait for 50 ns;

        assert false report "Simulation ended" severity failure;
    end process;

end sha256_tb;

