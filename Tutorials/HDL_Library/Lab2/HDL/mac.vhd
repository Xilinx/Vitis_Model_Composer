library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mac is
   generic(
	   coef_value : integer := 0
	);
	
	port(
	     din : in std_logic_vector(11 downto 0);
   	  cin : in std_logic_vector(25 downto 0);
	     clk : in std_logic;
   	  ce : in std_logic;
		  rst : in std_logic;
   	  dout : out std_logic_vector(25 downto 0));
end mac;

architecture Behavioral of mac is

signal coef : std_logic_vector(11 downto 0);
signal product : std_logic_vector(23 downto 0); 
signal addition : std_logic_vector(25 downto 0); 

begin

	coef <= CONV_STD_LOGIC_VECTOR (coef_value, 12);

	--sign extend the coefficients



	-- Multiplication
	process(clk, ce, din, coef)
	begin

		if clk'event and clk='1' then
			if (ce='1') then

				product <= din * coef;

			end if;
		end if;

	end process;

	-- Addition	chain
	addition <= product + cin;

	-- Register result
	process(clk, ce, addition, rst)
	begin

		if (rst = '0') then

			dout <= "00000000000000000000000000";

		elsif (clk'event and clk='1') then
			if (ce='1') then

				dout <= addition;

			end if;
		end if;

	end process;

end Behavioral;
