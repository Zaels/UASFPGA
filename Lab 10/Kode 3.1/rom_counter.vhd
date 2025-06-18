library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom_counter is
    Port ( 
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        count_out  : out STD_LOGIC_VECTOR (2 downto 0)
    );
end rom_counter;

architecture Behavioral of rom_counter is

    -- 1. Mendefinisikan tipe dan konstanta untuk ROM
    -- Ini adalah lookup table yang berisi urutan hitungan
    type rom_type is array (0 to 7) of STD_LOGIC_VECTOR(2 downto 0);
    constant COUNT_ROM : rom_type := (
        0 => "001",  -- 0 -> 1
        1 => "011",  -- 1 -> 3
        2 => "000",  -- 2 -> 0
        3 => "101",  -- 3 -> 5
        4 => "000",  -- 4 (unused) -> 0
        5 => "111",  -- 5 -> 7
        6 => "000",  -- 6 (unused) -> 0
        7 => "010"   -- 7 -> 2
    );

    -- Sinyal internal untuk menyimpan state (hitungan) saat ini dan berikutnya
    signal current_count : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal next_count    : STD_LOGIC_VECTOR(2 downto 0);

begin

    -- 2. Logika State Berikutnya (ROM Lookup)
    -- Mengambil nilai hitungan berikutnya dari ROM berdasarkan hitungan saat ini.
    -- to_integer mengubah std_logic_vector menjadi integer agar bisa dipakai sebagai alamat array.
    next_count <= COUNT_ROM(to_integer(unsigned(current_count)));

    -- 3. Register State (Process Sinkron)
    -- Proses ini menyimpan state saat ini dan hanya akan mengupdate nilainya
    -- dengan state berikutnya saat ada clock atau reset.
    process(clk, reset)
    begin
        if (reset = '1') then
            current_count <= "000";
        elsif (rising_edge(clk)) then
            current_count <= next_count;
        end if;
    end process;
    
    -- 4. Logika Output
    -- Mengeluarkan nilai hitungan yang stabil (state saat ini) ke LED.
    count_out <= current_count;

end Behavioral;