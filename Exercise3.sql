--ZADANIE 1


--a) Zmodyfikuj numer telefonu w tabeli pracownicy, dodając do niego kierunkowy dla 
--Polski w nawiasie (+48) 

UPDATE ksiegowosc.pracownicy
SET telefon = CONCAT('(+48) ', telefon)
WHERE telefon NOT LIKE '(+48)%';

--b) Zmodyfikuj atrybut telefon w tabeli pracownicy tak, aby numer oddzielony był
--myślnikami wg wzoru: ‘555-222-333’

UPDATE ksiegowosc.pracownicy
SET telefon = CONCAT(SUBSTRING(telefon, 1, 3), '-', SUBSTRING(telefon, 4, 3), '-', SUBSTRING(telefon, 7))
WHERE telefon IS NOT NULL;

--c) Używając dużych liter, wyświetl dane pracownika, którego nazwisko jest najdłuższe

SELECT *
FROM ksiegowosc.pracownicy
ORDER BY LENGTH(nazwisko) DESC
LIMIT 1;

--d) Wyświetl dane pracowników i ich pensje zakodowane przy pomocy algorytmu md5

SELECT
  ksiegowosc.pracownicy.imie,
  ksiegowosc.pracownicy.nazwisko,
  ksiegowosc.pracownicy.adres,
  ksiegowosc.pracownicy.telefon,
  MD5(CONCAT(ksiegowosc.pracownicy.imie, ksiegowosc.pracownicy.nazwisko, ksiegowosc.pracownicy.adres, ksiegowosc.pracownicy.telefon, CAST(ksiegowosc.pensja.kwota AS VARCHAR))) AS zakodowane_dane
FROM
  ksiegowosc.pracownicy
JOIN
  ksiegowosc.wynagrodzenia ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenia.id_pracownika
JOIN
  ksiegowosc.pensja ON ksiegowosc.wynagrodzenia.id_pensji = ksiegowosc.pensja.id_pensji;


--e) Wyświetl pracowników, ich pensje oraz premie. Wykorzystaj złączenie lewostronne.

SELECT p.imie, p.nazwisko, ksiegowosc.pensja.kwota AS pensja, ksiegowosc.premia.kwota AS premia
FROM ksiegowosc.pracownicy p
LEFT JOIN ksiegowosc.wynagrodzenia w ON p.id_pracownika = w.id_pracownika
LEFT JOIN ksiegowosc.premia ON w.id_premii = ksiegowosc.premia.id_premii
LEFT JOIN ksiegowosc.pensja  ON w.id_pensji = ksiegowosc.pensja.id_pensji

--f)Wygeneruj raport (zapytanie)

SELECT 
    'Pracownik ' || p.imie || ' ' || p.nazwisko || ', w dniu ' || w.data || 
    ' otrzymał pensję całkowitą na kwotę ' || (pp.kwota + COALESCE(pre.kwota, 0)) || ' zł, ' ||
    'gdzie wynagrodzenie zasadnicze wynosiło: ' || pp.kwota || ' zł, premia: ' || COALESCE(pre.kwota, 0) || ' zł' AS raport
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenia w ON p.id_pracownika = w.id_pracownika
LEFT JOIN ksiegowosc.premia pre ON w.id_premii = pre.id_premii
LEFT JOIN ksiegowosc.pensja pp ON w.id_pensji = pp.id_pensji;




--ZADANIE 2

-- Tabela 1: Pracownicy

CREATE TABLE Pracownicy (
    IDPracownika VARCHAR(10) PRIMARY KEY,
    NazwaLekarza VARCHAR(50) 
);

-- Tabela 2: Pacjenci

CREATE TABLE Pacjenci (
    IDPacjenta VARCHAR(10) PRIMARY KEY,
    NazwaPacjenta VARCHAR(50) 
);


-- Tabela 3: Wizyty

CREATE TABLE Wizyty (
    IDPracownika VARCHAR(10),
    IDPacjenta VARCHAR(10),
    DataGodzinaWizyty DATETIME  
);


-- Tabela 4: Zabiegi

CREATE TABLE Zabiegi (
    IDZabiegu VARCHAR(10) PRIMARY KEY,
    NazwaZabiegu VARCHAR(50) 
);

 ALTER TABLE Wizyty ADD FOREIGN KEY (IDPracownika) REFERENCES Pracownicy(IDPracownika),
 ALTER TABLE Wizyty ADD FOREIGN KEY (IDPacjenta) REFERENCES Pacjenci(IDPacjenta),
 ALTER TABLE Wizyty ADD FOREIGN KEY (IDZabiegu) REFERENCES Zabiegi(IDZabiegu)

------------------------------------------------------------------
-- Tabela 1: Dostawcy
CREATE TABLE Dostawcy (
    IDDostawcy INT PRIMARY KEY,
    NazwaDostawcy VARCHAR(255),
    AdresDostawcy VARCHAR(255)
);

-- Tabela 2: Produkty
CREATE TABLE Produkty (
    IDProduktu INT PRIMARY KEY,
    NazwaProduktu VARCHAR(255),
    Cena netto DECIMAL(10, 2)
    Cena brutto DECIMAL(10, 2)
);

-- Tabela 3: Zamówienia
CREATE TABLE Zamówienia (
   IDZamówienia INT PRIMARY KEY,
   IDProduktu INT,
   IDDostawcy INT
);
ALTER TABLE Zamówienia FOREIGN KEY (IDProduktu) REFERENCES Produkty(IDProduktu),
ALTER TABLE Zamówienia FOREIGN KEY (IDDostawcy) REFERENCES Dostawcy(IDDostawcy)
