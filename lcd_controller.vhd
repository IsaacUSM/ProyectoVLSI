LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY lcd_controller IS
	GENERIC(
		clk_freq : INTEGER := 50; --Frecuencia del reloj del sistema en MHz
		display_lines : STD_LOGIC:= '1';--Numero de lineas del display (0 = 1-linea, 1 = 2-lineas)
		character_font : STD_LOGIC := '0'; --Caracter (0 = 5x8 dots, 1 = 5x10 dots)
		display_on_off : STD_LOGIC := '1'; --Display on/off (0 = off, 1 = on)
		cursor : STD_LOGIC := '0'; --Cursor on/off (0 = off, 1 = on)
		blink : STD_LOGIC := '1'; --Intermitencia on/off (0 = off, 1 = on)
		inc_dec : STD_LOGIC := '1'; --Incrementar/decrementar (0 = decr, 1 = incr)
		shift : STD_LOGIC := '0'); --Desplazamiento on/off (0 = off, 1 = on)
	PORT(
		clk : IN STD_LOGIC; --Reloj del sistema
		reset_n : IN STD_LOGIC; --’0’ reinicia el sistema lcd
		lcd_enable : IN STD_LOGIC; -- Mantiene los dato en el controlador lcd
		lcd_bus : IN STD_LOGIC_VECTOR(9 DOWNTO 0); --señales de datos y control
		busy : OUT STD_LOGIC := '1'; --Ocupado/Espera controlador lcd
		rw, rs, e : OUT STD_LOGIC; --read/write, setup/data, y enable para el lcd
		lcd_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); --señales de datos lcd
END lcd_controller;
ARCHITECTURE controller OF lcd_controller IS
TYPE CONTROL IS(power_up, initialize, ready, send);
SIGNAL state : CONTROL;
BEGIN
	PROCESS(clk)
	VARIABLE clk_count : INTEGER := 0; --contador para temporización
	BEGIN
		IF(clk'EVENT and clk = '1') THEN
			CASE state IS
			--Esperar 50 ms para alimentacion segura Vdd y cumplir tiempo de espera del LCD
				WHEN power_up => busy <= '1';
					IF(clk_count < (50000 * clk_freq)) THEN --Esperar 50 ms
						clk_count := clk_count + 1;
						state <= power_up;
					ELSE --Alimentación completa y correcta
						clk_count := 0;
						rs <= '0';
						rw <= '0';
						lcd_data <= "00110000";
						state <= initialize;
					END IF;
			--Ciclo para la secuencia de inicializacion
				WHEN initialize => busy <= '1';
					clk_count := clk_count + 1;
					IF(clk_count < (10 * clk_freq)) THEN --function set
						lcd_data <= "0011" & display_lines & character_font & "00";
						e <= '1';
						state <= initialize;
					ELSIF(clk_count < (60 * clk_freq)) THEN --Esperar 50 us
						lcd_data <= "00000000";
						e <= '0';
						state <= initialize;
					ELSIF(clk_count < (70 * clk_freq)) THEN --display on/off control
						lcd_data <= "00001" & display_on_off & cursor & blink;
						e <= '1';
						state <= initialize;
					ELSIF(clk_count < (120 * clk_freq)) THEN --Esperar 50 us
						lcd_data <= "00000000";
						e <= '0';
						state <= initialize;
					ELSIF(clk_count < (130 * clk_freq)) THEN --display clear
						lcd_data <= "00000001";
						e <= '1';
						state <= initialize;
					ELSIF(clk_count < (2130 * clk_freq)) THEN --Esperar 2 ms
						lcd_data <= "00000000";
						e <= '0';
						state <= initialize;
					ELSIF(clk_count < (2140 * clk_freq)) THEN --entry mode set
						lcd_data <= "000001" & inc_dec & shift;
						e <= '1';
						state <= initialize;
					ELSIF(clk_count < (2200 * clk_freq)) THEN --Esperar 60 us
						lcd_data <= "00000000";
						e <= '0';
						state <= initialize;
					ELSE --Inicializacion completa
						clk_count := 0;
						busy <= '0';
						state <= ready;
					END IF;
				--Esperar la señal enable y entonces registrar la instruccion
				WHEN ready => IF(lcd_enable = '1') THEN busy <= '1';
					rs <= lcd_bus(9);
					rw <= lcd_bus(8);
					lcd_data <= lcd_bus(7 DOWNTO 0);
					clk_count := 0;
					state <= send;
				ELSE
					busy <= '0';
					rs <= '0';
					rw <= '0';
					lcd_data <= "00000000";
					clk_count := 0;
					state <= ready;
				END IF;
				--Eviar la instruccion al lcd
				WHEN send => busy <= '1';
					IF(clk_count < (50 * clk_freq)) THEN --Permanecer por 50us
						IF(clk_count < clk_freq) THEN --negative enable
							e <= '0';
						ELSIF(clk_count < (14 * clk_freq)) THEN --medio-ciclo positive de enable
							e <= '1';
						ELSIF(clk_count < (27 * clk_freq)) THEN --medio- ciclo negativo de enable
							e <= '0';
						END IF;
						clk_count := clk_count + 1;
						state <= send;
					ELSE
						clk_count := 0;
						state <= ready;
					END IF;
			END CASE;
			--reset
			IF(reset_n = '0') THEN
				state <= power_up;
			END IF;
		END IF;
	END PROCESS;
END controller;