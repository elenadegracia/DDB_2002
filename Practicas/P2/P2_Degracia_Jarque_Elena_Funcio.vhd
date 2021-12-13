--FUNCIO_2---------------------------------------------------------

ENTITY funcio_2 IS
PORT (a,b,c,d: IN BIT; f: OUT BIT);
END funcio_2;

--ARQUITECTURA LOGICA---------------------------------------------

ARCHITECTURE logica OF funcio_2 IS
BEGIN
f <= ((a AND c AND (a XOR d)) OR ((NOT b) AND c));
END logica;

--ARQUITECTURA ESTRUCTURAL----------------------------------------

ARCHITECTURE estructural OF funcio_2 IS
COMPONENT portainv IS
PORT (a : IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT portaand2 IS
PORT (a, b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT portaxor2 IS
PORT (a, b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT portaor2 IS
PORT (a, b: IN BIT; z: OUT BIT);
END COMPONENT;

SIGNAL inv_b,alpha,beta,alpha_and_beta,gama: BIT;

FOR DUT: portainv USE ENTITY WORK.inv (logicaretard);
FOR DUT1: portaand2 USE ENTITY work.and2 (logicaretard);
FOR DUT2: portaand2 USE ENTITY work.and2 (logicaretard);
FOR DUT3: portaand2 USE ENTITY work.and2 (logicaretard);
FOR DUT4: portaor2 USE ENTITY WORK.or2 (logicaretard);
FOR DUT5: portaxor2 USE ENTITY WORK.xor2 (logicaretard);

BEGIN
DUT: portainv PORT MAP (b,inv_b);
DUT1: portaand2 PORT MAP (a,c,alpha);
DUT2: portaand2 PORT MAP (inv_b,c,gama);
DUT5: portaxor2 PORT MAP (a,d,beta);
DUT3: portaand2 PORT MAP (alpha,beta,alpha_and_beta);
DUT4: portaor2 PORT MAP (alpha_and_beta,gama,f);
END estructural;

--BANC DE PROVES AMB ARQUITECTURA TEST-----------------------------
ENTITY banc_de_proves IS
END banc_de_proves;

ARCHITECTURE test OF banc_de_proves IS

COMPONENT bloc_funcio IS
PORT (a,b,c,d: IN BIT; f: OUT BIT);
END COMPONENT;

SIGNAL ent3,ent2,ent1,ent0,sort_logica,sort_estructural: BIT;

FOR DUT: bloc_funcio USE ENTITY WORK.funcio_2(logica);
FOR DUT1: bloc_funcio USE ENTITY WORK.funcio_2(estructural);

BEGIN

DUT: bloc_funcio PORT MAP(ent3,ent2,ent1,ent0, sort_logica);
DUT1: bloc_funcio PORT MAP(ent3,ent2,ent1,ent0,sort_estructural);

PROCESS (ent3, ent2, ent1, ent0)
		BEGIN
 			ent3 <= NOT ent3 AFTER 400 ns;
            		ent2 <= NOT ent2 AFTER 200 ns;
            		ent1 <= NOT ent1 AFTER 100 ns;
			ent0 <= NOT ent0 AFTER 50 ns;
	 END PROCESS;
END test;



---PREGUNTES A RESPODRE:

-- La funció te rebots ja que els calculs es fan, cada un, amb un interval de 3 ns, durant aquest moment, 
--la funcio esta rebent unes dades teoricament "incorrectes".

--Apartat c)


--Apartat d)
--Quan posem que variin les senyals d'entrada en 5 ns, no li donam temps a la funcio
--a que hi hagi un valor calculat practicament be (tot i que en la teoria, haurien de ser correctes).

