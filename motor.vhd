Library IEEE;
Use IEEE.Std_logic_1164.all;
Use IEEE.Std_logic_arith.all;
Use IEEE.Std_logic_unsigned.all;
Entity motor is
	Port (reloj, reset, stop, go: in std_logic;
			dato_motor: out std_logic_vector(3 downto 0));
End motor;
Architecture behavioral of motor is
	Component divisor is
	Port( reloj: in std_logic;
			div_reloj : out std_logic);
	end Component;
	Type state is (inicia, cero, uno, dos, tres, cuatro, cinco, seis, siete);
	Signal pr_state, nx_state : state;
	Signal reloj_1 : std_logic;
	SIGNAL cuenta : INTEGER RANGE 0 TO 4461 := 0;
	SIGNAL vueltas : INTEGER RANGE 0 TO 4 := 0;
	SIGNAL stop_motor : std_logic;
begin
	U1 : divisor Port map(reloj, reloj_1);
	Process (reset, reloj_1)
	Begin
		If (reset='0') then
			pr_state <= inicia;
		elsif reloj_1 ='1' and reloj_1'event then
			pr_state <= nx_state;
		End if;
	End Process;
	
	Process (reset, reloj_1, cuenta, vueltas, go)
	begin
		stop_motor <= '1';
		if go='1' then
			if reloj_1 ='1' and reloj_1'event then
				cuenta <= cuenta + 1;
				If cuenta = 4460 then
					cuenta <= 0;
					vueltas <= vueltas + 1;
				else
					If vueltas = 3 then
						vueltas <= 0;
						stop_motor <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	Process(pr_state, stop, nx_state)
	Begin
		Case pr_state is
		When inicia =>
			If stop='0' then
				nx_state <= inicia;
			else
				nx_state <= cero;
			End If;
		When cero =>
			If stop='0' then
				nx_state <= cero;
			else
				nx_state <= uno;
			End If;
		When uno =>
			If stop='0' then
				nx_state <= uno;
			else
				nx_state <= dos;
			End If;
		When dos =>
			If stop='0' then
				nx_state <= dos;
			else
				nx_state <= tres;
			End If;
		When tres =>
			If stop='0' then
				nx_state <= tres;
			else
				nx_state <= cuatro;
			End If;
		When cuatro =>
			If stop='0' then
				nx_state <= cuatro;
			else
				nx_state <= cinco;
			End If;
		When cinco =>
			If stop='0' then
				nx_state <= cinco;
			else
				nx_state <= seis;
			End If;
		When seis =>
			If stop='0' then
				nx_state <= seis;
			else
				nx_state <= siete;
			End If;
		When siete =>
			If stop='0' then
				nx_state <= siete;
			else
				nx_state <= inicia;
			End If;
		End Case;
	End Process;
	
	Process(pr_state)
	Begin
		Case pr_state is
		When inicia => 
			dato_motor <= "0000";
		When cero => 
			dato_motor <= "1000";
		When uno => 
			dato_motor <= "1100";
		When dos => 
			dato_motor <= "0100";
		When tres => 
			dato_motor <= "0110";
		When cuatro => 
			dato_motor <= "0010";
		When cinco => 
			dato_motor <= "0011";
		When seis => 
			dato_motor <= "0001";
		When siete => 
			dato_motor <= "1001";
		When others => 
			NULL;
		End Case;
	End Process;
End behavioral;