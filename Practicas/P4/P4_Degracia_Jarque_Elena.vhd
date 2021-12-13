--Elena Degracia Jarque 24.11.2019

--Declarem les entitats que ens demana l'exercici
--MULTIPLEXOR 4a1------------------------------------------------------------------------------------

ENTITY mux4a1 IS
PORT ( a,b,c,d,sel1,sel0 : IN BIT; f: OUT BIT);
END mux4a1;

--FLIP FLOP D---------------------------------------------------------------------------------------

ENTITY FlipFlop_D IS
PORT (D,Clk,Pre: IN BIT; Q: OUT BIT);
END FlipFlop_D;

-- REGISTRE-----------------------------------------------------------------------------------------

ENTITY registre IS
PORT (a2,a1,a0,sel1,sel0: IN BIT; q2,q1,q0: OUT BIT);
END registre;

-- ARQUITECTURA IFTHEN------------------------------------------------------------------------------

ARCHITECTURE ifthen OF FlipFlop_D IS
SIGNAL qint:BIT;
BEGIN
PROCESS (D,Clk,Pre)
BEGIN 
IF Pre='0' THEN qint<='1' AFTER 2 ns;
      ELSIF Clk'EVENT AND Clk='1' THEN 
      qint <= D AFTER 2 ns;
-- flanc de pujada ja que la sortida es guarda quan el Clk varia de '0' a '1'
END IF;
END PROCESS;
Q<=qint; 
END ifthen;

-- Taula de la veritat de mux4a1

--     sel1 sell0   | f
--   -----------------------------
--      0     0     | a = 1
--      0     1     | b (mante la paraula)
--      1     0     | c (carrega en paral·lel)
--      1     1     | d (carrega en serie)

ARCHITECTURE ifthen OF mux4a1 IS
BEGIN
PROCESS (sel1,sel0,b,c,d)
BEGIN
IF sel1 = '0' THEN

        IF sel0 = '0' THEN f <= '1' AFTER 2 ns;
        ELSIF sel0 = '1' THEN f <= b AFTER 2 ns;
        END IF;
ELSIF sel1 = '1' THEN
        IF sel0 = '0' THEN f <= c AFTER 2 ns;
        ELSIF sel0 = '1' THEN f <= d AFTER 2 ns;
END IF;
END IF;
END PROCESS;
END ifthen;

-- ARQUITECTURA LOGICARETARD------------------------------------------------------------------------

ARCHITECTURE logicaretard OF mux4a1 IS
BEGIN
f <= (( a AND (NOT sel1) AND (NOT sel0)) OR ( b AND (NOT sel1) AND sel0) OR (c AND sel1 AND (NOT sel0))
      OR (d AND sel1 AND sel0)) AFTER 5 ns;
END logicaretard;

-- ARQUITECTURA ESTRUCTURAL REGISTRE----------------------------------------------------------------

ARCHITECTURE estructural OF registre IS
--posem els components de les entitats que hi haura al registre

COMPONENT el_FlipFlop_D IS
PORT (D,Clk,Pre: IN BIT; Q: OUT BIT);
END COMPONENT;

COMPONENT el_mux4a1 IS
PORT (a,b,c,d,sel1,sel0: IN BIT; f: OUT BIT);
END COMPONENT;


SIGNAL a_ext,Clk,E,d2,d1,d0,q2_int,q1_int,q0_int: BIT;

FOR DUT: el_mux4a1 USE ENTITY WORK.mux4a1(ifthen);
FOR DUT1: el_mux4a1 USE ENTITY WORK.mux4a1(ifthen);
FOR DUT2: el_mux4a1 USE ENTITY WORK.mux4a1(ifthen);
FOR DUT3: el_FlipFlop_D USE ENTITY WORK.FlipFlop_D (ifthen);
FOR DUT4: el_FlipFlop_D USE ENTITY WORK.FlipFlop_D (ifthen);
FOR DUT5: el_FlipFlop_D USE ENTITY WORK.FlipFlop_D (ifthen);

BEGIN
DUT: el_mux4a1 PORT MAP (a2,a_ext,q2_int,E,sel1,sel0,d2);
DUT1: el_mux4a1 PORT MAP (a1,a_ext,q1_int,q2_int,sel1,sel0,d1);
DUT2: el_mux4a1 PORT MAP (a0,a_ext,q0_int,q1_int,sel1,sel0,d0);
DUT3: el_FlipFlop_D PORT MAP (d2,Clk,'1',q2_int);
DUT4: el_FlipFlop_D PORT MAP (d1,Clk,'1',q1_int);
DUT5: el_FlipFlop_D PORT MAP (d0,Clk,'1',q0_int);

Q2 <= q2_int; Q1 <= q1_int; Q0 <= q0_int;
END estructural;

-- BANC DE PPROVES----------------------------------------------------------------------------------

ENTITY bdp IS
END bdp;

ARCHITECTURE test OF bdp IS

COMPONENT el_FlipFlop_D IS
PORT (D,Clk,Pre: IN BIT; Q: OUT BIT);
END COMPONENT;

COMPONENT el_mux4a1 IS
PORT (a,b,c,d,sel1,sel0: IN BIT; f: OUT BIT);
END COMPONENT;

COMPONENT bloc_registre IS
PORT (a2,a1,a0,sel1,sel0: IN BIT; Q2,Q1,Q0: OUT BIT);
END COMPONENT;

SIGNAL ent2,ent1,ent0,Clock, ent,sel_1,sel_0,sort2,sort1,sort0: BIT;

FOR DUT: bloc_registre USE ENTITY WORK.registre (estructural);

BEGIN
DUT: bloc_registre PORT MAP(ent2,ent1,ent0,sel_1,sel_0,sort2,sort1,sort0);

PROCESS (ent2,ent1,ent0,Clock, ent,sel_1,sel_0)
BEGIN 		
            		ent2 <= NOT ent2 AFTER 1500 ns;
            		ent1 <= NOT ent1 AFTER 1000 ns;
            		ent0 <= NOT ent0 AFTER 500 ns;
			Clock <= NOT Clock AFTER 400 ns;
            		ent <= NOT ent AFTER 200 ns;
            		sel_1 <= NOT sel_1 AFTER 100 ns;
			sel_0 <= NOT sel_0 AFTER 50 ns ;
END PROCESS;

END test;
