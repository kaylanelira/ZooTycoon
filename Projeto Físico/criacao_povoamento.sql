/* ================ CRIAÇÃO DAS TABELAS ================ */
CREATE TABLE ANIMAL(
    ID VARCHAR2(4) PRIMARY KEY,
    NOME VARCHAR2(80) NOT NULL,
    ESTADO_SAUDE VARCHAR2(80),
    DATA_NASC DATE,
    ID_MAE VARCHAR2(4),
    
    CONSTRAINT FK_FILHO_MAE FOREIGN KEY (ID_MAE) REFERENCES ANIMAL (ID)
)

CREATE TABLE TERRESTRE(
    ID VARCHAR(4)PRIMARY KEY,
    ALTURA NUMBER(4,2),
    TIPO_ABRIGO VARCHAR2(80),
    CONSTRAINT PK_TERRESTRE_ANIMAL FOREIGN KEY (ID) REFERENCES ANIMAL (ID)
)

CREATE TABLE AEREO(
    ID VARCHAR(4)PRIMARY KEY,
    ENVERGADURA NUMBER(3,2), 
    ALTURA_VOO NUMBER(4,2),
    
    CONSTRAINT PK_AEREO_ANIMAL FOREIGN KEY (ID) REFERENCES ANIMAL (ID)
)

CREATE TABLE AQUATICO(
    ID VARCHAR2(4) PRIMARY KEY,
    PROFUNDIDADE NUMBER(4,2),
    TAMANHO_PISCINA NUMBER(7,2),
    
    CONSTRAINT PK_AQUATICO_ANIMAL FOREIGN KEY (ID) REFERENCES ANIMAL (ID)
)

CREATE TABLE VETERINARIO(
    ID VARCHAR2(4) PRIMARY KEY,
    NOME VARCHAR2(80) NOT NULL,
    ESPECIALIZACAO VARCHAR2(80)
)

CREATE TABLE VETERINARIO_TELEFONE(
    TELEFONE VARCHAR2(11) PRIMARY KEY,
    ID VARCHAR2(4),
    
    CONSTRAINT FK_VET_TELEFONE FOREIGN KEY (ID) REFERENCES VETERINARIO (ID)
)

CREATE TABLE CONSULTA(
    ID_VET VARCHAR2(4),
    ID VARCHAR2(4),
    DATA DATE,
    DIAGNOSTICO VARCHAR2(255),
    PRESCRICAO VARCHAR2(255),
    
    CONSTRAINT FK_CONSULTA_VET FOREIGN KEY (ID_VET) REFERENCES VETERINARIO (ID),
    CONSTRAINT PK_CONSULTA PRIMARY KEY (ID_VET, ID)
)

CREATE TABLE ANIMAL_CONSULTA(
    ID_VET VARCHAR2(4),
    ID_CONSULTA VARCHAR2(4),
    ID_ANIMAL VARCHAR2(4),
    
    CONSTRAINT FK_CONSULTA FOREIGN KEY (ID_VET, ID_CONSULTA) REFERENCES CONSULTA (ID_VET, ID),
    CONSTRAINT PK_ANIMAL_CONSULTA PRIMARY KEY (ID_VET, ID_CONSULTA, ID_ANIMAL)
)

CREATE TABLE TRATADOR(
    ID VARCHAR2(4) PRIMARY KEY,
    NOME VARCHAR2(80),
    DATA_NASC DATE
)

CREATE TABLE TRATA(
    ID_TRATADOR VARCHAR2(4),
    ID_ANIMAL VARCHAR2(4),
    
    CONSTRAINT FK_TRATA_ANIMAL FOREIGN KEY (ID_ANIMAL) REFERENCES ANIMAL(ID),
    CONSTRAINT FK_TRATA_TRATADOR FOREIGN KEY (ID_TRATADOR) REFERENCES TRATADOR(ID),
    CONSTRAINT PK_TRATA PRIMARY KEY (ID_ANIMAL, ID_TRATADOR)
)
-- TODO: TORNAR A HERANÇA TOTAL

/* ================ POVOAMENTO DAS TABELAS ================ */
INSERT INTO ANIMAL VALUES ('1111', 'LOLA', 'SAUDAVEL', TO_DATE('20/02/2023', 'DD/MM/YYYY'), NULL);
INSERT INTO ANIMAL VALUES ('2222', 'LALA', 'DOENTE', TO_DATE('20/12/2023', 'DD/MM/YYYY'), '1111');
INSERT INTO ANIMAL VALUES ('3333', 'ORAC', 'DOENTE', TO_DATE('12/12/2020', 'DD/MM/YYYY'), NULL);
INSERT INTO TERRESTRE VALUES ('1111', 4.50, 'SUBTERRANEO');
INSERT INTO AEREO VALUES ('2222', 3.75, 40.89);
INSERT INTO AQUATICO VALUES ('3333', 30.00, 400.90);
INSERT INTO VETERINARIO VALUES ('4444','JOCICLEITON MARCOS', 'BALEIA');
INSERT INTO VETERINARIO_TELEFONE VALUES ('1234567890','4444');
INSERT INTO VETERINARIO_TELEFONE VALUES ('0987654321','4444');
INSERT INTO CONSULTA VALUES ('4444', '5555', TO_DATE('18/02/2021', 'DD/MM/YYYY'), 'INDEFINIDO', 'EXAME DE SANGUE');
INSERT INTO ANIMAL_CONSULTA VALUES ('4444', '5555', '1111');
INSERT INTO TRATADOR VALUES ('6666', 'YASMIM', TO_DATE('11/11/1111', 'DD/MM/YYYY'))
INSERT INTO TRATA VALUES ('6666', '2222')