CREATE DATABASE case_acti;

use case_acti;

CREATE TABLE livro(
livro_id INT IDENTITY(1,1) CONSTRAINT pk_livro PRIMARY KEY ,
livro_titulo VARCHAR(60) NOT NULL,
livro_data_publicacao DATE NOT NULL,
livro_editora VARCHAR(70) NOT NULL,
livro_autor VARCHAR(70) NOT NULL
);

CREATE TABLE endereco(
endereco_id INT IDENTITY(1,1),
endereco_cep VARCHAR(8) NOT NULL,
endereco_numero INT NOT NULL,
endereco_rua VARCHAR(100) NOT NULL,
endereco_bairro VARCHAR(40) NOT NULL,
CONSTRAINT pk_endereco PRIMARY KEY (endereco_id) 
);

CREATE TABLE usuario(
usuario_id INT IDENTITY(1,1) CONSTRAINT pk_usuario PRIMARY KEY,
usuario_nome VARCHAR(70) NOT NULL,
usuario_cpf VARCHAR(11) NOT NULL,
data_associacao DATE NOT NULL,
endereco_id INT NOT NULL,
CONSTRAINT uk_usuario_cpf UNIQUE(usuario_cpf),
CONSTRAINT fk_endereco_usuario FOREIGN KEY (endereco_id) REFERENCES endereco(endereco_id)
);

CREATE TABLE emprestimo (
emprestimo_id INT IDENTITY(1,1) CONSTRAINT pk_emprestimo PRIMARY KEY,
emprestimo_data DATE NOT NULL,
data_efetiva_devolucao DATE NULL,
emprestimo_status VARCHAR(10) NOT NULL,
usuario_id INT NOT NULL,
CONSTRAINT ck_emprestimo_status CHECK(emprestimo_status in('ABERTO', 'ATRASADO', 'CONCLUIDO')),
CONSTRAINT fk_usuario_emprestimo FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
);

CREATE TABLE emprestimo_livro(
livro_id INT,
emprestimo_id INT,
CONSTRAINT fk_emprestimo_livro_livro FOREIGN KEY (livro_id) REFERENCES livro(livro_id),
CONSTRAINT fk_emprestimo_livro_emprestimo FOREIGN KEY (emprestimo_id) REFERENCES emprestimo (emprestimo_id),
CONSTRAINT pk_livro_emprestimo_composta PRIMARY KEY (livro_id, emprestimo_id)
);

GO

/*Procedures CRUD*/

/* Livro */
/*PROCEDURE INSERT */
CREATE PROCEDURE sp_livro_insert
	@livro_titulo VARCHAR(60),
	@data_publicacao DATE,
	@livro_editora VARCHAR(70),
	@livro_autor VARCHAR(70)
AS BEGIN
	INSERT INTO livro(livro_titulo, livro_data_publicacao, livro_editora, livro_autor) 
	VALUES(@livro_titulo, @data_publicacao, @livro_editora,@livro_autor);
END
GO

/* PROCEDURE UPDATE LIVRO */
CREATE PROCEDURE sp_livro_update(
	@livro_id INT,
	@livro_titulo VARCHAR(60),
	@data_publicacao DATE,
	@livro_editora VARCHAR(70),
	@livro_autor VARCHAR(70))
AS BEGIN
		UPDATE livro 
		SET livro_titulo = @livro_titulo,
			livro_data_publicacao = @data_publicacao,
			livro_editora = @livro_editora,
			livro_autor = @livro_autor
		WHERE livro_id = @livro_id;
END
GO

/* PROCEDURE DELETE LIVRO */
CREATE PROCEDURE sp_livro_delete(
	@livro_id INT)
AS BEGIN 
	DELETE FROM livro 
	WHERE livro_id = @livro_id;
END
GO

/* PROCEDURE SELECT LIVRO */
CREATE PROCEDURE sp_livro_select(
    @livro_id INT = NULL
)
AS
BEGIN
    SELECT livro_id,
           livro_titulo,
           livro_data_publicacao,
           livro_editora,
           livro_autor
    FROM livro
    WHERE @livro_id IS NULL OR livro_id = @livro_id;
END
GO


/* Usuário */
/* PROCEDURE INSERT USUARIO */
CREATE PROCEDURE sp_usuario_insert(
	@usuario_nome VARCHAR(70),
	@usuario_cpf VARCHAR(11),
	@data_associacao DATE,
	@endereco_id INT
)
AS BEGIN
	INSERT INTO usuario(usuario_nome, usuario_cpf, data_associacao, endereco_id) 
	VALUES (@usuario_nome, @usuario_cpf, @data_associacao, @endereco_id);
END
GO

/* PROCEDURE UPDATE USUARIO*/
CREATE PROCEDURE sp_usuario_update(
		@usuario_id INT,
		@usuario_nome VARCHAR(70),
		@usuario_cpf VARCHAR(11),
		@data_associacao DATE,
		@endereco_id INT)
AS BEGIN
		UPDATE usuario 
			SET usuario_nome = @usuario_nome,
				usuario_cpf = @usuario_cpf,
				data_associacao = @data_associacao,
				endereco_id = @endereco_id
			WHERE
				usuario_id = @usuario_id;
END
GO

/* PROCEDURE DELETE USUARIO */
CREATE PROCEDURE sp_usuario_delete(
		@usuario_id INT
)
AS BEGIN 
	DELETE FROM usuario 
	WHERE usuario_id = @usuario_id;
END
GO

/* PROCEDURE SELECT USUARIO */
CREATE PROCEDURE sp_usuario_select(
		@usuario_id INT = NULL
)
AS BEGIN 
	SELECT usuario_id,
           usuario_nome,
           usuario_cpf,
           data_associacao,
           endereco_id
	FROM usuario 
	WHERE @usuario_id IS NULL OR usuario_id = @usuario_id;
END 
GO


/* Emprestimo */
/* PROCEDURE INSERT EMPRESTIMO */
CREATE PROCEDURE sp_emprestimo_insert(
	@emprestimo_data DATE,
	@data_efetiva_devolucao DATE,
	@emprestimo_status VARCHAR(35),
	@usuario_id INT
)
AS BEGIN
	INSERT INTO emprestimo(emprestimo_data, data_efetiva_devolucao, emprestimo_status, usuario_id) 
	VALUES (@emprestimo_data, @data_efetiva_devolucao, @emprestimo_status, @usuario_id);
END
GO

/* PROCEDURE UPDATE EMPRESTIMO */
CREATE PROCEDURE sp_emprestimo_update(
	@emprestimo_id INT,
	@emprestimo_data DATE,
	@data_efetiva_devolucao DATE,
	@emprestimo_status VARCHAR(35),
	@usuario_id INT
)
AS BEGIN
		UPDATE emprestimo
			SET emprestimo_data = @emprestimo_data,
				data_efetiva_devolucao = @data_efetiva_devolucao,
				emprestimo_status = @emprestimo_status,
				usuario_id = @usuario_id
			WHERE
				emprestimo_id = @emprestimo_id;
END
GO

/* PROCEDURE DELETE EMPRESTIMO */
CREATE PROCEDURE sp_emprestimo_delete(
	@emprestimo_id INT
)
AS BEGIN
	DELETE FROM emprestimo 
	WHERE emprestimo_id = @emprestimo_id;
END
GO

/* PROCEDURE SELECT EMPRESTIMO */
CREATE PROCEDURE sp_emprestimo_select(
		@emprestimo_id INT = NULL
)
AS BEGIN
	SELECT emprestimo_id,
           emprestimo_data,
           data_efetiva_devolucao,
           emprestimo_status,
           usuario_id
	FROM emprestimo
	WHERE @emprestimo_id IS NULL OR emprestimo_id = @emprestimo_id;
END
GO


/* Endereço */
/* PROCEDURE INSERT ENDERECO */
CREATE PROCEDURE sp_endereco_insert(
	@endereco_cep VARCHAR(8),
	@endereco_numero INT,
	@endereco_rua VARCHAR(100),
	@endereco_bairro VARCHAR(40)
)
AS BEGIN
	INSERT INTO endereco(endereco_cep,endereco_numero, endereco_rua, endereco_bairro) 
	VALUES (@endereco_cep, @endereco_numero, @endereco_rua, @endereco_bairro);
END
GO

/* PROCEDURE UPDATE ENDERECO */
CREATE PROCEDURE sp_endereco_update(
	@endereco_id INT,
	@endereco_cep VARCHAR(8),
	@endereco_numero INT,
	@endereco_rua VARCHAR(100),
	@endereco_bairro VARCHAR(40)
)
AS BEGIN
	UPDATE endereco
		SET endereco_cep = @endereco_cep,
			endereco_numero = @endereco_numero,
			endereco_rua = @endereco_rua,
			endereco_bairro = @endereco_bairro
		WHERE 
		endereco_id = @endereco_id;
END
GO

/* PROCEDURE DELETE ENDERECO */
CREATE PROCEDURE sp_endereco_delete(
	@endereco_id INT
)	
AS BEGIN
	DELETE FROM endereco 
	WHERE endereco_id = @endereco_id;
END
GO

/* PROCEDURE SELECT ENDERECO */
CREATE PROCEDURE sp_endereco_select(
		@endereco_id INT = NULL
)
AS BEGIN
	SELECT endereco_id,
           endereco_cep,
           endereco_numero,
           endereco_rua,
           endereco_bairro
	FROM endereco
	WHERE @endereco_id IS NULL OR endereco_id = @endereco_id;
END
GO

/* Emprestimo_livro*/
/* PROCEDURE INSERT EMPRESTIMO_LIVRO */
CREATE PROCEDURE sp_emprestimo_livro_insert(
	@livro_id INT,
	@emprestimo_id INT
)
AS BEGIN
	INSERT INTO emprestimo_livro(livro_id, emprestimo_id) 
	VALUES (@livro_id, @emprestimo_id);
END
GO

/* PROCEDURE DELETE EMPRESTIMO_LIVRO */
CREATE PROCEDURE sp_emprestimo_livro_delete(
	@livro_id INT,
	@emprestimo_id INT
)
AS BEGIN
	DELETE FROM emprestimo_livro 
	WHERE livro_id = @livro_id 
	AND emprestimo_id = @emprestimo_id; 
END
GO

/* PROCEDURE SELECT EMPRESTIMO_LIVRO */
CREATE PROCEDURE sp_emprestimo_livro_select(
		@livro_id INT = NULL,
		@emprestimo_id INT = NULL 
)
AS BEGIN
	SELECT livro_id,
		   emprestimo_id 
	FROM emprestimo_livro
	WHERE(@livro_id IS NULL OR livro_id = @livro_id)
      AND (@emprestimo_id IS NULL OR emprestimo_id = @emprestimo_id);
END
GO
