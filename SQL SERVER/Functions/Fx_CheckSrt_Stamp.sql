SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.Fx_CheckSrt_Stamp (@UsClbStamp as char(25), @SrtStampToCheck as char(25))RETURNS bitASBEGIN   if rtrim(@UsClbStamp) = ''		Return 0	Declare @lResult as bit	Set @lResult = 0	Declare @cFindCveStamp as char(25)	Set @cFindCveStamp = ' '	Set @cFindCveStamp = (Select srt.cvestamp from srt (nolock) inner join cve (nolock) on srt.cvestamp=cve.cvestamp where srt.srtstamp=@SrtStampToCheck)	if (isnull(@cFindCveStamp,'') = '')		Set @lResult = 1	else		Set @lResult = dbo.Fx_CheckCve_Stamp(@UsClbStamp,@cFindCveStamp)	Return @lResultEND
GO
