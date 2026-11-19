SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Phc_InsertLog]
	@Stamp			VARCHAR(25),
	@UserCode		VARCHAR(30),
	@Data			VARCHAR(30),
	@Hora			varchar(8),
    @Descricao      Varchar(250),
    @Tipo           Varchar(200),
    @UserNo         Numeric(6,0),
    @Origem         Varchar(30),
    @Texto          Text,
    @Ousrinis       Varchar(30),
    @Usrinis        Varchar(30), 
    @TabNom         Varchar(20), 
	@TabStamp   	Varchar(25),
	@NumReg			Numeric(10,0),
	@DeletedRows	TEXT,
	@InsertedRows	TEXT

AS 
BEGIN 
     SET NOCOUNT ON 


     INSERT INTO nlog
		(
        nlogstamp, usercode, data, hora, descricao, tipo, userno, origem, texto
        ,ousrinis, ousrdata, ousrhora, usrinis, usrdata, usrhora, tabnom
        ,tabstamp, numreg, deletedrows, insertedrows,datetimerow
        )
	VALUES 
		(
	        @Stamp,
	        @UserCode,
            getdate(),
            @Hora,
            @Descricao,
            @Tipo,
            @UserNo,
            @Origem,
            @Texto,
            @Ousrinis,
            getdate(),
            CONVERT(VARCHAR(8),getdate(),108),
            @Usrinis,
            getdate(),
            CONVERT(VARCHAR(8),getdate(),108),    
            @TabNom, 
            @TabStamp,
            @NumReg,
            @DeletedRows,
            @InsertedRows,
            getdate()
		);
	
	
END 
GO
