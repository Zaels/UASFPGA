-- File: control_unit.vhd (VERSI PERBAIKAN)
library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        start    : in  std_logic;
        Q_lsb    : in  std_logic;
        cnt_done : in  std_logic;
        load     : out std_logic;
        add_op   : out std_logic;
        shift_op : out std_logic;
        done     : out std_logic
    );
end entity control_unit;

architecture behavioral of control_unit is
    -- Menambah state baru S_LOAD
    type state_t is (S_IDLE, S_LOAD, S_CHECK, S_ADD, S_SHIFT, S_DONE);
    signal current_state, next_state : state_t;

begin
    -- Proses 1: Logika transisi state (sinkron) - TIDAK BERUBAH
    process(clk, rst)
    begin
        if (rst = '1') then
            current_state <= S_IDLE;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process;

    -- Proses 2: Logika state berikutnya dan output (kombinasional) - DIUBAH TOTAL
    process(current_state, start, Q_lsb, cnt_done)
    begin
        -- Nilai default
        load     <= '0';
        add_op   <= '0';
        shift_op <= '0';
        done     <= '0';
        next_state <= current_state;

        case current_state is
            when S_IDLE =>
                if (start = '1') then
                    next_state <= S_LOAD; -- Pindah ke state LOAD, jangan buat keputusan dulu
                end if;

            when S_LOAD => -- STATE BARU
                load <= '1'; -- Aktifkan sinyal load di sini
                next_state <= S_CHECK; -- Setelah load, pindah untuk mengecek LSB

            when S_CHECK => -- STATE BARU UNTUK MEMBUAT KEPUTUSAN
                if (cnt_done = '1') then
                    next_state <= S_DONE; -- Jika sudah selesai, ke DONE
                else
                    if (Q_lsb = '1') then -- Sekarang Q_lsb sudah valid
                        next_state <= S_ADD;
                    else
                        next_state <= S_SHIFT;
                    end if;
                end if;

            when S_ADD =>
                add_op <= '1';
                next_state <= S_SHIFT; -- Setelah ADD, selalu SHIFT

            when S_SHIFT =>
                shift_op <= '1';
                next_state <= S_CHECK; -- Setelah SHIFT, kembali mengecek kondisi

            when S_DONE =>
                done <= '1';
                if (start = '0') then
                    next_state <= S_IDLE;
                end if;

        end case;
    end process;

end architecture behavioral;