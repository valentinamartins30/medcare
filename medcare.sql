create TABLE pacientes (
	id serial primary key,
	nome varchar (150) not null,
	email VARCHAR (100) unique not NULL,
	cpf VARCHAR(11) unique not null,
	data_nascimento VARCHAR (8) not null,
	data_cadastro timestamp default current_timestamp
)

create TABLE especilidades (
	id serial primary key,
	nome varchar (150) unique not null
)

create TABLE medicos (
	id serial primary key,
	nome varchar (150) not null,
	crm varchar(150) unique not null,
	valor_consulta numeric (10, 2) not null check (valor_consulta > 0)
)

CREATE TABLE consultas (
    id SERIAL PRIMARY KEY,
    medico_id INT NOT NULL,
    paciente_id INT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'agendada' CHECK (status IN ('agendada', 'realizada', 'cancelada')),

    CONSTRAINT fk_consultas_medicos FOREIGN KEY (medico_id) REFERENCES medicos(id),
    CONSTRAINT fk_consultas_pacientes FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);

CREATE TABLE exames_consulta (
    id SERIAL PRIMARY KEY,
    consulta_id INT NOT NULL,
    nome_exame VARCHAR(150) NOT NULL,
    valor_exame numeric (10, 2) not null check (valor_exame >= 0),
    CONSTRAINT fk_exames_consulta_id FOREIGN KEY (consulta_id) 
    REFERENCES consultas(id) ON DELETE CASCADE   
	);

INSERT INTO pacientes(id, nome, email, cpf, data_nascimento) VALUES
(1, 'Mirela', 'mimis@gmail.com', '00094125066', '30061982'),
(2, 'Mollie', 'mollie@gmail.com', '05235211030', '09062010'),
(3, 'Paulo', 'paulo@gmail.com', '92345089245', '17011981')

INSERT INTO especilidades(id, nome) VALUES
(1, 'Cardiologia')
(2, 'Dermatologia')
(3, 'Pediatria')

insert INTO medicos(id, nome, crm, valor_consulta) VALUES
(1, 'Valentina', '666777', 200.90)
(2, 'Isabella', '111222', 150.90),
(3, 'Madu', '888555', 120.50)

insert INTO consultas(id, medico_id, paciente_id, status, data_hora) VALUES
(1, 2, 2, 'agendada',  CURRENT_TIMESTAMP),
(2, 1, 3, 'realizada',  CURRENT_TIMESTAMP),
(3, 2, 1, 'cancelada',  CURRENT_TIMESTAMP),
(4, 3, 2, 'agendada', CURRENT_TIMESTAMP)

insert into exames_consulta(id, consulta_id, nome_exame, valor_exame) VALUES
(1,1,'Dermatoscopia', 200.00),
(2,2,'Ecocardiograma', 500.00),
(3,3,'Luz de Wood', 90.00),
(4,4,'Hemograma', 100.00)

ALTER TABLE medicos ADD COLUMN especialidade_id INT REFERENCES especilidades(id);
UPDATE medicos SET especialidade_id = 1 WHERE id = 1;
UPDATE medicos SET especialidade_id = 2 WHERE id = 2.;
UPDATE medicos SET especialidade_id = 3 WHERE id = 3;

SELECT 
    m.nome AS medico,
    m.crm,
    e.nome AS especilidade,
    m.valor_consulta
FROM 
    medicos m
JOIN 
    especilidades e ON m.especialidade_id = e.id
ORDER BY 
    m.valor_consulta DESC;

INSERT INTO pacientes(id, nome, email, cpf, data_nascimento) VALUES
(4, 'Carlos Silva', 'carlao@gmail.com', '90876534528', '10022008')

insert INTO consultas(id, medico_id, paciente_id, status, data_hora) VALUES
(5, 3, 4, 'realizada',  CURRENT_TIMESTAMP)

SELECT 
    c.id AS id_consulta,
    c.data_hora,
    m.nome AS nome_medico,
    e.nome AS especialidade,
    c.status
FROM 
    consultas c
JOIN 
    pacientes p ON c.paciente_id = p.id
JOIN 
    medicos m ON c.medico_id = m.id
JOIN 
    especilidades e ON m.especialidade_id = e.id
WHERE 
    p.nome = 'Carlos Silva';

    SELECT 
    c.id AS id_consulta,
    p.nome AS nome_paciente,
    m.nome AS nome_medico,
    (m.valor_consulta + SUM(e.valor_exame)) AS valor_total
FROM 
    consultas c
JOIN 
    pacientes p ON c.paciente_id = p.id
JOIN 
    medicos m ON c.medico_id = m.id
JOIN 
    exames_consulta e ON e.consulta_id = c.id
GROUP BY 
    c.id, p.nome, m.nome, m.valor_consulta;

INSERT INTO especilidades(id, nome) VALUES
(4, 'Urologista')
insert INTO medicos(id, nome, crm, valor_consulta) VALUES
(5, 'Lucca', '999888', 490.50)

SELECT nome, valor_consulta
FROM medicos
WHERE valor_consulta > 300.00;


SELECT 
    e.nome AS especialidade,
    SUM(m.valor_consulta) AS total_faturado
FROM 
    consultas c
JOIN 
    medicos m ON c.medico_id = m.id
JOIN 
    especilidades e ON m.especialidade_id = e.id
WHERE 
    c.status = 'realizada'
GROUP BY 
    e.id, e.nome
ORDER BY 
    total_faturado DESC;
