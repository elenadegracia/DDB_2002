-- INVERSOR ----------------------------------------
ENTITY inv IS 
	PORT(a: IN BIT; z: OUT BIT);
END inv;


ARCHITECTURE logica_retard OF inv IS
BEGIN
	z <= NOT a AFTER 4 ns;
END logica_retard;


--AND2 -------------------------------------------
ENTITY and2 IS
	PORT(a, b: IN BIT; z: OUT BIT);
END and2;

ARCHITECTURE logica_retard OF and2 IS
BEGIN
	z <= a AND b  AFTER 4 ns;
END logica_retard;

--XOR2 -------------------------------------------
ENTITY xor2 IS
	PORT(a, b:IN BIT; z: OUT BIT);
END xor2;

ARCHITECTURE logica_retard OF xor2 IS
BEGIN
	z<= (NOT a AND b) OR (a AND NOT b) AFTER 4 ns;
END logica_retard;




-- Flip-Flop JK (flanc de pujada) ----------------------
ENTITY FlipFlipJK IS
PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FlipFlipJK;

ARCHITECTURE ifthen OF FlipFlipJK IS
SIGNAL qint: BIT;
BEGIN
PROCESS (J,K,Clk,Pre,Clr)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 4 ns;
ELSE
IF Pre='0' THEN qint<='1' AFTER 4 ns;
ELSE
		IF Clk='1' THEN
			IF J='0' AND K='0' THEN qint<=qint AFTER 4 ns;
			ELSIF J='0' AND K='1' THEN qint<='0' AFTER 4 ns;
			ELSIF J='1' AND K='0' THEN qint<='1' AFTER 4 ns;
			ELSIF J='1' AND K='1' THEN qint<= NOT qint AFTER 4 ns;
			END IF;

		END IF;
	END IF;
END IF;

END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;
-----------------------------------------------------------------------------------------------------------
--- Circuit ---

ENTITY circuit IS
PORT (clock, X: IN BIT; z2,z1,z0: OUT BIT);
END circuit;

ARCHITECTURE estructural OF circuit IS

COMPONENT portaand2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT portaxor2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT inversor IS
PORT(a: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT FFJK IS
PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;

SIGNAL sortxor, sortinv, sortand: BIT;
SIGNAL Q1,Q0,Q2: BIT;

FOR DUT1: inversor USE ENTITY WORK.inv(logica_retard);
FOR DUT2: portaand2 USE ENTITY WORK.and2(logica_retard);
FOR DUT3: portaxor2 USE ENTITY WORK.xor2(logica_retard);

FOR DUT4: FFJK USE ENTITY WORK.FlipFlop_JK(ifthen);
FOR DUT5: FFJK USE ENTITY WORK.FlipFlop_JK(ifthen);
FOR DUT6: FFJK USE ENTITY WORK.FlipFlop_JK(ifthen);

BEGIN

DUT1: inversor PORT MAP (sortxor, sortinv);
DUT2: portaand2 PORT MAP (sortinv, Q1, sortand);
DUT3: portaxor2 PORT MAP (X, Q0, sortxor);

DUT4: FFJK PORT MAP (sortand, sortand, clock, '1', Q2);
DUT5: FFJK PORT MAP (sortinv, sortinv, clock, '1',Q1);
DUT6: FFJK PORT MAP (X, '1', clock,'1', Q0);



END estructural;

ENTITY BancDeProves IS
END BancDeProves;

ARCHITECTURE test OF BancDeProves IS
COMPONENT circuit_prova IS
PORT (clock, X: IN BIT; z0,z1,z2: OUT BIT);
END COMPONENT;

SIGNAL clock,x,z0,z1,z2: BIT;

FOR DUT1: circuit_prova USE ENTITY WORK.circuit(estructural);

BEGIN
DUT1: circuit_prova PORT MAP (clock,x,z0,z1,z2);

clock <= NOT clock AFTER 100 ns;
x <= NOT x AFTER 50 ns;


END test;
