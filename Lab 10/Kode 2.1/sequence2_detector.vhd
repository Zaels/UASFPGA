library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sequence_detector is
    Port ( 
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC; -- Reset active-high
        ain   : in  STD_LOGIC_VECTOR (1 downto 0);
        yout  : out STD_LOGIC
    );
end sequence_detector;

architecture Behavioral of sequence_detector is

    -- Definisi 8 status yang diperlukan menggunakan tipe data enumerasi
    type state_type is (
        ZERO_IDLE,
        ZERO_SAW_01,
        ZERO_SAW_11,
        ZERO_SAW_10,
        ONE_IDLE,
        ONE_SAW_01,
        ONE_SAW_11,
        ONE_SAW_10
    );
    
    -- Sinyal untuk state register
    signal current_state, next_state : state_type;

    -- Konstanta untuk input agar kode lebih mudah dibaca
    constant IN_00 : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant IN_01 : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant IN_10 : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant IN_11 : STD_LOGIC_VECTOR(1 downto 0) := "11";

begin

    -- Process 1: State Register (Logika Sekuensial)
    -- Proses ini berfungsi sebagai memori (Flip-Flop) yang menyimpan status saat ini.
    -- Status hanya berubah pada saat ada detak clock atau sinyal reset.
    state_reg_proc: process(clk, reset)
    begin
        if (reset = '1') then
            current_state <= ZERO_IDLE;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process;

    -- Process 2: Next-State Logic (Logika Kombinasional)
    -- Proses ini menentukan status berikutnya berdasarkan status saat ini dan input 'ain'.
    -- Ini adalah "otak" dari mesin status.
    next_state_logic_proc: process(current_state, ain)
    begin
        case current_state is
            when ZERO_IDLE =>
                if (ain = IN_01) then next_state <= ZERO_SAW_01;
                elsif (ain = IN_11) then next_state <= ZERO_SAW_11;
                elsif (ain = IN_10) then next_state <= ZERO_SAW_10;
                else next_state <= ZERO_IDLE;
                end if;
            when ONE_IDLE =>
                if (ain = IN_01) then next_state <= ONE_SAW_01;
                elsif (ain = IN_11) then next_state <= ONE_SAW_11;
                elsif (ain = IN_10) then next_state <= ONE_SAW_10;
                else next_state <= ONE_IDLE;
                end if;
            when ZERO_SAW_01 => -- Sequence 01,xx -> yout=0
                if (ain = IN_00) then next_state <= ZERO_IDLE;
                elsif (ain = IN_01) then next_state <= ZERO_SAW_01;
                elsif (ain = IN_11) then next_state <= ZERO_SAW_11;
                elsif (ain = IN_10) then next_state <= ZERO_SAW_10;
                else next_state <= ZERO_IDLE;
                end if;
            when ONE_SAW_01 => -- Sequence 01,xx -> yout=0
                if (ain = IN_00) then next_state <= ZERO_IDLE;
                elsif (ain = IN_01) then next_state <= ONE_SAW_01;
                elsif (ain = IN_11) then next_state <= ONE_SAW_11;
                elsif (ain = IN_10) then next_state <= ONE_SAW_10;
                else next_state <= ONE_IDLE;
                end if;
            when ZERO_SAW_11 => -- Sequence 11,xx -> yout=1
                if (ain = IN_00) then next_state <= ONE_IDLE;
                elsif (ain = IN_01) then next_state <= ZERO_SAW_01;
                elsif (ain = IN_11) then next_state <= ZERO_SAW_11;
                elsif (ain = IN_10) then next_state <= ZERO_SAW_10;
                else next_state <= ZERO_IDLE;
                end if;
            when ONE_SAW_11 => -- Sequence 11,xx -> yout=1
                if (ain = IN_00) then next_state <= ONE_IDLE;
                elsif (ain = IN_01) then next_state <= ONE_SAW_01;
                elsif (ain = IN_11) then next_state <= ONE_SAW_11;
                elsif (ain = IN_10) then next_state <= ONE_SAW_10;
                else next_state <= ONE_IDLE;
                end if;
            when ZERO_SAW_10 => -- Sequence 10,xx -> toggle (0->1)
                if (ain = IN_00) then next_state <= ONE_IDLE;
                elsif (ain = IN_01) then next_state <= ZERO_SAW_01;
                elsif (ain = IN_11) then next_state <= ZERO_SAW_11;
                elsif (ain = IN_10) then next_state <= ZERO_SAW_10;
                else next_state <= ZERO_IDLE;
                end if;
            when ONE_SAW_10 => -- Sequence 10,xx -> toggle (1->0)
                if (ain = IN_00) then next_state <= ZERO_IDLE;
                elsif (ain = IN_01) then next_state <= ONE_SAW_01;
                elsif (ain = IN_11) then next_state <= ONE_SAW_11;
                elsif (ain = IN_10) then next_state <= ONE_SAW_10;
                else next_state <= ONE_IDLE;
                end if;
        end case;
    end process;
    
    -- Process 3: Output Logic (Logika Kombinasional)
    -- Proses ini menentukan output HANYA berdasarkan status saat ini.
    -- Inilah yang menjadikannya sebuah mesin Moore.
    output_logic_proc: process(current_state)
    begin
        case current_state is
            when ZERO_IDLE | ZERO_SAW_01 | ZERO_SAW_11 | ZERO_SAW_10 =>
                yout <= '0';
            when ONE_IDLE | ONE_SAW_01 | ONE_SAW_11 | ONE_SAW_10 =>
                yout <= '1';
        end case;
    end process;

end Behavioral;