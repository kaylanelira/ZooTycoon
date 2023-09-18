Seu projeto deve ter todos os tipos de consultas abaixo
-Group by/Having
-Junção interna
-Junção externa
-Semi junção
-Anti-junção
-Subconsulta do tipo escalar
-Subconsulta do tipo linha
-Subconsulta do tipo tabela
-Operação de conjunto

Atenção: Cada aluno deve fazer ao menos 01 dessas consultas mais 01 procedimento com SQL embutida e parâmetro, função com SQL embutida e parâmetro ou gatilho. 

/* Junção interna: Qual o nome do animal e o nome do 
    veterinário envolvidos na consulta na data 15/09? */
SELECT A.NOME AS NOME_ANIMAL, V.NOME AS NOME_VETERINARIO
FROM ANIMAL A INNER JOIN ANIMAL_CONSULTA AC ON A.ID = AC.ID_ANIMAL 
              INNER JOIN VETERINARIO V ON AC.ID_VET = V.ID
WHERE AC.DATA = TO_DATE('15/09/2023')

-- Junção interna: Quais animais estarão de exposição no dia X
SELECT A.NOME 
FROM ANIMAL A INNER JOIN EXPOE E ON A.ID = E.ID_ANIMAL
              INNER JOIN EXPOSICAO W ON E.ID_EXPO = W.ID
WHERE TO_CHAR(W.DATA_INICIO, 'DD') = 11;

/* Junção Externa: quais são os nomes dos visitantes 
    que visitaram a exposição com ID 5678? */
SELECT VISITANTE.NOME
FROM VISITANTE
LEFT JOIN VISITA ON VISITANTE.CPF = VISITA.CPF_VISITANTE
LEFT JOIN EXPOSICAO ON VISITA.ID_EXPO = EXPOSICAO.ID
WHERE EXPOSICAO.ID = '5678';

/* Group By/Having: Agrupar por nome de exposição, 
    os que terão mais de 5 visitantes */
SELECT E.NOME 
FROM EXPOSICAO E INNER JOIN VISITA A ON A.ID_EXPO = E.ID
GROUP BY E.NOME
HAVING COUNT(*) > 0;

/* Subconsulta Escalar: Quais animais aéreos tem altura 
    de voo maior que a média */
SELECT ID FROM AEREO 
WHERE ALTURA_VOO > (SELECT AVG(ALTURA_VOO) FROM AEREO);

/* Subconsulta Tabela: Quais os veterinarios que 
    realizam consulta no dia X */
SELECT V.NOME FROM VETERINARIO V
WHERE V.ID IN (SELECT ID_VET FROM CONSULTA 
                WHERE TO_CHAR(DATA,'DD') = 16);

/* Subconsulta linha: Saber nome das exposiões que vão se 
    acontecem entre os mesmos dias da exposição com o id 3456 */
SELECT NOME FROM EXPOSICAO
WHERE (DATA_INICIO, DATA_FIM) = 
                            (SELECT DATA_INICIO, DATA_FIM 
                             FROM EXPOSICAO 
                             WHERE ID = 3456);

/* Semi junção: Listar todos os animais 
    que participaram de exposições */
SELECT A.NOME FROM ANIMAL A
WHERE EXISTS (SELECT * FROM EXPOE E
              WHERE A.ID = E.ID_ANIMAL);

/* Anti Junção: Quais são os zeladores que não 
    trabalharam depois de DD/MM/YY */
SELECT NOME FROM ZELADOR
WHERE ID NOT IN (SELECT ID_ZELADOR FROM JAULA
                 WHERE DATA_MANUTENCAO > TO_DATE('14/03/21'));

-- Function: Para quantas consultas um animal de nome tal já foi?
CREATE OR REPLACE FUNCTION qtd_consultas_animal (NOME_ANIMAL VARCHAR2) RETURN NUMBER IS
    qtdC NUMBER;
BEGIN
    SELECT COUNT(*) INTO qtdC
    FROM ANIMAL_CONSULTA AC
    WHERE AC.ID_ANIMAL =
        (SELECT ID
         FROM ANIMAL
         WHERE NOME = NOME_ANIMAL);
         
    RETURN qtdC;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Quantidade de consultas: '||qtd_consultas_animal('LOLA'));
END;

-- Tabela e Gatilho: Registro de todas as visitas a exposição

CREATE TABLE HISTORICO_VISITAS_EXPOSICAO (
    CPF_VISITANTE VARCHAR(4), 
    ID_EXPOSICAO NUMBER,
    TEMPO_SISTEMA TIMESTAMP,

    CONSTRAINT FK_HISTORICO_VISITANTE FOREIGN KEY (CPF_VISITANTE) REFERENCES VISITANTE (CPF),
    CONSTRAINT FK_HISTORICO_EXPOSICAO FOREIGN KEY (ID_EXPOSICAO) REFERENCES EXPOSICAO (ID),
    CONSTRAINT PK_HISTORICO PRIMARY KEY (TEMPO_SISTEMA, CPF_VISITANTE, ID_EXPOSICAO)
);

CREATE OR REPLACE TRIGGER TRIGGER_INSERIR_HISTORICO
AFTER INSERT ON VISITA
FOR EACH ROW
BEGIN
    INSERT INTO HISTORICO_VISITAS_EXPOSICAO (CPF_VISITANTE, ID_EXPOSICAO, TEMPO_SISTEMA)
    VALUES (:NEW.CPF, :NEW.ID_EXPOSICAO, SYSTIMESTAMP);
END;
/

-- Quantidade de visitantes por exposicao
CREATE OR REPLACE PROCEDURE vis_exp(NOME_EXP VARCHAR)IS 
    QTD_VIS NUMBER;

BEGIN
     SELECT COUNT(*) INTO QTD_VIS
     FROM VISITA
     WHERE ID_EXPO = (SELECT ID FROM EXPOSICAO 
                WHERE NOME = NOME_EXP);
                
     DBMS_OUTPUT.PUT_LINE('Quantidade de visitantes no '||NOME_EXP|| ' foi de: '|| QTD_VIS);
END;
/

EXEC vis_exp('seaborn');

-- Lista nome de animais e id de todos excetos aquaticos.
SELECT NOME AS ANIMAL, ID ID_ANIMAL FROM ANIMAL 
WHERE ID IN (
    (SELECT ID FROM ANIMAL)
    EXCEPT
    (SELECT ID FROM AQUATICO)
);