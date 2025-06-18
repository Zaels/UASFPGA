library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sequence_detector_new is
end tb_sequence_detector_new;

architecture behavior of tb_sequence_detector_new is
 
    -- Deklarasi komponen yang akan diuji
    component sequence_detector
        Port (
            clk   : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            ain   : in  STD_LOGIC_VECTOR (1 downto 0);
            yout  : out STD_LOGIC
        );
    end component;
    
   -- Sinyal untuk input
   signal clk   : std_logic := '0';
   signal reset : std_logic := '0';
   signal ain   : std_logic_vector(1 downto 0) := (others => '0');

   -- Sinyal untuk output
   signal yout  : std_logic;

   -- Definisi periode clock sesuai waveform (20 ns)
   constant clk_period : time := 20 ns;

begin
 
    -- Instansiasi UUT
    uut: sequence_detector PORT MAP (
        clk   => clk,
        reset => reset,
        ain   => ain,
        yout  => yout
    );

    -- Proses pembangkit clock
    clk_process :process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;
 
    -- Proses untuk memberikan stimulus sesuai waveform pada gambar
    stim_proc: process
    begin        
        -- Kondisi awal hingga 110 ns
        reset <= '0';
        ain   <= "00";
        wait for 110 ns;
      
        -- t=110ns
        ain <= "10";
        wait for 20 ns;
        
        -- t=130ns
        ain <= "00";
        wait for 20 ns;
        
        -- t=150ns
        ain <= "01";
        wait for 20 ns;
        
        -- t=170ns, Reset Pertama
        ain   <= "00";
        reset <= '1';
        wait for 20 ns;
        
        -- t=190ns
        reset <= '0';
        ain   <= "10";
        wait for 20 ns;
        
        -- t=210ns, tahan hingga 270ns
        ain <= "00";
        wait for 60 ns;
        
        -- t=270ns, Reset Kedua
        ain   <= "11";
        reset <= '1';
        wait for 20 ns;

        -- t=290ns
        reset <= '0';
        ain   <= "10";
        wait for 20 ns;

        -- t=310ns
        ain <= "00";
        wait for 20 ns;
        
        -- t=330ns
        ain <= "01";
        wait for 20 ns;

        -- t=350ns
        ain <= "00";
        wait for 20 ns;
        
        -- t=370ns
        ain <= "11";
        wait for 20 ns;

        -- t=390ns, Reset Ketiga dan tahan
        ain   <= "00";
        reset <= '1';

        wait; -- Hentikan proses stimulus
    end process;

end behavior;