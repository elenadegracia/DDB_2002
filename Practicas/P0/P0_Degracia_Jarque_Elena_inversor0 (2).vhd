--INVERSOR-----------------------------------------------------------------
--Es declara l'entitat---------------------
ENTITY inversor IS
PORT (a: IN BIT; f: OUT BIT);
END inversor;
--arquitectura (funcio que fa)--------------
ARCHITECTURE logica OF inversor IS
BEGIN
f<= not a;
END logica;
