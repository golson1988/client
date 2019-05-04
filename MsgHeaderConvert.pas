unit MsgHeaderConvert;
 //为了减少流量 并且兼容以前的消息类型
interface
uses Grobal2;

procedure StateRetMsgToDef(Ret:pTStateMsg; DefMsg : pTDefaultMessage);
procedure DefMsg2ToDefMsg(DefMsg2:pTDefaultMessage2;DefMsg:pTDefaultMessage);

implementation

procedure StateRetMsgToDef(Ret:pTStateMsg; DefMsg : pTDefaultMessage);
begin
  FillChar(DefMsg^,DefaultMessageSize,0);
  DefMsg.Ident := Ret.wIdent;
  DefMsg.Recog:= Ret.Recog;
end;

procedure DefMsg2ToDefMsg(DefMsg2:pTDefaultMessage2;DefMsg:pTDefaultMessage);
begin
  DefMsg.Ident := DefMsg2.Ident;
  DefMsg.Recog := DefMsg2.Recog;
  DefMsg.Param := DefMsg2.Param;
  DefMsg.Tag := DefMsg2.Tag;
  DefMsg.Series := DefMsg2.Series;
  DefMsg.nSessionID := 0;
  DefMsg.nToken := 0;
  DefMsg.CRC := 0;
end;

end.
