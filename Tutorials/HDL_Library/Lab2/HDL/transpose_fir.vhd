library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transpose_fir is
    Port ( din : in std_logic_vector(11 downto 0);
           clk : in std_logic;
           ce : in std_logic;
           rst : in std_logic_vector(0 downto 0);
           dout : out std_logic_vector(25 downto 0));
end transpose_fir;

architecture Behavioral of transpose_fir is

component mac
	generic (
	     coef_value : integer := 0
	);
	
	port(
	     din : in std_logic_vector(11 downto 0);
   	  cin : in std_logic_vector(25 downto 0);
	     clk : in std_logic;
   	  ce : in std_logic;
		  rst : in std_logic;
   	  dout : out std_logic_vector(25 downto 0));
end component;

constant N : integer := 23;	                    -- Number of Coefficients
type coef_array is array (0 to N-1) of integer;	  -- Coefficient Values
constant coefficient : coef_array := (-38, -74, -109, -109, -37, 140, 435, 827, 1262, 1663, 1945, 2047, 1945, 1663, 1262, 827, 435, 140, -37, -109, -109, -74, -38);

signal cin_temp : std_logic_vector(26*N downto 0) := CONV_STD_LOGIC_VECTOR (0, 26*N+1);  

	

begin

   G0: for I in 0 to N-1 generate
      	
      	G_first: if I = 0 generate
		
		M0: MAC 
			generic map (
		        coef_value => coefficient(I)
			)
			port map (
              din => din, 
			     cin => "00000000000000000000000000",
              clk => clk,
		   	   ce => ce,
				  rst => rst(0),
			     dout => cin_temp(25 downto 0));
			end generate;
	
	GX: if (I >= 1 and I < N-1) generate
		M1: MAC 
			generic map (
			     coef_value => coefficient(I)
			)
			port map (
	           din => din, 
			     cin => cin_temp(I*25+(I-1) downto ((I-1)*26)),
	           clk => clk,
			     ce => ce,
				  rst => rst(0),
			     dout => cin_temp((I+1)*25+I downto I*26));
			end generate;
	
	
	G_last: if I = N-1 generate
		M2: MAC 
			generic map(
			     coef_value => coefficient(I)
			)			
			port map (
              din => din, 
			     cin => cin_temp(I*25+(I-1) downto ((I-1)*26)),
              clk => clk,
		        ce => ce,
				  rst => rst(0),
		        dout => dout);
			end generate;
   end generate;

end Behavioral;
