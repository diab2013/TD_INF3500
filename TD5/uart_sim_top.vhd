

-------------------------------------------------------------------------------
-- Libraries 
-------------------------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.math_real.all;
	use ieee.numeric_std.all;
library work;
	use work.common_pkg.all;

-------------------------------------------------------------------------------
-- Entity 
-------------------------------------------------------------------------------
entity sim_top is                                                         			

end sim_top;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture sim_top of sim_top is

	--------------
	-- Function --
	--------------

	-----------
	-- Types --
	-----------

	---------------
	-- Constants --
	---------------
	
	-------------------------
	-- Signal declarations --
	-------------------------

	signal rx_sdata		: std_logic;
	signal clk		: std_logic :='0';
	signal output : std_logic_vector (7 downto 0);
	constant data				: std_logic_vector(7 downto 0) := x"A5";


begin

	---------------
	-- Port maps --
	--------------- 
	fo: entity work.topB 
	port map(                                                      			
        -- Control                                                          
        clk               => clk,
        reset             => '0',
        -- TX pins
        tx_sdata        => open,
        
        -- RX pins
        rx_sdata       => rx_sdata,
        rx_frame_err   => open,
        rx_parity_err  => open,
        
        --display_cathods => open,
        display_enable  => output
    );
	-------------------------------
	-- Asynchronous Assignments --
	-------------------------------

	---------------
	-- Processes --
	---------------
    clk <= not clk after 5ns;
    
    process
    begin
        rx_sdata    <= '1';
        wait for 30 us;
        rx_sdata    <= '0';
        wait for 8.68 us;

 
        rx_sdata    <= '1';
        wait for 8.68 us;
        rx_sdata    <= '1';
        wait for 8.68 us; 
        rx_sdata    <= data(2);
        wait for 8.68 us;
        rx_sdata    <= data(3);
        wait for 8.68 us;
        rx_sdata    <= data(4);
        wait for 8.68 us;
        rx_sdata    <= data(5);
        wait for 8.68 us;
        rx_sdata    <= data(6);
        wait for 8.68 us;
        rx_sdata    <= data(7);
        wait for 8.68 us;
        rx_sdata    <= '0';
        wait for 8.68 us;
        rx_sdata    <= '1';
        
        
        wait for 30 us;
        rx_sdata    <= '0';
        wait for 8.68 us;

 
        rx_sdata    <= data(0);
        wait for 8.68 us;
        rx_sdata    <= data(1);
        wait for 8.68 us; 
        rx_sdata    <= data(2);
        wait for 8.68 us;
        rx_sdata    <= data(3);
        wait for 8.68 us;
        rx_sdata    <= data(4);
        wait for 8.68 us;
        rx_sdata    <= data(5);
        wait for 8.68 us;
        rx_sdata    <= data(6);
        wait for 8.68 us;
        rx_sdata    <= data(7);
        wait for 8.68 us;
        rx_sdata    <= '0';
        wait for 8.68 us;
        rx_sdata    <= '1';
        
        wait for 1ms;
        --assert (data = rx_sdata)
        assert output = data
            report "KEK" severity failure;

    end process;
        

end sim_top;
