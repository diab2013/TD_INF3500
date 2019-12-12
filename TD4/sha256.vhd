library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.functions_sha256_pkg.all;

entity sha256 is
    Port ( 
        --entrées
        sha256_din : in std_logic_vector(511 downto 0);
        sha256_din_en : in std_logic;
        clk, rst : in std_logic;
        --sorties
        sha256_dout : out std_logic_vector(255 downto 0);
        sha256_dout_val : out std_logic
        );
end sha256;

architecture sha256 of sha256 is
    type state is (INIT, INIT_VAR, BOUCLE_FOR, CALCUL_T1, CALCUL_T2, CALCUL_VAR, CALCUL_HASH, ENDING, STOP);
    signal etat : state := INIT;
    constant K : vector32u_t(0 to 63) := ( 
        x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5", x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5",
	    x"d807aa98", x"12835b01", x"243185be", x"550c7dc3", x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
	    x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc", x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da",
	    x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7", x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967",
	    x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13", x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
	    x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3", x"d192e819", x"d6990624", x"f40e3585", x"106aa070",
	    x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5", x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3",
	    x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208", x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2");
	signal W : vector32_t(0 to 63);
    signal H0, H1, H2, H3, H4, H5, H6, H7 : std_logic_vector(31 downto 0);
    signal a, b, c, d, e, f, g, h , T1, T2: std_logic_vector(31 downto 0);
    signal debut_sys : std_logic := '1';
    
begin
    process(clk, rst)
    variable counter : natural range 0 to 63 := 0;
        begin
        
        if rst = '1' then 
            etat <= INIT;
            sha256_dout_val <= '0';
            --debut_sys <= '1';
        elsif (rising_edge(CLK)) then
            if sha256_din_en = '1' then 
                case etat is 
                    when INIT =>
                    H0 <= x"6a09e667";
                    H1 <= x"bb67ae85";
                    H2 <= x"3c6ef372";
                    H3 <= x"a54ff53a";
                    H4 <= x"510e527f";
                    H5 <= x"9b05688c";
                    H6 <= x"1f83d9ab";
                    H7 <= x"5be0cd19";
                    W <= (others => x"00000000");
                    etat <= INIT_VAR;
                    --debut_sys <= '0';
                    when others =>
                    end case;
            else
                --if sha256_din_en = '1' then
                    case etat is
                        when STOP =>
                            etat <= INIT;
                        when INIT_VAR =>
                            a <= H0;
                            b <= H1;
                            c <= H2;
                            d <= H3;
                            e <= H4;
                            f <= H5;
                            g <= H6;
                            h <= H7;
                            sha256_dout_val <= '0';
                            counter := 0;
                            etat <= BOUCLE_FOR;
                        when BOUCLE_FOR =>
                            if counter < 16 then
                                W(counter) <= sha256_din(511 - 32*counter downto 512 - 32*(counter+1));
                            else  
                                W(counter) <= std_logic_vector(sigma_lower_1(unsigned(W(counter-2)))
                                                + unsigned(W(counter-7)) + sigma_lower_0(unsigned(W(counter-15)))
                                                + unsigned(W(counter-16)));
                            end if;
                            etat <= CALCUL_T1;
                        when CALCUL_T1 =>                      
                            T1 <= std_logic_vector(unsigned(h) + sigma_upper_1(unsigned(e))
                                + ch(unsigned(e), unsigned(f), unsigned(g)));
                                etat <= CALCUL_T2;
                        when CALCUL_T2 =>
                            T1 <= std_logic_vector(unsigned(T1) + K(counter) + unsigned(W(counter)));
                            T2 <= std_logic_vector(sigma_upper_0(unsigned(a)) + maj(unsigned(a), unsigned(b), unsigned(c)));
                            etat <= CALCUL_VAR;
                        when CALCUL_VAR =>
                            h <= g;
                            g <= f;
                            f <= e;
                            e <= std_logic_vector(unsigned(d) + unsigned(T1));
                            d <= c;
                            c <= b;
                            b <= a;
                            a <= std_logic_vector(unsigned(T1) + unsigned(T2));
                            counter := counter + 1;
                            if counter > 63 then
                                etat <= CALCUL_HASH;
                            else 
                                etat <= BOUCLE_FOR;
                            end if;
                        when CALCUL_HASH =>
                            H0 <= std_logic_vector(unsigned(a) + unsigned(H0));
                            H1 <= std_logic_vector(unsigned(b) + unsigned(H1));
                            H2 <= std_logic_vector(unsigned(c) + unsigned(H2));
                            H3 <= std_logic_vector(unsigned(d) + unsigned(H3));
                            H4 <= std_logic_vector(unsigned(e) + unsigned(H4));
                            H5 <= std_logic_vector(unsigned(f) + unsigned(H5));
                            H6 <= std_logic_vector(unsigned(g) + unsigned(H6));
                            H7 <= std_logic_vector(unsigned(h) + unsigned(H7));
                            etat <= ENDING;
                        when ENDING =>
                            sha256_dout_val <= '1';
                            sha256_dout <= H0&H1&H2&H3&H4&H5&H6&H7;
                            etat <= STOP;
                        when others =>
                            
                    end case;
                --end if;
            end if;
        end if;
        
    end process;
end sha256;
