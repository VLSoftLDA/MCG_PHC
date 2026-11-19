SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.Fx_CheckClb_No (@UsClbNo as int , @ClbNoToCheck as int)RETURNS bitASBEGIN   if @UsClbNo = 0		Return 0	Declare @lResult as bit	Set @lResult = 0	Declare @cFindNo as int, @cFindStamp as char(25), @ClbStampToCheck as char(25)	Set @cFindNo = 0	Set @cFindStamp = ' '	WHILE 1=1	Begin		if @UsClbNo = @ClbNoToCheck			begin				set @lResult = 1				break			end		else			begin				Set @cFindStamp = (Select clbstamp1 from clb (nolock) where clb.no=@ClbNoToCheck)				if  (isnull(@cFindStamp,'') = '')					break				else					Set @ClbStampToCheck = (Select clbstamp from clb (nolock) where clb.no=@ClbNoToCheck)					if @cFindStamp = @ClbStampToCheck						begin							set @lResult = 0							break						end					else						begin							Set  @cFindNo = isnull((Select no from clb (nolock) where clb.clbstamp=@cFindStamp),0)							if (@cFindNo = @UsClbNo)								begin									set @lResult = 1									break								end							else								set @ClbNoToCheck = @cFindNo						end			end	End	Return @lResultEND
GO
