Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;
entity juego is
	Port( reloj,boton: in std_logic;
			Dado : BUFFER STD_LOGIC_VECTOR (6 DOWNTO 0));
end juego;

architecture behavioral of juego is
--signal boton : std_logic;
signal cuenta: INTEGER RANGE 7 TO 1000000 := 7;
signal modulo, aux: INTEGER;
begin
	process (reloj, boton)
		begin
			if rising_edge(reloj) then
				cuenta <= cuenta + 1;
				if cuenta = 1000000 then
					cuenta <= 7;
				end if;
			end if;
			if boton = '1' then
				aux <= cuenta mod 6;
				if aux = 0 then
					aux <= aux + 1;
					modulo <= aux;
				else
					modulo <= aux;
				end if;
			end if;
	end process;
	WITH modulo SELECT 
		Dado<=	"1111001" WHEN 1,-- 1
					"0100100" WHEN 2,-- 2
					"0110000" WHEN 3,-- 3
					"0011001" WHEN 4,-- 4
					"0010010" WHEN 5,-- 5
					"0000010" WHEN 6,-- 6
					"1111111" WHEN OTHERS;
end behavioral;