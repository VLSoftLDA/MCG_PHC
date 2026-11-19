SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.Fx_CheckCve_Stamp (@UsClbStamp as char(25), @CveStampToCheck as char(25))RETURNS bitASBEGIN   if rtrim(@UsClbStamp) = ''		Return 0	Declare @lResult as bit	Set @lResult = 0	Declare @cFindClbStamp as char(25)	Set @cFindClbStamp = ' '	Set @cFindClbStamp = (Select clbstamp from clb (nolock) where clb.cvestamp=@CveStampToCheck)	if (isnull(@cFindClbStamp,'') = '')		Set @lResult = 1	else		Set @lResult = dbo.Fx_CheckClb_Stamp(@UsClbStamp,@cFindClbStamp)	Return @lResultEND
GO
