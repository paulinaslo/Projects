--Celem projektu jest stworzenie systemu bazodanowego do reprezentowania struktury geograficznej �wiata w formie hierarchicznej oraz 
--implementacja funkcji umo�liwiaj�cych manipulacj� tymi danymi.

INSERT INTO �wiat VALUES ('�wiat', '/'), ('Europa', '/1/'),('Afryka', '/2/'), 
('Niemcy', '/1/1/'), ('Grecja', '/1/2/'), ('Egipt', '/2/1/'), ('Kenia', '/2/2/'), 
('Berlin', '/1/1/1/'), ('Hamburg', '/1/1/2/'),('Ateny', '/1/2/1/'), ('Saloniki', '/1/2/2/'), ('Kair', '/2/1/1/'), ('Giza', '/2/1/2/'), ('Nairobi','/2/2/1/'), ('Mombasa', '/2/2/2/'),
('RosenstraBe', '/1/1/1/1/'),('Sperlingsgasse', '/1/1/1/2/'), ('Alterwall', '/1/1/2/1/'), ('Kratinou', '/1/2/1/1/'), ('Proxenon', '/1/2/2/1/'), ('AlFalki', '/2/1/1/1/'), ('Alaish', '/2/1/2/1/'), ('KundaSt','/2/2/1/1/'), (' Tanast', '/2/2/2/1/')

select * from �wiat


-- a) wy�wietli� ca�� jedn� (wybran�) ga��� drzewa (od �wiata do ulicy)
-- b) doda� nowy kraj
-- c) wy�wietli� nazw� kontynentu na kt�rym le�y miasto 'x'
-- d) wy�wietli� nazwy wszystkich kraj�w
-- e) sprawdzi� czy kraj 'x' le�y na kontynencie 'y'
-- f) czy 'x' oraz 'y' s� krajami
-- g) wy�wietli� wszystkie ulice miasta 'x'

-- a)

SELECT nazwa, poziom.ToString() AS Poziom
FROM �wiat
WHERE poziom >= '/1/' AND poziom <= '/1/1/1/1/'

-- b)

INSERT INTO �wiat (nazwa, poziom)
VALUES ('Hiszpania', '/1/3/')

-- c)

SELECT nazwa
FROM �wiat
WHERE poziom = (
    SELECT poziom.GetAncestor(2)
    FROM �wiat
    WHERE nazwa = 'x'
)

-- d)

SELECT DISTINCT nazwa
FROM �wiat
WHERE poziom.GetLevel() = 2

-- e)

DECLARE @kraj hierarchyid, @kontynent hierarchyid
SELECT @kraj = poziom FROM �wiat WHERE nazwa = 'x'
SELECT @kontynent = poziom FROM �wiat WHERE nazwa = 'y'

SELECT CASE WHEN @kraj.IsDescendantOf(@kontynent) = 1 THEN 'TAK' ELSE 'NIE' END AS czy_na_kontynencie

-- f)

SELECT DISTINCT nazwa
FROM �wiat
WHERE poziom.GetLevel() = 2 AND nazwa IN ('x', 'y')

-- je�li  x lub y jest krajem zostanie zwr�cona nazwa kraju

-- g)

SELECT nazwa FROM �wiat WHERE poziom.GetLevel() = 4 AND poziom.GetAncestor(1) = (SELECT poziom FROM �wiat WHERE nazwa = 'x')