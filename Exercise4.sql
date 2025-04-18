-- Zadanie 1 Napisz procedurę wypisującą do konsoli ciąg Fibonacciego. Procedura musi przyjmować jako
-- argument wejściowy liczbę n. Generowanie ciągu Fibonacciego musi zostać
-- zaimplementowane jako osobna funkcja, wywoływana przez procedurę. 

CREATE OR REPLACE FUNCTION generate_fibonacci(n INT)
RETURNS TABLE (fib_value BIGINT)
AS $$
DECLARE
    a BIGINT := 0;
    b BIGINT := 1;
    i INT := 1;
BEGIN
    WHILE i <= n LOOP
        fib_value := a;
        RETURN NEXT;

        a := a + b;
        b := a - b;
        i := i + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM generate_fibonacci(10);


-- Zadanie 2 Napisz trigger DML, który po wprowadzeniu danych do tabeli Persons zmodyfikuje nazwisko
-- tak, aby było napisane dużymi literami. 


CREATE OR REPLACE FUNCTION uppercase_lastname_function0()
RETURNS TRIGGER AS $$
BEGIN
    NEW.lastname := UPPER(NEW.lastname);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER uppercase_lastname_trigger0
BEFORE INSERT OR UPDATE ON person.person
FOR EACH ROW
EXECUTE FUNCTION uppercase_lastname_function0();

-- Zadanie 3 Przygotuj trigger ‘taxRateMonitoring’, który wyświetli komunikat o błędzie, jeżeli nastąpi
-- zmiana wartości w polu ‘TaxRate’ o więcej niż 30%. 

CREATE OR REPLACE FUNCTION taxRateMonitoring()		
RETURNS TRIGGER AS $$								
DECLARE												
    old_tax_rate numeric;							
    new_tax_rate numeric;							
    max_change_percent numeric := 30; 				
BEGIN												
    old_tax_rate := COALESCE(OLD.TaxRate, 0);		
    new_tax_rate := COALESCE(NEW.TaxRate, 0);		
    IF abs(new_tax_rate - old_tax_rate) / old_tax_rate * 100 > max_change_percent THEN 			
        RAISE EXCEPTION 'Zmiana wartości w polu TaxRate o więcej niż 30% !!!', NEW.TaxRate;		
    END IF;

    RETURN NEW;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER taxRateMonitoring			
BEFORE UPDATE ON sales.salestaxrate			
FOR EACH ROW								
EXECUTE FUNCTION taxRateMonitoring()