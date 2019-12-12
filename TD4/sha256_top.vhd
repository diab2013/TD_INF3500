-------------------------------------------------------------------------------
-- sha256_top.vhd: TOP SHA256
-- Jeferson S. Silva
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity sha256_top is
    port (
        clk             : in    std_logic;
        rst             : in    std_logic;

        sha256_din_en   : in    std_logic;
        sha256_din      : in    std_logic_vector(15 downto 0);

        sha256_dout     : out   std_logic_vector(15 downto 0);
        sha256_dout_val : out   std_logic
    );
end sha256_top;

architecture sha256_top of sha256_top is

    function sha256_padder (din : std_logic_vector(15 downto 0)) return std_logic_vector is
        variable din_padded : std_logic_vector(511 downto 0);
    begin
    -- Padding the inputs
        din_padded(512 - 1 downto 512 - 16) :=  din;
        din_padded(512 - 16 - 1)            :=  '1';
        din_padded(512 - 16 - 2 downto 64)  :=  (others => '0');
        din_padded(63 downto 0)             :=  std_logic_vector(to_unsigned(16, 64));

        return din_padded;
    end function;

    signal sha256_dout_int  : std_logic_vector(255 downto 0);

begin

    sha_inst: entity work.sha256
        port map (
            clk             => clk,    
            rst             => rst,    
    
            sha256_din_en   => sha256_din_en,    
            sha256_din      => sha256_padder(sha256_din),    
    
            sha256_dout     => sha256_dout_int,    
            sha256_dout_val => sha256_dout_val    
        );
    
    sha256_dout <= sha256_dout_int(15 downto 0); 

end sha256_top;

