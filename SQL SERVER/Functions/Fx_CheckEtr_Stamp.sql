SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.Fx_CheckEtr_Stamp (@UsClbStamp as char(25), @EtrStampToCheck as char(25))RETURNS bitASBEGIN   if rtrim(@UsClbStamp) = ''		Return 0	Declare @lResult as bit	Set @lResult = 0	Declare @cFindCveStamp as char(25)	Set @cFindCveStamp = ' '	Set @cFindCveStamp = (Select etr.cvestamp from etr (nolock) inner join cve (nolock) on etr.cvestamp=cve.cvestamp where etr.etrstamp=@EtrStampToCheck)	if (isnull(@cFindCveStamp,'') = '')		Set @lResult = 1	else		Set @lResult = dbo.Fx_CheckCve_Stamp(@UsClbStamp,@cFindCveStamp)	Return @lResultEND
GO
