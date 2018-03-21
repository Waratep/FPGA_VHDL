
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity lab4 is

	 Port ( Y : out  STD_LOGIC_VECTOR(6 downto 0);
			  clock : in std_logic;
			  dot : out  STD_LOGIC;
			  button_A : in  STD_LOGIC;
			  button_B : in  STD_LOGIC;
			  DEBUG : out STD_LOGIC;
			  com : out  STD_LOGIC_VECTOR(3 downto 0) );
end lab4;

architecture Behavioral of lab4 is
	
	 signal count_clock : integer range(0) to (6250000) := 0; 				 ----- delay for count botton H and M (double)
	 signal count_clock_half : integer range(0) to (12500000) := 0; 				 ----- delay for count botton H and M (double)
    signal toggle_clock : std_logic := '0';                              ----- state check botton H or M
	 signal toggle_clock_half : std_logic := '0';                              ----- state check botton H or M
	 signal i : integer range(0) to (2) ;       
	 signal sec1 : integer range(0) to (10) ;
	 signal sec2 : integer range(0) to (6) ;                              ----- time 
	 signal min1 : integer range(0) to (10) ;
	 signal min2 : integer range(0) to (60) ;
	 signal hour1 : integer range(0) to (10) ;
	 signal hour2 : integer range(0) to (2) ;	 
	 signal X : std_logic_vector (3 downto 0);           						 -----  4 bit counter 
	 signal common : integer range(0) to (500000) := 0;   			       -----  clock of segment 4 common

	
begin

	Y <= "1110001" when X = "1111" else
		  "1111001" when X = "1110" else
		  "1011110" when X = "1101" else
		  "0111001" when X = "1100" else
		  "1111100" when X = "1011" else
		  "1110111" when X = "1010" else
		  "1101111" when X = "1001" else 
		  "1111111" when X = "1000" else
		  "0000111" when X = "0111" else
		  "1111101" when X = "0110" else
		  "1101101" when X = "0101" else
		  "1100110" when X = "0100" else
		  "1001111" when X = "0011" else
		  "1011011" when X = "0010" else
		  "0000110" when X = "0001" else
		  "0111111";
		  

	
	
	
process (clock)
begin
	if (clock'event and clock = '1') then
			count_clock <= count_clock+1;
			if (count_clock = 6250000) then
				  toggle_clock <= not toggle_clock;
				  count_clock <= 1;
			end if;
	end if;
end process;
  
  
process (clock)
begin
	if (clock'event and clock = '1') then
			count_clock_half <= count_clock_half+1;
			if (count_clock_half = 12500000) then
				  toggle_clock_half <= not toggle_clock_half;
				  count_clock_half <= 1;
			end if;
	end if;
end process;
 


process (clock,toggle_clock)
begin
		
	if (clock'event and clock = '1') then
		common <= common+2;
			
		DEBUG <= toggle_clock;	
		if (common < 125000) then
			X <= STD_LOGIC_VECTOR(to_unsigned(sec1,4));    ------ 1110
			dot <= '0';
			com <= "1110";
		end if;	
		
		if (common > 125000 and common < 250000) then
			X <= STD_LOGIC_VECTOR(to_unsigned(sec2,4));    ------ 1101
			dot <= toggle_clock_half or button_B or button_A;
			com <= "1101";
		end if;
		
		if (common > 250000 and common < 375000) then
			X <= STD_LOGIC_VECTOR(to_unsigned(min1,4));   ------ 1011
			dot <= toggle_clock_half or button_B or button_A;
			com <= "1011";
		end if;
		
		if (common > 375000 and common < 500000) then
			X <= STD_LOGIC_VECTOR(to_unsigned(min2,4));  ------ 0111
			dot <= '0';
			com <= "0111";
		end if;
				
	end if;						
end process;
  
  
process (toggle_clock)                                   ---- process clock
begin	
	
	
	if rising_edge(toggle_clock) then
		
		i <= i+1;
		if (i = 1) then
			sec1 <= sec1+1;                                    ---- count sec ++
			i <= 0;
			
			if (sec1 = 9) then                   
				sec1 <= 0;
				sec2 <= sec2+1;

			end if;
		
		end if;
		
		if (button_A = '1') then 
			hour1 <= hour1+1;
		end if;
			
		if (button_B = '1') then 
			min1 <=min1+1;
			
		end if;
		
		if (sec2 = 5 and sec1 = 9) then
			sec2 <= 0;
			min1 <= min1+1;
		end if;
		
		if (min1 = 9) then
			min1 <= 0;
			min2 <= min2+1;
		end if;
		
		if (min2 = 5 and min1 = 9) then
			min2 <= 0;
			hour1 <= hour1+1;
		end if;	
		
		if (hour1 = 9) then
			hour1 <= 0;
			hour2 <= hour2+1;
		end if;
		
		if (hour2 = 2 and hour1 = 4) then
			hour2 <= 0;
			hour1 <= 0;
			min2 <= 0;
			min1 <= 0;
			sec2 <= 0;
			sec1 <= 0;
		end if;	
			
			
	end if;
end process;

end Behavioral;







