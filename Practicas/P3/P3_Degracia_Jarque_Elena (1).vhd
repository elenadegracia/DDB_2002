--a)LATCH D i FLIP FLOP D-------------------------------------------------------------------------

ENTITY latch_D IS
PORT (D,Clk,Pre,clr: IN BIT; Q,NO_Q: OUT BIT);
END latch_D;

ENTITY FlipFlop_D IS
PORT (D,Clk,Pre,clr: IN BIT; Q,NO_Q: OUT BIT);
END FlipFlop_D;

---ifthen-----------------------------------------------------------------------------------------
ARCHITECTURE ifthen OF FlipFlop_D IS
SIGNAL qint:BIT;
BEGIN
PROCESS (D,Clk,Pre,clr)
BEGIN 
IF clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Pre='0' THEN qint<='1' AFTER 2 ns;
      ELSIF Clk'EVENT AND Clk='0' THEN
      qint <= D AFTER 2 ns;

END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

ARCHITECTURE ifthen OF latch_D IS
SIGNAL qint: BIT;
BEGIN
PROCESS (D,Clk,Pre,clr)
BEGIN
IF clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Pre = '0' THEN qint <='1' AFTER 2 ns;
      ELSIF Clk = '1' THEN qint <= D AFTER 2 ns;
END IF;
END PROCESS;
Q<= qint; NO_Q<= NOT qint;
END ifthen;

--b)LATCH JK I FLIP FLOP JK-----------------------------------------------------------------------

ENTITY latch_JK IS
PORT (J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END latch_JK;

ENTITY FlipFlop_JK IS
PORT (J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FlipFlop_JK;

--ifthen------------------------------------------------------------------------------------------
ARCHITECTURE ifthen OF latch_JK IS
SIGNAL qint: BIT;
BEGIN
PROCESS (J,K,Clk,Pre,Clr)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
ELSIF Pre='0' THEN qint<='1' AFTER 2 ns;
ELSIF Clk='1' THEN
			IF J='0' AND K='0' THEN qint<=qint AFTER 2 ns;
			ELSIF J='0' AND K='1' THEN qint<='0' AFTER 2 ns;
			ELSIF J='1' AND K='0' THEN qint<='1' AFTER 2 ns;
			ELSIF J='1' AND K='1' THEN qint<= NOT qint AFTER 2 ns;
			END IF;


END IF;

END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

ARCHITECTURE  ifthen OF FlipFlop_JK IS
SIGNAL qint: BIT;
BEGIN
PROCESS (J,K,Clk,Pre,Clr)
BEGIN
IF Clr = '0' THEN qint<='0' AFTER 2 ns;
ELSIF Pre = '0' THEN qint <='1' AFTER 2 ns;
ELSIF Clk ='1' THEN
        IF J = '0' AND K = '0' THEN qint <= qint AFTER 2 ns;
        ELSIF J ='1' AND K = '0' THEN qint<='1' AFTER 2 ns;
        ELSIF J = '0' AND K = '1' THEN qint <= '0' AFTER 2 ns;
        ELSIF J = '1' AND K = '1' THEN qint <= NOT qint AFTER 2 ns;
        END IF;
END IF;
END PROCESS;
Q <=qint; NO_Q<= NOT qint;
END ifthen;


--c)LATCH T I FLIPFLOP T--------------------------------------------------------------------------

ENTITY latch_T IS
PORT (T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END latch_T;

ENTITY FlipFlop_T IS
PORT (T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FlipFlop_T;

--ifthen------------------------------------------------------------------------------------------

ARCHITECTURE ifthen OF FlipFlop_T IS
SIGNAL qint:BIT;
BEGIN
PROCESS (T,Clk,Pre,clr)
BEGIN 
IF clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Pre='0' THEN qint<='1' AFTER 2 ns;
      ELSIF Clk'EVENT AND Clk='0' THEN
      qint <= T AFTER 2 ns;

END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

ARCHITECTURE ifthen OF latch_T IS
SIGNAL qint: BIT;
BEGIN
PROCESS (T,Clk,Pre,clr)
BEGIN
IF clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Pre = '0' THEN qint <='1' AFTER 2 ns;
      ELSIF Clk = '1' THEN
                IF T = '1' THEN qint <= NOT qint AFTER 2 ns;
                END IF; 
END IF;
END PROCESS;
Q<= qint; NO_Q<= NOT qint;
END ifthen;

--PREGUNTA 3--BANC DE PROVES----------------------------------------------------------------------

ENTITY bdp IS
END bdp;

ARCHITECTURE test OF bdp IS
COMPONENT la_latch_D IS
PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;
COMPONENT la_FlipFlop_D IS
PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;
COMPONENT la_latch_JK IS
PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;
COMPONENT la_FlipFlop_JK IS
PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;
COMPONENT la_FlipFlop_T IS
PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;
COMPONENT la_latch_T IS
PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;

SIGNAL ent1,ent2,clock,preset,clear,Dsort_Q,Dsort_noQ,JKsort_Q,JKsort_noQ,Tsort_Q,Tsort_noQ,
       DsortFF_Q,DsortFF_noQ,JKsortFF_Q,JKsortFF_noQ,TsortFF_Q,TsortFF_noQ: BIT;

FOR DUT: la_latch_D USE ENTITY WORK.latch_D(ifthen);
FOR DUT1: la_FlipFlop_D  USE ENTITY WORK.FlipFlop_D (ifthen);
FOR DUT2: la_latch_JK USE ENTITY WORK.latch_JK(ifthen);
FOR DUT3: la_FlipFlop_JK USE ENTITY WORK.FlipFlop_JK(ifthen);
FOR DUT4: la_latch_T USE ENTITY WORK.latch_T(ifthen);
FOR DUT5: la_FlipFlop_T USE ENTITY WORK.FlipFlop_T(ifthen);

BEGIN
DUT: la_latch_D PORT MAP (ent1,clock,preset,clear,Dsort_Q,Dsort_noQ);
DUT1: la_FlipFlop_D PORT MAP (ent1,clock,preset,clear,DsortFF_Q,DsortFF_noQ);
DUT2: la_latch_JK PORT MAP (ent1,ent2,clock,preset,clear,JKsort_Q,JKsort_noQ);
DUT3: la_FlipFlop_JK PORT MAP (ent1,ent2,clock,preset,clear,JKsortFF_Q,JKsortFF_noQ);
DUT4: la_latch_T PORT MAP (ent1,clock,preset,clear,Tsort_Q,Tsort_noQ);
DUT5: la_FlipFlop_T PORT MAP (ent1,clock,preset,clear,TsortFF_Q,TsortFF_noQ);

ent1 <= NOT ent1 AFTER 800 ns;
ent2 <= NOT ent2 AFTER 400 ns;
clock <= NOT clock AFTER 500 ns;
preset <= '0', '1' AFTER 600 ns;
clear <= '1','0' AFTER 200 ns, '1' AFTER 400 ns;

END test;


--PREGUNTA 4--------------------------------------------------------------------------------------

--La principal diferència entre el Flip-Flop i el Latch és que el Latch no necessita una senyal
--de rellotge per el seu funcionament i el Flip-Flop sí.
