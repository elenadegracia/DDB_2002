--Elena Degràcia Jarque  01.12.2019

--ENTITATS NECESSARIES PER REALITXAR EL CIRCUIT------------------------------------------------------------
--Implementem les portes lògiques i la seva arquitectura perquè el sistema pugui funcionar.

--XOR2-----------------------------------------------------------------------------------------------------
ENTITY xor2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END xor2;

ARCHITECTURE logicaretard OF xor2 IS
BEGIN
    z <= a XOR b AFTER 4 ns;
END logicaretard;

--AND2-----------------------------------------------------------------------------------------------------
ENTITY and2 IS
PORT (a,b: IN BIT; z: OUT BIT);
END and2;


ARCHITECTURE logicaretard OF and2 IS
BEGIN
  z <= a AND b AFTER 4 ns;
END logicaretard;

--INVERSOR-------------------------------------------------------------------------------------------------
ENTITY inv IS
PORT (a: IN BIT; z: OUT BIT);
END inv;

ARCHITECTURE logicaretard OF inv IS
BEGIN 
   z <= (NOT a) AFTER 4 ns;
END logicaretard;

--FlipFlop JK----------------------------------------------------------------------------------------------
--Ha de ser de flanc de pujada 
ENTITY FF_JK IS
PORT (J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FF_JK;

ARCHITECTURE  ifthen OF FF_JK IS
SIGNAL qint: BIT;
BEGIN
PROCESS (J,K,Clk,Pre,Clr)
BEGIN
IF Clr = '0' THEN qint<='0' AFTER 2 ns;  ---te prioritat el clr
ELSIF Pre = '0' THEN qint <='1' AFTER 2 ns;
ELSIF Clk'EVENT AND Clk='1' THEN 	--flanc de pujada
        IF J = '0' AND K = '0' THEN qint <= qint AFTER 2 ns;
        ELSIF J ='1' AND K = '0' THEN qint<='1' AFTER 2 ns;
        ELSIF J = '0' AND K = '1' THEN qint <= '0' AFTER 2 ns;
        ELSIF J = '1' AND K = '1' THEN qint <= NOT qint AFTER 2 ns;
        END IF;
END IF;
END PROCESS;
Q <=qint; NO_Q<= NOT qint;
END ifthen;

--MAQUINA D'ESTATS-----------------------------------------------------------------------------------------
ENTITY maquina_estats IS
PORT(clock, x: IN BIT; z2,z1,z0: OUT BIT);
END maquina_estats;

ARCHITECTURE estructural OF maquina_estats IS
 
 --definim els components---------------------------------------------
COMPONENT portaxor2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT portaand2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END COMPONENT;
  
COMPONENT portaFF_JK IS
PORT(j, k, clk, pre, clr: IN BIT; q: OUT BIT);
END COMPONENT;

COMPONENT portainv IS
PORT (a: IN BIT; z: OUT BIT);
END COMPONENT;

--definim senyals interns------------------------------------------- 

SIGNAL q0,q1,q2,x_int,s_xor,xnor_int,and_int,clk: BIT;

FOR DUT: portaxor2 USE ENTITY WORK.xor2(logicaretard);
FOR DUT1: portainv USE ENTITY WORK.inv(logicaretard);
FOR DUT2: portaand2 USE ENTITY WORK.and2(logicaretard);
FOR DUT3: portaFF_JK USE ENTITY WORK.FF_JK(ifthen);
FOR DUT4: portaFF_JK USE ENTITY WORK.FF_JK(ifthen);
FOR DUT5: portaFF_JK USE ENTITY WORK.FF_JK(ifthen);
  
BEGIN
    
DUT: portaxor2 PORT MAP (x_int, q0, s_xor);
DUT1: portainv PORT MAP (s_xor, xnor_int);
DUT2: portaand2 PORT MAP (xnor_int, q1, and_int);
DUT3: portaFF_JK PORT MAP (and_int, and_int, clk, '1', '1',q2);
DUT4: portaFF_JK PORT MAP (xnor_int, xnor_int, clk, '1', '1', q1);
DUT5: portaFF_JK PORT MAP (x_int, '1', clk, '1', '1', q0);
    
    
z2 <= q2; 
z1 <= q1;
z0 <= q0;
END estructural;

--BANC DE PROVES-------------------------------------------------------------------------------------------

ENTITY bdp_maquina IS
END bdp_maquina;

ARCHITECTURE test OF bdp_maquina IS
  
COMPONENT maquina IS
PORT(clock, x: IN BIT; z2,z1,z0: OUT BIT);
END COMPONENT;
  
SIGNAL ent_clock, ent_x, s_z2, s_z1, s_z0: BIT;

FOR DUT1: maquina USE ENTITY WORK.maquina_estats(estructural);

BEGIN
    
DUT1: maquina PORT MAP(ent_clock, ent_x, s_z2, s_z1, s_z0);
      
          
ent_clock <= NOT ent_clock AFTER 100 ns;
ent_x <= NOT ent_x AFTER 50 ns;
         
    
END test;
    
