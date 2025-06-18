-- File: binary_multiplier.vhd
-- Deskripsi: Modul top-level yang menggabungkan datapath dan control_unit.

library ieee;
use ieee.std_logic_1164.all;

entity binary_multiplier is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        start           : in  std_logic;
        multiplicand_in : in  std_logic_vector(2 downto 0);
        multiplier_in   : in  std_logic_vector(2 downto 0);
        product_out     : out std_logic_vector(5 downto 0);
        done            : out std_logic
    );
end entity binary_multiplier;

architecture structural of binary_multiplier is
    -- Deklarasi Komponen
    component datapath is
        port (
            clk             : in  std_logic;
            rst             : in  std_logic;
            load            : in  std_logic;
            add_op          : in  std_logic;
            shift_op        : in  std_logic;
            multiplicand_in : in  std_logic_vector(2 downto 0);
            multiplier_in   : in  std_logic_vector(2 downto 0);
            Q_lsb           : out std_logic;
            cnt_done        : out std_logic;
            product_out     : out std_logic_vector(5 downto 0)
        );
    end component;

    component control_unit is
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
    end component;

    -- Sinyal internal untuk menghubungkan kedua unit
    signal load_s, add_s, shift_s : std_logic;
    signal q_lsb_s, cnt_done_s   : std_logic;

begin
    -- Instansiasi Unit Pemroses Data
    u_datapath : datapath
        port map (
            clk             => clk,
            rst             => rst,
            load            => load_s,
            add_op          => add_s,
            shift_op        => shift_s,
            multiplicand_in => multiplicand_in,
            multiplier_in   => multiplier_in,
            Q_lsb           => q_lsb_s,
            cnt_done        => cnt_done_s,
            product_out     => product_out
        );

    -- Instansiasi Unit Kontrol
    u_control : control_unit
        port map (
            clk      => clk,
            rst      => rst,
            start    => start,
            Q_lsb    => q_lsb_s,
            cnt_done => cnt_done_s,
            load     => load_s,
            add_op   => add_s,
            shift_op => shift_s,
            done     => done
        );

end architecture structural;