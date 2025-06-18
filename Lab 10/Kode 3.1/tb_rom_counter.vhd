library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_rom_counter is
end tb_rom_counter;

architecture behavior of tb_rom_counter is
 
    -- Deklarasi komponen yang akan diuji
    component rom_counter
        Port (
            clk        : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            count_out  : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

   -- Sinyal untuk input
   signal clk   : std_logic := '0';
   signal reset : std_logic := '0';

   -- Sinyal untuk output
   signal count_out : std_logic_vector(2 downto 0);

   -- Definisi periode clock
   constant clk_period : time := 100 ns; -- Sesuai untuk simulasi manual dengan switch

begin
    -- Instansiasi Unit Under Test (UUT)
    uut: rom_counter PORT MAP (
        clk        => clk,
        reset      => reset,
        count_out  => count_out
    );

    -- Proses untuk membangkitkan clock
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Proses untuk memberikan stimulus
    stim_proc: process
    begin
        -- Berikan sinyal reset di awal selama satu siklus clock
        reset <= '1';
        wait for clk_period;
        reset <= '0';

        -- Biarkan simulasi berjalan selama 15 siklus untuk melihat urutan berulang
        wait for 15 * clk_period;
        
        wait; -- Hentikan simulasi
    end process;
end;