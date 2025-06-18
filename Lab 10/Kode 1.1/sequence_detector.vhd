library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sequence_detector is
    Port ( 
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC; -- Active-high reset
        ain   : in  STD_LOGIC;
        yout  : out STD_LOGIC;
        count : out STD_LOGIC_VECTOR (3 downto 0)
    );
end sequence_detector;

architecture Behavioral of sequence_detector is

    -- Definisi status
    type state_type is (S0, S1, S2);
    signal current_state, next_state : state_type;
    
    -- Sinyal internal untuk counter
    signal count_internal : unsigned(3 downto 0) := (others => '0');

begin

    -- Process 1: Logika sekuensial untuk register status
    state_register_proc: process(clk, reset)
    begin
        if (reset = '1') then
            current_state <= S0;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process;

    -- Process 2: Logika kombinasional untuk status berikutnya
    next_state_logic_proc: process(current_state, ain)
    begin
        case current_state is
            when S0 =>
                if (ain = '1') then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
            when S1 =>
                if (ain = '1') then
                    next_state <= S2;
                else
                    next_state <= S1;
                end if;
            when S2 =>
                if (ain = '1') then
                    next_state <= S0;
                else
                    next_state <= S2;
                end if;
        end case;
    end process;

    -- Process 3: Logika kombinasional untuk output (ciri khas Mealy)
    output_logic_proc: process(current_state, ain, reset) -- Tambahkan reset ke sensitivity list
    begin
        if reset = '1' then
            yout <= '0'; -- Paksa yout ke 0 selama reset aktif
        elsif ((current_state = S0) and (ain = '0')) then
            yout <= '1'; 
        elsif ((current_state = S2) and (ain = '1')) then
            yout <= '1'; 
        else
            yout <= '0';
        end if;
    end process;
    
    -- Process untuk counter jumlah '1' yang akan ditampilkan di LED
    counter_proc: process(clk, reset)
    begin
        if (reset = '1') then
            count_internal <= (others => '0');
        elsif (rising_edge(clk)) then
            if (ain = '1') then
                count_internal <= count_internal + 1;
            end if;
        end if;
    end process;
    
    -- Meng-assign sinyal internal ke port output
    count <= std_logic_vector(count_internal);

end Behavioral;