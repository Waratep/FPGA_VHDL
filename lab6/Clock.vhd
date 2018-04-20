
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Clock is
    Port ( y : out  STD_LOGIC_VECTOR (6 downto 0);
           clock : in  STD_LOGIC;
           com : out  STD_LOGIC_VECTOR (3 downto 0);
           dot : out  STD_LOGIC;
			  butH : in  STD_LOGIC;
			  b1 : in  STD_LOGIC;
			  b2 : in  STD_LOGIC;
			  led1 : out  STD_LOGIC;
			  led2 : out  STD_LOGIC;
			  sw1 : in  STD_LOGIC;
			  sw2 : in  STD_LOGIC;
			  alarm : in  STD_LOGIC;
			  led3 : out  STD_LOGIC;
			  led4 : out  STD_LOGIC;
			  led5 : out  STD_LOGIC;
			  led6 : out  STD_LOGIC;
			  led : out  STD_LOGIC;
			  buzzer : out  STD_LOGIC;
			  butM : in  STD_LOGIC
			  );
end Clock;

architecture Behavioral of Clock is
		-- time
		signal x : std_logic_vector (3 downto 0);
		signal sec1 : integer range (0) to (10);
		signal sec2 : integer range (0) to (6);
		signal min1 : integer range (0) to (10);
		signal min2 : integer range (0) to (6);
		signal hour1 : integer range (0) to (10);
		signal hour2 : integer range (0) to (2);
		
		signal min1_al : integer range (0) to (10);
		signal min2_al : integer range (0) to (6);
		signal hour1_al : integer range (0) to (10);
		signal hour2_al : integer range (0) to (2);
		
		
		-- freq clock
		signal co : integer range (0) to (500000);
		constant c : integer := 12500000;
		signal fre : integer range (0) to (c);
		signal fre_buz : integer range (0) to (2000);
		signal buz : std_logic;
		signal fre1 : integer range (0) to (c);
		signal clock1000ms : std_logic;
		signal clock500ms : std_logic;
		signal count : integer range (0) to (1);
		
		-- button
		signal b1_buf : std_logic;
		signal b2_buf : std_logic;
		
		-- switch
		signal sw1_buf : std_logic;
		signal sw2_buf : std_logic;
		signal alarm_buf : std_logic;

begin	
			-- gfedcba
		y <= "1101111" when x = "1001" else	--9	  
			  "1111111" when x = "1000" else	--8
			  "0000111" when x = "0111" else	--7
			  "1111101" when x = "0110" else	--6
			  "1101101" when x = "0101" else	--5
			  "1100110" when x = "0100" else	--4
			  "1001111" when x = "0011" else	--3
			  "1011011" when x = "0010" else	--2
			  "0000110" when x = "0001" else	--1
			  "0111111";	--0
		led <= clock1000ms;


			  
process (clock)
begin
	if (clock'event and clock = '1') then
			fre <= fre+1;
			if (fre = c) then
				  clock1000ms <= not clock1000ms;
				  fre<=1;
			end if;
	end if;
end process;

			  
process (clock)
begin
	if (clock'event and clock = '1') then
			fre_buz <= fre_buz+1;
			if (fre = 2000) then
				  buz <= not buz;
				  fre_buz<=1;
			end if;
	end if;
end process;

process (clock)
begin
	if (clock'event and clock = '1') then
	
			while (b1 = '1') loop
				b1_buf <= not b1_buf;
			
				if (b1_buf = '0') then
					led1 <= '0';
				end if;
				if (b1_buf = '1') then
					led1 <= '1';
				end if;
				
			end loop;
			
			while (b2 = '1') loop
				b2_buf <= not b2_buf;
			
				if (b2_buf = '0') then
					led2 <= '0';
				end if;
				if (b2_buf = '1') then
					led2 <= '1';
				end if;
				
			end loop;
			
			
			if (sw1 = '0') then
				
				led3 <= '1';
				sw1_buf <= '1';
				
			end if;
			
			if (sw1 = '1') then
				
				led3 <= '0';
				sw1_buf <= '0';
				
			end if;
			
			if (sw2 = '0') then
				
				led4 <= '1';
				sw2_buf <= '1';
				
			end if;
			
			if (sw2 = '1') then
				
				led4 <= '0';
				sw2_buf <= '0';
				
			end if;	

			if (alarm = '0') then
				
				led5 <= '1';
				alarm_buf <= '1';
				
			end if;
			
			if (alarm = '1') then
				
				led5 <= '0';
				alarm_buf <= '0';
				
			end if;		

			
	end if;
end process;

process (buz)
begin
	if (buz'event and buz = '1') then
			if (min1 = min1_al and min2 = min2_al and hour1 = hour1_al and hour2 = hour2_al and alarm_buf = '1') then
				buzzer <= buz;
				led6 <= '1';
			else
				buzzer <= '0';
				led6 <= '0';
			end if;
			
	end if;
end process;


process (clock)
begin
	if (clock'event and clock = '1') then
			fre1 <= fre1+1;
			if (fre1 = c/2) then
				  clock500ms <= not clock500ms;
				  fre1<=1;
			end if;	
	end if;
end process;


process(clock500ms)
begin
		if(clock500ms'event and clock500ms = '1') then
			count <= count+1;
			-- clock
			if (count = 1) then
				sec1 <= sec1+1 ;						-- sec digit
				if (sec1 = 9) then		
					sec1 <= 0;							
					sec2 <= sec2+1;					-- sec tens 
					if (sec2 = 5) then		
						sec2 <= 0;						
						min1 <= min1+1;				-- min digit
						if (min1 = 9) then		
							min1 <= 0;					
							min2 <= min2+1;			-- min tens
							if (min2 = 5) then
								min2 <= 0;				
								hour1 <= hour1+1;		-- hour digit
								if (hour1 = 9) then		
									hour1 <= 0;
									hour2 <= hour2+1;	-- hour tens
								end if;
								if (hour2 = 2 and hour1 = 3) then		-- clear
									hour2 <= 0;	
									hour1 <= 0;
								end if;	
							end if;
						end if;
					end if;
				end if;
			end if;
			
		
		
			if (butM = '1') then	
				if (sw2_buf = '0') then
					min1 <= min1+1;				-- min digit
					if (min1 = 9) then		
						min1 <= 0;
						min2 <= min2+1;			-- min tens	
					end if;
					
					if (min2 = 5 and min1 = 9) then		
							min1 <= 0;
							min2 <= 0;
							hour1 <= hour1+1;		-- hour digit
					end if;
				end if;
				
				if (sw2_buf = '1') then
					min1_al <= min1_al+1;				-- min digit
					if (min1_al = 9) then		
						min1_al <= 0;
						min2_al <= min2_al+1;			-- min tens	
					end if;
				
					if (min2_al = 5 and min1_al = 9) then		
						min1_al <= 0;
						min2_al <= 0;
						hour1_al <= hour1_al+1;		-- hour digit
					end if;
				end if;
				
			end if;
		
			if(butH = '1') then
				if(sw2_buf = '0') then
					hour1 <= hour1+1;
					if (hour1 = 9) then		-- hour tens
						hour1 <= 0;
						hour2 <= hour2+1;
						
					end if;
					if (hour2 = 2 and hour1 = 3) then		-- clear
						hour1 <= 0;
						hour2 <= 0;
					end if;
				end if;
				
				if(sw2_buf = '1') then
					hour1_al <= hour1_al+1;
					if (hour1_al = 9) then		-- hour tens
						hour1_al <= 0;
						hour2_al <= hour2_al+1;
					end if;
					if (hour2_al = 2 and hour1_al = 3) then		-- clear
						hour1_al <= 0;
						hour2_al <= 0;
					end if;
				end if;
			end if;			
	   end if;
			
end process;

process (clock,clock1000ms)
begin
		if(clock'event and clock = '1') then
			co<=co+1;
		-- common
			if (co < 125000) then
				if (sw1_buf = '1' and sw2_buf = '0') then
					x <= STD_LOGIC_VECTOR(to_unsigned (min1,4));
				elsif(sw1_buf = '0') then
					x <= STD_LOGIC_VECTOR(to_unsigned (sec1,4));
				elsif(sw2_buf = '1' and sw1_buf = '1') then
					x <= STD_LOGIC_VECTOR(to_unsigned (min1_al,4));
				end if;
				com <= "1110";
				dot <= '0';
			end if;
			
			if (co > 125000 and co < 250000) then
				if (sw1_buf = '1' and sw2_buf = '0') then
					x <= STD_LOGIC_VECTOR(to_unsigned (min2,4));
				elsif(sw1_buf = '0') then
					x <= STD_LOGIC_VECTOR(to_unsigned (sec2,4));
				elsif(sw2_buf = '1' and sw1_buf = '1') then
					x <= STD_LOGIC_VECTOR(to_unsigned (min2_al,4));	
				end if;
				com <= "1101";		
				dot <= clock1000ms or butH or butM;
			end if;
			
			if (co > 250000 and co < 375000) then 
				if (sw1_buf = '1' and sw2_buf = '0') then
					x <= STD_LOGIC_VECTOR(to_unsigned (hour1,4));
				elsif(sw1_buf = '0') then
					x <= STD_LOGIC_VECTOR(to_unsigned (min1,4));
				elsif(sw2_buf = '1' and sw1_buf = '1') then
					x <= STD_LOGIC_VECTOR(to_unsigned (hour1_al,4));
				end if;
				com <= "1011";
				dot <= clock1000ms or butH or butM;
			end if;
			
			if(co > 375000 and co < 500000) then
				if (sw1_buf = '1' and sw2_buf = '0') then
					x <= STD_LOGIC_VECTOR(to_unsigned (hour2,4));
				elsif(sw1_buf = '0') then
					x <= STD_LOGIC_VECTOR(to_unsigned (min2,4));
				elsif(sw2_buf = '1' and sw1_buf = '1') then
					x <= STD_LOGIC_VECTOR(to_unsigned (hour2_al,4));
				end if;
				com <= "0111";
				dot <= '0';
			end if;
			
		end if;	
end process;

end Behavioral;

