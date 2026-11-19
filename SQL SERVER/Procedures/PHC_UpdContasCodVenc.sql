SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_Update_CM6
	@cm6stamp       NVARCHAR(50),

	@debger         NVARCHAR(20),
	@debnor         NVARCHAR(20),
	@debpro         NVARCHAR(20),
	@deb1emp        NVARCHAR(20),
	@creger         NVARCHAR(20),
	@crenor         NVARCHAR(20),
	@crepro         NVARCHAR(20),
	@cre1emp        NVARCHAR(20),

	@divcc          BIT,

	@u_debger2      NVARCHAR(20),
	@u_debnor2      NVARCHAR(20),
	@u_creger2      NVARCHAR(20),
	@u_crenor2      NVARCHAR(20),
	@u_debger3      NVARCHAR(20),
	@u_debnor3      NVARCHAR(20),
	@u_creger3      NVARCHAR(20),
	@u_crenor3      NVARCHAR(20),

	@inactivo       BIT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE cm6
	SET
		debger      = @debger,
		debnor      = @debnor,
		debpro      = @debpro,
		deb1emp     = @deb1emp,
		creger      = @creger,
		crenor      = @crenor,
		crepro      = @crepro,
		cre1emp     = @cre1emp,
		divcc       = @divcc,
		u_debger2   = @u_debger2,
		u_debnor2   = @u_debnor2,
		u_creger2   = @u_creger2,
		u_crenor2   = @u_crenor2,
		u_debger3   = @u_debger3,
		u_debnor3   = @u_debnor3,
		u_creger3   = @u_creger3,
		u_crenor3   = @u_crenor3,
		inactivo    = @inactivo
	WHERE
		cm6stamp = @cm6stamp;
END
GO
