--------------------------------------------------------
--  Arquivo criado - terça-feira-agosto-08-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table ZELADOR
--------------------------------------------------------

  CREATE TABLE "KAY"."ZELADOR" 
   (	"CPF" VARCHAR2(11 BYTE), 
	"IDADE" NUMBER, 
	"NOME" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "USERS" ;
REM INSERTING into KAY.ZELADOR
SET DEFINE OFF;
--------------------------------------------------------
--  Constraints for Table ZELADOR
--------------------------------------------------------

  ALTER TABLE "KAY"."ZELADOR" ADD PRIMARY KEY ("CPF")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "USERS"  ENABLE;
