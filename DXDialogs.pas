unit DXDialogs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MShare, Share, DWinCtl, uTextures, Grobal2, HUtil32, AnsiHUtil32,
  EDcode, Generics.Collections, SoundUtil, OleCtrls, SHDocVw_EWB, EwbCore,
  EmbeddedWB, AbstractCanvas, AbstractTextures, AsphyreTypes, AsphyreUtils,
  ActiveX, Math, IntroScn, Common, StdCtrls, uTypes,WinInet;

type
  TDXEmbeddedWB = class(TEmbeddedWB)
  public
    procedure WMSetFocus(var WMessage: TMessage); message WM_SETFOCUS;
    procedure WMKillFocus(var WMessage: TMessage); message WM_KILLFOCUS;
  end;

  TFrmDXDialogs = class(TForm)
    DWBoxs: TDWindow;
    DBoxItem1: TDButton;
    DBoxItem2: TDButton;
    DBoxItem3: TDButton;
    DBoxItem4: TDButton;
    DBoxItem5: TDButton;
    DBoxItem6: TDButton;
    DBoxItem7: TDButton;
    DBoxItem8: TDButton;
    DBoxCtrl: TDButton;
    DContainer: TDWindow;
    DCloseContainer: TDButton;
    procedure DBoxCtrlDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBoxCtrlClick(Sender: TObject; X, Y: Integer);
    procedure DWBoxsDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DBoxItem1Click(Sender: TObject; X, Y: Integer);
    procedure DBoxItem1DirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBoxItem1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DWBoxsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DContainerDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCloseContainerClick(Sender: TObject; X, Y: Integer);
    procedure DCloseContainerDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure FormCreate(Sender: TObject);
    procedure DNewEditIDDirectPaint(Sender: TObject; DSurface: TAsphyreCanvas);
    procedure DNewLoginCloseClick(Sender: TObject; X, Y: Integer);
  private
    { Private declarations }
    nBoxStep: Byte;
    boBoxOpening, boBoxOpened: Boolean;
    myShuffleItems: array [0..7] of TClientItem;
    FBoxW, FBoxH: Integer;
    EmbWB: TEmbeddedWB;
    FUrl: String;
    procedure Shuffle(Value: Boolean);
    procedure GetBoxItem(ATag: Integer);
    procedure RandomSortShuffle;
    procedure DoUpdateUI(Sender: TObject; var Rezult: HRESULT);
  public
    { Public declarations }
    procedure Initialize;
    procedure CloseDialogs;
    procedure CloseTopMost;
    procedure ShowBox(StrItems: PPlatfromString);
    procedure Navigate(const AUrl: String; AWidth: Integer = 600; AHeight: Integer = 480);
    procedure RequestURL(AUrl: String);
  end;

  TMir3LoginScene = class(TCustomLoginScene) //归来
  private
    FFireIdx, FLightIdx: Integer;
    FFireTick: LongWord;
  public
    constructor Create; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure PlayScene(MSurface: TAsphyreCanvas); override;
    procedure PassWdFail; override;
  end;

  TMir4LoginScene = class(TCustomLoginScene) //最新客户端
  private
    FFireIdx, FLightIdx: Integer;
    FFireTick: LongWord;
  public
    constructor Create; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure ChangeLoginState(state: TLoginState); override;
    procedure PlayScene(MSurface: TAsphyreCanvas); override;
    procedure PassWdFail; override;
  end;
var
  FrmDXDialogs: TFrmDXDialogs;

implementation
  uses AsphyreTextureFonts, FState, CLMain, DrawScrn, DXHelper;

{$R *.dfm}

function WebPagePost(sURL, sPostData: string): Boolean;
const
  RequestMethod = 'POST';
  HTTP_VERSION = 'HTTP/1.1'; //HTTP版本 我抓包看过 HTTP/1.0 HTTP/1.1。尚未仔细了解其区别。按MSDN来写的。留空默认是1.0
var
 // dwSize:DWORD;
 // dwFileSize: Int64;
//  dwBytesRead,dwReserved:DWORD;
  hInte, hConnection, hRequest: HInternet;
//  ContentSize:array[1..1024] of Char;
  HostPort: Integer;
  HostName, FileName, sHeader: string;

  nErrorCode:Integer;
  procedure ParseURL(URL: string; var HostName, FileName: string; var HostPort: Integer);
  var
    i, p, k: Integer;
    function StrToIntDef(const S: string; Default: Integer): Integer;
    var
      E: Integer;
    begin
      Val(S, Result, E);
      if E <> 0 then Result := Default;
    end;
  begin
    if lstrcmpi('http://', PChar(Copy(URL, 1, 7))) = 0 then System.Delete(URL, 1, 7);
    HostName := URL;
    FileName := '/';
    HostPort := INTERNET_DEFAULT_HTTP_PORT;
    i := Pos('/', URL);
    if i <> 0 then
    begin
      HostName := Copy(URL, 1, i - 1);
      FileName := Copy(URL, i, Length(URL) - i + 1);
    end;
    p := pos(':', HostName);
    if p <> 0 then
    begin
      k := Length(HostName) - p;
      HostPort := StrToIntDef(Copy(HostName, p + 1, k), INTERNET_DEFAULT_HTTP_PORT);
      Delete(HostName, p, k + 1);
    end;
  end;
begin
  Result := False;
  Try
    //dwFileSize := 0;
    ParseURL(sURL, HostName, FileName, HostPort);
    // 函数原型见 http://technet.microsoft.com/zh-cn/subscriptions/aa385096(v=vs.85).aspx
    hInte := InternetOpen('', //UserAgent
      INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if hInte <> nil then
    begin
      //打开一个Http连接
      hConnection := InternetConnect(hInte, // 函数原型见 http://technet.microsoft.com/zh-cn/query/ms909418
        PChar(HostName),
        HostPort,
        nil,
        nil,
        INTERNET_SERVICE_HTTP,
        0,
        0);

      if hConnection <> nil then
      begin
        //创建一个HTTP请求
        hRequest := HttpOpenRequest(hConnection, // 函数原型见 http://msdn.microsoft.com/zh-cn/library/aa917871
          PChar(RequestMethod),
          PChar(FileName),
          HTTP_VERSION,
          '', //Referrer 来路
          nil, //AcceptTypes 接受的文件类型 TEXT/HTML */*
          INTERNET_FLAG_NO_CACHE_WRITE or
          INTERNET_FLAG_RELOAD,
          0);

        if hRequest <> nil then
        begin
          sHeader := 'Content-Type: application/x-www-form-urlencoded' + #13#10;
      //    +'CLIENT-IP: 216.13.23.33'+#13#10
      //    'X-FORWARDED-FOR: 216.13.23.33' + #13#10+; 伪造代理IP

          // 函数原型见 http://msdn.microsoft.com/zh-cn/library/aa384227(v=VS.85)
          //加入HTTP头
          HttpAddRequestHeaders(hRequest, PChar(sHeader),
            Length(sHeader),
            HTTP_ADDREQ_FLAG_ADD or HTTP_ADDREQ_FLAG_REPLACE);
          //发送HTTP请求
          // 函数原型见 http://msdn.microsoft.com/zh-cn/library/windows/desktop/aa384247(v=vs.85).aspx
          if HttpSendRequest(hRequest, nil, 0, PChar(sPostData), Length(sPostData)) then
          begin
            //dwReserved:=0;
           // dwSize:=SizeOf(ContentSize);
            // 函数原型 http://msdn.microsoft.com/zh-cn/subscriptions/downloads/aa384238.aspx
            //查询返回值
           { dwSize := SizeOf(dwFileSize);
            if HttpQueryInfo(hRequest,HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER,@dwFileSize,dwSize,dwReserved) and (dwFileSize >= 300) and (dwFileSize <> 500) then
            begin
              dwFileSize:=StrToInt(StrPas(@ContentSize));
              SetLength(Result,dwFileSize);
             // GetMem(Result, dwFileSize);
              InternetReadFile(hRequest,@Result[1],dwFileSize,dwBytesRead);
            end else  //我们只做单纯的POST 不接受返回值 李昀
            begin
            //  nErrorCode := GetLastError;
            end; }
            Result := True;
          end;

        end;
        InternetCloseHandle(hRequest);
      end;
      InternetCloseHandle(hConnection);
    end;
    InternetCloseHandle(hInte);
  except
  end;

end;

function URLEncode(const S: AnsiString): AnsiString;
var
  Idx: Integer; // loops thru characters in string
begin
  Result := '';
  for Idx := 1 to Length(S) do
  begin
    case S[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + S[Idx];
      ' ':
        Result := Result + '+'
    else
      Result := Result + '%' + SysUtils.IntToHex(Ord(S[Idx]), 2);
    end;
  end;
end;


procedure TFrmDXDialogs.CloseDialogs;
begin
  DWBoxs.Visible  :=  False;
  DContainer.Visible  :=  False;
end;

procedure TFrmDXDialogs.CloseTopMost;
begin
  EmbWB.Visible :=  False;
  EmbWB.Stop;
  DContainer.Visible :=  False;
end;

procedure TFrmDXDialogs.DBoxCtrlClick(Sender: TObject; X, Y: Integer);
begin
  case nBoxStep of
    0:
    begin
      Inc(nBoxStep);
      DBoxCtrl.TimeTick  :=  GetTickCount;
      Shuffle(True);
    end;
    1:
    begin
    end;
    2:
    begin
    end;
    3:
    begin
      DWBoxs.Visible  :=  False;
    end;
  end;
end;

procedure TFrmDXDialogs.DBoxCtrlDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  OffSet, TimeX: Integer;
begin
  OffSet  :=  0;
  with DBoxCtrl do
  begin
    if not (nBoxStep in [1, 2]) and Downed then
    begin
      d :=  Propertites.Images.Images[Propertites.ImageIndex + 1];
      OffSet  :=  1;
    end
    else
    begin
      d :=  Propertites.Images.Images[Propertites.ImageIndex];
      OffSet  :=  0;
    end;
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    case nBoxStep of
      0:
      begin
        TimeX :=  (GetTickCount - TimeTick) div 1000;
        if TimeX > 15 then
        begin
          Inc(nBoxStep);
          TimeTick  :=  GetTickCount;
          Shuffle(True);
        end
        else
        begin
          Caption :=  '洗牌(' + IntToStr(15 - TimeX + 1) + ')';
        end;
      end;
      1:
      begin
        Caption :=  '洗牌中...';
      end;
      2:
      begin
        TimeX :=  (GetTickCount - TimeTick) div 1000;
        if TimeX > 30 then
        begin
          TimeTick  :=  GetTickCount;
          System.Randomize;
          GetBoxItem(Random(8));
        end
        else
        begin
          Caption :=  '提取(' + IntToStr(30 - TimeX + 1) + ')';
        end;
      end;
      3:
      begin
        Caption :=  '关闭';
      end;
    end;
    D := FontManager.Default.TextOut(Caption);
    if D <> nil then
      dsurface.DrawBoldText(SurfaceX(Left) + OffSet + (Width - D.Width) div 2, SurfaceY(Top) + OffSet + (Height - D.Height) div 2, D, $0093F4F2, FontBorderColor);
  end;
end;

procedure TFrmDXDialogs.DBoxItem1Click(Sender: TObject; X, Y: Integer);
begin
  if boBoxOpened then
  begin
    GetBoxItem(TDButton(Sender).Tag);
    g_SoundManager.DXPlaySound(s_glass_button_click);
  end;
end;

procedure TFrmDXDialogs.DBoxItem1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with TDButton(Sender) do
  begin
    d :=  Propertites.Images.Images[Propertites.ImageIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    if nBoxStep in [0, 3] then
      DrawItem(myShuffleItems[Tag], dsurface, SurfaceX(Left), SurfaceY(Top), Width, Height, TimeTick);
  end;
end;

procedure TFrmDXDialogs.DBoxItem1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sel: Integer;
  Butt: TDButton;
  Temp: TClientItem;
begin
  if nBoxStep in [0,3] then
  begin
    Butt := TDButton(Sender);
    sel := Butt.Tag;
    if sel <> -1 then
    begin
      Temp  :=  myShuffleItems[sel];
      if Temp.Name <> '' then
      begin
        if (Temp.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
          DScreen.UpdateItemHintPostion(g_Application._CurPos)
        else
        begin
          g_MouseItem := Temp;
          DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
        end;
      end
      else
      begin
        g_MouseItem.Name := '';
        DScreen.ClearHint;
      end;
    end;
  end;
end;

procedure TFrmDXDialogs.DCloseContainerClick(Sender: TObject; X, Y: Integer);
begin
  EmbWB.Visible :=  False;
  EmbWB.Stop;
  DContainer.Visible :=  False;
end;

procedure TFrmDXDialogs.DCloseContainerDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
begin
  with DCloseContainer do
  begin
    if Downed then
      d := g_77Images.Images[53]
    else
      d := g_77Images.Images[52];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d);
  end;
end;

procedure TFrmDXDialogs.DContainerDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  T: TAsphyreLockableTexture;
begin
  with DContainer do
  begin
    D :=  g_77Images.Images[339];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    D :=  g_77Images.Images[340];
    if D <> nil then
      dsurface.HorFillDraw(SurfaceX(Left) + 94, SurfaceX(Left) + Width - 94, SurfaceY(Top), D);
    D :=  g_77Images.Images[341];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left) + Width - 94, SurfaceY(Top), D);

    D :=  g_77Images.Images[342];
    if D <> nil then
      dsurface.VerFillDraw(SurfaceX(Left), SurfaceY(Top) + 65, SurfaceY(Top) + Height - 26, D);
    D :=  g_77Images.Images[343];
    if D <> nil then
      dsurface.VerFillDraw(SurfaceX(Left) + Width - 17, SurfaceY(Top) + 65, SurfaceY(Top) + Height - 26, D);

    D :=  g_77Images.Images[344];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top) + Height - 22, D);
    D :=  g_77Images.Images[345];
    if D <> nil then
      dsurface.HorFillDraw(SurfaceX(Left) + 91, SurfaceX(Left) + Width - 92, SurfaceY(Top) + Height - 22, D);
    D :=  g_77Images.Images[346];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left) + Width - 92, SurfaceY(Top) + Height - 22, D);
    dsurface.FillRect(Rect(SurfaceX(Left) + 17, SurfaceY(Top) + 65, SurfaceX(Left) + Width - 17, SurfaceY(Top) + Height - 22), GetRGB(255));
    T :=  FontManager.Default.TextOut(Caption);
    if T <> nil then
      dsurface.DrawBoldText(SurfaceX(Left) + 36, SurfaceY(Top) + 42, T, $0093F4F2, FontBorderColor);
  end;
  if not EmbWB.Visible then
  begin
    EmbWB.Navigate(FUrl);
    EmbWB.Visible :=  True;
  end;
end;

procedure TFrmDXDialogs.DNewEditIDDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
  ARect: TRect;
begin
  with TDEdit(Sender) do
  begin
    ARect := Bounds(SurfaceX(Left) - 2, SurfaceY(Top) - 2, Width + 4, Height + 4);
    DSurface.FrameRect(ARect, cColor4(cColor1($004581AB)));
  end;
end;

procedure TFrmDXDialogs.DNewLoginCloseClick(Sender: TObject; X, Y: Integer);
begin
  FrmMain.Close;
end;


procedure TFrmDXDialogs.DoUpdateUI(Sender: TObject; var Rezult: HRESULT);
begin
  if EmbWB.GetDocument <> nil then
  begin
    DContainer.Caption  :=  EmbWB.GetDocument.title;
  end;
end;

procedure TFrmDXDialogs.DWBoxsDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  TimeX: Integer;
begin
  with DWBoxs do
  begin
    d :=  Propertites.Images.Images[Propertites.ImageIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    if boBoxOpening then
    begin
      TimeX :=  394 + (GetTickCount - TimeTick) div 150;
      if TimeX > 403 then
      begin
        TimeX  :=  403;
        Shuffle(False);
      end;
      D :=  Propertites.Images.Images[TimeX];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top) + 32, D);
    end;
  end;
end;

procedure TFrmDXDialogs.DWBoxsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  g_MouseItem.Name := '';
  DScreen.ClearHint;
end;

procedure TFrmDXDialogs.FormCreate(Sender: TObject);
begin
  EmbWB :=  TEmbeddedWB.Create(Self);
  EmbWB.Parent  :=  FrmMain;
  EmbWB.Visible :=  False;
  EmbWB.OnUpdateUI  :=  DoUpdateUI;
end;

procedure TFrmDXDialogs.GetBoxItem(ATag: Integer);

  procedure SetState(AButton: TDButton);
  begin
    if AButton.Tag = ATag then
      AButton.SetImgIndex(g_77Images, 391)
    else
      AButton.SetImgIndex(g_77Images, 392);
  end;

begin
  SetState(DBoxItem1);
  SetState(DBoxItem2);
  SetState(DBoxItem3);
  SetState(DBoxItem4);
  SetState(DBoxItem5);
  SetState(DBoxItem6);
  SetState(DBoxItem7);
  SetState(DBoxItem8);
  Inc(nBoxStep);
  DBoxCtrl.TimeTick  :=  GetTickCount;
  boBoxOpened :=  False;
  FrmMain.SendGetShuffleItem(myShuffleItems[ATag].MakeIndex);
end;

procedure TFrmDXDialogs.Initialize;
begin
  DWBoxs.DParent  :=  g_DXUIWindow;
  DWBoxs.SetImgIndex(g_77Images, 390);
  DWBoxs.Left := (ScreenWidth - DWBoxs.Width) div 2;;
  DWBoxs.Top := (ScreenHeight - DWBoxs.Height - g_BottomHeight) div 2;
  DBoxItem1.SetImgIndex(g_77Images, 391);
  DBoxItem2.SetImgIndex(g_77Images, 391);
  DBoxItem3.SetImgIndex(g_77Images, 391);
  DBoxItem4.SetImgIndex(g_77Images, 391);
  DBoxItem5.SetImgIndex(g_77Images, 391);
  DBoxItem6.SetImgIndex(g_77Images, 391);
  DBoxItem7.SetImgIndex(g_77Images, 391);
  DBoxItem8.SetImgIndex(g_77Images, 391);
  DBoxCtrl.SetImgIndex(g_77Images, 404);
  g_DXUIWindow.AddChild(DWBoxs);

  DContainer.DParent  :=  g_DXUIWindow;
  g_DXUIWindow.AddChild(DContainer);
  DCloseContainer.SetImgIndex(g_77Images, 52);
end;

procedure TFrmDXDialogs.Navigate(const AUrl: String; AWidth, AHeight: Integer);
begin
  if (AWidth <= 0) or (AHeight <= 0) then
  begin
    OpenBrowser(AUrl);
    Exit;
  end;

  FUrl  :=  AUrl;
  DContainer.Caption  :=  '页面加载中...';
  DContainer.Width  :=  AWidth + 36;
  DContainer.Width  :=  Min(DContainer.Width, SCREENWIDTH);
  DContainer.Height :=  AHeight + 87;
  DContainer.Height :=  Min(DContainer.Height, SCREENHEIGHT);
  DContainer.Left :=  (SCREENWIDTH - DContainer.Width) div 2;
  DContainer.Top  :=  (SCREENHEIGHT - DContainer.Height) div 2;
  DCloseContainer.Left  :=  DContainer.Width - 32;
  DCloseContainer.Top  :=  32;
  EmbWB.Left  :=  DContainer.Left + 16;
  EmbWB.Top   :=  DContainer.Top + 65;
  EmbWB.Width :=  DContainer.Width - 32;
  EmbWB.Height:=  DContainer.Height - 87;
  DContainer.Visible  :=  True;
end;

procedure TFrmDXDialogs.RandomSortShuffle;
var
  List: TList;
  I: Integer;
  AItem: PTClientItem;
begin
  List  :=  TList.Create;
  try
    System.Randomize;
    for I := 0 to 7 do
    begin
      New(AItem);
      AItem^  :=  myShuffleItems[I];
      List.Add(AItem);
    end;
    for I := 0 to 7 do
      List.SortList(
        function (L, R: Pointer): Integer
        var
          nL, nR: Integer;
        begin
          nL  :=  Random(10);
          nR  :=  Random(10);
          Result  :=  nL - nR;
        end
      );
    for I := 0 to 7 do
    begin
      myShuffleItems[I] :=  PTClientItem(List.Items[I])^;
      Dispose(List.Items[I]);
    end;
  finally
    List.Free;
  end;
end;

procedure TFrmDXDialogs.RequestURL(AUrl: String);
var
  sURL:String;
  sParam:string;
  sParam2:string;
  sName:string;
  sData :string;
  i:Integer;
begin
 // AUrl := 'http://127.0.0.1/game/Test.php?Name=你爸爸&Code=你妈妈&ff=';
  sParam := GetValidStr3(AUrl,sURL,['?']);
  if sURL <> '' then
  begin
    if sParam <> '' then
    begin
      sParam := '&' + sParam + '&';
      i:=0;
      repeat
        sParam := '=' + ArrestStringEx(sParam,'&','=',sName);
        sParam := '&' + ArrestStringEx(sParam,'=','&',sData);
        if (sName <> '') then
        begin
          if i = 0 then
            sParam2 := '?' + sName + '=' + URLEncode(UTF8Encode(sData))
          else
            sParam2 := sParam2 +  '&' + sName + '=' + URLEncode(UTF8Encode(sData));
          i := i + 1;
        end
        else
          Break;
      until sParam = '' ;
    end;
    sURL := sURL + sParam2;
    Try
      TThread.CreateAnonymousThread(procedure begin
        WebPagePost(sURL,'');
      end).Start;
    except

    end;
  end;
end;

procedure TFrmDXDialogs.ShowBox(StrItems: PPlatfromString);
var
  I: Integer;
  AData: PPlatfromString;
  AClientItem:  TClientItem;
begin
  I :=  0;
  while True do
  begin
    if StrItems = '' then
      break;
    StrItems := AnsiGetValidStr3(StrItems, AData, ['/']);
    if AData <> '' then
    begin
      DecodeClientItem(AData, AClientItem);
      myShuffleItems[I]  :=  AClientItem;
      Inc(I);
      if I > 7 then
        Break;
    end
    else
      Break;
  end;

  DBoxItem1.SetImgIndex(g_77Images, 391);
  DBoxItem2.SetImgIndex(g_77Images, 391);
  DBoxItem3.SetImgIndex(g_77Images, 391);
  DBoxItem4.SetImgIndex(g_77Images, 391);
  DBoxItem5.SetImgIndex(g_77Images, 391);
  DBoxItem6.SetImgIndex(g_77Images, 391);
  DBoxItem7.SetImgIndex(g_77Images, 391);
  DBoxItem8.SetImgIndex(g_77Images, 391);
  DBoxCtrl.SetImgIndex(g_77Images, 404);
  nBoxStep  :=  0;
  boBoxOpening  :=  False;
  boBoxOpened :=  False;
  DBoxCtrl.TimeTick :=  GetTickCount;
  DWBoxs.TimeTick :=  GetTickCount;
  DWBoxs.Visible  :=  True;
end;

procedure TFrmDXDialogs.Shuffle(Value: Boolean);
begin
  boBoxOpening  :=  Value;
  DBoxItem1.Visible :=  not Value;
  DBoxItem2.Visible :=  not Value;
  DBoxItem3.Visible :=  not Value;
  DBoxItem4.Visible :=  not Value;
  DBoxItem5.Visible :=  not Value;
  DBoxItem6.Visible :=  not Value;
  DBoxItem7.Visible :=  not Value;
  DBoxItem8.Visible :=  not Value;
  if Value then
  begin
    DWBoxs.TimeTick :=  GetTickCount;
    RandomSortShuffle;
  end
  else
  begin
    DBoxItem1.SetImgIndex(g_77Images, 392);
    DBoxItem2.SetImgIndex(g_77Images, 392);
    DBoxItem3.SetImgIndex(g_77Images, 392);
    DBoxItem4.SetImgIndex(g_77Images, 392);
    DBoxItem5.SetImgIndex(g_77Images, 392);
    DBoxItem6.SetImgIndex(g_77Images, 392);
    DBoxItem7.SetImgIndex(g_77Images, 392);
    DBoxItem8.SetImgIndex(g_77Images, 392);
    Inc(nBoxStep);
    boBoxOpened :=  True;
  end;
end;

{ TDXEmbeddedWB }

procedure TDXEmbeddedWB.WMKillFocus(var WMessage: TMessage);
begin
end;

procedure TDXEmbeddedWB.WMSetFocus(var WMessage: TMessage);
begin
end;

{ TMir3LoginScene }

procedure TMir3LoginScene.CloseScene;
begin
  inherited;
end;

constructor TMir3LoginScene.Create;
begin
  inherited;
  FFireIdx := 0;
  FLightIdx := 0;
end;

procedure TMir3LoginScene.OpenScene;
begin
  inherited;
  m_sLoginId := '';
  m_sLoginPasswd := '';
  m_boOpenFirst := TRUE;
  m_nCurFrame := 0;
  m_nMaxFrame := 19;
end;

procedure TMir3LoginScene.PassWdFail;
begin
end;

procedure TMir3LoginScene.PlayScene(MSurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  ALeft, ATop: Integer;
  OX, OY: integer;

  procedure DrawFire1(Idx: Integer);
  begin
    D := g_WEffectLogin.GetCachedImage(Idx, OX, OY);
    if D <> nil then
    begin
      case DISPLAYSIZETYPE of
        0: MSurface.Draw(ALeft + 620 + OX, ATop + 380 + oy, D, beSrcColor);
        1: MSurface.Draw(ALeft + 590 + OX, ATop + 340 + oy, D, beSrcColor);
        2: MSurface.Draw(ALeft + 520 + OX, ATop + 340 + oy, D, beSrcColor);
      end;
    end;
  end;

  procedure DrawFire2(Idx: Integer);
  begin
    D := g_WEffectLogin.GetCachedImage(Idx, OX, OY);
    if D <> nil then
    begin
      case DISPLAYSIZETYPE of
        0: MSurface.Draw(ALeft + 420 + OX, ATop + 380 + oy, D, beSrcColor);
        1: MSurface.Draw(ALeft + 380 + OX, ATop + 340 + oy, D, beSrcColor);
        2: MSurface.Draw(ALeft + 300 + OX, ATop + 340 + oy, D, beSrcColor);
      end;
    end;
  end;

  procedure DrawFire3(Idx: Integer);
  begin
    D := g_WEffectLogin.GetCachedImage(Idx, OX, OY);
    if D <> nil then
    begin
      case DISPLAYSIZETYPE of
        0: MSurface.Draw(ALeft + 560 + OX, ATop + 420 + oy, D, beSrcColor);
        1: MSurface.Draw(ALeft + 520 + OX, ATop + 380 + oy, D, beSrcColor);
        2: MSurface.Draw(ALeft + 460 + OX, ATop + 400 + oy, D, beSrcColor);
      end;
    end;
  end;

  procedure DrawFire4(Idx: Integer);
  begin
    D := g_WEffectLogin.GetCachedImage(Idx, OX, OY);
    if D <> nil then
    begin
      case DISPLAYSIZETYPE of
        0: MSurface.Draw(ALeft + 460 + OX, ATop + 420 + oy, D, beSrcColor);
        1: MSurface.Draw(ALeft + 440 + OX, ATop + 380 + oy, D, beSrcColor);
        2: MSurface.Draw(ALeft + 360 + OX, ATop + 400 + oy, D, beSrcColor);
      end;
    end;
  end;

  procedure DrawDoor(Idx: Integer);
  begin
    D := g_WEffectLogin.GetCachedImage(Idx, OX, OY);
    if D <> nil then
    begin
      case DISPLAYSIZETYPE of
        0: MSurface.Draw(ALeft + 516 + OX, ATop + 324 + oy, D);
        1: MSurface.Draw(ALeft + 484 + OX, ATop + 280 + oy, D);
        2: MSurface.Draw(ALeft + 413 + OX, ATop + 289 + oy, D);
      end;
    end;
  end;

begin
  if m_boOpenFirst then
  begin
    m_boOpenFirst := FALSE;
  end;
  case DISPLAYSIZETYPE of
    0: d := g_WEffectLogin.Images[0];
    1: d := g_WEffectLogin.Images[1];
    2: d := g_WEffectLogin.Images[2];
  end;
  ALeft := 0;
  ATop := 0;
  if d <> nil then
  begin
    ALeft := (SCREENWIDTH - d.Width) div 2;
    ATop := (SCREENHEIGHT - d.Height) div 2;
    MSurface.Draw(ALeft, ATop, d.ClientRect, d, FALSE);
  end;
  if GetTickCount - FFireTick > 60 then
  begin
    FFireTick := GetTickCount;
    Inc(FFireIdx);
    Inc(FLightIdx);
    if FFireIdx > 39 then
      FFireIdx := 0;
    if FLightIdx > 19 then
      FLightIdx := 0;
  end;
  DrawFire1(10 + FFireIdx);
  DrawFire2(60 + FFireIdx);
  DrawFire3(210 + FFireIdx);
  DrawFire4(260 + FFireIdx);

  if m_boNowOpening then
  begin
    Inc(m_nCurFrame);
    if m_nCurFrame >= m_nMaxFrame - 1 then
    begin
      m_nCurFrame := m_nMaxFrame - 1;
      if not g_boDoFadeOut and not g_boDoFadeIn then
      begin
        g_boDoFadeOut := TRUE;
        g_boDoFadeIn := TRUE;
        g_nFadeIndex := 29;
      end;
    end;
    DrawDoor(540 + m_nCurFrame);
    if g_boDoFadeOut then
    begin
      if g_nFadeIndex <= 1 then
      begin
        g_WEffectLogin.ClearCache;
        DScreen.ChangeScene(stSelectChr); //
      end;
    end;
  end;
  D := g_WEffectLogin.GetCachedImage(310 + FLightIdx, OX, OY);
  if D <> nil then
    MSurface.Draw(ALeft + 640 + OX, ATop + 480 +oy, D, TBlendingEffect.beSrcColor);
//  MSurface.TextOut((SCREENWIDTH - 800) div 2 + 360, (SCREENHEIGHT - 600) div 2 + 535, '健康游戏公告', $0093F4F2);
//  MSurface.TextOut((SCREENWIDTH - 800) div 2 + 190, (SCREENHEIGHT - 600) div 2 + 553, '抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，', $0093F4F2);
//  MSurface.TextOut((SCREENWIDTH - 800) div 2 + 190, (SCREENHEIGHT - 600) div 2 + 571, '沉迷游戏伤身。合理安排游戏，享受健康生活。严厉打击赌博，营造和谐环境。', $0093F4F2);
//  MSurface.BoldText(16, 16, APP_VERSION, clLime, clBlack);
end;

{ TMir4LoginScene }

procedure TMir4LoginScene.ChangeLoginState(state: TLoginState);
begin
  case state of
    lsLogin:
    begin
    end;
    lsNewid: ;
    lsNewidRetry: ;
    lsChgpw: ;
    lsCloseAll: ;
  end;
end;

procedure TMir4LoginScene.CloseScene;
begin
  inherited;
end;

constructor TMir4LoginScene.Create;
begin
  inherited;
  FFireIdx := 0;
  FLightIdx := 0;
end;

procedure TMir4LoginScene.OpenScene;
begin
  inherited;
  m_sLoginId := '';
  m_sLoginPasswd := '';
  m_boOpenFirst := TRUE;
  m_nCurFrame := 0;
  m_nMaxFrame := 11;
end;

procedure TMir4LoginScene.PassWdFail;
begin

end;

procedure TMir4LoginScene.PlayScene(MSurface: TAsphyreCanvas);
var
  d: TAsphyreLockableTexture;
  ALeft, ATop: Integer;
  OX, OY: integer;
begin
  if m_boOpenFirst then
  begin
    m_boOpenFirst := FALSE;
  end;
  case DISPLAYSIZETYPE of
    0: d := g_WNSelectImages.Images[490];
    1, 2: d := g_WNSelectImages.Images[520];
  end;
  ALeft := 0;
  ATop := 0;
  if d <> nil then
  begin
    ALeft := (SCREENWIDTH - d.Width) div 2;
    ATop := (SCREENHEIGHT - d.Height) div 2;
    MSurface.Draw(ALeft, ATop, d.ClientRect, d, False);
  end;
  if GetTickCount - FFireTick > 60 then
  begin
    FFireTick := GetTickCount;
    Inc(FFireIdx);
    Inc(FLightIdx);
    if FFireIdx > 14 then
      FFireIdx := 0;
  end;
  d := nil;
  case DISPLAYSIZETYPE of
    0: d := g_WNSelectImages.GetCachedImage(570 + FFireIdx, OX, OY);
    1, 2: d := g_WNSelectImages.GetCachedImage(550 + FFireIdx, OX, OY);
  end;
  if d <> nil then
    MSurface.Draw(ALeft, ATop, d, TBlendingEffect.beSrcColor);

  if m_boNowOpening then
  begin
    Inc(m_nCurFrame);
    if m_nCurFrame >= m_nMaxFrame - 1 then
    begin
      m_nCurFrame := m_nMaxFrame - 1;
      if not g_boDoFadeOut and not g_boDoFadeIn then
      begin
        g_boDoFadeOut := TRUE;
        g_boDoFadeIn := TRUE;
        g_nFadeIndex := 29;
      end;
    end;
    case DISPLAYSIZETYPE of
      0:
      begin
        d := g_WNSelectImages.GetCachedImage(500 + m_nCurFrame, OX, OY);
        if d <> nil then
          MSurface.Draw(ALeft + 516 + OX, ATop + 348 + OY, d, TBlendingEffect.beNormal);
      end;
      1, 2:
      begin
        d := g_WNSelectImages.GetCachedImage(530 + m_nCurFrame, OX, OY);
        if d <> nil then
          MSurface.Draw(ALeft + 400 + OX, ATop + 272 + OY, d, TBlendingEffect.beNormal);
      end;
    end;
    if g_boDoFadeOut then
    begin
      if g_nFadeIndex <= 1 then
      begin
        g_WEffectLogin.ClearCache;
        DScreen.ChangeScene(stSelectChr); //
      end;
    end;
  end;

  MSurface.BoldText((SCREENWIDTH - 800) div 2 + 360, (SCREENHEIGHT - 600) div 2 + 535, '健康游戏公告', $008CEFF7, $00212121);
  MSurface.BoldText((SCREENWIDTH - 800) div 2 + 190, (SCREENHEIGHT - 600) div 2 + 553, '抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，', $008CEFF7, $00212121);
  MSurface.BoldText((SCREENWIDTH - 800) div 2 + 190, (SCREENHEIGHT - 600) div 2 + 571, '沉迷游戏伤身。合理安排游戏，享受健康生活。严厉打击赌博，营造和谐环境。', $008CEFF7, $00212121);
  MSurface.BoldText(16, 16, APP_VERSION, clLime, clBlack);
end;




initialization
  OleInitialize(nil);

finalization
  OleUninitialize;

end.
