
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.complex_slv_trans_pkg.all;
use work.mc_interface_trans_pkg.all;

entity ssr_transpose_top is
    generic(
        SSR        : natural := 16;
        DATA_WIDTH : natural := 32;
        MEM_STYLE  : natural := 4;
        SIM_METHOD : natural := 2;      --1 is inactive, 2 is xsim, 3 is questa
        M          : natural := 16;
        N          : natural := 2048
    );
    port(
        clk   : in  std_logic;
        ce    : in  std_logic := '1';   -- not used, for SysGen only
        idata : in  std_logic_vector(2 * DATA_WIDTH * SSR - 1 downto 0);
        vi    : in  std_logic;
        odata : out std_logic_vector(2 * DATA_WIDTH * SSR - 1 downto 0);
        vo    : out std_logic
    );
end entity;

architecture one of ssr_transpose_top is

    function to_style_string(x : natural) return string is
    begin
        if (x = 0) then
            return "auto";
        elsif (x = 1) then
            return "block";
        elsif (x = 2) then
            return "distributed";
        elsif (x = 3) then
            return "registers";
        elsif (x = 4) then
            return "ultra";
        elsif (x = 5) then
            return "mixed";
        end if;
    end function;

    constant STYLE : STRING := to_style_string(mem_style);
    --"block", "distributed", "registers", "ultra", "mixed", "auto"


    --constant L2M : INTEGER        := LOG2(M);
    --constant L2N : INTEGER        := LOG2(N);
    --constant L2R : INTEGER        := LOG2(SSR);

begin
    u0 : entity work.ssr_transpose_top_encrypt
        generic map(
            SSR            => SSR,
            DATA_WIDTH     => DATA_WIDTH,
            STYLE => STYLE,
            SIM_METHOD => SIM_METHOD,
            M => M,
            N => N 
        )
        port map(
            clk   => clk,
            ce    => ce,
            idata => idata,
            vi    => vi,
            odata => odata,
            vo    => vo
        );


end architecture;
