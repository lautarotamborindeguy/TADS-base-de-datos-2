CREATE TABLE Funcionario (
    idFuncionario INTEGER PRIMARY KEY,
    nome VARCHAR(100),
    idade INTEGER
);

CREATE TABLE Planta (
    idPlanta INTEGER PRIMARY KEY,
    nome VARCHAR(100),
    luzDiaria DECIMAL(10,2),
    aguaDiaria DECIMAL(10,2)
);

CREATE TABLE Plantio (
    idPlantio INTEGER PRIMARY KEY,
    dataPlantio DATE,
    sementes DECIMAL(10,2),
    idPlanta INTEGER,
    idFuncionario INTEGER,
    idCanteiro INTEGER,
    FOREIGN KEY (idPlanta) REFERENCES Planta(idPlanta),
    FOREIGN KEY (idFuncionario) REFERENCES Funcionario(idFuncionario),
    FOREIGN KEY (idCanteiro) REFERENCES Canteiro(idCanteiro)
);

ALTER TABLE Funcionario
DROP COLUMN idade;

ALTER TABLE Funcionario
ADD dataNascimento DATE;

INSERT INTO Canteiro (idCanteiro, nome, luzDiaria, aguaDiaria)
VALUES (11, 'Canteiro 11', 8, 6);

INSERT INTO Plantio (
    idPlantio,
    dataPlantio,
    sementes,
    idPlanta,
    idFuncionario,
    idCanteiro
)
VALUES (1, '2026-08-19', 20, 1, 1, 1);

INSERT INTO Funcionario (idFuncionario, nome, dataNascimento)
VALUES (11, 'João Silva', '1995-05-20');

DELETE FROM Funcionario;

DELETE FROM Planta
WHERE aguaDiaria > 5;

UPDATE Canteiro
SET luzDiaria = 5;

UPDATE Canteiro
SET aguaDiaria = 10
WHERE aguaDiaria < 7;