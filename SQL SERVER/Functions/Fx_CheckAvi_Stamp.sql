SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.Fx_CheckAvi_Stamp (@UsClbStamp as char(25), @AviStampToCheck as char(25))RETURNS bitASBEGIN   if rtrim(@UsClbStamp) = ''		Return 0	Declare @lResult as bit	Set @lResult = 0	Declare @cFindAvlNo as int	Set @cFindAvlNo = 0	Set @cFindAvlNo = (Select avl.no from avi (nolock) inner join avl (nolock) on avi.avlstamp=avl.avlstamp where avi.avistamp=@AviStampToCheck)	if (isnull(@cFindAvlNo,-1) = -1)		Set @lResult = 0	else		Set @lResult = dbo.Fx_CheckClb_No(@UsClbStamp,@cFindAvlNo)	Return @lResultEND
GO
