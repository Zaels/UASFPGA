-- File: datapath.vhd
-- Deskripsi: Unit pemroses data untuk pengali 3x3 bit.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        -- Sinyal Kontrol
        load            : in  std_logic;
        add_op          : in  std_logic;
        shift_op        : in  std_logic;
        -- Input Data
        multiplicand_in : in  std_logic_vector(2 downto 0);
        multiplier_in   : in  std_logic_vector(2 downto 0);
        -- Output Status & Data
        Q_lsb           : out std_logic;
        cnt_done        : out std_logic;
        product_out     : out std_logic_vector(5 downto 0)
    );
end entity datapath;

architecture behavioral of datapath is
    -- Register Internal
    signal M_reg        : std_logic_vector(2 downto 0);
    signal Q_reg        : std_logic_vector(2 downto 0);
    signal A_reg        : std_logic_vector(2 downto 0);
    signal C_reg        : std_logic;
    signal counter_reg  : unsigned(1 downto 0);

    -- Sinyal untuk hasil penjumlahan
    signal sum_result   : unsigned(3 downto 0);

begin
    -- Logika Kombinasional untuk Adder
    sum_result <= unsigned('0' & A_reg) + unsigned(M_reg);

    -- Proses Sekuensial Utama (dipicu oleh clock)
    process(clk, rst)
    begin
        if (rst = '1') then
            -- Reset semua register
            A_reg       <= (others => '0');
            Q_reg       <= (others => '0');
            M_reg       <= (others => '0');
            C_reg       <= '0';
            counter_reg <= (others => '0');
        elsif (rising_edge(clk)) then
            if (load = '1') then
                -- Muat operand dan inisialisasi
                A_reg       <= (others => '0');
                Q_reg       <= multiplier_in;
                M_reg       <= multiplicand_in;
                C_reg       <= '0';
                counter_reg <= (others => '0');
            elsif (add_op = '1') then
                -- Operasi Penjumlahan: {C, A} <= A + M
                C_reg       <= std_logic(sum_result(3));
                A_reg       <= std_logic_vector(sum_result(2 downto 0));
            elsif (shift_op = '1') then
                -- Operasi Geser Kanan: {C, A, Q} digeser
                Q_reg       <= A_reg(0) & Q_reg(2 downto 1);
                A_reg       <= C_reg & A_reg(2 downto 1);
                C_reg       <= '0'; -- Carry di-clear setelah digeser
                counter_reg <= counter_reg + 1;
            end if;
        end if;
    end process;

    -- Menetapkan sinyal output
    Q_lsb       <= Q_reg(0);
    cnt_done    <= '1' when counter_reg = "11" else '0'; -- Selesai setelah 3 pergeseran
    product_out <= A_reg & Q_reg;

end architecture behavioral;