library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity state is
    Port (
        --entrées
        entree: in std_logic_vector(31 downto 0);
        nouvelle_entree : in std_logic;
        CLK, reset : in std_logic;
        --sorties
        sortie : out std_logic_vector(255 downto 0);
        sortie_valide : out std_logic
    );
end state;

architecture Behavioral of state is
    type state is (INIT, INIT_VAR, CALCUL_T, CALCUL_VAR, CALCUL_HASH, OUTPUT, STOP);
    signal etat : state:=INIT;
    constant K : std_logic_vector(31 downto 0) := x"428a2f98";
    signal H0, H1, H2, H3, H4, H5, H6, H7, W : std_logic_vector(31 downto 0);
    signal a, b, c, d, e, f, g, h , T1, T2: std_logic_vector(31 downto 0);
    
    signal ch, maj, sig_upper_1, sig_upper_0 : std_logic_vector(31 downto 0);
    
begin
    compression1: entity work.compression
    port map(e, f, g, ch, open, open, sig_upper_1, open, open);
    compression2: entity work.compression
    port map(a, b, c, open, maj, sig_upper_0,open, open, open);
    
    process(CLK, reset)
        begin
       
        if reset = '1' then
            etat <= INIT;
        elsif (rising_edge(CLK)) then
            case etat is
                when STOP =>
                    
                when INIT =>
                    H0 <= x"6a09e667";
                    H1 <= x"bb67ae85";
                    H2 <= x"3c6ef372";
                    H3 <= x"a54ff53a";
                    H4 <= x"510e527f";
                    H5 <= x"9b05688c";
                    H6 <= x"1f83d9ab";
                    H7 <= x"5be0cd19";
                    W <= x"00000000";
                    etat <= INIT_VAR;
                when INIT_VAR =>
                    a <= H0;
                    b <= H1;
                    c <= H2;
                    d <= H3;
                    e <= H4;
                    f <= H5;
                    g <= H6;
                    h <= H7;
                    W <= entree;
                    sortie_valide <= '0';
                    etat <= CALCUL_T;
                when CALCUL_T =>
                    T1 <= std_logic_vector(unsigned(h) + unsigned(sig_upper_1) + unsigned(ch) 
                            + unsigned(K) + unsigned(W));
                    T2 <= std_logic_vector(unsigned(sig_upper_0) + unsigned(maj));
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
                    etat <= CALCUL_HASH;
                when CALCUL_HASH =>
                    H0 <= std_logic_vector(unsigned(a) + unsigned(H0));
                    H1 <= std_logic_vector(unsigned(b) + unsigned(H1));
                    H2 <= std_logic_vector(unsigned(c) + unsigned(H2));
                    H3 <= std_logic_vector(unsigned(d) + unsigned(H3));
                    H4 <= std_logic_vector(unsigned(e) + unsigned(H4));
                    H5 <= std_logic_vector(unsigned(f) + unsigned(H5));
                    H6 <= std_logic_vector(unsigned(g) + unsigned(H6));
                    H7 <= std_logic_vector(unsigned(h) + unsigned(H7));
                    etat <= OUTPUT;
                when OUTPUT =>
                    sortie_valide <= '1';
                    sortie <= H0&H1&H2&H3&H4&H5&H6&H7;
                    etat <= STOP;
            end case;
        end if;
       
    end process;
    
end Behavioral;
