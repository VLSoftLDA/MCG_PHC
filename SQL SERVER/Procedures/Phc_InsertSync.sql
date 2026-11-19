SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Phc_InsertSync]
	@Stamp			VARCHAR(25),
	@Database		VARCHAR(50),
	@Utilizador		VARCHAR(50),
	@Tabela			VARCHAR(25),
	@Servico		VARCHAR(50),
	@Id1			VARCHAR(Max),
	@Id2			VARCHAR(Max),
	@Id3			VARCHAR(Max),
	@Type			VARCHAR(25),
	@Message		VARCHAR(Max),
	@Header			VARCHAR(Max)

AS 
BEGIN 
     SET NOCOUNT ON 


     INSERT INTO dbo.u_SyncMw
		(                    
			Stamp, 
			BaseDados, 
			Servico, 
			id1, 
			id2,
			id3,
			type,
			message,
			header,
			tabela, 
			data, 
			datasync,
			utilizador,
			sync
		)
	VALUES 
		(
			@Stamp,
			@Database,
			@Servico,
			@Id1,
			@Id2,
			@Id3,
			@Type,
			@Message,
			@Header,
			@Tabela,
			GETDATE(),
			'19000101',
			@Utilizador,
			0
		);
	
	
END 
GO
