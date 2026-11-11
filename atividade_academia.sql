IF DB_ID('Banco_Academia_daniel') IS NULL
BEGIN
    CREATE DATABASE Banco_Academia_daniel; --Criar banco de dados Banco_Academia
END;

USE Banco_Academia_daniel; --Selecionar banco de dados Banco_Academia

--comando para listar todos os bancos de dados existentes no servidor SQL Server
SELECT name AS NomeDoBanco
FROM sys.databases
ORDER BY name;

--comando para listar o banco de dados atual
SELECT DB_NAME() AS BancoAtual;

--Criando Tabelas Professores
IF OBJECT_ID(N'dbo.Professores', N'U') IS NULL
BEGIN
    CREATE TABLE Professores (
        IdProfessor INT PRIMARY KEY IDENTITY(1,1), --Identity para auto incrementar o IdProfessor
        Nome VARCHAR(100) NOT NULL,
        Email VARCHAR(100) NOT NULL UNIQUE, -- Unique para não permitir emails duplicados
        Especialidade VARCHAR(100) NOT NULL
    );
END;

    
IF OBJECT_ID(N'dbo.Cursos', N'U') IS NULL
BEGIN
    CREATE TABLE Cursos(
        IdCurso INT PRIMARY KEY IDENTITY(1,1), --Identity para auto incrementar o IdCurso
        NomeCurso VARCHAR(100) NOT NULL UNIQUE, -- Unique para não permitir cursos duplicados
        CargaHoraria INT NOT NULL CHECK (CargaHoraria > 0 AND CargaHoraria <= 200), -- Check para validar a carga horária
        IdProfessor INT NOT NULL,
        Ativo BIT NOT NULL DEFAULT 1, -- Default para definir o valor padrão como 1 (ativo)

        CONSTRAINT FK_Cursos_Professores --CONSTRAINT para criar a chave estrangeira
        FOREIGN KEY (IdProfessor) REFERENCES Professores(IdProfessor)  
    );
END;

IF OBJECT_ID(N'dbo.Alunos', N'U') IS NULL
BEGIN
    CREATE TABLE Alunos(
        IdAluno INT PRIMARY KEY IDENTITY(1,1), --Identity para auto incrementar o IdAluno
        Nome VARCHAR(100) NOT NULL,
        Email VARCHAR(100) NOT NULL UNIQUE, -- Unique para não permitir emails duplicados
        Turma VARCHAR(50) NOT NULL,
        DataNascimento DATE NOT NULL,
        Ativo BIT NOT NULL CONSTRAINT DF_Alunos_Ativo DEFAULT 1 -- Default para definir o valor padrão como 1 (ativo)
    );
END;

IF OBJECT_ID(N'dbo.Matriculas', N'U') IS NULL
BEGIN
    CREATE TABLE Matriculas(
        IdMatricula INT IDENTITY(1,1) PRIMARY KEY, --Identity para auto incrementar o IdMatricula
        IdAluno INT NOT NULL,
        IdCurso INT NOT NULL,
        DataMatricula DATE NOT NULL CONSTRAINT DF_Matriculas_Data DEFAULT (CONVERT(DATE, GETDATE())), -- Default para definir a data atual como valor padrão
        NotaFinal DECIMAL(4,2) NULL CHECK (NotaFinal BETWEEN 0 AND 10), -- Check para validar a nota final
        StatusMatricula VARCHAR(20) NOT NULL CONSTRAINT DF_Matriculas_Status DEFAULT 'Ativa', -- Default para definir o valor padrão como 'Ativa'

        CONSTRAINT UQ_Matriculas_AlunoCurso UNIQUE (IdAluno, IdCurso), -- Unique para não permitir que um aluno se matricule no mesmo curso mais de uma vez
        CONSTRAINT FK_Matriculas_Alunos -- CONSTRAINT para criar a chave estrangeira
            FOREIGN KEY (IdAluno) REFERENCES Alunos(IdAluno), -- CONSTRAINT para criar a chave estrangeira
        CONSTRAINT FK_Matriculas_Cursos  -- CONSTRAINT para criar a chave estrangeira
            FOREIGN KEY (IdCurso) REFERENCES Cursos(IdCurso) --Para criar a chave estrangeira, referenciando a tabela Cursos
    );
END;




INSERT INTO Professores (Nome, Email, Especialidade)
VALUES
('Ana Martins',     'ana.martins@academia.com',    'Banco de Dados'),
('Carlos Ribeiro',  'carlos.ribeiro@academia.com', 'Programação'),
('Fernanda Lima',   'fernanda.lima@academia.com',  'Desenvolvimento Web'),
('Rafael Souza',    'rafael.souza@academia.com',   'Redes de Computadores');


INSERT INTO Cursos (NomeCurso, CargaHoraria, IdProfessor)
VALUES
('Banco de Dados Inicial', 40, 1),
('SQL Server Essencial',   36, 1),
('Lógica de Programação',  40, 2),
('JavaScript para Jovens', 32, 2),
('HTML e CSS',             30, 3),
('Fundamentos de Redes',   24, 4);


INSERT INTO Aluno(Nome, Email, Turma, DataNascimento)
VALUES
('Alice Pereira',   'alice.pereira@escola.com',   '2INFO-A', '2008-03-14'),
('Bruno Alves',     'bruno.alves@escola.com',     '2INFO-A', '2008-07-22'),
('Camila Rocha',    'camila.rocha@escola.com',    '2INFO-A', '2008-01-30'),
('Diego Santos',    'diego.santos@escola.com',    '2INFO-B', '2007-11-09'),
('Elisa Nunes',     'elisa.nunes@escola.com',     '2INFO-B', '2008-05-18'),
('Felipe Costa',    'felipe.costa@escola.com',    '2INFO-B', '2008-09-02'),
('Gabriela Melo',   'gabriela.melo@escola.com',   '2INFO-C', '2007-12-12'),
('Henrique Luz',    'henrique.luz@escola.com',    '2INFO-C', '2008-06-28'),
('Isabela Torres',  'isabela.torres@escola.com',  '2INFO-C', '2008-02-06'),
('João Mendes',     'joao.mendes@escola.com',     '2INFO-C', '2007-08-25');




 INSERT INTO Matriculas (IdAluno, IdCurso, DataMatricula, NotaFinal, StatusMatricula)
 VALUES
    (1, 1, '2026-02-03', 8.50, 'Concluída'),
    (1, 5, '2026-02-03', 9.00, 'Concluída'),
    (2, 1, '2026-02-03', 7.00, 'Concluída'),
    (2, 3, '2026-02-04', 8.00, 'Ativa'),
    (3, 2, '2026-02-04', 9.50, 'Concluída'),
    (3, 4, '2026-02-04', NULL, 'Ativa'),
    (4, 3, '2026-02-05', 6.50, 'Concluída'),
    (5, 5, '2026-02-05', 8.50, 'Concluída'),
    (6, 6, '2026-02-06', NULL, 'Ativa'),
    (7, 1, '2026-02-06', 7.50, 'Concluída'),
    (8, 2, '2026-02-07', 10.00, 'Concluída'),
    (8, 6, '2026-02-07', 8.00, 'Concluída'),
    (9, 4, '2026-02-08', NULL, 'Ativa'),
    (9, 5, '2026-02-08', 9.00, 'Concluída'),
    (10, 3, '2026-02-09', 7.00, 'Concluída'),
    (10, 2, '2026-02-09', NULL, 'Ativa');



SELECT * FROM Professores;
SELECT * FROM Cursos;
SELECT * FROM Aluno;
SELECT * FROM Matriculas;

SELECT * FROM Professores;

--seleciona somente colunas especificas da tabela professores
SELECT nome, email from Professores;

--apelido para deixar o titulo mais claro na resposta
SELECT nome as nomedoaluno, turma as sala from alunos;

-- consulta por ordem alfabetica
SELECT nome, turma
from Aluno
ORDER BY nome asc: -- asc para ordem cresente (padrao) e desc para ordem decresente

-- os 5 primeiros registros de alunos cadastrados
SELECT top 5 nome, turma, datanascimento
from Alunos
ORDER BY nome;

SELECT * from alunos;


-- filtros com where
--whre filtrara as linhas. leia a consulta como uma frase: selecione os nomes e turmas dos alunos onde a turma seja igual a 2info-a

--igial a 
SELECT nome, turma
from aluno 
WHERE turma = '2info-a';

--diferente de 
SELECT nome, turma 
FROM aluno 
where turma <> '2info-a' -- ou seja, selecione os nomes e turmas dos alunos onde a turma seja diferente de '2info-a'

--and: as duas condições devem ser verdadeiros para que o registro seja retornado na consulta.
SELECT nome, turma, DataNascimento
from Aluno
where turma = '2info-a' and DataNascimento > '2008-01-01'; --ou seja, selecione os nomes, turmas e datas de nacimentos dos alunos onde a turma seja igual a '2info-1' e a data de nacimento seja maior que '2008-01-01'

-- or pelo menos uma condição deve ser verdadeiro
SELECT nome, turma
from alunos 
WHERE turma = '2info-a' or DataNascimento > '2008-01-01'; -- ou seja, selecione os nomes e turmas dos alunos onde a turma seja igual a '2info-a' ou a data de nascimento seja maior que '2008-01-01

--in: versão mais curta para variar valores
SELECT nome, turma
from Alunos
where turma in ('2info-a', '2info-b'); --ou seja, selecione os nomes e turmas dos alunos onde a turma seja igual a '2info-b'

--like: % significa "qualquer quantidade de caracter " e _ seignifica "qualquer caracter"
SELECT nome, email
from Aluno
where nome like '%es'; --ou seja, selecione os nomes e emails dos alunos onde o email termina com'@escola.com'



--atualizando dados com update
--update: atualiza os dados de uma tabela. a sintaxe basica e: UPDATE nome_da_tabela set Nome_da_coluna = novo_valor where condicao

--corrigir a turma de um aluno especifico
update Alunos
set turma = '2info-b'
where IdAluno = 3; -- altera a turma do aluno com idaluno igual a 3 para '2info-b

SELECT * from aluno

-- registrar uma nota e encerrar a matricula do aluno 2 no curso 3
UPDATE Matriculas
set NotaFinal = 8.75, StatusMatricula = 'concluida'
WHERE IdAluno = 2 and IdCurso = 3; -- alterra a nota final e o status da matricula do aluno com idaluno igual a 2 e idcurso igual a 3

SELECT * from aluno;
SELECT * from Matriculas;

--conferir a alteração da turma do aluno 3
SELECT * from Matriculas
where idaluno = 2 and idcurso = 3;

SELECT * from alunos;
--desativar alunos da turma 2info-b
UPDATE Alunos
set Ativo = 0 
WHERE turma = '2info-b';

SELECT * from Alunos;

--reativar alunos da turma 2info-b
SELECT * from alunos;
UPDATE Alunos
set Ativo = 1
WHERE turma = '2info-b';

-- excluindo registros com delete
INSERT into alunos (nome, email, turma, DataNascimento)
VALUES('aluno de teste', 'teste.remover@escola.com', '2info-a', '2008-01-01');


SELECT * from Alunos
WHERE email = 'teste.remove@escola.com';

delete from alunos 
where email = 'texte.remover@escola.com';


--funções de texto e data 

SELECT 
nome,
upper(nome) as nomeemMaisculo, -- converte o nome para maiusculo
LOWER(nome) as nomeemminusculo,-- converte o nome para minusculo
len(nome) as quantidadedecaracteres,--retorna a quantidade de caracteres do nome
concat(nome, '-', turma) as nomeEturma, -- concatena o nome e a turma 
FORMAT(datanascimento, 'dd/mm/yyyy') as datanascimentoformatada, --formata a data 
datediff(year, datanascimento, getdate()) as idadeaproximada -- calcula a idade do aluno 

from alunos;

--funções de calculos e agrupamento

--quantidade de alunos cadastrados
SELECT COUNT(*) as quantidadedealunos
from alunos;

--quantidade de matriculas que ja possuem nota final
SELECT COUNT(NotaFinal) as quantidadedematriculascomnota
from Matriculas;

--media, maior e menor nota, obs: dados nulos (null) não são considerados nos calculos
SELECT
  avg(notafinal) as mediadasnota, --media das notas
  max(notafinal) as maiornota, -- maior nota
  min(notafinal) as menornota --menor nota
  from Matriculas;

  --troca null por um texto para exibir o resultado de forma mais clara
  SELECT 
  idmatricula, ISNULL(CONVERT(varchar(10), notafinal), 'sem nota') as notafinal,
  statusmatricula
  from Matriculas;


-- group by e having: agrupa os registros por uma ou mais colunas e permite filtrar os grupos com base em uma condicao

--quntos alunos estão matriculados em cada turma
SELECT turma, count(*) as quantidadedealunos
from Alunos
group by turma
ORDER by quantidadedealunos desc; -- ordena o resultado pela quantidade de alunos em ordem decrecente

--cursos que tem duas ou mais matriculas
SELECT idcurso, COUNT(*) as quantidadedematriculas
from Matriculas
group by IdCurso
HAVING COUNT(*) >= 2 --filtra os cursos que tem duas ou mais matriculas 
ORDER by quantidadedematriculas desc; -- ordena o resultado pela quantidade de matriculas em ordem decrecente


--relacionando tabelas com join: permite combinar registros de duas ou mais tabelas com base em uma condicao de correspodencia


--inner join: retotna apenas os registros 
SELECT
   a.nome as nomedoaluno,
   c.NomeCurso as nomedocurso,
   m.STATUSmatricula,
   m.NotaFinal
FROM Matriculas as M
INNER JOIN alunos as A
   ON m.idaluno = a.idaluno -- relaciona a tabela matriculas com a tabela alunos
INNER JOIN cursos as C
   ON m.idcurso = c.idcurso -- relaciona a tabela matriculas com a tabela cursos
ORDER BY a.nome; -- ordena o resultado pelo nome do aluno

--join com 4 tabelas: retorna apenas os registros que tem correspodencia em todas as tabelas
SELECT 
  a.Nome as Aluno,
  a.turma,
  c.NomeCurso as curso,
  p.nome as professores,
  m.notafinal,
  m.STATUSmatricula
FROM Matriculas as M
INNER JOIN alunos as A
  ON m.idaluno = a.idaluno --relaciona a tabela matriculas com a tabela alunos
INNER JOIN Cursos as c
  ON m.idcurso = c.idcurso --relaciona a tabela matriculas com a tabela cursos
INNER JOIN Professores as p
  ON c.idprofessor = p.idprofessor --relaciona a tabela cursos com a tabela professores
ORDER BY p.nome, c.NomeCurso, a.nome; --ordena o resultado pelo nome do aluno



--left join: retorna todos os registros da tabela a esquerda e os registros correspondentes da tabela a direita.

SELECT
    a.Nome AS nomedoaluno,
    c.NomeCurso AS nomedocurso,
    m.NotaFinal,
    m.StatusMatricula
FROM Alunos AS a
LEFT JOIN Matriculas AS m
    ON a.IdAluno = m.IdAluno--relaciona a tabela alunos com a tabela matriculas
LEFT JOIN Cursos AS c
    ON m.IdCurso = c.IdCurso--relaciona a tabela matriculas com a tabela cursos
WHERE m.IdMatricula IS NULL;--filtra os alunos que não possuem matricula

--se a consulta não retornar linhas, significa que todos os alunos possuem matricula em apenas um curso.


--join com filtro e media por curso: retorna a media das notas finais por curso, considerando apenas os alunos que possuem matricula
SELECT
c.NomeCurso as curso,
COUNT(m.idmatricula) as totaldematricula,
avg(m.NotaFinal) as mediadocurso
from cursos as C
LEFT JOIN matriculas as m
on c.IdCurso = m.IdCurso--relaciona a tabela cursos coma a tabela matricula
WHERE m.NotaFinal is not NULL--filtra apenas as matriculas que possuem nota final
GROUP by c.NomeCurso--agrupa o resultado pelo nome do curso
ORDER by c.nomecurso;--ordena o resultado pelo nome do curso


--testando as restrições de forma segura
--estes exemplos devem apresentar erro. isso e bom: mostra que o banco esta protegenso os dados

--erro: o e-mail ja foi usado por alice
INSERT into Alunos (nome, Email, turma)
VALUES ('outra alice', 'alice.pereira@escola.com', '2info-a');

--erro: não existe aluno de id 999
INSERT into Matriculas (IdAluno, IdCurso, NotaFinal)
VALUES (999, 1,8.00);


--erro: a nota não pode ser maior que 10
update Matriculas
set notafinal = 12.00
WHERE idmatricula = 1;


SELECT table_name
FROM information_schema.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

