-- File: tb_binary_multiplier.vhd
-- Deskripsi: Testbench untuk memvalidasi desain pengali 3x3 bit.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_binary_multiplier is
end entity tb_binary_multiplier;

architecture test of tb_binary_multiplier is
    -- Deklarasi Komponen DUT (Device Under Test)
    component binary_multiplier is
        port (
            clk             : in  std_logic;
            rst             : in  std_logic;
            start           : in  std_logic;
            multiplicand_in : in  std_logic_vector(2 downto 0);
            multiplier_in   : in  std_logic_vector(2 downto 0);
            product_out     : out std_logic_vector(5 downto 0);
            done            : out std_logic
        );
    end component;

    -- Sinyal untuk dihubungkan ke DUT
    signal clk          : std_logic := '0';
    signal rst          : std_logic;
    signal start        : std_logic;
    signal multiplicand : std_logic_vector(2 downto 0);
    signal multiplier   : std_logic_vector(2 downto 0);
    signal product      : std_logic_vector(5 downto 0);
    signal done         : std_logic;
    
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instansiasi DUT
    dut_inst : binary_multiplier
        port map (
            clk             => clk,
            rst             => rst,
            start           => start,
            multiplicand_in => multiplicand,
            multiplier_in   => multiplier,
            product_out     => product,
            done            => done
        );

    -- Proses generator clock
    clk <= not clk after CLK_PERIOD / 2;

    -- Proses stimulus
    stim_proc: process
    begin
        report "-------------------------------------------";
        report "Memulai Simulasi Testbench Pengali 3x3 Bit (VHDL)";
        report "-------------------------------------------";
        
        -- --- Test Case 1: 3 x 5 = 15 ---
        rst          <= '1';
        start        <= '0';
        multiplicand <= "110"; -- 6
        multiplier   <= "101"; -- 5
        wait for CLK_PERIOD * 1.5;
        rst <= '0';
        wait for CLK_PERIOD;
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        
        wait until done = '1';
        wait for CLK_PERIOD / 2;
        report "Test Case 1: " & integer'image(to_integer(unsigned(multiplicand))) & " x " &
               integer'image(to_integer(unsigned(multiplier))) & " = " &
               integer'image(to_integer(unsigned(product)));
        assert product = std_logic_vector(to_unsigned(15, 6))
            report "--> Status: GAGAL " severity error;
        report "--> Status: LULUS " & LF; -- LF = Line Feed
        report "-------------------";
        report "Simulasi Selesai.";
        report "-------------------";
        wait;-- Hentikan simulasi
    end process stim_proc;

end architecture test;