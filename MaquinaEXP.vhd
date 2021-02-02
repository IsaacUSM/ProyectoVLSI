Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_unsigned.all;
entity MaquinaEXP is
	Generic (FREQ_CLK: integer := 50_000_00);
	Port( CLK: IN STD_LOGIC;
			COLUMNAS: in std_logic_vector(3 downto 0);
			FILAS: out std_logic_vector(3 downto 0);
			BOTON_PRES: out std_logic_vector (3 downto 0);
			IND: out std_logic;
			PASS: OUT STD_LOGIC;
			stop_motor: OUT STD_LOGIC:='0';
			D0,D1,D2,D3,D4,D5,FANTASMA : BUFFER STD_LOGIC_VECTOR (6 DOWNTO 0));
end MaquinaEXP;

architecture behavioral of MaquinaEXP is
	CONSTANT DELAY_1MS : INTEGER := (FREQ_CLK/1000)-1;
	CONSTANT DELAY_10MS : INTEGER := (FREQ_CLK/100)-1;
	SIGNAL CONTA_1MS: INTEGER RANGE 0 TO DELAY_1MS := 0;
	SIGNAL BANDERA: STD_LOGIC := '0';
	SIGNAL CONTA_10MS: INTEGER RANGE 0 TO DELAY_10MS := 0;
	SIGNAL BANDERA2 : STD_LOGIC := '0';
	SIGNAL BOT_1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_3 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_4 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_5 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_6 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_7 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_8 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_9 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_A : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_B : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_C : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_D : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_0 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_AS : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL BOT_GA : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL FILA_REG_S : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS=>'0');
	SIGNAL FILA : INTEGER RANGE 0 TO 3 := 0;
	SIGNAL IND_S : STD_LOGIC := '0';
	SIGNAL EDO : INTEGER RANGE 0 TO 1 := 0;
	SIGNAL FOCA : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
	SIGNAL DESPLAZA : STD_LOGIC := '0';
	BEGIN
		FILAS <= FILA_REG_S;
		--RETARDO 1 MS--
		PROCESS(CLK)
		BEGIN
			IF RISING_EDGE(CLK) THEN
				CONTA_1MS <= CONTA_1MS+1;
				BANDERA <= '0';
				IF CONTA_1MS = DELAY_1MS THEN
					CONTA_1MS <= 0;
					BANDERA <= '1';
				END IF;
			END IF;
		END PROCESS;
		----------------
		--RETARDO 10 MS--
		PROCESS(CLK)
		BEGIN
			IF RISING_EDGE(CLK) THEN
				CONTA_10MS <= CONTA_10MS+1;
				BANDERA2 <= '0';
				IF CONTA_10MS = DELAY_10MS THEN
					CONTA_10MS <= 0;
					BANDERA2 <= '1';
				END IF;
			END IF;
		END PROCESS;
		----------------
		--PROCESO EN LAS FILAS ----
		PROCESS(CLK, BANDERA2)
		BEGIN
			IF RISING_EDGE(CLK) AND BANDERA2 = '1' THEN
				FILA <= FILA+1;
				IF FILA = 3 THEN
					FILA <= 0;
				END IF;
			END IF;
		END PROCESS;
		WITH FILA SELECT
			FILA_REG_S <= 	"1000" WHEN 0,
								"0100" WHEN 1,
								"0010" WHEN 2,
								"0001" WHEN OTHERS;
		-------------------------------
		----------PROCESO EN EL TECLADO AL SELECCIONAR UN VALOR------------
		PROCESS(CLK,BANDERA)
		BEGIN
			IF RISING_EDGE(CLK) AND BANDERA = '1' THEN
				IF FILA_REG_S = "1000" THEN
					BOT_1 <= BOT_1(6 DOWNTO 0)&COLUMNAS(3);
					BOT_2 <= BOT_2(6 DOWNTO 0)&COLUMNAS(2);
					BOT_3 <= BOT_3(6 DOWNTO 0)&COLUMNAS(1);
					BOT_A <= BOT_A(6 DOWNTO 0)&COLUMNAS(0);
				ELSIF FILA_REG_S = "0100" THEN
					BOT_4 <= BOT_4(6 DOWNTO 0)&COLUMNAS(3);
					BOT_5 <= BOT_5(6 DOWNTO 0)&COLUMNAS(2);
					BOT_6 <= BOT_6(6 DOWNTO 0)&COLUMNAS(1);
					BOT_B <= BOT_B(6 DOWNTO 0)&COLUMNAS(0);
				ELSIF FILA_REG_S = "0010" THEN
					BOT_7 <= BOT_7(6 DOWNTO 0)&COLUMNAS(3);
					BOT_8 <= BOT_8(6 DOWNTO 0)&COLUMNAS(2);
					BOT_9 <= BOT_9(6 DOWNTO 0)&COLUMNAS(1);
					BOT_C <= BOT_C(6 DOWNTO 0)&COLUMNAS(0);
				ELSIF FILA_REG_S = "0001" THEN
					BOT_AS <= BOT_AS(6 DOWNTO 0)&COLUMNAS(3);
					BOT_0 <= BOT_0(6 DOWNTO 0)&COLUMNAS(2);
					BOT_GA <= BOT_GA(6 DOWNTO 0)&COLUMNAS(1);
					BOT_D <= BOT_D(6 DOWNTO 0)&COLUMNAS(0);
				END IF;
			END IF;
		END PROCESS;
		----------------------------------------------------------------------------
		--SALIDA--
		PROCESS(CLK)
		--variable DESPLAZA : integer range 0 to 6 := 0;
		BEGIN
			IF RISING_EDGE(CLK) THEN
				IF BOT_0 = "11111111" THEN 
					BOTON_PRES <= X"0"; 
					FOCA <= "10000";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_1 = "11111111" THEN 
					BOTON_PRES <= X"1"; 
					FOCA <= "00001";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_2 = "11111111" THEN 
					BOTON_PRES <= X"2"; 
					FOCA <= "00010";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_3 = "11111111" THEN 
					BOTON_PRES <= X"3"; 
					FOCA <= "00011";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_4 = "11111111" THEN 
					BOTON_PRES <= X"4"; 
					FOCA <= "00100";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_5 = "11111111" THEN 
					BOTON_PRES <= X"5"; 
					FOCA <= "00101";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_6 = "11111111" THEN 
					BOTON_PRES <= X"6"; 
					FOCA <= "00110";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_7 = "11111111" THEN 
					BOTON_PRES <= X"7"; 
					FOCA <= "00111";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_8 = "11111111" THEN 
					BOTON_PRES <= X"8"; 
					FOCA <= "01000";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_9 = "11111111" THEN 
					BOTON_PRES <= X"9"; 
					FOCA <= "01001";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_A = "11111111" THEN 
					BOTON_PRES <= X"A"; 
					FOCA <= "01010";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_B = "11111111" THEN 
					BOTON_PRES <= X"B"; 
					FOCA <= "01011";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_C = "11111111" THEN 
					BOTON_PRES <= X"C"; 
					FOCA <= "01100";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_D = "11111111" THEN 
					BOTON_PRES <= X"D"; 
					FOCA <= "01101";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_AS = "11111111" THEN 
					BOTON_PRES <= X"E"; 
					FOCA <= "01110";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSIF BOT_GA = "11111111" THEN 
					BOTON_PRES <= X"F"; 
					FOCA <= "01111";
					DESPLAZA <= '1';
					IND_S <= '1';
				ELSE 
					IND_S <= '0';
					DESPLAZA <= '0';
				END IF;
			END IF;
		END PROCESS;
		
		WITH FOCA SELECT 
		 FANTASMA<=  "1000000" WHEN "10000",-- 0  
						 "1111001" WHEN "00001",-- 1
						 "0100100" WHEN "00010",-- 2
						 "0110000" WHEN "00011",-- 3
						 "0011001" WHEN "00100",-- 4
						 "0010010" WHEN "00101",-- 5
						 "0000010" WHEN "00110",-- 6
						 "0111000" WHEN "00111",-- 7
						 "0000000" WHEN "01000",-- 8
						 "0011000" WHEN "01001",-- 9
						 "0001000" WHEN "01010",-- A
						 "0000011" WHEN "01011",-- B
						 "1000110" WHEN "01100",-- C
						 "0100001" WHEN "01101",-- D
						 "0011100" WHEN "01110",-- *
						 "0001001" WHEN "01111",-- #
						 "1111111" WHEN OTHERS;
		-----------------------------		
		
		PROCESS(DESPLAZA)
		BEGIN
			IF DESPLAZA = '1' THEN
				D0 <= FANTASMA;
			END IF;
		END PROCESS;

		PROCESS(DESPLAZA)
		BEGIN
			IF DESPLAZA = '1' THEN
				D1 <= D0;
			END IF;
		END PROCESS;	

		PROCESS(DESPLAZA)
		BEGIN
			IF DESPLAZA = '1' THEN
				D2 <= D1;
			END IF;
		END PROCESS;

		PROCESS(DESPLAZA)
		BEGIN
			IF DESPLAZA = '1' THEN
				D3 <= D2;
			END IF;
		END PROCESS;
		
		PROCESS(DESPLAZA)
		BEGIN
			IF DESPLAZA = '1' THEN
				D4 <= D3;
			END IF;
		END PROCESS;
		
		PROCESS(DESPLAZA)
		BEGIN
			IF DESPLAZA = '1' THEN
				D5 <= D4;
			END IF;
		END PROCESS;

		--- Se activa cuando se ingresa la pass
		PROCESS(CLK)--159DA*
		BEGIN
			IF D5 = "1111001" AND D4 = "0010010" AND D3 = "0011000" AND D2 = "0100001" AND D1 = "0001000" AND D0 = "0011100" THEN
				PASS <= '1';
				stop_motor <= '1';
			ELSE
				PASS <= '0';
				stop_motor <= '0';
			END IF;
		END PROCESS;
		
		--ACTIVACIÓN PARA LA BANDERA UN CICLO DE RELOJ--
		PROCESS(CLK)
		BEGIN
			IF RISING_EDGE(CLK) THEN
				IF EDO = 0 THEN
					IF IND_S = '1' THEN
						IND <= '1';
						EDO <= 1;
					ELSE
						EDO <= 0;
						IND <= '0';
					END IF;
				ELSE
					IF IND_S = '1' THEN
						EDO <= 1;
						IND <= '0';
					ELSE
						EDO <= 0;
					END IF;
				END IF;
			END IF;
		END PROCESS;
	--------------------------------------
END behavioral;