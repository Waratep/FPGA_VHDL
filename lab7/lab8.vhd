library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lab8 is
	Port ( Y : out  STD_LOGIC_VECTOR(6 downto 0);
			clock : in std_logic;
			shift : in std_logic;
			com : out  STD_LOGIC_VECTOR(3 downto 0);
			control: in STD_LOGIC_VECTOR(1 downto 0);
			input_A : in STD_LOGIC_VECTOR(7 downto 0);
			input_B : in STD_LOGIC_VECTOR(7 downto 0)
			);
end lab8;

architecture Behavioral of lab8 is

	 signal A : std_logic_vector (7 downto 0);	
	 
	 signal Buffer_1 : std_logic_vector (8 downto 0); 		
	 signal Buffer_2 : std_logic_vector (8 downto 0); 				 
	 signal Buffer_3 : std_logic_vector (8 downto 0); 				 
	 signal Buffer_4 : std_logic_vector (8 downto 0); 				 	 
	 signal X : std_logic_vector (3 downto 0);  
	 signal output : std_logic_vector (3 downto 0);           						 
	 signal common : integer range(0) to (500000) := 0;   			       -----  clock of segment 4 common

begin

	Y <= "1110001" when X = "1111" else		--F
		  "1111001" when X = "1110" else		--E
		  "1011110" when X = "1101" else		--D
		  "0111001" when X = "1100" else		--C
		  "1111100" when X = "1011" else		--B
		  "1110111" when X = "1010" else		--A
		  "1101111" when X = "1001" else 	--9
		  "1111111" when X = "1000" else		--8
		  "0000111" when X = "0111" else		--7
		  "1111101" when X = "0110" else		--6
		  "1101101" when X = "0101" else		--5
		  "1100110" when X = "0100" else		--4
		  "1001111" when X = "0011" else		--3
		  "1011011" when X = "0010" else		--2
		  "0000110" when X = "0001" else    --1
		  "0111111";                        --0

			

process (control)  --ADD
begin
	
	if (control = "00") then
		Buffer_1 <= ('0'& not input_A) + ('0'& not input_B);
		
	end if;
end process;



process (control)  --SUB
begin

	if (control = "01") then
		Buffer_2 <= ('0'& not input_A) - ('0'& not input_B);
		
	end if;
end process;



process (control)  --XOR
begin

	if (control = "10") then
		Buffer_3 <= ('0'& not input_A) xor ('0'& not input_B);
		
	end if;
end process;



process (control,shift)  --SHL
begin

	if (control = "11") then
		
		if (shift = '1') then
			
			Buffer_4 <= ('0'& not input_A);
		
			Buffer_4(8) <= Buffer_4(7);
			Buffer_4(7) <= Buffer_4(6);
			Buffer_4(6) <= Buffer_4(5);
			Buffer_4(5) <= Buffer_4(4);
			Buffer_4(4) <= Buffer_4(3);
			Buffer_4(3) <= Buffer_4(2);
			Buffer_4(2) <= Buffer_4(1);
			Buffer_4(1) <= Buffer_4(0);
			Buffer_4(0) <= '0';
			
		else 
			Buffer_4 <= ('0'& not input_A);
		end if;
		
	end if;
	
end process;

process (clock,control)
begin
if (clock'event and clock = '1') then
	common <= common + 2;
		if (common < 125000) then
			--output <= (Buffer_X(3) & Buffer_X(2) & Buffer_X(1) & Buffer_X(0));   
			if (control = "00") then
				X <= Buffer_1(3 downto 0);
			end if;
			if (control = "01") then
				X <= Buffer_2(3 downto 0);			
			end if;
			if (control = "10") then
				X <= Buffer_3(3 downto 0);
			end if;
			if (control = "11") then
				X <= Buffer_4(3 downto 0);
			end if;
			
			com <= "1110";
		end if;	
		
		if (common > 125000 and common < 250000) then
			--output <= (Buffer_X(7) & Buffer_X(6) & Buffer_X(5) & Buffer_X(4));
			if (control = "00") then
				X <= Buffer_1(7 downto 4);
			end if;
			if (control = "01") then
				X <= Buffer_2(7 downto 4);			
			end if;
			if (control = "10") then
				X <= Buffer_3(7 downto 4);
			end if;
			if (control = "11") then
				X <= Buffer_4(7 downto 4);
			end if;
					
			com <= "1101";
			
		end if;
		
		if (common > 250000 and common < 375000) then
			--output <= ('0'&'0'&'0'&Buffer_X(8)); 
			if (control = "00") then
				X <= '0'&'0'&'0'&Buffer_1(8);
			end if;
			if (control = "01") then
				X <= '0'&'0'&'0'&Buffer_2(8);			
			end if;
			if (control = "10") then
				X <= '0'&'0'&'0'&Buffer_3(8);
			end if;
			if (control = "11") then
				X <= '0'&'0'&'0'&Buffer_4(8);
			end if;
						
			com <= "1011";
		end if;
		
		if (common > 375000 and common < 500000) then
			--X <= STD_LOGIC_VECTOR(to_unsigned(min2,4));  
			--com <= "0111";
		end if;
end if;
end process;

end Behavioral;
