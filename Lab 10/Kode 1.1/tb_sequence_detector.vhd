library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sequence_detector_scenario_loop is
end tb_sequence_detector_scenario_loop;

architecture behavior of tb_sequence_detector_scenario_loop is
 
    -- Deklarasi Komponen (UUT)
    component sequence_detector
    Port (
         clk   : in  STD_LOGIC;
         reset : in  STD_LOGIC;
         ain   : in  STD_LOGIC;
         yout  : out STD_LOGIC;
         count : out STD_LOGIC_VECTOR (3 downto 0)
    );
    end component;
    
   -- Sinyal-sinyal
   signal clk   : std_logic := '0';
   signal reset : std_logic := '0';
   signal ain   : std_logic := '0';
   signal yout  : std_logic;
   signal count : std_logic_vector(3 downto 0);

   -- Periode Clock
   constant clk_period : time := 100 ns;

begin
 
    -- Instansiasi UUT
    uut: sequence_detector PORT MAP (
          clk => clk,
          reset => reset,
          ain => ain,
          yout => yout,
          count => count
        );

    -- Proses Pembangkit Clock
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
 
    -- Proses Stimulus dengan Skenario yang Diulang
    stim_proc: process
    begin        
        -- Lakukan reset HANYA SEKALI di awal simulasi
        ain   <= '0';
        reset <= '1';
        wait for 150 ns;
        reset <= '0';
        wait for clk_period;
        
        -- Loop tak terbatas untuk mengulang seluruh skenario tes
        loop
            -- 2. Urutan Pertama (Mencari '1' ke-3)
            ain <= '1'; wait for clk_period; -- '1' ke-1
            ain <= '0'; wait for clk_period;
            ain <= '1'; wait for clk_period; -- '1' ke-2
            ain <= '0'; wait for 2 * clk_period; 
            ain <= '1'; wait for clk_period; -- '1' ke-3 -> yout harusnya 1
            ain <= '0'; wait for clk_period;

            -- 3. Urutan Kedua (Mencari '1' ke-6)
            ain <= '1'; wait for clk_period; -- '1' ke-4
            ain <= '1'; wait for clk_period; -- '1' ke-5
            ain <= '1'; wait for clk_period; -- '1' ke-6 -> yout harusnya 1
            ain <= '0'; wait for 3 * clk_period;

            -- 4. Urutan Ketiga (Mencari '1' ke-9)
            ain <= '1'; wait for clk_period; -- '1' ke-7
            ain <= '0'; wait for clk_period * 2;
            ain <= '1'; wait for clk_period; -- '1' ke-8
            ain <= '0'; wait for clk_period;
            ain <= '1'; wait for clk_period; -- '1' ke-9 -> yout harusnya 1
            ain <= '0'; wait for clk_period;

            -- 5. Lakukan Reset di Tengah Skenario
            wait for 2 * clk_period;
            reset <= '1';
            wait for clk_period;
            reset <= '0';
            wait for clk_period; -- Counter dan state harus kembali ke 0

            -- 6. Urutan Keempat (Setelah Reset)
            ain <= '1'; wait for clk_period; -- '1' ke-1 (setelah reset)
            ain <= '1'; wait for clk_period; -- '1' ke-2
            ain <= '0'; wait for clk_period;
            ain <= '1'; wait for clk_period; -- '1' ke-3 -> yout harusnya 1
            ain <= '0'; wait for clk_period;

            -- 7. Urutan Kelima
            ain <= '1'; wait for clk_period; -- '1' ke-4
            ain <= '1'; wait for clk_period; -- '1' ke-5
            ain <= '1'; wait for clk_period; -- '1' ke-6 -> yout harusnya 1
            ain <= '1'; wait for clk_period; -- '1' ke-7
        end loop;
    end process;
    
    -- Proses terpisah untuk menghentikan simulasi setelah 1 detik
    stop_sim_proc: process
    begin
        wait for 1000 ms;
        report "Simulasi berhenti setelah 1 detik." severity failure;
    end process;

end;