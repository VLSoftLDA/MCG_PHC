SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.Fx_CheckClb_Stamp (@UsClbStamp as char(25), @ClbStampToCheck as char(25))RETURNS bit  ASBEGIN   if rtrim(@UsClbStamp) = ''		Return 0	Declare @lResult as bit	Set @lResult = 0	Declare @cFindStamp as char(25)	Set @cFindStamp = ' '	WHILE 1=1	Begin		if @UsClbStamp = @ClbStampToCheck			begin				set @lResult = 1				break			end		else			begin				Set  @cFindStamp  =  (Select clbstamp1 from clb (nolock) where clb.clbstamp=@ClbStampToCheck)				if  (isnull(@cFindStamp,'') = '')					break				else					if @cFindStamp = @ClbStampToCheck						begin							set @lResult = 0							break						end					else						begin							if (@cFindStamp = @UsClbStamp)								begin									set @lResult = 1									break								end							else								set @ClbStampToCheck = @cFindStamp						end			end	End	Return @lResultEND
GO
