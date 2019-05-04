unit FState;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Generics.Collections,
  StdCtrls, Grids, Grobal2, clFunc, hUtil32, cliUtil, EDcode, soundUtil, actor,
  DWinCtl,
  DXHelper, uUITypes, uCliUITypes, uTypes, Common, uMapDesc, uMessageParse,
  Clipbrd,
  AbstractCanvas, AbstractTextures, AsphyreFactory, AbstractDevices,
  AsphyreTypes,
  uEDcode, uTextures, ExtCtrls, Math, PopupMeunuFrm, uInputString, WIL,
  uMagicMgr, Share, ExtUI,uDListView,uCliOrders,SkillInfo;

const
  BOTTOMBOARD800 = 371; // 主操作介面图形号
  BOTTOMBOARD1024 = 2; // 主操作介面图形号

  MAXSTATEPAGE = 4;
  LISTLINEHEIGHT = 13;
  MAXMENU = 10;

  STRLINS = 50;

  _ST_CHATBOX = 1;
  _ST_MAILLIST = 2;
  _ST_MAILREAD = 3;
  _ST_MAILWRITE = 4;
  _ST_BUYITEM = 5;
  _ST_SPLITITEM = 6;
  _ST_MISSIONS = 7;
  _ST_STALLLOG = 8;
  _ST_QSTALLLOG = 9;
  _ST_CHATHISBOX = 10;

  //盛大小地图模式的宽高
  SD_MMapWidth_2 = 200;
  SD_MMapHeight_2 = 200;

  SD_MMapWidth_1 = 120;
  SD_MMapHeight_1 = 120;




type
  //变量标签类型
  TTBType = (tbInt,tbuInt,tbWord,tbByte,tbInt64,tbJob,tbString,tbMyName,tbMapX,tbMapY,tbGoldV,tbGameGoldV,tbShortInt,tbHitSpeed);
  TDVarTextDataType = record
    DataType : TTBType;
    Data : Pointer;
  end;

  TSpotDlgMode = (dmSell, dmRepair, dmStorage, dmPlayDrink);

  TClickPoint = record
    rc: TRect;
    RStr: string;
    Index: Integer;
  end;

  pTClickPoint = ^TClickPoint;

  TdxExtendButton = class(TDButton)
  private
    TagName: String;
    CommandText: String;
  end;

  TStallItemState = (ssNone, ssMarketBuy, ssMarketPutOn, ssMarketUpdate,
    ssStallBuy, ssStallPutOn, ssStallUpdate, ssStallBuyPutOn, ssStallBuyUpdate,
    ssStallSaleToBuy);

  TFrmDlg = class(TForm)
    DStateWin: TDWindow;
    DBackground: TDWindow;
    DWHeadHealth: TDWindow;
    DWGroups: TDWindow;
    DItemBag: TDWindow;
    DBottom: TDWindow;
    DMyState: TDButton;
    DMyBag: TDButton;
    DMyMagic: TDButton;
    DOption: TDButton;
    DGold: TDButton;
    DItemsUpBut: TDButton;
    DCloseBag: TDButton;
    DCloseState: TDButton;
    DLogIn: TDWindow;
    DLoginNew: TDButton;
    DLoginOk: TDButton;
    DNewAccount: TDWindow;
    DNewAccountOk: TDButton;
    DLoginClose: TDButton;
    DNewAccountClose: TDButton;
    DSelectChr: TDSelChrWin;
    DscSelect1: TDButton;
    DscSelect2: TDButton;
    DscStart: TDButton;
    DscNewChr: TDButton;
    DscEraseChr: TDButton;
    DscCredits: TDButton;
    DscExit: TDButton;
    DCreateChr: TDWindow;
    DccWarrior: TDButton;
    DccWizzard: TDButton;
    DccMonk: TDButton;
    DccReserved: TDButton;
    DccMale: TDButton;
    DccFemale: TDButton;
    DccLeftHair: TDButton;
    DccRightHair: TDButton;
    DccOk: TDButton;
    DccClose: TDButton;
    DItemGrid: TDGrid;
    DLoginChgPw: TDButton;
    DMsgDlg: TDWindow;
    DMsgDlgOk: TDButton;
    DMsgDlgYes: TDButton;
    DMsgDlgCancel: TDButton;
    DMsgDlgNo: TDButton;
    DSWNecklace: TDButton;
    DSWLight: TDButton;
    DSWArmRingR: TDButton;
    DSWArmRingL: TDButton;
    DSWRingR: TDButton;
    DSWRingL: TDButton;
    DSWWeapon: TDDrawItemImage;
    DSWDress: TDDrawItemImage;
    DSWHelmet: TDDrawItemImage;
    DSWBujuk: TDButton;
    DSWBelt: TDButton;
    DSWBoots: TDButton;
    DSWCharm: TDButton;

    DBelt1: TDButton;
    DBelt2: TDButton;
    DBelt3: TDButton;
    DBelt4: TDButton;
    DBelt5: TDButton;
    DBelt6: TDButton;
    DChgPw: TDWindow;
    DChgpwOk: TDButton;
    DChgpwCancel: TDButton;
    DMerchantDlg: TDWindow;
    DMerchantDlgClose: TDButton;
    DMenuDlg: TDWindow;
    DMenuPrev: TDButton;
    DMenuNext: TDButton;
    DMenuBuy: TDButton;
    DMenuClose: TDButton;
    DSellDlg: TDWindow;
    DSellDlgOk: TDButton;
    DSellDlgClose: TDButton;
    DSellDlgSpot: TDButton;
    DKeySelDlg: TDWindow;
    DKsIcon: TDButton;
    DKsF1: TDButton;
    DKsF2: TDButton;
    DKsF3: TDButton;
    DKsF4: TDButton;
    DKsNone: TDButton;
    DKsOk: TDButton;
    DBotGroup: TDButton;
    DBotMiniMap: TDButton;
    DBotFriend: TDButton;
    DGroupDlg: TDWindow;
    DGrpAllowGroup: TDCheckBox;
    DGrpDlgClose: TDButton;
    DGrpAddMem: TDButton;
    DGrpDelMem: TDButton;
    DBotLogout: TDButton;
    DBotExit: TDButton;
    DBotGuild: TDButton;
    DStPageUp: TDButton;
    DStPageDown: TDButton;
    DDealRemoteDlg: TDWindow;
    DDealDlg: TDWindow;
    DDRGrid: TDGrid;
    DDGrid: TDGrid;
    DDealOk: TDButton;
    DDealClose: TDButton;
    DDGold: TDButton;
    DDRGold: TDButton;
    DSelServerDlg: TDWindow;
    DSSrvClose: TDButton;
    DSServer1: TDButton;
    DSServer2: TDButton;
    DUserState1: TDWindow;
    DCloseUS1: TDButton;
    DWeaponUS1: TDButton;
    DHelmetUS1: TDButton;
    DNecklaceUS1: TDButton;
    DDressUS1: TDButton;
    DLightUS1: TDButton;
    DArmringRUS1: TDButton;
    DRingRUS1: TDButton;
    DArmringLUS1: TDButton;
    DRingLUS1: TDButton;

    DBujukUS1: TDButton;
    DBeltUS1: TDButton;
    DBootsUS1: TDButton;
    DCharmUS1: TDButton;

    DSServer3: TDButton;
    DSServer4: TDButton;
    DGuildDlg: TDWindow;
    DGDHome: TDButton;
    DGDList: TDButton;
    DGDChat: TDButton;
    DGDAddMem: TDButton;
    DGDDelMem: TDButton;
    DGDEditNotice: TDButton;
    DGDEditGrade: TDButton;
    DGDAlly: TDButton;
    DGDBreakAlly: TDButton;
    DGDWar: TDButton;
    DGDCancelWar: TDButton;
    DGDUp: TDButton;
    DGDDown: TDButton;
    DGDClose: TDButton;
    DGuildEditNotice: TDWindow;
    DGEClose: TDButton;
    DGEOk: TDButton;
    DSServer5: TDButton;
    DSServer6: TDButton;
    DNewAccountCancel: TDButton;
    DAdjustAbility: TDWindow;
    DPlusDC: TDButton;
    DPlusMC: TDButton;
    DPlusSC: TDButton;
    DPlusAC: TDButton;
    DPlusMAC: TDButton;
    DPlusHP: TDButton;
    DPlusMP: TDButton;
    DPlusHit: TDButton;
    DPlusSpeed: TDButton;
    DMinusDC: TDButton;
    DMinusMC: TDButton;
    DMinusSC: TDButton;
    DMinusAC: TDButton;
    DMinusMAC: TDButton;
    DMinusMP: TDButton;
    DMinusHP: TDButton;
    DMinusHit: TDButton;
    DMinusSpeed: TDButton;
    DAdjustAbilClose: TDButton;
    DAdjustAbilOk: TDButton;
    DBotPlusAbil: TDButton;
    DKsF5: TDButton;
    DKsF6: TDButton;
    DKsF7: TDButton;
    DKsF8: TDButton;
    DEngServer1: TDButton;
    DKsConF1: TDButton;
    DKsConF2: TDButton;
    DKsConF3: TDButton;
    DKsConF4: TDButton;
    DKsConF5: TDButton;
    DKsConF6: TDButton;
    DKsConF7: TDButton;
    DKsConF8: TDButton;
    DAOpenShop: TDAniButton;
    DFriendDlg: TDWindow;
    DFrdClose: TDButton;
    DButton1: TDButton;
    DButton2: TDButton;
    DChgGamePwd: TDWindow;
    DChgGamePwdClose: TDButton;
    RefusePublicChat: TDExtendButton;
    RefuseCRY: TDExtendButton;
    RefuseWHISPER: TDExtendButton;
    Refuseguild: TDExtendButton;
    AutoCRY: TDExtendButton;
    CharacterSranking: TDButton;
    DShop: TDWindow;
    DShopClose: TDButton;
    DShopImgLogo: TDButton;
    DShopDecorate: TDButton;
    DShopSupplies: TDButton;
    DshopStrengthen: TDButton;
    DShopFriend: TDButton;
    DShopCapacity: TDButton;
    DShopPrev: TDButton;
    DShopNext: TDButton;
    DShopBuy: TDButton;
    DShopImg1: TDButton;
    DShopImg2: TDButton;
    DShopImg3: TDButton;
    DShopImg4: TDButton;
    DShopImg5: TDButton;
    DShopImg6: TDButton;
    DShopImg7: TDButton;
    DShopImg8: TDButton;
    DShopImg9: TDButton;
    DShopImg10: TDButton;
    DShopSpeciallyImg1: TDButton;
    DShopSpeciallyImg2: TDButton;
    DShopSpeciallyImg3: TDButton;
    DShopSpeciallyImg4: TDButton;
    DShopSpeciallyImg5: TDButton;
    DLevelOrder: TDWindow;
    DLevelOrderClose: TDButton;
    DLevelOrderIndex: TDButton;
    DLevelOrderPrev: TDButton;
    DLevelOrderNext: TDButton;
    DLevelOrderLastPage: TDButton;
    DMyLevelOrder: TDButton;
    DBoxs: TDWindow;
    DBoxsBelt1: TDButton;
    DBoxsBelt2: TDButton;
    DBoxsBelt3: TDButton;
    DBoxsBelt4: TDButton;
    DBoxsBelt5: TDButton;
    DBoxsBelt6: TDButton;
    DBoxsBelt7: TDButton;
    DBoxsBelt8: TDButton;
    DBoxsBelt9: TDButton;
    DBoxsTautology: TDButton;
    DItemsUp: TDWindow;
    DItemsUpClose: TDButton;
    DItemsUpBelt1: TDButton;
    DItemsUpBelt2: TDButton;
    DItemsUpBelt3: TDButton;
    DItemsUpOk: TDButton;
    DHelp: TDButton;
    DInternet: TDButton;
    DWMiniMap: TDWindow;
    DGlory: TDButton;
    DPlayDrink: TDWindow;
    DPlayDrinkClose: TDButton;
    DPlayDrinkFist: TDButton;
    DPlayDrinkScissors: TDButton;
    DPlayDrinkCloth: TDButton;
    DPlayFist: TDButton;
    DDrink3: TDButton;
    DDrink1: TDButton;
    DDrink2: TDButton;
    DDrink4: TDButton;
    DDrink5: TDButton;
    DDrink6: TDButton;
    DWPleaseDrink: TDWindow;
    DPDrink1: TDButton;
    DPDrink2: TDButton;
    DPleaseDrinkClose: TDButton;
    DPleaseDrinkDrink: TDButton;
    DPleaseDrinkExit: TDButton;
    DPlayDrinkNpcNum: TDButton;
    DPlayDrinkPlayNum: TDButton;
    DPlayDrinkWhoWin: TDButton;
    DFriendDlgFrd: TDButton;
    DHeiMingDan: TDButton;
    DPrevFriendDlg: TDButton;
    DNextFriendDlg: TDButton;
    DFriendList: TDButton;
    DAddFriend: TDButton;
    DWCheckNum: TDWindow;
    DCheckNumClose: TDButton;
    DCheckNumOK: TDButton;
    DCheckNumChange: TDButton;
    DEditCheckNum: TDEdit;
    DWMakeWineDesk: TDWindow;
    DMakeWineDeskClose: TDButton;
    DMakeWineHelp: TDButton;
    DMaterialMemo: TDButton;
    DStartMakeWine: TDButton;
    DBMateria: TDButton;
    DBWineSong: TDButton;
    DBWater: TDButton;
    DBWineCrock: TDButton;
    DBAssistMaterial1: TDButton;
    DBAssistMaterial2: TDButton;
    DBAssistMaterial3: TDButton;
    DBDrug: TDButton;
    DBWine: TDButton;
    DBWineBottle: TDButton;
    DWChallenge: TDWindow;
    DChallengeClose: TDButton;
    DChallengeOK: TDButton;
    DChallengeCancel: TDButton;
    DChallengeGrid: TDGrid;
    DChallengeGold: TDButton;
    DRChallengeGrid: TDGrid;
    dwRecoverChr: TDWindow;
    btnRecover: TDButton;
    btnRecvChrClose: TDButton;
    buttUseBatter: TDButton;
    DAttzhanshi: TDButton;
    DAttfashi: TDButton;
    DAttdaoshi: TDButton;
    DSighIcon: TDButton;
    DBatterRandom: TDButton;
    DBatterSort: TDButton;
    DStallCtrl: TDButton;
    DChatScroll: TDButton;
    DChatScrollTop: TDButton;
    DChatScrollBottom: TDButton;
    DBPay: TDButton;
    DWMaxMiniMap: TDWindow;
    DCloseMaxMiniMap: TDButton;
    DBShopCAdd: TDButton;
    DBShopCDec: TDButton;
    DWProgress: TDWindow;
    DWMaxMiniMapC: TDButton;
    DWMiniMapCtr: TDButton;
    DItemsRefresh: TDButton;
    DWSplitItem: TDWindow;
    DWSplitItemAdd: TDButton;
    DWSplitItemDec: TDButton;
    DWSplitItemOK: TDButton;
    DWSplitItemCancel: TDButton;
    DWBuyItemCount: TDWindow;
    DWBuyItemCountAdd: TDButton;
    DWBuyItemCountDec: TDButton;
    DWBuyItemCountOK: TDButton;
    DWBuyItemCountCancel: TDButton;
    DSWZhuli: TDButton;
    DZhuliUS1: TDButton;
    ScrollTimer: TTimer;
    DWMarket: TDWindow;
    DWMarketSButton: TDButton;
    DWMarketMButton: TDButton;
    DWMarketLButton: TDButton;
    DWMarketCloseButton: TDButton;
    DWMarketItems: TDGrid;
    DWMarketRItems: TDButton;
    DWMarketPStall: TDButton;
    DWMarketNStall: TDButton;
    DWMarketBuyItem: TDButton;
    DWMarketVList: TDButton;
    DWMarketRList: TDButton;
    DWMarketVStall: TDButton;
    DWMarketPPage: TDButton;
    DWMarketNPage: TDButton;
    DWMarketName: TDEdit;
    DWSplitItemEdt: TDEdit;
    DWBuyItemCountEdt: TDEdit;
    DWMarketSetName: TDButton;
    DWMarketPutOn: TDButton;
    DWMarketItem: TDWindow;
    DWMarketItemGoldEdt: TDEdit;
    DWMarketItemGameGoldEdt: TDEdit;
    DWMarketItemPutOn: TDButton;
    DWMarketItemPutOff: TDButton;
    DWMarketItemClose: TDButton;
    DWMarketItemItem: TDButton;
    DWMarketRMyItems: TDButton;
    DWMarketExtGold: TDButton;
    DChatBox: TDChatBox;
    DEShopAmount: TDEdit;
    DTopExtendButtons: TDControl;
    DGrpDismiss: TDButton;
    DFashionUS1: TDButton;
    DButton3: TDButton;
    DButton4: TDButton;
    DCheckFashion: TDCheckBox;
    MessageBoxTimer: TTimer;
    DMailList: TDWindow;
    DMailReader: TDWindow;
    DMailWriter: TDWindow;
    DBCloseMail: TDButton;
    DBCloseReader: TDButton;
    DBCloseWriter: TDButton;
    DBNewMail: TDButton;
    DBReadMail: TDButton;
    DBMLTop: TDButton;
    DBMLScroll: TDButton;
    DBMLBottom: TDButton;
    DBRMTop: TDButton;
    DBRMScroll: TDButton;
    DBRMBottom: TDButton;
    DBWMTop: TDButton;
    DBWMScroll: TDButton;
    DBWMBottom: TDButton;
    DMerchantDlgMessage: TDLabel;
    DMMailEdit: TDMemo;
    DMMReader: TDMemo;
    DEMailSubject: TDEdit;
    DEMailTo: TDEdit;
    DBMailToUsers: TDButton;
    DBMailExtrAtt: TDButton;
    DBMailReply: TDButton;
    DBMailSend: TDButton;
    DCMailItem: TDControl;
    DCSendMailItem: TDButton;
    DBDelMail: TDButton;
    DBDelAllMail: TDButton;
    DESendGold: TDEdit;
    DBSendGoldType: TDButton;
    DEBuyAttPrice: TDEdit;
    DBBuyAttGoldType: TDButton;
    DELoginID: TDEdit;
    DELoginPwd: TDEdit;
    DEChat: TDEdit;
    DEChrName: TDEdit;
    DBufferButtons: TDControl;
    DSMount: TDButton;
    DMountUS1: TDButton;
    DBotHorse: TDButton;
    DscSelect3: TDButton;
    DscSelect4: TDButton;
    DscSelect5: TDButton;
    DccAssassin: TDButton;
    DccArcher: TDButton;
    DPlusTC: TDButton;
    DMinusTC: TDButton;
    DPlusPC: TDButton;
    DMinusPC: TDButton;
    DBTitle1: TDButton;
    DBTitle2: TDButton;
    DBTitle3: TDButton;
    DBTitle4: TDButton;
    DBTitle5: TDButton;
    DBTitle6: TDButton;
    DBActivveTitle: TDButton;
    DBTitlePre: TDButton;
    DBTitleNext: TDButton;
    DBotDeal: TDButton;
    DSShied: TDDrawItemImage;
    DSShied1: TDButton;
    DscPriorPage: TDButton;
    DscNextPage: TDButton;
    DPlusWC: TDButton;
    DMinusWC: TDButton;
    DOrderRiches: TDRadioButton;
    DOrderMaster: TDRadioButton;
    DOrderWar: TDRadioButton;
    DOrderMag: TDRadioButton;
    DOrderDao: TDRadioButton;
    DOrderArc: TDRadioButton;
    DOrderCik: TDRadioButton;
    DOrderWS: TDRadioButton;
    DOrderAbil: TDRadioButton;
    DOrderLevel: TDRadioButton;
    DHintWindowClose: TDButton;
    DHintWindow: TDWindow;
    DWMiniMissions: TDWindow;
    DWMissions: TDWindow;
    DBCloseMissions: TDButton;
    DBMissionDoing: TDButton;
    DBMissionUnDo: TDButton;
    DLabelMissions: TDButton;
    DBMissionSwitch: TDExtendButton;
    DBMissionsWindow: TDButton;
    DBMissionsTop: TDButton;
    DBMissionsScroll: TDButton;
    DBMissionsBottom: TDButton;
    DMissionContent: TDLabel;
    DBMissionsListTop: TDButton;
    DBMissionsListScroll: TDButton;
    DBMissionsListBottom: TDButton;
    DMissionList: TDButton;
    DWDice: TDWindow;
    DWDiceClose: TDButton;
    DWStallWin: TDWindow;
    DWStallQueryWin: TDWindow;
    DWStallWinClose: TDButton;
    DWStallWinSaleGrid: TDGrid;
    DWStallWinBuyGrid: TDGrid;
    DWStallWinLeaveMsg: TDEdit;
    DWStallQueryWinSaleGrid: TDGrid;
    DWStallQueryWinBuyGrid: TDGrid;
    DWStallQueryWinClose: TDButton;
    DWStallWinCtrl: TDButton;
    DWStallWinGetGold: TDButton;
    DWMarketItemCountEdt: TDEdit;
    DWStallWinScrollTop: TDButton;
    DWStallWinScrollBar: TDButton;
    DWStallWinScrollBottom: TDButton;
    DWStallQueryWinScrollTop: TDButton;
    DWStallQueryWinScrollBar: TDButton;
    DWStallQueryWinScrollBttom: TDButton;
    DSideBarButtons: TDButton;
    DButtonSideBar: TDButton;
    DSideBar: TDControl;
    DGuidExtentButton: TDButton;
    DWChatHistory: TDWindow;
    DWChatHistoryClose: TDButton;
    DBChatHistoryScrollTop: TDButton;
    DBChatHistoryScrollBar: TDButton;
    DBChatHistoryScrollBottom: TDButton;
    DBotChatHistory: TDButton;
    DMChatHistory: TDButton;
    DStateWinPre: TDButton;
    DStateWinNext: TDButton;
    DUserState1Pre: TDButton;
    DUserState1Next: TDButton;
    DSWJewelryBox: TDButton;
    DSWZodiacSigns: TDButton;
    DSWJeweButtonOther: TDButton;
    DSWZodiacOther: TDButton;
    DRecruitMember: TDCheckBox;
    DTLevel: TDTextField;
    DTDateTime: TDTextField;
    DTAttackMode: TDTextField;
    DAMyHP: TDAniButton;
    DAMyMP: TDAniButton;
    DBWarEmptyBlood: TDButton;
    DAWarBlood: TDAniButton;
    DAWarBloodEffect: TDAniButton;
    DABloodEffect: TDAniButton;
    DAExpBar: TDAniButton;
    DAWeightBar: TDAniButton;
    DBWeather: TDButton;
    DTMapXY: TDTextField;
    DTHPText: TDTextField;
    DTMPText: TDTextField;
    DBLeftBloodPic: TDButton;
    DBRightBottomPic: TDButton;
    DTCountDownHint: TDTextField;
    DTMiniMapName: TDTextField;
    DBMinMapBackGround: TDButton;
    DBMiniMapImage: TDButton;
    DTAccount: TDTextField;
    DTPassWord: TDTextField;
    DTRegHint: TDTextField;
    DPLoginPanel: TDPanel;
    DILoginBGP: TDImagePanel;
    DTNotice1: TDTextField;
    DTNotice2: TDTextField;
    DTNotice3: TDTextField;
    DTAPP_Version: TDTextField;
    DAOpenDoor: TDAniButton;
    DALoginEffect: TDAniButton;
    DALoginFire1: TDAniButton;
    DALoginFire2: TDAniButton;
    DALoginFire3: TDAniButton;
    DALoginFire4: TDAniButton;
    DTMagicPageCount: TDTextField;
    DGridBottomPic: TDGridImage;
    DIQuickItemPic: TDImagePanel;
    DIStateHumImage: TDStateBottomImage;
    DStateWinPage_Skill: TDWindow;
    DSkillItem1: TDSkillItem;
    DSkillItem2: TDSkillItem;
    DSkillItem3: TDSkillItem;
    DSkillItem4: TDSkillItem;
    DSkillItem5: TDSkillItem;
    DSkillItem6: TDSkillItem;
    DStateWinPage_Attr: TDWindow;
    DTAC: TDVarTextField;
    DTMAC: TDVarTextField;
    DTDC: TDVarTextField;
    DTMC: TDVarTextField;
    DTSC: TDVarTextField;
    DTTC: TDVarTextField;
    DTPC: TDVarTextField;
    DTWC: TDVarTextField;
    DTHIT: TDVarTextField;
    DTSPEED: TDVarTextField;
    DTWeight: TDVarTextField;
    DTWearWeight: TDVarTextField;
    DTHandWeight: TDVarTextField;
    DTFightPower: TDVarTextField;
    DTAntiMagic: TDVarTextField;
    DTAntiPoison: TDVarTextField;
    DTDrugRecovery: TDVarTextField;
    DTHPRecovery: TDVarTextField;
    DTMPRecovery: TDVarTextField;
    DTABSORBING: TDVarTextField;
    DTREBOUND: TDVarTextField;
    DTATTACKADD: TDVarTextField;
    DTPunchHit: TDVarTextField;
    DTCRITICALHIT: TDVarTextField;
    DTEXPADDRATE: TDVarTextField;
    DTITEMDROPADDRATE: TDVarTextField;
    DTGOLDDROPADDRATE: TDVarTextField;
    DTAPPENDDAMAGE: TDVarTextField;

    DTAC_Other: TDVarTextField;
    DTMAC_Other: TDVarTextField;
    DTDC_Other: TDVarTextField;
    DTMC_Other: TDVarTextField;
    DTSC_Other: TDVarTextField;
    DTTC_Other: TDVarTextField;
    DTPC_Other: TDVarTextField;
    DTWC_Other: TDVarTextField;
    DTHIT_Other: TDVarTextField;
    DTSPEED_Other: TDVarTextField;
    DTWeight_Other: TDVarTextField;
    DTWearWeight_Other: TDVarTextField;
    DTHandWeight_Other: TDVarTextField;
    DTFightPower_Other: TDVarTextField;
    DTAntiMagic_Other: TDVarTextField;
    DTAntiPoison_Other: TDVarTextField;
    DTDrugRecovery_Other: TDVarTextField;
    DTHPRecovery_Other: TDVarTextField;
    DTMPRecovery_Other: TDVarTextField;
    DTABSORBING_Other: TDVarTextField;
    DTREBOUND_Other: TDVarTextField;
    DTATTACKADD_Other: TDVarTextField;
    DTPunchHit_Other: TDVarTextField;
    DTCRITICALHIT_Other: TDVarTextField;
    DTEXPADDRATE_Other: TDVarTextField;
    DTITEMDROPADDRATE_Other: TDVarTextField;
    DTGOLDDROPADDRATE_Other: TDVarTextField;
    DTAPPENDDAMAGE_Other: TDVarTextField;

    DStateWinPage_State: TDWindow;
    DTJob: TDTextField;
    DTLevelText: TDTextField;
    DTCredit: TDTextField;
    DTExp: TDTextField;
    DTMaxExp: TDTextField;
    DTHP: TDTextField;
    DTMP: TDTextField;
    DTGameGoldCount: TDTextField;
    DTGamePoint: TDTextField;
    DTGameGlory: TDTextField;
    DTGameGird: TDTextField;
    DTGameDiamond: TDTextField;
    DTVJob: TDVarTextField;
    DTVLevel: TDVarTextField;
    DTVCreditPoint: TDVarTextField;
    DTVEXP: TDVarTextField;
    DTVMAXEXP: TDVarTextField;
    DTVHP: TDVarTextField;
    DTVMP: TDVarTextField;
    DTVGameGold: TDVarTextField;
    DTVGamePoint: TDVarTextField;
    DTVGameGlory: TDVarTextField;
    DTVGameGird: TDVarTextField;
    DTVGameDiamond: TDVarTextField;
    DStateWinPage_Tiltle: TDWindow;
    DTTitle1: TDTextField;
    DTTitle2: TDTextField;
    DTTitle3: TDTextField;
    DTTitle4: TDTextField;
    DTTitle5: TDTextField;
    DTTitle6: TDTextField;
    DTActivveTitle: TDTextField;
    DPStateWin: TDPageControl;
    DIStateHumImage_fashion: TDStateBottomImage;
    TTabState: TDTab;
    DTMySelfName: TDTextField;
    DTGuildRankName: TDTextField;
    DBMyHair: TDButton;
    DBTitleInfo: TDButton;
    DWFashionDress: TDDrawItemImage;
    DTGoldCount: TDVarTextField;
    DTGameGold: TDVarTextField;
    DTBagGamePoint: TDVarTextField;
    TabOtherState: TDTab;
    DPOtherState: TDPageControl;
    DIOtherStateImage: TDStateBottomImage;
    DStateOtherAttr: TDWindow;
    DIOtherStatefashion: TDStateBottomImage;
    DHairUS: TDButton;
    DTNameUS1: TDTextField;
    DTGuildRankUS1: TDTextField;
    DLoginNotice: TDWindow;
    DNoticeOK: TDButton;
    DLoginNoticeMsg: TDWindow;
    DTMapName: TDTextField;
    DTMapMouseX: TDTextField;
    DTMapMouseY: TDTextField;
    DMiniMapDrawPos: TDWindow;
    DMsgDlgText: TDWindow;
    DLVGoods: TDListView;
    DStorageWin: TDWindow;
    DLVSaveItems: TDListView;
    DSaveItemsPrevPage: TDButton;
    DSaveItemsNextPage: TDButton;
    DGetBackItem: TDButton;
    DStorageWinClose: TDButton;
    DTGuildName: TDTextField;
    DMGuild: TDEditMemo;
    DPEditPopupMenu: TDPopupMenu;
    DTSellTitle: TDTextField;
    DVRecoverCharNames: TDListView;
    DTabGameShopType: TDTab;
    DTSetSkillTips: TDTextField;
    DGrpExit: TDButton;
    DMapAreaFlag: TDControl;
    DMouseXYMiniMap: TDTextField;
    DStallGold: TDTextField;
    DStallGameGold: TDTextField;
    DStallGoldValue: TDTextField;
    DStallGameGoldValue: TDTextField;
    DStallTips: TDVarTextField;
    DStallLog: TDControl;
    DWMarketWinName: TDTextField;
    DTItemName: TDTextField;
    DWStallStop: TDButton;
    DViewStallLog: TDControl;
    DASelChrFire1: TDAniButton;
    DASelChrFire2: TDAniButton;
    DASelChrFire3: TDAniButton;
    DASelChrFire4: TDAniButton;
    DAWater1: TDAniButton;
    DAWater2: TDAniButton;
    DAChrFoucs: TDAniButton;
    DAChr1: TDAniButton;
    DAChr2: TDAniButton;
    DAChr3: TDAniButton;
    DAChr4: TDAniButton;
    DAChr5: TDAniButton;
    DPanelChr1: TDImagePanel;
    DPanelChr2: TDImagePanel;
    DPanelChr3: TDImagePanel;
    DPanelChr4: TDImagePanel;
    DPanelChr5: TDImagePanel;
    DPanelSelChrBGP: TDImagePanel;
    DTServerName: TDTextField;
    DTChrPage: TDTextField;
    DANewChr: TDAniButton;
    DTExpText: TDVarTextField;
    DTWeightText: TDVarTextField;
    DLockClientPassword: TDWindow;
    DLockClientPasswordOk: TDButton;
    DEDT_LockPassword: TDEdit;
    DTCaption: TDVarTextField;
    DLockClient: TDImagePanel;
    m_EdNewId: TDEdit;
    m_EdNewPasswd: TDEdit;
    m_EdConfirm: TDEdit;
    m_EdYourName: TDEdit;
    m_EdSSNo: TDEdit;
    m_EdBirthDay: TDEdit;
    m_EdQuiz1: TDEdit;
    m_EdAnswer1: TDEdit;
    m_EdQuiz2: TDEdit;
    m_EdAnswer2: TDEdit;
    m_EdPhone: TDEdit;
    m_EdMobPhone: TDEdit;
    m_EdEMail: TDEdit;
    m_EdChgId: TDEdit;
    m_EdChgCurrentPw: TDEdit;
    m_EdChgNewPw: TDEdit;
    m_EdChgRepeat: TDEdit;
    DShopGameGold: TDTextField;
    DShopGamePoint: TDTextField;
    DShopSelItemPrice: TDTextField;
    DShopSelItemName: TDTextField;
    DGuildInfo: TDWindow;
    DExitGame: TDWindow;
    DExitGameHint: TDTextField;
    DExitOk: TDButton;
    DExitCancel: TDButton;
    DTRankUserName: TDTextField;
    DTRankOrder: TDTextField;
    DTRankJob: TDTextField;
    DTRankSex: TDTextField;
    DTRankType: TDTextField;
    DTRankPage: TDTextField;
    DTRankOrderText: TDTextField;
    DTRankMyOrder: TDTextField;
    DV_RankInfo: TDListView;
    DTCommission: TDTextField;
    EdtMsgDlg: TDEdit;
    DLBLHelpText: TDLabel;
    DMiniMap_SD: TDWindow;
    DMapMiniMapImageMask: TDButton;
    DRankType: TDControl;
    procedure DBottomDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DItemBagDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DItemsUpButDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DStateWinDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure FormCreate(Sender: TObject);
    procedure DItemGridGridSelect(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DItemGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
    procedure DItemGridDblClick(Sender: TObject);
    procedure DMsgDlgDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DMsgDlgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBackgroundBackgroundClick(Sender: TObject);
    procedure DItemGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DBelt1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure FormDestroy(Sender: TObject);
    procedure DBelt1DblClick(Sender: TObject);
    procedure DLoginCloseClick(Sender: TObject; X, Y: Integer);
    procedure DLoginOkClick(Sender: TObject; X, Y: Integer);
    procedure DLoginNewClick(Sender: TObject; X, Y: Integer);
    procedure DLoginChgPwClick(Sender: TObject; X, Y: Integer);
    procedure DNewAccountOkClick(Sender: TObject; X, Y: Integer);
    procedure DNewAccountCloseClick(Sender: TObject; X, Y: Integer);
    procedure DccCloseClick(Sender: TObject; X, Y: Integer);
    procedure DChgpwOkClick(Sender: TObject; X, Y: Integer);
    procedure DscSelect1Click(Sender: TObject; X, Y: Integer);
    procedure DCloseStateClick(Sender: TObject; X, Y: Integer);
    procedure DSWWeaponClick(Sender: TObject; X, Y: Integer);

    procedure DMsgDlgOkClick(Sender: TObject; X, Y: Integer);
    procedure DCloseBagClick(Sender: TObject; X, Y: Integer);
    procedure DBelt1Click(Sender: TObject; X, Y: Integer);
    procedure DMyStateClick(Sender: TObject; X, Y: Integer);
    procedure DSWWeaponMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBelt1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMerchantDlgCloseClick(Sender: TObject; X, Y: Integer);
    procedure DMenuCloseClick(Sender: TObject; X, Y: Integer);
    procedure DMenuDlgDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DMenuDlgClick(Sender: TObject; X, Y: Integer);
    procedure DSellDlgDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DSellDlgCloseClick(Sender: TObject; X, Y: Integer);
    procedure DSellDlgSpotClick(Sender: TObject; X, Y: Integer);
    procedure DSellDlgSpotDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DSellDlgSpotMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DSellDlgOkClick(Sender: TObject; X, Y: Integer);
    procedure DMenuBuyClick(Sender: TObject; X, Y: Integer);
    procedure DMenuPrevClick(Sender: TObject; X, Y: Integer);
    procedure DMenuNextClick(Sender: TObject; X, Y: Integer);
    procedure DGoldClick(Sender: TObject; X, Y: Integer);
    procedure DSWLightDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    // 显示英雄装备    清清$010
    procedure DBackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DStateWinMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DStMag1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DMagicItemIconDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);

    procedure DKsIconDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DKsF1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DKsOkClick(Sender: TObject; X, Y: Integer);
    procedure DKsF1Click(Sender: TObject; X, Y: Integer);
    procedure DGrpDlgCloseClick(Sender: TObject; X, Y: Integer);
    procedure DBotGroupClick(Sender: TObject; X, Y: Integer);
    procedure DGrpAllowGroupClick(Sender: TObject; X, Y: Integer);
    procedure DGroupDlgDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DGrpAddMemClick(Sender: TObject; X, Y: Integer);
    procedure DGrpDelMemClick(Sender: TObject; X, Y: Integer);
    procedure DBotLogoutClick(Sender: TObject; X, Y: Integer);
    procedure DBotExitClick(Sender: TObject; X, Y: Integer);
    procedure DStPageUpClick(Sender: TObject; X, Y: Integer);
    procedure DBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DDealOkClick(Sender: TObject; X, Y: Integer);
    procedure DDealCloseClick(Sender: TObject; X, Y: Integer);
    procedure DDealRemoteDlgDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DDealDlgDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DDGridGridSelect(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DDGridGridPaint(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState; dsurface: TAsphyreCanvas);
    procedure DDGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DDRGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
    procedure DDRGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DDGoldClick(Sender: TObject; X, Y: Integer);
    procedure DSServer1Click(Sender: TObject; X, Y: Integer);
    procedure DSSrvCloseClick(Sender: TObject; X, Y: Integer);
    procedure DBotMiniMapClick(Sender: TObject; X, Y: Integer);
    procedure DMenuDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DUserState1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DUserState1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWeaponUS1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DCloseUS1Click(Sender: TObject; X, Y: Integer);
    procedure DNecklaceUS1DirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBotGuildClick(Sender: TObject; X, Y: Integer);
    procedure DGuildDlgDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DGDUpClick(Sender: TObject; X, Y: Integer);
    procedure DGDDownClick(Sender: TObject; X, Y: Integer);
    procedure DGDCloseClick(Sender: TObject; X, Y: Integer);
    procedure DGDHomeClick(Sender: TObject; X, Y: Integer);
    procedure DGDListClick(Sender: TObject; X, Y: Integer);
    procedure DGDAddMemClick(Sender: TObject; X, Y: Integer);
    procedure DGDDelMemClick(Sender: TObject; X, Y: Integer);
    procedure DGDEditNoticeClick(Sender: TObject; X, Y: Integer);
    procedure DGDEditGradeClick(Sender: TObject; X, Y: Integer);
    procedure DGECloseClick(Sender: TObject; X, Y: Integer);
    procedure DGEOkClick(Sender: TObject; X, Y: Integer);
    procedure DGuildEditNoticeDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DGDChatClick(Sender: TObject; X, Y: Integer);
    procedure DNewAccountDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DAdjustAbilCloseClick(Sender: TObject; X, Y: Integer);
    procedure DAdjustAbilityDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBotPlusAbilClick(Sender: TObject; X, Y: Integer);
    procedure DPlusDCClick(Sender: TObject; X, Y: Integer);
    procedure DMinusDCClick(Sender: TObject; X, Y: Integer);
    procedure DAdjustAbilOkClick(Sender: TObject; X, Y: Integer);
    procedure DBotPlusAbilDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DAdjustAbilityMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DEngServer1Click(Sender: TObject; X, Y: Integer);
    procedure DGDAllyClick(Sender: TObject; X, Y: Integer);
    procedure DGDBreakAllyClick(Sender: TObject; X, Y: Integer);
    procedure DBotMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DBotFriendClick(Sender: TObject; X, Y: Integer);
    procedure DFrdCloseClick(Sender: TObject; X, Y: Integer);
    procedure DChgGamePwdCloseClick(Sender: TObject; X, Y: Integer);
    procedure DChgGamePwdDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure CallHeroClick(Sender: TObject; X, Y: Integer);
    procedure RefuseguildClick(Sender: TObject; X, Y: Integer);
    procedure RefuseWHISPERClick(Sender: TObject; X, Y: Integer);
    procedure HeroStateClick(Sender: TObject; X, Y: Integer);
    procedure DCloseHeroStateClick(Sender: TObject; X, Y: Integer);
    procedure HeroPackageClick(Sender: TObject; X, Y: Integer);
    procedure RefusePublicChatClick(Sender: TObject; X, Y: Integer);
    procedure DHeroItemBagDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DHeroItemGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
    procedure DHeroItemGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DHeroItemGridDblClick(Sender: TObject);
    function HeroIcon(sex: Integer; job: Integer): Integer;
    procedure DAOpenShopClick(Sender: TObject; X, Y: Integer);
    procedure DShopDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DShopImg1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DShopNextClick(Sender: TObject; X, Y: Integer);
    procedure DShopDecorateClick(Sender: TObject; X, Y: Integer);
    procedure DShopImg1Click(Sender: TObject; X, Y: Integer);
    procedure Itemstrorlist(str: string; WIDTH, HEIGH: Integer);
    procedure DShopBuyClick(Sender: TObject; X, Y: Integer);
    procedure DShopSpeciallyImg1DirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DShopSpeciallyImg1Click(Sender: TObject; X, Y: Integer);
    // Shop 物品动画演示
    procedure ShopGifInfo(dsurface: TAsphyreCanvas;
      dx, dy, ShopGifBegin, ShopGifEnd: Integer);
    procedure CharacterSrankingClick(Sender: TObject; X, Y: Integer);
    procedure DLevelOrderCloseClick(Sender: TObject; X, Y: Integer);
    procedure DOrderLevelClick(Sender: TObject; X, Y: Integer);
    procedure DBottomMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure typeTimeimg; // 英雄怒气变换函数
    procedure DPlayGameNum();
    procedure ItemLightTimeImg(); inline; // 物品发光变换函数 20080223
    procedure ItemFlashTime(); inline;
    procedure BoxsFlash(Button: TDButton; dsurface: TAsphyreCanvas);
    procedure BoxsRandomImg;
    procedure BoxsRunning(dsurface: TAsphyreCanvas);
    procedure DBoxsDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DBoxsClick(Sender: TObject; X, Y: Integer);
    procedure DBoxsBelt5DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DBoxsBelt5MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBoxsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBoxsTautologyClick(Sender: TObject; X, Y: Integer);
    procedure DBoxsTautologyMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBoxsBelt1DblClick(Sender: TObject);
    procedure ShowBoxsGird(Show: Boolean);
    procedure DItemsUpButMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DItemsUpButClick(Sender: TObject; X, Y: Integer);
    procedure DItemBagMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure RefuseCRYClick(Sender: TObject; X, Y: Integer);
    procedure AutoCRYClick(Sender: TObject; X, Y: Integer);
    procedure DSHWeaponClick(Sender: TObject; X, Y: Integer);
    procedure DLevelOrderClick(Sender: TObject; X, Y: Integer);
    procedure ShowSellOffListDlg;
    procedure DWMiniMapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DSelectChrMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBoxsTautologyDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DItemsUpBelt1DirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DItemsUpBelt1Click(Sender: TObject; X, Y: Integer);
    procedure DItemsUpOkClick(Sender: TObject; X, Y: Integer);
    procedure DItemsUpBelt1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DItemsUpCloseClick(Sender: TObject; X, Y: Integer);
    procedure DPlayDrinkDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure ChallengeClick(Sender: TObject; X, Y: Integer);
    procedure DDrink1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DPlayFistClick(Sender: TObject; X, Y: Integer);
    procedure DPlayDrinkCloseDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DPlayDrinkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DPlayDrinkMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DPlayDrinkClick(Sender: TObject; X, Y: Integer);
    procedure DWPleaseDrinkDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DPDrink1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DPlayDrinkCloseClick(Sender: TObject; X, Y: Integer);
    procedure DPlayDrinkFistClick(Sender: TObject; X, Y: Integer);
    procedure DPlayDrinkNpcNumDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DPlayDrinkPlayNumDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DPlayDrinkWhoWinDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas); // 显示寄售列表界面 20080317
    procedure ShowPlayDrinkImg(Show: Boolean);
    procedure DPlayDrinkFistDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DDrink1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DPlayDrinkMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DDrink1Click(Sender: TObject; X, Y: Integer);
    procedure DPDrink1Click(Sender: TObject; X, Y: Integer);
    procedure DPDrink1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWPleaseDrinkMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DPleaseDrinkExitClick(Sender: TObject; X, Y: Integer);
    procedure DPleaseDrinkDrinkClick(Sender: TObject; X, Y: Integer);
    procedure DWPleaseDrinkClick(Sender: TObject; X, Y: Integer);
    procedure DWPleaseDrinkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DWPleaseDrinkMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DFriendDlgFrdClick(Sender: TObject; X, Y: Integer);
    procedure DFriendDlgDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DFriendListDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DPrevFriendDlgClick(Sender: TObject; X, Y: Integer);
    procedure DAddFriendClick(Sender: TObject; X, Y: Integer);
    procedure DInternetClick(Sender: TObject; X, Y: Integer);
    procedure DWCheckNumDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DCheckNumOKDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DCheckNumOKClick(Sender: TObject; X, Y: Integer);
    procedure DEditCheckNumKeyPress(Sender: TObject; var Key: Char);
    procedure DEditCheckNumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DCheckNumChangeClick(Sender: TObject; X, Y: Integer);
    procedure DWMakeWineDeskDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DMakeWineHelpDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DMakeWineDeskCloseClick(Sender: TObject; X, Y: Integer);
    procedure DMakeWineHelpClick(Sender: TObject; X, Y: Integer);
    procedure DMaterialMemoClick(Sender: TObject; X, Y: Integer);
    procedure DBMateriaMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWMakeWineDeskMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ShowMakeWine(bool: Boolean);
    procedure DBMateriaClick(Sender: TObject; X, Y: Integer);
    procedure DBMateriaDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DBDrugDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DBDrugClick(Sender: TObject; X, Y: Integer);
    procedure DStartMakeWineClick(Sender: TObject; X, Y: Integer);
    procedure DBDrugMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DHeroLiquorProgressDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCheckSdoNameShowDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DNewSdoBasicDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWChallengeDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DChallengeGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DChallengeGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
    procedure DChallengeGridGridSelect(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DChallengeCloseClick(Sender: TObject; X, Y: Integer);
    procedure DRChallengeGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DRChallengeGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
    procedure DChallengeOKClick(Sender: TObject; X, Y: Integer);
    procedure DChallengeGoldClick(Sender: TObject; X, Y: Integer);
    procedure btnRecvChrCloseClick(Sender: TObject; X, Y: Integer);
    procedure btnRecoverClick(Sender: TObject; X, Y: Integer);
    procedure DWChallengeMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DEdtSdoCommonHpTimerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DHeroItemBagMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    constructor Create(AOwner: TComponent); override;
    procedure State5Click(Sender: TObject; X, Y: Integer);
    procedure cmButtDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure cmButtClick(Sender: TObject; X, Y: Integer);
    procedure ButtChongmaiDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure OpenmaiButt1DblClick(Sender: TObject);
    procedure BatterSkill1DirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure BatterSkill5DirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure BatterSkill1Click(Sender: TObject; X, Y: Integer);
    procedure ButtChongmaiClick(Sender: TObject; X, Y: Integer);
    procedure buttUseBatterDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure OpenmaiButt1DirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DAdjustAbilOkDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DAttzhanshiDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DAttzhanshiClick(Sender: TObject; X, Y: Integer);
    procedure DHeroAttZhanshiDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DHeroAttZhanshiClick(Sender: TObject; X, Y: Integer);
    procedure DStartTrainingDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DHeroLeftSel2Click(Sender: TObject; X, Y: Integer);
    procedure DHeroRightSel2Click(Sender: TObject; X, Y: Integer);
    procedure DMentSay1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DMentSay1Click(Sender: TObject; X, Y: Integer);
    procedure DSighIconDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DSighIconClick(Sender: TObject; X, Y: Integer);
    procedure DBatterRandomDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBatterPopMenuDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBatterPopMenuMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBatterPopMenuClick(Sender: TObject; X, Y: Integer);
    procedure BatterSkill1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DStPageUpDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DStPageDownDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DChatScrollMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DShopImgLogoDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DShopMKindClick(Sender: TObject; X, Y: Integer);
    procedure DShopBuyDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DWMaxMiniMapDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBPayClick(Sender: TObject; X, Y: Integer);
    procedure DBShopCAddClick(Sender: TObject; X, Y: Integer);
    procedure DBShopCDecClick(Sender: TObject; X, Y: Integer);
    procedure DShopImg1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DShopImgLogoMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DShopMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DSellDlgOkMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DSellDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWProgressDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DHelpClick(Sender: TObject; X, Y: Integer);
    procedure DWMaxMiniMapCDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCloseMaxMiniMapClick(Sender: TObject; X, Y: Integer);
//    procedure DCloseMaxMiniMapDirectPaint(Sender: TObject;
//      dsurface: TAsphyreCanvas);
    procedure DWMaxMiniMapCMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DWMaxMiniMapCMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWMaxMiniMapCDblClick(Sender: TObject);
    procedure DWMaxMiniMapMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWMiniMapCtrClick(Sender: TObject; X, Y: Integer);
    procedure DItemsRefreshDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DItemsRefreshClick(Sender: TObject; X, Y: Integer);
    procedure DItemsUpMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWSplitItemCancelClick(Sender: TObject; X, Y: Integer);
    procedure DWSplitItemOKClick(Sender: TObject; X, Y: Integer);
    procedure DWSplitItemDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DWBuyItemCountCancelClick(Sender: TObject; X, Y: Integer);
    procedure DWBuyItemCountOKClick(Sender: TObject; X, Y: Integer);
    procedure DWBuyItemCountDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWHeadHealthDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWHeadHealthInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DWGroupsDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DChatScrollTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DChatScrollTopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DChatScrollBottomMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DChatScrollBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollTimerTimer(Sender: TObject);
    procedure DWMarketSButtonClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketSButtonDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWMarketCloseButtonClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DWMarketVListClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketVStallClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketItemsGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
    procedure DWMarketItemsGridSelect(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DWMarketItemsGridMouseMove(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DWMarketMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWMarketItemDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWMarketItemCloseClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketItemMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWMarketPutOnClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketItemItemDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWMarketItemItemMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWMarketItemPutOnClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketItemPutOffClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketBuyItemClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketRItemsClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketPStallClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketNStallClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketSetNameClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketRListClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DMsgDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DDealDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWMarketRMyItemsClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketPPageClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketNPageClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketPutOnDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWMarketExtGoldClick(Sender: TObject; X, Y: Integer);
    procedure DChatBoxDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DChatBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DChatBoxMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DShopSpeciallyImg5MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DShopCloseClick(Sender: TObject; X, Y: Integer);
    procedure DSighIconMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DEShopAmountChange(Sender: TObject);
    procedure DMyBagClick(Sender: TObject; X, Y: Integer);
    procedure DMyMagicClick(Sender: TObject; X, Y: Integer);
    procedure DOptionClick(Sender: TObject; X, Y: Integer);
    procedure DHeiMingDanClick(Sender: TObject; X, Y: Integer);
    procedure DFriendDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DFriendDlgFrdMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DFriendListClick(Sender: TObject; X, Y: Integer);
    procedure DFriendListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DGroupDlgClick(Sender: TObject; X, Y: Integer);
    procedure DGrpDismissClick(Sender: TObject; X, Y: Integer);
    procedure DGroupDlgDblClick(Sender: TObject);
    procedure DCheckFashionMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DCheckFashionClick(Sender: TObject; X, Y: Integer);
    procedure DCheckFashionDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure MessageBoxTimerTimer(Sender: TObject);
    procedure DWMiniMapInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DMerchantDlgInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DWMiniMapDblClick(Sender: TObject);
    procedure DChatBoxMouseWheelDownEvent(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DChatBoxMouseWheelUpEvent(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMerchantDlgVisibleChange(Sender: TObject);
    procedure DBCloseMailClick(Sender: TObject; X, Y: Integer);
    procedure DMailListVisibleChange(Sender: TObject);
    procedure DBCloseReaderClick(Sender: TObject; X, Y: Integer);
    procedure DBCloseWriterClick(Sender: TObject; X, Y: Integer);
    procedure DBNewMailClick(Sender: TObject; X, Y: Integer);
    procedure DBReadMailClick(Sender: TObject; X, Y: Integer);
    procedure DMailListPostionChange(Sender: TObject);
    procedure DMailListDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DMailListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBMLScrollMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBWMScrollMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMerchantDlgMessageCommandLinkClick(Sender: TObject;
      const Command: string);
    procedure DMerchantDlgMessageMoveInCommandNode(Sender: TObject;
      ACommandNode: TMessageNode; X, Y: Integer);
    procedure DBMLTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBMLTopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBMLBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBMLBottomMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBWMTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBWMBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBWMBottomMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBWMTopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBRMTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBRMBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBRMBottomMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBRMTopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBRMScrollMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMailReaderDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DBMailSendClick(Sender: TObject; X, Y: Integer);
    procedure DBMailExtrAttClick(Sender: TObject; X, Y: Integer);
    procedure DBMailReplyClick(Sender: TObject; X, Y: Integer);
    procedure DBMailToUsersClick(Sender: TObject; X, Y: Integer);
    procedure DCMailItemDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DCSendMailItemDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DCSendMailItemClick(Sender: TObject; X, Y: Integer);
    procedure DMailWriterVisibleChange(Sender: TObject);
    procedure DCSendMailItemMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DCMailItemMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMailWriterMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMailReaderMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMailListMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMailWriterDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DBDelMailClick(Sender: TObject; X, Y: Integer);
    procedure DBDelAllMailClick(Sender: TObject; X, Y: Integer);
    procedure DWBuyItemCountEdtChange(Sender: TObject);
    procedure DWSplitItemEdtChange(Sender: TObject);
    procedure DWSplitItemAddMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DWSplitItemDecMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DWSplitItemDecMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DWSplitItemAddMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DWBuyItemCountDecMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DWBuyItemCountAddMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DWBuyItemCountAddMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DWBuyItemCountDecMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DKeySelDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWSplitItemMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWBuyItemCountMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMailListMouseWheelDownEvent(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMailListMouseWheelUpEvent(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBSendGoldTypeClick(Sender: TObject; X, Y: Integer);
    procedure DBBuyAttGoldTypeClick(Sender: TObject; X, Y: Integer);
    procedure DEChatKeyPress(Sender: TObject; var Key: Char);
    procedure DEChatKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DELoginPwdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBufferButtonsInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DBotHorseClick(Sender: TObject; X, Y: Integer);
    procedure DAdjustAbilityVisibleChange(Sender: TObject);
    procedure DMerchantDlgMessageGetItemImages(ANode: TMessageNode);
    procedure DStMag1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);

    procedure DMagicItemMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);

    procedure DSServer6DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DscExitClick(Sender: TObject; X, Y: Integer);
    procedure DccWarriorClick(Sender: TObject; X, Y: Integer);
    procedure DccWarriorDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DccMaleDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DCreateChrDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DscStartDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DGuildEditNoticeVisibleChange(Sender: TObject);
    procedure DBActivveTitleClick(Sender: TObject; X, Y: Integer);
    procedure DBTitle1Click(Sender: TObject; X, Y: Integer);
    procedure DBTitlePreClick(Sender: TObject; X, Y: Integer);
    procedure DBTitleNextClick(Sender: TObject; X, Y: Integer);
    procedure DBActivveTitleDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBTitle1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DBTitle1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBActivveTitleMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBotDealClick(Sender: TObject; X, Y: Integer);
    procedure DscPriorPageClick(Sender: TObject; X, Y: Integer);
    procedure DscNextPageClick(Sender: TObject; X, Y: Integer);
    procedure DItemsUpVisibleChange(Sender: TObject);
    procedure DLevelOrderDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DLevelOrderMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DLevelOrderIndexClick(Sender: TObject; X, Y: Integer);
    procedure DLevelOrderPrevClick(Sender: TObject; X, Y: Integer);
    procedure DLevelOrderNextClick(Sender: TObject; X, Y: Integer);
    procedure DLevelOrderLastPageClick(Sender: TObject; X, Y: Integer);
    procedure DMyLevelOrderClick(Sender: TObject; X, Y: Integer);
    procedure DLevelOrderMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DHintWindowCloseClick(Sender: TObject; X, Y: Integer);
    procedure DHintWindowDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DHintWindowCloseDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DHintWindowInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DItemsUpButInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DBMissionSwitchClick(Sender: TObject; X, Y: Integer);
    procedure DWMiniMissionsInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DBCloseMissionsClick(Sender: TObject; X, Y: Integer);
    procedure DBMissionsWindowClick(Sender: TObject; X, Y: Integer);
    procedure DBMissionDoingClick(Sender: TObject; X, Y: Integer);
    procedure DBMissionUnDoDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DLabelMissionsDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DBMissionsScrollMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBottomVisibleChange(Sender: TObject);
    procedure DChatScrollMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBMLScrollMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBRMScrollMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBWMScrollMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBMissionsScrollMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DMailListDblClick(Sender: TObject);
    procedure DBMissionsBottomMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBMissionsBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBMissionsTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBMissionsTopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DLabelMissionsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DLabelMissionsClick(Sender: TObject; X, Y: Integer);
    procedure DLabelMissionsInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DWMiniMissionsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DBMissionsTopMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMissionListDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DMissionListMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMissionListClick(Sender: TObject; X, Y: Integer);
    procedure DBMissionsListScrollMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DBMissionsListScrollMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWMissionsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMissionContentCommandLinkClick(Sender: TObject;
      const Command: string);
    procedure DWMarketItemVisibleChange(Sender: TObject);
    procedure DWDiceDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DWDiceCloseClick(Sender: TObject; X, Y: Integer);
    procedure DWStallWinCloseClick(Sender: TObject; X, Y: Integer);
    procedure DWStallQueryWinCloseClick(Sender: TObject; X, Y: Integer);
    procedure DWStallWinSaleGridGridSelect(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DWStallWinSaleGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
    procedure DStallCtrlClick(Sender: TObject; X, Y: Integer);
    procedure DWMarketItemCountEdtChange(Sender: TObject);
    procedure DWStallWinCtrlClick(Sender: TObject; X, Y: Integer);
    procedure DWStallWinSaleGridGridMouseMove(Sender: TObject;
      ACol, ARow: Integer; Shift: TShiftState);
    procedure DWStallWinDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DWStallWinBuyGridGridMouseMove(Sender: TObject;
      ACol, ARow: Integer; Shift: TShiftState);
    procedure DWStallWinBuyGridGridPaint(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
    procedure DWStallWinBuyGridGridSelect(Sender: TObject; ACol, ARow: Integer;
      Shift: TShiftState);
    procedure DWStallWinGetGoldClick(Sender: TObject; X, Y: Integer);
    procedure DWStallQueryWinSaleGridGridMouseMove(Sender: TObject;
      ACol, ARow: Integer; Shift: TShiftState);
    procedure DWStallQueryWinSaleGridGridPaint(Sender: TObject;
      ACol, ARow: Integer; Rect: TRect; State: TGridDrawState;
      dsurface: TAsphyreCanvas);
    procedure DWStallQueryWinSaleGridGridSelect(Sender: TObject;
      ACol, ARow: Integer; Shift: TShiftState);
    procedure DWStallQueryWinBuyGridGridMouseMove(Sender: TObject;
      ACol, ARow: Integer; Shift: TShiftState);
    procedure DWStallQueryWinBuyGridGridPaint(Sender: TObject;
      ACol, ARow: Integer; Rect: TRect; State: TGridDrawState;
      dsurface: TAsphyreCanvas);
    procedure DWStallQueryWinBuyGridGridSelect(Sender: TObject;
      ACol, ARow: Integer; Shift: TShiftState);
    procedure DWStallWinMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWStallQueryWinMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWStallWinLeaveMsgKeyPress(Sender: TObject; var Key: Char);
    procedure DWStallWinScrollTopMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DWStallWinScrollTopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DWStallWinScrollBottomMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DWStallWinScrollBottomMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DWStallWinScrollBarMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DWStallWinScrollBarMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DWStallQueryWinDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DWStallQueryWinScrollTopMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DWStallQueryWinScrollBttomMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DWStallQueryWinScrollBarMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DWStallQueryWinScrollBarMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure DUserState1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DSideBarDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DButtonSideBarClick(Sender: TObject; X, Y: Integer);
    procedure DSideBarButtonsDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DSideBarMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DSideBarButtonsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DSideBarButtonsClick(Sender: TObject; X, Y: Integer);
    procedure DGuidExtentButtonClick(Sender: TObject; X, Y: Integer);
    procedure DGDWarClick(Sender: TObject; X, Y: Integer);
    procedure DBotChatHistoryClick(Sender: TObject; X, Y: Integer);
    procedure DWChatHistoryCloseClick(Sender: TObject; X, Y: Integer);
    procedure DMChatHistoryDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DMChatHistoryMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DMChatHistoryMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure DMChatHistoryMouseWheelDownEvent(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure DMChatHistoryMouseWheelUpEvent(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure DBChatHistoryScrollTopMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DBChatHistoryScrollTopMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DBChatHistoryScrollBottomMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DBChatHistoryScrollBarMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DBChatHistoryScrollBarMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure DUserState1NextClick(Sender: TObject; X, Y: Integer);
    procedure DSWJewelryBoxClick(Sender: TObject; X, Y: Integer);
    procedure DSWZodiacOtherClick(Sender: TObject; X, Y: Integer);
    procedure DRecruitMemberClick(Sender: TObject; X, Y: Integer);
    procedure DSideBarInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DscStartInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DBWeatherDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DAOpenDoorDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure TTabStateTabChange(Sender: TDControl;
      SourceIndex, Index: Integer);
    procedure DBMyHairDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DBTitleInfoDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DUserState1PreClick(Sender: TObject; X, Y: Integer);
    procedure DHairUSDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DWeaponUS1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DDressUS1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DSShied1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DBZhuliStateDirectPaint(Sender: TObject;
      dsurface: TAsphyreCanvas);
    procedure DHelmetUS1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure DStateWinNextClick(Sender: TObject; X, Y: Integer);
    procedure DNoticeOKClick(Sender: TObject; X, Y: Integer);
    procedure DLoginNoticeMsgDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DMiniMapDrawPosMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DFashionUS1DirectPaint(Sender: TObject; DSurface: TAsphyreCanvas);
    procedure DSaveItemsPrevPageClick(Sender: TObject; X, Y: Integer);
    procedure DSaveItemsNextPageClick(Sender: TObject; X, Y: Integer);
    procedure DGetBackItemClick(Sender: TObject; X, Y: Integer);
    procedure DStorageWinCloseClick(Sender: TObject; X, Y: Integer);
    procedure DLVSaveItemsClick(Sender: TObject; X, Y: Integer);
    procedure DLVGoodsClick(Sender: TObject; X, Y: Integer);
    procedure DGuildDlgVisibleChange(Sender: TObject);
    procedure DPEditPopupMenuVisibleChange(Sender: TObject);
    procedure DTabGameShopTypeTabChange(Sender: TDControl; SourceIndex,
      Index: Integer);
    procedure DKeySelDlgVisibleChange(Sender: TObject);
    procedure DMiniMapDrawPosDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DMapAreaFlagDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DWStallStopClick(Sender: TObject; X, Y: Integer);
    procedure DAExpBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DAWeightBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DBRightBottomPicMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DLockClientPasswordOkClick(Sender: TObject; X, Y: Integer);
    procedure DSelServerDlgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DLoginNoticeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DGuildInfoDirectPaint(Sender: TObject; DSurface: TAsphyreCanvas);
    procedure DExitOkClick(Sender: TObject; X, Y: Integer);
    procedure DExitCancelClick(Sender: TObject; X, Y: Integer);
    procedure DV_RankInfoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DTItemNameDirectPaint(Sender: TObject; DSurface: TAsphyreCanvas);
    procedure DLBLHelpTextDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DWMaxMiniMapVisibleChange(Sender: TObject);
    procedure DMiniMap_SDDirectPaint(Sender: TObject; DSurface: TAsphyreCanvas);
    procedure DMiniMap_SDMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DTMySelfNameDirectPaint(Sender: TObject;
      DSurface: TAsphyreCanvas);
    procedure DChatBoxDownInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DBackgroundInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DBottomInRealArea(Sender: TObject; X, Y: Integer;
      var IsRealArea: Boolean);
    procedure DSWHelmetDirectPaint(Sender: TObject; DSurface: TAsphyreCanvas);
  private
    FUILoaded: Boolean;
    FBloodTick, FShopAmount: Integer;
    FSpeciallyShop: Boolean;

    ShopKind: Byte;
    ShopTabPage: Byte;

    DlgTemp: TList;
    magcur, magtop, HeroMagTop: Integer;
 //   EdDlgEdit: TEdit;
    FGuildMemo: TMemo;
    // ItemFlash: Integer;    //金牛装备闪光
    // ItemFlashTick: Integer; //金牛装备闪光间隔
    ViewDlgEdit: Boolean;
    MenuTop: Integer;
  public
    MagicPage: Integer;
  private
    InternalForceMagicPage: Integer; // 内功技能页
    HeroMagicPage: Integer;
    HeroInternalForceMagicPage: Integer; // 英雄内功技能页
    BlinkTime: LongWord;
    BlinkCount: Integer; // 0..9荤捞甫 馆汗

    imginsex: Integer; // 清清
    typetime: LongWord;
    // 批量购买
    FBuyMaxCount, FBuyPrice, FBuyIndex: Integer;
    FBuyItemName: String;
    // 拆分
    FSplitMaxCount, FSplitMakeIndex: Integer;
    // 设置技能快捷键
    FSelMagic: pTClientMagic;
    FMagKeyCurKey: Integer;
    // 邮件
    FSendGoldType: Integer;
    FBuyAttGoldType: Integer;
    // 行会编辑
    FGuildMemoType: Byte;

    BatterImage: Integer;
    BatterTime: Integer;
    FChatLock: Boolean;
    FItemIndex: Integer; // 辅助物品顶部序号
    FPrgMax: Integer;
    FPrgTick: LongWord;
    FPrgMessage: String;
    FPMenuIdx: Integer;
    FScrollType: Byte;
    FExtendButtons, FTopExtendButtons: TList<TdxExtendButton>;
    FBufferControls: TList<TuDBufferControl>;
    BottomSurface: TAsphyreRenderTargetTexture;
    FInNpcMsgDowned: Boolean;
    FMessageBoxList: TList;
    FDialogItem: PTMessageDialogItem;
    FMissionY: Integer;
    FMissionListY: Integer;
    FChatScrollY: Integer;
    FMLScrollY: Integer;
    FMRScrollY: Integer;
    FMWScrollY: Integer;
    FStallLogScrollY: Integer;
    FQueryStallLogScrollY: Integer;
    FStallLogTopLine: Integer;
    FQueryStallLogTopLine: Integer;
    FDiceTime: LongWord;
    FDiceID: Integer;
    FDiceCount: Integer;
    FDicePoint1: Integer;
    FDicePoint2: Integer;
    FDicePoint3: Integer;
    FDiceAniEnd1: Boolean;
    FDiceAniEnd2: Boolean;
    FDiceAniEnd3: Boolean;
    FDiceSended: Boolean;
    FDicePlayCount: Integer;
    FSideButtons: TStrings;
    FSideButtonExpand: Boolean;
    FSideButtonActive: Integer;
    function GetBatterMagicIcon(Eff: Word): Integer;


    procedure HeroInternalForcePageChanged;
    procedure LevelOrderPageChanged; // 等级排行榜页数改变 2007.12.12
    procedure MouseRightItem(WhoItemBag { 谁的包裹 } , ACol, ARow: Integer);
    // 右键穿装备
    procedure DealItemReturnBag(mitem: TClientItem);
    procedure ChallengeItemReturnBag(mitem: TClientItem);
    procedure SellOffItemReturnBag(mitem: TClientItem); // 元宝寄售返回包裹 20080316
    procedure DealZeroGold;
    procedure NpcAutoSelDrinkRuning(dsurface: TAsphyreCanvas);
    procedure MouseDlbTakeItem(WhoItemBag, Idx: Integer);
    procedure UIWinSelectClick(ANpc: Integer;
      const Selected, WinName, ItemIndexes: String);
    procedure UIMoveInCommandNode(Sender: TObject; ACommandNode: TMessageNode;
      X, Y: Integer);
    procedure UIMoveInHint(Sender: TObject; const Hint: String; X, Y: Integer);
    procedure UIGetPass(var Pass: String; var Handled: Boolean);
    function CanRefreshBag: Boolean; inline;
    procedure BuildMessageBox;
    procedure EndMessageBox(ATag: Integer);
    procedure ShowBuyItemDialog(const Caption, ItemName: String;
      MaxCount, Price, Index: Integer);
    procedure ShowSplitItemDialog(const Caption: String;
      MaxCount, MakeIndex: Integer);
    procedure IncBuyItemCount(Value: Integer);
    procedure IncSplitItemCount(Value: Integer);
    procedure OnBufferItemMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure OnBufferItemTimeEnd(Sender: TObject);
    procedure RebuildBufferControls;
    procedure ChangeBonusPointButtonsState;
    procedure DrawMessageBackGround(Sender: TObject);
    procedure DoMessageGetItemImages(ANode: TMessageNode);
    procedure RenderBottomSurface(Sender: TObject);
    procedure DoClickHintInited(Sender: TObject);
    procedure RecalcSideBarButtons;
  public
    InternalForcePage: Integer; // 内功状态页
    BatterPage: Byte; // 连击经络页面
    BatterWink: Boolean;
    BatterSelMenu: Byte;
    MarketTabIdx: Integer;
    MarketItemIndex: Integer;
    ISMarketList: Boolean;
    MarketListIndex: Integer;
    MarketListPage: Integer;
    StallItemState: TStallItemState;
    MerchantDiagWidth, MerchantDlgHeight: Integer;
    LevelOrderPage: Integer;
    msglx, msgly: Integer;
    strorlist: array [0 .. STRLINS - 1] of String;
    strorlistidx: array [0 .. STRLINS - 1] of Integer;
    strorliscont: Integer;
    HeroStatePage: Integer;
    MsgText: string;

    FAQColor: Integer;
    FDlgMessage: TuMerchantMessage;
    MerchantName: string;
    MerchantFace: Integer;
    MDlgStr: string;
    MDlgPoints: TList;
    RequireAddPoints: Boolean;
    SelectMenuIndex: Integer;
    LastestClickTime: LongWord;
    SpotDlgMode: TSpotDlgMode;

//    MenuList: TList; // list of PTClientGoods
//    MenuIndex: Integer;

    CurDetailItem: string;
    MenuTopLine: Integer;
    BoDetailMenu: Boolean;
    BoNoDisplayMaxDura: Boolean;
    BoMakeDrugMenu: Boolean;
    NAHelps: TStringList;
    NewAccountTitle: string;

    DlgEditText: string;
    UserDressInnerEffect: TItemInnerEffect;
    UserWeponInnerEffect: TItemInnerEffect;
    UserMixedAbility: Int64;

    GuildTopLine: Integer;
    GuildEditHint: string;
    procedure HideAllControls;
    procedure RestoreHideControls;
    procedure InitializeForLogin;
    procedure CreateSelChrUI;//创建选择角色信息的描述组件
    procedure Initialize;
    procedure InitializePlace; // 初始化图象位置 20080524
    procedure InitUIPak;
    procedure InitStateWin; // 初始化人物装备内关 组件
    procedure Finalize;
    procedure BuildBufferStation;
    procedure OpenMyStatus(nPage: Integer);
    procedure OpenUserState(UserState: TUserStateInfo);
    procedure OpenItemBag;
    procedure ViewBottomBox(visible: Boolean);
    procedure ViewHeadHealtBox(visible: Boolean);
    procedure ViewGroupHeadHealtBox(visible: Boolean);
    procedure CancelItemMoving;
    procedure DropMovingItem;
    procedure OpenAdjustAbility;

    procedure ShowSelectServerDlg;
    function DMessageDlg(msgstr: string; DlgButtons: TMsgDlgButtons)
      : TModalResult;
    procedure MessageBox(const Title: string; DlgButtons: TMsgDlgButtons;
      Proc: TMessageHandler = nil);
    procedure ShowMDlg(face: Integer; mname, msgstr: string);
    procedure ShowCustomMDlg(AMerchant, AType, face: Integer;
      const UIName, NPCName, Message: string);
    procedure ShowGuildDlg;
    procedure ShowGuildEditNotice;
    procedure ShowGuildEditGrade;

    procedure ResetMenuDlg;
    procedure ShowShopMenuDlg(ShopOnly: Boolean = False);
    procedure ShowStorgeDlg(); //显示仓库窗口
    procedure ShowShopSellDlg;
    procedure ShowShopSellOffDlg; // 元宝寄售显示窗口 20080316
    procedure CloseDSellDlg;
    procedure CloseMDlg(CloseManual: Boolean);
    procedure CloseForMapChanged;

    procedure ToggleShowGroupDlg;
    procedure OpenDealDlg;

    procedure OpenChallengeDlg; // 打开挑战对话框
    procedure CloseChallengeDlg;
    procedure CloseDealDlg;

    procedure OpenFriendDlg;
    procedure SetAjustAbiPosition;
    procedure SetOrderPosition;
    procedure SoldOutGoods(itemserverindex: Integer);
    procedure DelStorageItem(itemserverindex: Integer);
    procedure SetMagicKeyDlg(CurKey: Integer);
    procedure ShowPlayDrink(Who1: Integer; msgstr: string);
    procedure BatterButtChanged;
    procedure HeroBatterButtChanged;
    procedure AdjustWindowShow();
    procedure OpenUI(const AName: String);
    procedure ShowProgress(const AMessage: String; Max: Integer);
    procedure CloseProgress;
    procedure ResetMaxMap;
    procedure ShowMap;
    procedure OpenDragonBox;
    procedure OpenDragonBoxFail;
    // procedure ChatSrollToBottom;
    procedure UpdateChatSroll;
    procedure UpdateChatHisSroll;
    procedure SetMarketTabIndex(Index: Integer);
    procedure OpenMarket;
    procedure OpenShop;
    procedure OpenBag;
    procedure ShowMarkteItemModal;
    procedure ShowMarketItemUpdate;
    procedure ShowMarketItemPutOn;
    procedure ShowMarketItemBuy;
    procedure ShowStallPutOn;
    procedure ShowStallItemUpdate;
    procedure ShowStallBuyPutOn;
    procedure ShowStallBuyItemUpdate;
    procedure ShowStallItemBuy;
    procedure ShowStallSaleToBuy;
    procedure ReStall;
    procedure ClearExtendButtons;
    procedure AddExtendButton(const AName, AHint, ACommand: String;
      ImageIndex: Integer; ISTop: Boolean ;  X:Integer = 0 ; Y : Integer = 0);
    procedure RemoveExtendButton(const AName: String);
    procedure ExtButtonMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ExtButtonDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
    procedure ExtButtonClick(Sender: TObject; X, Y: Integer);
    procedure SetExtButtonBounds;
    procedure SetTopExtButtonBounds;
    procedure OpenMiniMap(ChangeSize: Boolean = True);
    procedure ReBuildGropuUI;
    procedure ReBuildGroupHeadUI;
    procedure CloseTopmost;
    procedure OpenMailBox;
    procedure ReloadBagItems;
    procedure OpenMailView;
    procedure OpenRefineBox;
    procedure OpenLookupStall(S: AnsiString);
    procedure OpenMyStall(S: AnsiString);
    procedure ClearMailWriter;
    procedure ClearMailReader;

    procedure UpdateMailListScroll;
    procedure UpdateMailReadScroll;
    procedure UpdateMailWriteScroll;
    procedure UpdateMiniMissionsScroll;
    procedure UpdateStallLogScroll;
    procedure UpdateQueryStallLogScroll;
    procedure AddOrUpdateBufferControl(BufferType, TimeLimit, Value: Integer;
      const AName: String);
    procedure RemoveBufferControl(BufferType: Integer);
    procedure ClearBuffers;
    procedure ReSetShopState;
    procedure BeginScene(Device: TAsphyreDevice; MSurface: TAsphyreCanvas);
    procedure SetBottomButtonsPosition;
    procedure ShowMissionDetail(SwitchVisible: Boolean);
    procedure UpdateMissionContent;
    procedure UpdateMissions;
    procedure ShowMissionControl(V: Boolean);
    procedure StartDice(ATag, APoint1, APoint2, APoint3: Integer);
    procedure AddStallQueryLog(const S: String);
    procedure AddSideBarButton(const ACaption, AName: String);
    procedure DeleteSideBarButton(const AName: String);
    procedure ClearSideBarButtons;
    procedure LoadCustomUI();
    function CanClickStartPlayBtn(): Double;
    procedure ShowLockClientWindows(Show:Boolean; const Caption: String);
    procedure ResetSDMiniMapSizeAndPosition(&type:integer);
  public
    NameDesc0,Name0,JobDesc0,JobName0,LevelDesc0,Level0 : TDTextField;
    NameDesc1,Name1,JobDesc1,JobName1,LevelDesc1,Level1 : TDTextField;
    NameDesc2,Name2,JobDesc2,JobName2,LevelDesc2,Level2 : TDTextField;
    NameDesc3,Name3,JobDesc3,JobName3,LevelDesc3,Level3 : TDTextField;
    NameDesc4,Name4,JobDesc4,JobName4,LevelDesc4,Level4 : TDTextField;


    ChrInfoPanel : array[0..4] of TDImagePanel;
    ChrNames:array[0..4] of TDTextField;
    ChrJobDescs:array[0..4] of TDTextField;
    ChrJobName:array[0..4] of TDTextField;
    ChrLevelDesc:array[0..4] of TDTextField;
    ChrLevel:array[0..4] of TDTextField;
    ChrNameDesc:array[0..4] of TDTextField;
    ChrAnis:array[0..4] of TDAniButton;
    ChrSelectButton:array[0..4] of TDButton;


    procedure SetMagicPage(Page: Integer);
    procedure MagicIconClick(Sender: TObject; X, Y: Integer);
    procedure SetTitlePage(Page: Integer);
    procedure SetRankListViewData(RankOrder:TuOrderObject);
  end;

procedure DrawItem(Item: TClientItem; dsurface: TAsphyreCanvas;
  X, Y, CellWidth, CellHeight: Integer; TimeTick: LongWord ; ItemFrom : TDrawItemFileType = dipBagItem);
procedure DrawShopItem(Item: TShopItem; dsurface: TAsphyreCanvas;
  X, Y, CellWidth, CellHeight: Integer; TimeTick: LongWord);
Function MaigicCountPage: Integer;
procedure DrawItemUI(dsurface: TAsphyreCanvas; Sender: TDDrawItemImage;
  ItemProperty: TDrawItemProperties);
procedure DrawItemUIMouseMove(Sender: TDDrawItemImage;
  ItemProperty: TDrawItemProperties);
procedure InitVarTextField();
function GetDrawStatePic(Properites: TStateWinProperties): Integer;
procedure SetAllowGroup(Value: Boolean);
procedure SetRecruitMember(Value: Boolean);
function GetDVarValue(Sender : TDVarTextField; Const VarName:String):string;
procedure ClickNpcLable(Sender : TDMerchatAniButton ; const Command: string);
procedure OnUIReadDone();
procedure GotoNpcProc(const S:String);

var
  FrmDlg: TFrmDlg;
  CHATBOXLINECOUNT : Integer = 9; // 聊天框一屏能显示多少 行文字
  MerchantDlgLeft : Integer = 20;
  MerchantDlgTop : Integer = 18;
  ShowMySelfOrder:Boolean = false;
implementation

uses
  ClMain, DrawScrn, IntroScn, AsphyreUtils, MShare,
  AsphyreTextureFonts,
  uAnsiStrings, AnsiHUtil32, AnsiStrings, clGuild, NewItemDlg, ViewOtherNewItem;

const
  _MISSION_COLOR_: array [TMissonKind] of TColor = (clMaroon, clPurple,
    clBlue, clTeal);
  _MISSION_KINDS_: array [TMissonKind] of String = ('[主]', '[支]', '[日]', '[悬]');
var
  VarTextCaption : TDictionary<string,TDVarTextDataType>;
{$R *.DFM}
procedure GotoNpcProc(const S:String);
begin
  FrmMain.SendMerchantDlgSelect(g_nCurMerchant, S);
end;

function GetChatBoxStyle():TDChatBoxStyle;
begin
  Result := FrmDlg.DChatBox.Propertites.ChatBoxStyle;
end;

procedure OnUIReadDone();
begin
  MerchantDlgLeft := FrmDlg.DMerchantDlgMessage.Left;
  MerchantDlgTop :=  FrmDlg.DMerchantDlgMessage.Top;
  DXPopupMenu.HidePopup;
end;

procedure SetCloseButtonImage(D:TDButton);
begin
  D.SetImgIndex(g_77Images,52);
  D.Propertites.DownedIndex := 53;
end;

procedure SetMirOldButtonImageIndex(D:TDControl;W:TWMImages;ImageIndex : Integer);
begin
  D.SetImgIndex(W,ImageIndex);
  D.Propertites.ImageIndex := -1;
  D.Propertites.DownedIndex := ImageIndex;
end;

procedure CSetImageIndex(D:TDControl;W:TWMImages;ImageIndex : Integer);
begin
  D.SetImgIndex(W,ImageIndex);
  D.Propertites.DownedIndex := ImageIndex + 1;
end;

procedure AddDVarTextList(const Text : String;tType: TTBType;Data:Pointer);
var
  D:TDVarTextDataType;
begin
  D.DataType := tType;
  D.Data := Data;
  VarTextCaption.Add(Text,D);
end;


procedure SetAllowGroup(Value: Boolean);
begin
  g_boAllowGroup := Value;
  FrmDlg.DGrpAllowGroup.Checked := Value;
end;

procedure SetRecruitMember(Value: Boolean);
begin
  g_boRecruitMember := Value;
  FrmDlg.DRecruitMember.Checked := Value;
end;

Function MaigicCountPage: Integer;
begin
  if g_DWinMan.StateWinType <> wk176 then
    Result := 6
  else
    Result := 5;
end;

function IIFI(I: Integer): String; INLINE;
begin
  if I = 0 then
    Result := ''
  else
    Result := IntToStr(I);
end;

function GetDrawStatePic(Properites: TStateWinProperties): Integer;
var
  job, sex: Integer;
begin
  Result := -1;
  job := 0;
  sex := 0;

  if not Properites.DrawOtherStateInfo then
  begin
    if g_MySelf <> nil then
    begin
      job := g_MySelf.m_btJob;
      sex := g_MySelf.m_btSex;
    end;
  end
  else
  begin
    job := UserState1.job;
    sex := GenderFeature(UserState1.Feature);
  end;

  if job = _JOB_ARCHER then
  begin
    if sex = 0 then
      Result := Properites.ArcherMaleIndex
    else
      Result := Properites.ArcherFemaleIndex
  end
  else
  begin
    if sex = 0 then
      Result := Properites.MaleIndex
    else
      Result := Properites.FemaleIndex
  end;
end;

procedure InitSkillItem(D: TDSkillItem);
begin
  if g_DWinMan.StateWinType = wk195 then
  begin
    D.WIDTH := 260;
    D.Height := 40;
  end else
  begin
    D.Width := 170;
    D.Height := 40;
  end;

  D.FMagicIcon.Name := D.Name + '_Icon';
  D.FMagicIcon.Caption := D.Caption + '_图标';
  D.FMagicIcon.Left := 4;
  D.FMagicIcon.Top := 4;
  D.FMagicIcon.WIDTH := 33;
  D.FMagicIcon.Height := 31;
  D.FMagicIcon.OnClick := FrmDlg.MagicIconClick;

  D.FSkillName.Name := D.Name + '_Name';
  D.FSkillName.Caption := D.Caption + '_名称';
  D.FSkillName.Left := 44;
  D.FSkillName.Top := 7;
  D.FSkillName.Propertites.Caption.Text := '未定义';

  D.FLevelText.Name := D.Name + '_Level';
  D.FLevelText.Caption := D.Caption + '_等级';
  D.FLevelText.Propertites.Caption.Text := '3';
  D.FLevelText.Left := 62;
  D.FLevelText.Top := 22;

  D.FExpText.Name := D.Name + '_Exp';
  D.FExpText.Caption := D.Caption + '_熟练度';
  D.FExpText.Left := 91;
  D.FExpText.Top := 22;
  D.FExpText.Propertites.Caption.Text := '0/100';

  D.FLVIcon.Name := D.Name + '_LevelImage';
  D.FLVIcon.Caption := D.Caption + '_等级图标';
  D.FLVIcon.Left := 45;
  D.FLVIcon.Top := 22;
  D.FLVIcon.SetImgIndex(g_WMainImages, 112);

  D.FEXPICon.Name := D.Name + '_ExpImage';
  D.FEXPICon.Caption := D.Caption + '_熟练度图标';
  D.FEXPICon.Left := 70;
  D.FEXPICon.Top := 22;
  D.FEXPICon.SetImgIndex(g_WMainImages, 111);

  D.FQuickKey.Name := D.Name + '_QuickKey';
  D.FQuickKey.Caption := D.Caption + '_快捷键';
  if g_DWinMan.StateWinType = wk195 then
  begin
    D.FQuickKey.Top := 10;
    D.FQuickKey.Left := 176;
    D.FQuickKey.WIDTH := 24;
    D.FQuickKey.Height := 24;
  end else
  begin
    D.FQuickKey.Top := 5;
    D.FQuickKey.Left := 139;
    D.FQuickKey.WIDTH := 24;
    D.FQuickKey.Height := 24;
  end;

  D.FQuickKey.SetImgIndex(g_WMain3Images, -1);
end;

procedure SetSkillItemUIData2(D: TDSkillItem; Magic: pTClientMagic);
var
  KeyImg: Integer;
begin
  D.FMagic := Magic;
  if Magic = nil then
  begin
    D.FSkillName.Propertites.Caption.Text := '';
    D.FLevelText.Propertites.Caption.Text := '';
    D.FExpText.Propertites.Caption.Text := '';
    D.FMagicIcon.OnDirectPaint := nil;
    D.FQuickKey.Propertites.ImageIndex := -1;
    D.FMagicIcon.OnMouseMove := nil;
    D.FLVIcon.visible := False;
    D.FEXPICon.visible := False;
  end
  else
  begin

    D.FSkillName.Propertites.Caption.Text := Magic.sMagicName;

    D.FLevelText.Propertites.Caption.Text := IntToStr(Magic.Level);
    if Magic.Level = 3 then
      D.FExpText.Propertites.Caption.Text := '-'
    else
      D.FExpText.Propertites.Caption.Text := Format('%d/%d', [Magic.CurTrain, Magic.MaxTrain]);

    D.FMagicIcon.OnDirectPaint := FrmDlg.DMagicItemIconDirectPaint;

    D.FMagicIcon.OnMouseMove := FrmDlg.DMagicItemMouseMove;

    KeyImg := -1;
    case Byte(Magic.Key) of
      Byte('1'):
        KeyImg := 156;
      Byte('2'):
        KeyImg := 157;
      Byte('3'):
        KeyImg := 158;
      Byte('4'):
        KeyImg := 159;
      Byte('5'):
        KeyImg := 160;
      Byte('6'):
        KeyImg := 161;
      Byte('7'):
        KeyImg := 162;
      Byte('8'):
        KeyImg := 163;
      Byte('E'):
        KeyImg := 148;
      Byte('F'):
        KeyImg := 149;
      Byte('G'):
        KeyImg := 150;
      Byte('H'):
        KeyImg := 151;
      Byte('I'):
        KeyImg := 152;
      Byte('J'):
        KeyImg := 153;
      Byte('K'):
        KeyImg := 154;
      Byte('L'):
        KeyImg := 155;
    end;

    D.FQuickKey.Propertites.ImageIndex := KeyImg;
    D.FLVIcon.visible := True;
    D.FEXPICon.visible := True;
  end;
end;

procedure SetSkillItemUIData(Index: Integer; Magic: pTClientMagic);
var
  D: TDSkillItem;
begin
  D := nil;
  case index of
    0:
      D := FrmDlg.DSkillItem1;
    1:
      D := FrmDlg.DSkillItem2;
    2:
      D := FrmDlg.DSkillItem3;
    3:
      D := FrmDlg.DSkillItem4;
    4:
      D := FrmDlg.DSkillItem5;
    5:
      D := FrmDlg.DSkillItem6;
  end;
  if D <> nil then
    SetSkillItemUIData2(D, Magic);
end;

procedure UpDataSkillItemData(D: TDSkillItem);
begin
  SetSkillItemUIData2(D, D.FMagic)
end;

procedure SetTitleItemUIData(Index: Integer; Title: pTClientHumTitle);
var
  Button: TDButton;
  DTextField: TDTextField;
begin
  Button := nil;
  DTextField := nil;
  case index of
    0:
      begin
        Button := FrmDlg.DBTitle1;
        DTextField := FrmDlg.DTTitle1;
      end;
    1:
      begin
        Button := FrmDlg.DBTitle2;
        DTextField := FrmDlg.DTTitle2;
      end;
    2:
      begin
        Button := FrmDlg.DBTitle3;
        DTextField := FrmDlg.DTTitle3;
      end;
    3:
      begin
        Button := FrmDlg.DBTitle4;
        DTextField := FrmDlg.DTTitle4;
      end;
    4:
      begin
        Button := FrmDlg.DBTitle5;
        DTextField := FrmDlg.DTTitle5;
      end;
    5:
      begin
        Button := FrmDlg.DBTitle6;
        DTextField := FrmDlg.DTTitle6;
      end;
  end;

  if Title <> nil then
  begin
    DTextField.visible := True;
    Button.SetImgIndex(g_77Title, Title.Item.Looks);
    Button.Data := Title;
    DTextField.Propertites.Caption.Text := Title.Item.sName;
  end
  else
  begin
    Button.SetImgIndex(g_77Title, -1);
    DTextField.visible := False;
  end;
end;

function GetDrawItemControlItem(ItemProperty: TDrawItemProperties)
  : PTClientItem;
var
  Index: Integer;
begin
  Result := nil;
  Index := ItemProperty.ItemIndex;
  case ItemProperty.ItemGroupType of
    igtItemBag:
      begin
        if (Index >= Low(g_ItemArr)) and (Index <= High(g_ItemArr)) then
          Result := @g_ItemArr[Index];

      end;
    igtUseItem:
      begin
        if (Index >= Low(g_UseItems)) and (Index <= High(g_UseItems)) then
        begin
          Result := @g_UseItems[Index];
        end;
      end;
    igtStoreItem:
      begin
//        if Index < g_SaveItemList.Count then
//          Result := PTClientItem(g_SaveItemList[Index]);
      end;
    igtCustomItem:
      ;
  end;

  if Result.Name = '' then
    Result := nil;
end;

procedure DrawItemUI(dsurface: TAsphyreCanvas; Sender: TDDrawItemImage;
  ItemProperty: TDrawItemProperties);
var
  PItem: PTClientItem;
  ImageLib: TWMImages;
  Index: Integer;
  nLook: Integer;
  D: TAsphyreLockableTexture;
  nX, nY, X, Y, ax, ay: Integer;
  ATexture: TAsphyreLockableTexture;
  boDraw: Boolean;
begin

  PItem := GetDrawItemControlItem(ItemProperty);

  if (pItem = nil) and  (ItemProperty.ItemIndex =  U_HELMET) then
  begin
    if g_UseItems[U_ZHULI].Name <> '' then
      pItem := @g_UseItems[U_ZHULI];
  end;
  
  // 如果没有获取到物品则直接退出
  if (PItem = nil) then
    Exit;
  X := Sender.SurfaceX(Sender.Left);
  Y := Sender.SurfaceY(Sender.Top);
  nLook := PItem^.Looks;
  ImageLib := nil;
  case ItemProperty.ItemFileType of
    dipStateItem:
      begin
        if nLook > 9999 then
        begin
          ImageLib := g_77WStateItemImages;
          nLook := nLook - 10000;
        end
        else
          ImageLib := g_WStateItemImages
      end;
    dipBagItem:
      begin
        if nLook > 9999 then
        begin
          ImageLib := g_77WBagItemImages;
          nLook := nLook - 10000;
        end
        else
          ImageLib := g_WBagItemImages;

      end;
  end;

  boDraw := False;

  if ItemProperty.ItemFileType = dipStateItem then
  begin
    nX := Sender.Left + Sender.DrawItemProperty.OffsetX;
    nY := Sender.Top + Sender.DrawItemProperty.OffsetY;
    case ItemProperty.ItemIndex of
      U_DRESS:
        begin
          with Sender do
          begin

            if g_MyDressInnerEff <> nil then
              g_MyDressInnerEff.Draw(dsurface, SurfaceX(nX), SurfaceY(nY))
            else
              DressStateDrawBlend(g_UseItems[U_DRESS].S.Shape,
                g_UseItems[U_DRESS].AniCount, TimeTick, dsurface,
                SurfaceX(nX), SurfaceY(nY));

            D := GetDressStateItemImgXY(g_MySelf.m_btJob, g_MySelf.m_btSex,
              g_UseItems[U_DRESS], ax, ay);
            if D <> nil then
            begin
              if g_MySelf.m_nBlendColor > 0 then
              begin
                dsurface.DrawColor(SurfaceX(nX + ax), SurfaceY(nY + ay), D,
                  g_MySelf.m_nBlendColor);
              end
              else
              begin
                dsurface.Draw(SurfaceX(nX + ax), SurfaceY(nY + ay),
                  D.ClientRect, D, True);
              end;
            end;


          end;
          boDraw := True;
        end;
      U_WEAPON:
        begin
          with Sender do
          begin
            D := GetStateItemImgXY(g_UseItems[U_WEAPON].Looks, ax, ay);
            if D <> nil then
            begin
              if g_MySelf.m_nWeaponBlendColor > 0 then
              begin
                dsurface.DrawColor(SurfaceX(nX + ax), SurfaceY(nY + ay), D,
                  g_MySelf.m_nWeaponBlendColor);
              end
              else
              begin
                dsurface.Draw(SurfaceX(nX + ax), SurfaceY(nY + ay),
                  D.ClientRect, D, True);
              end;
            end;

            if g_MyWeponInnerEff <> nil then
              g_MyWeponInnerEff.Draw(dsurface, SurfaceX(nX), SurfaceY(nY))
            else
              WeponStateDrawBlend(g_UseItems[U_WEAPON].S.Shape,
                g_UseItems[U_WEAPON].AniCount, TimeTick, dsurface,
                SurfaceX(nX), SurfaceY(nY));
          end;
          boDraw := True;
        end;
      U_SHIED:
        begin
          with Sender do
          begin
            D := GetStateItemImgXY(g_UseItems[U_SHIED].Looks, ax, ay);
            if D <> nil then
              dsurface.Draw(SurfaceX(nX + ax), SurfaceY(nY + ay),
                D.ClientRect, D, True);
            ShieldDrawBlend(g_UseItems[U_SHIED].S.Shape,
              g_UseItems[U_SHIED].AniCount, TimeTick, dsurface, SurfaceX(nX),
              SurfaceY(nY));
          end;
          boDraw := True;
        end;

      U_FASHION:
        begin
          with Sender do
          begin
            D := GetStateItemImgXY(g_UseItems[U_FASHION].Looks, ax, ay);
            if D <> nil then
              dsurface.Draw(SurfaceX(nX + ax), SurfaceY(nY + ay),
                D.ClientRect, D, True);
            DressStateDrawBlend(g_UseItems[U_FASHION].S.Shape,
              g_UseItems[U_FASHION].AniCount, TimeTick, dsurface,
              SurfaceX(nX), SurfaceY(nY));
          end;
        end;

      U_HELMET :
        begin
          //不能绘制头盔
          if (g_UseItems[U_ZHULI].Name <> '') and (g_UseItems[U_ZHULI].S.Reserved = 1) then
          begin
            boDraw := True;
          end else if (g_UseItems[U_ZHULI].Name <> '') and (g_UseItems[U_ZHULI].S.Reserved = 0) then
          begin
            with Sender do
            begin
               D := GetStateItemImgXY(g_UseItems[U_ZHULI].Looks, ax, ay);
             
               if D <> nil then
                dsurface.Draw(SurfaceX(nX + ax), SurfaceY(nY + ay) + 2,
                  D.ClientRect, D, True);
              DressStateDrawBlend(g_UseItems[U_ZHULI].S.Shape,
                g_UseItems[U_ZHULI].AniCount, TimeTick, dsurface,
                SurfaceX(nX), SurfaceY(nY) + 2);
            end;

            if nLook = g_UseItems[U_ZHULI].Looks then
            begin
              boDraw := True;
            end;
          end;
        end;

    end;
  end;

  // 前面绘制过了就不要再绘制这里了 前面需要对武器和衣服进行特殊处理
  if not boDraw then
  begin
    D := ImageLib.GetCachedImage(nLook, nX, nY);
    if D <> Nil then
    begin
      nX := Sender.DrawItemProperty.OffsetX + nX;
      nY := Sender.DrawItemProperty.OffsetY + nY;
      if Sender.DrawItemProperty.InCenter then
      begin
        dsurface.Draw(nX + X + (Sender.WIDTH - D.WIDTH) div 2,
          nY + Y + (Sender.Height - D.Height) div 2, D.ClientRect, D, True);
      end
      else
      begin
        dsurface.Draw(nX + X, nY + Y, D.ClientRect, D, True);
      end;
    end;
  end;

  if ItemProperty.ItemFileType = dipBagItem then
  begin
    //if SetContain(PItem.BindState, _ITEM_STATE_BIND) then
    if PItem.State.Bind then
    begin
      D := g_77Images.Images[102];
      if D <> nil then
        dsurface.Draw(X + 1, Y + (Sender.Height - D.Height) - 1,
          D.ClientRect, D, True);
    end;

    if (PItem.S.StdMode in [{$I AddinStdmode.INC}]) and (PItem.Dura > 1) then
    begin
      ATexture := FontManager.
        Default.TextOut('x' + IntToSortString(PItem.Dura));
      if ATexture <> nil then
        dsurface.DrawBoldText(X + (Sender.WIDTH + D.WIDTH) div 2 -
          ATexture.WIDTH + 1, Y + (Sender.Height + D.Height) div 2 -
          ATexture.Height + 1, ATexture, clWhite, FontBorderColor);
    end;

    if PItem.Index >= 0 then
    begin
      if PItem.AddProperty.Light > 0 then
        ItemFlashDrawBlend(PItem.AddProperty.Light, Sender.TimeTick,
          dsurface, X, Y)
      else if PItem.CustomEff > 0 then
        ItemFlashDrawBlendEx(PItem, dsurface, Sender.WIDTH,
          Sender.Height, X, Y);
    end;
  end;

end;

// TODO
procedure DrawItemUIMouseMove(Sender: TDDrawItemImage;
  ItemProperty: TDrawItemProperties);
var
  PItem: PTClientItem;
begin

end;

procedure DrawItem(Item: TClientItem; dsurface: TAsphyreCanvas;
  X, Y, CellWidth, CellHeight: Integer; TimeTick: LongWord;ItemFrom : TDrawItemFileType);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
  nLook: Integer;
begin
  if Item.Name = '' then
    Exit;

  case Item.Index of
    - 2:
      D := g_WBagItemImages.Images[1186];
    -3:
      D := g_WBagItemImages.Images[1185];
    -4:
      D := g_WBagItemImages.Images[2155];
    -5:
      D := g_WBagItemImages.Images[2156];
    -6:
      D := g_WBagItemImages.Images[1189];
    -7:
      D := g_WBagItemImages.Images[1187];
    -8:
      D := g_WBagItemImages.Images[122];
  else
    if Item.Looks > 9999 then
      D := g_77WBagItemImages.Images[Item.Looks - 10000]
    else
      D := g_WBagItemImages.Images[Item.Looks];

  end;
  if D <> nil then
  begin
    dsurface.Draw(X + (CellWidth - D.WIDTH) div 2, Y + (CellHeight - D.Height)
      div 2, D.ClientRect, D, True);

//    if (Item.BindState > 0) and SetContain(Item.BindState,
//      _ITEM_STATE_BIND) then
    if Item.State.Bind then
    begin
      D := g_77Images.Images[102];
      if D <> nil then
        dsurface.Draw(X + 1, Y + (CellHeight - D.Height) - 1,
          D.ClientRect, D, True);
    end;

    if (Item.S.StdMode in [{$I AddinStdmode.INC},71]) and (Item.Dura > 1) then
    begin
      ATexture := FontManager.Default.TextOut('x' + IntToSortString(Item.Dura));
      if ATexture <> nil then
        dsurface.DrawBoldText(X + (CellWidth + D.WIDTH) div 2 - ATexture.WIDTH +
          1, Y + (CellHeight + D.Height) div 2 - ATexture.Height + 1, ATexture,
          clWhite, FontBorderColor);
    end;
    if Item.Index >= 0 then
    begin
      if ItemFrom = dipBagItem then
      begin

        if Item.AddProperty.Light > 0 then
          ItemFlashDrawBlend(Item.AddProperty.Light, TimeTick, dsurface, X, Y)
        else if Item.CustomEff > 0 then
          ItemFlashDrawBlendEx(@Item, dsurface, CellWidth, CellHeight, X, Y);
      end else
      begin
        if Item.CustomEff > 0 then
          ItemFlashDrawBlendEx_StateItem(@Item, dsurface, CellWidth, CellHeight, X, Y)
        else if Item.AddProperty.Light > 0 then
          ItemFlashDrawBlend(Item.AddProperty.Light, TimeTick, dsurface, X, Y)
      end;
    end;
  end;
end;

procedure DrawShopItem(Item: TShopItem; dsurface: TAsphyreCanvas;
  X, Y, CellWidth, CellHeight: Integer; TimeTick: LongWord);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
begin
  if Item.Name = '' then
    Exit;

  if Item.StdItem.Looks > 9999 then
    D := g_77WBagItemImages.Images[Item.StdItem.Looks - 10000]
  else
    D := g_WBagItemImages.Images[Item.StdItem.Looks];
  if D <> nil then
  begin
    dsurface.Draw(X + (CellWidth - D.WIDTH) div 2, Y + (CellHeight - D.Height)
      div 2, D.ClientRect, D, True);
    if Item.State.Bind then
    begin
      D := g_77Images.Images[102];
      if D <> nil then
        dsurface.Draw(X + 1, Y + (CellHeight - D.Height) - 1,
          D.ClientRect, D, True);
    end;
    if (Item.StdItem.StdMode in [{$I AddinStdmode.INC}]) and
      (Item.StdItem.DuraMax > 1) then
    begin
      ATexture := FontManager.Default.TextOut('x1');
      if ATexture <> nil then
        dsurface.DrawBoldText(X + (CellWidth + D.WIDTH) div 2 - ATexture.WIDTH +
          1, Y + (CellHeight + D.Height) div 2 - ATexture.Height + 1, ATexture,
          clWhite, FontBorderColor);
    end;
    ItemFlashDrawBlend(Item.AddProperty.Light, TimeTick, dsurface, X, Y);
  end;
end;

procedure DrawTextItem(Surface: TAsphyreCanvas; X, Y, WIDTH: Integer);
var
  D: TAsphyreLockableTexture;
  I: Integer;
begin
  D := g_77Images.Images[60];
  if D <> nil then
    Surface.Draw(X, Y, D);
  D := g_77Images.Images[61];
  if D <> nil then
    for I := X + 12 - 1 to X + WIDTH - 12 do
      Surface.Draw(I, Y, D);
  D := g_77Images.Images[62];
  if D <> nil then
    Surface.Draw(X + WIDTH - 12, Y, D);
end;

procedure TFrmDlg.FormCreate(Sender: TObject);
begin
  FUILoaded := False;
  FExtendButtons := TList<TdxExtendButton>.Create;
  FTopExtendButtons := TList<TdxExtendButton>.Create;
  FBufferControls := TList<TuDBufferControl>.Create;
  FDlgMessage := TuMerchantMessage.Create;
  FDlgMessage.OnDrawBackGround := DrawMessageBackGround;
  FDlgMessage.OnGetItemImages := DoMessageGetItemImages;
  DChatBox.OnDownInRealArea := DChatBoxDownInRealArea;
  ShopKind := 0;
  ShopTabPage := 0;
  FBloodTick := 0;
  MarketListIndex := -1;
  MarketListPage := 0;
  ISMarketList := True;
  StallItemState := ssNone;
  SetMarketTabIndex(0);
  // frmMain.DXDraw.Initialize;
  // ItemLightImgIdx := 0; //初始化物品发光图片ID为0 20080223
  BatterTime := GetTickCount;
  BatterImage := 0;
  BatterSelMenu := 0;
  g_boBoxsMiddleItems := False; // 初始化宝箱物品为中间
  LevelOrderPage := 0;
  g_nBoxsImg := 0;
  g_BoxsFlashImg := 0;
  HeroStatePage := 0;
  HeroMagicPage := 0;
  DlgTemp := TList.Create;

  magcur := 0;
  magtop := 0;
  HeroMagTop := 0;
  MDlgPoints := TList.Create;
//  MenuList := TList.Create;
//  SelectMenuIndex := -1;
//  MenuIndex := -1;
  MenuTopLine := 0;
  BoDetailMenu := False;
  BoNoDisplayMaxDura := False;
  BoMakeDrugMenu := False;
  MagicPage := 0;
  InternalForceMagicPage := 0;
  HeroInternalForceMagicPage := 0;
  NAHelps := TStringList.Create;
  BlinkTime := GetTickCount;
  BlinkCount := 0;
  BottomSurface := nil;

  g_ShopPage := 0;
  ShopGifFrame := 0;
  imginsex := 0;
  FSendGoldType := 0;
  FBuyAttGoldType := 0;

  g_SellDlgItem.Name := '';
  FItemIndex := 0;
  g_PlayDrinkPoints := TList.Create; // 20080515

  if FrmMain <> nil then
  begin
//    EdDlgEdit := TEdit.Create(FrmMain.Owner);
//    with EdDlgEdit do
//    begin
//      Parent := FrmMain;
//      Color := clBlack;
//      Font.Color := clWhite;
//      Font.Size := 9;
//      MaxLength := 30;
//      Height := 16;
//      Ctl3d := False;
//      BorderStyle := bsSingle; { OnKeyPress := EdDlgEditKeyPress; }
//      visible := False;
//    end;
    FGuildMemo := TMemo.Create(FrmMain);
    FGuildMemo.Parent := FrmMain;
    FGuildMemo.visible := False;
    FGuildMemo.WIDTH := 571;
    FGuildMemo.Height := 246;
    FGuildMemo.Color := clBlack;
    FGuildMemo.Font.Color := clWhite;
    FGuildMemo.Font.Size := 9;
    FGuildMemo.Ctl3d := False;
    FGuildMemo.BorderStyle := bsSingle;
    DScreen.OnClickHintInited := DoClickHintInited;
  end;
  FMessageBoxList := TList.Create;
  FSideButtons := TStringList.Create;
end;

procedure TFrmDlg.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  FDlgMessage.Free;
  DlgTemp.Free;
  for I := 0 to MDlgPoints.Count - 1 do
  begin // 20080718释放内存
    if pTClickPoint(MDlgPoints[I]) <> nil then
      Dispose(pTClickPoint(MDlgPoints[I]));
  end;
  FreeAndNilEx(MDlgPoints);
  for I := 0 to FMessageBoxList.Count - 1 do
    FreeMem(FMessageBoxList[I]);
  FMessageBoxList.Free;
  if BottomSurface <> nil then
    FreeAndNilEx(BottomSurface);
  g_PlayDrinkPoints.Free;
  //MenuList.Free;
  NAHelps.Free;
  ClearExtendButtons;
  FExtendButtons.Free;
  FTopExtendButtons.Free;
  FBufferControls.Free;
  FSideButtons.Free;
end;

procedure TFrmDlg.HideAllControls;
var
  I: Integer;
  c: TControl;
begin
  DlgTemp.Clear;
  with FrmMain do
    if ControlCount > 0 then
      for I := 0 to ControlCount - 1 do
      begin
        c := Controls[I];
        if (c is TEdit) or (c is TMemo) then
          if (c.visible) and (c <> EdtMsgDlg) then
          begin
            DlgTemp.Add(c);
            c.visible := False;
          end;
      end;
end;

procedure TFrmDlg.RestoreHideControls;
var
  I: Integer;
begin
  if DlgTemp.Count > 0 then // 20080629
    for I := 0 to DlgTemp.Count - 1 do
    begin
      TControl(DlgTemp[I]).visible := True;
    end;
end;

procedure TFrmDlg.InitializeForLogin;

  procedure SetButtomImage(AButton: TDButton; Lib: TWMImages; Index: Integer;
    DefWidth, DefHeight, DefLeft, DefTop: Integer);
  begin
    AButton.SetImgIndexEx(Lib, Index, DefWidth, DefHeight, DefLeft, DefTop);
    AButton.Propertites.MoveIndex := Index + 1;
    AButton.Propertites.DownedIndex := Index + 2;
  end;

  procedure SetNormalButtomImage(AButton: TDButton; Lib: TWMImages;
    Index: Integer; DefWidth, DefHeight, DefLeft, DefTop: Integer);
  begin
    AButton.SetImgIndexEx(Lib, Index, DefWidth, DefHeight, DefLeft, DefTop);
    AButton.Propertites.MoveIndex := -1;
    AButton.Propertites.DownedIndex := Index + 1;
  end;

  procedure SetDownButtomImage(AButton: TDButton; Lib: TWMImages;
    X, Y, Index: Integer);
  begin
    AButton.SetImgIndex(Lib, Index);
    AButton.Propertites.ImageIndex := -1;
    AButton.Propertites.DownedIndex := Index;
    AButton.Propertites.Left := X;
    AButton.Propertites.Top := Y;
  end;

  procedure SetDownButtomImage2(AButton: TDButton; Lib: TWMImages;
    Index: Integer);
  begin
    AButton.SetImgIndex(Lib, Index);
    AButton.Propertites.ImageIndex := -1;
    AButton.Propertites.DownedIndex := Index;
  end;

  procedure SetMir4SelChrButton(AButton: TDButton; Lib: TWMImages;
    Index: Integer);
  begin
    AButton.SetImgIndex(Lib, Index);
    AButton.Propertites.MoveIndex := Index + 1;
    AButton.Propertites.DownedIndex := Index + 2;
    Abutton.Propertites.DisabledIndex := Index +3;
  end;

  procedure SetNormalSelChrButton(AButton: TDButton; Lib: TWMImages;
    Index: Integer);
  begin
    AButton.SetImgIndex(Lib, Index);
    AButton.Propertites.ImageIndex := -1;
    AButton.Propertites.MoveIndex := Index ;
    AButton.Propertites.DownedIndex := Index;
  end;

var
  D: TAsphyreLockableTexture;
  nx,ny:Integer;
begin
  g_DWinMan.ClearAll;
  DBackground.Left := 0;
  DBackground.Top := 0;
  DBackground.WIDTH := SCREENWIDTH;
  DBackground.Height := SCREENHEIGHT;
  DBackground.Background := True;
  g_DWinMan.AddDControl(DBackground, True);

  { ----------------------------------------------------------- }
  DLogIn.Left := (SCREENWIDTH - DLogIn.WIDTH) div 2;
  DLogIn.Top := (SCREENHEIGHT - DLogIn.Height) div 2;

  { ----------------------------------------------------------- }
  // 服务器选择窗口
  case g_DWinMan.UIType of
    skNormal:
      begin
        DSelServerDlg.WIDTH := 308;
        DSelServerDlg.Height := 450;
        DSelServerDlg.SetImgIndex(g_WMainImages, 256);
        SetNormalButtomImage(DSServer1, g_WMain3Images, 2, 168, 41, 65, 100);
        SetNormalButtomImage(DSServer2, g_WMain3Images, 2, 168, 41, 65, 145);
        SetNormalButtomImage(DSServer3, g_WMain3Images, 2, 168, 41, 65, 190);
        SetNormalButtomImage(DSServer4, g_WMain3Images, 2, 168, 41, 65, 235);
        SetNormalButtomImage(DSServer5, g_WMain3Images, 2, 168, 41, 65, 280);
        SetNormalButtomImage(DSServer6, g_WMain3Images, 2, 168, 41, 65, 325);
        DSSrvClose.SetImgIndex(g_WMainImages, 64);
        DSSrvClose.Propertites.ImageIndex := -1;
        DSSrvClose.Left := 245;
        DSSrvClose.Top := 31;
      end;
    skReturn:
      begin
        DSelServerDlg.WIDTH := 276;
        DSelServerDlg.Height := 390;
        DSelServerDlg.SetImgIndex(g_WUi3Images, 2802);
        SetButtomImage(DSServer1, g_WUi3Images, 2803, 182, 36, 47, 86);
        SetButtomImage(DSServer2, g_WUi3Images, 2803, 182, 36, 47, 126);
        SetButtomImage(DSServer3, g_WUi3Images, 2803, 182, 36, 47, 166);
        SetButtomImage(DSServer4, g_WUi3Images, 2803, 182, 36, 47, 206);
        SetButtomImage(DSServer5, g_WUi3Images, 2803, 182, 36, 47, 246);
        SetButtomImage(DSServer6, g_WUi3Images, 2803, 182, 36, 47, 286);
        DSSrvClose.visible := False;
      end;
    skMir4:
      begin
        DSelServerDlg.WIDTH := 300;
        DSelServerDlg.Height := 419;
        DSelServerDlg.SetImgIndex(g_WUINImages, 253);
        SetButtomImage(DSServer1, g_WUINImages, 250, 178, 44, 61, 80);
        SetButtomImage(DSServer2, g_WUINImages, 250, 178, 44, 61, 130);
        SetButtomImage(DSServer3, g_WUINImages, 250, 178, 44, 61, 180);
        SetButtomImage(DSServer4, g_WUINImages, 250, 178, 44, 61, 230);
        SetButtomImage(DSServer5, g_WUINImages, 250, 178, 44, 61, 280);
        SetButtomImage(DSServer6, g_WUINImages, 250, 178, 44, 61, 330);
        DSSrvClose.visible := False;
      end;
  end;
  DSelServerDlg.Left := (SCREENWIDTH - DSelServerDlg.WIDTH) div 2;
  DSelServerDlg.Top := (SCREENHEIGHT - DSelServerDlg.Height) div 2;

  DEngServer1.visible := False;
  DSServer1.visible := False;
  DSServer2.visible := False;
  DSServer3.visible := False;
  DSServer4.visible := False;
  DSServer5.visible := False;
  DSServer6.visible := False;
  { ----------------------------------------------------------- }
  // 新建帐号窗口
  DNewAccountCancel.SetImgIndex(g_WMainImages, 52);
  DNewAccountCancel.Propertites.DownedIndex := 52;
  DNewAccountCancel.Propertites.ImageIndex := -1;

  DNewAccountClose.SetImgIndex(g_WMainImages, 64);
  { ----------------------------------------------------------- }
  // 修改密码窗口
  D := g_WMainImages.Images[50];
  if D <> nil then
    DChgPw.SetImgIndex(g_WMainImages, 50);
  DChgpwOk.SetImgIndex(g_WMainImages, 62);
  DChgpwCancel.SetImgIndex(g_WMainImages, 52);
  { ----------------------------------------------------------- }

  D := g_WMain3Images.Images[406];
  if D <> nil then
  begin
    dwRecoverChr.SetImgIndex(g_WMain3Images, 406);
    btnRecvChrClose.SetImgIndex(g_WMainImages, 64);
    btnRecvChrClose.Propertites.ImageIndex := -1;
    btnRecvChrClose.Propertites.DownedIndex := 64;
    btnRecover.SetImgIndex(g_WMain3Images, 407);
  end;

  //选择角色窗口
  case g_DWinMan.UIType of
    skNormal:
      begin
        DscSelect1.SetImgIndex(g_WMainImages, 66);
        DscSelect2.SetImgIndex(g_WMainImages, 67);

        SetDownButtomImage2(DscStart, g_WMainImages, 68);
        SetDownButtomImage2(DscNewChr, g_WMainImages, 69);
        SetDownButtomImage2(DscEraseChr, g_WMainImages, 70);
        SetDownButtomImage2(DscCredits, g_WMain3Images, 405);
        SetDownButtomImage2(DscExit, g_WMainImages, 72);

        // 创建角色窗口
        D := g_WMainImages.Images[73];
        if D <> nil then
          DCreateChr.SetImgIndex(g_WMainImages, 73);

        SetNormalSelChrButton(DccWarrior,g_WMainImages,74);
        SetNormalSelChrButton(DccWizzard,g_WMainImages,75);
        SetNormalSelChrButton(DccMonk,g_WMainImages,76);

        SetNormalSelChrButton(DccMale,g_WMainImages,77);
        SetNormalSelChrButton(DccFemale,g_WMainImages,78);

        DccLeftHair.Visible := False;
        DccRightHair.Visible := False;
        DccLeftHair.SetImgIndex(g_WMainImages, 79);
        DccRightHair.SetImgIndex(g_WMainImages, 80);

        SetNormalSelChrButton(DccOk,g_WMainImages,62);
        SetNormalSelChrButton(DccClose,g_WMainImages,64);

        DEChrName.Left := 70;
        DEChrName.Top := 106;
        DEChrName.Height := 18;
        DEChrName.WIDTH := 138;
        DEChrName.MaxLength := CREATECHARNAMELEN;
      end;
    skReturn:
      begin
        SetMir4SelChrButton(DscStart,g_WUi3Images,2768);
        SetMir4SelChrButton(DscNewChr,g_WUi3Images,2741);
        SetMir4SelChrButton(DscEraseChr,g_WUi3Images,2783);
        SetMir4SelChrButton(DscCredits,g_WUi3Images,2760);
        SetMir4SelChrButton(DscExit,g_WUi3Images,2790);

        DCreateChr.SetImgIndex(g_WUi3Images,2740);
        // 创建角色窗口

        SetMir4SelChrButton(DccWarrior,g_WUi3Images,2813);
        SetMir4SelChrButton(DccWizzard,g_WUi3Images,2756);
        SetMir4SelChrButton(DccMonk,g_WUi3Images,2748);
        SetMir4SelChrButton(DccAssassin,g_WUi3Images,2745);
        SetMir4SelChrButton(DccArcher,g_WUi3Images,2820);
        SetMir4SelChrButton(DccReserved,g_WUI2Images,3184);
        SetMir4SelChrButton(DccMale,g_WUi3Images,2776);
        SetMir4SelChrButton(DccFemale,g_WUi3Images,2779);
        DccOk.Propertites.Caption.Text := '提交';
        DccClose.Propertites.Caption.Text := '返回';
        SetMir4SelChrButton(DccOk,g_WUi3Images,2752);
        SetMir4SelChrButton(DccClose,g_WUi3Images,2752);
        DEChrName.Left := 36;
        DEChrName.Top := 354;
        DEChrName.Height := 18;
        DEChrName.WIDTH := 206;
        DEChrName.Transparent := True;
        // DEChrName.MaxLength := ACTORNAMELEN div SizeOf(Char);
        DEChrName.MaxLength := CREATECHARNAMELEN;
      end;
    skMir4:
      begin
        SetMir4SelChrButton(DscSelect1, g_WUINImages, 270);
        SetMir4SelChrButton(DscSelect2, g_WUINImages, 270);

        SetMir4SelChrButton(DscStart, g_WUINImages, 276);
        SetMir4SelChrButton(DscNewChr, g_WUINImages, 261);
        SetMir4SelChrButton(DscEraseChr, g_WUINImages, 267);
        SetMir4SelChrButton(DscCredits, g_WUINImages, 264);
        SetMir4SelChrButton(DscExit, g_WUINImages, 230);
        DscExit.Propertites.MoveIndex := 237;
        DscExit.Propertites.DownedIndex := 238;

        // 创建角色窗口
        DCreateChr.SetImgIndex(g_WUINImages, 279);
        SetMir4SelChrButton(DccWarrior,g_WUINImages,55);
        SetMir4SelChrButton(DccWizzard,g_WUINImages,46);
        SetMir4SelChrButton(DccMonk,g_WUINImages,43);
        SetMir4SelChrButton(DccAssassin,g_WUINImages,40);
        DccArcher.visible := False;
        DccReserved.visible := False;

        SetMir4SelChrButton(DccMale,g_WUINImages,49);
        SetMir4SelChrButton(DccFemale,g_WUINImages,52);

        SetMir4SelChrButton(DccOk,g_WUINImages,273);
        SetMir4SelChrButton(DccClose,g_WUiCommonImages,3);
        DEChrName.Left := 84;
        DEChrName.Top := 122;
        DEChrName.Height := 18;
        DEChrName.WIDTH := 176;
        DEChrName.Transparent := True;
        DEChrName.MaxLength := CREATECHARNAMELEN;
      end;
  end;
  SetMirOldButtonImageIndex(DscPriorPage,g_77Images,305);
  SetMirOldButtonImageIndex(DscNextPage,g_77Images,308);

  DscPriorPage.Propertites.ImageIndex := 305;
  DscNextPage.Propertites.ImageIndex := 308;

  // 登录场景通用
  DTNotice1.Left := 0;
  DTNotice1.Top := SCREENHEIGHT - 64;
  DTNotice1.WIDTH := SCREENWIDTH;
  DTNotice1.Height := 14;

  DTNotice2.Left := 0;
  DTNotice2.Top := SCREENHEIGHT - 44;
  DTNotice2.WIDTH := SCREENWIDTH;
  DTNotice2.Height := 14;

  DTNotice3.Left := 0;
  DTNotice3.Top := SCREENHEIGHT - 24;
  DTNotice3.WIDTH := SCREENWIDTH;
  DTNotice3.Height := 14;

  DTAPP_Version.Left := 16;
  DTAPP_Version.Top := 16;

  DALoginFire1.Propertites.visible := False;
  DALoginFire2.Propertites.visible := False;
  DALoginFire3.Propertites.visible := False;
  DALoginFire4.Propertites.visible := False;
  // 登录场景
  case g_DWinMan.UIType of
    skNormal:
      begin
        DTRegHint.visible := False;
        DTAccount.visible := False;
        DTPassWord.visible := False;
        DPLoginPanel.visible := False;
        DALoginEffect.visible := False;


        DILoginBGP.SetImgIndex(g_WChrSelImages, 22);

        DILoginBGP.Propertites.InCenter := True;

        DAOpenDoor.Left := (DBackground.WIDTH - DAOpenDoor.WIDTH) div 2;
        DAOpenDoor.Top := (DBackground.Height - DAOpenDoor.Height) div 2;

        DELoginID.Left := 96;
        DELoginID.Top := 83;
        DELoginID.Color := clBlack;
        DELoginID.WIDTH := 140;
        DELoginID.Height := 21;

        DELoginPwd.Left := 96;
        DELoginPwd.Top := 114;
        DELoginPwd.Color := clBlack;
        DELoginPwd.WIDTH := 140;
        DELoginPwd.Height := 21;

        SetDownButtomImage(DLoginClose, g_77Images, 252, 28, 53);
        DLoginClose.Propertites.ImageIndex := 52;

        // 老版本的三个按钮
        SetDownButtomImage(DLoginOk, g_WMainImages, 170, 164, 62);
        SetDownButtomImage(DLoginNew, g_WMainImages, 25, 207, 61);
        SetDownButtomImage(DLoginChgPw, g_WMainImages, 130, 207, 53);
        DNewAccount.SetImgIndex(g_WMainImages,63);
        DNewAccountClose.SetImgIndex(g_77Images,52);
        DNewAccountClose.Propertites.DownedIndex := 53;

        DNewAccountOk.SetImgIndex(g_WMainImages,62);
        DNewAccountOk.Propertites.ImageIndex := -1;
        DNewAccountOk.Propertites.DownedIndex := 62;
        DNewAccountOk.Left := 160;
        DNewAccountOk.Top := 417;
      end;
    skReturn, skMir4:
      begin

        DLoginChgPw.visible := False;
        DLoginNew.visible := False;

        DLogIn.Propertites.ImageIndex := -1;
        DLogIn.WIDTH := 420;
        DLogIn.Height := 210;
        DLogIn.Left := (SCREENWIDTH - DLogIn.WIDTH) div 2;

        DPLoginPanel.Left := 0;
        DPLoginPanel.Top := 0;
        DPLoginPanel.WIDTH := DLogIn.WIDTH;
        DPLoginPanel.Height := DLogIn.Height;
        DPLoginPanel.Propertites.BorderColor := $3778FF;
        DPLoginPanel.Propertites.Color := clBlack;
        DPLoginPanel.Propertites.BorderPixel := 2;
        DPLoginPanel.Propertites.Alpha := 200;

        DELoginID.Left := 112;
        DELoginID.Top := 60;
        DELoginID.Propertites.BorderColor := $3778FF;
        DELoginID.Transparent := True;
        DELoginID.Color := clBlack;
        DELoginID.WIDTH := 220;
        DELoginID.Height := 21;

        DELoginPwd.Left := 112;
        DELoginPwd.Top := 98;
        DELoginPwd.Propertites.BorderColor := $3778FF;
        DELoginPwd.Transparent := True;
        DELoginPwd.Color := clBlack;
        DELoginPwd.WIDTH := 220;
        DELoginPwd.Height := 21;

        DLoginOk.Left := 110;
        DLoginOk.Top := 142;
        DLoginOk.WIDTH := 224;
        DLoginOk.Height := 28;
        DLoginOk.SetImgIndex(g_77Images, 518);
        DLoginOk.Propertites.DownedIndex := 519;

        DLoginClose.SetImgIndex(g_77Images, 520);
        DLoginClose.Propertites.DownedIndex := -1;
        DLoginClose.Left := DLogIn.WIDTH - DLoginClose.WIDTH - 4;
        DLoginClose.Top := 6;

        DTRegHint.Left := 0;
        DTRegHint.WIDTH := 420;
        DTRegHint.Top := 184;

        DTAccount.Left := 61;
        DTAccount.Top := 65;

        DTPassWord.Left := 61;
        DTPassWord.Top := 103;


        // 归来
        if g_DWinMan.UIType = skReturn then
        begin
          DALoginFire1.visible := True;
          DALoginFire2.visible := True;
          DALoginFire3.visible := True;
          DALoginFire4.visible := True;

          DILoginBGP.SetImgIndex(g_WEffectLogin, 0);
          // 归来的登录特效
          DALoginFire1.Propertites.Images := g_WEffectLogin;
          DALoginFire1.Propertites.ImageIndex := 10;
          DALoginFire1.Left := (SCREENWIDTH - DALoginFire1.WIDTH) div 2;
          DALoginFire1.Top := (SCREENHEIGHT - DALoginFire1.Height) div 2;
          DALoginFire1.Propertites.OffsetX := 220;
          DALoginFire1.Propertites.OffsetY := 240;

          DALoginFire2.Propertites.Images := g_WEffectLogin;
          DALoginFire2.Propertites.ImageIndex := 210;
          DALoginFire2.Left := (SCREENWIDTH - DALoginFire1.WIDTH) div 2;
          DALoginFire2.Top := (SCREENHEIGHT - DALoginFire1.Height) div 2;
          DALoginFire2.Propertites.OffsetX := 160;
          DALoginFire2.Propertites.OffsetY := 270;

          DALoginFire3.Propertites.Images := g_WEffectLogin;
          DALoginFire3.Propertites.ImageIndex := 260;
          DALoginFire3.Left := (SCREENWIDTH - DALoginFire1.WIDTH) div 2;
          DALoginFire3.Top := (SCREENHEIGHT - DALoginFire1.Height) div 2;
          DALoginFire3.Propertites.OffsetX := 50;
          DALoginFire3.Propertites.OffsetY := 270;

          DALoginFire4.Propertites.Images := g_WEffectLogin;
          DALoginFire4.Propertites.ImageIndex := 60;
          DALoginFire4.Left := (SCREENWIDTH - DALoginFire1.WIDTH) div 2;
          DALoginFire4.Top := (SCREENHEIGHT - DALoginFire1.Height) div 2;
          DALoginFire4.Propertites.OffsetX := 0;
          DALoginFire4.Propertites.OffsetY := 240;

          DALoginEffect.SetImgIndex(g_WEffectLogin, 310);
          DALoginEffect.Propertites.AniCount := 20;
          DALoginEffect.Propertites.AniInterval := 100;

          DAOpenDoor.Propertites.Images := g_WEffectLogin;
          DAOpenDoor.Propertites.ImageIndex := 540;
          DAOpenDoor.Propertites.AniCount := 19;
          DAOpenDoor.Propertites.OffsetX := 5;
          DAOpenDoor.Propertites.OffsetY := -60;

          if SCREENWIDTH < 1024 then
          begin
            DILoginBGP.SetImgIndex(g_WEffectLogin, 2);
            DALoginFire1.Propertites.OffsetX := 220;
            DALoginFire1.Propertites.OffsetY := 240;

            DALoginFire2.Propertites.OffsetX := 170;
            DALoginFire2.Propertites.OffsetY := 320;

            DALoginFire3.Propertites.OffsetX := 60;
            DALoginFire3.Propertites.OffsetY := 310;

            DALoginFire4.Propertites.OffsetX := 0;
            DALoginFire4.Propertites.OffsetY := 240;

            DAOpenDoor.Propertites.OffsetX := 13;
            DAOpenDoor.Propertites.OffsetY := -10;
          end;

        end
        else
        begin
          if SCREENWIDTH < 1024 then
          begin
            DILoginBGP.SetImgIndex(g_WNSelectImages, 520);
            DAOpenDoor.Propertites.Images := g_WNSelectImages;
            DAOpenDoor.Propertites.ImageIndex := 530;
            DALoginEffect.SetImgIndex(g_WNSelectImages, 550);
            DALoginEffect.Propertites.AniCount := 15;
            DALoginEffect.Propertites.AniInterval := 50;
          end
          else
          begin
            DILoginBGP.SetImgIndex(g_WNSelectImages, 490);
            DAOpenDoor.Propertites.Images := g_WNSelectImages;
            DAOpenDoor.Propertites.ImageIndex := 500;
            DALoginEffect.SetImgIndex(g_WNSelectImages, 570);
            DALoginEffect.Propertites.AniCount := 15;
            DALoginEffect.Propertites.AniInterval := 50;
          end;

        end;

        DALoginEffect.Left := (SCREENWIDTH - DALoginEffect.WIDTH) div 2;
        DALoginEffect.Top := (SCREENHEIGHT - DALoginEffect.Height) div 2;

        DILoginBGP.Propertites.InCenter := True;

        DAOpenDoor.Left := (DBackground.WIDTH - DAOpenDoor.WIDTH) div 2;
        DAOpenDoor.Top := (DBackground.Height - DAOpenDoor.Height) div 2;
        DALoginEffect.visible := True;
      end;
  end;

  DILoginBGP.Left := (SCREENWIDTH - DILoginBGP.Width) div 2 ;
  DILoginBGP.Top := (SCREENHEIGHT - DILoginBGP.Height) div 2;

  DAOpenDoor.Propertites.visible := False;
  // ==============================================================================
  // 修改密码窗口
  DChgGamePwd.Left := 190;
  DChgGamePwd.Top := 150;
  DChgGamePwdClose.Left := 291;
  DChgGamePwdClose.Top := 8;
  // ==============================================================================
  // NPC对话框
  DMsgDlg.Left := 174;
  DMsgDlg.Top := 210;
  DMsgDlgOk.Top := 126;
  DMsgDlgYes.Top := 126;
  DMsgDlgCancel.Top := 126;
  DMsgDlgNo.Top := 126;
  DCreateChr.Left := (SCREENWIDTH - 800) div 2 + 250;
  DCreateChr.Top := (SCREENHEIGHT - 600) div 2 + 91;
  // ==============================================================================
  // 修改密码窗口
  DChgPw.Left := (SCREENWIDTH - 420) div 2;
  DChgPw.Top := (SCREENHEIGHT - 299) div 2 - 1;
  DChgpwOk.Left := 182;
  DChgpwOk.Top := 252;
  DChgpwCancel.Left := 277;
  DChgpwCancel.Top := 251;
  // ==============================================================================
  // 新建帐号窗口
  DNewAccount.Left := (SCREENWIDTH - 640) div 2;
  DNewAccount.Top := (SCREENHEIGHT - 473) div 2 - 1;

  DNewAccountCancel.Left := 447;
  DNewAccountCancel.Top := 419;
  DNewAccountClose.Left := 587;
  DNewAccountClose.Top := 33;

  // ==============================================================================
  // 验证码 20080612
  DWCheckNum.Left := 300;
  DWCheckNum.Top := 200;
  DCheckNumClose.Left := 205;
  DCheckNumClose.Top := 0;
  DCheckNumOK.Left := 36;
  DCheckNumOK.Top := 113;
  DCheckNumChange.Left := 122;
  DCheckNumChange.Top := 113;
  DEditCheckNum.Left := 95;
  DEditCheckNum.Top := 8;
  DEditCheckNum.WIDTH := 90;
  DEditCheckNum.Height := 19;

  //公告窗口
  DLoginNotice.Left := (SCREENWIDTH - DLoginNotice.Width ) div 2;
  DLoginNotice.Top := (SCREENHEIGHT - DLoginNotice.Height ) div 2;
  DNoticeOK.Left := 90;
  DNoticeOK.Top := 305;

  DLoginNoticeMsg.Width := DLoginNotice.Width - 40;
  DLoginNoticeMsg.Height := DLoginNotice.Height - 90;
  DLoginNoticeMsg.Left := 23;
  DLoginNoticeMsg.Top := 20;

  LoginScene.initUI;


end;

procedure TFrmDlg.LoadCustomUI;
var
  sFileName: string;
begin
  sFileName := ResourceDir + 'UI.91UI';
  if FileExists(sFileName) then
    DWinCtl.g_DWinMan.LoadFromFile(sFileName);
end;

procedure TFrmDlg.InitStateWin;
var
  AttrLeft, AttrRight: Integer;
  AttrFixTop: Integer;
  // TabButton : TDTabButton;
  I: Integer;
  procedure SetAttrLeft(D: TDControl);
  var
    LineHeight: Integer;
  begin
    if g_DWinMan.StateWinType = wk195 then
    begin
      LineHeight := 16;
      D.Left := 38;
      D.Top := LineHeight * AttrLeft + AttrFixTop;
      Inc(AttrLeft);
    end else
    begin
      D.Propertites.AutoSize := False;
      D.Propertites.Width := 72;
      D.Propertites.Height := 12;
      D.Propertites.Align := aCenter;
      LineHeight := 20;
      D.Left := 68;
      D.Top := LineHeight * AttrLeft + AttrFixTop;
      Inc(AttrLeft);
    end;
  end;

  procedure SetAttrRight(D: TDControl);
  var
    LineHeight: Integer;
  begin
    if g_DWinMan.StateWinType = wk195 then
    begin
      LineHeight := 16;
      D.Left := 178;
      D.Top := LineHeight * AttrRight + AttrFixTop;
      Inc(AttrRight);
    end else
    begin
      D.Visible := False;
    end;
  end;

  Procedure SetStateText(LeftControl, RightControl: TDControl; Top: Integer);
  begin

    if g_DWinMan.StateWinType = wk195 then
    begin
    LeftControl.Top := Top;
    RightControl.Top := Top;
    LeftControl.Left := 40;
    RightControl.Left := 180;
    end else
    begin
    LeftControl.Top := Top + 5;
    RightControl.Top := Top + 5;
    LeftControl.Left := 10;
    RightControl.Left := 110;
    end;
  end;

// procedure SetTabButton(TabButton:TDTabButton ; Text : String);
// begin
// TabButton.TabButtonPropertites.Caption.Text := Text;
// TabButton.TabButtonPropertites.FontStyle := [fsBold];
// TabButton.TabButtonPropertites.CharYSpace := 2;
// TabButton.TabButtonPropertites.OffsetX := 6;
// TabButton.TabButtonPropertites.OffsetY := 5;
// TabButton.TabButtonPropertites.SelectdTextColor := $A8D6E8;
// TabButton.TabButtonPropertites.Caption.Color := $738BA1;
// TabButton.TabButtonPropertites.TextVert := True;
// TabButton.TabButtonPropertites.Caption.Border := clBlack;
// TabButton.TabButtonPropertites.Caption.OutLinePixel := 1;
// end;

begin
  AttrLeft := 0;
  AttrRight := 0;
  AttrFixTop := 40;
  // 人物状态窗口
  DSWDress.Tag := U_DRESS;
  DSWWeapon.Tag := U_WEAPON;
  DSWLight.Tag := U_RIGHTHAND;
  DSWHelmet.Tag := U_HELMET;
  DSWNecklace.Tag := U_NECKLACE;
  DSWArmRingR.Tag := U_ARMRINGR;
  DSWArmRingL.Tag := U_ARMRINGL;
  DSWRingR.Tag := U_RINGR;
  DSWRingL.Tag := U_RINGL;
  DSWBujuk.Tag := U_BUJUK;
  DSWBelt.Tag := U_BELT;
  DSWBoots.Tag := U_BOOTS;
  DSWCharm.Tag := U_CHARM;
  DSWZhuli.Tag := U_ZHULI;
  DWFashionDress.Tag := U_FASHION;
  DSMount.Tag := U_MOUNT;
  DSShied.Tag := U_SHIED;

  // ====================================================
  DUserState1.Left := SCREENWIDTH - DUserState1.WIDTH;
  DStateWin.Left := SCREENWIDTH - DStateWin.WIDTH;
  DStateWin.Top := 0;
   {$REGION '195人物界面初始化'}

  if g_DWinMan.StateWinType = wk195 then
  begin
    // 武器装备页
    DIStateHumImage.Left := 0;
    DIStateHumImage.Top := 0;
    DIStateHumImage.StateDrawProperty.ArcherMaleIndex := 234;
    DIStateHumImage.StateDrawProperty.ArcherFemaleIndex := 235;
    DIStateHumImage.StateDrawProperty.MaleIndex := 258;
    DIStateHumImage.StateDrawProperty.FemaleIndex := 259;
    DIStateHumImage.SetImgIndex(g_77Images, 258);
    DIStateHumImage.WIDTH := 290;
    DIStateHumImage.Height := 304;

    // ==============================================================================
    DSWJewelryBox.Left := 249;
    DSWJewelryBox.Top := 63;
    DSWJewelryBox.WIDTH := 36;
    DSWJewelryBox.Height := 32;
    DSWJewelryBox.SetImgIndex(g_77Images, 65);
    DSWJewelryBox.Propertites.DownedIndex := 66;

    DSWZodiacSigns.Left := 249;
    DSWZodiacSigns.Top := 98;
    DSWZodiacSigns.WIDTH := 36;
    DSWZodiacSigns.Height := 32;
    DSWZodiacSigns.SetImgIndex(g_77Images, 68);
    DSWZodiacSigns.Propertites.DownedIndex := 69;

    DSWLight.Left := 5;
    DSWLight.Top := 134;
    DSWLight.WIDTH := 36;
    DSWLight.Height := 32;

    DSWNecklace.Left := 247;
    DSWNecklace.Top := 134;
    DSWNecklace.WIDTH := 36;
    DSWNecklace.Height := 32;

    DSWHelmet.Left := 127;
    DSWHelmet.Top := 69;
    DSWHelmet.WIDTH := 36;
    DSWHelmet.Height := 32;

    DSWArmRingR.Left := 5;
    DSWArmRingR.Top := 177;
    DSWArmRingR.WIDTH := 36;
    DSWArmRingR.Height := 32;

    DSWArmRingL.Left := 247;
    DSWArmRingL.Top := 176;
    DSWArmRingL.WIDTH := 36;
    DSWArmRingL.Height := 32;

    DSWRingR.Left := 6;
    DSWRingR.Top := 220;
    DSWRingR.WIDTH := 36;
    DSWRingR.Height := 32;

    DSWRingL.Left := 247;
    DSWRingL.Top := 220;
    DSWRingL.WIDTH := 36;
    DSWRingL.Height := 32;

    DSMount.Left := 243;
    DSMount.Top := 263;
    DSMount.WIDTH := 36;
    DSMount.Height := 32;

    DSWWeapon.Left := 69;
    DSWWeapon.Top := 35;
    DSWWeapon.WIDTH := 46;
    DSWWeapon.Height := 134;

    DSWDress.Left := 114;
    DSWDress.Top := 100;
    DSWDress.WIDTH := 60;
    DSWDress.Height := 112;

    DSWBujuk.Left := 13;
    DSWBujuk.Top := 263;
    DSWBujuk.WIDTH := 36;
    DSWBujuk.Height := 32;

    DSWBelt.Left := 58;
    DSWBelt.Top := 263;
    DSWBelt.WIDTH := 36;
    DSWBelt.Height := 32;

    DSWBoots.Left := 104;
    DSWBoots.Top := 263;
    DSWBoots.WIDTH := 36;
    DSWBoots.Height := 32;

    DSWCharm.Left := 151;
    DSWCharm.Top := 263;
    DSWCharm.WIDTH := 36;
    DSWCharm.Height := 32;

    DSWZhuli.Left := 197;
    DSWZhuli.Top := 263;
    DSWZhuli.WIDTH := 36;
    DSWZhuli.Height := 32;

    DSShied.Left := 174;
    DSShied.Top := 117;
    DSShied.WIDTH := 32;
    DSShied.Height := 64;

    DCheckFashion.WIDTH := 78;
    DCheckFashion.Height := 17;

    // 技能页面
    DSkillItem1.Left := 15;
    DSkillItem2.Left := 15;
    DSkillItem3.Left := 15;
    DSkillItem4.Left := 15;
    DSkillItem5.Left := 15;
    DSkillItem6.Left := 15;

    DSkillItem1.Top := 9;
    DSkillItem2.Top := 55;
    DSkillItem3.Top := 100;
    DSkillItem4.Top := 146;
    DSkillItem5.Top := 192;
    DSkillItem6.Top := 239;

    InitSkillItem(DSkillItem1);
    InitSkillItem(DSkillItem2);
    InitSkillItem(DSkillItem3);
    InitSkillItem(DSkillItem4);
    InitSkillItem(DSkillItem5);
    InitSkillItem(DSkillItem6);

    DStPageUp.Left := 93;
    DStPageUp.Top := 284;
    DStPageDown.Left := 176;
    DStPageDown.Top := 284;

    DTMagicPageCount.Left := 138;
    DTMagicPageCount.Top := 284;

    DStateWinPage_Skill.SetImgIndex(g_77Images, 262);

    // 属性页面
    DStateWinPage_Attr.SetImgIndex(g_77Images, 261);
    DStateWinPage_Attr.Left := 0;
    DStateWinPage_Attr.Top := 0;

    SetAttrLeft(DTAC);
    SetAttrLeft(DTMAC);
    SetAttrLeft(DTDC);
    SetAttrLeft(DTMC);
    SetAttrLeft(DTSC);
    SetAttrLeft(DTTC);
    SetAttrLeft(DTPC);
    SetAttrLeft(DTWC);
    SetAttrLeft(DTHIT);
    SetAttrLeft(DTSPEED);
    SetAttrLeft(DTWeight);
    SetAttrLeft(DTWearWeight);
    SetAttrLeft(DTHandWeight);
    SetAttrLeft(DTFightPower);

    SetAttrRight(DTAntiMagic);
    SetAttrRight(DTAntiPoison);
    SetAttrRight(DTDrugRecovery);
    SetAttrRight(DTHPRecovery);
    SetAttrRight(DTMPRecovery);
    SetAttrRight(DTABSORBING);
    SetAttrRight(DTREBOUND);
    SetAttrRight(DTATTACKADD);
    SetAttrRight(DTPunchHit);
    SetAttrRight(DTCRITICALHIT);
    SetAttrRight(DTEXPADDRATE);
    SetAttrRight(DTITEMDROPADDRATE);
    SetAttrRight(DTGOLDDROPADDRATE);
    SetAttrRight(DTAPPENDDAMAGE);

    // 状态页面

    DStateWinPage_State.SetImgIndex(g_77Images, 260);
    DStateWinPage_State.Left := 0;
    DStateWinPage_State.Top := 0;

    SetStateText(DTJob, DTVJob, 48);
    SetStateText(DTLevelText, DTVLevel, 64);
    SetStateText(DTCredit, DTVCreditPoint, 80);
    SetStateText(DTExp, DTVEXP, 110); // 第一条横线
    SetStateText(DTMaxExp, DTVMAXEXP, 128);
    SetStateText(DTHP, DTVHP, 146);
    SetStateText(DTMP, DTVMP, 164);
    SetStateText(DTGameGoldCount, DTVGameGold, 182);
    SetStateText(DTGamePoint, DTVGamePoint, 220); // 第二条横线
    SetStateText(DTGameGlory, DTVGameGlory, 238);
    SetStateText(DTGameGird, DTVGameGird, 256);
    SetStateText(DTGameDiamond, DTVGameDiamond, 274);

    // 称号页面
    DStateWinPage_Tiltle.SetImgIndex(g_77Images, 264);
    DBTitle1.WIDTH := 32;
    DBTitle1.Height := 32;
    DBTitle1.Left := 11;
    DBTitle1.Top := 70;

    DBTitle2.WIDTH := 32;
    DBTitle2.Height := 32;
    DBTitle2.Left := 11;
    DBTitle2.Top := 109;

    DBTitle3.WIDTH := 32;
    DBTitle3.Height := 32;
    DBTitle3.Left := 11;
    DBTitle3.Top := 148;

    DBTitle4.WIDTH := 32;
    DBTitle4.Height := 32;
    DBTitle4.Left := 11;
    DBTitle4.Top := 187;

    DBTitle5.WIDTH := 32;
    DBTitle5.Height := 32;
    DBTitle5.Left := 11;
    DBTitle5.Top := 226;

    DBTitle6.WIDTH := 32;
    DBTitle6.Height := 32;
    DBTitle6.Left := 11;
    DBTitle6.Top := 265;

    DTTitle1.Propertites.Caption.Text := '未定意思';
    DTTitle1.Left := 51;
    DTTitle1.Top := 78;

    DTTitle2.Propertites.Caption.Text := '未定意思';
    DTTitle2.Left := 51;
    DTTitle2.Top := 119;

    DTTitle3.Propertites.Caption.Text := '未定意思';
    DTTitle3.Left := 51;
    DTTitle3.Top := 158;

    DTTitle4.Propertites.Caption.Text := '未定意思';
    DTTitle4.Left := 51;
    DTTitle4.Top := 198;

    DTTitle5.Propertites.Caption.Text := '未定意思';
    DTTitle5.Left := 51;
    DTTitle5.Top := 236;

    DTTitle6.Propertites.Caption.Text := '未定意思';
    DTTitle6.Left := 51;
    DTTitle6.Top := 274;

    DBActivveTitle.Left := 29;
    DBActivveTitle.Top := 4;
    DBActivveTitle.WIDTH := 38;
    DBActivveTitle.Height := 38;

    DTActivveTitle.Left := 75;
    DTActivveTitle.Top := 16;

    DBTitlePre.Left := 131;
    DBTitlePre.Top := 131;
    DBTitlePre.WIDTH := 13;
    DBTitlePre.Height := 23;
    DBTitlePre.SetImgIndex(g_77Images,415);
    DBTitlePre.Propertites.DownedIndex := 417;
    DBTitlePre.Propertites.MoveIndex := 416;

    DBTitleNext.Left := 131;
    DBTitleNext.Top := 185;
    DBTitleNext.WIDTH := 13;
    DBTitleNext.Height := 23;
    DBTitleNext.SetImgIndex(g_77Images,412);
    DBTitleNext.Propertites.DownedIndex := 414;
    DBTitleNext.Propertites.MoveIndex := 413;

    DBTitleInfo.WIDTH := 140;
    DBTitleInfo.Height := 220;
    DBTitleInfo.Left := 150;
    DBTitleInfo.Top := 78;

    // 时装页面
    DIStateHumImage_fashion.Left := 0;
    DIStateHumImage_fashion.Top := 0;

    TTabState.Left := 7;
    TTabState.Top := 126;
    TTabState.WIDTH := 22;
    TTabState.Height := 250;
    TTabState.SheetCount := 6;

    DPStateWin.Left := 34;
    DPStateWin.Top := 126;
    DPStateWin.WIDTH := 290;
    DPStateWin.Height := 300;
    DPStateWin.TabWidth := 290;
    DPStateWin.TabHeight := 300;
    // ===========================初始化他人的窗口界面======================================
    // ==============================================================================
    // 人物状态窗口(查看别人信息)
    DHelmetUS1.Tag := U_HELMET;
    DDressUS1.Tag := U_DRESS;
    DWeaponUS1.Tag := U_WEAPON;
    DLightUS1.Tag := U_RIGHTHAND;
    DArmringRUS1.Tag := U_ARMRINGR;
    DRingRUS1.Tag := U_RINGR;
    DNecklaceUS1.Tag := U_NECKLACE;
    DArmringLUS1.Tag := U_ARMRINGL;
    DRingLUS1.Tag := U_RINGL;
    DBujukUS1.Tag := U_BUJUK;
    DBeltUS1.Tag := U_BELT;
    DBootsUS1.Tag := U_BOOTS;
    DCharmUS1.Tag := U_CHARM;
    DZhuliUS1.Tag := U_ZHULI;
    DMountUS1.Tag := U_MOUNT;
    DSShied1.Tag := U_SHIED;
    DFashionUS1.Tag := U_FASHION;

    DSWJeweButtonOther.Left := 280 - 33;
    DSWJeweButtonOther.Top := 220;
    DSWJeweButtonOther.WIDTH := 36;
    DSWJeweButtonOther.Height := 32;
    DSWJeweButtonOther.SetImgIndex(g_77Images, 65);
    DSWJeweButtonOther.Propertites.DownedIndex := 66;

    DSWZodiacOther.Left := 280 - 33;
    DSWZodiacOther.Top := 180;
    DSWZodiacOther.WIDTH := 36;
    DSWZodiacOther.Height := 32;
    DSWZodiacOther.SetImgIndex(g_77Images, 68);
    DSWZodiacOther.Propertites.DownedIndex := 69;

    DUserState1.Left := SCREENWIDTH - 340;
    DUserState1.Top := 0;
    DLightUS1.Left := 38 - 33;
    DLightUS1.Top := 258 - 124;
    DLightUS1.WIDTH := 36;
    DLightUS1.Height := 32;

    DNecklaceUS1.Left := 280 - 33;
    DNecklaceUS1.Top := 258 - 124;
    DNecklaceUS1.WIDTH := 36;
    DNecklaceUS1.Height := 32;

    DHelmetUS1.Left := 127;
    DHelmetUS1.Top := 71;
    DHelmetUS1.WIDTH := 36;
    DHelmetUS1.Height := 32;
    DHelmetUS1.Propertites.OffsetX := -75;
    DHelmetUS1.Propertites.OffsetY := 5;

    DArmringRUS1.Left := 38 - 33;
    DArmringRUS1.Top := 302 - 124;
    DArmringRUS1.WIDTH := 36;
    DArmringRUS1.Height := 32;

    DArmringLUS1.Left := 247;
    DArmringLUS1.Top := 177;
    DArmringLUS1.WIDTH := 36;
    DArmringLUS1.Height := 32;

    DRingRUS1.Left := 38 - 33;
    DRingRUS1.Top := 346 - 124;
    DRingRUS1.WIDTH := 36;
    DRingRUS1.Height := 32;

    DRingLUS1.Left := 247;
    DRingLUS1.Top := 220;
    DRingLUS1.WIDTH := 36;
    DRingLUS1.Height := 32;

    DWeaponUS1.Left := 69;
    DWeaponUS1.Top := 54;
    DWeaponUS1.WIDTH := 46;
    DWeaponUS1.Height := 134;
    DWeaponUS1.Propertites.OffsetX := -19;
    DWeaponUS1.Propertites.OffsetY := 24;

    DDressUS1.Left := 115;
    DDressUS1.Top := 102;
    DDressUS1.WIDTH := 50;
    DDressUS1.Height := 112;
    DDressUS1.Propertites.OffsetX := -62;
    DDressUS1.Propertites.OffsetY := -25;

    DBujukUS1.Left := 46 - 33;
    DBujukUS1.Top := 388 - 124;
    DBujukUS1.WIDTH := 36;
    DBujukUS1.Height := 32;

    DBeltUS1.Left := 92 - 33;
    DBeltUS1.Top := 388 - 124;
    DBeltUS1.WIDTH := 36;
    DBeltUS1.Height := 32;

    DBootsUS1.Left := 138 - 33;
    DBootsUS1.Top := 388 - 124;
    DBootsUS1.WIDTH := 36;
    DBootsUS1.Height := 32;

    DCharmUS1.Left := 184 - 33;
    DCharmUS1.Top := 388 - 124;
    DCharmUS1.WIDTH := 36;
    DCharmUS1.Height := 32;

    DZhuliUS1.Left := 230 - 33;
    DZhuliUS1.Top := 388 - 124;
    DZhuliUS1.WIDTH := 36;
    DZhuliUS1.Height := 32;

    DMountUS1.Left := 243;
    DMountUS1.Top := 263;
    DMountUS1.WIDTH := 36;
    DMountUS1.Height := 32;

    DSShied1.Left := 164;
    DSShied1.Top := 114;
    DSShied1.WIDTH := 32;
    DSShied1.Height := 64;
    DSShied1.Propertites.OffsetX := -100;
    DSShied1.Propertites.OffsetY := -10;

    DFashionUS1.Left := 148 - 33;
    DFashionUS1.Top := 226 - 124;
    DFashionUS1.WIDTH := 70;
    DFashionUS1.Height := 112;

    DCloseUS1.Left := 314;
    DCloseUS1.Top := 60;

    DStateOtherAttr.SetImgIndex(g_77Images, 261);

    DPOtherState.Left := 34;
    DPOtherState.Top := 126;
    DPOtherState.WIDTH := 290;
    DPOtherState.Height := 300;
    DPOtherState.TabWidth := 290;
    DPOtherState.TabHeight := 300;

    TabOtherState.Left := 8;
    TabOtherState.Top := 129;
    TabOtherState.WIDTH := 20;
    TabOtherState.Height := 140;

    AttrLeft := 0;
    AttrRight := 0;
    AttrFixTop := 40;
    SetAttrLeft(DTAC_Other);
    SetAttrLeft(DTMAC_Other);
    SetAttrLeft(DTDC_Other);
    SetAttrLeft(DTMC_Other);
    SetAttrLeft(DTSC_Other);
    SetAttrLeft(DTTC_Other);
    SetAttrLeft(DTPC_Other);
    SetAttrLeft(DTWC_Other);
    SetAttrLeft(DTHIT_Other);
    SetAttrLeft(DTSPEED_Other);
    SetAttrLeft(DTWeight_Other);
    SetAttrLeft(DTWearWeight_Other);
    SetAttrLeft(DTHandWeight_Other);
    SetAttrLeft(DTFightPower_Other);

    SetAttrRight(DTAntiMagic_Other);
    SetAttrRight(DTAntiPoison_Other);
    SetAttrRight(DTDrugRecovery_Other);
    SetAttrRight(DTHPRecovery_Other);
    SetAttrRight(DTMPRecovery_Other);
    SetAttrRight(DTABSORBING_Other);
    SetAttrRight(DTREBOUND_Other);
    SetAttrRight(DTATTACKADD_Other);
    SetAttrRight(DTPunchHit_Other);
    SetAttrRight(DTCRITICALHIT_Other);
    SetAttrRight(DTEXPADDRATE_Other);
    SetAttrRight(DTITEMDROPADDRATE_Other);
    SetAttrRight(DTGOLDDROPADDRATE_Other);
    SetAttrRight(DTAPPENDDAMAGE_Other);

    DPOtherState.Add(DIOtherStateImage);
    DPOtherState.Add(DStateOtherAttr);
    DPOtherState.Add(DIOtherStatefashion);

  end
  else
  {$ENDREGION}
  begin
    // 武器装备页
    if g_DWinMan.StateWinType = wk185 then
    begin
      DIStateHumImage.Left := 0;
      DIStateHumImage.Top := 0;
      DIStateHumImage.StateDrawProperty.ArcherMaleIndex := 29;
      DIStateHumImage.StateDrawProperty.ArcherFemaleIndex := 30;
      DIStateHumImage.StateDrawProperty.MaleIndex := 29;
      DIStateHumImage.StateDrawProperty.FemaleIndex := 30;
      DIStateHumImage.SetImgIndex(g_WMain3Images, 29);
      DIStateHumImage.WIDTH := 290;
      DIStateHumImage.Height := 304;

      //技能
      DStateWinPage_Skill.SetImgIndex(g_WMain2Images, 743);
      // 属性页面
      DStateWinPage_Attr.SetImgIndex(g_WMain3Images, -1);

      DStateWinPage_State.SetImgIndex(g_WMain3Images, 32);

      //查看他人信息窗口
      DIOtherStateImage.Left := 0;
      DIOtherStateImage.Top := 0;
      DIOtherStateImage.StateDrawProperty.ArcherMaleIndex := 29;
      DIOtherStateImage.StateDrawProperty.ArcherFemaleIndex := 30;
      DIOtherStateImage.StateDrawProperty.MaleIndex := 29;
      DIOtherStateImage.StateDrawProperty.FemaleIndex := 30;
      DIOtherStateImage.SetImgIndex(g_WMain3Images, 29);
      DIOtherStateImage.WIDTH := 290;
      DIOtherStateImage.Height := 304;

      DStateOtherAttr.SetImgIndex(g_WMain3Images, -1);
    end
    else if g_DWinMan.StateWinType = wk176 then
    begin
      DIStateHumImage.Left := 0;
      DIStateHumImage.Top := 0;
      DIStateHumImage.StateDrawProperty.ArcherMaleIndex := 376;
      DIStateHumImage.StateDrawProperty.ArcherFemaleIndex := 377;
      DIStateHumImage.StateDrawProperty.MaleIndex := 376;
      DIStateHumImage.StateDrawProperty.FemaleIndex := 377;
      DIStateHumImage.SetImgIndex(g_WMainImages, 376);
      DIStateHumImage.WIDTH := 290;
      DIStateHumImage.Height := 304;

      //技能
      DStateWinPage_Skill.SetImgIndex(g_WMainImages, 383);
      // 属性页面
      DStateWinPage_State.SetImgIndex(g_WMainImages, 382);

      DStateWinPage_Attr.SetImgIndex(g_WMainImages, -1);

      //查看他人信息窗口
      DIOtherStateImage.Left := 0;
      DIOtherStateImage.Top := 0;
      DIOtherStateImage.StateDrawProperty.ArcherMaleIndex := 376;
      DIOtherStateImage.StateDrawProperty.ArcherFemaleIndex := 377;
      DIOtherStateImage.StateDrawProperty.MaleIndex := 376;
      DIOtherStateImage.StateDrawProperty.FemaleIndex := 377;
      DIOtherStateImage.SetImgIndex(g_WMainImages, 376);
      DIOtherStateImage.WIDTH := 290;
      DIOtherStateImage.Height := 304;

      DStateOtherAttr.SetImgIndex(g_WMainImages, -1);

    end;

    DBMyHair.Left := -7;
    DBMyHair.Top := 44;
    DTMySelfName.Width := 120;
    DTMySelfName.Left := 64;
    DTMySelfName.Top := 25;

    DTGuildRankName.Width := 170;
    DTGuildRankName.Left := 0;
    DTGuildRankName.Top := 0;
    DTGuildRankName.DParent.RemoveControl(DTGuildRankName);

    DIStateHumImage.AddChild(DTGuildRankName);
    DTGuildRankName.DParent := DIStateHumImage;

    DTGuildRankUS1.DParent.RemoveControl(DTGuildRankUS1);
    DIOtherStateImage.AddChild(DTGuildRankUS1);
    DTGuildRankUS1.DParent := DIOtherStateImage;

    DTNameUS1.Width := 120;
    DTNameUS1.Left := 64;
    DTNameUS1.Top := 25;

    DTGuildRankUS1.Width := 170;
    DTGuildRankUS1.Left := 0;
    DTGuildRankUS1.Top := 0;

    TTabState.Visible := False;
    DStateWinPre.Visible := True;
    DStateWinNext.Visible := True;

    DStateWinPre.SetImgIndex(g_WMainImages, 373);
    DStateWinPre.Propertites.DownedIndex := 373;
    DStateWinPre.Propertites.ImageIndex := -1;

    DStateWinNext.SetImgIndex(g_WMainImages, 372);
    DStateWinNext.Propertites.DownedIndex := 372;
    DStateWinNext.Propertites.ImageIndex := -1;

    DStPageUp.SetImgIndex(g_WMainImages, 398);
    DStPageUp.Propertites.DownedIndex := 399;

    DStPageDown.SetImgIndex(g_WMainImages, 396);
    DStPageDown.Propertites.DownedIndex := 397;

    DUserState1Pre.SetImgIndex(g_WMainImages, 373);
    DUserState1Pre.Propertites.DownedIndex := 373;
    DUserState1Pre.Propertites.ImageIndex := -1;

    DUserState1Next.SetImgIndex(g_WMainImages, 372);
    DUserState1Next.Propertites.DownedIndex := 372;
    DUserState1Next.Propertites.ImageIndex := -1;

    if g_DWinMan.StateWinType = wk185 then
    begin
      DStateWin.SetImgIndex(g_WMain3Images, 207);
      DUserState1.SetImgIndex(g_WMain3Images, 207);
    end
    else
    begin
      DStateWin.SetImgIndex(g_WMainImages, 370);
      DUserState1.SetImgIndex(g_WMainImages, 370);
    end;

    // ==============================================================================
    DSWJewelryBox.Left := 249;
    DSWJewelryBox.Top := 63;
    DSWJewelryBox.WIDTH := 36;
    DSWJewelryBox.Height := 32;
    DSWJewelryBox.SetImgIndex(g_77Images, 65);
    DSWJewelryBox.Propertites.DownedIndex := 66;

    DSWZodiacSigns.Left := 249;
    DSWZodiacSigns.Top := 98;
    DSWZodiacSigns.WIDTH := 36;
    DSWZodiacSigns.Height := 32;
    DSWZodiacSigns.SetImgIndex(g_77Images, 68);
    DSWZodiacSigns.Propertites.DownedIndex := 69;

    DSWLight.Left := 130;
    DSWLight.Top := 73;
    DSWLight.WIDTH := 36;
    DSWLight.Height := 32;

    DSWNecklace.Left := 130;
    DSWNecklace.Top := 36;
    DSWNecklace.WIDTH := 36;
    DSWNecklace.Height := 32;

    DSWHelmet.Left := 68;
    DSWHelmet.Top := 36;
    DSWHelmet.WIDTH := 36;
    DSWHelmet.Height := 32;

    DSWArmRingR.Left := 5;
    DSWArmRingR.Top := 124;
    DSWArmRingR.WIDTH := 36;
    DSWArmRingR.Height := 32;

    DSWArmRingL.Left := 129;
    DSWArmRingL.Top := 124;
    DSWArmRingL.WIDTH := 36;
    DSWArmRingL.Height := 32;

    DSWRingR.Left := 4;
    DSWRingR.Top := 163;
    DSWRingR.WIDTH := 36;
    DSWRingR.Height := 32;

    DSWRingL.Left := 129;
    DSWRingL.Top := 163;
    DSWRingL.WIDTH := 36;
    DSWRingL.Height := 32;

    DSMount.Left := 243;
    DSMount.Top := 263;
    DSMount.WIDTH := 36;
    DSMount.Height := 32;
    DSMount.Visible := False;

    DSWWeapon.Left := 8;
    DSWWeapon.Top := 0;
    DSWWeapon.WIDTH := 46;
    DSWWeapon.Height := 124;

    DSWDress.Left := 55;
    DSWDress.Top := 66;
    DSWDress.WIDTH := 45;
    DSWDress.Height := 112;

    DSWBujuk.Left := 4;
    DSWBujuk.Top := 202;
    DSWBujuk.WIDTH := 36;
    DSWBujuk.Height := 32;

    DSWBelt.Left := 46;
    DSWBelt.Top := 202;
    DSWBelt.WIDTH := 36;
    DSWBelt.Height := 32;

    DSWBoots.Left := 88;
    DSWBoots.Top := 202;
    DSWBoots.WIDTH := 36;
    DSWBoots.Height := 32;

    DSWCharm.Left := 129;
    DSWCharm.Top := 202;
    DSWCharm.WIDTH := 36;
    DSWCharm.Height := 32;

    DHairUS.Left := -7;
    DHairUS.Top := 44;

    if g_DWinMan.StateWinType = wk176 then
    begin
      DSWCharm.Propertites.Abandon := True;
      DSWBoots.Propertites.Abandon := True;
      DSWBelt.Propertites.Abandon := True;
      DSWBujuk.Propertites.Abandon := True;
    end;

    DSWZhuli.Left := 197;
    DSWZhuli.Top := 263;
    DSWZhuli.WIDTH := 36;
    DSWZhuli.Height := 32;
    DSWZhuli.Visible := False;

    DSShied.Left := 105;
    DSShied.Top := 74;
    DSShied.WIDTH := 24;
    DSShied.Height := 64;

    DCheckFashion.WIDTH := 78;
    DCheckFashion.Height := 17;

    // 技能页面
    DSkillItem1.Left := 4;
    DSkillItem2.Left := 4;
    DSkillItem3.Left := 4;
    DSkillItem4.Left := 4;
    DSkillItem5.Left := 4;
    DSkillItem6.Left := 4;

    DSkillItem1.Top := 3;
    DSkillItem2.Top := 40;
    DSkillItem3.Top := 78;
    DSkillItem4.Top := 115;
    DSkillItem5.Top := 152;
    DSkillItem6.Top := 189;

    InitSkillItem(DSkillItem1);
    InitSkillItem(DSkillItem2);
    InitSkillItem(DSkillItem3);
    InitSkillItem(DSkillItem4);
    InitSkillItem(DSkillItem5);
    InitSkillItem(DSkillItem6);

    if g_DWinMan.StateWinType = wk176 then
    begin
      DSkillItem6.Abandon := True;
    end;

    DStPageUp.Left := 175;
    DStPageUp.Top := 54;
    DStPageDown.Left := 175;
    DStPageDown.Top := 97;

    DTMagicPageCount.Visible := False;
    DTMagicPageCount.Left := 138;
    DTMagicPageCount.Top := 284;


    DStateWinPage_Attr.Left := 0;
    DStateWinPage_Attr.Top := 0;

    AttrLeft := 0;
    AttrRight := 0;
    AttrFixTop := 45;
    SetAttrLeft(DTAC);
    DTAC.Propertites.Caption.Text := '<$AC>-<$ACMAX>';
    SetAttrLeft(DTMAC);
    DTMAC.Propertites.Caption.Text := '<$MAC>-<$MACMAX>';
    SetAttrLeft(DTDC);
    DTDC.Propertites.Caption.Text := '<$DC>-<$DCMAX>';
    SetAttrLeft(DTMC);
    DTMC.Propertites.Caption.Text := '<$MC>-<$MCMAX>';
    SetAttrLeft(DTSC);
    DTSC.Propertites.Caption.Text := '<$SC>-<$SCMAX>';
    SetAttrLeft(DTTC);
    DTTC.Propertites.Caption.Text := '<$HP>-<$HPMAX>';
    SetAttrLeft(DTPC);
    DTPC.Propertites.Caption.Text := '<$MP>-<$MPMAX>';
    SetAttrRight(DTWC);
    SetAttrRight(DTHIT);
    SetAttrRight(DTSPEED);
    SetAttrRight(DTWeight);
    SetAttrRight(DTWearWeight);
    SetAttrRight(DTHandWeight);
    SetAttrRight(DTFightPower);

    SetAttrRight(DTAntiMagic);
    SetAttrRight(DTAntiPoison);
    SetAttrRight(DTDrugRecovery);
    SetAttrRight(DTHPRecovery);
    SetAttrRight(DTMPRecovery);
    SetAttrRight(DTABSORBING);
    SetAttrRight(DTREBOUND);
    SetAttrRight(DTATTACKADD);
    SetAttrRight(DTPunchHit);
    SetAttrRight(DTCRITICALHIT);
    SetAttrRight(DTEXPADDRATE);
    SetAttrRight(DTITEMDROPADDRATE);
    SetAttrRight(DTGOLDDROPADDRATE);
    SetAttrRight(DTAPPENDDAMAGE);

    // 状态页面
    DStateWinPage_State.Left := 0;
    DStateWinPage_State.Top := 0;

    SetStateText(DTJob, DTVJob, 0);
    SetStateText(DTLevelText, DTVLevel, 16);
    SetStateText(DTCredit, DTVCreditPoint, 32);
    SetStateText(DTExp, DTVEXP, 48); // 第一条横线
    SetStateText(DTMaxExp, DTVMAXEXP, 64);
    SetStateText(DTHP, DTVHP, 80);
    SetStateText(DTMP, DTVMP, 96);
    SetStateText(DTGameGoldCount, DTVGameGold, 110);
    SetStateText(DTGamePoint, DTVGamePoint, 126); // 第二条横线
    SetStateText(DTGameGlory, DTVGameGlory, 140);
    SetStateText(DTGameGird, DTVGameGird, 156);
    SetStateText(DTGameDiamond, DTVGameDiamond, 172);

    // 称号页面
    DStateWinPage_Tiltle.SetImgIndex(g_77Images, 264);
    DBTitle1.WIDTH := 32;
    DBTitle1.Height := 32;
    DBTitle1.Left := 11;
    DBTitle1.Top := 70;

    DBTitle2.WIDTH := 32;
    DBTitle2.Height := 32;
    DBTitle2.Left := 11;
    DBTitle2.Top := 109;

    DBTitle3.WIDTH := 32;
    DBTitle3.Height := 32;
    DBTitle3.Left := 11;
    DBTitle3.Top := 148;

    DBTitle4.WIDTH := 32;
    DBTitle4.Height := 32;
    DBTitle4.Left := 11;
    DBTitle4.Top := 187;

    DBTitle5.WIDTH := 32;
    DBTitle5.Height := 32;
    DBTitle5.Left := 11;
    DBTitle5.Top := 226;

    DBTitle6.WIDTH := 32;
    DBTitle6.Height := 32;
    DBTitle6.Left := 11;
    DBTitle6.Top := 265;

    DTTitle1.Propertites.Caption.Text := '未定意思';
    DTTitle1.Left := 51;
    DTTitle1.Top := 78;

    DTTitle2.Propertites.Caption.Text := '未定意思';
    DTTitle2.Left := 51;
    DTTitle2.Top := 119;

    DTTitle3.Propertites.Caption.Text := '未定意思';
    DTTitle3.Left := 51;
    DTTitle3.Top := 158;

    DTTitle4.Propertites.Caption.Text := '未定意思';
    DTTitle4.Left := 51;
    DTTitle4.Top := 198;

    DTTitle5.Propertites.Caption.Text := '未定意思';
    DTTitle5.Left := 51;
    DTTitle5.Top := 236;

    DTTitle6.Propertites.Caption.Text := '未定意思';
    DTTitle6.Left := 51;
    DTTitle6.Top := 274;

    DBActivveTitle.Left := 29;
    DBActivveTitle.Top := 4;
    DBActivveTitle.WIDTH := 38;
    DBActivveTitle.Height := 38;

    DTActivveTitle.Left := 75;
    DTActivveTitle.Top := 16;

    DBTitlePre.Left := 131;
    DBTitlePre.Top := 131;
    DBTitlePre.WIDTH := 13;
    DBTitlePre.Height := 23;

    DBTitleNext.Left := 131;
    DBTitleNext.Top := 185;
    DBTitleNext.WIDTH := 13;
    DBTitleNext.Height := 23;

    DBTitleInfo.WIDTH := 140;
    DBTitleInfo.Height := 220;
    DBTitleInfo.Left := 150;
    DBTitleInfo.Top := 78;

    // 时装页面
    DIStateHumImage_fashion.Left := 0;
    DIStateHumImage_fashion.Top := 0;

    TTabState.Left := 7;
    TTabState.Top := 126;
    TTabState.WIDTH := 22;
    TTabState.Height := 250;
    TTabState.SheetCount := 6;


    //PageControl
    DPStateWin.Left := 39;
    DPStateWin.Top := 52;
    DPStateWin.WIDTH := 170;
    DPStateWin.Height := 240;
    DPStateWin.TabWidth := 170;
    DPStateWin.TabHeight := 240;
    // ===========================初始化他人的窗口界面======================================
    // ==============================================================================
    // 人物状态窗口(查看别人信息)
    DHelmetUS1.Tag := U_HELMET;
    DDressUS1.Tag := U_DRESS;
    DWeaponUS1.Tag := U_WEAPON;
    DLightUS1.Tag := U_RIGHTHAND;
    DArmringRUS1.Tag := U_ARMRINGR;
    DRingRUS1.Tag := U_RINGR;
    DNecklaceUS1.Tag := U_NECKLACE;
    DArmringLUS1.Tag := U_ARMRINGL;
    DRingLUS1.Tag := U_RINGL;
    DBujukUS1.Tag := U_BUJUK;
    DBeltUS1.Tag := U_BELT;
    DBootsUS1.Tag := U_BOOTS;
    DCharmUS1.Tag := U_CHARM;
    DZhuliUS1.Tag := U_ZHULI;
    DMountUS1.Tag := U_MOUNT;
    DSShied1.Tag := U_SHIED;
    DFashionUS1.Tag := U_FASHION;

    DSWJeweButtonOther.Left := 280;
    DSWJeweButtonOther.Top := 220;
    DSWJeweButtonOther.WIDTH := 36;
    DSWJeweButtonOther.Height := 32;
    DSWJeweButtonOther.SetImgIndex(g_77Images, 65);
    DSWJeweButtonOther.Propertites.DownedIndex := 66;

    DSWZodiacOther.Left := 280 - 33;
    DSWZodiacOther.Top := 180;
    DSWZodiacOther.WIDTH := 36;
    DSWZodiacOther.Height := 32;
    DSWZodiacOther.SetImgIndex(g_77Images, 68);
    DSWZodiacOther.Propertites.DownedIndex := 69;

    DUserState1.Left := SCREENWIDTH - 340;
    DUserState1.Top := 0;
    DLightUS1.Left := 130;
    DLightUS1.Top := 73;
    DLightUS1.WIDTH := 36;
    DLightUS1.Height := 32;

    DNecklaceUS1.Left := 130;
    DNecklaceUS1.Top := 35;
    DNecklaceUS1.WIDTH := 36;
    DNecklaceUS1.Height := 32;

    DHelmetUS1.Left := 68;
    DHelmetUS1.Top := 38;
    DHelmetUS1.WIDTH := 36;
    DHelmetUS1.Height := 32;
    DHelmetUS1.Propertites.OffsetX := -75;
    DHelmetUS1.Propertites.OffsetY := 5;

    DArmringRUS1.Left := 4;
    DArmringRUS1.Top := 124;
    DArmringRUS1.WIDTH := 36;
    DArmringRUS1.Height := 32;

    DArmringLUS1.Left := 129;
    DArmringLUS1.Top := 124;
    DArmringLUS1.WIDTH := 36;
    DArmringLUS1.Height := 32;

    DRingRUS1.Left := 4;
    DRingRUS1.Top := 163;
    DRingRUS1.WIDTH := 36;
    DRingRUS1.Height := 32;

    DRingLUS1.Left := 129;
    DRingLUS1.Top := 163;
    DRingLUS1.WIDTH := 36;
    DRingLUS1.Height := 32;

    DWeaponUS1.Left := 10;
    DWeaponUS1.Top := 20;
    DWeaponUS1.WIDTH := 46;
    DWeaponUS1.Height := 100;
    DWeaponUS1.Propertites.OffsetX := -19;
    DWeaponUS1.Propertites.OffsetY := 24;

    DDressUS1.Left := 55;
    DDressUS1.Top := 69;
    DDressUS1.WIDTH := 50;
    DDressUS1.Height := 112;
    DDressUS1.Propertites.OffsetX := -62;
    DDressUS1.Propertites.OffsetY := -25;

    DBujukUS1.Left := 4;
    DBujukUS1.Top := 201;
    DBujukUS1.WIDTH := 36;
    DBujukUS1.Height := 32;

    DBeltUS1.Left := 46;
    DBeltUS1.Top := 201;
    DBeltUS1.WIDTH := 36;
    DBeltUS1.Height := 32;

    DBootsUS1.Left := 88;
    DBootsUS1.Top := 201;
    DBootsUS1.WIDTH := 36;
    DBootsUS1.Height := 32;

    DCharmUS1.Left := 129;
    DCharmUS1.Top := 201;
    DCharmUS1.WIDTH := 36;
    DCharmUS1.Height := 32;

    if g_DWinMan.StateWinType = wk176 then
    begin
      DCharmUS1.Propertites.Abandon := True;
      DBootsUS1.Propertites.Abandon := True;
      DBeltUS1.Propertites.Abandon := True;
      DBujukUS1.Propertites.Abandon := True;
    end;

    DZhuliUS1.Left := 201;
    DZhuliUS1.Top := 388 - 124;
    DZhuliUS1.WIDTH := 36;
    DZhuliUS1.Height := 32;
    DZhuliUS1.Visible := False;

    DMountUS1.Left := 276 - 33;
    DMountUS1.Top := 388 - 124;
    DMountUS1.WIDTH := 36;
    DMountUS1.Height := 32;
    DMountUS1.Visible := False;

    DSShied1.Left := 104;
    DSShied1.Top := 86;
    DSShied1.WIDTH := 25;
    DSShied1.Height := 64;
    DSShied1.Propertites.OffsetX := -100;
    DSShied1.Propertites.OffsetY := -10;

    DFashionUS1.Left := 148 - 33;
    DFashionUS1.Top := 226 - 124;
    DFashionUS1.WIDTH := 70;
    DFashionUS1.Height := 112;

    DCloseUS1.Left := 8;
    DCloseUS1.Top := 39;

    DPOtherState.Left := 39;
    DPOtherState.Top := 52;
    DPOtherState.WIDTH := 170;
    DPOtherState.Height := 240;
    DPOtherState.TabWidth := 170;
    DPOtherState.TabHeight := 240;

    TabOtherState.Left := 8;
    TabOtherState.Top := 129;
    TabOtherState.WIDTH := 20;
    TabOtherState.Height := 140;
    TabOtherState.Visible := False;
    DUserState1Pre.Visible := True;
    DUserState1Next.Visible := True;

    AttrLeft := 0;
    AttrRight := 0;
    AttrFixTop := 45;
    SetAttrLeft(DTAC_Other);
    DTAC_Other.Propertites.Caption.Text := '<$AC_T>-<$ACMAX_T>';
    SetAttrLeft(DTMAC_Other);
    DTMAC_Other.Propertites.Caption.Text := '<$MAC>-<$MACMAX>';
    SetAttrLeft(DTDC_Other);
    DTDC_Other.Propertites.Caption.Text := '<$DC_T>-<$DCMAX_T>';
    SetAttrLeft(DTMC_Other);
    DTMC_Other.Propertites.Caption.Text := '<$MC_T>-<$MCMAX_T>';
    SetAttrLeft(DTSC_Other);
    DTSC_Other.Propertites.Caption.Text := '<$SC_T>-<$SCMAX_T>';
    SetAttrLeft(DTTC_Other);
    DTTC_Other.Propertites.Caption.Text := '<$HP_T>-<$HPMAX_T>';
    SetAttrLeft(DTPC_Other);
    DTPC_Other.Propertites.Caption.Text := '<$MP_T>-<$MPMAX_T>';

    SetAttrRight(DTWC_Other);
    SetAttrRight(DTHIT_Other);
    SetAttrRight(DTSPEED_Other);
    SetAttrRight(DTWeight_Other);
    SetAttrRight(DTWearWeight_Other);
    SetAttrRight(DTHandWeight_Other);
    SetAttrRight(DTFightPower_Other);

    SetAttrRight(DTAntiMagic_Other);
    SetAttrRight(DTAntiPoison_Other);
    SetAttrRight(DTDrugRecovery_Other);
    SetAttrRight(DTHPRecovery_Other);
    SetAttrRight(DTMPRecovery_Other);
    SetAttrRight(DTABSORBING_Other);
    SetAttrRight(DTREBOUND_Other);
    SetAttrRight(DTATTACKADD_Other);
    SetAttrRight(DTPunchHit_Other);
    SetAttrRight(DTCRITICALHIT_Other);
    SetAttrRight(DTEXPADDRATE_Other);
    SetAttrRight(DTITEMDROPADDRATE_Other);
    SetAttrRight(DTGOLDDROPADDRATE_Other);
    SetAttrRight(DTAPPENDDAMAGE_Other);

    DPOtherState.Add(DIOtherStateImage);
    DPOtherState.Add(DStateOtherAttr);
    DPOtherState.Add(DIOtherStatefashion);

  end;

      // 加入PageControl
    DPStateWin.Add(DIStateHumImage);
    DPStateWin.Add(DStateWinPage_State);
    DPStateWin.Add(DStateWinPage_Attr);
    DPStateWin.Add(DStateWinPage_Tiltle);
    DPStateWin.Add(DStateWinPage_Skill);
    DPStateWin.Add(DIStateHumImage_fashion);
end;

procedure OnChatBoxWHChange();
begin
  DScreen.ChatMessage.ChatBoxWidth := FrmDlg.DChatBox.WIDTH;
  DScreen.ChatMessage.ChatBoxHeight := FrmDlg.DChatBox.Height;
  CHATBOXLINECOUNT := FrmDlg.DChatBox.Height div 12;
end;

procedure TFrmDlg.Initialize; // 初始化窗口  清清 2007.10.20
var
  D: TAsphyreLockableTexture;
begin
  CreateSelChrUI;
  AdjustWindowShow();

  ExtUI.ChatBoxWHChange := OnChatBoxWHChange;
  DWinCtl.ClickMerchatLabel := ClickNpcLable;
  DWinCtl.g_DWinMan.OnReadDoneUI := OnUIReadDone;
  uMessageParse.NpcCountDownOverProc := GotoNpcProc;
  uMessageParse.BindGetChatBoxStyleCallBack(@GetChatBoxStyle);
  if g_NewUI then
  begin
    DBottom.Left := 0;
    DBottom.Top := SCREENHEIGHT - 107;
    DBottom.WIDTH := SCREENWIDTH;
    DBottom.Height := 107;
    g_BottomHeight := 0;

    // Belt 快捷栏
    DBelt1.Left := 82;
    DBelt1.Top := 13;
    DBelt1.WIDTH := 32;
    DBelt1.Height := 29;

    DBelt2.Left := 125;
    DBelt2.WIDTH := 13;
    DBelt2.Top := 66;
    DBelt2.Height := 29;

    DBelt3.Left := 169;
    DBelt3.WIDTH := 13;
    DBelt3.Top := 66;
    DBelt3.Height := 29;

    DBelt4.Left := 212;
    DBelt4.WIDTH := 13;
    DBelt4.Top := 66;
    DBelt4.Height := 29;

    DBelt5.Left := 256;
    DBelt5.WIDTH := 13;
    DBelt5.Top := 66;
    DBelt5.Height := 29;

    DBelt6.Left := 300;
    DBelt6.WIDTH := 13;
    DBelt6.Top := 66;
    DBelt6.Height := 29;

    DEChat.Left := 208;
    DEChat.Top := DBottom.Height - 19;
    DEChat.Height := 19;
    DEChat.WIDTH := SCREENWIDTH - 208 - 206;
    // 功能按钮
    DChatScroll.SetImgIndex(g_77Images, 303);
    DChatScrollTop.SetImgIndex(g_77Images, 299);
    DChatScrollBottom.SetImgIndex(g_77Images, 301);

    DMyState.Left := SCREENWIDTH - 266;
    DMyState.Top := 66;
    DMyBag.Left := SCREENWIDTH - 232;
    DMyBag.Top := 66;
    DMyMagic.Left := SCREENWIDTH - 198;
    DMyMagic.Top := 66;
    DOption.Left := SCREENWIDTH - 164;
    DOption.Top := 66;
    DAOpenShop.Left := SCREENWIDTH - 39;
    DAOpenShop.Top := 41;
    DSighIcon.Left := SCREENWIDTH - 36;
    DSighIcon.Top := -36;

    DInternet.visible := False;
    DHelp.visible := False;
    buttUseBatter.visible := False;
  end
  else
  begin
    // ==============================================================================
    // 功能按钮
    DMyState.Left := SCREENWIDTH - 168;
    DMyState.Top := 51;
    DMyBag.Left := SCREENWIDTH - 129;
    DMyBag.Top := 30;
    DMyMagic.Left := SCREENWIDTH - 89;
    DMyMagic.Top := 10;
    DOption.Left := SCREENWIDTH - 46;
    DOption.Top := 0;
    // ==============================================================================
    // 主控面板
    DBottom.Left := 0;
    DBottom.Top := SCREENHEIGHT - 251;
    DBottom.WIDTH := SCREENWIDTH;
    DBottom.Height := 251;
    g_BottomHeight := 251;
    DChatBox.Left := 14;
    DChatBox.Top := 25;
    DChatBox.WIDTH := SCREENWIDTH - 412;
    DChatBox.Height := 108;

    DEChat.Left := 208;
    DEChat.Top := DBottom.Height - 20;
    DEChat.Height := 14;
    DEChat.WIDTH := SCREENWIDTH - 411;
    {
      if (X >= 208) and (X <= 208 + 374) and (Y >= SCREENHEIGHT - 130) and (Y <= SCREENHEIGHT - 130 + 12 * 9) then
      begin

    }
    DChatScrollTop.Left := SCREENWIDTH - 204;
    DChatScrollTop.Top := 94 + 24;
    DChatScrollTop.WIDTH := 16;
    DChatScrollTop.Height := 10;
    DChatScrollBottom.Left := SCREENWIDTH - 204;
    DChatScrollBottom.Top := 94 + 128;
    DChatScrollBottom.WIDTH := 16;
    DChatScrollBottom.Height := 10;
    DChatScroll.Left := SCREENWIDTH - 204;
    DChatScroll.Top := DChatScrollTop.Top + DChatScrollTop.Height;
    DChatScroll.WIDTH := 16;
    DChatScroll.Height := 16;
    // ==============================================================================
    // Belt 快捷栏
    DBelt1.Left := 82;
    DBelt1.Top := 13;
    DBelt1.WIDTH := 32;
    DBelt1.Height := 29;

    DBelt2.Left := 125;
    DBelt2.WIDTH := 32;
    DBelt2.Top := 13;
    DBelt2.Height := 29;

    DBelt3.Left := 169;
    DBelt3.WIDTH := 32;
    DBelt3.Top := 13;
    DBelt3.Height := 29;

    DBelt4.Left := 212;
    DBelt4.WIDTH := 32;
    DBelt4.Top := 13;
    DBelt4.Height := 29;

    DBelt5.Left := 256;
    DBelt5.WIDTH := 32;
    DBelt5.Top := 13;
    DBelt5.Height := 29;

    DBelt6.Left := 300;
    DBelt6.WIDTH := 32;
    DBelt6.Top := 13;
    DBelt6.Height := 29;
    { ----------------------------------------------------------- }
    // 功能按钮
    DChatScroll.SetImgIndex(g_77Images, 303);
    DChatScrollTop.SetImgIndex(g_77Images, 299);
    DChatScrollBottom.SetImgIndex(g_77Images, 301);

    // ==============================================================================
    // 快捷按钮
    DAOpenShop.Left := SCREENWIDTH - 46;
    DAOpenShop.Top := 204;
    DBotExit.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 160));
    DBotExit.Top := 104;
    DBotLogout.Left := SCREENWIDTH div 2 +
      (SCREENWIDTH div 2 - (400 - 160)) - 30;
    DBotLogout.Top := 104;

    // 血球
    DAMyHP.Left := 40;
    DAMyHP.Top := 91;
    DAMyHP.WIDTH := 45;
    DAMyHP.Height := 90;
    DAMyMP.Left := 89;
    DAMyMP.Top := 91;
    DAMyMP.WIDTH := 45;
    DAMyMP.Height := 90;

    DABloodEffect.Left := 40;
    DABloodEffect.Top := 91;

    DTLevel.Left := SCREENWIDTH - 50 - DTLevel.WIDTH;
    DTLevel.Top := 145;
    DTDateTime.Left := SCREENWIDTH - 61 - DTDateTime.WIDTH;
    DTDateTime.Top := 230;

    DTAttackMode.Left := SCREENWIDTH - 92 - DTDateTime.WIDTH;
    DTAttackMode.Top := 113;

    // 战士的空血球
    DBWarEmptyBlood.Left := 40;
    DBWarEmptyBlood.Top := 91;
    DAWarBlood.Left := 40;
    DAWarBlood.Top := 91;

    DAWarBloodEffect.Left := 40;
    DAWarBloodEffect.Top := 91;

    // 经验条 负重条 天气
    DAExpBar.Left := SCREENWIDTH - 133;
    DAExpBar.Top := 180;

    DTExpText.Left := DAExpBar.Left;
    DTExpText.Top := 179;


    DAWeightBar.Left := SCREENWIDTH - 133;
    DAWeightBar.Top := 213;

    DTWeightText.Left := DAWeightBar.Left;
    DTWeightText.Top := 212;

//    DBWeather.WIDTH := 35;
//    DBWeather.Height := 60;
    DBWeather.Left := SCREENWIDTH - 52;
    DBWeather.Top := 79;

    DTHPText.WIDTH := 60;
    DTHPText.Top := 214;
    DTHPText.Left := 27;
    DTHPText.Height := 12;

    DTMPText.WIDTH := 60;
    DTMPText.Top := 214;
    DTMPText.Left := 88;
    DTMPText.Height := 12;

    DTMapXY.WIDTH := 160;
    DTMapXY.Height := 12;
    DTMapXY.Left := 7;
    DTMapXY.Top := 234;

    DBLeftBloodPic.Left := 0;
    DBLeftBloodPic.Top := 0;

    DBRightBottomPic.Left := SCREENWIDTH - DBRightBottomPic.WIDTH;
    DBRightBottomPic.Top := SCREENHEIGHT - DBRightBottomPic.Height -
      DBRightBottomPic.DParent.Top;
    DBRightBottomPic.Propertites.DAnchors := [akRight, akBottom];

    DTCountDownHint.Left := 0;
    DTCountDownHint.WIDTH := SCREENWIDTH;
    DTCountDownHint.Top := SCREENHEIGHT - 245;
    DTCountDownHint.Height := 16;

    DTMiniMapName.Left := 2;
    DTMiniMapName.Top := 6;
    DTMiniMapName.WIDTH := 105;
    DTMiniMapName.Height := 14;
    DTMiniMapName.Propertites.Align := aCenter;

    DBMinMapBackGround.Left := 2;
    DBMinMapBackGround.Top := 0;

    DBMiniMapImage.Left := 2;
    DBMiniMapImage.Top := 25;

    DMapMiniMapImageMask.Left := 0;
    DMapMiniMapImageMask.Top := 0;

    DMiniMapDrawPos.Left := 5;
    DMiniMapDrawPos.Top := 3;
    DMiniMapDrawPos.Width := 122;
    DMiniMapDrawPos.Height:= 120;

    DGridBottomPic.Left := DBLeftBloodPic.Left + DBLeftBloodPic.WIDTH - 24;
    DGridBottomPic.WIDTH := SCREENWIDTH - DBLeftBloodPic.WIDTH -
      DBRightBottomPic.WIDTH + 29;
    DGridBottomPic.Height := 157;
    DGridBottomPic.Top := DGridBottomPic.DParent.Height - DGridBottomPic.Height;

    DIQuickItemPic.Propertites.AnchorX := 0.5;
    DIQuickItemPic.Propertites.AnchorPx := 0.5;
    DIQuickItemPic.Propertites.AnchorY := -0.31;
    DIQuickItemPic.Propertites.AnchorPy := 0;
  end;

  { ---------------------------------------------------------- }
  // NPC对话框
  DMsgDlg.SetImgIndex(g_77Images, 243);

  CSetImageIndex(DMsgDlgOk,g_WMainImages,361);

  DMsgDlgYes.SetImgIndex(g_WMainImages, 363);
  DMsgDlgCancel.SetImgIndex(g_WMainImages, 365);
  DMsgDlgNo.SetImgIndex(g_WMainImages, 367);
  { ----------------------------------------------------------- }
  // 修改密码窗口
  D := g_WMainImages.Images[50];
  if D <> nil then
    DChgGamePwd.SetImgIndex(g_WMainImages, 689);
  DChgGamePwdClose.SetImgIndex(g_WMainImages, 64);
  // 人物状态窗口
  DStateWin.SetImgIndex(g_77Images, 263);
  DStPageUp.SetImgIndex(g_77Images, 305);
  DStPageDown.SetImgIndex(g_77Images, 308);
  DCloseState.SetImgIndex(g_77Images, 52);
  DCloseState.Propertites.DownedIndex := 53;
  // 内功
  // DStateTab.SetImgIndex(g_WMain2Images, 744);
  { ****************************************************************************** }
  { ---------------------英雄状态窗口------------------------- }

  // 清清$009 2007.10.21

  buttUseBatter.SetImgIndex(g_WMainImages, 1120);
  { ---------------------连击相关-------------------------- }
  DBatterRandom.SetImgIndex(g_WMainImages, 901);
  DBatterSort.SetImgIndex(g_WMainImages, 901);
  // DBatterPopMenu.SetImgIndex(g_WMainImages, 911);
  { ------------------------------------------------------- }
  // 排行榜
  CSetImageIndex(DLevelOrder,g_77Images,430);
  SetCloseButtonImage(DLevelOrderClose);

  CSetImageIndex(DOrderLevel,g_77Images,241);
  CSetImageIndex(DOrderRiches,g_77Images,241);
  CSetImageIndex(DOrderAbil,g_77Images,241);
  CSetImageIndex(DOrderMaster,g_77Images,241);
  CSetImageIndex(DOrderWar,g_77Images,241);
  CSetImageIndex(DOrderMag,g_77Images,241);
  CSetImageIndex(DOrderDao,g_77Images,241);
  CSetImageIndex(DOrderArc,g_77Images,241);
  CSetImageIndex(DOrderCik,g_77Images,241);
  CSetImageIndex(DOrderWS,g_77Images,241);

  CSetImageIndex(DLevelOrderIndex,g_77Images,152);
  CSetImageIndex(DLevelOrderPrev,g_77Images,152);
  CSetImageIndex(DLevelOrderNext,g_77Images,152);
  CSetImageIndex(DLevelOrderLastPage,g_77Images,152);
  CSetImageIndex(DMyLevelOrder,g_77Images,152);

  { ----------------------------------------------------------- }
  // 人物状态窗口(查看别人信息)
  DUserState1.SetImgIndex(g_77Images, 263);
  DCloseUS1.SetImgIndex(g_77Images, 52);
  DCloseUS1.Propertites.DownedIndex := 53;
  { ------------------------------------------------------------- }
  // 背包物品窗口
  DItemBag.SetImgIndex(g_77Images, 187);
  { ----------------------------------------------------------- }
  // Shop
  DShop.SetImgIndex(g_77Images, 214);
  SetCloseButtonImage(DShopClose);

  DShopSelItemName.Left := 32;
  DShopSelItemName.Top := 158;

  DShopSelItemPrice.Left := 32;
  DShopSelItemPrice.Top := 244;

  DShopGamePoint.Left := 70;
  DShopGamePoint.Top := 306;

  DShopGameGold.Left := 70;
  DShopGameGold.Top := 330;

  DShopBuy.Enabled := False;
  DShopBuy.SetImgIndex(g_77Images, 221); { 购买 }
  DShopBuy.Propertites.ImageIndex := 220;
  DShopBuy.Propertites.DownedIndex := 219;
  DShopBuy.Propertites.DisabledIndex := 221;

  DBPay.SetImgIndex(g_77Images, 217); { 充值 }
  DBPay.Propertites.DownedIndex := 218;

  SetMirOldButtonImageIndex(DShopDecorate,g_WMain3Images,299);
  SetMirOldButtonImageIndex(DShopSupplies,g_WMain3Images,300);
  SetMirOldButtonImageIndex(DshopStrengthen,g_WMain3Images,301);
  SetMirOldButtonImageIndex(DShopFriend,g_WMain3Images,302);
  SetMirOldButtonImageIndex(DShopCapacity,g_WMain3Images,303);
  DShopPrev.SetImgIndex(g_WMainImages, 388);
  DShopNext.SetImgIndex(g_WMainImages, 387);

  { ----------------------------------------------------------- }
  // 背包金币图片
  DGold.SetImgIndex(g_WMainImages, 29);
  DStallCtrl.SetImgIndex(g_77Images, 152);
  SetMirOldButtonImageIndex(DCloseBag,g_WMainImages,371);
  { ----------------------------------------------------------- }
  // NPC、商人对话框
  DMerchantDlg.SetImgIndexEx(g_WMainImages, 384, 416, 176, 0, 0);
  MerchantDiagWidth := DMerchantDlg.WIDTH;
  MerchantDlgHeight := DMerchantDlg.Height;
  DMerchantDlgClose.SetImgIndex(g_77Images, 52);
  DMerchantDlgClose.Propertites.DownedIndex := 53;
  { ----------------------------------------------------------- }
  // 宝箱
  D := g_WMain3Images.Images[520];
  if D <> nil then
    DBoxs.SetImgIndex(g_WMain3Images, 520);
  DBoxsBelt1.SetImgIndex(g_WMain3Images, 514);
  DBoxsBelt2.SetImgIndex(g_WMain3Images, 514);
  DBoxsBelt3.SetImgIndex(g_WMain3Images, 514);
  DBoxsBelt4.SetImgIndex(g_WMain3Images, 514);
  DBoxsBelt5.SetImgIndex(g_WMain3Images, 514);
  DBoxsBelt6.SetImgIndex(g_WMain3Images, 514);
  DBoxsBelt7.SetImgIndex(g_WMain3Images, 514);
  DBoxsBelt8.SetImgIndex(g_WMain3Images, 514);
  DBoxsBelt9.SetImgIndex(g_WMain3Images, 514);

  SetMirOldButtonImageIndex(DBoxsTautology,g_WMain3Images,511);
  //DBoxsTautology.SetImgIndex(g_WMain3Images, 511);
  { ----------------------------------------------------------- }
  // 装备升级
  D := g_WMain3Images.Images[462];
  if D <> nil then
    DItemsUp.SetImgIndex(g_WMain3Images, 462);
  SetMirOldButtonImageIndex(DItemsUpClose,g_WMainImages,64);
  SetMirOldButtonImageIndex(DItemsUpOk,g_WMain3Images,463);
  { ----------------------------------------------------------- }
  // 菜单对话框
  D := g_WMainImages.Images[385];
  if D <> nil then
    DMenuDlg.SetImgIndex(g_WMainImages, 385);

  SetMirOldButtonImageIndex(DMenuPrev,g_WMainImages,388);
  SetMirOldButtonImageIndex(DMenuNext,g_WMainImages,387);
  SetMirOldButtonImageIndex(DMenuBuy,g_WMainImages,386);
  DMenuClose.SetImgIndex(g_77Images, 52);
  DMenuClose.Propertites.DownedIndex := 53;

  //仓库
  DStorageWin.SetImgIndex(g_WMainImages, 385);


  SetMirOldButtonImageIndex(DSaveItemsPrevPage,g_WMainImages,388);
  DSaveItemsPrevPage.Left := 43;
  DSaveItemsPrevPage.Top := 175;

  SetMirOldButtonImageIndex(DSaveItemsNextPage,g_WMainImages,387);
  DSaveItemsNextPage.Left := 90;
  DSaveItemsNextPage.Top := 175;

  SetMirOldButtonImageIndex(DGetBackItem,g_WMainImages,386);
  DGetBackItem.Left := 214;
  DGetBackItem.Top := 171;


  DStorageWinClose.SetImgIndex(g_77Images, 52);
  DStorageWinClose.Propertites.DownedIndex := 53;
  DStorageWinClose.Left := 291;
  DStorageWinClose.Top := 0;

  { ----------------------------------------------------------- }
  // 出售
  DSellDlgClose.SetImgIndex(g_WMainImages, 64);
  DSellDlgClose.Propertites.ImageIndex := -1;
  DSellDlgClose.Propertites.DownedIndex := 64;
  { ----------------------------------------------------------- }
  // 设置魔法快捷对话框
  D := g_WMain3Images.Images[126];
  if D <> nil then
    DKeySelDlg.SetImgIndex(g_WMain3Images, 126);
  DKsF1.SetImgIndex(g_WMainImages, 232);
  DKsF2.SetImgIndex(g_WMainImages, 234);
  DKsF3.SetImgIndex(g_WMainImages, 236);
  DKsF4.SetImgIndex(g_WMainImages, 238);
  DKsF5.SetImgIndex(g_WMainImages, 240);
  DKsF6.SetImgIndex(g_WMainImages, 242);
  DKsF7.SetImgIndex(g_WMainImages, 244);
  DKsF8.SetImgIndex(g_WMainImages, 246);
  DKsConF1.SetImgIndex(g_WMain3Images, 132);
  DKsConF2.SetImgIndex(g_WMain3Images, 134);
  DKsConF3.SetImgIndex(g_WMain3Images, 136);
  DKsConF4.SetImgIndex(g_WMain3Images, 138);
  DKsConF5.SetImgIndex(g_WMain3Images, 140);
  DKsConF6.SetImgIndex(g_WMain3Images, 142);
  DKsConF7.SetImgIndex(g_WMain3Images, 144);
  DKsConF8.SetImgIndex(g_WMain3Images, 146);
  DKsNone.SetImgIndex(g_WMain3Images, 129);
  DKsOk.SetImgIndex(g_WMain3Images, 127);
  { ----------------------------------------------------------- }
  // 组对话框
  DGroupDlg.SetImgIndex(g_77Images, 136);
  DGrpDlgClose.SetImgIndex(g_77Images, 170);
  DGrpDlgClose.Propertites.DownedIndex := 171;

  CSetImageIndex(DGrpDismiss,g_77Images,84);
  CSetImageIndex(DGrpAddMem,g_77Images,84);
  CSetImageIndex(DGrpDelMem,g_77Images,84);
  CSetImageIndex(DGrpExit,g_77Images,84);

  DGrpExit.Left := 173;
  DGrpExit.Top := 231;

  DGrpDismiss.Left := 173;
  DGrpDismiss.Top := 231;

  DGrpAddMem.Left := 19;
  DGrpAddMem.Top := 231;

  DGrpDelMem.Left := 96;
  DGrpDelMem.Top := 231;

  DGrpAllowGroup.SetImgIndex(g_77Images, 238);
  DRecruitMember.SetImgIndex(g_77Images, 238);
  { ----------------------------------------------------------- }
  D := g_77Images.Images[236]; // 郴 背券芒
  if D <> nil then
    DDealDlg.SetImgIndex(g_77Images, 236);
  DDealOk.SetImgIndex(g_77Images, 107);
  DDealOk.Propertites.DownedIndex := 108;
  SetCloseButtonImage(DDealClose);
  D := g_77Images.Images[237]; // 买进方
  if D <> nil then
    DDealRemoteDlg.SetImgIndex(g_77Images, 237);
  DDRGold.SetImgIndex(g_77Images, 106);
  DDGold.SetImgIndex(g_77Images, 106);
  { ----------------------------------------------------------- }
  // 行会
  D := g_WMainImages.Images[180];
  if D <> nil then
    DGuildDlg.SetImgIndex(g_WMainImages, 180);

  DGuildInfo.Left := 20;
  DGuildInfo.Top := 41;
  SetCloseButtonImage(DGDClose);

  DGDHome.SetImgIndex(g_WMainImages, 198);
  DGDList.SetImgIndex(g_WMainImages, 200);
  DGDChat.SetImgIndex(g_WMainImages, 190);
  DGDAddMem.SetImgIndex(g_WMainImages, 182);
  DGDDelMem.SetImgIndex(g_WMainImages, 192);
  DGDEditNotice.SetImgIndex(g_WMainImages, 196);
  DGDEditGrade.SetImgIndex(g_WMainImages, 194);
  DGDAlly.SetImgIndex(g_WMainImages, 184);
  DGDBreakAlly.SetImgIndex(g_WMainImages, 186);
  DGDWar.SetImgIndex(g_WMainImages, 202);
  DGDCancelWar.SetImgIndex(g_WMainImages, 188);
  DGDUp.SetImgIndex(g_WMainImages, 373);
  DGDDown.SetImgIndex(g_WMainImages, 372);
  CSetImageIndex(DGuidExtentButton,g_77Images,518);
  // 行会通告编辑框
  DGuildEditNotice.SetImgIndex(g_WMainImages, 204);
  DGEOk.SetImgIndex(g_WMainImages, 361);
  DGEClose.SetImgIndex(g_WMainImages, 64);
  { ----------------------------------------------------------- }
  // 属性调整对话框
  DAdjustAbility.SetImgIndex(g_77Images, 54);
  SetCloseButtonImage(DAdjustAbilClose);
  CSetImageIndex(DAdjustAbilOk,g_WMainImages,363);
  DPlusDC.SetImgIndex(g_WMainImages, 212);
  DPlusMC.SetImgIndex(g_WMainImages, 212);
  DPlusSC.SetImgIndex(g_WMainImages, 212);
  DPlusTC.SetImgIndex(g_WMainImages, 212);
  DPlusPC.SetImgIndex(g_WMainImages, 212);
  DPlusWC.SetImgIndex(g_WMainImages, 212);
  DPlusAC.SetImgIndex(g_WMainImages, 212);
  DPlusMAC.SetImgIndex(g_WMainImages, 212);
  DPlusHP.SetImgIndex(g_WMainImages, 212);
  DPlusMP.SetImgIndex(g_WMainImages, 212);
  DPlusHit.SetImgIndex(g_WMainImages, 212);
  DPlusSpeed.SetImgIndex(g_WMainImages, 212);
  DMinusDC.SetImgIndex(g_WMainImages, 214);
  DMinusMC.SetImgIndex(g_WMainImages, 214);
  DMinusSC.SetImgIndex(g_WMainImages, 214);
  DMinusTC.SetImgIndex(g_WMainImages, 214);
  DMinusPC.SetImgIndex(g_WMainImages, 214);
  DMinusWC.SetImgIndex(g_WMainImages, 214);
  DMinusAC.SetImgIndex(g_WMainImages, 214);
  DMinusMAC.SetImgIndex(g_WMainImages, 214);
  DMinusHP.SetImgIndex(g_WMainImages, 214);
  DMinusMP.SetImgIndex(g_WMainImages, 214);
  DMinusHit.SetImgIndex(g_WMainImages, 214);
  DMinusSpeed.SetImgIndex(g_WMainImages, 214);
  { ****************************************************************************** }
  // 关系系统
  DFriendDlg.SetImgIndex(g_77Images, 166);
  CSetImageIndex(DFrdClose,g_77Images,170);

  //关系按钮
  DFriendDlgFrd.SetImgIndex(g_77Images, 168);
  DFriendDlgFrd.Propertites.MoveIndex := 169;
  DFriendDlgFrd.Propertites.DownedIndex := 167;

  DHeiMingDan.SetImgIndex(g_77Images, 168);
  CSetImageIndex(DAddFriend,g_77Images,150);

  DPrevFriendDlg.SetImgIndex(g_77Images, 172);
  DNextFriendDlg.SetImgIndex(g_77Images, 175);
  { ****************************************************************************** }
  // 酒馆1卷　20080508
  D := g_WMain2Images.Images[341];
  if D <> nil then
    DPlayDrink.SetImgIndex(g_WMain2Images, 341);
  DPlayDrinkClose.SetImgIndex(g_WMain2Images, 148);
  D := g_WMain2Images.Images[348];
  if D <> nil then
    DPlayDrinkFist.SetImgIndex(g_WMain2Images, 348);
  D := g_WMain2Images.Images[350];
  if D <> nil then
    DPlayDrinkScissors.SetImgIndex(g_WMain2Images, 350);
  D := g_WMain2Images.Images[350];
  if D <> nil then
    DPlayDrinkCloth.SetImgIndex(g_WMain2Images, 352);
  DPlayFist.SetImgIndex(g_WMain2Images, 358);
  DDrink1.SetImgIndex(g_WMain2Images, 363);
  DDrink2.SetImgIndex(g_WMain2Images, 363);
  DDrink3.SetImgIndex(g_WMain2Images, 363);
  DDrink4.SetImgIndex(g_WMain2Images, 363);
  DDrink5.SetImgIndex(g_WMain2Images, 363);
  DDrink6.SetImgIndex(g_WMain2Images, 363);
  D := g_WMain2Images.Images[340];
  if D <> nil then
  begin
    DWPleaseDrink.SetImgIndex(g_WMain2Images, 340);
    DPDrink1.SetImgIndex(g_WMain2Images, 365);
    DPDrink2.SetImgIndex(g_WMain2Images, 365);
    DPleaseDrinkClose.SetImgIndex(g_WMain2Images, 148);
    DPleaseDrinkDrink.SetImgIndex(g_WMain2Images, 354);
    DPleaseDrinkExit.SetImgIndex(g_WMain2Images, 356);
  end;
  // 酒馆2卷
  D := g_WMain2Images.Images[584];
  if D <> nil then
  begin
    DWMakeWineDesk.SetImgIndex(g_WMain2Images, 584);
    DMakeWineDeskClose.SetImgIndex(g_WMainImages, 371);
    DMakeWineHelp.SetImgIndex(g_WMain2Images, 590);
    DMaterialMemo.SetImgIndex(g_WMain2Images, 590);
    DStartMakeWine.SetImgIndex(g_WMain2Images, 590);
  end;
  { ****************************************************************************** }
  // 验证码 20080612
  DWCheckNum.SetImgIndex(g_WMain3Images, 43);
  DCheckNumClose.SetImgIndex(g_WMainImages, 64);
  DCheckNumOK.SetImgIndex(g_WMain2Images, 146);
  DCheckNumChange.SetImgIndex(g_WMain2Images, 146);
  { ****************************************************************************** }
  // 挑战
  D := g_WMain3Images.Images[465];
  if D <> nil then
  begin
    DWChallenge.SetImgIndex(g_WMain3Images, 465);
    DChallengeClose.SetImgIndex(g_WMain2Images, 148);
    DChallengeOK.SetImgIndex(g_WMain3Images, 463);
    DChallengeCancel.SetImgIndex(g_WMain3Images, 466);
  end;

  DWSplitItem.SetImgIndex(g_77Images, 101);

  CSetImageIndex(DWSplitItemOK,g_77Images,152);
  CSetImageIndex(DWSplitItemCancel,g_77Images,152);

  CSetImageIndex(DWBuyItemCountOK,g_77Images,152);
  CSetImageIndex(DWBuyItemCountCancel,g_77Images,152);

  SetMirOldButtonImageIndex(DWSplitItemAdd,g_77Images,227);
  SetMirOldButtonImageIndex(DWSplitItemDec,g_77Images,228);

  DWBuyItemCount.SetImgIndex(g_77Images, 100);
  DWBuyItemCountOK.SetImgIndex(g_77Images, 152);
  DWBuyItemCountCancel.SetImgIndex(g_77Images, 152);
  DWBuyItemCountAdd.SetImgIndex(g_77Images, 227);
  DWBuyItemCountDec.SetImgIndex(g_77Images, 228);

  DWHeadHealth.SetImgIndex(g_77Images, 353);

  // 自由市场
  DWMarket.SetImgIndex(g_77Images, 83);
  DWMarketSButton.SetImgIndex(g_77Images, 84);
  DWMarketMButton.SetImgIndex(g_77Images, 84);
  DWMarketLButton.SetImgIndex(g_77Images, 84);

  SetCloseButtonImage(DWMarketCloseButton);
  DWMarketRItems.SetImgIndex(g_77Images, 84);
  DWMarketPStall.SetImgIndex(g_77Images, 84);
  DWMarketNStall.SetImgIndex(g_77Images, 84);
  DWMarketBuyItem.SetImgIndex(g_77Images, 84);
  DWMarketVList.SetImgIndex(g_77Images, 84);
  DWMarketRList.SetImgIndex(g_77Images, 84);
  DWMarketVStall.SetImgIndex(g_77Images, 84);
  DWMarketPPage.SetImgIndex(g_77Images, 84);
  DWMarketNPage.SetImgIndex(g_77Images, 84);

  CSetImageIndex(DWMarketSetName,g_77Images,88);

  DWMarketRMyItems.SetImgIndex(g_77Images, 84);

  CSetImageIndex(DWMarketPutOn,g_77Images,84);
  DWMarketItem.SetImgIndex(g_77Images, 103);
  DWMarketItemPutOn.SetImgIndex(g_77Images, 84);
  DWMarketItemPutOff.SetImgIndex(g_77Images, 84);
  SetCloseButtonImage(DWMarketItemClose);
  DWMarketExtGold.SetImgIndex(g_77Images, 84);

  // 邮箱
  DMailList.SetImgIndex(g_77Images, 193);
  DMailReader.SetImgIndex(g_77Images, 210);
  DMailWriter.SetImgIndex(g_77Images, 211);

  SetCloseButtonImage(DBCloseMail);
  SetCloseButtonImage(DBCloseReader);
  SetCloseButtonImage(DBCloseWriter);

  CSetImageIndex(DBNewMail,g_77Images, 152);
  CSetImageIndex(DBReadMail,g_77Images, 152);
  CSetImageIndex(DBDelMail,g_77Images, 152);
  CSetImageIndex(DBDelAllMail,g_77Images, 152);


  DBMLTop.SetImgIndex(g_77Images, 406);
  DBMLScroll.SetImgIndex(g_77Images, 408);
  DBMLBottom.SetImgIndex(g_77Images, 410);
  DBRMTop.SetImgIndex(g_77Images, 406);
  DBRMScroll.SetImgIndex(g_77Images, 408);
  DBRMBottom.SetImgIndex(g_77Images, 410);
  DBWMTop.SetImgIndex(g_77Images, 406);
  DBWMScroll.SetImgIndex(g_77Images, 408);
  DBWMBottom.SetImgIndex(g_77Images, 410);
  DBMailToUsers.SetImgIndex(g_77Images, 410);

  CSetImageIndex(DBMailReply,g_77Images, 152);
  CSetImageIndex(DBMailExtrAtt,g_77Images, 152);
  CSetImageIndex(DBMailSend,g_77Images, 152);

  DBSendGoldType.SetImgIndex(g_77Images, 410);
  DBBuyAttGoldType.SetImgIndex(g_77Images, 410);

  DBMissionSwitch.SetImgIndex(g_77Images, 431);
  DBMissionsWindow.SetImgIndex(g_77Images, 435);
  DBMissionsTop.SetImgIndex(g_77Images, 406);
  DBMissionsScroll.SetImgIndex(g_77Images, 408);
  DBMissionsBottom.SetImgIndex(g_77Images, 410);
  DWMissions.SetImgIndex(g_77Images, 437);
  DBCloseMissions.SetImgIndex(g_77Images, 52);
  DBMissionDoing.SetImgIndex(g_77Images, 438);
  DBMissionUnDo.SetImgIndex(g_77Images, 438);

  DBMissionsListTop.SetImgIndex(g_77Images, 406);
  DBMissionsListScroll.SetImgIndex(g_77Images, 408);
  DBMissionsListBottom.SetImgIndex(g_77Images, 410);

  DWDice.SetImgIndex(g_77Images, 244);
  SetCloseButtonImage(DWDiceClose);

  DWStallWin.SetImgIndex(g_77Images, 494);
  DWStallQueryWin.SetImgIndex(g_77Images, 495);
  DWStallWinClose.SetImgIndex(g_77Images, 52);
  DWStallWinCtrl.SetImgIndex(g_77Images, 84);
  DWStallStop.SetImgIndex(g_77Images, 84);

  DWStallWinGetGold.SetImgIndex(g_77Images, 84);
  DWStallQueryWinClose.SetImgIndex(g_77Images, 52);

  CSetImageIndex(DWStallWinScrollTop,g_77Images, 406);
  DWStallWinScrollBar.SetImgIndex(g_77Images, 408);

  DWStallWinScrollBottom.SetImgIndex(g_77Images, 410);
  DWStallQueryWinScrollTop.SetImgIndex(g_77Images, 406);
  DWStallQueryWinScrollBar.SetImgIndex(g_77Images, 408);
  DWStallQueryWinScrollBttom.SetImgIndex(g_77Images, 410);

  DWChatHistory.SetImgIndex(g_WMainImages, 1150);
  DWChatHistoryClose.SetImgIndex(g_77Images, 52);
  DBChatHistoryScrollTop.SetImgIndex(g_77Images, 406);
  DBChatHistoryScrollBar.SetImgIndex(g_77Images, 408);
  DBChatHistoryScrollBottom.SetImgIndex(g_77Images, 410);
  DButtonSideBar.SetImgIndex(g_77Images,513);
  DButtonSideBar.Propertites.DownedIndex := 515;
  DButtonSideBar.Propertites.DownedIndex := 514;


  DTopExtendButtons.WIDTH := 300;;
  DTopExtendButtons.Height := 50;
  DTopExtendButtons.Top := 8;
  DTopExtendButtons.Left := SCREENWIDTH - 136 - DTopExtendButtons.WIDTH - 16;



  frmNewItem.Initialize; // 初始化首饰盒和十二生肖界面
  frmViewOtherNewItem.Initialize;

  DLockClientPassword.SetImgIndex(g_77Images,243);
  CSetImageIndex(DLockClientPasswordOk,g_WMainImages,361);
  DTCaption.Left := 33;
  DTCaption.Top := 51;
  DEDT_LockPassword.Left := 29;
  DEDT_LockPassword.Top := 88;
  DEDT_LockPassword.Width := 400;
  DEDT_LockPassword.Height := 20;
  DLockClientPasswordOk.Left := 319;
  DLockClientPasswordOk.Top := 120;

  DLockClientPassword.Left := (SCREENWIDTH - DLockClientPassword.Width) div 2;
  DLockClientPassword.Top := (SCREENHEIGHT - DLockClientPassword.Height) div 2;

  DExitGame.SetImgIndex(g_77Images,243);
  DExitOk.Left := 214;
  DExitOk.Top := 126;
  DExitOk.SetImgIndex(g_WMainImages,361);
  DExitOk.Propertites.DownedIndex := 362;

  DExitCancel.Left := 324;
  DExitCancel.Top := 126;
  DExitCancel.SetImgIndex(g_WMainImages,365);
  DExitCancel.Propertites.DownedIndex := 366;

  DExitGameHint.Left := 39;
  DExitGameHint.Top := 38;



end;

// 初始化图象位置 20080524
procedure TFrmDlg.InitializePlace;
begin
  // 荣誉显示
  DGlory.Left := 721;
  DGlory.Top := 152;
  // ==============================================================================
  // 酒馆相关 20080508
  DPlayDrink.Left := 174;
  DPlayDrink.Top := 50;
  DPlayDrinkClose.Left := 428;
  DPlayDrinkClose.Top := 34;
  DPlayDrinkFist.Left := 395;
  DPlayDrinkFist.Top := 240;
  DPlayDrinkScissors.Left := 351;
  DPlayDrinkScissors.Top := 250;
  DPlayDrinkCloth.Left := 342;
  DPlayDrinkCloth.Top := 294;
  DPlayFist.Left := 390;
  DPlayFist.Top := 286;
  DDrink1.Left := 155;
  DDrink1.Top := 140;
  DDrink2.Left := 225;
  DDrink2.Top := 140;
  DDrink3.Left := 100;
  DDrink3.Top := 170;
  DDrink4.Left := 280;
  DDrink4.Top := 170;
  DDrink5.Left := 160;
  DDrink5.Top := 190;
  DDrink6.Left := 230;
  DDrink6.Top := 190;
  DWPleaseDrink.Left := 200;
  DWPleaseDrink.Top := 139;
  DPDrink1.Left := 125;
  DPDrink1.Top := 136;
  DPDrink2.Left := 210;
  DPDrink2.Top := 165;
  DPleaseDrinkClose.Left := 376;
  DPleaseDrinkClose.Top := 40;
  DPleaseDrinkDrink.Left := 287;
  DPleaseDrinkDrink.Top := 263;
  DPleaseDrinkExit.Left := 338;
  DPleaseDrinkExit.Top := 263;
  DPlayDrinkNpcNum.Left := 0;
  DPlayDrinkNpcNum.Top := 172;
  DPlayDrinkPlayNum.Left := 269;
  DPlayDrinkPlayNum.Top := 172;
  DPlayDrinkWhoWin.Left := 173;
  DPlayDrinkWhoWin.Top := 128;
  // 酒馆2卷
  DWMakeWineDesk.Left := 380;
  DWMakeWineDesk.Top := 50;
  DMakeWineDeskClose.Left := 362;
  DMakeWineDeskClose.Top := 7;
  DMakeWineHelp.Left := 17;
  DMakeWineHelp.Top := 134;
  DMaterialMemo.Left := 17;
  DMaterialMemo.Top := 162;
  DStartMakeWine.Left := 17;
  DStartMakeWine.Top := 208;
  DBMateria.WIDTH := 32;
  DBMateria.Height := 30;
  DBMateria.Left := 114;
  DBMateria.Top := 225;

  DBWineSong.WIDTH := 32;
  DBWineSong.Height := 30;
  DBWineSong.Left := 162;
  DBWineSong.Top := 211;
  DBWater.WIDTH := 32;
  DBWater.Height := 30;
  DBWater.Left := 162;
  DBWater.Top := 244;
  DBWineCrock.WIDTH := 32;
  DBWineCrock.Height := 30;
  DBWineCrock.Left := 208;
  DBWineCrock.Top := 225;
  DBAssistMaterial1.WIDTH := 32;
  DBAssistMaterial1.Height := 30;
  DBAssistMaterial1.Left := 258;
  DBAssistMaterial1.Top := 225;
  DBAssistMaterial2.WIDTH := 32;
  DBAssistMaterial2.Height := 30;
  DBAssistMaterial2.Left := 293;
  DBAssistMaterial2.Top := 225;
  DBAssistMaterial3.WIDTH := 32;
  DBAssistMaterial3.Height := 30;
  DBAssistMaterial3.Left := 328;
  DBAssistMaterial3.Top := 225;

  DBDrug.WIDTH := 32;
  DBDrug.Height := 30;
  DBDrug.Left := 149;
  DBDrug.Top := 226;

  DBWine.WIDTH := 32;
  DBWine.Height := 30;
  DBWine.Left := 220;
  DBWine.Top := 226;

  DBWineBottle.WIDTH := 32;
  DBWineBottle.Height := 30;
  DBWineBottle.Left := 291;
  DBWineBottle.Top := 226;
  // ==============================================================================
  // 挑战
  DWChallenge.Left := 544;
  DWChallenge.Top := 10;
  DChallengeClose.Left := 238;
  DChallengeClose.Top := 0;
  DChallengeOK.Left := 73;
  DChallengeOK.Top := 231;
  DChallengeCancel.Left := 122;
  DChallengeCancel.Top := 231;
  DChallengeGrid.Left := 26;
  DChallengeGrid.Top := 156;
  DChallengeGrid.WIDTH := 188;
  DChallengeGrid.Height := 34;
  DChallengeGold.Top := 198;
  DChallengeGold.Left := 26;
  DChallengeGold.WIDTH := 41;
  DChallengeGold.Height := 20;
  DRChallengeGrid.Left := 26;
  DRChallengeGrid.Top := 56;
  DRChallengeGrid.WIDTH := 188;
  DRChallengeGrid.Height := 34;
  // 属性调整对话框
  DAdjustAbilClose.Left := 400;
  DAdjustAbilClose.Top := 1;
  DAdjustAbilOk.Left := 300;
  DAdjustAbilOk.Top := 298;

  SetBottomButtonsPosition;
  SetAjustAbiPosition;
  SetOrderPosition;

  DFriendDlg.Left := 160;
  DFriendDlg.Top := 120;
  DFrdClose.Left := 238;
  DFrdClose.Top := 10;
  DFriendDlgFrd.Left := 38;
  DFriendDlgFrd.Top := 48;
  DHeiMingDan.Left := 38;
  DHeiMingDan.Top := 338;
  DAddFriend.Left := 214;
  DAddFriend.Top := 320;
  DPrevFriendDlg.Left := 224;
  DPrevFriendDlg.Top := 90;
  DNextFriendDlg.Left := 224;
  DNextFriendDlg.Top := 132;
  DFriendList.Top := 90;
  DFriendList.Left := 42;
  DFriendList.WIDTH := 170;
  DFriendList.Height := 238;

  DWMiniMap.Left := SCREENWIDTH - 132;
  DWMiniMap.Top := 0;
  DWMiniMap.WIDTH := 132;
  DWMiniMap.Height := 150;
  DWMiniMapCtr.Left := 110;
  DWMiniMapCtr.Top := 0;
  DWMiniMapCtr.WIDTH := 24;
  DWMiniMapCtr.Height := 22;
  DWMiniMapCtr.SetImgIndex(g_77Images,348);
  DWMiniMapCtr.Propertites.MoveIndex := 349;
  DWMiniMapCtr.Propertites.DownedIndex := 350;


  DWMaxMiniMap.Left := (SCREENWIDTH - 600) div 2;
  DWMaxMiniMap.Top := (SCREENHEIGHT - 480 - DBottom.Height) div 2;
  DWMaxMiniMap.WIDTH := 600;
  DWMaxMiniMap.Height := 480;
  DWMaxMiniMapC.Left := 16;
  DWMaxMiniMapC.Top := 65;
  DWMaxMiniMapC.WIDTH := 566;
  DWMaxMiniMapC.Height := 392;
  DCloseMaxMiniMap.Left := 567;
  DCloseMaxMiniMap.Top := 33;
  DCloseMaxMiniMap.WIDTH := 16;
  DCloseMaxMiniMap.Height := 23;
  DTMapName.Left := 83;
  DTMapName.Top := 42;
  DTMapMouseX.Left := 373;
  DTMapMouseX.Top := 43;
  DTMapMouseY.Left := 460;
  DTMapMouseY.Top := 43;



  // ==============================================================================
  // SplashForm.ProgressBar1.Position := SplashForm.ProgressBar1.Position + 2;
  // 行会
  DGuildDlg.Left := 0;
  DGuildDlg.Top := 0;
  DGDClose.Left := 584;
  DGDClose.Top := 6;
  DGDHome.Left := 13;
  DGDHome.Top := 411;
  DGDList.Left := 13;
  DGDList.Top := 429;
  DGDChat.Left := 94;
  DGDChat.Top := 429;
  DGDAddMem.Left := 243;
  DGDAddMem.Top := 411;
  DGDDelMem.Left := 243;
  DGDDelMem.Top := 429;
  DGDEditNotice.Left := 325;
  DGDEditNotice.Top := 411;
  DGDEditGrade.Left := 325;
  DGDEditGrade.Top := 429;
  DGDAlly.Left := 407;
  DGDAlly.Top := 411;
  DGDBreakAlly.Left := 407;
  DGDBreakAlly.Top := 429;
  DGDWar.Left := 529;
  DGDWar.Top := 411;
  DGDCancelWar.Left := 529;
  DGDCancelWar.Top := 429;
  DGDUp.Left := 595;
  DGDUp.Top := 239;
  DGDDown.Left := 595;
  DGDDown.Top := 291;
  DGuidExtentButton.Left := 570 - DGuidExtentButton.WIDTH;
  DGuidExtentButton.Top := 8;
  // 行会通告编辑框
  DGEOk.Left := 514;
  DGEOk.Top := 287;
  DGEClose.Left := 584;
  DGEClose.Top := 6;
  DGuildEditNotice.Left := (SCREENWIDTH - DGuildEditNotice.WIDTH) div 2;
  DGuildEditNotice.Top := (SCREENHEIGHT - DGuildEditNotice.Height) div 2;
  // ==============================================================================
  DDealDlg.Left := 564;
  DDealDlg.Top := 0;
  DDGrid.Left := 21;
  DDGrid.Top := 56;
  DDGrid.WIDTH := 180;
  DDGrid.Height := 66;
  DDealOk.Left := 155;
  DDealOk.Top := 130;
  DDealClose.Left := 220;
  DDealClose.Top := 44;
  DDGold.Left := 12;
  DDGold.Top := 137;
  DDealRemoteDlg.Left := 344;
  DDealRemoteDlg.Top := 0;
  DDRGrid.Left := 21;
  DDRGrid.Top := 56;
  DDRGrid.WIDTH := 180;
  DDRGrid.Height := 66;
  DDRGold.Left := 12;
  DDRGold.Top := 137;
  DStallCtrl.Left := 218;
  DStallCtrl.Top := 220;
  // ==============================================================================
  // 组队话框
  DGroupDlg.Left := SCREENWIDTH - 260;
  DGroupDlg.Top := (SCREENHEIGHT - 299 - 140) div 2;
  DGrpDlgClose.Left := 230;
  DGrpDlgClose.Top := 12;
  DGrpAllowGroup.Left := 146;
  DGrpAllowGroup.Top := 262;

  DRecruitMember.Left := 30;
  DRecruitMember.Top := 262;
  // ==============================================================================
  // 设置魔法快捷对话框
  DKeySelDlg.Left := 212;
  DKeySelDlg.Top := 210;
  DKsIcon.Left := 51;
  DKsIcon.Top := 31;
  DKsF1.Left := 25;
  DKsF1.Top := 78;
  DKsF2.Left := 57;
  DKsF2.Top := 78;
  DKsF3.Left := 89;
  DKsF3.Top := 78;
  DKsF4.Left := 121;
  DKsF4.Top := 78;
  DKsF5.Left := 160;
  DKsF5.Top := 78;
  DKsF6.Left := 192;
  DKsF6.Top := 78;
  DKsF7.Left := 224;
  DKsF7.Top := 78;
  DKsF8.Left := 256;
  DKsF8.Top := 78;
  DKsConF1.Left := 25;
  DKsConF1.Top := 120;
  DKsConF2.Left := 57;
  DKsConF2.Top := 120;
  DKsConF3.Left := 89;
  DKsConF3.Top := 120;
  DKsConF4.Left := 121;
  DKsConF4.Top := 120;
  DKsConF5.Left := 160;
  DKsConF5.Top := 120;
  DKsConF6.Left := 192;
  DKsConF6.Top := 120;
  DKsConF7.Left := 224;
  DKsConF7.Top := 120;
  DKsConF8.Left := 256;
  DKsConF8.Top := 120;
  DKsNone.Left := 296;
  DKsNone.Top := 78;
  DKsOk.Left := 296;
  DKsOk.Top := 120;
  // ==============================================================================
  // SplashForm.ProgressBar1.Position := SplashForm.ProgressBar1.Position + 4;
  // 出售
  DSellDlg.Left := 328;
  DSellDlg.Top := 163;
  DSellDlgOk.Left := 85;
  DSellDlgOk.Top := 150;
  DSellDlgClose.Left := 115;
  DSellDlgClose.Top := 0;
  DSellDlgSpot.Left := 27;
  DSellDlgSpot.Top := 67;
  DSellDlgSpot.WIDTH := 61;
  DSellDlgSpot.Height := 52;
  // ==============================================================================
  // 菜单对话框
  DMenuDlg.Left := 138;
  DMenuDlg.Top := 163;
  DMenuPrev.Left := 43;
  DMenuPrev.Top := 175;
  DMenuNext.Left := 90;
  DMenuNext.Top := 175;
  DMenuBuy.Left := 215;
  DMenuBuy.Top := 171;
  DMenuClose.Left := 291;
  DMenuClose.Top := 0;
  // ==============================================================================
  // SplashForm.ProgressBar1.Position := SplashForm.ProgressBar1.Position + 2;
  // 装备升级
  DItemsUp.Left := 402;
  DItemsUp.Top := 163;
  DItemsUpClose.Left := 232;
  DItemsUpClose.Top := 0;
  DItemsUpOk.Left := 91;
  DItemsUpOk.Top := 176;
  // ==============================================================================
  // 宝箱
  DBoxs.Left := 215;
  DBoxs.Top := 164;
  DBoxsBelt1.Left := 30;
  DBoxsBelt1.Top := 28;
  DBoxsBelt2.Left := 80;
  DBoxsBelt2.Top := 28;
  DBoxsBelt3.Left := 130;
  DBoxsBelt3.Top := 28;
  DBoxsBelt4.Left := 30;
  DBoxsBelt4.Top := 76;
  DBoxsBelt5.Left := 80;
  DBoxsBelt5.Top := 76;
  DBoxsBelt6.Left := 130;
  DBoxsBelt6.Top := 76;
  DBoxsBelt7.Left := 30;
  DBoxsBelt7.Top := 124;
  DBoxsBelt8.Left := 80;
  DBoxsBelt8.Top := 124;
  DBoxsBelt9.Left := 130;
  DBoxsBelt9.Top := 124;
  DBoxsTautology.Left := 77;
  DBoxsTautology.Top := 175;
  // ==============================================================================
  // SplashForm.ProgressBar1.Position := SplashForm.ProgressBar1.Position + 4;
  // NPC、商人对话
  DMerchantDlg.Left := 0;
  DMerchantDlg.Top := 0;
  DMerchantDlgClose.Left := 399;
  DMerchantDlgClose.Top := 1;
  DMerchantDlgMessage.Left := MerchantDlgLeft;
  DMerchantDlgMessage.Top := MerchantDlgTop;
  DMerchantDlgMessage.WIDTH := DMerchantDlg.WIDTH - MerchantDlgLeft;
  DMerchantDlgMessage.Height := DMerchantDlg.Height - MerchantDlgTop;
  // ==============================================================================
  // 背包金币图片
  DGold.Left := 12;
  DGold.Top := 228;
  DItemsUpBut.Left := 293;
  DItemsUpBut.Top := 223;
  DItemsRefresh.WIDTH := 26;
  DItemsRefresh.Height := 22;
  DItemsRefresh.Left := 270;
  DItemsRefresh.Top := 271;
  DCloseBag.Left := 330;
  DCloseBag.Top := 39;
  DCloseBag.WIDTH := 14;
  DCloseBag.Height := 20;

  // ==============================================================================
  RefusePublicChat.Left := 175;
  RefusePublicChat.Top := 120;
  RefuseCRY.Left := 175;
  RefuseCRY.Top := 140;
  RefuseWHISPER.Left := 175;
  RefuseWHISPER.Top := 160;
  Refuseguild.Left := 175;
  Refuseguild.Top := 180;

  AutoCRY.Left := 175;
  AutoCRY.Top := 200;

  DHelp.Left := SCREENWIDTH - 197;
  DHelp.Top := 66; // 66;
  DInternet.Left := 170;
  DInternet.Top := 66;
  DSighIcon.Left := SCREENWIDTH - 230;
  DSighIcon.Top := 62;
  // ==============================================================================
  // 淬炼20080506
  DItemsUpBelt1.Left := 100;
  DItemsUpBelt1.Top := 35;
  DItemsUpBelt1.WIDTH := 34;
  DItemsUpBelt1.Height := 31;

  DItemsUpBelt2.Left := 40;
  DItemsUpBelt2.Top := 110;
  DItemsUpBelt2.WIDTH := 34;
  DItemsUpBelt2.Height := 31;

  DItemsUpBelt3.Left := 160;
  DItemsUpBelt3.Top := 112;
  DItemsUpBelt3.WIDTH := 34;
  DItemsUpBelt3.Height := 31;
  // ==============================================================================
  // SplashForm.ProgressBar1.Position := SplashForm.ProgressBar1.Position + 4;
  // Stop
  DShop.Left := 0;
  DShop.Top := 0;
  DShopClose.Left := 606;
  DShopClose.Top := 5;
  DShopClose.WIDTH := 14;
  DShopClose.Height := 20;
  DTabGameShopType.Left := 9;
  DTabGameShopType.Top := 8;
  DShopBuy.Left := 52;
  DShopBuy.Top := 270;
  DBPay.Left := 52;
  DBPay.Top := 354;
  DShopPrev.Left := 197;
  DShopPrev.Top := 349;
  DShopNext.Left := 287;
  DShopNext.Top := 349;
  DShopImgLogo.Left := 72;
  DShopImgLogo.Top := 82;
  DShopImgLogo.WIDTH := 32;
  DShopImgLogo.Height := 32;
  DShopDecorate.Left := 176;
  DShopDecorate.Top := 13;
  DShopSupplies.Left := 234;
  DShopSupplies.Top := 13;
  DshopStrengthen.Left := 292;
  DshopStrengthen.Top := 13;
  DShopFriend.Left := 350;
  DShopFriend.Top := 13;
  DShopCapacity.Left := 408;
  DShopCapacity.Top := 13;
  DShopSpeciallyImg1.Left := 517;
  DShopSpeciallyImg1.Top := 67;
  DShopSpeciallyImg1.WIDTH := 90;
  DShopSpeciallyImg1.Height := 60;
  DShopSpeciallyImg2.Left := 517;
  DShopSpeciallyImg2.Top := 132;
  DShopSpeciallyImg2.WIDTH := 90;
  DShopSpeciallyImg2.Height := 60;
  DShopSpeciallyImg3.Left := 517;
  DShopSpeciallyImg3.Top := 197;
  DShopSpeciallyImg3.WIDTH := 90;
  DShopSpeciallyImg3.Height := 60;
  DShopSpeciallyImg4.Left := 517;
  DShopSpeciallyImg4.Top := 262;
  DShopSpeciallyImg4.WIDTH := 90;
  DShopSpeciallyImg4.Height := 60;
  DShopSpeciallyImg5.Left := 517;
  DShopSpeciallyImg5.Top := 327;
  DShopSpeciallyImg5.WIDTH := 90;
  DShopSpeciallyImg5.Height := 60;
  DShopImg1.Left := 178;
  DShopImg1.Top := 61;
  DShopImg1.WIDTH := 160;
  DShopImg1.Height := 52;
  DShopImg2.Left := 349;
  DShopImg2.Top := 61;
  DShopImg2.WIDTH := 160;
  DShopImg2.Height := 52;
  DShopImg3.Left := 178;
  DShopImg3.Top := 115;
  DShopImg3.WIDTH := 160;
  DShopImg3.Height := 52;
  DShopImg4.Left := 349;
  DShopImg4.Top := 115;
  DShopImg4.WIDTH := 160;
  DShopImg4.Height := 52;
  DShopImg5.Left := 178;
  DShopImg5.Top := 167;
  DShopImg5.WIDTH := 160;
  DShopImg5.Height := 52;
  DShopImg6.Left := 349;
  DShopImg6.Top := 169;
  DShopImg6.WIDTH := 160;
  DShopImg6.Height := 52;
  DShopImg7.Left := 178;
  DShopImg7.Top := 223;
  DShopImg7.WIDTH := 160;
  DShopImg7.Height := 52;
  DShopImg8.Left := 349;
  DShopImg8.Top := 220;
  DShopImg8.WIDTH := 160;
  DShopImg8.Height := 52;
  DShopImg9.Left := 178;
  DShopImg9.Top := 277;
  DShopImg9.WIDTH := 160;
  DShopImg9.Height := 52;
  DShopImg10.Left := 349;
  DShopImg10.Top := 277;
  DShopImg10.WIDTH := 160;
  DShopImg10.Height := 52;
  //
  DEShopAmount.Left := 29;
  DEShopAmount.Top := 199;
  DEShopAmount.Height := 16;
  DEShopAmount.WIDTH := 92;

  DBShopCAdd.Left := 121;
  DBShopCAdd.Top := 199;
  DBShopCAdd.WIDTH := 16;
  SetMirOldButtonImageIndex(DBShopCAdd,g_77Images,228);

  DBShopCDec.Left := 137;
  DBShopCDec.Top := 199;
  DBShopCDec.WIDTH := 16;
  SetMirOldButtonImageIndex(DBShopCDec,g_77Images,228);

  // ==============================================================================
  // 背包物品窗口
  DItemBag.Left := 0;
  DItemBag.Top := 0;
  DItemGrid.Left := 23;
  DItemGrid.Top := 21;
  DItemGrid.WIDTH := 286;
  DItemGrid.Height := 195;

  DLevelOrder.WIDTH := 564;
  DLevelOrder.Height := 362;
  DLevelOrder.Left := (SCREENWIDTH - DLevelOrder.WIDTH) div 2;
  DLevelOrder.Top := (SCREENHEIGHT - DLevelOrder.Height - DBottom.Height) div 2;
  DLevelOrderClose.Left := 543;
  DLevelOrderClose.Top := 33;
  DLevelOrderClose.WIDTH := 14;
  DLevelOrderClose.Height := 20;

  DLevelOrderIndex.Left := 24;
  DLevelOrderIndex.Top := 312;
  DLevelOrderPrev.Left := 84;
  DLevelOrderPrev.Top := 312;
  DLevelOrderNext.Left := 144;
  DLevelOrderNext.Top := 312;
  DLevelOrderLastPage.Left := 204;
  DLevelOrderLastPage.Top := 312;
  DMyLevelOrder.Left := 264;
  DMyLevelOrder.Top := 312;

  case g_DWinMan.UIType of
    skNormal:
      begin
        // 选择角色窗口
        DSelectChr.Left := Round((SCREENWIDTH - 800) / 2);
        DSelectChr.Top := Round((SCREENHEIGHT - 600) / 2);
        DSelectChr.WIDTH := 800;
        DSelectChr.Height := 600;
        // 选择人物那各个按钮坐标
        DscSelect1.Left := 134;
        DscSelect1.Top := 454;
        DscSelect2.Left := 685;
        DscSelect2.Top := 454;
        DscSelect3.visible := False;
        DscSelect4.visible := False;
        DscSelect5.visible := False;
        DscStart.Left := 385;
        DscStart.Top := 456;
        DscNewChr.Left := 348;
        DscNewChr.Top := 486;
        DscEraseChr.Left := 347;
        DscEraseChr.Top := 506;
        DscCredits.Left := 346;
        DscCredits.Top := 527;
        DscExit.Left := 379;
        DscExit.Top := 547;
        DscPriorPage.Left := 360;
        DscPriorPage.Top := 420;
        DscNextPage.Left := 416;
        DscNextPage.Top := 420;

        DccWarrior.Left := 48;
        DccWarrior.Top := 157;
        DccWizzard.Left := 93;
        DccWizzard.Top := 157;
        DccMonk.Left := 138;
        DccMonk.Top := 157;
        DccReserved.visible := False;
        DccMale.Left := 93;
        DccMale.Top := 231;
        DccFemale.Left := 138;
        DccFemale.Top := 231;
        DccLeftHair.Left := 76;
        DccLeftHair.Top := 308;
        DccRightHair.Left := 170;
        DccRightHair.Top := 308;
        DccOk.Left := 104;
        DccOk.Top := 361;
        DccClose.Left := 248;
        DccClose.Top := 31;
      end;
    skReturn:
      begin
        DscSelect1.WIDTH := 100;
        DscSelect1.Height := 240;
        DscSelect2.WIDTH := 100;
        DscSelect2.Height := 240;
        DscSelect3.WIDTH := 100;
        DscSelect3.Height := 240;
        DscSelect4.WIDTH := 100;
        DscSelect4.Height := 240;
        DscSelect5.WIDTH := 100;
        DscSelect5.Height := 240;

        Dachr1.WIDTH := 100;
        Dachr1.Height := 240;

        Dachr2.WIDTH := 100;
        Dachr2.Height := 240;

        Dachr3.WIDTH := 100;
        Dachr3.Height := 240;

        Dachr4.WIDTH := 100;
        Dachr4.Height := 240;

        Dachr5.WIDTH := 100;
        Dachr5.Height := 240;

        DscStart.WIDTH := 150;
        DscStart.Height := 44;
        DscNewChr.WIDTH := 140;
        DscNewChr.Height := 36;
        DscEraseChr.WIDTH := 140;
        DscEraseChr.Height := 36;
        DscCredits.WIDTH := 140;
        DscCredits.Height := 36;
        DscExit.WIDTH := 140;
        DscExit.Height := 36;
        DscPriorPage.WIDTH := 24;
        DscPriorPage.Height := 14;
        DscNextPage.WIDTH := 24;
        DscNextPage.Height := 14;
        case DISPLAYSIZETYPE of
          0:
            begin
              DSelectChr.Left := (SCREENWIDTH - 1024) div 2;
              DSelectChr.Top := (SCREENHEIGHT - 768) div 2;
              DSelectChr.WIDTH := 1024;
              DSelectChr.Height := 768;

              DscSelect1.Left := 464;
              DscSelect1.Top := 232;
              DAChr1.Left := 464;
              DAChr1.Top := 232;

              DscSelect2.Left := 290;
              DscSelect2.Top := 336;
              DAChr2.Left := 290;
              DAChr2.Top := 336;

              DscSelect3.Left := 630;
              DscSelect3.Top := 336;
              DAChr3.Left := 630;
              DAChr3.Top := 336;

              DscSelect4.Left := 110;
              DscSelect4.Top := 460;
              DAChr4.Left := 110;
              DAChr4.Top := 460;

              DscSelect5.Left := 790;
              DscSelect5.Top := 460;
              DAChr5.Left := 790;
              DAChr5.Top := 460;

              DscStart.Left := 438;
              DscStart.Top := 698;
              DscNewChr.Left := 52;
              DscNewChr.Top := 700;
              DscEraseChr.Left := 242;
              DscEraseChr.Top := 700;
              DscCredits.Left := 642;
              DscCredits.Top := 700;
              DscExit.Left := 832;
              DscExit.Top := 700;
              DscPriorPage.Left := 472;
              DscPriorPage.Top := 676;
              DscNextPage.Left := 528;
              DscNextPage.Top := 676;
            end;
          1:
            begin
              DSelectChr.Left := (SCREENWIDTH - 960) div 2;
              DSelectChr.Top := (SCREENHEIGHT - 600) div 2;
              DSelectChr.WIDTH := 960;
              DSelectChr.Height := 600;

              DscSelect1.Left := 430;
              DscSelect1.Top := 168;
              DAChr1.Left := 430;
              DAChr1.Top := 168;

              DscSelect2.Left := 270;
              DscSelect2.Top := 250;
              DAChr2.Left := 270;
              DAChr2.Top := 250;

              DscSelect3.Left := 600;
              DscSelect3.Top := 250;
              DAChr3.Left := 600;
              DAChr3.Top := 250;

              DscSelect4.Left := 90;
              DscSelect4.Top := 350;
              DAChr4.Left := 90;
              DAChr4.Top := 350;

              DscSelect5.Left := 730;
              DscSelect5.Top := 350;
              DAChr5.Left := 730;
              DAChr5.Top := 350;

              DscStart.Left := 406;
              DscStart.Top := 530;
              DscNewChr.Left := 20;
              DscNewChr.Top := 544;
              DscEraseChr.Left := 210;
              DscEraseChr.Top := 544;
              DscCredits.Left := 610;
              DscCredits.Top := 544;
              DscExit.Left := 800;
              DscExit.Top := 544;
              DscPriorPage.Left := 442;
              DscPriorPage.Top := 498;
              DscNextPage.Left := 496;
              DscNextPage.Top := 498;
            end;
          2:
            begin
              DSelectChr.Left := (SCREENWIDTH - 800) div 2;
              DSelectChr.Top := (SCREENHEIGHT - 600) div 2;
              DSelectChr.WIDTH := 800;
              DSelectChr.Height := 600;

              DscSelect1.Left := 360;
              DscSelect1.Top := 170;
              DAChr1.Left := 360;
              DAChr1.Top := 170;

              DscSelect2.Left := 220;
              DscSelect2.Top := 250;
              DAchr2.Left := 220;
              DAchr2.Top := 250;

              DscSelect3.Left := 490;
              DscSelect3.Top := 250;
              DAchr3.Left := 490;
              DAchr3.Top := 250;

              DscSelect4.Left := 60;
              DscSelect4.Top := 350;
              DAchr4.Left := 60;
              DAchr4.Top := 350;

              DscSelect5.Left := 600;
              DscSelect5.Top := 350;
              DAchr5.Left := 600;
              DAchr5.Top := 350;

              DscStart.Left := 325;
              DscStart.Top := 480;
              DscNewChr.Left := 40;
              DscNewChr.Top := 544;
              DscEraseChr.Left := 230;
              DscEraseChr.Top := 544;
              DscCredits.Left := 426;
              DscCredits.Top := 544;
              DscExit.Left := 616;
              DscExit.Top := 544;
              DscPriorPage.Left := 360;
              DscPriorPage.Top := 448;
              DscNextPage.Left := 416;
              DscNextPage.Top := 448;
            end;
        end;
        DccWarrior.Left := 58;
        DccWarrior.Top := 68;
        DccWizzard.Left := 114;
        DccWizzard.Top := 68;
        DccMonk.Left := 170;
        DccMonk.Top := 68;
        DccAssassin.Left := 58;
        DccAssassin.Top := 124;
        DccArcher.Left := 114;
        DccArcher.Top := 124;
        DccReserved.Left := 170;
        DccReserved.Top := 124;
        DccReserved.Enabled := False;

        DccMale.Left := 86;
        DccMale.Top := 200;
        DccFemale.Left := 142;
        DccFemale.Top := 200;
        DccLeftHair.Left := 76;
        DccLeftHair.Top := 308;
        DccRightHair.Left := 170;
        DccRightHair.Top := 308;
        DccOk.Left := 70;
        DccOk.Top := 396;
        DccClose.Left := 152;
        DccClose.Top := 396;
      end;
    skMir4:
      begin
        DscSelect3.visible := False;
        DscSelect4.visible := False;
        DscSelect5.visible := False;
        case DISPLAYSIZETYPE of
          0:
            begin
              DSelectChr.Left := Round((SCREENWIDTH - 1024) / 2);
              DSelectChr.Top := Round((SCREENHEIGHT - 768) / 2);
              DSelectChr.WIDTH := 1024;
              DSelectChr.Height := 768;
              DscSelect1.Left := 154;
              DscSelect1.Top := 590;
              DscSelect2.Left := 754;
              DscSelect2.Top := 590;
              DscStart.Left := 446;
              DscStart.Top := 590;
              DscNewChr.Left := 386;
              DscNewChr.Top := 644;
              DscCredits.Left := 516;
              DscCredits.Top := 644;
              DscEraseChr.Left := 386;
              DscEraseChr.Top := 692;
              DscExit.Left := 516;
              DscExit.Top := 692;
              DscPriorPage.Left := 472;
              DscPriorPage.Top := 550;
              DscNextPage.Left := 528;
              DscNextPage.Top := 550;
            end;
          1, 2:
            begin
              DSelectChr.Left := Round((SCREENWIDTH - 800) / 2);
              DSelectChr.Top := Round((SCREENHEIGHT - 600) / 2);
              DSelectChr.WIDTH := 800;
              DSelectChr.Height := 600;
              DscSelect1.Left := 102;
              DscSelect1.Top := 464;
              DscSelect2.Left := 610;
              DscSelect2.Top := 464;
              DscStart.Left := 330;
              DscStart.Top := 464;
              DscNewChr.Left := 270;
              DscNewChr.Top := 512;
              DscCredits.Left := 410;
              DscCredits.Top := 512;
              DscEraseChr.Left := 270;
              DscEraseChr.Top := 556;
              DscExit.Left := 410;
              DscExit.Top := 556;
              DscPriorPage.Left := 360;
              DscPriorPage.Top := 450;
              DscNextPage.Left := 416;
              DscNextPage.Top := 450;
            end;
        end;
        DccWarrior.Left := 60;
        DccWarrior.Top := 186;
        DccWizzard.Left := 120;
        DccWizzard.Top := 186;
        DccMonk.Left := 180;
        DccMonk.Top := 186;
        DccAssassin.Left := 240;
        DccAssassin.Top := 186;
        DccReserved.visible := False;
        DccMale.Left := 120;
        DccMale.Top := 272;
        DccFemale.Left := 180;
        DccFemale.Top := 272;
        DccLeftHair.Left := 76;
        DccLeftHair.Top := 308;
        DccRightHair.Left := 170;
        DccRightHair.Top := 308;
        DccOk.Left := 116;
        DccOk.Top := 350;
        DccClose.Left := 310;
        DccClose.Top := 12;
      end;
  end;

  dwRecoverChr.Left := 24;
  dwRecoverChr.Top := 26;
  btnRecvChrClose.Left := 247;
  btnRecvChrClose.Top := 30;
  btnRecover.Left := 100;
  btnRecover.Top := 360;

  // ==============================================================================
  // 连击版状态栏 20091208
  // DAttect.WIDTH := 20;
  // DAttect.Height := 46;
  // DAttect.Left := 0;
  // DAttect.Top := 126 + 180;

  DBatterRandom.Left := 70;
  DBatterRandom.Top := 100;

  DBatterSort.Left := 140;
  DBatterSort.Top := 100;
  // -----------------------------------------------------------------

  DAttzhanshi.WIDTH := 80;
  DAttzhanshi.Height := 15;
  DAttzhanshi.Left := 45;
  DAttzhanshi.Top := 70;

  DAttfashi.WIDTH := 80;
  DAttfashi.Height := 15;
  DAttfashi.Left := 45;
  DAttfashi.Top := 95;

  DAttdaoshi.WIDTH := 80;
  DAttdaoshi.Height := 15;
  DAttdaoshi.Left := 45;
  DAttdaoshi.Top := 120;

  DWProgress.WIDTH := 186;
  DWProgress.Height := 61;
  DWProgress.Left := (SCREENWIDTH - 186) div 2;
  DWProgress.Top := SCREENHEIGHT - 285;
  DWProgress.SetImgIndex(g_77Images, 326);

  DWSplitItem.WIDTH := 156;
  DWSplitItem.Height := 133;
  DWSplitItemOK.Left := 16;
  DWSplitItemOK.Top := 92;

  DWSplitItemCancel.Left := 82;
  DWSplitItemCancel.Top := 92;
  DWSplitItemAdd.WIDTH := 16;
  DWSplitItemAdd.Height := 16;
  DWSplitItemAdd.Left := 106;
  DWSplitItemAdd.Top := 67;
  DWSplitItemDec.WIDTH := 16;
  DWSplitItemDec.Height := 16;
  DWSplitItemDec.Left := 122;
  DWSplitItemDec.Top := 67;
  DWSplitItemEdt.Left := 54;
  DWSplitItemEdt.Top := 66;

  DWBuyItemCount.WIDTH := 156;
  DWBuyItemCount.Height := 158;

  DWBuyItemCountOK.Left := 16;
  DWBuyItemCountOK.Top := 118;

  DWBuyItemCountCancel.Left := 82;
  DWBuyItemCountCancel.Top := 118;
  DWBuyItemCountAdd.WIDTH := 16;
  DWBuyItemCountAdd.Height := 16;
  DWBuyItemCountAdd.Left := 106;
  DWBuyItemCountAdd.Top := 67;
  DWBuyItemCountDec.WIDTH := 16;
  DWBuyItemCountDec.Height := 16;
  DWBuyItemCountDec.Left := 122;
  DWBuyItemCountDec.Top := 67;
  DWBuyItemCountEdt.Left := 54;
  DWBuyItemCountEdt.Top := 66;

  DWHeadHealth.Left := 0;
  DWHeadHealth.Top := 0;
  DWHeadHealth.WIDTH := 228;
  DWHeadHealth.Height := 81;
  DWGroups.Left := 0;
  DWGroups.Top := DWHeadHealth.Top + DWHeadHealth.Height + 16;
  DWGroups.WIDTH := 228;
  DWGroups.Height := 63;

  // 自由市场
  DWMarket.Left := 0;
  DWMarket.Top := 0;
  DWMarketSButton.Left := 49;
  DWMarketSButton.Top := 65;
  DWMarketMButton.Left := 118;
  DWMarketMButton.Top := 65;
  DWMarketLButton.Left := 187;
  DWMarketLButton.Top := 65;
  DWMarketCloseButton.Left := 625;
  DWMarketCloseButton.Top := 36;
  DWMarketItems.Left := 166;
  DWMarketItems.Top := 94;
  DWMarketItems.WIDTH := 454;
  DWMarketItems.Height := 288;

  DWMarketRItems.Left := 26;
  DWMarketRItems.Top := 392;
  DWMarketPStall.Left := 131;
  DWMarketPStall.Top := 392;
  DWMarketNStall.Left := 211;
  DWMarketNStall.Top := 392;
  DWMarketBuyItem.Left := 477;
  DWMarketBuyItem.Top := 392;
  DWMarketVList.Left := 555;
  DWMarketVList.Top := 392;

  DWMarketRList.Left := 26;
  DWMarketRList.Top := 392;
  DWMarketPPage.Left := 131;
  DWMarketPPage.Top := 392;
  DWMarketNPage.Left := 211;
  DWMarketNPage.Top := 392;
  DWMarketVStall.Left := 555;
  DWMarketVStall.Top := 392;

  DWMarketName.Left := 100;
  DWMarketName.Top := 392;
  DWMarketName.WIDTH := 200;
  DWMarketName.MaxLength := 30;
  DWMarketSetName.Left := 312;
  DWMarketSetName.Top := 390;
  DWMarketRMyItems.Top := 392;
  DWMarketRMyItems.Left := 348;
  DWMarketExtGold.Left := 477;
  DWMarketExtGold.Top := 392;
  DWMarketPutOn.Left := 555;
  DWMarketPutOn.Top := 392;
  DWMarketItemPutOn.Left := 60;
  DWMarketItemPutOn.Top := 243;
  DWMarketItemPutOff.Left := 140;
  DWMarketItemPutOff.Top := 243;
  DWMarketItemCountEdt.WIDTH := 132;
  DWMarketItemCountEdt.Top := 138;
  DWMarketItemCountEdt.Left := 92;
  DWMarketItemGoldEdt.WIDTH := 132;
  DWMarketItemGoldEdt.Top := 171;
  DWMarketItemGoldEdt.Left := 92;
  DWMarketItemGameGoldEdt.WIDTH := 132;
  DWMarketItemGameGoldEdt.Top := 204;
  DWMarketItemGameGoldEdt.Left := 92;
  DWMarketItemItem.WIDTH := 48;
  DWMarketItemItem.Height := 48;
  DWMarketItemItem.Left := 106;
  DWMarketItemItem.Top := 46;
  DWMarketItemClose.Left := 240;
  DWMarketItemClose.Top := 2;

  // 邮件系统
  DMailList.Left := SCREENWIDTH - DMailList.WIDTH - DMailReader.WIDTH;
  DMailList.Top := 120;
  DBCloseMail.Left := DMailList.WIDTH - DBCloseMail.WIDTH;
  DBCloseMail.Top := 0;
  DBMLTop.Left := 267;
  DBMLTop.Top := 67;
  DBMLScroll.Left := 267;
  DBMLScroll.Top := DBMLTop.Top + DBMLTop.Height;
  DBMLBottom.Left := 267;
  DBMLBottom.Top := 303 - DBMLBottom.Height;

  DBCloseReader.Left := DMailReader.WIDTH - DBCloseReader.WIDTH;
  DBCloseReader.Top := 0;
  DBCloseWriter.Left := DMailWriter.WIDTH - DBCloseWriter.WIDTH;
  DBCloseWriter.Top := 0;
  DBRMTop.Top := 96;
  DBRMTop.Left := 240;
  DBRMScroll.Top := DBRMTop.Top + DBRMTop.Height;
  DBRMScroll.Left := 240;
  DBRMBottom.Top := 223 - DBRMBottom.Height;
  DBRMBottom.Left := 240;
  DMMReader.WIDTH := 214;
  DMMReader.Height := 120;
  DMMReader.Left := 22;
  DMMReader.Top := 100;
  DBMailReply.Left := 16;
  DBMailReply.Top := 340;
  DBMailExtrAtt.Left := DBMailReply.Left + DBMailReply.WIDTH + 4;
  DBMailExtrAtt.Top := 340;
  DCMailItem.Left := 22;
  DCMailItem.Top := 272;
  DCMailItem.WIDTH := 40;
  DCMailItem.Height := 38;

  DBNewMail.Left := 16;
  DBNewMail.Top := 314;
  DBReadMail.Left := DBNewMail.Left + DBNewMail.WIDTH + 8;
  DBReadMail.Top := 314;
  DBDelMail.Left := DBReadMail.Left + DBReadMail.WIDTH + 8;
  DBDelMail.Top := 314;
  DBDelAllMail.Left := DBDelMail.Left + DBDelMail.WIDTH + 8;
  DBDelAllMail.Top := 314;
  DBWMTop.Top := 96;
  DBWMTop.Left := 240;
  DBWMScroll.Top := DBWMTop.Top + DBWMTop.Height;
  DBWMScroll.Left := 240;
  DBWMBottom.Top := 223 - DBWMBottom.Height;
  DBWMBottom.Left := 240;
  DMMailEdit.WIDTH := 218;
  DMMailEdit.Height := 122;
  DMMailEdit.Left := 20;
  DMMailEdit.Top := 98;
  DEMailTo.Left := 18;
  DEMailTo.Top := 46;
  DEMailTo.Height := 19;
  DEMailTo.WIDTH := 220;
  DEMailTo.MaxLength := ACTORNAMELEN;
  DBMailToUsers.Left := 239;
  DBMailToUsers.Top := 48;
  DEMailSubject.Left := 18;
  DEMailSubject.Top := 70;
  DEMailSubject.Height := 19;
  DEMailSubject.WIDTH := 236;
  DBMailSend.Left := 16;
  DBMailSend.Top := 340;
  DESendGold.Left := 24;
  DESendGold.Top := 248;
  DESendGold.Height := 18;
  DESendGold.WIDTH := 226;
  DBSendGoldType.Left := 232;
  DBSendGoldType.Top := 250;
  DEBuyAttPrice.Left := 18;
  DEBuyAttPrice.Top := 314;
  DEBuyAttPrice.Height := 18;
  DEBuyAttPrice.WIDTH := 236;
  DBBuyAttGoldType.Left := 236;
  DBBuyAttGoldType.Top := 316;
  DCSendMailItem.Left := 22;
  DCSendMailItem.Top := 272;
  DCSendMailItem.WIDTH := 40;
  DCSendMailItem.Height := 38;

  DWMiniMissions.WIDTH := 200;
  DWMiniMissions.Height := 154;
  DWMiniMissions.Left := SCREENWIDTH - 200;
  DWMiniMissions.Top := 200; // (SCREENHEIGHT - 154 - g_BottomHeight) div 2;

  DAdjustAbility.Left := 0;
  DAdjustAbility.Top := 0;

  DBMissionSwitch.Top := 0;
  DBMissionSwitch.Left := 200 - 15;
  DBMissionSwitch.WIDTH := 15;
  DBMissionsWindow.Top := 15;
  DBMissionsWindow.Left := 200 - 15;
  DBMissionsWindow.WIDTH := 15;
  DBMissionsTop.Top := 30;
  DBMissionsTop.Left := 200 - 15;
  DBMissionsTop.WIDTH := 15;
  DBMissionsScroll.Top := 45;
  DBMissionsScroll.Left := 200 - 15;
  DBMissionsScroll.WIDTH := 15;
  DBMissionsBottom.Top := 154 - 14;
  DBMissionsBottom.Left := 200 - 15;
  DBMissionsBottom.WIDTH := 15;
  DLabelMissions.Left := 0;
  DLabelMissions.Top := 0;
  DLabelMissions.WIDTH := 200 - 15;
  DLabelMissions.Height := DWMiniMissions.Height;

  DWMissions.Left := 0;
  DWMissions.Top := 0;
  DWMissions.WIDTH := 487;
  DWMissions.Height := 345;
  DBCloseMissions.Left := 467;
  DBCloseMissions.Top := 5;
  DBMissionDoing.Left := 18;
  DBMissionDoing.Top := 24;
  DBMissionUnDo.Left := 88;
  DBMissionUnDo.Top := 24;
  DMissionContent.Left := 232;
  DMissionContent.Top := 72;
  DMissionContent.WIDTH := 222;
  DMissionContent.Height := 240;
  DBMissionsListTop.Left := 198;
  DBMissionsListTop.Top := 50;
  DBMissionsListScroll.Left := 198;
  DBMissionsListScroll.Top := DBMissionsListTop.Top + DBMissionsListTop.Height;
  DBMissionsListBottom.Left := 198;
  DBMissionsListBottom.Top := 314;
  DMissionList.Left := 18;
  DMissionList.Top := 50;
  DMissionList.WIDTH := 180;
  DMissionList.Height := 276;

  DWDice.Left := (SCREENWIDTH - DWDice.WIDTH) div 2;
  DWDice.Top := (SCREENHEIGHT - DWDice.Height - g_BottomHeight) div 2;
  DWDiceClose.Left := 272;
  DWDiceClose.Top := 0;

  // 摊位
  DWStallWinClose.Left := 371;
  DWStallWinClose.Top := 2;
  DWStallQueryWinClose.Left := 371;
  DWStallQueryWinClose.Top := 2;
  DWStallWinSaleGrid.Left := 25;
  DWStallWinSaleGrid.Top := 53;
  DWStallWinSaleGrid.WIDTH := 154;
  DWStallWinSaleGrid.Height := 118;
  DWStallWinBuyGrid.Left := 193;
  DWStallWinBuyGrid.Top := 53;
  DWStallWinBuyGrid.WIDTH := 154;
  DWStallWinBuyGrid.Height := 118;
  DWStallWinCtrl.Left := 192;
  DWStallWinCtrl.Top := 182;

  DWStallStop.Left := 192;
  DWStallStop.Top := 182;

  DWStallWinGetGold.Left := 278;
  DWStallWinGetGold.Top := 182;
  DWStallWinScrollTop.Left := 341;
  DWStallWinScrollTop.Top := 249;
  DWStallWinScrollBar.Left := 341;
  DWStallWinScrollBar.Top := 264;
  DWStallWinScrollBottom.Left := 341;
  DWStallWinScrollBottom.Top := 342;

  DWStallQueryWinSaleGrid.Left := 25;
  DWStallQueryWinSaleGrid.Top := 53;
  DWStallQueryWinSaleGrid.WIDTH := 154;
  DWStallQueryWinSaleGrid.Height := 118;
  DWStallQueryWinBuyGrid.Left := 193;
  DWStallQueryWinBuyGrid.Top := 53;
  DWStallQueryWinBuyGrid.WIDTH := 154;
  DWStallQueryWinBuyGrid.Height := 118;
  DWStallWinLeaveMsg.Left := 68;
  DWStallWinLeaveMsg.Top := 336;
  DWStallWinLeaveMsg.WIDTH := 277;
  DWStallWinLeaveMsg.Height := 17;
  DWStallQueryWinScrollTop.Left := 341;
  DWStallQueryWinScrollTop.Top := 195;
  DWStallQueryWinScrollBar.Left := 341;
  DWStallQueryWinScrollBar.Top := 210;
  DWStallQueryWinScrollBttom.Left := 341;
  DWStallQueryWinScrollBttom.Top := 288;

  DWChatHistoryClose.Left := 398;
  DWChatHistoryClose.Top := 0;
  DBChatHistoryScrollTop.Left := 364;
  DBChatHistoryScrollTop.Top := 42;
  DBChatHistoryScrollBar.Left := 364;
  DBChatHistoryScrollBar.Top := DBChatHistoryScrollTop.Top +
    DBChatHistoryScrollTop.Height;
  DBChatHistoryScrollBottom.Left := 364;
  DBChatHistoryScrollBottom.Top := 230;
  DMChatHistory.Left := 17;
  DMChatHistory.Top := 46;
  DMChatHistory.WIDTH := 348;
  DMChatHistory.Height := 194;

  if g_DWinMan.StateWinType <> wk195 then
  begin

    DCloseState.Left := 8;
    DCloseState.Top := 39;
    DSWHelmet.Left := 112;
    DSWHelmet.Top := 88;
    DSWWeapon.Left := 40;
    DSWWeapon.Top := 52;
    DSWWeapon.WIDTH := 46;
    DSWWeapon.Height := 120;
    DSWDress.Left := 92;
    DSWDress.Top := 118;
    DSWDress.WIDTH := 64;
    DSWDress.Height := 124;
    DSWNecklace.Left := 168;
    DSWNecklace.Top := 87;
    DSWLight.Left := 168;
    DSWLight.Top := 125;
    DSWArmRingR.Left := 42;
    DSWArmRingR.Top := 176;
    DSWArmRingL.Left := 167;
    DSWArmRingL.Top := 176;
    DSWRingR.Left := 42;
    DSWRingR.Top := 215;
    DSWRingL.Left := 167;
    DSWRingL.Top := 215;
    DStateWinPre.Left := 7;
    DStateWinPre.Top := 128;
    DStateWinPre.WIDTH := 24;
    DStateWinPre.Height := 23;
    DStateWinNext.Left := 7;
    DStateWinNext.Top := 187;
    DStateWinNext.WIDTH := 24;
    DStateWinNext.Height := 23;

    DCloseUS1.Left := 8;
    DCloseUS1.Top := 39;
    DHelmetUS1.Left := 112;
    DHelmetUS1.Top := 88;
    DWeaponUS1.Left := 40;
    DWeaponUS1.Top := 52;
    DWeaponUS1.WIDTH := 46;
    DWeaponUS1.Height := 120;
    DDressUS1.Left := 92;
    DDressUS1.Top := 118;
    DDressUS1.WIDTH := 64;
    DDressUS1.Height := 124;
    DNecklaceUS1.Left := 168;
    DNecklaceUS1.Top := 87;
    DLightUS1.Left := 168;
    DLightUS1.Top := 125;
    DArmringRUS1.Left := 42;
    DArmringRUS1.Top := 176;
    DArmringLUS1.Left := 167;
    DArmringLUS1.Top := 176;
    DRingRUS1.Left := 42;
    DRingRUS1.Top := 215;
    DRingLUS1.Left := 167;
    DRingLUS1.Top := 215;
    DUserState1Pre.Left := 7;
    DUserState1Pre.Top := 128;
    DUserState1Pre.WIDTH := 24;
    DUserState1Pre.Height := 23;
    DUserState1Next.Left := 7;
    DUserState1Next.Top := 187;
    DUserState1Next.WIDTH := 24;
    DUserState1Next.Height := 23;

    if g_DWinMan.StateWinType <> wk176 then
    begin
      DSWBujuk.Left := 42;
      DSWBujuk.Top := 254;
      DSWBelt.Left := 84;
      DSWBelt.Top := 254;
      DSWBoots.Left := 126;
      DSWBoots.Top := 254;
      DSWCharm.Left := 167;
      DSWCharm.Top := 254;

      DBujukUS1.Left := 42;
      DBujukUS1.Top := 254;
      DBeltUS1.Left := 84;
      DBeltUS1.Top := 254;
      DBootsUS1.Left := 126;
      DBootsUS1.Top := 254;
      DCharmUS1.Left := 167;
      DCharmUS1.Top := 254;
    end;

  end;
  FUILoaded := True;
end;

procedure TFrmDlg.InitUIPak;
begin
  UIWindowManager.Clear;
  UIWindowManager.Assign(g_UIManager);
  UIWindowManager.SCREENWIDTH := SCREENWIDTH;
  UIWindowManager.SCREENHEIGHT := SCREENHEIGHT - DBottom.Height;
  UIWindowManager.WinForm := Self;
  UIWindowManager.DxParent := DBackground;
  UIWindowManager.OnClick := UIWinSelectClick;
  UIWindowManager.OnMoveInCommandNode := UIMoveInCommandNode;
  UIWindowManager.OnMoveInHint := UIMoveInHint;
  UIWindowManager.CreateAllUI;
  BuildItemEffect;
  BuildBufferStation;
end;

procedure TFrmDlg.Finalize;
begin
  if BottomSurface <> nil then
    FreeAndNilEx(BottomSurface);
end;

{ ------------------------------------------------------------------------ }
// 打开人物信息状态
procedure TFrmDlg.OpenMailBox;
begin
  if not DMailList.visible then
    DMailList.visible := True;
end;

procedure TFrmDlg.ReloadBagItems;
begin
  if CanRefreshBag then
  begin
    FrmMain.SendClientMessage(CM_QUERYBAGITEMS, 1, 0, 0, 0);
    DItemsRefresh.TimeTick := GetTickCount;
  end;
end;

procedure TFrmDlg.OpenMailView;
begin
  if not DEChat.Focused then
  begin
    g_ISOpenMaxMiniMap := False;
    g_ISOpenMiniMap := False;
    if DWMaxMiniMap.visible then
      DWMaxMiniMap.visible := False
    else
    begin
      g_nMouseMaxMapKeep := False;
      g_ISOpenMiniMap := False;
      g_ISOpenMaxMiniMap := True;
      ShowMap;
    end;
  end;
end;

procedure TFrmDlg.OpenRefineBox;
begin
  if not DItemsUp.visible then
    DItemsUp.visible := True
  else
    SetDFocus(DItemsUp);
end;

procedure TFrmDlg.OpenLookupStall(S: AnsiString);
const
  _S: array [Boolean] of String = ('开始摆摊', '停止摆摊');
var
  AStallUser, ASales, ABuys, AGold, AGameGold, ALogs, AGoldCommission,
    AGameGoldCommission, AStallVer: AnsiString;
  LS: TAnsiStrings;
  I: Integer;
  AStallItem: TClientStallItem;
  ABuyItem: TClientStallBuyItem;
begin
  LS := TAnsiStringList.Create;
  try
    FillChar(g_QueryStallItems, SizeOf(g_QueryStallItems), #0);
    FillChar(g_QueryStallBuyItems, SizeOf(g_QueryStallBuyItems), #0);
    g_QueryStallLogs.Clear;

    S := AnsiGetValidStr3(S, AStallUser, ['%']);
    S := AnsiGetValidStr3(S, ASales, ['%']);
    S := AnsiGetValidStr3(S, ABuys, ['%']);
    S := AnsiGetValidStr3(S, AGold, ['%']);
    S := AnsiGetValidStr3(S, AGameGold, ['%']);
    S := AnsiGetValidStr3(S, ALogs, ['%']);
    S := AnsiGetValidStr3(S, AGoldCommission, ['%']);
    S := AnsiGetValidStr3(S, AGameGoldCommission, ['%']);
    S := AnsiGetValidStr3(S, AStallVer, ['%']);
    g_SelMarketPlay := EDcode.DeCodeString(AStallUser);
    g_StallGoldCommission := StrToIntDef(AGoldCommission, 0);
    g_StallGameGoldCommission := StrToIntDef(AGameGoldCommission, 0);
    g_QueryStallVersion := StrToIntDef(AStallVer, 0);

    StrIToStrings(AnsiStrings.Trim(ASales), '/', LS);
    for I := 0 to LS.Count - 1 do
    begin
      EDcode.DecodeBuffer(LS[I], @AStallItem, SizeOf(TClientStallItem));
      g_QueryStallItems[AStallItem.Index] := AStallItem;
    end;

    StrIToStrings(AnsiStrings.Trim(ABuys), '/', LS);
    for I := 0 to LS.Count - 1 do
    begin
      EDcode.DecodeBuffer(LS[I], @ABuyItem, SizeOf(TClientStallBuyItem));
      g_QueryStallBuyItems[ABuyItem.Index].ItemName := ABuyItem.ItemName;
      g_QueryStallBuyItems[ABuyItem.Index].RegTime := ABuyItem.RegTime;
      g_QueryStallBuyItems[ABuyItem.Index].Gold := ABuyItem.Gold;
      g_QueryStallBuyItems[ABuyItem.Index].GameGold := ABuyItem.GameGold;
      g_QueryStallBuyItems[ABuyItem.Index].Count := ABuyItem.Count;
      g_QueryStallBuyItems[ABuyItem.Index].Index := ABuyItem.Index;
      g_QueryStallBuyItems[ABuyItem.Index].Item.Item :=
        GetClientItemByName(ABuyItem.ItemName);
      if g_QueryStallBuyItems[ABuyItem.Index].Item.Item.S.StdMode
        in [{$I AddinStdmode.INC}] then
      begin
        g_QueryStallBuyItems[ABuyItem.Index].Item.Item.DuraMax :=
          ABuyItem.Count;
        g_QueryStallBuyItems[ABuyItem.Index].Item.Item.Dura := ABuyItem.Count;
      end
      else
      begin
        g_QueryStallBuyItems[ABuyItem.Index].Item.Item.DuraMax :=
          g_QueryStallBuyItems[ABuyItem.Index].Item.Item.S.DuraMax;
        g_QueryStallBuyItems[ABuyItem.Index].Item.Item.Dura :=
          g_QueryStallBuyItems[ABuyItem.Index].Item.Item.DuraMax;
      end;
      g_QueryStallBuyItems[ABuyItem.Index].Item.RegTime := ABuyItem.RegTime;
      g_QueryStallBuyItems[ABuyItem.Index].Item.Gold := ABuyItem.Gold;
      g_QueryStallBuyItems[ABuyItem.Index].Item.GameGold := ABuyItem.GameGold;
      g_QueryStallBuyItems[ABuyItem.Index].Item.Index := ABuyItem.Index;
      g_QueryStallBuyItems[ABuyItem.Index].Item.Item.AddHold[0] := -1;
      g_QueryStallBuyItems[ABuyItem.Index].Item.Item.AddHold[1] := -1;
      g_QueryStallBuyItems[ABuyItem.Index].Item.Item.AddHold[2] := -1;
      g_QueryStallBuyItems[ABuyItem.Index].Item.Item.MakeIndex := -1000000 + I;
    end;

    StrIToStrings(AnsiStrings.Trim(ALogs), '/', LS);
    for I := 0 to LS.Count - 1 do
    begin
      if LS[I] <> '' then
        g_QueryStallLogs.Add(EDcode.DeCodeString(LS[I]));
    end;

    DWStallQueryWin.visible := True;
    DWStallQueryWin.Left := (SCREENWIDTH - DWStallQueryWin.WIDTH -
      DItemBag.WIDTH) div 2;
    DWStallQueryWin.Top :=
      (SCREENHEIGHT - g_BottomHeight - DWStallQueryWin.Height) div 2;
    DItemBag.Left := DWStallQueryWin.Left + DWStallQueryWin.WIDTH;
    DItemBag.Top := DWStallQueryWin.Top;
    DItemBag.visible := True;
  finally
    LS.Free;
  end;
end;

procedure TFrmDlg.OpenMyStall(S: AnsiString);
const
  _S: array [Boolean] of String = ('开始摆摊', '停止摆摊');
var
  AStallUser, ASales, ABuys, AGold, AGameGold, ALogs, AGoldCommission,
    AGameGoldCommission: AnsiString;
  LS: TAnsiStrings;
  I: Integer;
  AStallItem: TClientStallItem;
  ABuyItem: TClientStallBuyItem;
begin
  LS := TAnsiStringList.Create;
  try
    FillChar(g_StallItems, SizeOf(g_StallItems), #0);
    FillChar(g_StallBuyItems, SizeOf(g_StallBuyItems), #0);
    g_StallLogs.Clear;

    S := AnsiGetValidStr3(S, AStallUser, ['%']);
    S := AnsiGetValidStr3(S, ASales, ['%']);
    S := AnsiGetValidStr3(S, ABuys, ['%']);
    S := AnsiGetValidStr3(S, AGold, ['%']);
    S := AnsiGetValidStr3(S, AGameGold, ['%']);
    S := AnsiGetValidStr3(S, ALogs, ['%']);
    S := AnsiGetValidStr3(S, AGoldCommission, ['%']);
    S := AnsiGetValidStr3(S, AGameGoldCommission, ['%']);
    g_StallGoldCommission := StrToIntDef(AGoldCommission, 0);
    g_StallGameGoldCommission := StrToIntDef(AGameGoldCommission, 0);

    StrIToStrings(AnsiStrings.Trim(ASales), '/', LS);
    for I := 0 to LS.Count - 1 do
    begin
      EDcode.DecodeBuffer(LS[I], @AStallItem, SizeOf(TClientStallItem));
      g_StallItems[AStallItem.Index] := AStallItem;
    end;
    StrIToStrings(AnsiStrings.Trim(ABuys), '/', LS);
    for I := 0 to LS.Count - 1 do
    begin
      EDcode.DecodeBuffer(LS[I], @ABuyItem, SizeOf(TClientStallBuyItem));
      g_StallBuyItems[ABuyItem.Index].ItemName := ABuyItem.ItemName;
      g_StallBuyItems[ABuyItem.Index].RegTime := ABuyItem.RegTime;
      g_StallBuyItems[ABuyItem.Index].Gold := ABuyItem.Gold;
      g_StallBuyItems[ABuyItem.Index].GameGold := ABuyItem.GameGold;
      g_StallBuyItems[ABuyItem.Index].Count := ABuyItem.Count;
      g_StallBuyItems[ABuyItem.Index].Index := ABuyItem.Index;
      g_StallBuyItems[ABuyItem.Index].Item.Item :=
        GetClientItemByName(ABuyItem.ItemName);
      if g_StallBuyItems[ABuyItem.Index].Item.Item.S.StdMode
        in [{$I AddinStdmode.INC}] then
      begin
        g_StallBuyItems[ABuyItem.Index].Item.Item.DuraMax := ABuyItem.Count;
        g_StallBuyItems[ABuyItem.Index].Item.Item.Dura := ABuyItem.Count;
      end
      else
      begin
        g_StallBuyItems[ABuyItem.Index].Item.Item.DuraMax :=
          g_StallBuyItems[ABuyItem.Index].Item.Item.S.DuraMax;
        g_StallBuyItems[ABuyItem.Index].Item.Item.Dura :=
          g_StallBuyItems[ABuyItem.Index].Item.Item.DuraMax;
      end;
      g_StallBuyItems[ABuyItem.Index].Item.RegTime := ABuyItem.RegTime;
      g_StallBuyItems[ABuyItem.Index].Item.Gold := ABuyItem.Gold;
      g_StallBuyItems[ABuyItem.Index].Item.GameGold := ABuyItem.GameGold;
      g_StallBuyItems[ABuyItem.Index].Item.Index := ABuyItem.Index;
      g_StallBuyItems[ABuyItem.Index].Item.Item.AddHold[0] := -1;
      g_StallBuyItems[ABuyItem.Index].Item.Item.AddHold[1] := -1;
      g_StallBuyItems[ABuyItem.Index].Item.Item.AddHold[2] := -1;
      g_StallBuyItems[ABuyItem.Index].Item.Item.MakeIndex := -1000000 + I;
    end;

    StrIToStrings(AnsiStrings.Trim(ALogs), '/', LS);
    for I := 0 to LS.Count - 1 do
    begin
      if LS[I] <> '' then
        g_StallLogs.Add(EDcode.DeCodeString(LS[I]));
    end;

    g_MyStallGold := StrToIntDef(AGold, 0);
    g_MyStallGameGold := StrToIntDef(AGameGold, 0);

    DWStallWin.visible := True;
    DWStallWin.Left := (SCREENWIDTH - DWStallWin.WIDTH - DItemBag.WIDTH) div 2;
    DWStallWin.Top := (SCREENHEIGHT - g_BottomHeight - DWStallWin.Height) div 2;
    DItemBag.Left := DWStallWin.Left + DWStallWin.WIDTH;
    DItemBag.Top := DWStallWin.Top;
    DWStallWinGetGold.visible := not(g_MySelf.m_btStall in [1 .. 4]);
    DItemBag.visible := True;

    DWStallWinCtrl.Visible := g_MySelf.m_btStall = 0;
    DWStallStop.Visible := g_MySelf.m_btStall <> 0;
  finally
    LS.Free;
  end;
end;

procedure TFrmDlg.OpenMarket;
begin
  DWMarket.Left := 0;
  DWMarket.Top := 0;
  DWMarket.visible := not DWMarket.visible;
  if DWMarket.visible then
  begin
    DItemBag.Left := DWMarket.Left + DWMarket.WIDTH;
    DItemBag.Top := 0;
    ISMarketList := True;
    SetMarketTabIndex(0);
  end;
end;

procedure TFrmDlg.OpenMiniMap(ChangeSize: Boolean);
begin
  g_ISOpenMaxMiniMap := False;
  g_ISOpenMiniMap := True;
  if g_boSDMinimap then
  begin
    if ChangeSize then
      Inc(g_btMiniMapType);
    case g_btMiniMapType of
      1,2:
      begin
        ResetSDMiniMapSizeAndPosition(g_btMiniMapType);
      end
    else
      begin
        g_btMiniMapType := 0;
        ResetSDMiniMapSizeAndPosition(g_btMiniMapType);
      end;
    end;
  end
  else
  begin
    if DWMiniMap.visible then
    begin
      DWMiniMap.visible := False;
      g_boViewMiniMap := False;
    end
    else
    begin
      g_btMiniMapType := 1;
      ShowMap;
    end;
  end;
end;

procedure TFrmDlg.OpenShop;
begin
  if not DShop.visible  then
  begin
    DShop.Top := 0;
    DShop.Left := (SCREENWIDTH - DShop.WIDTH) div 2;
    DShop.visible := True;
    DShopDecorateClick(DShopDecorate, 0, 0);
    ShopIndex := -1;
    ShopSpeciallyIndex := -1;
    DShopImg1Click(DShopImg1, 0, 0);
  end else
    DShop.visible := False;
end;

procedure TFrmDlg.OpenBag;
begin
  if not DItemBag.visible then
  begin
    DItemBag.visible := True;
    DItemBag.Left := 0;
    DItemBag.Top := 0;
    ArrangeItemBag;
  end;
end;

procedure TFrmDlg.OpenMyStatus(nPage: Integer);
begin
  SetMagicPage(0);
  TTabState.SetPageControlIndex(nPage);
  DStateWin.visible := not DStateWin.visible;

end;

// 显示玩加信息对话框
procedure TFrmDlg.OpenUI(const AName: String);
var
  AWin: TuDWindow;
begin
  if UIWindowManager.TryGet(AName, AWin) and not AWin.visible then
    AWin.visible := True;
end;

procedure TFrmDlg.OpenUserState(UserState: TUserStateInfo);
var
  AEffect: TdxItemEffect;
begin
  UserState1 := UserState;
  DPOtherState.ActivePage := 0;
  UserDressInnerEffect := nil;
  UserWeponInnerEffect := nil;

  if UserState1.UseItems[U_DRESS].Name <> '' then
  begin
    if UserState1.UseItems[U_DRESS].CustomEff > 0 then
      if UIWindowManager.ItemEffects.TryGetEffect
        (UserState1.UseItems[U_DRESS].CustomEff, AEffect) then
        UIWindowManager.TryGetItemInnerEffect(AEffect.InnerEffect,
          UserDressInnerEffect);
  end;

  if UserState1.UseItems[U_WEAPON].Name <> '' then
  begin
    if UserState1.UseItems[U_WEAPON].CustomEff > 0 then
      if UIWindowManager.ItemEffects.TryGetEffect
        (UserState1.UseItems[U_WEAPON].CustomEff, AEffect) then
        UIWindowManager.TryGetItemInnerEffect(AEffect.InnerEffect,
          UserWeponInnerEffect);
  end;

  UserFightPower := RecalcTotalAbility(UserState);

  DTNameUS1.Propertites.Caption.Text := UserState.UserName;
  DTNameUS1.Propertites.Caption.Color := UserState.NAMECOLOR;
  DTGuildRankUS1.Propertites.Caption.Text := UserState.GuildRankName;

  FrmDlg.DSWJeweButtonOther.visible := SetContain(UserState.nFunctionFlag,
    Byte(ffJewelryBox));
  FrmDlg.DSWZodiacOther.visible := SetContain(UserState.nFunctionFlag,
    Byte(ffZodiac));
  DUserState1.visible := True;
end;

// 显示/关闭物品对话框
procedure TFrmDlg.OpenItemBag;
begin
  DItemBag.visible := not DItemBag.visible;
  if DItemBag.visible then
  begin
    ArrangeItemBag;
  end;
end;

// 底部状态框
procedure TFrmDlg.ViewBottomBox(visible: Boolean);
begin
  DBottom.visible := visible;
  //FShowMission := visible;
  //DBMissionSwitch.Propertites.ImageIndex := 433;
end;

procedure TFrmDlg.ViewHeadHealtBox(visible: Boolean);
begin
  DWHeadHealth.visible := visible and (g_MirStartupInfo.btMainInterface = 1);
end;

procedure TFrmDlg.ViewGroupHeadHealtBox(visible: Boolean);
begin
  DWGroups.visible := visible;
end;

// 取消物品移动
procedure TFrmDlg.CancelItemMoving;
begin
  if g_boItemMoving then
  begin // TODO
    g_boItemMoving := False;
    case g_MovingItem.Source of
      msBag:
        begin
          if g_ItemArr[g_MovingItem.FromIndex].Name = '' then
            g_ItemArr[g_MovingItem.FromIndex] := g_MovingItem.Item
          else
            AddItemBag(g_MovingItem.Item);
        end;
      msItemUp:
        g_ItemsUpItem[g_MovingItem.FromIndex] := g_MovingItem.Item;
      msDrinkItem:
        g_PDrinkItem[g_MovingItem.FromIndex] := g_MovingItem.Item;
      msUses:
        g_UseItems[g_MovingItem.FromIndex] := g_MovingItem.Item;
      msDealItem:
        AddDealItem(g_MovingItem.Item);
      msDealGold:
        ;
      msSellItem:
        ;
      msMailItem:
        ;
      msWineMateria:
        g_WineItem[g_MovingItem.FromIndex] := g_MovingItem.Item;
      msWineDrug:
        g_DrugWineItem[g_MovingItem.FromIndex] := g_MovingItem.Item;
      msChallenge:
        ;
      msCustomItem:
        ;
      msStall:
        ;
      // msJewelryBox: g_JewelryBox[g_MovingItem.FromIndex] := g_MovingItem.Item;
      // msZodiacSigns: g_ZodiacSigns[g_MovingItem.FromIndex] := g_MovingItem.Item;
    end;
    g_MovingItem.Item.Name := '';
  end;
  ArrangeItemBag;
end;

function TFrmDlg.CanClickStartPlayBtn: Double;
var
  Tick: Cardinal;
begin
  Tick := GetTickCount;
  if (Tick > g_StartGameTick) or (g_StartGameTick = 0) then
  begin
    Result := 1.0;
  end
  else
  begin
    Result := 1 - ((g_StartGameTick - Tick) / STARTGAMEWAIT);
  end;
end;

function TFrmDlg.CanRefreshBag: Boolean;
begin
  Result := not UIWindowManager.ItemLock and not DItemsUp.visible and
    not DSellDlg.visible and not DDealDlg.visible and not DMailWriter.visible;
  Result := Result and (GetTickCount - DItemsRefresh.TimeTick > 2000);
end;



// 把移动的物品放下
procedure TFrmDlg.DropMovingItem;
var
  boAccept: Boolean;
  oldName: String;
begin
  if g_boItemMoving then
  begin
    g_boItemMoving := False;
    if g_MovingItem.Item.Name <> '' then
    begin
      boAccept := True;
      oldName := g_MovingItem.Item.Name;
      if g_boDropBindFree and g_MovingItem.Item.Bind then
      begin
        g_Application.AddMessageDialog('绑定物品丢弃将会消失，确定丢弃吗？', [mbOK, mbCancel],
          procedure(AResult: Integer)begin if g_MovingItem.Item.Name <>
          '' then begin if AResult = mrOK then begin FrmMain.SendDropItem
          (g_MovingItem.Item.Name, g_MovingItem.Item.MakeIndex);
          AddDropItem(g_MovingItem.Item); g_MovingItem.Item.Name := '';
        end else begin g_MovingItem.Item.Name := oldName;
          g_boItemMoving := True; end; end; end)
      end
      else
      begin
        FrmMain.SendDropItem(g_MovingItem.Item.Name,
          g_MovingItem.Item.MakeIndex);
        AddDropItem(g_MovingItem.Item);
        g_MovingItem.Item.Name := '';
        g_dwLastDropItem := GetTickCount;
      end;
    end;
  end;
end;

procedure TFrmDlg.DSaveItemsNextPageClick(Sender: TObject; X, Y: Integer);
begin
  if DLVSaveItems.PageIndex < DLVSaveItems.PageCount - 1 then
    DLVSaveItems.PageIndex := DLVSaveItems.PageIndex + 1;
end;

procedure TFrmDlg.DSaveItemsPrevPageClick(Sender: TObject; X, Y: Integer);
begin
  if DLVSaveItems.PageIndex > 0 then
    DLVSaveItems.PageIndex := DLVSaveItems.PageIndex - 1;
end;

// 打开属性调整对话框
procedure TFrmDlg.OpenAdjustAbility;
begin
  g_nSaveBonusPoint := g_nBonusPoint;
  FillChar(g_BonusAbilChg, SizeOf(TNakedAbility), #0);
  DAdjustAbility.visible := True;
end;

procedure TFrmDlg.DBackgroundBackgroundClick(Sender: TObject);
var
  dropgold: Integer;
  valstr: string;
begin
  if g_boItemMoving then
  begin
    DBackground.WantReturn := True;
    if g_MovingItem.Source in [msGold, msBag] then
    begin
      if g_MovingItem.Item.Name = g_sGoldName { '金币' } then
      begin
        g_boItemMoving := False;
        g_MovingItem.Item.Name := '';

        g_Application.AddMessageDialog('请输入 ' + g_sGoldName + ' 数量?',
          [mbOK, mbAbort], procedure(AResult: Integer)begin g_boItemMoving :=
          False; g_MovingItem.Item.Name := '';
          if AResult = mrOK then begin GetValidStrVal(DlgEditText, valstr,
          [' ']); dropgold := Str_ToInt(valstr, 0);
          FrmMain.SendDropGold(dropgold); end; end);
      end
      else if g_MovingItem.Source in [msGold, msBag] then // 酒捞袍 啊规俊辑 滚赴巴父..
        DropMovingItem;
    end;
  end;
end;

procedure TFrmDlg.DBackgroundInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  IsRealArea := False;
end;

procedure TFrmDlg.DBackgroundMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if g_boItemMoving then
  begin
    DBackground.WantReturn := True;
  end;
end;

procedure TFrmDlg.DBActivveTitleClick(Sender: TObject; X, Y: Integer);
begin
  if (g_ActiveTitle > 0) and (GetTickCount - DBActivveTitle.TimeTick >
    1000) then
  begin
    g_Application.AddMessageDialog('确定取消当前称号?', [mbOK, mbCancel],
      procedure(AResult: Integer)begin if AResult = mrOK then begin
      DBActivveTitle.TimeTick := GetTickCount; FrmMain.SendSetActiveTitle(0);
    end; end);
  end;
end;

procedure TFrmDlg.DBActivveTitleDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D, ATexture: TAsphyreLockableTexture;
  ATitle: pTClientHumTitle;
begin
  if g_ActiveTitle > 0 then
  begin
    ATitle := g_Titles[g_ActiveTitle - 1];
    if ATitle <> nil then
    begin
      D := nil;
      if DBActivveTitle.Downed then
        D := g_77Title.Images[ATitle.Item.Looks + 2]
      else if DBActivveTitle.Moveed then
        D := g_77Title.Images[ATitle.Item.Looks + 1];
      if D = nil then
        D := g_77Title.Images[ATitle.Item.Looks];
      with DBActivveTitle do
      begin
        if D <> nil then
          dsurface.Draw(SurfaceX(Left) + (WIDTH - D.WIDTH) div 2,
            SurfaceY(Top) + (Height - D.Height) div 2, D);
        ATexture := FontManager.Default.TextOut(ATitle.Item.sName);
        if ATexture <> nil then
          dsurface.Draw(SurfaceX(Left) + WIDTH + 8, SurfaceY(Top) + 12,
            ATexture, cColor4(cColor1(GetRGB(ATitle.Item.Color))));
      end;
    end;
  end;
end;

procedure TFrmDlg.DBActivveTitleMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  g_FocusTitle := g_ActiveTitle - 1;
end;

procedure TFrmDlg.DBottomMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

{ ------------------------------------------------------------------------ }
/// /显示通用对话框
//function TFrmDlg.DMessageDlg(msgstr: string; DlgButtons: TMsgDlgButtons)
//  : TModalResult;
//const
//  XBase = 324;
//var
//  I: Integer;
//  lx, ly: Integer;
//  D: TAsphyreLockableTexture;
//begin
//  g_boDialog := True;
//  try
//    FrmMain.CloseTopmost;
//    lx := XBase;
//    ly := 126;
//    case DialogSize of
//      0: // 小对话框
//        begin
//          D := g_WMainImages.Images[381];
//          if D <> nil then
//          begin
//            DMsgDlg.SetImgIndex(g_WMainImages, 381);
//            DMsgDlg.Left := (SCREENWIDTH - D.WIDTH) div 2;
//            DMsgDlg.Top := (SCREENHEIGHT - D.Height) div 2;
//            msglx := 39;
//            msgly := 38;
//            lx := 90;
//            ly := 36;
//          end;
//        end;
//      1: // 大对话框（横）
//        begin
//          D := g_77Images.Images[243];
//          if D <> nil then
//          begin
//            DMsgDlg.SetImgIndex(g_77Images, 243);
//            DMsgDlg.Left := (SCREENWIDTH - D.WIDTH) div 2;
//            DMsgDlg.Top := (SCREENHEIGHT - D.Height) div 2;
//            msglx := 39;
//            msgly := 38;
//            lx := XBase;
//            ly := 126;
//          end;
//        end;
//      2: // 大对话框（竖）
//        begin
//          D := g_WMainImages.Images[380];
//          if D <> nil then
//          begin
//            DMsgDlg.SetImgIndex(g_WMainImages, 380);
//            DMsgDlg.Left := (SCREENWIDTH - D.WIDTH) div 2;
//            DMsgDlg.Top := (SCREENHEIGHT - D.Height) div 2;
//            msglx := 23;
//            msgly := 20;
//            lx := 90;
//            ly := 305;
//          end;
//        end;
//    end;
//    MsgText := msgstr;
//    ViewDlgEdit := False;
//    DMsgDlg.Floating := True; // 编辑框不可见
//    DMsgDlgOk.visible := False; // 允许鼠标移动
//    DMsgDlgYes.visible := False;
//    DMsgDlgCancel.visible := False;
//    DMsgDlgNo.visible := False;
//    DMsgDlg.Left := (SCREENWIDTH - DMsgDlg.WIDTH) div 2;
//    DMsgDlg.Top := (SCREENHEIGHT - DMsgDlg.Height) div 2;
//    FDlgMessage.Clear;
//    FDlgMessage.Parse(msgstr);
//
//    if mbCancel in DlgButtons then
//    begin
//      DMsgDlgCancel.Left := lx;
//      DMsgDlgCancel.Top := ly;
//      DMsgDlgCancel.visible := True;
//      lx := lx - 110;
//    end;
//    if mbNo in DlgButtons then
//    begin
//      DMsgDlgNo.Left := lx;
//      DMsgDlgNo.Top := ly;
//      DMsgDlgNo.visible := True;
//      lx := lx - 110;
//    end;
//    if mbYes in DlgButtons then
//    begin
//      DMsgDlgYes.Left := lx;
//      DMsgDlgYes.Top := ly;
//      DMsgDlgYes.visible := True;
//      lx := lx - 110;
//    end;
//    if (mbOK in DlgButtons) or (lx = XBase) then
//    begin // 只有确定
//      DMsgDlgOk.Left := lx;
//      DMsgDlgOk.Top := ly;
//      DMsgDlgOk.visible := True;
//      // lx := lx - 110;
//    end;
//    HideAllControls;
//    DMsgDlg.ShowModal;
//    if mbAbort in DlgButtons then
//    begin
//      ViewDlgEdit := True; // 显示编辑框.
//      DMsgDlg.Floating := False;
//      EdDlgEdit.Text := '';
//      EdDlgEdit.WIDTH := DMsgDlg.WIDTH - 70;
//      EdDlgEdit.Left := (SCREENWIDTH - EdDlgEdit.WIDTH) div 2;
//      EdDlgEdit.Top := (SCREENHEIGHT - EdDlgEdit.Height) div 2 - 10;
//    end;
//    Result := mrOK;
//
//    while not Application.Terminated do
//    begin
//      if not DMsgDlg.visible then
//        Break;
//      FrmMain.ProcOnIdle;
//      Application.ProcessMessages;
//      SleepEx(1, True);
//    end;
//
//    EdDlgEdit.visible := False;
//    SetImeMode(EdDlgEdit.Handle, imClose);
//    RestoreHideControls;
//    DlgEditText := EdDlgEdit.Text;
//    ViewDlgEdit := False;
//    Result := DMsgDlg.DialogResult;
//    DialogSize := 1; // 扁夯惑怕
//  finally
//    g_boDialog := False;
//  end;
//end;

function TFrmDlg.DMessageDlg(msgstr: string; DlgButtons: TMsgDlgButtons)
  : TModalResult;
const
  XBase = 324;
var
  I: Integer;
  lx, ly: Integer;
  D: TAsphyreLockableTexture;
begin
  if DMsgDlg.Images = nil then
    Exit;
  g_boDialog := True;
  try
    FrmMain.CloseTopmost;
    begin
      D := DMsgDlg.Images.Images[DMsgDlg.Propertites.ImageIndex];
      if D <> nil then
      begin
        DMsgDlg.Left := (SCREENWIDTH - D.WIDTH) div 2;
        DMsgDlg.Top := (SCREENHEIGHT - D.Height) div 2;
        lx := XBase;
        ly := 126;
      end;

    end;

    MsgText := msgstr;
    ViewDlgEdit := False;
    DMsgDlg.Floating := True; // 编辑框不可见
    DMsgDlgOk.visible := False; // 允许鼠标移动
    DMsgDlgYes.visible := False;
    DMsgDlgCancel.visible := False;
    DMsgDlgNo.visible := False;
    DMsgDlg.Left := (SCREENWIDTH - DMsgDlg.WIDTH) div 2;
    DMsgDlg.Top := (SCREENHEIGHT - DMsgDlg.Height) div 2;
    FDlgMessage.Clear;
    FDlgMessage.Parse(msgstr);

    if mbCancel in DlgButtons then
    begin
      DMsgDlgCancel.Left := lx;
      DMsgDlgCancel.Top := ly;
      DMsgDlgCancel.visible := True;
      lx := lx - 110;
    end;
    if mbNo in DlgButtons then
    begin
      DMsgDlgNo.Left := lx;
      DMsgDlgNo.Top := ly;
      DMsgDlgNo.visible := True;
      lx := lx - 110;
    end;

    if mbYes in DlgButtons then
    begin
      DMsgDlgYes.Left := lx;
      DMsgDlgYes.Top := ly;
      DMsgDlgYes.visible := True;
      lx := lx - 110;
    end;

    if (mbOK in DlgButtons) or (lx = XBase) then
    begin
      DMsgDlgOk.Left := lx;
      DMsgDlgOk.Top := ly;
      DMsgDlgOk.visible := True;
    end;
    HideAllControls;
    DMsgDlg.ShowModal;
    if mbAbort in DlgButtons then
    begin
      ViewDlgEdit := True; // 显示编辑框.
      DMsgDlg.Floating := False;
      EdtMsgDlg.Text := '';
//      EdtMsgDlg.WIDTH := DMsgDlg.WIDTH - 70;
//      EdtMsgDlg.Left := (SCREENWIDTH - EdtMsgDlg.WIDTH) div 2;
//      EdtMsgDlg.Top := (SCREENHEIGHT - EdtMsgDlg.Height) div 2 - 10;
    end else
    begin
      ViewDlgEdit := False;
      EdtMsgDlg.Visible := False;
    end;
    Result := mrOK;

    while not Application.Terminated do
    begin
      if not DMsgDlg.visible then
        Break;
      FrmMain.ProcOnIdle;
      Application.ProcessMessages;
      SleepEx(1, True);
    end;

    EdtMsgDlg.visible := False;
    SetImeMode(EdtMsgDlg.Handle, imClose);
    RestoreHideControls;
    DlgEditText := EdtMsgDlg.Text;
    ViewDlgEdit := False;
    Result := DMsgDlg.DialogResult;

  finally
    g_boDialog := False;
  end;
end;


procedure TFrmDlg.DMsgDlgOkClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DMsgDlgOk then
    DMsgDlg.DialogResult := mrOK;
  if Sender = DMsgDlgYes then
    DMsgDlg.DialogResult := mrYes;
  if Sender = DMsgDlgCancel then
    DMsgDlg.DialogResult := mrCancel;
  if Sender = DMsgDlgNo then
    DMsgDlg.DialogResult := mrNo;
  DMsgDlg.visible := False;
end;

procedure TFrmDlg.DMsgDlgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    if DMsgDlgOk.visible and
      not(DMsgDlgYes.visible { or DMsgDlgCancel.Visible 20080713 } or
      DMsgDlgNo.visible) then
    begin
      DMsgDlg.DialogResult := mrOK;
      DMsgDlg.visible := False;
    end;
    if DMsgDlgYes.visible and not(DMsgDlgOk.visible or DMsgDlgCancel.visible or
      DMsgDlgNo.visible) then
    begin
      DMsgDlg.DialogResult := mrYes;
      DMsgDlg.visible := False;
    end;
  end;
  if Key = 27 then
  begin
    if DMsgDlgCancel.visible then
    begin
      DMsgDlg.DialogResult := mrCancel;
      DMsgDlg.visible := False;
    end;
  end;
end;

procedure TFrmDlg.DMsgDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DMsgDlgDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
begin
  TDWindow(Sender).DefaultPaint(dsurface);
  with Sender as TDWindow do
    //FDlgMessage.Draw(dsurface, SurfaceX(Left + msglx), SurfaceY(Top + msgly));
    FDlgMessage.Draw(dsurface, SurfaceX(Left + DMsgDlgText.Left), SurfaceY(Top + DMsgDlgText.Top));
  if ViewDlgEdit then
  begin
    if not EdtMsgDlg.visible then
    begin
      EdtMsgDlg.visible := True;
      EdtMsgDlg.SetFocus;
    end;
  end;
end;

{ ------------------------------------------------------------------------ }

// 肺弊牢 芒

procedure TFrmDlg.DLoginNewClick(Sender: TObject; X, Y: Integer);
begin
  LoginScene.NewClick;
end;

procedure TFrmDlg.DLoginNoticeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    DNoticeOKClick(nil,0,0);
  end;
end;

procedure TFrmDlg.DLoginNoticeMsgDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
  with Sender as TDWindow do
    FDlgMessage.Draw(dsurface, SurfaceX(Left), SurfaceY(Top));
end;

procedure TFrmDlg.DLoginOkClick(Sender: TObject; X, Y: Integer);
begin
  if LoginScene.Login(DELoginID.Text, DELoginPwd.Text) then
    DELoginPwd.Text := ''
  else
    DELoginPwd.SetFocus;
end;

procedure TFrmDlg.DLVGoodsClick(Sender: TObject; X, Y: Integer);
var
  pg : PTClientGoods;
begin
  pg := DLVGoods.SelectedData;
  if pg <> nil then
  begin
      g_MouseItem := pg.Item;
    if g_MouseItem.Name <> '' then
    begin
      with Sender as TDButton do
        DScreen.ShowItemHint(SurfaceX(Left + Width),
          SurfaceY(Top + Y), g_MouseItem, fkNormal);
    end;
    g_MouseItem.Name := '';
  end;
end;

procedure TFrmDlg.DLVSaveItemsClick(Sender: TObject; X, Y: Integer);
var
  pg : PTClientGoods;
begin
  pg := DLVSaveItems.SelectedData;
  if pg <> nil then
  begin
      g_MouseItem := pg.Item;
    if g_MouseItem.Name <> '' then
    begin
      with Sender as TDButton do
        DScreen.ShowItemHint(SurfaceX(Left + Width),
          SurfaceY(Top + Y), g_MouseItem, fkNormal);
    end;
    g_MouseItem.Name := '';
  end;
end;

procedure TFrmDlg.DLoginCloseClick(Sender: TObject; X, Y: Integer);
begin
  FrmMain.Close;
end;

procedure TFrmDlg.DLockClientPasswordOkClick(Sender: TObject; X, Y: Integer);
begin
  frmMain.SendClientMessage(CM_UNLOCKCLIENT_PASSWORD,0,0,0,0,EDCode.EncodeString(DEDT_LockPassword.Text));
end;

procedure TFrmDlg.DLoginChgPwClick(Sender: TObject; X, Y: Integer);
begin
  LoginScene.ChgPwClick;
end;

procedure TFrmDlg.ShowSelectServerDlg;
begin
  case g_Servers.Count of
    1:
      begin
        DSServer1.visible := True;
        case g_DWinMan.UIType of
          skNormal:
            DSServer1.Top := 204;
          skReturn:
            DSServer1.Top := 174;
          skMir4:
            DSServer1.Top := 174;
        end;
        DSServer2.visible := False;
        DSServer3.visible := False;
        DSServer4.visible := False;
        DSServer5.visible := False;
        DSServer6.visible := False;
      end;
    2:
      begin
        DSServer1.visible := True;
        DSServer2.visible := True;
        case g_DWinMan.UIType of
          skNormal:
            begin
              DSServer1.Top := 190;
              DSServer2.Top := 235;
            end;
          skReturn:
            begin
              DSServer1.Top := 166;
              DSServer2.Top := 206;
            end;
          skMir4:
            begin
              DSServer1.Top := 166;
              DSServer2.Top := 206;
            end;
        end;
        DSServer3.visible := False;
        DSServer4.visible := False;
        DSServer5.visible := False;
        DSServer6.visible := False;
      end;
    3:
      begin
        DSServer1.visible := True;
        DSServer2.visible := True;
        DSServer3.visible := True;
        DSServer4.visible := False;
        DSServer5.visible := False;
        DSServer6.visible := False;
      end;
    4:
      begin
        DSServer1.visible := True;
        DSServer2.visible := True;
        DSServer3.visible := True;
        DSServer4.visible := True;
        DSServer5.visible := False;
        DSServer6.visible := False;
      end;
    5:
      begin
        DSServer1.visible := True;
        DSServer2.visible := True;
        DSServer3.visible := True;
        DSServer4.visible := True;
        DSServer5.visible := True;
        DSServer6.visible := False;
      end;
    6:
      begin
        DSServer1.visible := True;
        DSServer2.visible := True;
        DSServer3.visible := True;
        DSServer4.visible := True;
        DSServer5.visible := True;
        DSServer6.visible := True;
      end;
  else
    begin
      DSServer1.visible := True;
      DSServer2.visible := True;
      DSServer3.visible := True;
      DSServer4.visible := True;
      DSServer5.visible := True;
      DSServer6.visible := True;
    end;
  end;
  DSelServerDlg.visible := True;
  SetDFocus(DSelServerDlg);
end;

procedure TFrmDlg.DSServer1Click(Sender: TObject; X, Y: Integer);
var
  svname: string;
begin
  svname := '';
  if Sender = DSServer1 then
  begin
    svname := g_Servers.Strings[0];
    g_sServerMiniName := svname;
  end;
  if Sender = DSServer2 then
  begin
    svname := g_Servers.Strings[1];
    g_sServerMiniName := svname;
  end;
  if Sender = DSServer3 then
  begin
    svname := g_Servers.Strings[2];
    g_sServerMiniName := svname;
  end;
  if Sender = DSServer4 then
  begin
    svname := g_Servers.Strings[3];
    g_sServerMiniName := svname;
  end;
  if Sender = DSServer5 then
  begin
    svname := g_Servers.Strings[4];
    g_sServerMiniName := svname;
  end;
  if Sender = DSServer6 then
  begin
    svname := g_Servers.Strings[5];
    g_sServerMiniName := svname;
  end;
  if svname <> '' then
  begin
    // 20080910注释  没地方用到
    { if BO_FOR_TEST then begin
      svname := '泅公辑滚';
      g_sServerMiniName := '泅公';
      end; }
    FrmMain.SendSelectServer(svname);
    DSelServerDlg.visible := False;
    g_sServerName := svname;
  end;
end;

procedure TFrmDlg.DSServer6DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  tStr: String;
begin
  D := nil;
  with Sender as TDButton do
  begin
    DefaultPaint(dsurface);
    if g_Servers.Count > Tag then
      tStr := g_Servers.Strings[Tag];
    if tStr <> '' then
    begin
      Color := $0093F4F2;
      D := FontManager.GetFont('宋体', 12, [fsBold]).TextOut(tStr);
      if D <> nil then
      begin
        if TDButton(Sender).Downed then
          dsurface.DrawBoldText(SurfaceX(Left + (WIDTH - D.WIDTH) div 2) + 2,
            SurfaceY(Top + (Height - D.Height) div 2) + 2, D, Color, $08080808)
        else
          dsurface.DrawBoldText(SurfaceX(Left + (WIDTH - D.WIDTH) div 2),
            SurfaceY(Top + (Height - D.Height) div 2), D, Color, $08080808);
      end;
    end;
  end;
end;

procedure TFrmDlg.DSShied1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ax, bbx, bby, ay, sex, nColor, Idx: Integer;
begin
  with DSShied1 do
  begin
    if UserState1.UseItems[U_SHIED].Name <> '' then
    begin
      Idx := UserState1.UseItems[U_SHIED].Looks;
      D := GetStateItemImgXY(Idx, ax, ay);
      bbx := Propertites.OffsetX + Left;
      bby := Propertites.OffsetY + Top;
      if D <> nil then
        dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
          D.ClientRect, D, True);
      ShieldDrawBlend(UserState1.UseItems[U_SHIED].S.Shape,
        UserState1.UseItems[U_SHIED].AniCount, TimeTick, dsurface,
        SurfaceX(bbx), SurfaceY(bby));
    end;
  end;
end;

procedure TFrmDlg.DEngServer1Click(Sender: TObject; X, Y: Integer);
var
  svname: string;
begin
  svname := '91网络';
  g_sServerMiniName := svname;

  if svname <> '' then
  begin
    FrmMain.SendSelectServer(svname);
    DSelServerDlg.visible := False;
    g_sServerName := svname;
  end;
end;

procedure TFrmDlg.DSSrvCloseClick(Sender: TObject; X, Y: Integer);
begin
  // DSelServerDlg.visible := False;
  FrmMain.Close;
end;

{ ------------------------------------------------------------------------ }
// 新帐号
procedure TFrmDlg.DNewAccountOkClick(Sender: TObject; X, Y: Integer);
begin
  LoginScene.NewAccountOk;
end;

procedure TFrmDlg.DNewAccountCloseClick(Sender: TObject; X, Y: Integer);
begin
  LoginScene.NewAccountClose;
end;

procedure TFrmDlg.DNewAccountDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  I: Integer;
begin
  DNewAccount.DefaultPaint(dsurface);
end;

{ ------------------------------------------------------------------------ }
/// /Chg pw 冠胶

procedure TFrmDlg.DChgpwOkClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DChgpwOk then
    LoginScene.ChgpwOk;
  if Sender = DChgpwCancel then
    LoginScene.ChgpwCancel;
end;

procedure TFrmDlg.DscStartDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  DB: Double;
  ALeft, ATop: Integer;
begin
  with Sender as TDButton do
  begin
    if Propertites.Images <> nil then
    begin
      D := nil;
      if Downed then
      begin
        D := Propertites.Images.Images[Propertites.DownedIndex];
      end
      else if Moveed then
      begin
        D := Propertites.Images.Images[Propertites.MoveIndex];
      end
      else
      begin
        D := Propertites.Images.Images[Propertites.ImageIndex];
      end;

      if D <> nil then
      begin
        ALeft := SurfaceX(Left);
        ATop := SurfaceY(Top);
        dsurface.Draw(ALeft, ATop, D.ClientRect, D, True);

        if Sender = DscStart then
        begin
          DB := CanClickStartPlayBtn;
          if DB < 1 then
          begin
            ATop := ATop + Trunc(D.Height * DB);
            dsurface.FillRectAlpha(Rect(ALeft, ATop, ALeft + D.WIDTH,
              SurfaceY(Top) + D.Height), clBlack, 180);
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DscStartInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  if CanClickStartPlayBtn < 1 then
  begin
    IsRealArea := False;
  end;
end;

procedure TFrmDlg.DscExitClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DscStart then
  begin
    if GetTickCount - TDButton(Sender).TimeTick > 1000 then
    begin
      TDButton(Sender).TimeTick := GetTickCount;
      SelectChrScene.SelChrStartClick;
    end;
  end
  else if Sender = DscNewChr then
    SelectChrScene.SelChrNewChrClick
  else if Sender = DscEraseChr then
    SelectChrScene.SelChrEraseChrClick
  else if Sender = DscCredits then
    SelectChrScene.SelChrCreditsClick
  else if Sender = DscExit then
    SelectChrScene.SelChrExitClick;
end;

procedure TFrmDlg.DscNextPageClick(Sender: TObject; X, Y: Integer);
begin
  if DscNextPage.Enabled then
  begin
    SelectChrScene.IncPage;
    DscPriorPage.Enabled := SelectChrScene.PageIndex > 0;
    DscNextPage.Enabled := SelectChrScene.PageIndex < SelectChrScene.MaxPage;
  end;
end;

procedure TFrmDlg.DscPriorPageClick(Sender: TObject; X, Y: Integer);
begin
  if DscPriorPage.Enabled then
  begin
    SelectChrScene.DecPage;
    DscPriorPage.Enabled := SelectChrScene.PageIndex > 0;
    DscNextPage.Enabled := SelectChrScene.PageIndex < SelectChrScene.MaxPage;
  end;
end;

procedure TFrmDlg.DscSelect1Click(Sender: TObject; X, Y: Integer);
begin
  SelectChrScene.SelChrSelectClick(TDButton(Sender).Tag);
end;

procedure TFrmDlg.DccMaleDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);

  var
  D: TAsphyreLockableTexture;
begin
  with TDButton(Sender) do
  begin
    D := nil;
    if Downed then
    begin
      D := Propertites.Images.Images[Propertites.DownedIndex]
    end else if SelectChrScene.Chars[SelectChrScene.NewIndex].UserChr.Sex = Tag then
    begin
      D := Propertites.Images.Images[Propertites.MoveIndex]
    end else
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
    end;

    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  end;
end;

procedure TFrmDlg.DccWarriorClick(Sender: TObject; X, Y: Integer);
begin
  SelectChrScene.SelChrNewJob(TDButton(Sender).Tag);
end;

procedure TFrmDlg.DccWarriorDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with TDButton(Sender) do
  begin
    D := nil;
    if Downed then
    begin
      D := Propertites.Images.Images[Propertites.DownedIndex]
    end else if SelectChrScene.Chars[SelectChrScene.NewIndex].UserChr.job = Tag then
    begin
      D := Propertites.Images.Images[Propertites.MoveIndex]
    end else
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
    end;

    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  end;
end;

procedure TFrmDlg.DccCloseClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DccClose then
    SelectChrScene.SelChrNewClose;
  if Sender = DccMale then
    SelectChrScene.SelChrNewm_btSex(0);
  if Sender = DccFemale then
  begin
    if SelectChrScene.Chars[SelectChrScene.NewIndex].UserChr.job <>
      _JOB_SHAMAN then
      SelectChrScene.SelChrNewm_btSex(1)
    else
      SelectChrScene.SelChrNewm_btSex(0);
  end;
  if Sender = DccLeftHair then
    SelectChrScene.SelChrNewPrevHair;
  if Sender = DccRightHair then
    SelectChrScene.SelChrNewNextHair;
  if Sender = DccOk then
    SelectChrScene.SelChrNewOk;
end;

// 人物信息栏绘画 清清2007.10.20...
procedure TFrmDlg.DStateWinDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);

  function _X(V: Integer; b: Boolean): Integer;
  begin
    if b then
      Result := V
    else
      Result := V + 2;
  end;

  function _C(b: Boolean): TColor;
  begin
    if b then
      Result := $A8D6E8
    else
      Result := $738BA1;
  end;

var
  I, L, m, pgidx, magline, bbx, bby, mmx, Idx, ax, ay, trainlv, ARow: Integer;
  pm: pTClientMagic;
  D: TAsphyreLockableTexture;
  hcolor, old, KeyImg: Integer;
  iname, d1, d2, d3: string;
  rc: TRect;
  ATexture: TuTexture;
  // AEffect: TdxItemEffect;
  AInnerEffect: TItemInnerEffect;
  AHumTitle: pTClientHumTitle;
  AColor: TColor;
  nMagicCount: Integer;
begin
  FAQColor := $0093F4F2;
  with DStateWin do
  begin
    if Propertites.Images <> nil then
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D, True);
    end;

    case 0 of
      0:
        begin
          (*
            case StatePage of

            4: // 魔法
            begin
            bbx := Left + 34;
            bby := Top + 126;
            D := g_77Images.Images[262];
            if D <> nil then
            dsurface.Draw(SurfaceX(bbx), SurfaceY(bby),
            D.ClientRect, D, True);
            bbx := Left + 46;
            bby := Top + 140;
            magtop := MagicPage * 6;
            magline := _MIN(MagicPage * 6 + 6, g_MagicList.Count);
            for I := magtop to magline - 1 do
            begin
            pm := pTClientMagic(g_MagicList[I]);
            m := I - magtop;
            keyimg := 0;
            case Byte(pm.Key) of
            Byte('1'):
            keyimg := 156;
            Byte('2'):
            keyimg := 157;
            Byte('3'):
            keyimg := 158;
            Byte('4'):
            keyimg := 159;
            Byte('5'):
            keyimg := 160;
            Byte('6'):
            keyimg := 161;
            Byte('7'):
            keyimg := 162;
            Byte('8'):
            keyimg := 163;
            Byte('E'):
            keyimg := 148;
            Byte('F'):
            keyimg := 149;
            Byte('G'):
            keyimg := 150;
            Byte('H'):
            keyimg := 151;
            Byte('I'):
            keyimg := 152;
            Byte('J'):
            keyimg := 153;
            Byte('K'):
            keyimg := 154;
            Byte('L'):
            keyimg := 155;
            end;
            if keyimg > 0 then
            begin
            D := g_WMain3Images.Images[keyimg];
            if D <> nil then
            dsurface.Draw(bbx + 178, bby + m * 46,
            D.ClientRect, D, True);
            end;
            D := g_WMainImages.Images[112]; // lv
            if D <> nil then
            begin
            if pm.wMagicId = 68 then // 酒气护体
            dsurface.Draw(bbx + 110, bby + 7 + m * 46 - 7,
            D.ClientRect, D, True)
            else
            dsurface.Draw(bbx + 48, bby + 15 + m * 46,
            D.ClientRect, D, True);
            end;
            D := g_WMainImages.Images[111]; // exp
            if D <> nil then
            begin
            if pm.wMagicId <> 68 then
            dsurface.Draw(bbx + 48 + 26, bby + 15 + m * 46,
            D.ClientRect, D, True);
            end;
            if (pm.wMagicId = 68) and (pm.Level < 100) then
            begin
            D := g_WMain2Images.Images[577];
            if D <> nil then
            dsurface.Draw(bbx + 48, bby + 19 + m * 46,
            D.ClientRect, D, True);

            D := g_WMain2Images.Images[578];
            if D <> nil then
            begin
            rc := D.ClientRect;
            if g_dwExp68 > 0 then
            begin // 酒气护体 20080622
            rc.Right :=
            Round((rc.Right - rc.Left) / g_dwMaxExp68 *
            g_dwExp68);
            dsurface.Draw(bbx + 48, bby + 19 + m * 46,
            rc, D, True);
            end;
            end;
            end;
            end;

            for I := magtop to magline - 1 do
            begin
            pm := pTClientMagic(g_MagicList[I]);
            m := I - magtop;
            if pm.wMagicId <> 68 then
            if not(pm.Level in [0 .. 4]) then
            pm.Level := 0;
            dsurface.BoldText(pm.sMagicName, clSilver,
            FontBorderColor, bbx + 48, bby + m * 46);
            if pm.wMagicId = 68 then
            begin
            trainlv := pm.Level;
            dsurface.BoldText(IntToStr(pm.Level), clSilver,
            FontBorderColor, bbx + 124, bby + 7 + m * 46 - 7);
            end
            else
            begin
            if pm.Level in [0 .. 4] then
            trainlv := pm.Level
            else
            trainlv := 0;
            dsurface.BoldText(IntToStr(pm.Level), clSilver,
            FontBorderColor, bbx + 48 + 16, bby + 15 + m * 46);
            end;
            if pm.Def.MaxTrain[trainlv] > 0 then
            begin
            if pm.wMagicId <> 68 then
            begin
            if trainlv < 3 then
            dsurface.BoldText(IntToStr(pm.CurTrain) + '/' +
            IntToStr(pm.Def.MaxTrain[trainlv]), clSilver,
            FontBorderColor, bbx + 48 + 46, bby + 15 + m * 46)
            else
            dsurface.BoldText('-', clSilver, FontBorderColor,
            bbx + 48 + 46, bby + 15 + m * 46);
            end;
            end;
            end;
            end;
            5:
            begin
            pgidx := 256;
            if g_MySelf.m_btSex = 1 then
            pgidx := 257;
            bbx := Left + 34;
            bby := Top + 126;
            D := g_77Images.Images[pgidx];
            if D <> nil then
            dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), D, True);
            bbx := bbx + 52;
            bby := bby + 78;
            // 自己人物发型
            D := GetHumInnerHairImg(g_MySelf.m_btJob, g_MySelf.m_btSex,
            g_MySelf.m_btHair, ax, ay);
            if D <> nil then
            dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
            D.ClientRect, D, True);
            if g_UseItems[U_FASHION].Name <> '' then
            begin
            Idx := g_UseItems[U_FASHION].Looks;
            if Idx >= 0 then
            begin
            D := GetStateItemImgXY(Idx, ax, ay);
            if D <> nil then
            dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
            D.ClientRect, D, True);
            DressStateDrawBlend(g_UseItems[U_FASHION].S.Shape,
            g_UseItems[U_FASHION].AniCount, TimeTick, dsurface,
            SurfaceX(bbx), SurfaceY(bby));
            end;
            end;
            end;
            end; *)
          // // 绘制
          // bbx := SurfaceX(Left) + 10;
          // bby := SurfaceY(Top) + 132;
          // dsurface.BoldText('装', _C(StatePage = 0), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 0), bby);
          // dsurface.BoldText('备', _C(StatePage = 0), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 0), bby + 14);
          // Inc(bby, 40);
          // dsurface.BoldText('状', _C(StatePage = 1), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 1), bby);
          // dsurface.BoldText('态', _C(StatePage = 1), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 1), bby + 14);
          // Inc(bby, 40);
          // dsurface.BoldText('属', _C(StatePage = 2), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 2), bby);
          // dsurface.BoldText('性', _C(StatePage = 2), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 2), bby + 14);
          // Inc(bby, 40);
          // dsurface.BoldText('称', _C(StatePage = 3), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 3), bby);
          // dsurface.BoldText('号', _C(StatePage = 3), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 3), bby + 14);
          // Inc(bby, 40);
          // dsurface.BoldText('技', _C(StatePage = 4), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 4), bby);
          // dsurface.BoldText('能', _C(StatePage = 4), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 4), bby + 14);
          // Inc(bby, 40);
          // dsurface.BoldText('时', _C(StatePage = 5), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 5), bby);
          // dsurface.BoldText('装', _C(StatePage = 5), FontBorderColor, [fsBold],
          // _X(bbx, StatePage = 5), bby + 14);
        end;
    end;

    DTMySelfName.Propertites.Caption.Text := g_MySelf.m_sUserName;
    DTMySelfName.Propertites.Caption.Color := g_MySelf.m_nNameColor;

    DTGuildRankName.Propertites.Caption.Text := g_sGuildName + ' ' +
      g_sGuildRankName;
    DTGuildRankName.Propertites.Caption.Color := clSilver;
  end;
end;

// 点击首饰盒按钮
procedure TFrmDlg.DSWHelmetDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
begin
 //
end;

procedure TFrmDlg.DSWJewelryBoxClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DSWZodiacSigns then
  begin
    frmNewItem.DZodiacSigns.visible := not frmNewItem.DZodiacSigns.visible;
    if frmNewItem.DZodiacSigns.visible then
    begin
      frmNewItem.DZodiacSigns.Left := FrmDlg.DStateWin.Left -
        frmNewItem.DZodiacSigns.WIDTH - 20;
      frmNewItem.DJewelryBox.visible := False;
    end;
  end
  else if Sender = DSWJewelryBox then
  begin
    frmNewItem.DJewelryBox.visible := not frmNewItem.DJewelryBox.visible;
    if frmNewItem.DJewelryBox.visible then
    begin
      frmNewItem.DJewelryBox.Left := FrmDlg.DStateWin.Left -
        frmNewItem.DJewelryBox.WIDTH - 20;
      frmNewItem.DZodiacSigns.visible := False;
    end;
  end;
end;

procedure TFrmDlg.DSWLightDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  sel: Integer;
begin
  sel := TDButton(Sender).Tag;
  if (sel in [U_JEWELRYITEM1 .. U_JEWELRYITEM6]) or
    (sel in [U_ZODIAC1 .. U_ZODIAC12]) or
    (Sel in [0..U_MAXUSEITEMIDX]) then
  begin
    with TDControl(Sender) do
    begin
      if g_UseItems[Tag].Name <> '' then
        DrawItem(g_UseItems[Tag], dsurface, SurfaceX(Left), SurfaceY(Top),
          WIDTH, Height, TimeTick,dipStateItem);
    end;
  end;
end;

procedure TFrmDlg.DCloseStateClick(Sender: TObject; X, Y: Integer);
begin
  DStateWin.visible := False;
end;

procedure TFrmDlg.HeroInternalForcePageChanged;
begin
end;

procedure TFrmDlg.DOptionClick(Sender: TObject; X, Y: Integer);
begin
  DScreen.ClearHint;
  g_Config.Assistant.Sound := not g_Config.Assistant.Sound;
  g_Config.Assistant.BGSound := g_Config.Assistant.Sound;
  if g_Config.Assistant.Sound then
  begin
    FrmMain.AddChatBoardString('[音效 开]', clWhite, clBlack);
  end
  else
  begin
    g_SoundManager.Stop;
    FrmMain.AddChatBoardString('[音效 关]', clWhite, clBlack);
  end;
end;

// 点击武器、衣服等装备
procedure TFrmDlg.DSWWeaponClick(Sender: TObject; X, Y: Integer);
var
  where, n, sel: Integer;
  flag: Boolean;
  msg: TDefaultMessage;
  ItemName: String;
label
  Ok;
begin
  if g_MySelf = nil then
    Exit;
  if g_boLockMoveItem then
    Exit;

  sel := TDButton(Sender).Tag;
  if not g_boDblItem then
  begin
    if (sel in [U_JEWELRYITEM1 .. U_JEWELRYITEM6]) or
      (sel in [U_ZODIAC1 .. U_ZODIAC12]) then
      goto Ok;
  Ok:
    if g_boItemMoving and (g_MovingItem.Item.S.StdMode = 33) then
    begin
      if GetTickCount - g_dwLastClkFun > 500 then
      begin

        if Sender = DSWHelmet then
        begin
          if g_UseItems[U_ZHULI].Name <> '' then
            sel := U_ZHULI
          else
            sel := U_HELMET;
        end;
        if g_UseItems[sel].Name <> '' then
          FrmMain.SendItemClickUseItemFunc(sel, g_MovingItem.Item.MakeIndex,
            g_UseItems[sel].MakeIndex);
        g_dwLastClkFun := GetTickCount;
      end;
      Exit;
    end;
  end;

  if g_boItemMoving or g_boDblItem { 右键点物品 } then
  begin
    flag := False;
    if (g_MovingItem.Item.Name = '') then
    begin
      Exit;
    end;

    if (g_WaitingUseItem.Item.Name <> '') then
    begin
      if GetTickCount - g_WaitingUseItemTime > 5000 then
        g_WaitingUseItem.Item.Name := ''
      else
        Exit;
    end;

    if not(g_MovingItem.Source in [msBag, msUses]) then
      Exit;

    where := GetTakeOnPosition(g_MovingItem.Item);
    if g_MovingItem.Source = msBag then
    begin
      // 存放罐物品的扩展   20080315
      if ((g_UseItems[U_BUJUK].S.StdMode = 2) and
        (g_UseItems[U_BUJUK].AniCount = 21) and
        (Byte(g_UseItems[U_BUJUK].S.Source) = g_MovingItem.Item.S.Shape) and
        (g_UseItems[U_BUJUK].S.Shape = g_MovingItem.Item.S.StdMode)) and
        (not(g_MovingItem.Item.S.StdMode in [5, 6, 10, 11])) then
      begin
        if Sender = DSWBujuk then
        begin
          g_WaitingUseItem := g_MovingItem;
          g_WaitingUseItemTime := GetTickCount;
          g_MovingItem.Item.Name := '';
          g_boItemMoving := False;
          msg := MakeDefaultMsg(CM_REPAIRDRAGON,
            g_WaitingUseItem.Item.MakeIndex, 4, 0, 0, FrmMain.Certification);
          // 20071231
          FrmMain.SendSocket(msg,
            EDcode.Encodestring(g_WaitingUseItem.Item.Name)); // 20071231
          // Exit;
        end;
      end;
      // 火云石修复
      if (g_UseItems[U_BUJUK].S.StdMode = 25) and
        (g_UseItems[U_BUJUK].S.Shape = 10) and
        (g_MovingItem.Item.S.StdMode = 43) and
        (g_MovingItem.Item.S.Shape = 1) then
      begin
        if Sender = DSWBujuk then
        begin
          g_WaitingUseItem := g_MovingItem;
          g_WaitingUseItemTime := GetTickCount;
          g_MovingItem.Item.Name := '';
          g_boItemMoving := False;
          msg := MakeDefaultMsg(CM_REPAIRFINEITEM,
            g_WaitingUseItem.Item.MakeIndex, 0, 0, 0, FrmMain.Certification);
          // 20080507
          FrmMain.SendSocket(msg,
            EDcode.Encodestring(g_WaitingUseItem.Item.Name)); // 20080507
        end;
      end;
      case where of
        // 衣服
        U_DRESS:
          begin
            if Sender = DSWDress then
            begin
              case g_MySelf.m_btSex of
                0:
                  flag := g_MovingItem.Item.S.StdMode = 10;
                1:
                  flag := g_MovingItem.Item.S.StdMode = 11;
              end;
            end;
          end;
        // 武器
        U_WEAPON:
          begin
            if Sender = DSWWeapon then
            begin
              flag := True;
            end;
          end;
        // 项链
        U_NECKLACE:
          begin
            if Sender = DSWNecklace then
              flag := True;
          end;
        // 蜡烛、火把、圣牌、勋章之类的
        U_RIGHTHAND:
          begin
            if Sender = DSWLight then
              flag := True;
          end;
        U_HELMET:
          begin
            if Sender = DSWHelmet then
            begin
              if g_MovingItem.Item.S.StdMode = 16 then
                where := U_ZHULI;
              flag := True;
            end;
          end;
        U_ZHULI:
          begin
            // 斗笠
            if (Sender = DSWZhuli) or (Sender = DSWHelmet) then
              flag := True;
          end;
        // 戒指（左右都可以）
        U_RINGR, U_RINGL, U_JEWELRYITEM1 .. U_JEWELRYITEM6:
          begin
            if Sender = DSWRingL then
            begin
              where := U_RINGL;
              flag := True;
            end
            else if Sender = DSWRingR then
            begin
              where := U_RINGR;
              flag := True;
            end
            else
            begin
              where := TDButton(Sender).Tag;
              flag := True;
            end;
          end;
        // 手镯、手套(左右都可以)
        U_ARMRINGR:
          begin
            if Sender = DSWArmRingL then
            begin
              where := U_ARMRINGL;
              flag := True;
            end;
            if Sender = DSWArmRingR then
            begin
              where := U_ARMRINGR;
              flag := True;
            end;
          end;
        // 护身符、药粉之类的
        U_ARMRINGL:
          begin
            if Sender = DSWArmRingL then
            begin
              where := U_ARMRINGL;
              flag := True;
            end;
          end;
        // 护身符、药粉之类的
        U_BUJUK:
          begin
            if Sender = DSWBujuk then
            begin
              case g_MovingItem.Item.S.StdMode of
                2:
                  begin // 祝福罐，魔令包
                    if (g_MovingItem.Item.S.StdMode = 2) and
                      (g_MovingItem.Item.AniCount = 21) then
                    begin
                      where := U_BUJUK;
                      flag := True;
                    end;
                  end;
                25:
                  begin // 符
                    where := U_BUJUK;
                    flag := True;
                  end;
              end;
            end;
            if Sender = DSWArmRingL then
            begin
              where := U_ARMRINGL;
              flag := True;
            end;
          end;
        // 腰带
        U_BELT:
          begin
            if Sender = DSWBelt then
            begin
              where := U_BELT;
              flag := True;
            end;
          end;
        // 鞋子
        U_BOOTS:
          begin
            if Sender = DSWBoots then
            begin
              where := U_BOOTS;
              flag := True;
            end;
          end;
        // 宝石
        U_CHARM:
          begin
            if Sender = DSWCharm then
            begin
              where := U_CHARM;
              flag := True;
            end;
          end;
        U_MOUNT:
          begin
            if Sender = DSMount then
            begin
              where := U_MOUNT;
              flag := True;
            end;
          end;
        U_SHIED:
          begin
            if Sender = DSShied then
            begin
              where := U_SHIED;
              flag := True;
            end;
          end;
        U_FASHION:
          begin
            if Sender = DWFashionDress then
            begin
              case g_MySelf.m_btSex of
                0:
                  flag := g_MovingItem.Item.S.StdMode = 17;
                1:
                  flag := g_MovingItem.Item.S.StdMode = 18;
              end;
            end;
          end;
        U_ZODIAC1 .. U_ZODIAC12:
          begin
            where := TDButton(Sender).Tag;
            flag := True;
          end;
      end;
    end
    else
    begin
      if g_MovingItem.FromIndex in [U_DRESS .. U_MAXUSEITEMIDX] then
      begin
        if not g_boDblItem then
          g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
        g_UseItems[g_MovingItem.FromIndex] := g_MovingItem.Item;
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
        g_boDblItem := False;
      end;
    end;
    if flag then
    begin
      if not g_boDblItem then
        g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
      if ((not g_MovingItem.Item.State.AutoBindAfterTakeOn) or g_MovingItem.Item.Bind) or (g_MovingItem.Item.State.AutoBindAfterTakeOn and
        not g_MovingItem.Item.Bind and
        (DMessageDlg(g_MovingItem.Item.DisplayName + '穿戴后将会被绑定，确定穿戴吗？',
        [mbOK, mbCancel]) = mrOK)) then
      begin
        g_WaitingUseItem := g_MovingItem;
        g_WaitingUseItemTime := GetTickCount;
        g_WaitingUseItem.FromIndex := where;
        FrmMain.SendTakeOnItem(where, g_MovingItem.Item.MakeIndex,
          g_MovingItem.Item.Name);
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
        g_boDblItem := False; { 右键穿戴装备 }
      end;
    end;
  end
  else
  begin
    if (g_MovingItem.Item.Name <> '') or (g_WaitingUseItem.Item.Name <> '') then
    begin
      Exit;
    end;
    sel := -1;
    if Sender = DSWDress then
      sel := U_DRESS;
    if Sender = DSWWeapon then
      sel := U_WEAPON;

    if Sender = DSWHelmet then
    begin
      if g_UseItems[U_ZHULI].Name <> '' then
        sel := U_ZHULI
      else
        sel := U_HELMET;
    end;

    if Sender = DSWZhuli then
      sel := U_ZHULI;
    if Sender = DSWNecklace then
      sel := U_NECKLACE;
    if Sender = DSWLight then
      sel := U_RIGHTHAND;
    if Sender = DSWRingL then
      sel := U_RINGL;
    if Sender = DSWRingR then
      sel := U_RINGR;
    if Sender = DSWArmRingL then
      sel := U_ARMRINGL;
    if Sender = DSWArmRingR then
      sel := U_ARMRINGR;

    if Sender = DSWBujuk then
      sel := U_BUJUK;
    if Sender = DSWBelt then
      sel := U_BELT; //
    if Sender = DSWBoots then
      sel := U_BOOTS;
    if Sender = DSWCharm then
      sel := U_CHARM;
    if Sender = DWFashionDress then
      sel := U_FASHION;
    if Sender = DSMount then
      sel := U_MOUNT;
    if Sender = DSShied then
      sel := U_SHIED;

    if sel = -1 then
    begin
      sel := TDButton(Sender).Tag;
    end;

    if (sel >= 0) and (g_UseItems[sel].Name <> '') then
    begin
      if GetKeyState(VK_SHIFT) < 0 then
      begin
        g_SoundManager.ItemClickSound(g_UseItems[sel].S);
        ItemName := '[' + g_UseItems[sel].DisplayName + ']';
        SetDFocus(DEChat);
        PlayScene.AddChatObjText(ItemName, EncodeClientItem(g_UseItems[sel]));
      end
      else if GetKeyState(VK_MENU) < 0 then
      begin
        FrmMain.SendAltLButtonUseItem(sel, g_UseItems[sel].MakeIndex);
      end
      else
      begin
        g_SoundManager.ItemClickSound(g_UseItems[sel].S);
        g_MovingItem.FromIndex := sel;
        g_MovingItem.Source := msUses;
        g_MovingItem.Item := g_UseItems[sel];
        g_UseItems[sel].Name := '';
        g_boItemMoving := True;
      end;
    end;
  end;
end;

procedure TFrmDlg.DSWWeaponMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sel: Integer;
  tmpItem: TClientItem;
label
  Ok;
begin
  sel := TDButton(Sender).Tag;
  if (sel in [U_JEWELRYITEM1 .. U_JEWELRYITEM6]) or
    (sel in [U_ZODIAC1 .. U_ZODIAC12]) then
  begin
    goto Ok;
  end;
Ok:

  if sel in [U_DRESS .. U_MAXUSEITEMIDX] then
  begin
    tmpItem := g_UseItems[sel];
    if tmpItem.Name <> '' then
    begin
      if (tmpItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := tmpItem;
        DScreen.ShowItemHint(g_Application._CurPos, tmpItem, fkUse);
      end;
    end
    else
      DScreen.ClearHint;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DStateWinMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
  g_FocusTitle := -1;
end;

procedure TFrmDlg.DStateWinNextClick(Sender: TObject; X, Y: Integer);
var
  nPage: Integer;
begin
  nPage := DPStateWin.ActivePage;
  if Sender = DStateWinPre then
  begin
    if nPage <= 0 then
      Exit;
    nPage := nPage - 1;
    if nPage = 3 then
      nPage := 2;
  end
  else if Sender = DStateWinNext then
  begin
    if nPage >= 4 then
      Exit;
    nPage := nPage + 1;
    if nPage = 3 then
      nPage := 4
  end;

  if nPage = 4 then
    SetMagicPage(0);
  TTabState.SetPageControlIndex(nPage);
end;

procedure TFrmDlg.DStMag1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  Idx: Integer;
  D: TAsphyreLockableTexture;
  pm: pTClientMagic;
begin
  // with Sender as TDButton do
  // begin
  // Idx := _Max(Tag + MagicPage * MaigicCountPage, 0);
  // if Idx < g_MagicList.Count then
  // begin
  // pm := pTClientMagic(g_MagicList[Idx]);
  // D := GetMagicIcon(pm.Def, pm.Level, pm.Strengthen, Downed);
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // end;
end;

procedure TFrmDlg.DMagicItemIconDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  pm: pTClientMagic;
begin
  With Sender as TDButton do
  begin
    if DParent is TDSkillItem then
    begin
      pm := TDSkillItem(DParent).FMagic;
      if pm <> nil then
      begin
        D := GetMagicIcon(pm^, pm.Level, pm.Strengthen, Downed);
        if D <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      end;
    end;
  end;
end;

procedure TFrmDlg.DMagicItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Idx: Integer;
  pm: pTClientMagic;
  S: String;
begin
  with Sender as TDButton do
  begin
    if DParent is TDSkillItem then
    begin
      pm := TDSkillItem(DParent).FMagic;
      if pm <> nil then
      begin
        if not Downed and not DKeySelDlg.visible then
        begin
          if pm.boCustomMagic then
             S := g_SkillData.GetSkillLevelDesc(pm.wMagicId,pm.btTrainLv)
          else
              S := g_MagicMgr.Desc(pm.wMagicId);

          if S = '' then
            S := pm.sMagicName + '\{S=(点击设置快捷键);C=251}';
          DScreen.ShowHint(SurfaceX(Left) - 8, SurfaceY(Top), S, 1);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DStMag1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Idx: Integer;
  pm: pTClientMagic;
  S: String;
begin
  // with Sender as TDButton do
  // begin
  // if not Downed and not DKeySelDlg.visible then
  // begin
  // Idx := _Max(Tag + MagicPage * MaigicCountPage, 0);
  // if Idx < g_MagicList.Count then
  // begin
  // pm := pTClientMagic(g_MagicList[Idx]);
  // if pm <> nil then
  // begin
  // S := g_MagicMgr.Desc(pm.wMagicId);
  // if S = '' then
  // S := pm.sMagicName + '\{S=(点击设置快捷键);C=251}';
  // DScreen.ShowHint(SurfaceX(Left) - 8, SurfaceY(Top), S, 1);
  // end;
  // end;
  // end;
  // end;
end;

procedure TFrmDlg.DStorageWinCloseClick(Sender: TObject; X, Y: Integer);
begin
  DStorageWin.Visible := False;
end;

procedure TFrmDlg.DStPageDownDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with Sender as TDButton do
  begin
    if Propertites.Images <> nil then
    begin
      if not Downed then
        D := Propertites.Images.Images[Propertites.ImageIndex]
      else
        D := Propertites.Images.Images[Propertites.ImageIndex + 1];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D, True);
    end;
  end;
end;

procedure TFrmDlg.DStPageUpClick(Sender: TObject; X, Y: Integer);
var
  nMagicCount: Integer;
  nMagicPage: Integer;
begin

  nMagicCount := MaigicCountPage();

  nMagicPage := g_MagicList.Count div nMagicCount;

  if (g_MagicList.Count mod nMagicCount) <> 0 then
    Inc(nMagicPage);

  if Sender = DStPageUp then
  begin
    if MagicPage > 0 then
      Dec(MagicPage);
  end
  else
  begin
    if MagicPage < nMagicPage - 1 then
      Inc(MagicPage);
  end;
  SetMagicPage(MagicPage);

end;

procedure TFrmDlg.DStPageUpDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
end;

{ ------------------------------------------------------------------------ }
// 底部状态
{ ------------------------------------------------------------------------ }
procedure TFrmDlg.DBottomDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  rc: TRect;
  btop, sx, sy, I: Integer;
  r: Real;
  ATexture: TAsphyreLockableTexture;
begin
  if g_NewUI then
  begin
    D := g_77Images.Images[380];
    if D <> nil then
      dsurface.Draw(SCREENWIDTH - D.WIDTH, DBottom.Top, D);

    if (g_MySelf.m_Abil.MaxExp > 0) and (g_MySelf.m_Abil.MaxWeight > 0) then
    begin
      D := g_77Images.Images[385];
      if D <> nil then
      begin
        // 经验条
        rc := D.ClientRect;
        if g_MySelf.m_Abil.Exp > 0 then
          r := g_MySelf.m_Abil.MaxExp / g_MySelf.m_Abil.Exp
        else
          r := 0;
        if r > 0 then
          rc.Right := Round(rc.Right / r)
        else
          rc.Right := 0;
        dsurface.Draw(SCREENWIDTH - D.WIDTH, SCREENHEIGHT - D.Height,
          rc, D, True);
      end;
    end;
  end
  else
  begin
    dsurface.Draw(DBottom.Left, DBottom.Top, BottomSurface, True);

    D := nil;

    if g_MySelf <> nil then
    begin
      // 旧的血球绘制 现在改为 裁剪动画框 随云
      // 显示HP及MP 图形
      // if (g_MySelf.m_Abil.MaxHP > 0) and (g_MySelf.m_Abil.MaxMP > 0) then
      // begin
      // if g_DrawCount mod 4 = 0 then
      // Inc(FBloodTick);
      // if FBloodTick > 6 then
      // FBloodTick := 0;
      //
      // D := g_77Images.Images[230];
      // if D <> nil then
      // begin
      // rc := D.ClientRect;
      // dsurface.Draw(40, DBottom.Top + 91, rc, D, False);
      // end;
      //
      // if (g_MySelf.m_btJob = 0) and
      // (g_MySelf.m_Abil.Level < g_nShowMagBubbleLevel) then
      // begin // 武士
      // D := g_77Images.Images[231];
      // if D <> nil then
      // begin
      // rc := D.ClientRect;
      // rc.Top := Round(rc.Bottom / g_MySelf.m_Abil.MaxHP *
      // (g_MySelf.m_Abil.MaxHP - g_MySelf.m_Abil.HP));
      // dsurface.Draw(40, DBottom.Top + 91 + rc.Top, rc, D, False);
      // end;
      // D := g_77Images.Images[311 + FBloodTick];
      // if D <> nil then
      // dsurface.Draw(36, DBottom.Top + 90, D, beSrcColor);
      // end
      // else
      // begin
      //
      // D := g_77Images.Images[232];
      // if D <> nil then
      // begin
      // // HP 图形
      // rc := D.ClientRect;
      // rc.Right := 42;
      // rc.Top := Round(rc.Bottom / g_MySelf.m_Abil.MaxHP *
      // (g_MySelf.m_Abil.MaxHP - g_MySelf.m_Abil.HP));
      // dsurface.Draw(40, DBottom.Top + 91 + rc.Top, rc, D, False);
      // // MP 图形
      // rc := D.ClientRect;
      // rc.Left := 49;
      // rc.Right := D.ClientRect.Right;
      // rc.Top := Round(rc.Bottom / g_MySelf.m_Abil.MaxMP *
      // (g_MySelf.m_Abil.MaxMP - g_MySelf.m_Abil.MP));
      // dsurface.Draw(40 + rc.Left, DBottom.Top + 91 + rc.Top, rc,
      // D, False);
      //
      // rc := D.ClientRect;
      // rc.Left := 42;
      // rc.Right := 49;
      // dsurface.Draw(40 + rc.Left, DBottom.Top + 91, rc, D, False);
      // end;
      // D := g_77Images.Images[318 + FBloodTick];
      // if D <> nil then
      // dsurface.Draw(36, DBottom.Top + 91, D, beSrcColor);
      // end;
      // end;

      // 等级
      // PomiTextOut(dsurface, SCREENWIDTH - 140, SCREENHEIGHT - 104,
      // IntToStr(g_MySelf.m_Abil.Level));

      // dsurface.BoldText(g_sAttackMode, clWhite, FontBorderColor,
      // SCREENWIDTH - 160, SCREENHEIGHT - 138);

      DTDateTime.Propertites.Caption.Text := FormatDateTime('hh:mm:ss', Now);
      // TextNum.DrawNumberLeft(FormatDateTime('hh:mm:ss', Now), dsurface,
      // SCREENWIDTH - 128, SCREENHEIGHT - 21);

      DTHPText.Propertites.Caption.Text :=
        Format('%d/%d', [g_MySelf.m_Abil.HP, g_MySelf.m_Abil.MaxHP]);

      DTMPText.Propertites.Caption.Text :=
        Format('%d/%d', [g_MySelf.m_Abil.MP, g_MySelf.m_Abil.MaxMP]);

      DTMapXY.Propertites.Caption.Text :=
        Format('%s %d:%d', [g_sMapTitle, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY]);

      // TextNum.DrawNumberLeft(Format('%d/%d', [g_MySelf.m_Abil.HP,
      // g_MySelf.m_Abil.MaxHP]), dsurface, 27, SCREENHEIGHT - 37);
      // if not((g_MySelf.m_btJob = 0) and (g_MySelf.m_Abil.Level < 28)) then
      // TextNum.DrawNumberLeft(Format('%d/%d', [g_MySelf.m_Abil.MP,
      // g_MySelf.m_Abil.MaxMP]), dsurface, 89, SCREENHEIGHT - 37);
      // ATexture := FontManager.Default.TextOut(g_sMapTitle);
      //
      // if ATexture <> nil then
      // begin
      // dsurface.DrawBoldText(8, SCREENHEIGHT - 18, ATexture, clWhite,
      // FontBorderColor);
      // TextNum.DrawNumberLeft(Format('%d:%d', [g_MySelf.m_nCurrX,
      // g_MySelf.m_nCurrY]), dsurface, 16 + ATexture.WIDTH,
      // SCREENHEIGHT - 18);
      // end;

      // d := g_WMain3Images.Images[313];
      // if d <> nil then
      // dsurface.Draw(SCREENWIDTH-162, DBottom.Top+112, d.ClientRect, d, TRUE);

      // 旧的经验绘制 现在改为 裁剪动画框 随云
      // if (g_MySelf.m_Abil.MaxExp > 0) and (g_MySelf.m_Abil.MaxWeight > 0) then
      // begin
      // D := g_77Images.Images[233];
      // if D <> nil then
      // begin
      // // 经验条
      // rc := D.ClientRect;
      // if g_MySelf.m_Abil.Exp > 0 then
      // r := g_MySelf.m_Abil.MaxExp / g_MySelf.m_Abil.Exp
      // else
      // r := 0;
      // if r > 0 then
      // rc.Right := Round(rc.Right / r)
      // else
      // rc.Right := 0;
      // dsurface.Draw(SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 266))
      // { 666 } , SCREENHEIGHT - 71, rc, D, True);
      // // 背包重量条
      // rc := D.ClientRect;
      // if g_MySelf.m_Abil.Weight > 0 then
      // r := g_MySelf.m_Abil.MaxWeight / g_MySelf.m_Abil.Weight
      // else
      // r := 0;
      // if r > 0 then
      // rc.Right := Round(rc.Right / r)
      // else
      // rc.Right := 0;
      // dsurface.Draw(SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 266))
      // { 666 } , SCREENHEIGHT - 38, rc, D, True);
      // end;
      // end;

      // 饥饿程度
      if g_nMyHungryState in [1 .. 4] then
      begin
        D := g_WMainImages.Images[16 + g_nMyHungryState - 1];
        if D <> nil then
        begin
          dsurface.Draw(SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (400 - 354))
            { 754 } , 553, D.ClientRect, D, True);
        end;
      end;
    end;

    // D := g_77Images.Images[298];
    // if D <> nil then
    // dsurface.Draw(SCREENWIDTH - 204, DBottom.Top + 94 + 36, D, True);
  end;
end;

procedure TFrmDlg.DBottomInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  if TDControl(Sender).Propertites.MouseThrough then
    IsRealArea := false;
end;

procedure TFrmDlg.DBotPlusAbilDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  dd: TAsphyreLockableTexture;
begin
  with TDButton(Sender) do
  begin
    if not Downed then
    begin
      if (BlinkCount mod 2 = 0) and (not DAdjustAbility.visible) then
        dd := Propertites.Images.Images[Propertites.ImageIndex]
      else
        dd := Propertites.Images.Images[Propertites.ImageIndex + 2];
      if dd <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), dd.ClientRect, dd, True);
    end
    else
    begin
      dd := Propertites.Images.Images[Propertites.ImageIndex + 1];
      if dd <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), dd.ClientRect, dd, True);
    end;

    if GetTickCount - BlinkTime >= 500 then
    begin
      BlinkTime := GetTickCount;
      Inc(BlinkCount);
      if BlinkCount >= 10 then
        BlinkCount := 0;
    end;
  end;
end;

procedure TFrmDlg.DMyStateClick(Sender: TObject; X, Y: Integer);
begin
  DScreen.ClearHint;
  OpenMyStatus(0);
end;

procedure TFrmDlg.DBelt1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
begin
  with Sender as TDButton do
  begin
    if Tag in [0 .. 5] then
    begin
      if ItemCanShowInQuickBar(g_ItemArr[Tag]) then
      begin
        DrawItem(g_ItemArr[Tag], dsurface, SurfaceX(Left), SurfaceY(Top), WIDTH,
          Height, TimeTick);
      end;
    end;
  end;
end;

procedure TFrmDlg.DBelt1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Idx: Integer;
  tmpItem: TClientItem;
begin
  Idx := TDButton(Sender).Tag;
  if ItemCanShowInQuickBar(g_ItemArr[Idx]) then
  begin
    if Idx in [0 .. 5] then
    begin
      tmpItem := g_ItemArr[Idx];
      if tmpItem.Name <> '' then
      begin
        if (tmpItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
          DScreen.UpdateItemHintPostion(g_Application._CurPos)
        else
        begin
          g_MouseItem := tmpItem;
          DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
        end;
      end
      else
        DScreen.ClearHint;
    end
    else
      DScreen.ClearHint;
  end;
end;

procedure TFrmDlg.DBelt1Click(Sender: TObject; X, Y: Integer);
var
  Idx: Integer;
  temp: TClientItem;
begin
  if g_boDBClickItemWait = True then
  begin
    g_boDBClickItemWait := False;
    Exit;
  end;

  if g_boLockMoveItem then
    Exit;
  Idx := TDButton(Sender).Tag;

    if Idx in [0 .. 5] then
    begin
      if not g_boItemMoving then
      begin
        if g_ItemArr[Idx].Name <> '' then
        begin
          g_SoundManager.ItemClickSound(g_ItemArr[Idx].S);
          g_boItemMoving := True;
          g_MovingItem.FromIndex := Idx;
          g_MovingItem.Source := msBag;
          g_MovingItem.Item := g_ItemArr[Idx];
          g_ItemArr[Idx].Name := '';
        end;
      end
      else
      begin
        if g_MovingItem.Source in [msGold, msDealGold] then
          Exit;

        if  ItemCanShowInQuickBar (g_MovingItem.Item) then
        begin
          // if (g_MovingItem.Item.S.StdMode = 2) and (g_MovingItem.Item.S.Need = 1) then
          // Exit;
          if g_ItemArr[Idx].Name <> '' then
          begin
            temp := g_ItemArr[Idx];
            g_ItemArr[Idx] := g_MovingItem.Item;
            g_MovingItem.FromIndex := Idx;
            g_MovingItem.Source := msBag;
            g_MovingItem.Item := temp
          end
          else
          begin
            g_ItemArr[Idx] := g_MovingItem.Item;
            g_MovingItem.Item.Name := '';
            g_boItemMoving := False;
          end;
        end;
      end;
    end;
end;

procedure TFrmDlg.DBelt1DblClick(Sender: TObject);
var
  Idx: Integer;
begin
  if g_boLockMoveItem then
    Exit;
  Idx := TDButton(Sender).Tag;
  //if CanShowInQuickBar(g_ItemArr[Idx]) then
  begin
    g_EatingItemIndex := -1;
    if Idx in [0 .. 5] then
    begin

      if g_ItemArr[Idx].Name <> '' then
      begin
        if ItemCanShowInQuickBar(g_ItemArr[Idx]) then
          FrmMain.EatItem(Idx, g_boItemMoving);
      end
      else
      begin
        if g_boItemMoving and (g_MovingItem.FromIndex = Idx) and
          ItemCanShowInQuickBar(g_ItemArr[Idx]) then
          FrmMain.EatItem(Idx, g_boItemMoving);
      end;
      g_boDBClickItemWait := True;
    end;
  end;
end;

procedure TFrmDlg.DItemBagDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  if g_MySelf = nil then
    Exit;
  DItemBag.DefaultPaint(dsurface);
end;

procedure TFrmDlg.DItemsUpButDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with DItemsUpBut do
  begin
    if Propertites.Images <> nil then
    begin // 20080701
      if DItemsUpBut.Downed then
      begin
        D := Propertites.Images.Images[Propertites.ImageIndex];
        if D <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      end;
    end;
  end;
end;

procedure TFrmDlg.DItemsUpButInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  if Trim(ClientConf.sRefineName) = '' then
    IsRealArea := False;
end;

procedure TFrmDlg.DCloseBagClick(Sender: TObject; X, Y: Integer);
begin
  DItemBag.visible := False;
end;

procedure TFrmDlg.DItemGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
  Idx: Integer;
  tmpItem: TClientItem;
begin
  if ssRight in Shift then
  begin
    DScreen.ClearHint;
    if g_boItemMoving then
      DItemGridGridSelect(Self, ACol, ARow, Shift)
    else if GetTickCount - g_nDblItemTick > 700 then
    begin
      g_nDblItemTick := GetTickCount();
      MouseRightItem(1, ACol, ARow);
    end;
  end
  else
  begin
    Idx := ACol + ARow * DItemGrid.ColCount + 6 { 骇飘傍埃 };
    if Idx in [6 .. MAXBAGITEM - 1] then
    begin
      tmpItem := g_ItemArr[Idx];
      if tmpItem.Name <> '' then
      begin
        if (tmpItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
          DScreen.UpdateItemHintPostion(g_Application._CurPos)
        else
        begin
          g_MouseItem := tmpItem;
          DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
        end;
      end
      else
      begin
        g_MouseItem.Name := '';
        DScreen.ClearHint;
      end;
    end
    else
      DScreen.ClearHint;
  end;
end;

procedure TFrmDlg.DItemGridGridSelect(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
  Idx, mi, ACount: Integer;
  temp: TClientItem;
  TempIdx: Integer;
  boHaneld: Boolean;
  ItemName: String;
begin


  //物品双击 会执行到这里一次 导致物品再被选择  所以根据一个变量来做一个防范 随云
  if g_boDBClickItemWait then
  begin
    OutputDebugString(PChar('释放双击'));
    g_boDBClickItemWait := False;
    Exit;
  end;

  OutputDebugString(PChar('进入选择'));
  if g_boLockMoveItem then
  begin
    Exit;
  end;

  Idx := ACol + ARow * DItemGrid.ColCount + 6;
  if DItemGrid.IsRightSelected and not g_boPutOn then
  begin
    if not g_boItemMoving and (Idx in [6 .. MAXBAGITEM - 1]) and (Shift = [])
      and (g_ItemArr[Idx].Name <> '') then
    begin
      g_boItemMoving := True;
      g_MovingItem.FromIndex := Idx;
      g_MovingItem.Source := msBag;
      g_MovingItem.Item := g_ItemArr[Idx];
      g_ItemArr[Idx].Name := '';
      MouseDlbTakeItem(1, -1);
    end;
    Exit;
  end;

  if Idx in [6 .. MAXBAGITEM - 1] then
  begin
    if not g_boItemMoving then
    begin
      if g_ItemArr[Idx].Name <> '' then
      begin
        if (ssShift in Shift) and not g_boPutOn then
        begin
          g_SoundManager.ItemClickSound(g_ItemArr[Idx].S);
          SetDFocus(DEChat);
          ItemName := '[' + ObjectStrToSimple(g_ItemArr[Idx].DisplayName) + ']';
          PlayScene.AddChatObjText(ItemName, EncodeClientItem(g_ItemArr[Idx]));
        end
        else if (ssCtrl in Shift) and
          (g_ItemArr[Idx].S.StdMode in [{$I AddinStdmode.INC}]) and
          (g_ItemArr[Idx].Dura > 1) and not g_boPutOn then // 拆分
        begin
          g_MouseItem.Name := '';
          DScreen.ClearHint;
          ShowSplitItemDialog(g_ItemArr[Idx].DisplayName, g_ItemArr[Idx].Dura,
            g_ItemArr[Idx].MakeIndex);
        end
        else if (ssAlt in Shift) and
          not(g_ItemArr[Idx].S.StdMode in [{$I AddinStdmode.INC}]) and
          not g_boPutOn then
        begin
          FrmMain.SendAltLButtonBagItem(Idx, g_ItemArr[Idx].MakeIndex);
        end
        else
        begin
          g_SoundManager.ItemClickSound(g_ItemArr[Idx].S);
          if g_boPutOn then
          begin
            if not g_boStallLock then
            begin
              g_MouseItem.Name := '';
              DScreen.ClearHint;
              g_MarketItem.Inedex := Idx;
              g_MarketItem.Item.Item := g_ItemArr[Idx];
              g_ItemArr[Idx].Name := '';
              ShowMarketItemPutOn;
            end;
          end
          else
          begin
            g_boItemMoving := True;
            g_MovingItem.FromIndex := Idx;
            g_MovingItem.Source := msBag;
            g_MovingItem.Item := g_ItemArr[Idx];
            g_ItemArr[Idx].Name := '';
          end;
        end;
      end;
    end
    else
    begin
      if g_MovingItem.Source in [msGold, msDealGold] then
        Exit;

      if (g_MovingItem.Source = msUses) and
        (g_MovingItem.FromIndex in [U_DRESS .. U_MAXUSEITEMIDX]) then
      begin
        g_WaitingUseItem := g_MovingItem;
        g_WaitingUseItemTime := GetTickCount;
        FrmMain.SendTakeOffItem(g_MovingItem.FromIndex,
          g_MovingItem.Item.MakeIndex, g_MovingItem.Item.Name);
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
      end
      else
      begin
        case g_MovingItem.Source of
          msBag:
            ;
          msItemUp:
            g_ItemsUpItem[g_MovingItem.FromIndex].Name := '';
          msDrinkItem:
            ;
          msDealItem:
            DealItemReturnBag(g_MovingItem.Item);
          msDealGold:
            ;
          msSellItem:
            ;
          msMailItem:
            ;
          msWineMateria:
            ;
          msWineDrug:
            ;
          msChallenge:
            ChallengeItemReturnBag(g_MovingItem.Item);
          msCustomItem:
            ;
          msStall:
            ;
          // msJewelryBox:
          // begin
          // g_WaitingUseItem := g_MovingItem;
          // frmMain.SendJewelryBoxItemToBag(g_MovingItem.FromIndex,g_MovingItem.Item.MakeIndex);
          // g_MovingItem.Item.Name := '';
          // g_boItemMoving := False;
          // end;
          // msZodiacSigns:
          // begin
          // g_WaitingUseItem := g_MovingItem;
          // frmMain.SendZodiacSignItemToBag(g_MovingItem.FromIndex,g_MovingItem.Item.MakeIndex);
          // g_MovingItem.Item.Name := '';
          // g_boItemMoving := False;
          // end;
        end;

        // TODO if (mi <= -30) and (mi > -40) then // 元宝寄售 20080316
        // SellOffItemReturnBag(g_MovingItem.Item);

        if g_ItemArr[Idx].Name <> '' then
        begin
          boHaneld := False;
          case g_MovingItem.Item.S.StdMode of
{$I AddinStdmode.INC} , 71:
              begin
                if (g_MovingItem.Item.S.StdMode = g_ItemArr[Idx].S.StdMode) and
                  (g_MovingItem.Item.MakeIndex <> g_ItemArr[Idx].MakeIndex) then
                begin
                  if (g_ItemArr[Idx].Dura < g_ItemArr[Idx].S.DuraMax) and
                    (g_ItemArr[Idx].S.DuraMax > 1) then
                  begin
                    FrmMain.SendItemUnite(g_MovingItem.Item.MakeIndex,
                      g_ItemArr[Idx].MakeIndex);
                    boHaneld := True;
                  end;
                end;
              end;
            33:
              begin
                if (GetTickCount - g_dwLastClkFun > 500) and
                  (g_MovingItem.Item.MakeIndex <> g_ItemArr[Idx].MakeIndex) then
                begin
                  g_dwLastClkFun := GetTickCount;
                  FrmMain.SendItemClickFunc(g_MovingItem.Item.MakeIndex,
                    g_ItemArr[Idx].MakeIndex);
                  boHaneld := True;
                end;
              end;
          end;
          if not boHaneld then
          begin
            temp := g_ItemArr[Idx];
            g_ItemArr[Idx] := g_MovingItem.Item;
            g_MovingItem.FromIndex := Idx;
            g_MovingItem.Source := msBag;
            g_MovingItem.Item := temp;
          end;
        end
        else
        begin
          g_ItemArr[Idx] := g_MovingItem.Item;
          g_MovingItem.Item.Name := '';
          g_boItemMoving := False;
        end;
      end;
    end;
  end;
  ArrangeItemBag;
end;

// ****右键吃东西改成,双击吃东西****//
procedure TFrmDlg.DItemGridDblClick(Sender: TObject);
var
  Idx: Integer;
  keyvalue: TKeyBoardState;
  cu: TClientItem;
label
  finished;
begin

  OutputDebugString(PChar('进入双击'));
  if g_boLockMoveItem then
    Exit;

  g_EatingItemIndex := -1;
  Idx := DItemGrid.Col + DItemGrid.Row * DItemGrid.ColCount + 6;
  if Idx in [6 .. MAXBAGITEM - 1] then
  begin
    g_boDBClickItemWait := True;
    OutputDebugString(PChar('捕获双击'));
    if g_ItemArr[Idx].Name <> '' then
    begin // g_ItemArr[idx].Name <> '' 说明不是双击吃东西,一般是内挂吃的
      FillChar(keyvalue, SizeOf(TKeyBoardState), #0);
      GetKeyboardState(keyvalue);
      if keyvalue[VK_CONTROL] = $80 then
      begin
        cu := g_ItemArr[Idx];
        g_ItemArr[Idx].Name := '';
        AddItemBag(cu);
      end
      else if g_ItemArr[Idx].S.StdMode in [0, 1, 2, 3, 4, 31, 32, 34, 60,71] then
        FrmMain.EatItem(Idx, g_boItemMoving);
    end
    else
    begin
      if g_boItemMoving and (g_MovingItem.Item.Name <> '') and
        (g_MovingItem.Source <> msGold) then
      begin
        FillChar(keyvalue, SizeOf(TKeyBoardState), #0);
        GetKeyboardState(keyvalue);
        if keyvalue[VK_CONTROL] = $80 then
        begin
          cu := g_MovingItem.Item;
          g_MovingItem.Item.Name := '';
          g_boItemMoving := False;
          AddItemBag(cu);
        end
        else
        begin
          if (g_MovingItem.Source = msBag) and (g_MovingItem.FromIndex = Idx)
            and ((g_MovingItem.Item.S.StdMode in [0, 1, 2, 3, 4, 31, 32, 34, 60,71]
            ) or ((g_MovingItem.Item.S.StdMode = 48) and
            (g_MovingItem.Item.S.Source = 0))) then
          begin
            FrmMain.EatItem(Idx, g_boItemMoving);
            Exit;
          end;
          if (g_MovingItem.Source = msBag) and (g_MovingItem.FromIndex = Idx)
            and (g_MovingItem.Source <> msGold) then
          begin
            MouseDlbTakeItem(1, -1);
            Exit;
          end;
        end;
      end;
    end;
  end;

end;

procedure TFrmDlg.DItemGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
var
  Idx: Integer;
begin
  Idx := ACol + ARow * DItemGrid.ColCount + 6;
  if Idx in [6 .. MAXBAGITEM - 1] then
  begin
    with DItemGrid do
      DrawItem(g_ItemArr[Idx], dsurface, SurfaceX(Rect.Left),
        SurfaceY(Rect.Top), ColWidth, RowHeight, TimeTick);
  end;

end;

procedure TFrmDlg.DGoldClick(Sender: TObject; X, Y: Integer);
begin
  if g_MySelf = nil then
    Exit;
  if not g_boItemMoving then
  begin
    if g_nGold > 0 then
    begin
      g_SoundManager.DXPlaySound(s_money);
      g_boItemMoving := True;
      g_MovingItem.FromIndex := 0;
      g_MovingItem.Source := msGold;
      g_MovingItem.Item.Name := g_sGoldName;
    end;
  end
  else
  begin
    if g_MovingItem.Source in [msGold, msDealGold] then
    begin
      g_boItemMoving := False;
      g_MovingItem.Item.Name := '';
      if g_MovingItem.Source = msDealGold then
        DealZeroGold;
    end;
  end;
end;

procedure TFrmDlg.ShowMDlg(face: Integer; mname, msgstr: string);
var
  I: Integer;
begin
  UIWindowManager.CloseAll(False);
  DMerchantDlg.Left := 0; // 扁夯 困摹
  DMerchantDlg.Top := 0;
  MerchantFace := face;
  MerchantName := mname;
  MDlgStr := msgstr;
  DMerchantDlg.visible := True;
  DShop.visible := False;
  DItemBag.Left := DMerchantDlg.Width + 24;
  DItemBag.Top := 0;
  if MDlgPoints.Count > 0 then // 20080629
    for I := 0 to MDlgPoints.Count - 1 do
      Dispose(pTClickPoint(MDlgPoints[I]));
  MDlgPoints.Clear;
  RequireAddPoints := True;
  LastestClickTime := GetTickCount;
//  DMerchantDlgMessage.Left := MerchantDlgLeft;
//  DMerchantDlgMessage.Top := MerchantDlgTop;
//  DMerchantDlgMessage.WIDTH := DMerchantDlg.WIDTH - MerchantDlgLeft;
//  DMerchantDlgMessage.Height := DMerchantDlg.Height - MerchantDlgTop;
  DMerchantDlgMessage.Lines.Text := msgstr;
end;

procedure TFrmDlg.ShowCustomMDlg(AMerchant, AType, face: Integer;
  const UIName, NPCName, Message: string);
begin
  DMerchantDlg.visible := False;
  DShop.visible := False;
  if not UIWindowManager.ShowWindow(AType = 1, AMerchant, UIName, Message) then
  begin
    if AType = 0 then
      ShowMDlg(face, NPCName, Message);
  end;
end;

procedure TFrmDlg.ResetMaxMap;
begin
  g_nMouseMaxMapX := 0;
  g_nMouseMaxMapY := 0;
  g_nMouseMaxMapOffsetX := 0;
  g_nMouseMaxMapOffsetY := 0;
  DWMaxMiniMap.Left := _Max(0, (SCREENWIDTH - 600) div 2);
  DWMaxMiniMap.Top := _Max(0, (SCREENHEIGHT - 480 - DBottom.Height) div 2);
end;

procedure TFrmDlg.ResetMenuDlg;
var
  I: Integer;
begin
  CloseDSellDlg;
  if g_MenuItemList.Count > 0 then // 20080629
    for I := 0 to g_MenuItemList.Count - 1 do // 技何 皋春档 努府绢 窃.
      Dispose(PTClientItem(g_MenuItemList[I]));
  g_MenuItemList.Clear;

  for i := 0 to DLVGoods.Items.Count - 1 do
  begin
    if DLVGoods.Items[i].Data <> nil then
      Dispose(PTClientItem(DLVGoods.Items[i].Data));
  end;
  DLVGoods.Clear;

//  if MenuList.Count > 0 then // 20080629
//    for I := 0 to MenuList.Count - 1 do
//      Dispose(PTClientGoods(MenuList[I]));
//  MenuList.Clear;
//  MenuIndex := -1;


  MenuTopLine := 0;
  BoDetailMenu := False;
  BoMakeDrugMenu := False;

  DSellDlg.visible := False;
  DMenuDlg.visible := False;
  g_SellOffItemIndex := 200;
end;

procedure TFrmDlg.ResetSDMiniMapSizeAndPosition(&type: integer);
var
  W,H:Integer;
begin
//
  if &type = 1 then
  begin
    W := SD_MMapWidth_1;
    H := SD_MMapHeight_1;
  end else
  begin
    W := SD_MMapWidth_2;
    H := SD_MMapHeight_2;
  end;

  DMiniMap_SD.Left := SCREENWIDTH - W;
  DMiniMap_SD.Top := 0;
  DMiniMap_SD.Width := W;
  DMiniMap_SD.Height := H;
end;

procedure TFrmDlg.ReSetShopState;
begin
  if g_ShopItemList.Count > 0 then
  begin
    g_ShopItem := pTShopItem(g_ShopItemList[0])^;
    DEShopAmount.Text := '1';
    FShopAmount := 1;
    DShopBuy.Enabled := True;
  end
  else
  begin
    g_ShopItem.Name := '';
    DEShopAmount.Text := '0';
    FShopAmount := 0;
    DShopBuy.Enabled := False;
  end;
end;

procedure TFrmDlg.ReStall;
begin
  g_MarketItem.Item.Item.Name := '';
  g_MarketItem.Inedex := -1;
  MarketItemIndex := -1;
  g_boPutOn := False;
end;

procedure TFrmDlg.ClearExtendButtons;
var
  I: Integer;
begin
  for I := 0 to FExtendButtons.Count - 1 do
  begin
    FExtendButtons[I].DParent.DControls.Remove(FExtendButtons[I]);
    FExtendButtons[I].DParent := nil;
    FExtendButtons[I].Free;
  end;
  FExtendButtons.Clear;
  for I := 0 to FTopExtendButtons.Count - 1 do
  begin
    FTopExtendButtons[I].DParent.DControls.Remove(FTopExtendButtons[I]);
    FTopExtendButtons[I].DParent := nil;
    FTopExtendButtons[I].Free;
  end;
  FTopExtendButtons.Clear;
end;

procedure TFrmDlg.ClearMailWriter;
begin
  DEMailTo.Text := '';
  DEMailSubject.Text := '';
  DMMailEdit.Lines.Clear;
  DESendGold.Text := '';
  DEBuyAttPrice.Text := '';
end;

procedure TFrmDlg.ClearMailReader;
begin
  DMMReader.Lines.Clear;
end;

procedure TFrmDlg.ExtButtonMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  nLocalY: Integer;
begin
  with Sender as TdxExtendButton do
    if Hint <> '' then
    begin
      if pos('\', Hint) > 0 then
        nLocalY := 12
      else
        nLocalY := 0;
      DScreen.ShowHint(SurfaceX(Left), SurfaceY(Top - 20 - nLocalY), Hint);
    end;
end;

procedure TFrmDlg.ExtButtonDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with TDButton(Sender) do
  begin
    if Propertites.Images <> nil then
    begin
      D := nil;
      if Downed then
        D := Propertites.Images.Images[Propertites.ImageIndex + 1]
      else if Moveed then
        D := Propertites.Images.Images[Propertites.ImageIndex + 2];
      if D = nil then
        D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    end;
  end;
end;

procedure TFrmDlg.EndMessageBox(ATag: Integer);
var
  AResult: TModalResult;
begin
  if FDialogItem <> nil then
  begin
    EdtMsgDlg.visible := False;
    SetImeMode(EdtMsgDlg.Handle, imClose);
    RestoreHideControls;
    DlgEditText := EdtMsgDlg.Text;
    ViewDlgEdit := False;
    if Assigned(FDialogItem.Handler) then
      FDialogItem.Handler(AResult);

    FreeMem(FDialogItem);
    FDialogItem := nil;
    MessageBoxTimer.Enabled := True;
  end;
end;

procedure TFrmDlg.ExtButtonClick(Sender: TObject; X, Y: Integer);
begin
  with Sender as TdxExtendButton do
    if CommandText <> '' then
      FrmMain.SendExtendCommandExecute(CommandText);
end;

procedure TFrmDlg.AddExtendButton(const AName, AHint, ACommand: String;
  ImageIndex: Integer; ISTop: Boolean ;X:Integer = 0 ; Y : Integer = 0);
var
  I: Integer;
  AButton: TdxExtendButton;
begin
  if ISTop then
  begin
    for I := 0 to FTopExtendButtons.Count - 1 do
      if FTopExtendButtons.Items[I].TagName = AName then
      begin
        FTopExtendButtons.Items[I].Propertites.ImageIndex := ImageIndex;
        FTopExtendButtons.Items[I].CommandText := ACommand;
        Exit;
      end;

    AButton := TdxExtendButton.Create(nil);
    AButton.Parent := Self;
    AButton.visible := False;
    AButton.EnableFocus := False;
    AButton.DParent := DTopExtendButtons;
    DTopExtendButtons.AddChild(AButton);
    AButton.Propertites.Sound := csNorm;
    AButton.SetImgIndex(g_77Icons, ImageIndex);
    AButton.Hint := AHint;
    AButton.Top := 8;
    AButton.CommandText := ACommand;
    AButton.TagName := AName;
    AButton.OnDirectPaint := ExtButtonDirectPaint;
    AButton.OnMouseMove := ExtButtonMouseMove;
    AButton.OnClick := ExtButtonClick;
    FTopExtendButtons.Add(AButton);

    if (X <> 0) and (Y <> 0) then
    begin
      AButton.Top := Y;
      AButton.Left :=  X;
    end else
    begin
      SetTopExtButtonBounds;
    end;
    AButton.visible := True;
  end
  else
  begin
    for I := 0 to FExtendButtons.Count - 1 do
      if FExtendButtons.Items[I].TagName = AName then
      begin
        FExtendButtons.Items[I].Propertites.ImageIndex := ImageIndex;
        FExtendButtons.Items[I].CommandText := ACommand;
        Exit;
      end;

    AButton := TdxExtendButton.Create(nil);
    AButton.Parent := Self;
    AButton.visible := False;
    AButton.DParent := DBottom;
    AButton.EnableFocus := False;
    DBottom.AddChild(AButton);
    AButton.Propertites.Sound := csNorm;
    AButton.SetImgIndex(g_77Icons, ImageIndex);
    AButton.Hint := AHint;
    AButton.Top := 104 + (13 - AButton.Height) div 2;
    AButton.CommandText := ACommand;
    AButton.TagName := AName;
    AButton.OnDirectPaint := ExtButtonDirectPaint;
    AButton.OnMouseMove := ExtButtonMouseMove;
    AButton.OnClick := ExtButtonClick;
    FExtendButtons.Add(AButton);

    if (X <> 0) and (Y <> 0) then
    begin
      AButton.Top := Y;
      AButton.Left :=  X;
    end else
    begin
      SetExtButtonBounds;
    end;
    AButton.visible := True;
  end;
end;

procedure TFrmDlg.RemoveExtendButton(const AName: String);
var
  I: Integer;
begin
  for I := 0 to FExtendButtons.Count - 1 do
    if FExtendButtons[I].TagName = AName then
    begin
      FExtendButtons[I].DParent.DControls.Remove(FExtendButtons[I]);
      FExtendButtons[I].visible := False;
      FExtendButtons[I].DParent := nil;
      FExtendButtons[I].Free;
      FExtendButtons.Delete(I);
      //SetExtButtonBounds;
      Exit;
    end;

  for I := 0 to FTopExtendButtons.Count - 1 do
    if FTopExtendButtons[I].TagName = AName then
    begin
      FTopExtendButtons[I].DParent.DControls.Remove(FTopExtendButtons[I]);
      FTopExtendButtons[I].visible := False;
      FTopExtendButtons[I].DParent := nil;
      FTopExtendButtons[I].Free;
      FTopExtendButtons.Delete(I);
      //SetTopExtButtonBounds;
      Exit;
    end;
end;

procedure TFrmDlg.SetAjustAbiPosition;
const
  ___Top = 58;

var
  ARow: Integer;
begin
  ARow := 0;
  DPlusDC.Left := 300;
  DPlusDC.Top := ___Top + ARow * 20;
  Inc(ARow);
  DPlusMC.Left := 300;
  DPlusMC.Top := ___Top + ARow * 20;
  Inc(ARow);
  DPlusSC.Left := 300;
  DPlusSC.Top := ___Top + ARow * 20;
  Inc(ARow);

  DPlusTC.Left := 300;
  DPlusTC.Top := ___Top + ARow * 20;
  DPlusTC.visible := True;
  Inc(ARow);

  DPlusPC.Left := 300;
  DPlusPC.Top := ___Top + ARow * 20;
  DPlusPC.visible := True;
  Inc(ARow);

  DPlusWC.Left := 300;
  DPlusWC.Top := ___Top + ARow * 20;
  DPlusWC.visible := True;
  Inc(ARow);

  DPlusAC.Left := 300;
  DPlusAC.Top := ___Top + ARow * 20;
  Inc(ARow);
  DPlusMAC.Left := 300;
  DPlusMAC.Top := ___Top + ARow * 20;
  Inc(ARow);
  DPlusHP.Left := 300;
  DPlusHP.Top := ___Top + ARow * 20;
  Inc(ARow);
  DPlusMP.Left := 300;
  DPlusMP.Top := ___Top + ARow * 20;
  Inc(ARow);
  DPlusHit.Left := 300;
  DPlusHit.Top := ___Top + ARow * 20;
  Inc(ARow);
  DPlusSpeed.Left := 300;
  DPlusSpeed.Top := ___Top + ARow * 20;

  ARow := 0;
  DMinusDC.Left := 317;
  DMinusDC.Top := ___Top + ARow * 20;
  Inc(ARow);
  DMinusMC.Left := 317;
  DMinusMC.Top := ___Top + ARow * 20;
  Inc(ARow);
  DMinusSC.Left := 317;
  DMinusSC.Top := ___Top + ARow * 20;
  Inc(ARow);

    DMinusTC.Left := 317;
    DMinusTC.Top := ___Top + ARow * 20;
    DMinusTC.visible := True;
    Inc(ARow);


    DMinusPC.Left := 317;
    DMinusPC.Top := ___Top + ARow * 20;
    DMinusPC.visible := True;
    Inc(ARow);

    DMinusPC.visible := False;

    DMinusWC.Left := 317;
    DMinusWC.Top := ___Top + ARow * 20;
    DMinusWC.visible := True;
    Inc(ARow);

    DMinusWC.visible := False;
  DMinusAC.Left := 317;
  DMinusAC.Top := ___Top + ARow * 20;
  Inc(ARow);
  DMinusMAC.Left := 317;
  DMinusMAC.Top := ___Top + ARow * 20;
  Inc(ARow);
  DMinusHP.Left := 317;
  DMinusHP.Top := ___Top + ARow * 20;
  Inc(ARow);
  DMinusMP.Left := 317;
  DMinusMP.Top := ___Top + ARow * 20;
  Inc(ARow);
  DMinusHit.Left := 317;
  DMinusHit.Top := ___Top + ARow * 20;
  Inc(ARow);
  DMinusSpeed.Left := 317;
  DMinusSpeed.Top := ___Top + ARow * 20;
end;

procedure TFrmDlg.SetOrderPosition;

  procedure SetButtonPosition(V: Boolean; b: TDButton; var L: Integer);
  begin
    b.visible := True;
    b.Left := L;
    b.Top := 1;
    L := L + 48;
  end;

var
  L: Integer;
begin
  g_Orders.OrderType := 0;
  L := 10;
  SetButtonPosition(True, DOrderLevel, L);
  SetButtonPosition(True, DOrderRiches, L);
  SetButtonPosition(True, DOrderMaster, L);
  SetButtonPosition(ClientConf.boMixedAbility, DOrderAbil, L);
  SetButtonPosition(cjWAR in g_ServerJobs, DOrderWar, L);
  SetButtonPosition(cjMAG in g_ServerJobs, DOrderMag, L);
  SetButtonPosition(cjDAO in g_ServerJobs, DOrderDao, L);
  SetButtonPosition(cjCIK in g_ServerJobs, DOrderCik, L);
  SetButtonPosition(cjARCHER in g_ServerJobs, DOrderArc, L);
  SetButtonPosition(cjShaman in g_ServerJobs, DOrderWS, L);
  DRankType.Width := 500;
  DRankType.Height := 30;
  DRankType.Left := 31;
  DRankType.Top := 60;
end;

procedure TFrmDlg.SetRankListViewData(RankOrder: TuOrderObject);
var
  I : Integer;
  Item:TuOrderItem;
begin
  DV_RankInfo.Clear;
  for i := 0 to RankOrder.Items.Count - 1 do
  begin
    Item := RankOrder.Items[i];
    with DV_RankInfo.Add do
    begin
      SubStrings.Add(IntToStr(RankOrder.Page * 10 + I + 1));
      SubStrings.Add(Item.Name);
      SubStrings.Add(Item.Job);
      SubStrings.Add(Item.Sex);
      SubStrings.Add(Item.Data);
      Data := Item;
    end;
  end;

  if ShowMySelfOrder then
  begin
    DV_RankInfo.SelectedIndex := RankOrder.MyOrder mod 10
  end;
end;

procedure TFrmDlg.SetExtButtonBounds;
var
  I: Integer;
  StartLeft: Integer;
begin
  for I := 0 to FExtendButtons.Count - 1 do
    FExtendButtons[I].visible := False;

  StartLeft := DBotHorse.Left + DBotHorse.WIDTH + 2;
  for I := 0 to FExtendButtons.Count - 1 do
  begin
    if StartLeft + FExtendButtons[I].WIDTH > DBotLogout.Left then
      Break;

    FExtendButtons[I].Left := StartLeft;
    FExtendButtons[I].visible := True;
    StartLeft := StartLeft + FExtendButtons[I].WIDTH + 2;
  end;
end;

procedure TFrmDlg.SetTitlePage(Page: Integer);
var
  nMagicIndex: Integer;
  nPageMagicCount: Integer;
  I: Integer;
  pTitle: pTClientHumTitle;
  Index: Integer;
begin
  nPageMagicCount := 6;
  nMagicIndex := nPageMagicCount * Page;
  Index := 0;
  MagicPage := Page;
  for I := nMagicIndex to (nMagicIndex + nPageMagicCount - 1) do
  begin
    if (I >= 0) and (I < g_Titles.Count) then
      pTitle := g_Titles[I]
    else
      pTitle := nil;

    SetTitleItemUIData(Index, pTitle);
    Inc(Index);
  end;
end;

//procedure TFrmDlg.SetTopExtButtonBounds;
//var
//  Idx, I, ALeft, ATop, MaxLineHeight, MaxLineWidth, OY: Integer;
//  StartLeft: Integer;
//  J: Integer;
//begin
//  DTopExtendButtons.visible := False;
//  if FTopExtendButtons.Count > 0 then
//  begin
//    for I := 0 to FTopExtendButtons.Count - 1 do
//      FTopExtendButtons[I].visible := False;
//
//    ATop := 0;
//    MaxLineWidth := 0;
//    for I := 0 to Math.Ceil(FTopExtendButtons.Count / 4) - 1 do
//    begin
//      MaxLineHeight := 0;
//      ALeft := 0;
//      for J := 0 to 3 do
//      begin
//        Idx := I * 4 + J;
//        if Idx > FTopExtendButtons.Count - 1 then
//          Break;
//        FTopExtendButtons[Idx].Left := ALeft;
//        FTopExtendButtons[Idx].Top := ATop;
//        FTopExtendButtons[Idx].visible := True;
//        ALeft := ALeft + FTopExtendButtons[Idx].WIDTH;
//        MaxLineHeight := Max(MaxLineHeight, FTopExtendButtons[Idx].Height);
//      end;
//      MaxLineWidth := Max(MaxLineWidth, ALeft);
//      ATop := ATop + MaxLineHeight + 8;
//    end;
//
//    DTopExtendButtons.WIDTH := MaxLineWidth;
//    DTopExtendButtons.Height := ATop;
//    DTopExtendButtons.Top := 8;
//
//    if DWMiniMap.visible then
//      DTopExtendButtons.Left := DWMiniMap.Left - DTopExtendButtons.WIDTH - 16
//    else
//      DTopExtendButtons.Left := SCREENWIDTH - DTopExtendButtons.WIDTH - 8;
//  end;
//  DTopExtendButtons.visible := FTopExtendButtons.Count > 0;
//end;

procedure TFrmDlg.SetTopExtButtonBounds;
var
  Idx, I, ALeft, ATop, MaxLineHeight, MaxLineWidth, OY: Integer;
  StartLeft: Integer;
  J: Integer;
begin
  if FTopExtendButtons.Count > 0 then
  begin
    for I := 0 to FTopExtendButtons.Count - 1 do
      FTopExtendButtons[I].visible := False;

    ATop := 0;
    MaxLineWidth := 0;
    for I := 0 to Math.Ceil(FTopExtendButtons.Count / 4) - 1 do
    begin
      MaxLineHeight := 0;
      ALeft := 0;
      for J := 0 to 3 do
      begin
        Idx := I * 4 + J;
        if Idx > FTopExtendButtons.Count - 1 then
          Break;
        FTopExtendButtons[Idx].Left := ALeft;
        FTopExtendButtons[Idx].Top := ATop;
        FTopExtendButtons[Idx].visible := True;
        ALeft := ALeft + FTopExtendButtons[Idx].WIDTH;
        MaxLineHeight := Max(MaxLineHeight, FTopExtendButtons[Idx].Height);
      end;
      MaxLineWidth := Max(MaxLineWidth, ALeft);
      ATop := ATop + MaxLineHeight + 8;
    end;

  end;
end;

procedure TFrmDlg.ShowShopMenuDlg(ShopOnly: Boolean);
begin
  //MenuIndex := -1;
  DLVGoods.SelectedIndex := -1;
  DMerchantDlg.Left := 0; // 扁夯 困摹
  DMerchantDlg.Top := 0;
  DMerchantDlg.visible := True;
  DSellDlg.visible := False;
  DMenuDlg.Left := 0;
  DMenuDlg.Top := DMerchantDlg.Height + DMerchantDlg.Top;
  DMenuDlg.visible := True;
  MenuTop := 0;
  DItemBag.Left := DMerchantDlg.Width + 24;
  DItemBag.Top := 0;
  DItemBag.visible := True;
  LastestClickTime := GetTickCount;
end;

procedure TFrmDlg.ShowStorgeDlg;
begin
  DLVSaveItems.SelectedIndex := -1;
  DMerchantDlg.Left := 0;
  DMerchantDlg.Top := 0;
  DMerchantDlg.visible := True;
  DMenuDlg.Visible := False;
  DSellDlg.visible := False;
  DStorageWin.Left := 0;
  DStorageWin.Top := DMerchantDlg.Height + DMerchantDlg.Top;
  DStorageWin.visible := True;
  MenuTop := 0;
  DItemBag.Left := DMerchantDlg.Width + 24;
  DItemBag.Top := 0;
  DItemBag.visible := True;
  LastestClickTime := GetTickCount;
end;

procedure TFrmDlg.ShowShopSellDlg;
begin
  DSellDlg.Left := DMerchantDlg.Width - DSellDlg.Width - 24;
  DSellDlg.Top := DMerchantDlg.Height + DMerchantDlg.Top;
  DSellDlg.visible := True;
  DStorageWin.Visible := False;
  DMenuDlg.visible := False;
  DItemBag.Left := DMerchantDlg.Width + 24;
  DItemBag.Top := 0;
  DItemBag.visible := True;
  LastestClickTime := GetTickCount;
  g_sSellPriceStr := '';
end;

procedure TFrmDlg.CloseMDlg(CloseManual: Boolean);
var
  I: Integer;
begin
  DMerchantDlg.visible := False;
  if MDlgPoints <> nil then
  begin
    MDlgStr := '';
    for I := 0 to MDlgPoints.Count - 1 do
      Dispose(pTClickPoint(MDlgPoints[I]));
    MDlgPoints.Clear;
  end;
  DItemBag.Left := 0;
  DItemBag.Top := 0;
  DMenuDlg.visible := False;
  DStorageWin.Visible := False;
  CloseDSellDlg;
  UIWindowManager.CloseAll(CloseManual);
  DWMarket.visible := False;
  DWMarketItem.visible := False;
  DMailList.visible := False;
  DMailReader.visible := False;
  DMailWriter.visible := False;
  DPlayDrink.visible := False;
  DWPleaseDrink.visible := False;
  DWStallWin.visible := False;
  DWStallQueryWin.visible := False;
  if g_PDrinkItem[0].Name <> '' then
  begin
    AddItemBag(g_PDrinkItem[0]);
    g_PDrinkItem[0].Name := '';
  end;
  if g_PDrinkItem[1].Name <> '' then
  begin
    AddItemBag(g_PDrinkItem[1]);
    g_PDrinkItem[1].Name := '';
  end;
end;

procedure TFrmDlg.CloseForMapChanged;
begin
  DWDice.visible := False;
end;

procedure TFrmDlg.CloseProgress;
begin
  DWProgress.visible := False;
end;

procedure TFrmDlg.CloseTopmost;
var
  I: Integer;
begin
  if g_MySelf <> nil then
  begin
    for I := 0 to DBackground.DControls.Count - 1 do
    begin
      if DBackground.DControls[I].visible and DBackground.DControls[I]
        .AllowESC then
      begin
        DBackground.DControls[I].visible := False;
        Break;
      end;
    end;
  end;
end;

procedure TFrmDlg.CloseDSellDlg;
begin
  DSellDlg.visible := False;
  if g_SellDlgItem.Name <> '' then
    AddItemBag(g_SellDlgItem);
  g_SellDlgItem.Name := '';
end;

procedure TFrmDlg.DMerchantDlgInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  IsRealArea := True;
end;

procedure TFrmDlg.DMerchantDlgCloseClick(Sender: TObject; X, Y: Integer);
begin
  CloseMDlg(False);
end;

procedure TFrmDlg.DMenuDlgDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);

  function sx(X: Integer): Integer;
  begin
    Result := DMenuDlg.SurfaceX(DMenuDlg.Left + X);
  end;
  function sy(Y: Integer): Integer;
  begin
    Result := DMenuDlg.SurfaceY(DMenuDlg.Top + Y);
  end;

var
  I, lh, m, menuline: Integer;
  D: TAsphyreLockableTexture;
  pg: PTClientGoods;
  str: string;
  AColor: TColor;
begin
//  if DMenuDlg.Propertites.Images <> nil then
//  begin
//    D := DMenuDlg.Propertites.Images.Images[DMenuDlg.Propertites.ImageIndex];
//    if D <> nil then
//      dsurface.Draw(DMenuDlg.SurfaceX(DMenuDlg.Left),
//        DMenuDlg.SurfaceY(DMenuDlg.Top), D.ClientRect, D, True);
//  end;
//
//  AColor := clWhite;
//  if not BoStorageMenu then
//  begin
//    dsurface.TextOut(19, sy(11), '物品列表', clWhite);
//    dsurface.TextOut(sx(156), sy(11), '价格', clWhite);
//    dsurface.TextOut(sx(245), sy(11), '持久', clWhite);
//    lh := LISTLINEHEIGHT;
//    menuline := _MIN(MAXMENU, MenuList.Count - MenuTop);
//    for I := MenuTop to MenuTop + menuline - 1 do
//    begin
//      m := I - MenuTop;
//      if I = MenuIndex then
//      begin
//        AColor := clRed;
//        dsurface.TextOut('>', AColor, sx(12), sy(32 + m * lh));
//      end
//      else
//        AColor := clWhite;
//      pg := PTClientGoods(MenuList[I]);
//      if pg.SubMenu > 0 then
//        uTextures.Textures.ObjectName(dsurface, pg.Name).Draw(dsurface, sx(19),
//          sy(32 + m * lh), AColor)
//      else
//        uTextures.Textures.ObjectName(dsurface, pg.Item.DisplayName)
//          .Draw(dsurface, sx(19), sy(32 + m * lh), AColor);
//      dsurface.TextOut(IntToStr(pg.Price) + ' ' + g_sGoldName, AColor, sx(156),
//        sy(32 + m * lh));
//      str := '';
//      if pg.Grade = -1 then
//        str := '-'
//      else
//        dsurface.TextOut(IntToStr(pg.Grade), AColor, sx(245), sy(32 + m * lh));
//    end;
//  end
//  else
//  begin
//    dsurface.TextOut('托管物品列表(' + IntToStr(MenuList.Count) + '/44件)', clWhite,
//      sx(19), sy(11));
//    dsurface.TextOut('持久', clWhite, sx(156), sy(11));
//    dsurface.TextOut('数量', clWhite, sx(245), sy(11));
//    lh := LISTLINEHEIGHT;
//    menuline := _MIN(MAXMENU, MenuList.Count - MenuTop);
//    for I := MenuTop to MenuTop + menuline - 1 do
//    begin
//      m := I - MenuTop;
//      if I = MenuIndex then
//      begin
//        AColor := clRed;
//        dsurface.TextOut('>', AColor, sx(12), sy(32 + m * lh));
//      end
//      else
//        AColor := clWhite;
//      pg := PTClientGoods(MenuList[I]);
//      uTextures.Textures.ObjectName(dsurface, pg.Item.DisplayName)
//        .Draw(dsurface, sx(19), sy(32 + m * lh), AColor);
//      case pg.Item.S.StdMode of
//{$I AddinStdmode.INC}:
//          begin
//            dsurface.TextOut('-', AColor, sx(156), sy(32 + m * lh));
//            dsurface.TextOut(IntToStr(pg.Item.Dura), AColor, sx(245),
//              sy(32 + m * lh));
//          end;
//        4:
//          begin
//            dsurface.TextOut('-', AColor, sx(156), sy(32 + m * lh));
//            dsurface.TextOut('1', AColor, sx(245), sy(32 + m * lh));
//          end;
//      else
//        begin
//          dsurface.TextOut(IntToStr(pg.Stock) + '/' + IntToStr(pg.Grade),
//            AColor, sx(156), sy(32 + m * lh));
//          dsurface.TextOut('1', AColor, sx(245), sy(32 + m * lh));
//        end;
//      end;
//    end;
//  end;
end;

procedure TFrmDlg.DMenuDlgClick(Sender: TObject; X, Y: Integer);
var
  lx, ly, Idx: Integer;
  pg: PTClientGoods;
begin
  DScreen.ClearHint;
//  lx := DMenuDlg.LocalX(X) - DMenuDlg.Left;
//  ly := DMenuDlg.LocalY(Y) - DMenuDlg.Top;
//  if (lx >= 14) and (lx <= 279) and (ly >= 32) and (ly <= 160) then
//  begin
//    Idx := (ly - 32) div LISTLINEHEIGHT + MenuTop;
//    if Idx < MenuList.Count then
//    begin
//      g_SoundManager.DXPlaySound(s_glass_button_click);
//      MenuIndex := Idx;
//    end;
//  end;
//
//  lx := 292;
//  ly := 32 + (MenuIndex - MenuTop) * LISTLINEHEIGHT;
//  if BoStorageMenu then
//  begin
//    if (MenuIndex >= 0) and (MenuIndex < g_SaveItemList.Count) then
//    begin
//      g_MouseItem := PTClientItem(g_SaveItemList[MenuIndex])^;
//      if g_MouseItem.Name <> '' then
//      begin
//        with Sender as TDButton do
//          DScreen.ShowItemHint(DMenuDlg.SurfaceX(Left + lx),
//            DMenuDlg.SurfaceY(Top + ly), g_MouseItem, fkNormal);
//      end;
//      g_MouseItem.Name := '';
//    end;
//  end
//  else
//  begin
//    if MenuIndex >= 0 then
//    begin
//      if MenuIndex < g_MenuItemList.Count then // 商品明细
//      begin
//        pg := PTClientGoods(MenuList[MenuIndex]);
//        if (pg <> nil) and (pg.SubMenu = 0) then
//        begin
//          g_MouseItem := PTClientItem(g_MenuItemList[MenuIndex])^;
//          if g_MouseItem.Name <> '' then
//          begin
//            with Sender as TDButton do
//              DScreen.ShowItemHint(DMenuDlg.SurfaceX(Left + lx),
//                DMenuDlg.SurfaceY(Top + ly), g_MouseItem, fkNormal);
//          end;
//          g_MouseItem.Name := '';
//        end;
//      end
//      else if MenuIndex < MenuList.Count then // 商品汇总
//      begin
//        pg := PTClientGoods(MenuList[MenuIndex]);
//        if (pg <> nil) and (pg.SubMenu = 0) then
//        begin
//          g_MouseItem := PTClientGoods(MenuList[MenuIndex]).Item;
//          if g_MouseItem.Name <> '' then
//          begin
//            with Sender as TDButton do
//              DScreen.ShowItemHint(DMenuDlg.SurfaceX(Left + lx),
//                DMenuDlg.SurfaceY(Top + ly), g_MouseItem, fkNormal);
//          end;
//          g_MouseItem.Name := '';
//        end;
//      end;
//    end;
//  end;
end;

procedure TFrmDlg.DMenuDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  with DMenuDlg do
    if (X < SurfaceX(Left + 10)) or (X > SurfaceX(Left + WIDTH - 20)) or
      (Y < SurfaceY(Top + 30)) or (Y > SurfaceY(Top + Height - 50)) then
    begin
      DScreen.ClearHint;
    end;
end;

procedure TFrmDlg.DMenuBuyClick(Sender: TObject; X, Y: Integer);
var
  pg: PTClientGoods;
  ACount: Integer;
begin
  if GetTickCount < LastestClickTime then
    Exit;
  if g_boLockMoveItem then
    Exit;

//  if (MenuIndex >= 0) and (MenuIndex < MenuList.Count) then
//  begin
//    pg := PTClientGoods(MenuList[MenuIndex]);
//    LastestClickTime := GetTickCount + 500;
//
//    if pg.SubMenu > 0 then
//    begin
//      FrmMain.SendGetDetailItem(g_nCurMerchant, 0, pg.Name);
//      MenuTopLine := 0;
//      CurDetailItem := pg.Name;
//    end
//    else
//    begin
//      if BoStorageMenu then
//      begin
//        FrmMain.SendTakeBackStorageItem(g_nCurMerchant,
//          pg.Price { MakeIndex } , pg.Name);
//        Exit;
//      end;
//      if BoMakeDrugMenu then
//      begin
//        FrmMain.SendMakeDrugItem(g_nCurMerchant, pg.Name);
//        Exit;
//      end;
//
//      if (pg.Item.Name <> '') and (pg.Item.S.StdMode in [{$I AddinStdmode.INC}])
//        and (pg.Item.S.DuraMax > 1) then
//      begin
//        ShowBuyItemDialog(pg.Item.DisplayName, pg.Name, pg.Item.S.DuraMax,
//          pg.Item.S.Price, pg.Stock);
//      end
//      else
//        FrmMain.SendBuyItem(g_nCurMerchant, pg.Stock, 1, pg.Name);
//    end;
//  end;

  pg := DLVGoods.SelectedData;
  if pg <> nil then
  begin
    if Pg.SubMenu > 0 then
    begin
      FrmMain.SendGetDetailItem(g_nCurMerchant, 0, pg.Name);
      MenuTopLine := 0;
      CurDetailItem := pg.Name;
    end else
    begin

      if BoMakeDrugMenu then
      begin
        FrmMain.SendMakeDrugItem(g_nCurMerchant, pg.Name);
        Exit;
      end;

      if (pg.Item.Name <> '') and (pg.Item.S.StdMode in [{$I AddinStdmode.INC}])
        and (pg.Item.S.DuraMax > 1) then
      begin
        ShowBuyItemDialog(pg.Item.DisplayName, pg.Name, pg.Item.S.DuraMax,
          pg.Item.S.Price, pg.Stock);
      end
      else
        FrmMain.SendBuyItem(g_nCurMerchant, pg.Stock, 1, pg.Name);
    end;
  end;
end;

procedure TFrmDlg.DMenuPrevClick(Sender: TObject; X, Y: Integer);
begin
  if not BoDetailMenu then
  begin
    if MenuTop > 0 then
      Dec(MenuTop, MAXMENU);
    if MenuTop < 0 then
      MenuTop := 0;
  end
  else
  begin
    if MenuTopLine > 0 then
    begin
      MenuTopLine := _Max(0, MenuTopLine - 10);
      FrmMain.SendGetDetailItem(g_nCurMerchant, MenuTopLine, CurDetailItem);
    end;
  end;

    if DLVGoods.PageIndex > 0 then
      DLVGoods.PageIndex := DLVGoods.PageIndex - 1;
end;

procedure TFrmDlg.DMenuNextClick(Sender: TObject; X, Y: Integer);
begin
  if not BoDetailMenu then
  begin
//    if MenuTop + MAXMENU < MenuList.Count then
//      Inc(MenuTop, MAXMENU);

    if DLVGoods.PageIndex < DLVGoods.PageCount - 1 then
    DLVGoods.PageIndex := DLVGoods.PageIndex + 1;
  end
  else
  begin
    MenuTopLine := MenuTopLine + 10;
    FrmMain.SendGetDetailItem(g_nCurMerchant, MenuTopLine, CurDetailItem);
  end;



end;

procedure TFrmDlg.SoldOutGoods(itemserverindex: Integer);
var
  I: Integer;
  pg: PTClientGoods;
begin
  for i := 0 to DLVGoods.Items.Count - 1 do
  begin
    pg := PTClientGoods(DLVGoods.Items[I].Data);
    if (pg.Grade >= 0) and (pg.Stock = itemserverindex) then
    begin
      Dispose(pg);
      DLVGoods.Delete(i);
      Break;
    end;
  end;


//  if MenuList.Count > 0 then // 20080629
//    for I := 0 to MenuList.Count - 1 do
//    begin
//      pg := PTClientGoods(MenuList[I]);
//      if (pg.Grade >= 0) and (pg.Stock = itemserverindex) then
//      begin
//        Dispose(pg);
//        MenuList.Delete(I);
//        if I < g_MenuItemList.Count then
//          g_MenuItemList.Delete(I);
//        if MenuIndex > MenuList.Count - 1 then
//          MenuIndex := MenuList.Count - 1;
//        Break;
//      end;
//    end;
end;

procedure TFrmDlg.DelStorageItem(itemserverindex: Integer);
var
  I: Integer;
  pg: PTClientGoods;
begin

  for i := 0 to DLVSaveItems.Items.Count - 1 do
  begin
    pg := PTClientGoods(DLVSaveItems.Items[I].Data);
    if (pg.Price = itemserverindex) then
    begin
      Dispose(pg);
      DLVSaveItems.Delete(i);
      Break;
    end;
  end;


//  if MenuList.Count > 0 then // 20080629
//    for I := 0 to MenuList.Count - 1 do
//    begin
//      pg := PTClientGoods(MenuList[I]);
//      if (pg.Price = itemserverindex) then
//      begin // 焊包格废牢版款 Price = ItemServerIndex烙.
//        Dispose(pg);
//        MenuList.Delete(I);
//        if I < g_SaveItemList.Count then
//          g_SaveItemList.Delete(I);
//        if MenuIndex > MenuList.Count - 1 then
//          MenuIndex := MenuList.Count - 1;
//        Break;
//      end;
//    end;
end;

procedure TFrmDlg.DMenuCloseClick(Sender: TObject; X, Y: Integer);
begin
  DMenuDlg.visible := False;
end;

procedure ClickNpcLable(Sender : TDMerchatAniButton ; const Command: string);
begin
  if Sender = nil then
    g_SoundManager.DXPlaySound(s_glass_button_click)
  else
  begin
    g_DWinMan.Clicksound(Sender, Sender.Propertites.Sound);
  end;
  if Command <> '' then
  begin
    if pos('@LINK:', UpperCase(Command)) = 1 then
      OpenBrowser(Copy(Command, 7, Length(Command) - 6))
    else
      FrmMain.SendMerchantDlgSelect(g_nCurMerchant, Command);
  end;
end;

procedure TFrmDlg.DMerchantDlgMessageCommandLinkClick(Sender: TObject;
  const Command: string);
begin
  ClickNpcLable(nil,Command);
end;

procedure TFrmDlg.DMerchantDlgMessageGetItemImages(ANode: TMessageNode);
begin
  MerchantMessageGetItemImages(ANode);
end;

procedure TFrmDlg.DMerchantDlgMessageMoveInCommandNode(Sender: TObject;
  ACommandNode: TMessageNode; X, Y: Integer);
begin
  UIMoveInCommandNode(Sender, ACommandNode, X, Y);
end;

procedure TFrmDlg.DMerchantDlgVisibleChange(Sender: TObject);
begin
  if FUILoaded and not DMerchantDlg.visible then
    CloseMDlg(False);
end;

procedure TFrmDlg.DSellDlgDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  actionname: string;
begin
  DSellDlg.DefaultPaint(dsurface);
  with DSellDlg do
  begin
    actionname := '';
    case SpotDlgMode of
      dmSell:
        actionname := '出售: ';
      dmRepair:
        actionname := '修理: ';
      dmStorage:
        actionname := ' 保管物品';
      dmPlayDrink:
        actionname := '请酒';
    end;
//    if actionname <> '' then
//      dsurface.BoldText(actionname + g_sSellPriceStr, clWhite, FontBorderColor,
//        SurfaceX(Left + 8), SurfaceY(Top + 6));

    DTSellTitle.Propertites.Caption.Text := actionname + g_sSellPriceStr;

  end;
end;

procedure TFrmDlg.DSellDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DSellDlgCloseClick(Sender: TObject; X, Y: Integer);
begin
  CloseDSellDlg;
end;

procedure TFrmDlg.DSellDlgSpotClick(Sender: TObject; X, Y: Integer);
var
  temp: TClientItem;
begin
  g_sSellPriceStr := '';
  if not g_boItemMoving then
  begin
    if g_SellDlgItem.Name <> '' then
    begin
      g_SoundManager.ItemClickSound(g_SellDlgItem.S);
      g_boItemMoving := True;
      g_MovingItem.FromIndex := 0; // sell 芒俊辑 唱咳..
      g_MovingItem.Source := msSellItem;
      g_MovingItem.Item := g_SellDlgItem;
      g_SellDlgItem.Name := '';
    end;
  end
  else
  begin
    if g_MovingItem.Source in [msBag, msSellItem] then
    begin
      g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
      if g_SellDlgItem.Name <> '' then
      begin
        temp := g_SellDlgItem;
        g_SellDlgItem := g_MovingItem.Item;
        g_MovingItem.FromIndex := 0;
        g_MovingItem.Source := msSellItem;
        g_MovingItem.Item := temp
      end
      else
      begin
        g_SellDlgItem := g_MovingItem.Item;
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
      end;
      g_boQueryPrice := True;
      g_dwQueryPriceTime := GetTickCount;
    end;
  end;
end;

procedure TFrmDlg.DSellDlgSpotDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  with DSellDlgSpot do
    DrawItem(g_SellDlgItem, dsurface, SurfaceX(Left), SurfaceY(Top), WIDTH,
      Height, TimeTick);
end;

// 卖物品时放物品的那个框框
procedure TFrmDlg.DSellDlgSpotMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if g_SellDlgItem.Name <> '' then
  begin
    if (g_SellDlgItem.MakeIndex = g_MouseItem.MakeIndex) and
      DScreen.ItemHint then
      DScreen.UpdateItemHintPostion(g_Application._CurPos)
    else
    begin
      g_MouseItem := g_SellDlgItem;
      DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
    end;
  end
  else
  begin
    g_MouseItem.Name := '';
    DScreen.ClearHint;
  end;
end;

// 卖物品的确定按钮
procedure TFrmDlg.DSellDlgOkClick(Sender: TObject; X, Y: Integer);
begin
  if (g_SellDlgItem.Name = '') and (g_SellDlgItemSellWait.Name = '') then
    Exit;
  if GetTickCount < LastestClickTime then
    Exit;
  case SpotDlgMode of
    dmSell:
      FrmMain.SendSellItem(g_nCurMerchant, g_SellDlgItem.MakeIndex,
        g_SellDlgItem.Name);
    dmRepair:
      FrmMain.SendRepairItem(g_nCurMerchant, g_SellDlgItem.MakeIndex,
        g_SellDlgItem.Name);
    dmStorage:
      FrmMain.SendStorageItem(g_nCurMerchant, g_SellDlgItem.MakeIndex,
        g_SellDlgItem.Name);
    dmPlayDrink:
      FrmMain.SendPlayDrinkItem(g_nCurMerchant, g_SellDlgItem.MakeIndex,
        g_SellDlgItem.Name);
  end;
  g_SellDlgItemSellWait := g_SellDlgItem;
  g_SellDlgItem.Name := '';
  LastestClickTime := GetTickCount + 500;
  g_sSellPriceStr := '';
end;

procedure TFrmDlg.DSellDlgOkMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.SetMagicKeyDlg(CurKey: Integer);
begin
  DScreen.ClearHint;
  FMagKeyCurKey := CurKey;
  DKeySelDlg.Left := (SCREENWIDTH - DKeySelDlg.WIDTH) div 2;
  DKeySelDlg.Top := (SCREENHEIGHT - DKeySelDlg.Height) div 2;
  HideAllControls;
  DKeySelDlg.ShowModal;
end;

procedure TFrmDlg.SetMagicPage(Page: Integer);
var
  nMagicIndex: Integer;
  nPageMagicCount: Integer;
  I: Integer;
  pMagic: pTClientMagic;
  Index: Integer;
begin
  nPageMagicCount := MaigicCountPage;
  nMagicIndex := nPageMagicCount * Page;
  Index := 0;
  MagicPage := Page;
  for I := nMagicIndex to (nMagicIndex + nPageMagicCount - 1) do
  begin
    if (I >= 0) and (I < g_MagicList.Count) then
      pMagic := g_MagicList[I]
    else
      pMagic := nil;

    SetSkillItemUIData(Index, pMagic);

    Inc(Index);
  end;

  DTMagicPageCount.Propertites.Caption.Text := IntToStr(MagicPage + 1) + '/' +
    IntToStr(((g_MagicList.Count - 1) div nPageMagicCount ) + 1);
end;

procedure TFrmDlg.SetMarketTabIndex(Index: Integer);
begin
  if g_boStallLock then
    Exit;

  ReStall;
  MarketTabIdx := Index;
  DWMarketItems.visible := False;
  DWMarketRItems.visible := False;
  DWMarketPStall.visible := False;
  DWMarketNStall.visible := False;
  DWMarketBuyItem.visible := False;
  DWMarketVList.visible := False;
  DWMarketRList.visible := False;
  DWMarketVStall.visible := False;
  DWMarketPPage.visible := False;
  DWMarketNPage.visible := False;
  DWMarketName.visible := False;
  DWMarketSetName.visible := False;
  DWMarketPutOn.visible := False;
  DWMarketRMyItems.visible := False;
  DWMarketExtGold.visible := False;
  case MarketTabIdx of
    0:
      begin
        DWMarketItems.visible := not ISMarketList;
        DWMarketRItems.visible := not ISMarketList;
        DWMarketPStall.visible := not ISMarketList;
        DWMarketNStall.visible := not ISMarketList;
        DWMarketBuyItem.visible := not ISMarketList;
        DWMarketVList.visible := not ISMarketList;
        DWMarketRList.visible := ISMarketList;
        DWMarketPPage.visible := ISMarketList;
        DWMarketNPage.visible := ISMarketList;
        DWMarketVStall.visible := ISMarketList;
        if not g_boStallListLoaded and (g_MySelf <> nil) then
        begin
          FrmMain.SendMarketGetList;
          MarketListPage := 0;
        end;
      end;
    1:
      begin
        if g_MyMarketName = '' then
          g_MyMarketName := g_MySelf.m_sUserName + '的摊位';
        DWMarketName.Text := g_MyMarketName;
        DWMarketName.visible := True;
        DWMarketSetName.visible := True;
        DWMarketPutOn.visible := True;
        DWMarketItems.visible := True;
        DWMarketRMyItems.visible := True;
        DWMarketExtGold.visible := True;
        if not g_boStallLoaded then
          FrmMain.SendMarketGetItems('');
      end;
    2:
      begin

      end;
  end;
end;

procedure TFrmDlg.ShowMissionDetail(SwitchVisible: Boolean);
begin
  DWMissions.Left := 0;
  DWMissions.Top := 0;
  DBMissionDoing.Tag := 1;
  DBMissionUnDo.Tag := 0;
  if SwitchVisible then
    DWMissions.visible := not DWMissions.visible
  else
    DWMissions.visible := True;
end;

procedure TFrmDlg.UpdateMissionContent;
var
  AContent: String;
begin
  if g_MissionListFocused >= 0 then
  begin
    case DBMissionDoing.Tag of
      0:
        begin
          if g_MissionListFocused < g_Missions.UnDoCount then
          begin
            AContent := g_Missions.UnDo[g_MissionListFocused].Content;
            AContent := StringReplace(AContent, '#MissionID#',
              g_Missions.UnDo[g_MissionListFocused].MissionID, [rfReplaceAll]);
            DMissionContent.Lines.Text := AContent;
          end;
        end;
      1:
        begin
          if g_MissionListFocused < g_Missions.DoingCount then
          begin
            AContent := g_Missions.Doing[g_MissionListFocused].Content;
            AContent := StringReplace(AContent, '#P#',
              IntToStr(g_Missions.Doing[g_MissionListFocused].NeedProgress),
              [rfReplaceAll]);
            AContent := StringReplace(AContent, '#M#',
              IntToStr(g_Missions.Doing[g_MissionListFocused].NeedMax),
              [rfReplaceAll]);
            AContent := StringReplace(AContent, '#MissionID#',
              g_Missions.Doing[g_MissionListFocused].MissionID, [rfReplaceAll]);
            AContent := StringReplace(AContent, '#RecordID#',
              g_Missions.Doing[g_MissionListFocused].RecordID, [rfReplaceAll]);
            DMissionContent.Lines.Text := AContent;
          end;
        end;
    end;
  end;
end;

procedure TFrmDlg.UpdateMissions;
begin
  DMissionContent.Lines.Clear;
  if g_MissionListFocused <> -1 then
  begin
    case DBMissionDoing.Tag of
      0:
        begin
          if g_MissionListFocused > g_Missions.UnDoCount - 1 then
            g_MissionListFocused := g_Missions.UnDoCount - 1;
        end;
      1:
        begin
          if g_MissionListFocused > g_Missions.DoingCount - 1 then
            g_MissionListFocused := g_Missions.DoingCount - 1;
        end;
    end;
    if g_MissionListTopIndex > g_MissionListFocused then
      g_MissionListTopIndex := g_MissionListFocused;
  end;
  UpdateMissionContent;
end;

procedure TFrmDlg.ShowMissionControl(V: Boolean);
begin
  DWMiniMissions.visible := V;
  if V then
  begin
    //FShowMission := True;
    DBMissionSwitchClick(nil, 0, 0);
  end;
end;

procedure TFrmDlg.StartDice(ATag, APoint1, APoint2, APoint3: Integer);
begin
  FDiceTime := GetTickCount;
  FDicePlayCount := 0;
  FDiceAniEnd1 := False;
  FDiceAniEnd2 := False;
  FDiceAniEnd3 := False;
  FDiceID := ATag;
  FDiceCount := 1;
  FDicePoint1 := APoint1;
  FDicePoint2 := APoint2;
  FDicePoint3 := APoint3;
  if FDicePoint2 in [1 .. 6] then
    Inc(FDiceCount);
  if FDicePoint3 in [1 .. 6] then
    Inc(FDiceCount);
  FDiceSended := False;
  FDicePlayCount := 0;
  DWDice.visible := True;
end;

procedure TFrmDlg.DKeySelDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DKeySelDlgVisibleChange(Sender: TObject);
begin
  if DKeySelDlg.Visible then
  begin
    DTSetSkillTips.Propertites.Caption.Text := FSelMagic.sMagicName + '  快捷键盘被设置为.';
  end;
end;

procedure TFrmDlg.DKsIconDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  D := GetMagicIcon(FSelMagic^, FSelMagic.Level,
    FSelMagic.Strengthen, False);
  if D <> nil then
    dsurface.Draw(DKsIcon.SurfaceX(DKsIcon.Left), DKsIcon.SurfaceY(DKsIcon.Top),
      D.ClientRect, D, True);
end;

procedure TFrmDlg.DKsF1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with TDButton(Sender) do
  begin
    if FMagKeyCurKey = Tag then
    begin
      if Propertites.Images <> nil then
      begin
        D := Propertites.Images.Images[Propertites.ImageIndex + 1];
        if D <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      end;
    end;
    if Downed then
    begin
      if Propertites.Images <> nil then
      begin
        D := Propertites.Images.Images[Propertites.ImageIndex];
        if D <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      end;
    end;
  end;
end;

procedure TFrmDlg.DKsOkClick(Sender: TObject; X, Y: Integer);
var
  ANewKey: PPlatfromChr;
  I: Integer;
  AMagic: pTClientMagic;
begin
  if Word(FSelMagic.Key) <> FMagKeyCurKey then
  begin
    ANewKey := PPlatfromChr(FMagKeyCurKey);
    if g_MagicList.Count > 0 then
    begin
      for I := 0 to g_MagicList.Count - 1 do
      begin
        AMagic := pTClientMagic(g_MagicList[I]);
        if AMagic.Key = ANewKey then
        begin
          AMagic.Key := #0;
          FrmMain.SendMagicKeyChange(AMagic.wMagicId, #0);
        end;
      end;
    end;
    FSelMagic.Key := ANewKey;
    FrmMain.SendMagicKeyChange(FSelMagic.wMagicId, ANewKey);
  end;

  UpDataSkillItemData(DSkillItem1);
  UpDataSkillItemData(DSkillItem2);
  UpDataSkillItemData(DSkillItem3);
  UpDataSkillItemData(DSkillItem4);
  UpDataSkillItemData(DSkillItem5);
  UpDataSkillItemData(DSkillItem6);
  DKeySelDlg.visible := False;
end;

procedure TFrmDlg.DKsF1Click(Sender: TObject; X, Y: Integer);
begin
  FMagKeyCurKey := TDButton(Sender).Tag;
end;

procedure TFrmDlg.DBotMiniMapClick(Sender: TObject; X, Y: Integer);
begin
  DScreen.ClearHint;
  OpenMiniMap;
end;

procedure TFrmDlg.DBotGuildClick(Sender: TObject; X, Y: Integer);
begin
  if DGuildDlg.visible then
  begin
    DGuildDlg.visible := False;
  end
  else if GetTickCount > g_dwQueryMsgTick then
  begin
    g_dwQueryMsgTick := GetTickCount + 3000;
    FrmMain.SendShortCut(_SC_OPENGUILDDLG);
  end;
end;

procedure TFrmDlg.DBotHorseClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DBotHorse.TimeTick > 500 then
  begin
    FrmMain.SendShortCut(_SC_SwitchHorse);
    DBotHorse.TimeTick := GetTickCount;
  end;
end;

procedure TFrmDlg.DBotGroupClick(Sender: TObject; X, Y: Integer);
begin
  ToggleShowGroupDlg;
end;

{ ------------------------------------------------------------------------ }

// 弊缝 促捞倔肺弊

{ ------------------------------------------------------------------------ }

procedure TFrmDlg.ToggleShowGroupDlg;
begin
  ReBuildGropuUI;
  DGroupDlg.visible := not DGroupDlg.visible;
end;

procedure TFrmDlg.TTabStateTabChange(Sender: TDControl;
  SourceIndex, Index: Integer);
var
  Tab: TDTab;
begin
  Tab := TDTab(Sender);
  // 技能页面

  if Index = 4 then
  begin
    SetMagicPage(0);
  end
  else if Index = 3 then
  begin
    SetTitlePage(0);
  end;

end;

procedure TFrmDlg.DGroupDlgClick(Sender: TObject; X, Y: Integer);
begin
  g_GroupSelIndex := -1;
  X := X - DGroupDlg.SurfaceX(DGroupDlg.Left);
  Y := Y - DGroupDlg.SurfaceY(DGroupDlg.Top);
  if (X >= 24) and (X <= 236) and
    (((Y >= 114) and (Y <= 220)) or ((Y >= 66) and (Y <= 84))) then
  begin
    if Y <= 84 then
      g_GroupSelIndex := 0
    else
    begin
      if Y <= 134 then
      begin
        if X <= 130 then
          g_GroupSelIndex := 1
        else
          g_GroupSelIndex := 2;
      end
      else if Y <= 156 then
      begin
        if X <= 130 then
          g_GroupSelIndex := 3
        else
          g_GroupSelIndex := 4;
      end
      else if Y <= 178 then
      begin
        if X <= 130 then
          g_GroupSelIndex := 5
        else
          g_GroupSelIndex := 6;
      end
      else if Y <= 199 then
      begin
        if X <= 130 then
          g_GroupSelIndex := 7
        else
          g_GroupSelIndex := 8;
      end
      else if Y <= 220 then
      begin
        if X <= 130 then
          g_GroupSelIndex := 9
        else
          g_GroupSelIndex := 10;
      end;
    end;
    g_SoundManager.DXPlaySound(s_norm_button_click);
  end;
end;

procedure TFrmDlg.DGroupDlgDblClick(Sender: TObject);
begin
  if g_GroupSelIndex <> -1 then
  begin
    PlayScene.SetChatText('/' + g_GroupMembers[g_GroupSelIndex].UserName + ' ');
    SetDFocus(DEChat);
    DEChat.SelStart := Length(DEChat.Text);
    DEChat.SelLength := 0;
  end;
end;

procedure TFrmDlg.DGroupDlgDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
const
  GRP_COLOR: array [Boolean] of TColor = (clWhite, clRed);
var
  D: TAsphyreLockableTexture;
  T: TAsphyreLockableTexture;
  NameT: TuTexture;
  I, X, Y: Integer;
begin
  with DGroupDlg do
  begin
    X := SurfaceX(Left);
    Y := SurfaceY(Top);
    if Propertites.Images <> nil then
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(X, Y, D.ClientRect, D, True);
    end;
    if g_GroupMembers.Count > 0 then
    begin
      NameT := Textures.ObjectName(dsurface, g_GroupMembers[0].UserName);
      if NameT <> nil then
        NameT.Draw(dsurface, X + 26, Y + 68, GRP_COLOR[g_GroupSelIndex = 0]);
      for I := 1 to g_GroupMembers.Count - 1 do
      begin
        NameT := Textures.ObjectName(dsurface, g_GroupMembers[I].UserName);
        if NameT <> nil then
        begin
          case I of
            1:
              NameT.Draw(dsurface, X + 26, Y + 118,
                GRP_COLOR[g_GroupSelIndex = I]);
            2:
              NameT.Draw(dsurface, X + 136, Y + 118,
                GRP_COLOR[g_GroupSelIndex = I]);
            3:
              NameT.Draw(dsurface, X + 26, Y + 140,
                GRP_COLOR[g_GroupSelIndex = I]);
            4:
              NameT.Draw(dsurface, X + 136, Y + 140,
                GRP_COLOR[g_GroupSelIndex = I]);
            5:
              NameT.Draw(dsurface, X + 26, Y + 162,
                GRP_COLOR[g_GroupSelIndex = I]);
            6:
              NameT.Draw(dsurface, X + 136, Y + 162,
                GRP_COLOR[g_GroupSelIndex = I]);
            7:
              NameT.Draw(dsurface, X + 26, Y + 184,
                GRP_COLOR[g_GroupSelIndex = I]);
            8:
              NameT.Draw(dsurface, X + 136, Y + 184,
                GRP_COLOR[g_GroupSelIndex = I]);
            9:
              NameT.Draw(dsurface, X + 26, Y + 206,
                GRP_COLOR[g_GroupSelIndex = I]);
            10:
              NameT.Draw(dsurface, X + 136, Y + 206,
                GRP_COLOR[g_GroupSelIndex = I]);
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DGrpDlgCloseClick(Sender: TObject; X, Y: Integer);
begin
  DGroupDlg.visible := False;
end;

procedure TFrmDlg.DGrpAllowGroupClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwChangeGroupModeTick + 500 then
  begin
    g_boAllowGroup := not g_boAllowGroup;
    g_dwChangeGroupModeTick := GetTickCount;
    FrmMain.SendChangeState(STATE_ALLOWGROUP, g_boAllowGroup);
  end;
  SetAllowGroup(g_boAllowGroup);
end;

procedure TFrmDlg.DRecruitMemberClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwChangeRecruitMemberModeTick + 500 then
  begin
    g_boRecruitMember := not g_boRecruitMember;
    g_dwChangeRecruitMemberModeTick := GetTickCount;
    FrmMain.SendChangeState(STATE_Recruit, g_boRecruitMember);
  end;
  SetRecruitMember(g_boRecruitMember);
end;

procedure TFrmDlg.DGrpAddMemClick(Sender: TObject; X, Y: Integer);
var
  Who: string;
begin

  g_Application.AddMessageDialog('输入想加入编组人物名称.', [mbOK, mbCancel, mbAbort],
    procedure(AResult: Integer)begin if AResult = mrOK then begin Who :=
    Trim(DlgEditText); if (GetTickCount > g_dwChangeGroupModeTick) and
    (Who <> '') then begin g_dwChangeGroupModeTick := GetTickCount + 5000;
    if g_GroupMembers.Count = 0 then FrmMain.SendCreateGroup(Trim(DlgEditText))
  else if g_ISGroupMaster then FrmMain.SendAddGroupMember(Trim(DlgEditText));
    DScreen.AddChatBoardString('已发送组队邀请...', '', clWhite, clBlue); end;
  end; end);
end;

procedure TFrmDlg.DGrpDelMemClick(Sender: TObject; X, Y: Integer);
var
  Who: string;
begin
  if g_ISGroupMaster and (GetTickCount > g_dwChangeGroupModeTick) and
    (g_GroupMembers.Count > 0) and (g_GroupSelIndex > 0) then
  begin
    if g_GroupMembers[g_GroupSelIndex] <> nil then
    begin
      Who := Trim(g_GroupMembers[g_GroupSelIndex].UserName);
      if (Who <> '') and (DMessageDlg('确定将玩家【' + Who + '】踢出队伍吗？',
        [mbOK, mbCancel]) = mrOK) then
      begin
        g_dwChangeGroupModeTick := GetTickCount + 5000;
        FrmMain.SendDelGroupMember(Who);
      end;
    end;
  end;
end;

procedure TFrmDlg.DGrpDismissClick(Sender: TObject; X, Y: Integer);
var
  msg: String;
begin
  if (GetTickCount > g_dwChangeGroupModeTick) and
    (g_GroupMembers.Count > 0) then
  begin
    msg := '确定退出队伍吗？';
    if Sender = DGrpDismiss then
      msg := '确定解散队伍吗？';
    if DMessageDlg(msg, [mbOK, mbCancel]) = mrOK then
    begin
      g_dwChangeGroupModeTick := GetTickCount + 5000;
      FrmMain.SendLeaveGroupMember;
    end;
  end;
end;

procedure TFrmDlg.DBotLogoutClick(Sender: TObject; X, Y: Integer);
begin
  DScreen.ClearHint;
  // 强行退出
  g_dwLatestStruckTick := GetTickCount() + 10001;
  g_dwLatestMagicTick := GetTickCount() + 10001;
  g_dwLatestHitTick := GetTickCount() + 10001;
  //
  if (GetTickCount - g_dwLatestStruckTick > 10000) and
    (GetTickCount - g_dwLatestMagicTick > 10000) and
    (GetTickCount - g_dwLatestHitTick > 10000) or (g_MySelf.m_boDeath) then
  begin
    FrmMain.AppLogOut;
  end
  else
    FrmMain.AddChatBoardString('攻击状态不能退出游戏.', clYellow, clRed);
end;

procedure TFrmDlg.DBotChatHistoryClick(Sender: TObject; X, Y: Integer);
begin
  UpdateChatHisSroll;
  DWChatHistory.visible := not DWChatHistory.visible;
  DWChatHistory.Left := (SCREENWIDTH - DWChatHistory.WIDTH) div 2;
  DWChatHistory.Top := SCREENHEIGHT - DBottom.Height - DWChatHistory.Height;
end;

procedure TFrmDlg.DBotDealClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > DBotDeal.TimeTick then
  begin
    DBotDeal.TimeTick := GetTickCount + 3000;
    FrmMain.SendShortCut(_SC_DEALTRY);
  end;
end;

procedure TFrmDlg.DBotExitClick(Sender: TObject; X, Y: Integer);
begin
  DScreen.ClearHint;
  // 强行退出
  g_dwLatestStruckTick := GetTickCount() + 10001;
  g_dwLatestMagicTick := GetTickCount() + 10001;
  g_dwLatestHitTick := GetTickCount() + 10001;
  //
  if (GetTickCount - g_dwLatestStruckTick > 10000) and
    (GetTickCount - g_dwLatestMagicTick > 10000) and
    (GetTickCount - g_dwLatestHitTick > 10000) or (g_MySelf.m_boDeath) then
  begin
    FrmMain.Close
  end
  else
    FrmMain.AddChatBoardString('攻击状态不能退出游戏.', clYellow, clRed);
end;

procedure TFrmDlg.DBotPlusAbilClick(Sender: TObject; X, Y: Integer);
begin
  OpenAdjustAbility;
end;

{ ****************************************************************************** }
// 打开交易对话框
procedure TFrmDlg.OpenDealDlg;
begin
  g_boRDealOK := False;
  g_boDealOK := False;

  DDealRemoteDlg.Left := SCREENWIDTH - 236 - 100;
  DDealRemoteDlg.Top := 0;
  DDealDlg.Left := SCREENWIDTH - 236 - 100;
  DDealDlg.Top := DDealRemoteDlg.Height - 15;
  DItemBag.Left := 0; // 475;
  DItemBag.Top := 0;
  DItemBag.visible := True;
  DDealDlg.visible := True;
  DDealRemoteDlg.visible := True;

  FillChar(g_DealItems[0], SizeOf(g_DealItems), #0);
  FillChar(g_DealRemoteItems[0], SizeOf(g_DealRemoteItems), #0);
  g_nDealGold := 0;
  g_nDealRemoteGold := 0;
  g_boDealEnd := False;
  ArrangeItemBag;
end;

procedure TFrmDlg.OpenDragonBox;
begin
  DBoxs.SetImgIndex(g_WMain3Images, 510);
  DBoxs.Left := (SCREENWIDTH - DBoxs.WIDTH) DIV 2;
  DBoxs.Top := (SCREENHEIGHT - DBoxs.Height) DIV 2;
  DBoxs.visible := True; // 宝箱显示界面
  g_BoxShape := 6;
  DBoxsTautology.visible := True; // 点击多次转动按钮显示
  g_BoxsCircleNum := 0; // 初始化转动圈数
  g_boBoxsMiddleItems := True; // 初始化物品为中间
  g_BoxsShowPosition := 8;
  g_BoxsFirstMove := False; // 初始化第1次转动
  g_BoxsMoveDegree := 0; // 初始化 转盘次数
  ShowBoxsGird(True); // 显示宝箱格
  BoxsRandomImg;
end;

procedure TFrmDlg.OpenDragonBoxFail;
begin
  g_boPutBoxsKey := False;
  DBoxs.visible := False;
  ShowBoxsGird(False); // 显示宝箱格
  g_nBoxsImg := 0;
  g_BoxsShowPosition := -1;
  AddItemBag(g_BoxsTempKeyItems);
  // 返回包裹 钥匙
  AddItemBag(g_EatingItem);
  // 返回包裹 宝箱
  g_EatingItem.Name := '';
end;

{ ****************************************************************************** }
// 打开挑战对话框
procedure TFrmDlg.OpenChallengeDlg;
// var
// d: TAsphyreLockableTexture;
begin
  DWChallenge.Left := 544;
  DWChallenge.Top := 0;
  DItemBag.Left := 0; // 475;
  DItemBag.Top := 0;
  DItemBag.visible := True;
  DWChallenge.visible := True;

  FillChar(g_ChallengeItems[0], SizeOf(g_ChallengeItems), #0);
  FillChar(g_ChallengeRemoteItems[0], SizeOf(g_ChallengeRemoteItems), #0);
  g_nChallengeGold := 0;
  g_nChallengeRemoteGold := 0;
  g_nChallengeDiamond := 0;
  g_nChallengeRemoteDiamond := 0;
  g_boChallengeEnd := False;
  ArrangeItemBag;
end;

procedure TFrmDlg.CloseChallengeDlg;
begin
  DWChallenge.visible := False;
  ArrangeItemBag;
end;

{ ****************************************************************************** }
procedure TFrmDlg.CloseDealDlg;
begin
  DDealDlg.visible := False;
  DDealRemoteDlg.visible := False;

  // 酒捞袍 啊规俊 儡惑捞 乐绰瘤 八荤
  ArrangeItemBag;
end;

procedure TFrmDlg.DDealOkClick(Sender: TObject; X, Y: Integer);
begin
  if g_boDealOK then
    Exit;

  if GetTickCount > g_dwDealActionTick then
  begin
    FrmMain.SendDealEnd;
    g_dwDealActionTick := GetTickCount + 4000;
    g_boDealEnd := True;
    if g_boItemMoving then
    begin
      if g_MovingItem.Source = msDealItem then
      begin
        AddDealItem(g_MovingItem.Item);
        g_boItemMoving := False;
        g_MovingItem.Item.Name := '';
      end;
    end;
  end;
end;

procedure TFrmDlg.DDealCloseClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwDealActionTick then
  begin
    CloseDealDlg;
    FrmMain.SendCancelDeal;
  end;
end;

procedure TFrmDlg.DDealRemoteDlgDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
begin
  with DDealRemoteDlg do
  begin
    if Propertites.Images <> nil then
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;
    dsurface.TextOut(GetGoldStr(g_nDealRemoteGold), clWhite,
      SurfaceX(Left + 68), SurfaceY(Top + 196 - 64));
    if g_boRDealOK then
      dsurface.BoldText('(已确认)', clRed, FontBorderColor, SurfaceX(Left + 154),
        SurfaceY(Top + 132))
    else
      dsurface.BoldText('(未确认)', clLime, FontBorderColor, SurfaceX(Left + 154),
        SurfaceY(Top + 132));
    ATexture := FontManager.Default.TextOut(g_sDealWho);
    if ATexture <> nil then
      dsurface.DrawBoldText(SurfaceX(Left + 59 + (106 - ATexture.WIDTH) div 2),
        SurfaceY(Top + 6), ATexture, clWhite, FontBorderColor);
  end;
end;

procedure TFrmDlg.DDealDlgDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
begin
  with DDealDlg do
  begin
    if Propertites.Images <> nil then
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;
    dsurface.TextOut(GetGoldStr(g_nDealGold), clWhite, SurfaceX(Left + 68),
      SurfaceY(Top + 196 - 62));
{$IFDEF UIDesinging}Exit; {$ENDIF}
    ATexture := FontManager.Default.TextOut(FrmMain.CharName);
    if ATexture <> nil then
      dsurface.DrawBoldText(SurfaceX(Left + 59 + (106 - ATexture.WIDTH) div 2),
        SurfaceY(Top + 3) + 4, ATexture, clWhite, FontBorderColor);
  end;
end;

procedure TFrmDlg.DDealDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DealItemReturnBag(mitem: TClientItem);
begin
  if not g_boDealEnd then
  begin
    g_DealDlgItem := mitem;
    FrmMain.SendDelDealItem(g_DealDlgItem);
    g_dwDealActionTick := GetTickCount + 4000;
  end;
end;

// 挑战物品返回包裹 20080705
procedure TFrmDlg.ChallengeItemReturnBag(mitem: TClientItem);
begin
  if not g_boChallengeEnd then
  begin
    g_ChallengeDlgItem := mitem;
    FrmMain.SendDelChallengeItem(g_ChallengeDlgItem);
    g_dwChallengeActionTick := GetTickCount + 4000;
  end;
end;

// 元宝寄售返回包裹 20080316
procedure TFrmDlg.SellOffItemReturnBag(mitem: TClientItem);
begin
  g_SellOffDlgItem := mitem;
  FrmMain.SendDelSellOffItem(g_SellOffDlgItem);
end;

procedure TFrmDlg.DDGridGridSelect(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
  Idx: Integer;
begin
  if not g_boDealEnd and (GetTickCount > g_dwDealActionTick) then
  begin
    if not g_boItemMoving then
    begin
      Idx := ACol + ARow * DDGrid.ColCount;
      if Idx in [0 .. 9] then
      begin
        if g_DealItems[Idx].Name <> '' then
        begin
          g_boItemMoving := True;
          g_MovingItem.FromIndex := Idx;
          g_MovingItem.Source := msDealItem;
          g_MovingItem.Item := g_DealItems[Idx];
          g_DealItems[Idx].Name := '';
          g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
        end;
      end;
    end
    else
    begin
      case g_MovingItem.Source of
        msGold, msDealGold:
          DDGoldClick(Self, 0, 0);
        msBag, msDealItem:
          begin
            g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
            g_boItemMoving := False;
            if g_MovingItem.Source = msBag then
            begin
              g_DealDlgItem := g_MovingItem.Item;
              FrmMain.SendAddDealItem(g_DealDlgItem);
              g_dwDealActionTick := GetTickCount + 4000;
            end
            else
              AddDealItem(g_MovingItem.Item);
            g_MovingItem.Item.Name := '';
          end;
      end;
    end;
    ArrangeItemBag;
  end;
end;

procedure TFrmDlg.DDressUS1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ax, bbx, bby, ay, sex, nColor: Integer;
begin
  with DDressUS1 do
  begin
    bbx := Left + Propertites.OffsetX;
    bby := Top + Propertites.OffsetY;
    sex := GenderFeature(UserState1.Feature);
    if UserState1.UseItems[U_DRESS].Name <> '' then
    begin
      D := GetDressStateItemImgXY(UserState1.job, sex,
        UserState1.UseItems[U_DRESS], ax, ay);

      if D <> nil then
      begin
        nColor := GetRGB(UserState1.BodyBlendColor);
        if nColor > 0 then
        begin
          dsurface.DrawColor(SurfaceX(bbx + ax), SurfaceY(bby + ay), D, nColor);
        end
        else
        begin
          dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
            D.ClientRect, D, True);
        end;
      end;

      if UserDressInnerEffect <> nil then
        UserDressInnerEffect.Draw(dsurface, SurfaceX(bbx), SurfaceY(bby))
      else
        DressStateDrawBlend(UserState1.UseItems[U_DRESS].S.Shape,
          UserState1.UseItems[U_DRESS].AniCount, TimeTick, dsurface,
          SurfaceX(bbx), SurfaceY(bby));
    end;
  end;
end;

procedure TFrmDlg.DDGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
var
  Idx: Integer;
begin
  Idx := ACol + ARow * DDGrid.ColCount;
  if Idx in [0 .. 9] then
  begin
    with DDGrid do
      DrawItem(g_DealItems[Idx], dsurface, SurfaceX(Rect.Left),
        SurfaceY(Rect.Top), ColWidth, RowHeight, TimeTick);
  end;
end;

procedure TFrmDlg.DDGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
  Idx: Integer;
  tmpItem: TClientItem;
begin
  Idx := ACol + ARow * DDGrid.ColCount;
  if Idx in [0 .. 9] then
  begin
    tmpItem := g_DealItems[Idx];
    if tmpItem.Name <> '' then
    begin
      if (tmpItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := tmpItem;
        DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
      end;
    end
    else
    begin
      g_MouseItem.Name := '';
      DScreen.ClearHint;
    end;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DDRGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
var
  Idx: Integer;
begin
  Idx := ACol + ARow * DDRGrid.ColCount;
  if Idx in [0 .. 9] then
  begin
    with DDRGrid do
      DrawItem(g_DealRemoteItems[Idx], dsurface, SurfaceX(Rect.Left),
        SurfaceY(Rect.Top), ColWidth, RowHeight, TimeTick);
  end;
end;

procedure TFrmDlg.DDRGridGridMouseMove(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
  Idx: Integer;
  tmpItem: TClientItem;
begin
  Idx := ACol + ARow * DDRGrid.ColCount;
  if Idx in [0 .. 19] then
  begin
    tmpItem := g_DealRemoteItems[Idx];
    if tmpItem.Name <> '' then
    begin
      if (tmpItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := tmpItem;
        DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
      end;
    end
    else
    begin
      g_MouseItem.Name := '';
      DScreen.ClearHint;
    end;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DealZeroGold;
begin
  if not g_boDealEnd and (g_nDealGold > 0) then
  begin
    g_dwDealActionTick := GetTickCount + 4000;
    FrmMain.SendChangeDealGold(0);
  end;
end;

procedure TFrmDlg.DDGoldClick(Sender: TObject; X, Y: Integer);
var
  DGold: Integer;
  valstr: string;
begin
  if g_MySelf = nil then
    Exit;
  if not g_boDealEnd and (GetTickCount > g_dwDealActionTick) then
  begin
    if not g_boItemMoving then
    begin
      if g_nDealGold > 0 then
      begin
        g_SoundManager.DXPlaySound(s_money);
        g_boItemMoving := True;
        g_MovingItem.FromIndex := 0;
        g_MovingItem.Source := msDealGold;
        g_MovingItem.Item.Name := g_sGoldName;
      end;
    end
    else
    begin
      if g_MovingItem.Source in [msGold, msDealGold] then
      begin
        if (g_MovingItem.Source = msGold) then
        begin
          if g_MovingItem.Item.Name = g_sGoldName then
          begin

            g_boItemMoving := False;
            g_MovingItem.Item.Name := '';
            DMessageDlg('请输入 ' + g_sGoldName + ' 数量', [mbOK, mbAbort]);
            GetValidStrVal(DlgEditText, valstr, [' ']);
            DGold := Str_ToInt(valstr, 0);
            if (DGold <= (g_nDealGold + g_nGold)) and (DGold > 0) then
            begin
              FrmMain.SendChangeDealGold(DGold);
              g_dwDealActionTick := GetTickCount + 4000;
            end;
          end;
        end;
        g_boItemMoving := False;
        g_MovingItem.Item.Name := '';
      end;
    end;
  end;
end;

procedure TFrmDlg.DUserState1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);

  function _X(V: Integer; b: Boolean): Integer;
  begin
    if b then
      Result := V
    else
      Result := V + 2;
  end;

  function _C(b: Boolean): TColor;
  begin
    if b then
      Result := $A8D6E8
    else
      Result := $738BA1;
  end;

var
  pgidx, bbx, bby, Idx, ax, ay, sex, hair, ARow: Integer;
  D: TAsphyreLockableTexture;
  rc: TRect;
  ATexture: TuTexture;
  nColor: Integer;
begin
  with DUserState1 do
  begin
    if Propertites.Images <> nil then
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;
  end;

  (*
    with DUserState1 do
    begin
    if Propertites.Images <> nil then
    begin
    D := Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
    dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;
    if g_DWinMan.StateWinType <> wk195 then
    begin

    ATexture := Textures.ObjectName(dsurface, UserState1.UserName);
    if ATexture <> nil then
    ATexture.Draw(dsurface, SurfaceX(Left + 122 - ATexture.WIDTH div 2),
    SurfaceY(Top + 20), UserState1.NAMECOLOR);
    case 0 of
    0:
    begin
    hair := HAIRfeature(UserState1.Feature);
    sex := hair mod 2;
    if g_DWinMan.StateWinType = wk176 then
    begin
    pgidx := 376;
    if sex = 1 then
    pgidx := 377;
    end
    else
    begin
    pgidx := 29;
    if sex = 1 then
    pgidx := 30;
    end;

    bbx := Left + 38;
    bby := Top + 52;

    if g_DWinMan.StateWinType = wk176 then
    D := g_WMainImages.Images[pgidx]
    else
    D := g_WMain3Images.Images[pgidx];

    if D <> nil then
    dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), D.ClientRect,
    D, True);

    ATexture := Textures.ObjectName(dsurface, UserState1.GuildName + ' '
    + UserState1.GuildRankName);
    if ATexture <> nil then
    ATexture.Draw(dsurface, SurfaceX(Left + 39), SurfaceY(Top + 51),
    clSilver);
    bbx := Left + 31;
    bby := Top + 96;
    // 自己人物发型
    D := GetHumInnerHairImg(UserState1.job, sex, hair, ax, ay);
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    if UserState1.UseItems[U_DRESS].Name <> '' then
    begin
    D := GetDressStateItemImgXY(UserState1.job, sex,
    UserState1.UseItems[U_DRESS], ax, ay);

    if D <> nil then
    begin
    nColor := GetRGB(UserState1.BodyBlendColor);
    if nColor > 0 then
    begin
    dsurface.DrawColor(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D, nColor);
    end
    else
    begin
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    end;
    end;

    if g_MyDressInnerEff <> nil then
    g_MyDressInnerEff.Draw(dsurface, SurfaceX(bbx), SurfaceY(bby))
    else
    DressStateDrawBlend(UserState1.UseItems[U_DRESS].S.Shape,
    UserState1.UseItems[U_DRESS].AniCount, TimeTick, dsurface,
    SurfaceX(bbx), SurfaceY(bby));
    end;

    if UserState1.UseItems[U_WEAPON].Name <> '' then
    begin
    Idx := UserState1.UseItems[U_WEAPON].Looks;
    D := GetStateItemImgXY(Idx, ax, ay);

    if D <> nil then
    begin
    nColor := GetRGB(UserState1.WeaponBlendColor);
    if nColor > 0 then
    begin
    dsurface.DrawColor(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D, nColor);
    end
    else
    begin
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    end;
    end;

    if g_MyWeponInnerEff <> nil then
    g_MyWeponInnerEff.Draw(dsurface, SurfaceX(bbx), SurfaceY(bby))
    else
    WeponStateDrawBlend(UserState1.UseItems[U_WEAPON].S.Shape,
    UserState1.UseItems[U_WEAPON].AniCount, TimeTick, dsurface,
    SurfaceX(bbx), SurfaceY(bby));
    end;
    if UserState1.UseItems[U_SHIED].Name <> '' then
    begin
    Idx := UserState1.UseItems[U_SHIED].Looks;
    D := GetStateItemImgXY(Idx, ax, ay);
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    ShieldDrawBlend(UserState1.UseItems[U_SHIED].S.Shape,
    UserState1.UseItems[U_SHIED].AniCount, TimeTick, dsurface,
    SurfaceX(bbx), SurfaceY(bby));
    end;
    // 斗笠 20080417
    if UserState1.UseItems[U_ZHULI].Name <> '' then
    begin
    Idx := UserState1.UseItems[U_ZHULI].Looks;
    if Idx >= 0 then
    begin
    D := GetStateItemImgXY(Idx, ax, ay);
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    end;
    end
    else if UserState1.UseItems[U_HELMET].Name <> '' then
    begin
    Idx := UserState1.UseItems[U_HELMET].Looks;
    if Idx >= 0 then
    begin
    D := GetStateItemImgXY(Idx, ax, ay);
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    end;
    end;
    end;
    1:
    begin
    bbx := Left + 109;
    bby := Top;
    dsurface.BoldText(IntToStr(UserState1.m_Abil.ACMin) + '-' +
    IntToStr(UserState1.m_Abil.ACMax), clSilver, FontBorderColor, bbx,
    bby + 99);
    dsurface.BoldText(IntToStr(UserState1.m_Abil.MACMin) + '-' +
    IntToStr(UserState1.m_Abil.MACMax), clSilver, FontBorderColor,
    bbx, bby + 119);
    dsurface.BoldText(IntToStr(UserState1.m_Abil.DCMin) + '-' +
    IntToStr(UserState1.m_Abil.DCMax), clSilver, FontBorderColor, bbx,
    bby + 139);
    dsurface.BoldText(IntToStr(UserState1.m_Abil.MCMin) + '-' +
    IntToStr(UserState1.m_Abil.MCMax), clSilver, FontBorderColor, bbx,
    bby + 159);
    dsurface.BoldText(IntToStr(UserState1.m_Abil.SCMin) + '-' +
    IntToStr(UserState1.m_Abil.SCMax), clSilver, FontBorderColor, bbx,
    bby + 179);
    dsurface.BoldText(IntToStr(UserState1.m_Abil.HP) + '/' +
    IntToStr(UserState1.m_Abil.MaxHP), clSilver, FontBorderColor, bbx,
    bby + 199);
    dsurface.BoldText(IntToStr(UserState1.m_Abil.MP) + '/' +
    IntToStr(UserState1.m_Abil.MaxMP), clSilver, FontBorderColor, bbx,
    bby + 219);
    end;
    end;
    end
    else
    begin
    { .$ELSE }
    // D := g_77Images.Images[180 + USStatePage];
    if D <> nil then
    dsurface.Draw(SurfaceX(Left) + 6, SurfaceY(Top) + 126, D, True);

    case 0 of
    0:
    begin
    hair := HAIRfeature(UserState1.Feature);
    sex := hair mod 2;
    case UserState1.job of
    _JOB_ARCHER:
    begin
    pgidx := 234;
    if sex = 1 then
    pgidx := 235;
    end
    else
    begin
    pgidx := 258;
    if sex = 1 then
    pgidx := 259;
    end;
    end;
    bbx := Left + 34;
    bby := Top + 126;
    D := g_77Images.Images[pgidx];
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), D.ClientRect,
    D, True);

    bbx := bbx + 52;
    bby := bby + 78;
    D := GetHumInnerHairImg(UserState1.job, sex, hair, ax, ay);
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    if UserState1.UseItems[U_DRESS].Name <> '' then
    begin
    D := GetDressStateItemImgXY(UserState1.job, sex,
    UserState1.UseItems[U_DRESS], ax, ay);

    if D <> nil then
    begin
    nColor := GetRGB(UserState1.BodyBlendColor);
    if nColor > 0 then
    begin
    dsurface.DrawColor(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D, nColor);
    end
    else
    begin
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    end;
    end;

    if UserDressInnerEffect <> nil then
    UserDressInnerEffect.Draw(dsurface, SurfaceX(bbx),
    SurfaceY(bby))
    else
    DressStateDrawBlend(UserState1.UseItems[U_DRESS].S.Shape,
    UserState1.UseItems[U_DRESS].AniCount, TimeTick, dsurface,
    SurfaceX(bbx), SurfaceY(bby));
    end;
    if UserState1.UseItems[U_WEAPON].Name <> '' then
    begin
    Idx := UserState1.UseItems[U_WEAPON].Looks;
    D := GetStateItemImgXY(Idx, ax, ay);
    if D <> nil then
    begin
    nColor := GetRGB(UserState1.WeaponBlendColor);
    if nColor > 0 then
    begin
    dsurface.DrawColor(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D, nColor);
    end
    else
    begin
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    end;
    end;

    if UserWeponInnerEffect <> nil then
    UserWeponInnerEffect.Draw(dsurface, SurfaceX(bbx),
    SurfaceY(bby))
    else
    WeponStateDrawBlend(UserState1.UseItems[U_WEAPON].S.Shape,
    UserState1.UseItems[U_WEAPON].AniCount, TimeTick, dsurface,
    SurfaceX(bbx), SurfaceY(bby));
    end;
    if UserState1.UseItems[U_SHIED].Name <> '' then
    begin
    Idx := UserState1.UseItems[U_SHIED].Looks;
    D := GetStateItemImgXY(Idx, ax, ay);
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    ShieldDrawBlend(UserState1.UseItems[U_SHIED].S.Shape,
    UserState1.UseItems[U_SHIED].AniCount, TimeTick, dsurface,
    SurfaceX(bbx), SurfaceY(bby));
    end;
    // 斗笠
    if UserState1.UseItems[U_ZHULI].Name <> '' then
    begin
    Idx := UserState1.UseItems[U_ZHULI].Looks;
    if Idx >= 0 then
    begin
    D := GetStateItemImgXY(Idx, ax, ay);
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    end;
    end
    else if UserState1.UseItems[U_HELMET].Name <> '' then
    begin
    Idx := UserState1.UseItems[U_HELMET].Looks;
    if Idx >= 0 then
    begin
    D := GetStateItemImgXY(Idx, ax, ay);
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    end;
    if Idx = 1685 then
    begin
    D := g_WMainImages.Images[g_ItemFlash + 620];
    if D <> nil then
    dsurface.DrawBlend(DHelmetUS1.SurfaceX(DHelmetUS1.Left - 21 +
    15), DHelmetUS1.SurfaceY(DHelmetUS1.Top - 23 + 15), D, 1);
    end;
    end;
    end;
    1:
    begin
    bbx := Left + 34;
    bby := Top + 126;
    D := g_77Images.Images[261];
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), D.ClientRect,
    D, True);

    bbx := bbx + 36;
    bby := bby + 10;
    ARow := 2;
    dsurface.BoldText('防御 ' + IntToStr(UserState1.m_Abil.ACMin) + '-' +
    IntToStr(UserState1.m_Abil.ACMax), clSilver, FontBorderColor, bbx,
    bby + 14 * ARow);
    Inc(ARow);
    dsurface.BoldText('魔防 ' + IntToStr(UserState1.m_Abil.MACMin) + '-' +
    IntToStr(UserState1.m_Abil.MACMax), clSilver, FontBorderColor,
    bbx, bby + 14 * ARow);
    Inc(ARow);
    dsurface.BoldText('攻击 ' + IntToStr(UserState1.m_Abil.DCMin) + '-' +
    IntToStr(UserState1.m_Abil.DCMax), clSilver, FontBorderColor, bbx,
    bby + 14 * ARow);
    Inc(ARow);
    dsurface.BoldText('魔法 ' + IntToStr(UserState1.m_Abil.MCMin) + '-' +
    IntToStr(UserState1.m_Abil.MCMax), clSilver, FontBorderColor, bbx,
    bby + 14 * ARow);
    Inc(ARow);
    dsurface.BoldText('道术 ' + IntToStr(UserState1.m_Abil.SCMin) + '-' +
    IntToStr(UserState1.m_Abil.SCMax), clSilver, FontBorderColor, bbx,
    bby + 14 * ARow);
    Inc(ARow);
    if cjARCHER in g_ServerJobs then
    begin
    dsurface.BoldText('箭术 ' + IntToStr(UserState1.m_Abil.TCMin) + '-'
    + IntToStr(UserState1.m_Abil.TCMax), clSilver, FontBorderColor,
    bbx, bby + 14 * ARow);
    Inc(ARow);
    end;
    if cjCIK in g_ServerJobs then
    begin
    dsurface.BoldText('刺术 ' + IntToStr(UserState1.m_Abil.PCMin) + '-'
    + IntToStr(UserState1.m_Abil.PCMax), clSilver, FontBorderColor,
    bbx, bby + 14 * ARow);
    Inc(ARow);
    end;
    if cjShaman in g_ServerJobs then
    begin
    dsurface.BoldText('武术 ' + IntToStr(UserState1.m_Abil.WCMin) + '-'
    + IntToStr(UserState1.m_Abil.WCMax), clSilver, FontBorderColor,
    bbx, bby + 14 * ARow);
    Inc(ARow);
    end;
    dsurface.BoldText
    ('准确 ' + IntToStr(UserState1.m_SubAbility.HitPoint), clSilver,
    FontBorderColor, bbx, bby + 14 * ARow);
    Inc(ARow);
    dsurface.BoldText
    ('敏捷 ' + IntToStr(UserState1.m_SubAbility.SpeedPoint), clSilver,
    FontBorderColor, bbx, bby + 14 * ARow);

    bbx := bbx + 116;
    dsurface.BoldText
    ('魔法躲避 ' + IntToStr(UserState1.m_SubAbility.AntiMagic) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 2);
    dsurface.BoldText
    ('毒物躲避 ' + IntToStr(UserState1.m_SubAbility.AntiPoison) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 3);
    dsurface.BoldText
    ('中毒恢复 ' + IntToStr(UserState1.m_SubAbility.PoisonRecover) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 4);
    dsurface.BoldText
    ('体力恢复 ' + IntToStr(UserState1.m_SubAbility.HealthRecover) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 5);
    dsurface.BoldText
    ('魔法恢复 ' + IntToStr(UserState1.m_SubAbility.SpellRecover) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 6);

    dsurface.BoldText
    ('吸收伤害 ' + IntToStr(UserState1.m_SubAbility.Absorbing) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 7);
    dsurface.BoldText
    ('伤害反弹 ' + IntToStr(UserState1.m_SubAbility.Rebound) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 8);
    dsurface.BoldText
    ('伤害加成 ' + IntToStr(UserState1.m_SubAbility.AttackAdd) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 9);
    dsurface.BoldText
    ('致命一击 ' + IntToStr(UserState1.m_SubAbility.PunchHit) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 10);
    dsurface.BoldText
    ('会心一击 ' + IntToStr(UserState1.m_SubAbility.CriticalHit) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 11);
    dsurface.BoldText('经验加成 ' + IntToStr(UserState1.m_SubAbility.ExpAdd)
    + '%', clSilver, FontBorderColor, bbx, bby + 14 * 12);
    dsurface.BoldText
    ('物品爆率加成 ' + IntToStr(UserState1.m_SubAbility.ItemAdd) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 13);
    dsurface.BoldText
    ('金币爆率加成 ' + IntToStr(UserState1.m_SubAbility.GoldAdd) + '%',
    clSilver, FontBorderColor, bbx, bby + 14 * 14);

    if ClientConf.boMixedAbility then
    begin
    dsurface.BoldText('战力 ' + IntToStr(UserMixedAbility), clFuchsia,
    FontBorderColor, Left + 70, Top + 340);
    end;
    end;
    2:
    begin
    hair := HAIRfeature(UserState1.Feature);
    sex := hair mod 2;
    pgidx := 256;
    if sex = 1 then
    pgidx := 257;
    bbx := Left + 34;
    bby := Top + 126;
    D := g_77Images.Images[pgidx];
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), D, True);
    bbx := bbx + 52;
    bby := bby + 78;
    D := GetHumInnerHairImg(UserState1.job, sex, hair, ax, ay);
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    if UserState1.UseItems[U_FASHION].Name <> '' then
    begin
    Idx := UserState1.UseItems[U_FASHION].Looks;
    if Idx >= 0 then
    begin
    D := GetStateItemImgXY(Idx, ax, ay);
    if D <> nil then
    dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
    D.ClientRect, D, True);
    DressStateDrawBlend(UserState1.UseItems[U_FASHION].S.Shape,
    UserState1.UseItems[U_FASHION].AniCount, TimeTick, dsurface,
    SurfaceX(bbx), SurfaceY(bby));
    end;
    end;
    end;
    end;
    bbx := SurfaceX(Left) + 10;
    bby := SurfaceY(Top) + 140;
    //      ATexture := Textures.ObjectName(dsurface, UserState1.UserName);
    //      if ATexture <> nil then
    //        ATexture.Draw(dsurface, SurfaceX(Left + 170 - ATexture.WIDTH div 2),
    //          SurfaceY(Top + 60), clWhite);
    //      ATexture := Textures.ObjectName(dsurface, UserState1.GuildName + ' ' +
    //        UserState1.GuildRankName);
    //      if ATexture <> nil then
    //        ATexture.Draw(dsurface, SurfaceX(Left + 170 - ATexture.WIDTH div 2),
    //          SurfaceY(Top + 86), clSilver);
    end;
    { .$ENDIF }
    end; *)
end;

procedure TFrmDlg.DUserState1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  L, T: Integer;
begin
  if (Button = TMouseButton.mbLeft) and (ssCtrl in Shift) then
  begin
    with DUserState1 do
    begin
      L := LocalX(X - Left);
      T := LocalY(Y - Top);
    end;
    if (T >= 62) and (T < 75) and (L > 110) and (L < 230) then
    begin
      SetDFocus(DEChat);
      PlayScene.SetChatText('/' + UserState1.UserName + ' ');
    end;
  end;
end;

procedure TFrmDlg.DUserState1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DUserState1NextClick(Sender: TObject; X, Y: Integer);
begin
  if g_DWinMan.StateWinType = wk195 then
  begin
    if DPOtherState.ActivePage < DPOtherState.LastPage then
      DPOtherState.ActivePage := DPOtherState.ActivePage + 1;
  end else
  begin
    if DPOtherState.ActivePage < DPOtherState.LastPage - 1 then
      DPOtherState.ActivePage := DPOtherState.ActivePage + 1;
  end;
end;

procedure TFrmDlg.DUserState1PreClick(Sender: TObject; X, Y: Integer);
begin
  if DPOtherState.ActivePage > 0 then
    DPOtherState.ActivePage := DPOtherState.ActivePage - 1;
end;

procedure TFrmDlg.DV_RankInfoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  AName: String;
  Item : TuOrderItem;
begin
  if Button = mbRight then
  begin
    if DV_RankInfo.SelectedIndex <> -1 then
    begin
      Item := TuOrderItem(DV_RankInfo.SelectedData);
      AName := Item.Name;
      if AName <> g_MySelf.m_sUserName then
      begin
        if DXPopupMenu.PopVisible then
          DXPopupMenu.HidePopup;
        DXPopupMenu.BeginUpdate;
        DXPopupMenu.Clear;
        DXPopupMenu.AddMenuItem(1, '查看装备');
        DXPopupMenu.AddMenuItem(11, '私聊');
        DXPopupMenu.AddMenuItem(12, '复制名称');
        if not NameInFriends(AName) and not NameInEnemies(AName) then
          DXPopupMenu.AddMenuItem(14, '添加好友');
        DXPopupMenu.EndUpdate;
        DXPopupMenu.Popup(DV_RankInfo, X - DV_RankInfo.Left,
          Y - DV_RankInfo.Top, 0,
        procedure(Tag: Integer;
          const ACaption: String)
          begin
          case Tag of
            1: FrmMain.SendClientMessage(CM_EXECMENUITEM, 0, 0, 0, Tag,
             EDcode.Encodestring(AName));
            11: begin
              PlayScene.SetChatText('/' + AName + ' '); SetDFocus(DEChat);
              DEChat.SelStart := Length(DEChat.Text);
            end;
            12: Clipbrd.Clipboard.SetTextBuf(PChar(AName));
            14: FrmMain.AddFriend(AName); end; end);
      end;
    end;
  end;

end;

procedure TFrmDlg.DWeaponUS1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ax, bbx, bby, ay, sex, nColor: Integer;
begin
  with DWeaponUS1 do
  begin
    sex := GenderFeature(UserState1.Feature);
    bbx := Left + Propertites.OffsetX;
    bby := Top + Propertites.OffsetY;
    if UserState1.UseItems[U_WEAPON].Name <> '' then
    begin

      D := GetStateItemImgXY(UserState1.UseItems[U_WEAPON].wLook, ax, ay);

      if D <> nil then
      begin
        nColor := GetRGB(UserState1.BodyBlendColor);
        if nColor > 0 then
        begin
          dsurface.DrawColor(SurfaceX(bbx + ax), SurfaceY(bby + ay), D, nColor);
        end
        else
        begin
          dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
            D.ClientRect, D, True);
        end;
      end;

      if UserWeponInnerEffect <> nil then
        UserWeponInnerEffect.Draw(dsurface, SurfaceX(bbx), SurfaceY(bby))
      else
        WeponStateDrawBlend(UserState1.UseItems[U_WEAPON].S.Shape,
          UserState1.UseItems[U_WEAPON].AniCount, TimeTick, dsurface,
          SurfaceX(bbx), SurfaceY(bby));
    end;
  end;
end;

procedure TFrmDlg.DWeaponUS1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sel: Integer;
  tmpItem: TClientItem;
begin
  sel := TDButton(Sender).Tag;
  if sel in [U_DRESS .. U_MAXUSEITEMIDX] then
  begin
    tmpItem := UserState1.UseItems[sel];
    if tmpItem.Name <> '' then
    begin
      if (tmpItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := tmpItem;
        DScreen.ShowItemHint(g_Application._CurPos, tmpItem, fkNormal);
      end;
    end
    else
      DScreen.ClearHint;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DWGroupsDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  I, Idx: Integer;
  D: TAsphyreLockableTexture;
  ARect: TRect;
  ATexture: TAsphyreLockableTexture;
begin
  with DWGroups do
  begin
    Idx := 0;
    for I := 0 to g_GroupMembers.Count - 1 do
    begin
      if g_GroupMembers.Items[I].UserName <> g_MySelf.m_sUserName then
      begin
        D := g_77Images.Images[357];
        if D <> nil then
        begin
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top) + Idx * 46, D);
          ATexture := FontManager.
            Default.TextOut(IntToStr(g_GroupMembers[I].Level));
          if ATexture <> nil then
            dsurface.DrawBoldText(SurfaceX(Left) + 4, SurfaceY(Top) + Idx * 46 +
              3, ATexture, clWhite, FontBorderColor);
          ATexture := FontManager.Default.TextOut(g_GroupMembers[I].UserName);
          if ATexture <> nil then
            dsurface.DrawBoldText(SurfaceX(Left) + 26, SurfaceY(Top) + Idx * 46
              + 3, ATexture, clWhite, FontBorderColor);
          ATexture := FontManager.
            Default.TextOut(GetJobShortName(g_GroupMembers[I].job));
          if ATexture <> nil then
            dsurface.DrawBoldText(SurfaceX(Left) + 103, SurfaceY(Top) + Idx * 46
              + 22, ATexture, clWhite, FontBorderColor);
          // 显示HP及MP 图形
          if g_GroupMembers[I].MaxHP > 0 then
          begin
            D := g_77Images.Images[358];
            if D <> nil then
            begin
              // HP 图形
              ARect := D.ClientRect;
              ARect.Right :=
                Round(ARect.Right * (g_GroupMembers[I].HP / g_GroupMembers
                [I].MaxHP));
              dsurface.Draw(SurfaceX(Left) + 4, SurfaceY(Top) + Idx * 46 + 22,
                ARect, D, False);
            end;
          end;
          ATexture := FontManager.
            Default.TextOut(Format('%d/%d', [g_GroupMembers[I].HP,
            g_GroupMembers[I].MaxHP]));
          if ATexture <> nil then
            dsurface.DrawBoldText(4 + (92 - ATexture.WIDTH) div 2,
              SurfaceY(Top) + Idx * 46 + 22 + (5 - ATexture.Height) div 2,
              ATexture, clWhite, FontBorderColor);
          if g_GroupMembers[I].MaxMP > 0 then
          begin
            D := g_77Images.Images[359];
            if D <> nil then
            begin
              // MP 图形
              ARect := D.ClientRect;
              ARect.Right :=
                Round(ARect.Right * (g_GroupMembers[I].MP / g_GroupMembers
                [I].MaxMP));
              dsurface.Draw(SurfaceX(Left) + 4, SurfaceY(Top) + Idx * 46 + 34,
                ARect, D, False);
            end;
          end;
          ATexture := FontManager.
            Default.TextOut(Format('%d/%d', [g_GroupMembers[I].MP,
            g_GroupMembers[I].MaxMP]));
          if ATexture <> nil then
            dsurface.DrawBoldText(4 + (92 - ATexture.WIDTH) div 2,
              SurfaceY(Top) + Idx * 46 + 34 + (5 - ATexture.Height) div 2,
              ATexture, clWhite, FontBorderColor);
        end;
        Inc(Idx);
      end;
    end;
  end;
end;

procedure TFrmDlg.DWHeadHealthDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
  rc: TRect;
begin
  with DWHeadHealth do
  begin
    D := Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
      dsurface.Draw(0, 0, D);
    if g_MySelf <> nil then
    begin
      D := g_77Images.Images[360 + g_MySelf.m_btSex * 5 + g_MySelf.m_btJob];
      if D <> nil then
        dsurface.Draw(6, 6, D);

      ATexture := FontManager.Default.TextOut(IntToStr(g_MySelf.m_Abil.Level));
      if ATexture <> nil then
        dsurface.DrawBoldText(SurfaceX(Left) + 68 + (20 - ATexture.WIDTH) div 2,
          SurfaceY(Top) + 4, ATexture, clWhite, FontBorderColor);
      ATexture := FontManager.Default.TextOut(g_MySelf.m_sUserName);
      if ATexture <> nil then
        dsurface.DrawBoldText(SurfaceX(Left) + 96, SurfaceY(Top) + 4, ATexture,
          clWhite, FontBorderColor);
      ATexture := FontManager.
        Default.TextOut(GetJobShortName(g_MySelf.m_btJob));
      if ATexture <> nil then
        dsurface.DrawBoldText(SurfaceX(Left) + 196, SurfaceY(Top) + 30,
          ATexture, clWhite, FontBorderColor);
      // 显示HP及MP 图形
      if g_MySelf.m_Abil.MaxHP > 0 then
      begin
        D := g_77Images.Images[354];
        if D <> nil then
        begin
          // HP 图形
          rc := D.ClientRect;
          rc.Right :=
            Round(rc.Right * (g_MySelf.m_Abil.HP / g_MySelf.m_Abil.MaxHP));
          dsurface.Draw(68, 29, rc, D, False);
        end;
      end;
      ATexture := FontManager.
        Default.TextOut(Format('%d/%d', [g_MySelf.m_Abil.HP,
        g_MySelf.m_Abil.MaxHP]));
      if ATexture <> nil then
        dsurface.DrawBoldText(68 + (120 - ATexture.WIDTH) div 2,
          29 + (6 - ATexture.Height) div 2, ATexture, clWhite, FontBorderColor);
      if g_MySelf.m_Abil.MaxMP > 0 then
      begin
        D := g_77Images.Images[355];
        if D <> nil then
        begin
          // MP 图形
          rc := D.ClientRect;
          rc.Right :=
            Round(rc.Right * (g_MySelf.m_Abil.MP / g_MySelf.m_Abil.MaxMP));
          dsurface.Draw(68, 44, rc, D, False);
        end;
      end;
      ATexture := FontManager.
        Default.TextOut(Format('%d/%d', [g_MySelf.m_Abil.MP,
        g_MySelf.m_Abil.MaxMP]));
      if ATexture <> nil then
        dsurface.DrawBoldText(68 + (120 - ATexture.WIDTH) div 2,
          44 + (6 - ATexture.Height) div 2, ATexture, clWhite, FontBorderColor);
    end;
  end;
end;

procedure TFrmDlg.DWHeadHealthInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
var
  D: TAsphyreLockableTexture;
begin
  IsRealArea := False;
  D := DWHeadHealth.Propertites.Images.Images
    [DWHeadHealth.Propertites.ImageIndex];
  if D <> nil then
    IsRealArea := D.Pixels[X, Y] > 0;
end;

procedure TFrmDlg.DCloseUS1Click(Sender: TObject; X, Y: Integer);
begin
  DUserState1.visible := False;
end;

procedure TFrmDlg.DCMailItemDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  if (g_Mail.Selected <> nil) then
  begin
    if g_Mail.Selected.Item1.Name <> '' then
      DrawItem(g_Mail.Selected.Item1, dsurface,
        DCMailItem.SurfaceX(DCMailItem.Left),
        DCMailItem.SurfaceY(DCMailItem.Top), DCMailItem.WIDTH,
        DCMailItem.Height, DCMailItem.TimeTick);
  end;
end;

procedure TFrmDlg.DCMailItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (g_Mail.Selected <> nil) then
  begin
    if g_Mail.Selected.Item1.Name <> '' then
    begin
      if (g_Mail.Selected.Item1.MakeIndex = g_MouseItem.MakeIndex) and
        DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := g_Mail.Selected.Item1;
        DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
      end;
    end
    else
      DScreen.ClearHint;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DNecklaceUS1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  with TDControl(Sender) do
  begin
    if UserState1.UseItems[Tag].Name <> '' then
      DrawItem(UserState1.UseItems[Tag], dsurface, SurfaceX(Left),
        SurfaceY(Top), WIDTH, Height, TimeTick,dipStateItem);
  end;
end;

procedure TFrmDlg.ShowGuildDlg;
begin
  DGuildDlg.visible := True; // not DGuildDlg.Visible;
  DGuildDlg.Top := -3;
  DGuildDlg.Left := 0;
  if DGuildDlg.visible then
  begin
    DGDAddMem.visible := g_Guild.CommanderMode;
    DGDDelMem.visible := g_Guild.CommanderMode;
    DGDEditNotice.visible := g_Guild.CommanderMode;
    DGDEditGrade.visible := g_Guild.CommanderMode;
    DGDAlly.visible := g_Guild.CommanderMode;
    DGDBreakAlly.visible := g_Guild.CommanderMode;
    DGDWar.visible := g_Guild.CommanderMode;
    DGDCancelWar.visible := g_Guild.CommanderMode;
  end;
  GuildTopLine := 0;
end;

procedure TFrmDlg.ShowGuildEditNotice;
begin
  with DGuildEditNotice do
  begin
    FGuildMemo.Left := SurfaceX(Left + 16);
    FGuildMemo.Top := SurfaceY(Top + 36);
    FGuildMemo.WIDTH := 571;
    FGuildMemo.Height := 246;
    FGuildMemo.Lines.Assign(g_Guild.Notice);
    FGuildMemo.visible := True;
    FGuildMemoType := 0;
    DGuildEditNotice.ShowModal;
    FGuildMemo.SetFocus;
  end;
  while True do
  begin
    if not DGuildEditNotice.visible then
      Break;
    FrmMain.ProcOnIdle;
    Application.ProcessMessages;
    if Application.Terminated then
      Exit;
  end;
end;

procedure TFrmDlg.ShowLockClientWindows(Show:Boolean; const Caption: String);
begin
  if Show then
  begin
    DTCaption.Propertites.Caption.Text := Caption;
    DLockClient.Width := SCREENWIDTH;
    DLockClient.Height := SCREENHEIGHT;
    DLockClient.Visible := True;
  end else
  begin
    DLockClient.Visible := False;
  end;
end;

procedure TFrmDlg.ShowGuildEditGrade;
begin
  if g_Guild.Members.Count <= 0 then
  begin
    DMessageDlg('请先打开成员列表。', [mbOK]);
    Exit;
  end;

  with DGuildEditNotice do
  begin
    FGuildMemo.Left := SurfaceX(Left + 16);
    FGuildMemo.Top := SurfaceY(Top + 36);
    FGuildMemo.WIDTH := 571;
    FGuildMemo.Height := 246;
    FGuildMemo.Lines.Assign(g_Guild.Members);
    FGuildMemo.visible := True;
    FGuildMemoType := 1;
    DGuildEditNotice.ShowModal;
    FGuildMemo.SetFocus;
  end;

  while True do
  begin
    if not DGuildEditNotice.visible then
      Break;
    FrmMain.ProcOnIdle;
    Application.ProcessMessages;
    if Application.Terminated then
      Exit;
  end;
end;

procedure TFrmDlg.DGuidExtentButtonClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DGuidExtentButton.TimeTick > 300 then
  begin
    FrmMain.SendGuildExtendButtonClick;
    DGuidExtentButton.TimeTick := GetTickCount;
  end;
end;

procedure TFrmDlg.DGuildDlgDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  I, J, n, bx, by: Integer;
  AColor: TColor;
  ATextLine: TclGuildTextLine;
  ATextNode: TclGuildTextNode;
begin
  with DGuildDlg do
  begin
    if Propertites.Images <> nil then
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;
//    Textures.ObjectName(dsurface, g_Guild.GuildName).Draw(dsurface, Left + 320,
//      Top + 13, clWhite);
//    bx := Left + 20;
//    by := Top + 41;
//    if g_Guild.Texts.Count > 0 then
//    begin
//      for I := GuildTopLine to g_Guild.Texts.Count - 1 do
//      begin
//        n := I - GuildTopLine;
//        if n * 14 > 356 then
//          Break;
//        ATextLine := g_Guild.Texts[I];
//        for J := 0 to ATextLine.Count - 1 do
//        begin
//          ATextNode := ATextLine[J];
//          Textures.ObjectName(dsurface, ATextNode.Value)
//            .Draw(dsurface, bx + ATextNode.Left, by + n * 14, ATextNode.Color);
//        end;
//      end;
//    end;
//  end;

  // if GuildStrs.Count > 0 then
  // for I := GuildTopLine to GuildStrs.Count - 1 do
  // begin
  // n := I - GuildTopLine;
  // if n * 14 > 356 then
  // break;
  // if Integer(GuildStrs.Objects[I]) <> 0 then
  // AColor := TColor(GuildStrs.Objects[I])
  // else
  // begin
  // if g_Guild.LogChat then
  // AColor := GetRGB(2)
  // else
  // AColor := clSilver;
  // end;
  // Textures.ObjectName(DSurface, GuildStrs[I]).Draw(dsurface, bx, by + n * 14, AColor);
  // end;
  // end;
end;
end;

procedure TFrmDlg.DGuildDlgVisibleChange(Sender: TObject);
begin
  if TDControl(Sender).Visible then
  begin
    DTGuildName.Propertites.Caption.Text := g_Guild.GuildName;
  end;

end;

procedure TFrmDlg.DGDUpClick(Sender: TObject; X, Y: Integer);
begin
  if GuildTopLine > 0 then
    Dec(GuildTopLine, 3);
  if GuildTopLine < 0 then
    GuildTopLine := 0;
end;

procedure TFrmDlg.DGDWarClick(Sender: TObject; X, Y: Integer);
begin
  // g_Application.AddMessageDialog('请输入对方行会的名称：', [mbOK, mbAbort],
  // procedure(AResult: Integer)
  // var
  // S: String;
  // begin
  // if AResult = mrOK then
  // begin
  // if DlgEditText <> '' then
  // FrmMain.SendClientMessage(CM_REQUESTGUILDWAR, 0, 0, 0, 0, EDCode.EncodeString(DlgEditText));
  // end;
  // end
  // );
end;

procedure TFrmDlg.DGDDownClick(Sender: TObject; X, Y: Integer);
begin
  if GuildTopLine + 12 < g_Guild.Texts.Count then
    Inc(GuildTopLine, 3);
end;

procedure TFrmDlg.DGDCloseClick(Sender: TObject; X, Y: Integer);
begin
  DGuildDlg.visible := False;
  g_Guild.LogChat := False;
end;

procedure TFrmDlg.DGDHomeClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwQueryMsgTick then
  begin
    g_dwQueryMsgTick := GetTickCount + 3000;
    FrmMain.SendGuildHome;
  end;
end;

procedure TFrmDlg.DGDListClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwQueryMsgTick then
  begin
    g_dwQueryMsgTick := GetTickCount + 3000;
    FrmMain.SendGuildMemberList;
  end;
end;

procedure TFrmDlg.DGDAddMemClick(Sender: TObject; X, Y: Integer);
begin
  g_Application.AddMessageDialog('请输入想加入' + g_Guild.GuildName + '的人物名称：',
    [mbOK, mbAbort], procedure(AResult: Integer)var S: String;
  begin if AResult = mrOK then begin S := Common.MakeMaskString(DlgEditText);
    if S <> '' then FrmMain.SendGuildAddMem(S); end; end);
end;

procedure TFrmDlg.DGDDelMemClick(Sender: TObject; X, Y: Integer);
begin
  g_Application.AddMessageDialog('请输入想要开除的人物名称：', [mbOK, mbAbort],
    procedure(AResult: Integer)var S: String;
  begin if AResult = mrOK then begin S := Common.MakeMaskString(DlgEditText);
    if S <> '' then FrmMain.SendGuildDelMem(S); end; end);
end;

procedure TFrmDlg.DGDEditNoticeClick(Sender: TObject; X, Y: Integer);
begin
  GuildEditHint := '[修改行会通告内容]';
  ShowGuildEditNotice;
end;

procedure TFrmDlg.DGDEditGradeClick(Sender: TObject; X, Y: Integer);
begin
  GuildEditHint := '[修改行会成员的等级和职位。 # 警告 : 不能增加行会成员/删除行会成员]';
  ShowGuildEditGrade;
end;

// 结盟
procedure TFrmDlg.DGDAllyClick(Sender: TObject; X, Y: Integer);
begin
  g_Application.AddMessageDialog('对方结盟行会必需在 [允许结盟]状态下。\' + '而且二个行会的管理者必须面对面。\' +
    '是否确认行会结盟？', [mbOK, mbCancel], procedure(AResult: Integer)
  begin if AResult = mrOK then begin FrmMain.SendShortCut(_SC_Alliance);
  end; end);
end;

// 解除结盟
procedure TFrmDlg.DGDBreakAllyClick(Sender: TObject; X, Y: Integer);
begin
  g_Application.AddMessageDialog('请输入您想取消结盟的行会的名字', [mbOK, mbAbort],
    procedure(AResult: Integer)var S: String;
  begin if AResult = mrOK then begin S := Common.MakeMaskString(DlgEditText);
    if S <> '' then FrmMain.SendShortCut(_SC_CancelAlliance, S); end; end);
end;

procedure TFrmDlg.DGuildEditNoticeDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with DGuildEditNotice do
  begin
    if Propertites.Images <> nil then
    begin // 20080701
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;

    dsurface.TextOut(GuildEditHint, clSilver, Left + 18, Top + 291);
  end;
end;

procedure TFrmDlg.DGuildEditNoticeVisibleChange(Sender: TObject);
begin
  if FUILoaded and not DGuildEditNotice.visible then
    FGuildMemo.visible := False;
end;

procedure TFrmDlg.DGuildInfoDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  I, J, n, bx, by: Integer;
  AColor: TColor;
  ATextLine: TclGuildTextLine;
  ATextNode: TclGuildTextNode;
begin
   bx := DGuildInfo.SurfaceX(DGuildInfo.Left);
   by := DGuildInfo.SurfaceY(DGuildInfo.Top);
    if g_Guild.Texts.Count > 0 then
    begin
      for I := GuildTopLine to g_Guild.Texts.Count - 1 do
      begin
        n := I - GuildTopLine;
        if n * 14 > 356 then
          Break;
        ATextLine := g_Guild.Texts[I];
        for J := 0 to ATextLine.Count - 1 do
        begin
          ATextNode := ATextLine[J];
          Textures.ObjectName(dsurface, ATextNode.Value)
            .Draw(dsurface, bx + ATextNode.Left, by + n * 14, ATextNode.Color);
        end;
      end;
    end;
end;


procedure TFrmDlg.DGECloseClick(Sender: TObject; X, Y: Integer);
begin
  FGuildMemo.visible := False;
  DGuildEditNotice.visible := False;
end;

procedure TFrmDlg.DGEOkClick(Sender: TObject; X, Y: Integer);
var
  I: Integer;
  AData, ALine, ARankNo, ARankName: String;
begin
  FGuildMemo.visible := False;
  DGuildEditNotice.visible := False;
  if FGuildMemo.Lines.Count > 0 then
  begin
    for I := 0 to FGuildMemo.Lines.Count - 1 do
    begin
      ALine := FGuildMemo.Lines[I];
      if ALine = '' then
        AData := AData + ' '#13
      else
        AData := AData + ALine + #13;
    end;
    case FGuildMemoType of
      0:
        begin
          if Length(AData) > 4000 then
          begin
            AData := Copy(AData, 1, 4000);
            DMessageDlg('公告内容超过限制大小，公告内容将被截短！', [mbOK]);
          end;
          FrmMain.SendGuildUpdateNotice(AData);
        end;
      1:
        begin
          if Length(AData) > 5000 then
          begin
            AData := Copy(AData, 1, 5000);
            DMessageDlg('内容超过限制大小，内容将被截短', [mbOK]);
          end;
          FrmMain.SendGuildUpdateGrade(AData);
        end;
    end;
    FGuildMemo.Lines.Clear;
  end;
end;

procedure TFrmDlg.DGetBackItemClick(Sender: TObject; X, Y: Integer);
var
 pg: PTClientGoods;
begin
  pg :=  PTClientGoods(DLVSaveItems.SelectedData);
  if pg <> nil then
  begin
    FrmMain.SendTakeBackStorageItem(g_nCurMerchant,pg.Price { MakeIndex } , pg.Name);
  end;
end;

function TranslationBuffer(AControl: TuDBufferControl;
  const Message: String): String;
begin
  Result := Message;
  if pos('$剩余时间$', Result) > 0 then
  begin
    if not AControl.Permannent then
      Result := StringReplace(Result, '$剩余时间$',
        AControl.TimeToStr(AControl.EndTick - AControl.StartTick),
        [rfReplaceAll, rfIgnoreCase])
    else
      Result := StringReplace(Result, '$剩余时间$', '永久',
        [rfReplaceAll, rfIgnoreCase]);
  end;
  if pos('$持续时间$', Result) > 0 then
  begin
    if not AControl.Permannent then
      Result := StringReplace(Result, '$持续时间$',
        AControl.TimeToStr(AControl.TimeLimit * 1000),
        [rfReplaceAll, rfIgnoreCase])
    else
      Result := StringReplace(Result, '$持续时间$', '永久',
        [rfReplaceAll, rfIgnoreCase]);
  end;
  Result := StringReplace(Result, '$点数$', IntToStr(AControl.Value),
    [rfReplaceAll, rfIgnoreCase]);
end;

procedure TFrmDlg.OnBufferItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  AControl: TuDBufferControl;
  ABufferItem: TdxUIBufferItem;
  AHint: String;
begin
  DScreen.ClearHint;
  if Sender is TuDBufferControl then
  begin
    AControl := TuDBufferControl(Sender);
    ABufferItem := AControl.BufferItem;
    if (ABufferItem <> nil) and (ABufferItem.Hint <> '') then
    begin
      AHint := TranslationBuffer(AControl, ABufferItem.Hint);
      DScreen.ShowHint(AControl.SurfaceX(AControl.Left),
        AControl.SurfaceY(AControl.Top) + AControl.Height, AHint);
    end;
  end;
end;

procedure TFrmDlg.OnBufferItemTimeEnd(Sender: TObject);
var
  AControl: TuDBufferControl;
  Idx: Integer;
begin
  AControl := TuDBufferControl(Sender);
  Idx := FBufferControls.IndexOf(AControl);
  if Idx <> -1 then
  begin
    FBufferControls[Idx].visible := False;
    RebuildBufferControls;
  end;
end;

procedure TFrmDlg.RebuildBufferControls;
var
  I, ALeft, ATop, ALineSize, ALineMaxHeight: Integer;
begin
  ATop := 0;
  ALeft := 0;
  ALineSize := 0;
  ALineMaxHeight := 0;
  for I := 0 to FBufferControls.Count - 1 do
  begin
    if FBufferControls[I].visible then
    begin
      FBufferControls[I].Top := ATop;
      FBufferControls[I].Left := ALeft;
      ALineMaxHeight := Max(ALineMaxHeight, FBufferControls[I].Height);
      if FBufferControls[I].BufferItem.ShowTime then
        ALeft := ALeft + Max(FBufferControls[I].WIDTH + 8, 48)
      else
        ALeft := ALeft + FBufferControls[I].WIDTH + 8;
      Inc(ALineSize);
      if (UIWindowManager.Form.Buffers.MaxBufOfLine > 0) and
        (ALineSize >= UIWindowManager.Form.Buffers.MaxBufOfLine) then
      begin
        ALineSize := 0;
        ALeft := 0;
        ATop := ATop + ALineMaxHeight + 12;
        ALineMaxHeight := 0;
      end;
    end;
  end;
end;

procedure TFrmDlg.AddOrUpdateBufferControl(BufferType, TimeLimit,
  Value: Integer; const AName: String);

  procedure AddHintMessage(const Value: String; FontColor, BgColor: TColor);
  begin
    DScreen.AddChatBoardString(Value, '', FontColor, BgColor);
    UpdateChatSroll;
  end;

  function CreateBufferControl(AUIBufferType: TdxUIBufferType;
    ABufferItem: TdxUIBufferItem): TuDBufferControl;
  var
    I: Integer;
  begin
    for I := 0 to FBufferControls.Count - 1 do
    begin
      if FBufferControls[I].visible and
        (FBufferControls[I].BufferItem = ABufferItem) then
      begin
        Result := FBufferControls[I];
        Exit;
      end;
    end;

    Result := TuDBufferControl.Create(Self);
    Result.Parent := Self;
    Result.EnableFocus := False;
    Result.OnMouseMove := OnBufferItemMouseMove;
    Result.OnTimeEnd := OnBufferItemTimeEnd;
    Result.BufferItem := ABufferItem;
    Result.DParent := DBufferButtons;
    FBufferControls.Add(Result);
    DBufferButtons.DControls.Add(Result);
  end;

var
  ABufferControl: TuDBufferControl;
  ABufferItem: TdxUIBufferItem;
  AUIBufferType: TdxUIBufferType;
  AMessageHandled: Boolean;
begin
  AUIBufferType := TdxUIBufferType(BufferType);
  ABufferItem := nil;
  if AUIBufferType = btCustom then
    UIWindowManager.Form.Buffers.TryGet(AName, ABufferItem)
  else
    UIWindowManager.Form.Buffers.TryGet(AUIBufferType, ABufferItem);
  AMessageHandled := False;
  Value := ABS(Value);
  if ABufferItem <> nil then
  begin
    ABufferControl := CreateBufferControl(AUIBufferType, ABufferItem);
    ABufferControl.TimeLimit := TimeLimit;
    ABufferControl.Value := Value;
    ABufferControl.Permannent := (TimeLimit = 60000) and
      (AUIBufferType = btTransparent);
    ABufferControl.BufferTime := TimeLimit * 1000;
    ABufferControl.StartTick := GetTickCount;
    ABufferControl.EndTick := ABufferControl.StartTick + TimeLimit * 1000;
    ABufferControl.BufferValue := Value;
    ABufferControl.DParent := DBufferButtons;
    RebuildBufferControls;
    if ABufferItem.Message <> '' then
    begin
      DScreen.AddChatBoardString(TranslationBuffer(ABufferControl,
        ABufferItem.Message), '', ABufferItem.FontColor,
        ABufferItem.Background);
      UpdateChatSroll;
      AMessageHandled := True;
    end;
  end;
  if not AMessageHandled then
  begin
    case AUIBufferType of
      btTransparent:
        ;
      btStone:
        AddHintMessage('你被石化了！', clWhite, clRed);
      btDecHealth:
        AddHintMessage('你中毒了！', clWhite, clRed);
      btDamagearmor:
        AddHintMessage('你中毒了！', clWhite, clRed);
      btLockRun:
        AddHintMessage('被蜘蛛网束缚，暂时失去移动能力！', clWhite, clRed);
      btLockSpell:
        AddHintMessage('你被禁止使用魔法！', clWhite, clRed);
      btDontMove:
        AddHintMessage('暂时失去移动能力！', clWhite, clRed);
      btDCAdd:
        AddHintMessage('攻击力增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clGreen, clWhite);
      btDCDec:
        AddHintMessage('攻击力减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btMCAdd:
        AddHintMessage('魔法力增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clGreen, clWhite);
      btMCDec:
        AddHintMessage('魔法力减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btSCAdd:
        AddHintMessage('道术增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit) +
          '秒！', clGreen, clWhite);
      btSCDec:
        AddHintMessage('道术减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit) +
          '秒！', clWhite, clRed);
      btPCAdd:
        AddHintMessage('刺术增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit) +
          '秒！', clGreen, clWhite);
      btPCDec:
        AddHintMessage('刺术减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit) +
          '秒！', clWhite, clRed);
      btTCAdd:
        AddHintMessage('箭术增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit) +
          '秒！', clGreen, clWhite);
      btTCDec:
        AddHintMessage('箭术减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit) +
          '秒！', clWhite, clRed);
      btACAdd:
        AddHintMessage('物理防御增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clGreen, clWhite);
      btACDec:
        AddHintMessage('物理防御减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btMACAdd:
        AddHintMessage('魔法防御增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clGreen, clWhite);
      btMACDec:
        AddHintMessage('魔法防御减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btHitPointAdd:
        AddHintMessage('准确增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit) +
          '秒！', clGreen, clWhite);
      btHitPointDec:
        AddHintMessage('准确减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit) +
          '秒！', clGreen, clWhite);
      btSpeedAdd:
        AddHintMessage('攻击速度增加' + IntToStr(TimeLimit) + '秒！', clGreen, clWhite);
      btSpeedDec:
        AddHintMessage('攻击速度降低' + IntToStr(TimeLimit) + '秒！', clWhite, clRed);
      btSpeedPointAdd:
        AddHintMessage('敏捷增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit) +
          '秒！', clGreen, clWhite);
      btSpeedPointDec:
        AddHintMessage('敏捷减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit) +
          '秒！', clWhite, clRed);
      btHealthRecoverAdd:
        AddHintMessage('体力恢复增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clGreen, clWhite);
      btHealthRecoverDec:
        AddHintMessage('体力恢复减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btSpellRecoverAdd:
        AddHintMessage('魔法恢复增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clGreen, clWhite);
      btSpellRecoverDec:
        AddHintMessage('魔法恢复减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btAntiMagicAdd:
        AddHintMessage('魔法躲避增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clGreen, clWhite);
      btAntiMagicDec:
        AddHintMessage('魔法躲避减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btAntiPoisonAdd:
        AddHintMessage('毒物躲避增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clGreen, clWhite);
      btAntiPoisonDec:
        AddHintMessage('毒物躲避减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btPoisonRecoverAdd:
        AddHintMessage('中毒恢复增加' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clGreen, clWhite);
      btPoisonRecoverDec:
        AddHintMessage('中毒恢复减少' + IntToStr(Value) + '点，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btHPAdd:
        AddHintMessage('体力值上限增加' + IntToStr(Value) + '点，持续' +
          IntToStr(TimeLimit) + '秒！', clGreen, clWhite);
      btHPDec:
        AddHintMessage('体力值上限减少' + IntToStr(Value) + '点，持续' +
          IntToStr(TimeLimit) + '秒！', clWhite, clRed);
      btMPAdd:
        AddHintMessage('魔力值上限增加' + IntToStr(Value) + '点，持续' +
          IntToStr(TimeLimit) + '秒！', clGreen, clWhite);
      btMPDec:
        AddHintMessage('魔力值上限减少' + IntToStr(Value) + '点，持续' +
          IntToStr(TimeLimit) + '秒！', clWhite, clRed);
      btAbsorbingAdd:
        AddHintMessage('伤害吸收增加' + IntToStr(Value) + '%，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btAbsorbingDec:
        AddHintMessage('伤害吸收减少' + IntToStr(Value) + '%，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btReboundAdd:
        AddHintMessage('伤害反弹增加' + IntToStr(Value) + '%，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btReboundDec:
        AddHintMessage('伤害反弹减少' + IntToStr(Value) + '%，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btDamagePer:
        AddHintMessage('伤害提高' + IntToStr(Value) + '%，持续' + IntToStr(TimeLimit) +
          '秒！', clWhite, clRed);
      btPunchHitAdd:
        AddHintMessage('致命一击增加' + IntToStr(Value) + '%，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btPunchHitDec:
        AddHintMessage('致命一击减少' + IntToStr(Value) + '%，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btCriticalHitAdd:
        AddHintMessage('会心一击增加' + IntToStr(Value) + '%，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btCriticalHitDec:
        AddHintMessage('会心一击减少' + IntToStr(Value) + '%，持续' + IntToStr(TimeLimit)
          + '秒！', clWhite, clRed);
      btCritical:
        AddHintMessage('暴击提高' + IntToStr(Value) + '%，持续' + IntToStr(TimeLimit) +
          '秒！', clWhite, clRed);
    end;
  end;
end;

procedure TFrmDlg.AddStallQueryLog(const S: String);
begin
  g_QueryStallLogs.Add(S);
  if FQueryStallLogTopLine < g_QueryStallLogs.Count - 7 then
  begin
    FQueryStallLogTopLine := g_QueryStallLogs.Count - 7;
    UpdateQueryStallLogScroll;
  end;
end;

procedure TFrmDlg.AddSideBarButton(const ACaption, AName: String);
begin
  if FSideButtons.IndexOf(AName + '=' + ACaption) = -1 then
  begin
    FSideButtons.Add(AName + '=' + ACaption);
    RecalcSideBarButtons;
  end;
end;

procedure TFrmDlg.DeleteSideBarButton(const AName: String);
var
  AIdx: Integer;
begin
  AIdx := FSideButtons.IndexOfName(AName);
  if AIdx > -1 then
  begin
    FSideButtons.Delete(AIdx);
    RecalcSideBarButtons;
  end;
end;

procedure TFrmDlg.ClearSideBarButtons;
begin
  FSideButtons.Clear;
  FSideButtonActive := -1;
  FSideButtonExpand := False;
  RecalcSideBarButtons;
end;

procedure TFrmDlg.RecalcSideBarButtons;
var
  AButtonsHeight: Integer;
begin
  DSideBar.visible := False;
  if (FSideButtons.Count > 0) and (g_77Images.Images[510] <> nil) then
  begin
    AButtonsHeight := FSideButtons.Count * 28;
    DSideBar.Left := 0;
    DSideBar.Height := Max(264, AButtonsHeight + 44);
    DSideBar.WIDTH := 146;
    DSideBar.Top :=
      Max(0, (SCREENHEIGHT - DBottom.Height - DSideBar.Height) div 2);
    DButtonSideBar.Height := 212;
    DButtonSideBar.WIDTH := 28;
    DButtonSideBar.Top := 22 +
      (DSideBar.Height - 44 - DButtonSideBar.Height) div 2;
    if FSideButtonExpand then
    begin
      DSideBarButtons.Left := 3;
      DSideBarButtons.Height := AButtonsHeight;
      DSideBarButtons.Top := 22;
      DSideBarButtons.WIDTH := 112;
      DSideBarButtons.visible := True;
      DButtonSideBar.Left := 118;
    end
    else
    begin
      DSideBarButtons.visible := False;
      DButtonSideBar.Left := 0;
    end;
    DSideBar.visible := True;
  end;
end;

procedure TFrmDlg.RemoveBufferControl(BufferType: Integer);
var
  I: Integer;
  AUIBufferType: TdxUIBufferType;
begin
  AUIBufferType := TdxUIBufferType(BufferType);
  for I := 0 to FBufferControls.Count - 1 do
  begin
    if FBufferControls[I].BufferItem.BufferType = AUIBufferType then
    begin
      if FBufferControls[I].BufferItem.HideMessage <> '' then
      begin
        DScreen.AddChatBoardString(TranslationBuffer(FBufferControls[I],
          FBufferControls[I].BufferItem.HideMessage), '',
          FBufferControls[I].BufferItem.FontColor,
          FBufferControls[I].BufferItem.Background);
        UpdateChatSroll;
      end;
      FBufferControls[I].visible := False;
      DBufferButtons.DControls.Remove(FBufferControls[I]);
      FBufferControls[I].Free;
      FBufferControls.Delete(I);
      RebuildBufferControls;
      Exit;
    end;
  end;
end;

procedure TFrmDlg.ClearBuffers;
var
  I: Integer;
begin
  for I := FBufferControls.Count - 1 downto 0 do
  begin
    FBufferControls[I].visible := False;
    DBufferButtons.DControls.Remove(FBufferControls[I]);
    FBufferControls[I].Free;
    FBufferControls.Delete(I);
  end;
end;

procedure TFrmDlg.DGDChatClick(Sender: TObject; X, Y: Integer);
begin
  g_Guild.LogChat := not g_Guild.LogChat;
  g_Guild.LoadChats;
end;

procedure TFrmDlg.DAdjustAbilCloseClick(Sender: TObject; X, Y: Integer);
begin
  DAdjustAbility.visible := False;
  g_nBonusPoint := g_nSaveBonusPoint;
 // SetBottomButtonsPosition;
end;

procedure TFrmDlg.DAdjustAbilityDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
const
  _COLOR_: array [Boolean] of TColor = (clSilver, clWhite);

  procedure AdjustAb(abil: Byte; val: Word; var lov, hiv: Word);
  var
    lo, hi: Byte;
    I: Integer;
  begin
    lo := LoByte(abil);
    hi := HiByte(abil);
    lov := 0;
    hiv := 0;
    for I := 1 to val do
    begin
      if lo + 1 < hi then
      begin
        Inc(lo);
        Inc(lov);
      end
      else
      begin
        Inc(hi);
        Inc(hiv);
      end;
    end;
  end;

var
  D: TAsphyreLockableTexture;
  L, m, adc, amc, asc, atc, apc, awc, aac, amac, ARow: Integer;
  ldc, lmc, lsc, ltc, lpc, lwc, lac, lmac, hdc, hmc, hsc, htc, hpc, hwc, hac,
    hmac: Word;
begin
  with DAdjustAbility do
  begin
    if Propertites.Images <> nil then
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;
  end;
  if g_MySelf = nil then
    Exit;

  L := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 18;
  m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 22;
  dsurface.TextOut('你有可分配的点数，选择你想提高的能力', clSilver, L, m);
  dsurface.TextOut('这样的选择你只可以做一次，最好能很小心地选择', clSilver, L, m + 18);

  adc := (g_BonusAbilChg.DC) div g_BonusTick.DC;
  amc := (g_BonusAbilChg.MC) div g_BonusTick.MC;
  asc := (g_BonusAbilChg.SC) div g_BonusTick.SC;
  atc := (g_BonusAbilChg.Tc) div g_BonusTick.Tc;
  apc := (g_BonusAbilChg.Pc) div g_BonusTick.Pc;
  awc := (g_BonusAbilChg.Wc) div g_BonusTick.Wc;
  aac := (g_BonusAbilChg.AC) div g_BonusTick.AC;
  amac := (g_BonusAbilChg.MAC) div g_BonusTick.MAC;
  AdjustAb(g_NakedAbil.DC, adc, ldc, hdc);
  AdjustAb(g_NakedAbil.MC, amc, lmc, hmc);
  AdjustAb(g_NakedAbil.SC, asc, lsc, hsc);
  AdjustAb(g_NakedAbil.Tc, atc, ltc, htc);
  AdjustAb(g_NakedAbil.Pc, apc, lpc, hpc);
  AdjustAb(g_NakedAbil.Wc, awc, lwc, hwc);
  AdjustAb(g_NakedAbil.AC, aac, lac, hac);
  AdjustAb(g_NakedAbil.MAC, amac, lmac, hmac);

  L := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 40;
  m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 58;
  ARow := 0;
  dsurface.TextOut('物理攻击   ' + IntToStr(g_MySelf.m_Abil.DCMin + ldc) + '-' +
    IntToStr(g_MySelf.m_Abil.DCMax + hdc), clWhite, L, m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut('魔法攻击   ' + IntToStr(g_MySelf.m_Abil.MCMin + lmc) + '-' +
    IntToStr(g_MySelf.m_Abil.MCMax + hmc), clWhite, L, m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut('道术攻击   ' + IntToStr(g_MySelf.m_Abil.SCMin + lsc) + '-' +
    IntToStr(g_MySelf.m_Abil.SCMax + hsc), clWhite, L, m + ARow * 20);
  Inc(ARow);
  if cjARCHER in g_ServerJobs then
  begin
    dsurface.TextOut('箭术攻击   ' + IntToStr(g_MySelf.m_Abil.TCMin + ltc) + '-' +
      IntToStr(g_MySelf.m_Abil.TCMax + htc), clWhite, L, m + ARow * 20);
    Inc(ARow);
  end;
  if cjCIK in g_ServerJobs then
  begin
    dsurface.TextOut('刺术攻击   ' + IntToStr(g_MySelf.m_Abil.PCMin + lpc) + '-' +
      IntToStr(g_MySelf.m_Abil.PCMax + hpc), clWhite, L, m + ARow * 20);
    Inc(ARow);
  end;
  if cjShaman in g_ServerJobs then
  begin
    dsurface.TextOut('武术攻击   ' + IntToStr(g_MySelf.m_Abil.WCMin + lwc) + '-' +
      IntToStr(g_MySelf.m_Abil.WCMax + hwc), clWhite, L, m + ARow * 20);
    Inc(ARow);
  end;
  dsurface.TextOut('物理防御   ' + IntToStr(g_MySelf.m_Abil.ACMin + lac) + '-' +
    IntToStr(g_MySelf.m_Abil.ACMax + hac), clWhite, L, m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut('魔法防御   ' + IntToStr(g_MySelf.m_Abil.MACMin + lmac) + '-' +
    IntToStr(g_MySelf.m_Abil.MACMax + hmac), clWhite, L, m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut('生 命 值   ' + IntToStr(g_MySelf.m_Abil.MaxHP +
    (g_BonusAbil.HP + g_BonusAbilChg.HP) div g_BonusTick.HP), clWhite, L,
    m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut('魔 力 值   ' + IntToStr(g_MySelf.m_Abil.MaxMP +
    (g_BonusAbil.MP + g_BonusAbilChg.MP) div g_BonusTick.MP), clWhite, L,
    m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut('准    确   ' + IntToStr(g_MySubAbility.HitPoint +
    (g_BonusAbil.Hit + g_BonusAbilChg.Hit) div g_BonusTick.Hit), clWhite, L,
    m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut('敏    捷   ' + IntToStr(g_MySubAbility.SpeedPoint +
    (g_BonusAbil.Speed + g_BonusAbilChg.Speed) div g_BonusTick.Speed), clWhite,
    L, m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut('可分配点数  ' + IntToStr(g_nBonusPoint), clYellow, L,
    m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut('点击按钮的同时按下Ctrl键属性加减值为10', clRed, L, m + 260);

  L := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 220;
  m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 58;
  ARow := 0;
  dsurface.TextOut(IntToStr(g_BonusAbilChg.DC + g_BonusAbil.DC) + '/' +
    IntToStr(g_BonusTick.DC), _COLOR_[g_BonusAbilChg.DC > 0], L, m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut(IntToStr(g_BonusAbilChg.MC + g_BonusAbil.MC) + '/' +
    IntToStr(g_BonusTick.MC), _COLOR_[g_BonusAbilChg.MC > 0], L, m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut(IntToStr(g_BonusAbilChg.SC + g_BonusAbil.SC) + '/' +
    IntToStr(g_BonusTick.SC), _COLOR_[g_BonusAbilChg.SC > 0], L, m + ARow * 20);
  Inc(ARow);
  if cjARCHER in g_ServerJobs then
  begin
    dsurface.TextOut(IntToStr(g_BonusAbilChg.Tc + g_BonusAbil.Tc) + '/' +
      IntToStr(g_BonusTick.Tc), _COLOR_[g_BonusAbilChg.Tc > 0], L,
      m + ARow * 20);
    Inc(ARow);
  end;
  if cjCIK in g_ServerJobs then
  begin
    dsurface.TextOut(IntToStr(g_BonusAbilChg.Pc + g_BonusAbil.Pc) + '/' +
      IntToStr(g_BonusTick.Pc), _COLOR_[g_BonusAbilChg.Pc > 0], L,
      m + ARow * 20);
    Inc(ARow);
  end;
  if cjShaman in g_ServerJobs then
  begin
    dsurface.TextOut(IntToStr(g_BonusAbilChg.Wc + g_BonusAbil.Wc) + '/' +
      IntToStr(g_BonusTick.Wc), _COLOR_[g_BonusAbilChg.Wc > 0], L,
      m + ARow * 20);
    Inc(ARow);
  end;
  dsurface.TextOut(IntToStr(g_BonusAbilChg.AC + g_BonusAbil.AC) + '/' +
    IntToStr(g_BonusTick.AC), _COLOR_[g_BonusAbilChg.AC > 0], L, m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut(IntToStr(g_BonusAbilChg.MAC + g_BonusAbil.MAC) + '/' +
    IntToStr(g_BonusTick.MAC), _COLOR_[g_BonusAbilChg.MAC > 0], L,
    m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut(IntToStr(g_BonusAbilChg.HP + g_BonusAbil.HP) + '/' +
    IntToStr(g_BonusTick.HP), _COLOR_[g_BonusAbilChg.HP > 0], L, m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut(IntToStr(g_BonusAbilChg.MP + g_BonusAbil.MP) + '/' +
    IntToStr(g_BonusTick.MP), _COLOR_[g_BonusAbilChg.MP > 0], L, m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut(IntToStr(g_BonusAbilChg.Hit + g_BonusAbil.Hit) + '/' +
    IntToStr(g_BonusTick.Hit), _COLOR_[g_BonusAbilChg.Hit > 0], L,
    m + ARow * 20);
  Inc(ARow);
  dsurface.TextOut(IntToStr(g_BonusAbilChg.Speed + g_BonusAbil.Speed) + '/' +
    IntToStr(g_BonusTick.Speed), _COLOR_[g_BonusAbilChg.Speed > 0], L,
    m + ARow * 20);
end;

procedure TFrmDlg.ChangeBonusPointButtonsState;
begin
  DPlusDC.Enabled := g_nBonusPoint > 0;
  DPlusMC.Enabled := g_nBonusPoint > 0;
  DPlusSC.Enabled := g_nBonusPoint > 0;
  DPlusTC.Enabled := g_nBonusPoint > 0;
  DPlusPC.Enabled := g_nBonusPoint > 0;
  DPlusWC.Enabled := g_nBonusPoint > 0;
  DPlusAC.Enabled := g_nBonusPoint > 0;
  DPlusMAC.Enabled := g_nBonusPoint > 0;
  DPlusHP.Enabled := g_nBonusPoint > 0;
  DPlusMP.Enabled := g_nBonusPoint > 0;
  DPlusHit.Enabled := g_nBonusPoint > 0;
  DPlusSpeed.Enabled := g_nBonusPoint > 0;

  DMinusDC.Enabled := g_BonusAbilChg.DC > 0;
  DMinusMC.Enabled := g_BonusAbilChg.MC > 0;
  DMinusSC.Enabled := g_BonusAbilChg.SC > 0;
  DMinusTC.Enabled := g_BonusAbilChg.Tc > 0;
  DMinusPC.Enabled := g_BonusAbilChg.Pc > 0;
  DMinusWC.Enabled := g_BonusAbilChg.Wc > 0;
  DMinusAC.Enabled := g_BonusAbilChg.AC > 0;
  DMinusMAC.Enabled := g_BonusAbilChg.MAC > 0;
  DMinusHP.Enabled := g_BonusAbilChg.HP > 0;
  DMinusMP.Enabled := g_BonusAbilChg.MP > 0;
  DMinusHit.Enabled := g_BonusAbilChg.Hit > 0;
  DMinusSpeed.Enabled := g_BonusAbilChg.Speed > 0;
end;

procedure TFrmDlg.DPlusDCClick(Sender: TObject; X, Y: Integer);
var
  incp: Integer;
begin
  if g_nBonusPoint > 0 then
  begin
    if IsKeyPressed(VK_CONTROL) and (g_nBonusPoint > 10) then
      incp := 10
    else
      incp := 1;
    Dec(g_nBonusPoint, incp);
    if Sender = DPlusDC then
      Inc(g_BonusAbilChg.DC, incp);
    if Sender = DPlusMC then
      Inc(g_BonusAbilChg.MC, incp);
    if Sender = DPlusSC then
      Inc(g_BonusAbilChg.SC, incp);
    if Sender = DPlusTC then
      Inc(g_BonusAbilChg.Tc, incp);
    if Sender = DPlusPC then
      Inc(g_BonusAbilChg.Pc, incp);
    if Sender = DPlusWC then
      Inc(g_BonusAbilChg.Wc, incp);
    if Sender = DPlusAC then
      Inc(g_BonusAbilChg.AC, incp);
    if Sender = DPlusMAC then
      Inc(g_BonusAbilChg.MAC, incp);
    if Sender = DPlusHP then
      Inc(g_BonusAbilChg.HP, incp);
    if Sender = DPlusMP then
      Inc(g_BonusAbilChg.MP, incp);
    if Sender = DPlusHit then
      Inc(g_BonusAbilChg.Hit, incp);
    if Sender = DPlusSpeed then
      Inc(g_BonusAbilChg.Speed, incp);
    ChangeBonusPointButtonsState;
    //SetBottomButtonsPosition;
  end;
end;

procedure TFrmDlg.DMiniMapDrawPosDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
  D, DMap: TAsphyreLockableTexture;
  mx, my, nX, nY, I, AStateTop: Integer;
  rc, drc, AMapRec: TRect;
  actor: TActor;
  btColor: Byte;
  ATexture: TAsphyreLockableTexture;
  P: PPoint;
  XRate, YRate: Double;
  AMiniWidth, AMiniHeight: Integer;
  ALeft, ATop : Integer;
  xScale,yScale:Double;
begin
  if g_boSDMinimap then
    Exit;

  if GetTickCount > m_dwBlinkTime + 300 then
  begin
    m_dwBlinkTime := GetTickCount;
    m_boViewBlink := not m_boViewBlink;
  end;

  if TryGetMMap(g_nMiniMapIndex, DMap) then
  begin
    mx := (g_MySelf.m_nCurrX * 48) div 32;
    my := (g_MySelf.m_nCurrY * 32) div 32;

    drc := DMap.ClientRect;

    rc.Left := _Max(0, mx - (DMiniMapDrawPos.Width div 2));
    rc.Top := _Max(0, my - (DMiniMapDrawPos.Height div 2));
    rc.Right := _MIN(drc.Right, rc.Left + DMiniMapDrawPos.Width);
    rc.Bottom := _MIN(drc.Bottom, rc.Top + DMiniMapDrawPos.Height);

    if rc.Right - rc.Left < DMiniMapDrawPos.Width then
      rc.Left := rc.Right - DMiniMapDrawPos.Width;
    if rc.Bottom - rc.Top < DMiniMapDrawPos.Height then
      rc.Top := drc.Bottom - DMiniMapDrawPos.Height;

    ALeft := DMiniMapDrawPos.SurfaceX(DMiniMapDrawPos.Left);
    ATop := DMiniMapDrawPos.SurfaceY(DMiniMapDrawPos.Top);

    AMapRec := Bounds(ALeft, ATop, DMiniMapDrawPos.WIDTH,
      DMiniMapDrawPos.Height);

    if (DMap.Width < DMiniMapDrawPos.Width)  or (DMap.Height < DMiniMapDrawPos.Height) then
    begin
      AMapRec := DMiniMapDrawPos.ClientDrawRect;
      if g_boTransparentMiniMap then
        dsurface.Draw(drc, AMapRec, DMap, cAlpha4(120))
      else
        dsurface.Draw(drc, AMapRec, DMap, clWhite4);

      xScale := DMiniMapDrawPos.Width / DMap.Width;
      yScale := DMiniMapDrawPos.Height/ DMap.Height;
      rc := DMap.ClientRect;
    end else
    begin
      xScale := 1;
      yScale := 1;
      if g_boTransparentMiniMap then
        dsurface.DrawAlpha(ALeft, ATop, rc, DMap, 120)
      else
        dsurface.Draw(ALeft, ATop, rc, DMap, False);

    end;




    for nX := g_MySelf.m_nCurrX - 16 to g_MySelf.m_nCurrX + 16 do
    begin
      for nY := g_MySelf.m_nCurrY - 16 to g_MySelf.m_nCurrY + 16 do
      begin
        actor := PlayScene.FindActorXY(nX, nY);
        if (actor <> nil) and (actor <> g_MySelf) and
          (not actor.m_boDeath) then
        begin
          mx := Round(((actor.m_nCurrX * 48) div 32) * xScale)  - rc.Left;
          my := Round(((actor.m_nCurrY * 32) div 32) * yScale) - rc.Top;
          case actor.Race of
            0, 1:
              D := g_77Images.Images[111];
            12:
              D := g_77Images.Images[110];
            50:
              D := g_77Images.Images[113];
          else
            begin
              if (actor.m_boFriendly) then
                D := g_77Images.Images[113]
              else
                D := g_77Images.Images[112];
            end;
          end;
          if D <> nil then
            dsurface.Draw(ALeft + mx, ATop + my, D);
        end;
      end;
    end;

    for I := 0 to g_CurMapDesc.Count - 1 do
    begin
      if g_CurMapDesc.Items[I]._Type in [1, 2] then
      begin
        ATexture := FontManager.Default.TextOut(g_CurMapDesc.Items[I].Desc);
        if ATexture <> nil then
        begin
          mx := Round(((g_CurMapDesc.Items[I].MapX * 48) div 32) * xScale);
          my := Round(((g_CurMapDesc.Items[I].MapY * 32) div 32) * yScale);

          if (mx + ATexture.WIDTH div 2 >= rc.Left) and
            (mx - ATexture.WIDTH div 2 <= rc.Right) and
            (my + ATexture.Height div 2 >= rc.Top) and
            (my - ATexture.Height div 2 <= rc.Bottom) then
          begin
            dsurface.DrawBoldTextInRect(ALeft + mx - rc.Left -
              ATexture.WIDTH div 2, ATop + my - rc.Top -
              ATexture.Height div 2, AMapRec, ATexture,
              g_CurMapDesc.Items[I].Color, FontBorderColor);
          end;
        end;
      end;
    end;

    if m_boViewBlink then
    begin
      mx := Round(((g_MySelf.m_nCurrX * 48) div 32) * xScale) - rc.Left;
      my := Round(((g_MySelf.m_nCurrY * 32) div 32) * yScale) - rc.Top;
      D := g_77Images.Images[111];
      if D <> nil then
        dsurface.Draw(ALeft + mx, ATop + my, D);
    end;

    AStateTop := DWMiniMap.Height;
  end;

end;


procedure TFrmDlg.DMiniMapDrawPosMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  D: TAsphyreLockableTexture;
  rc, drc: TRect;
  mx, my: Integer;
begin
  X := X - DMiniMapDrawPos.Left;
  Y := Y - DMiniMapDrawPos.Top;
  if TryGetMMap(g_nMiniMapIndex, D) then
  begin
    if g_boSDMinimap and (g_btMiniMapType in [1, 2]) then
    begin
      case g_btMiniMapType of
        1:
          begin
            drc := D.ClientRect;
            mx := (g_MySelf.m_nCurrX * 48) div 32;
            my := (g_MySelf.m_nCurrY * 32) div 32;

            rc.Left := _Max(0, mx - (DMiniMapDrawPos.Width div 2));
            rc.Top := _Max(0, my - (DMiniMapDrawPos.Height div 2));
            rc.Right := _MIN(drc.Right, rc.Left + DMiniMapDrawPos.Width);
            rc.Bottom := _MIN(drc.Bottom, rc.Top + DMiniMapDrawPos.Height);
            if rc.Right - rc.Left < DMiniMapDrawPos.Width then
              rc.Left := rc.Right - DMiniMapDrawPos.Width;
            if rc.Bottom - rc.Top < DMiniMapDrawPos.Height then
              rc.Top := drc.Bottom - DMiniMapDrawPos.Height;
            g_nMouseMinMapX := ((rc.Left + X) *32) div 48;
            g_nMouseMinMapY := ((rc.Top + Y) * 32) div 32;
          end;
        2:
          begin
            g_nMouseMinMapX := Round(((X - (SCREENWIDTH - 200)) * 32) div 48 *
              (D.WIDTH / 200));
            g_nMouseMinMapY := Round((Y * 32 div 32) * (D.Height / 200));
          end;
      end;
    end
    else if g_boMiniMapExpand then
    begin
      drc := D.ClientRect;
      mx := (g_MySelf.m_nCurrX * 48) div 32;
      my := (g_MySelf.m_nCurrY * 32) div 32;

      rc.Left := _Max(0, mx - (DMiniMapDrawPos.Width div 2));
      rc.Top := _Max(0, my - (DMiniMapDrawPos.Height div 2));
      rc.Right := _MIN(drc.Right, rc.Left + DMiniMapDrawPos.Width);
      rc.Bottom := _MIN(drc.Bottom, rc.Top + DMiniMapDrawPos.Height);

      if rc.Right - rc.Left < DMiniMapDrawPos.Width then
        rc.Left := rc.Right - DMiniMapDrawPos.Width;
      if rc.Bottom - rc.Top < DMiniMapDrawPos.Height then
        rc.Top := drc.Bottom - DMiniMapDrawPos.Height;

      g_nMouseMinMapX := ((rc.Left + X) * 32) div 48;
      g_nMouseMinMapY := ((rc.Top  + Y) * 32) div 32;

     DMouseXYMiniMap.Propertites.Caption.Text := IntToStr(g_nMouseMinMapX) + ':' + IntToStr(g_nMouseMinMapY);
    end;
  end;
end;

procedure TFrmDlg.DMiniMap_SDDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
  D, DMap: TAsphyreLockableTexture;
  mx, my, nX, nY, I, AStateTop: Integer;
  rc, drc, AMapRec: TRect;
  actor: TActor;
  btColor: Byte;
  ATexture: TAsphyreLockableTexture;
  P: PPoint;
  XRate, YRate: Double;
  AMiniWidth, AMiniHeight: Integer;
  ALeft, ATop: Integer;
begin
  if not g_boSDMinimap then
    exit;

  if GetTickCount > m_dwBlinkTime + 300 then
  begin
    m_dwBlinkTime := GetTickCount;
    m_boViewBlink := not m_boViewBlink;
  end;

  if TryGetMMap(g_nMiniMapIndex, DMap) then
  begin

    mx := (g_MySelf.m_nCurrX * 48) div 32;
    my := (g_MySelf.m_nCurrY * 32) div 32;

    if g_btMiniMapType = 1 then
    begin

      drc := DMap.ClientRect;
      rc.Left := _Max(0, mx - (DMiniMap_SD.Width div 2));
      rc.Top := _Max(0, my - (DMiniMap_SD.Height div 2));
      rc.Right := _MIN(drc.Right, rc.Left + DMiniMap_SD.Width);
      rc.Bottom := _MIN(drc.Bottom, rc.Top + DMiniMap_SD.Height);

      ALeft := DMiniMap_SD.Left;
      ATop := DMiniMap_SD.Top;

      if (rc.Right - rc.Left) {RectWidth} < DMiniMap_SD.Width then
        rc.Left := rc.Right - DMiniMap_SD.Width;
//      if (rc.Bottom - rc.Top {RectHeight}) < DMiniMap_SD.Height then
//        rc.Top := drc.Bottom - DMiniMap_SD.Height;


      AMapRec := Bounds(ALeft, ATop, DMiniMap_SD.Width, DMiniMap_SD.Height);
      if g_boTransparentMiniMap then
        dsurface.DrawAlpha(ALeft, ATop, rc, DMap, 120)
      else
        dsurface.Draw(ALeft, ATop, rc, DMap, False);

      for nX := g_MySelf.m_nCurrX - 16 to g_MySelf.m_nCurrX + 16 do
      begin
        for nY := g_MySelf.m_nCurrY - 16 to g_MySelf.m_nCurrY + 16 do
        begin
          actor := PlayScene.FindActorXY(nX, nY);
          if (actor <> nil) and (actor <> g_MySelf) and
            (not actor.m_boDeath) then
          begin
            mx := (actor.m_nCurrX * 48) div 32 - rc.Left;
            my := (actor.m_nCurrY * 32) div 32 - rc.Top;
            case actor.Race of
              0, 1:
                D := g_77Images.Images[111];
              12:
                D := g_77Images.Images[110];
              50:
                D := g_77Images.Images[113];
            else
              begin
                if (actor.m_boFriendly) then
                  D := g_77Images.Images[113]
                else
                  D := g_77Images.Images[112];
              end;
            end;
            if D <> nil then
              dsurface.Draw(ALeft + mx, ATop + my, D);
          end;
        end;
      end;

      for I := 0 to g_CurMapDesc.Count - 1 do
      begin
        if g_CurMapDesc.Items[I]._Type in [1, 2] then
        begin
          ATexture := FontManager.Default.TextOut(g_CurMapDesc.Items[I].Desc);
          if ATexture <> nil then
          begin
            mx := (g_CurMapDesc.Items[I].MapX * 48) div 32;
            my := (g_CurMapDesc.Items[I].MapY * 32) div 32;
            if (mx + ATexture.WIDTH div 2 >= rc.Left) and
              (mx - ATexture.WIDTH div 2 <= rc.Right) and
              (my + ATexture.Height div 2 >= rc.Top) and
              (my - ATexture.Height div 2 <= rc.Bottom) then
            begin
              dsurface.DrawBoldTextInRect(ALeft + mx - rc.Left -
                ATexture.WIDTH div 2, ATop + my - rc.Top -
                ATexture.Height div 2, AMapRec, ATexture,
                g_CurMapDesc.Items[I].Color, FontBorderColor);
            end;
          end;
        end;
      end;

      if m_boViewBlink then
      begin
        mx := (g_MySelf.m_nCurrX * 48) div 32 - rc.Left;
        my := (g_MySelf.m_nCurrY * 32) div 32 - rc.Top;
        D := g_77Images.Images[111];
        if D <> nil then
          dsurface.Draw(ALeft + mx, ATop + my, D);
      end;
    end else if g_btMiniMapType = 2 then
    begin

      rc := DMap.ClientRect;
      AMapRec := Bounds(SCREENWIDTH - SD_MMapWidth_2, 0, SD_MMapWidth_2, SD_MMapHeight_2);
      if g_boTransparentMiniMap then
        dsurface.Draw(DMap.ClientRect, AMapRec, DMap, cAlpha4(120))
      else
        dsurface.Draw(DMap.ClientRect, AMapRec, DMap, clWhite4);
      XRate := SD_MMapWidth_2 / DMap.WIDTH;
      YRate := SD_MMapHeight_2 / DMap.Height;
      ALeft := SCREENWIDTH - 200;
      for I := 0 to g_CurMapDesc.Count - 1 do
      begin
        if g_CurMapDesc.Items[I]._Type = 2 then
        begin
          ATexture := FontManager.Default.TextOut(g_CurMapDesc.Items[I].Desc);
          if ATexture <> nil then
          begin
            mx := Round(((g_CurMapDesc.Items[I].MapX * 48) div 32) * XRate);
            my := Round(((g_CurMapDesc.Items[I].MapY * 32) div 32) * YRate);
            if (mx + ATexture.WIDTH div 2 >= rc.Left) and
              (mx - ATexture.WIDTH div 2 <= rc.Right) and
              (my + ATexture.Height div 2 >= rc.Top) and
              (my - ATexture.Height div 2 <= rc.Bottom) then
            begin
              dsurface.DrawBoldTextInRect(ALeft + mx - rc.Left -
                ATexture.WIDTH div 2, my - rc.Top - ATexture.Height div 2,
                AMapRec, ATexture, g_CurMapDesc.Items[I].Color,
                FontBorderColor);
            end;
          end;
        end;
      end;

      for I := g_uPointList.Count - 1 downto 0 do
      begin
        P := g_uPointList.Items[I];
        if (P <> nil) and PtInRect(rc, P^) then
          dsurface.PixelsOut(ALeft + Round((P.X * 48) div 32 * XRate),
            ATop + Round(P.Y * YRate), clRed, 2);
      end;

      if m_boViewBlink then
      begin
        mx := Round((g_MySelf.m_nCurrX * 48) div 32 * XRate);
        my := Round((g_MySelf.m_nCurrY * 32) div 32 * YRate);
        D := g_77Images.Images[111];
        if D <> nil then
          dsurface.Draw(ALeft + mx - 2, my - 2, D);
      end;
    end;

  end;
end;

procedure TFrmDlg.DMiniMap_SDMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    g_boTransparentMiniMap := not g_boTransparentMiniMap;
  end;
end;

procedure TFrmDlg.DMinusDCClick(Sender: TObject; X, Y: Integer);
var
  decp: Integer;
begin
  if IsKeyPressed(VK_CONTROL) and (g_nBonusPoint - 10 > 0) then
    decp := 10
  else
    decp := 1;
  if Sender = DMinusDC then
    if g_BonusAbilChg.DC >= decp then
    begin
      Dec(g_BonusAbilChg.DC, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusMC then
    if g_BonusAbilChg.MC >= decp then
    begin
      Dec(g_BonusAbilChg.MC, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusSC then
    if g_BonusAbilChg.SC >= decp then
    begin
      Dec(g_BonusAbilChg.SC, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusTC then
    if g_BonusAbilChg.Tc >= decp then
    begin
      Dec(g_BonusAbilChg.Tc, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusPC then
    if g_BonusAbilChg.Pc >= decp then
    begin
      Dec(g_BonusAbilChg.Pc, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusWC then
    if g_BonusAbilChg.Wc >= decp then
    begin
      Dec(g_BonusAbilChg.Wc, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusAC then
    if g_BonusAbilChg.AC >= decp then
    begin
      Dec(g_BonusAbilChg.AC, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusMAC then
    if g_BonusAbilChg.MAC >= decp then
    begin
      Dec(g_BonusAbilChg.MAC, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusHP then
    if g_BonusAbilChg.HP >= decp then
    begin
      Dec(g_BonusAbilChg.HP, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusMP then
    if g_BonusAbilChg.MP >= decp then
    begin
      Dec(g_BonusAbilChg.MP, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusHit then
    if g_BonusAbilChg.Hit >= decp then
    begin
      Dec(g_BonusAbilChg.Hit, decp);
      Inc(g_nBonusPoint, decp);
    end;
  if Sender = DMinusSpeed then
    if g_BonusAbilChg.Speed >= decp then
    begin
      Dec(g_BonusAbilChg.Speed, decp);
      Inc(g_nBonusPoint, decp);
    end;
  ChangeBonusPointButtonsState;
  SetBottomButtonsPosition;
end;

procedure TFrmDlg.DMissionContentCommandLinkClick(Sender: TObject;
  const Command: string);
begin
  g_SoundManager.DXPlaySound(s_glass_button_click);
  if Command <> '' then
  begin
    if pos('@LINK:', UpperCase(Command)) = 1 then
      OpenBrowser(Copy(Command, 7, Length(Command) - 6))
    else
      FrmMain.SendMissionCommandSelect(Command);
  end;
end;

procedure TFrmDlg.DMissionListClick(Sender: TObject; X, Y: Integer);
begin
  case DBMissionDoing.Tag of
    0:
      begin
        if (g_MissionListSelected >= 0) and
          (g_MissionListSelected < g_Missions.UnDoCount) then
        begin
          g_MissionListFocused := g_MissionListSelected;
          UpdateMissionContent;
          g_SoundManager.DXPlaySound(s_glass_button_click);
          Exit;
        end;
      end;
    1:
      begin
        if (g_MissionListSelected >= 0) and
          (g_MissionListSelected < g_Missions.DoingCount) then
        begin
          g_MissionListFocused := g_MissionListSelected;
          UpdateMissionContent;
          g_SoundManager.DXPlaySound(s_glass_button_click);
          Exit;
        end;
      end;
  end;
  DMissionContent.Lines.Clear;
  g_MissionListFocused := -1;
end;

procedure TFrmDlg.DMissionListDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  I, X, Y, OX: Integer;
  ATexture: TAsphyreLockableTexture;
  r: TRect;
  AMissionItem: TMissionItem;
  ALinkItem: TMissionLinkItem;
begin
  if g_MissionListTopIndex >= 0 then
  begin
    Y := DMissionList.SurfaceY(DMissionList.Top);
    X := DMissionList.SurfaceX(DMissionList.Left);
    if (g_MissionListSelected > -1) and
      (g_MissionListSelected - g_MissionListTopIndex in [0 .. 16]) then
    begin
      r := Bounds(X, Y + (g_MissionListSelected - g_MissionListTopIndex) * 16 +
        4, DMissionList.WIDTH, 16);
      g_GameCanvas.FillRectAlpha(r, $00A0A0A0, 125);
    end;
    if (g_MissionListFocused > -1) and
      (g_MissionListFocused - g_MissionListTopIndex in [0 .. 16]) then
    begin
      r := Bounds(X, Y + (g_MissionListFocused - g_MissionListTopIndex) * 16 +
        4, DMissionList.WIDTH, 16);
      g_GameCanvas.FillRectAlpha(r, $00E85700, 175);
    end;

    case DBMissionDoing.Tag of
      0:
        begin
          for I := 0 to 16 do
          begin
            if I + g_MissionListTopIndex > g_Missions.UnDoCount - 1 then
              Break;
            ALinkItem := g_Missions.UnDo[g_MissionListTopIndex + I];
            OX := 0;
            ATexture := FontManager.
              Default.TextOut(_MISSION_KINDS_[ALinkItem.Kind]);
            if ATexture <> nil then
            begin
              dsurface.DrawText(X + 6, Y + 6, ATexture,
                _MISSION_COLOR_[ALinkItem.Kind]);
              OX := ATexture.WIDTH + 2;

              ATexture := FontManager.Default.TextOut(ALinkItem.Subject);
              if ATexture <> nil then
              begin
                dsurface.Draw(X + 6 + OX, Y + 6, ATexture);
                Y := Y + 16;
              end;
            end;
          end;
        end;
      1:
        begin
          for I := 0 to 16 do
          begin
            if I + g_MissionListTopIndex > g_Missions.DoingCount - 1 then
              Break;
            AMissionItem := g_Missions.Doing[g_MissionListTopIndex + I];
            OX := 0;
            ATexture := FontManager.
              Default.TextOut(_MISSION_KINDS_[AMissionItem.Kind]);
            if ATexture <> nil then
            begin
              dsurface.DrawText(X + 6, Y + 6, ATexture,
                _MISSION_COLOR_[AMissionItem.Kind]);
              OX := ATexture.WIDTH;

              ATexture := FontManager.Default.TextOut(AMissionItem.Subject);
              if ATexture <> nil then
              begin
                dsurface.Draw(X + 6 + OX, Y + 6, ATexture);
                Y := Y + 16;
              end;
            end;
          end;
        end;
    end;
  end;
end;

procedure TFrmDlg.DMissionListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  AIndex: Integer;
begin
  X := X - DMissionList.Left;
  Y := Y - DMissionList.Top;
  g_MissionListSelected := -1;
  if (X > 4) and (Y > 6) then
  begin
    AIndex := (Y - 6) div 16;
    if AIndex in [0 .. 16] then
    begin
      g_MissionListSelected := g_MissionListTopIndex + AIndex;
      case DBMissionDoing.Tag of
        0:
          begin
            if g_MissionListSelected > g_Missions.UnDoCount - 1 then
              g_MissionListSelected := -1;
          end;
        1:
          begin
            if g_MissionListSelected > g_Missions.DoingCount - 1 then
              g_MissionListSelected := -1;
          end;
      end;
    end;
  end;
  DScreen.ClearHint;
end;

procedure TFrmDlg.DAdjustAbilOkClick(Sender: TObject; X, Y: Integer);
begin
  FrmMain.SendAdjustBonus(g_nBonusPoint, g_BonusAbilChg);
  DAdjustAbility.visible := False;
end;

procedure TFrmDlg.DAdjustAbilityMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DAdjustAbilityVisibleChange(Sender: TObject);
begin
  if DAdjustAbility.visible and (g_MySelf <> nil) then
  begin
    ChangeBonusPointButtonsState;
  end;
end;

procedure TFrmDlg.DBotMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
const
  NeedLev = '需要内功等级%d级';
var
  nLocalY: Integer;
  nHintX, nHintY, nTag: Integer;
  Butt: TDButton;
  sMsg, sMsg1, sMsg2: String;
  Int: Integer;
begin
  // if g_MySelf = nil then
  // Exit;
  // // g_boHintDragonPoint := False;  20080619
  // sMsg := '';
  // sMsg1 := '';
  // sMsg2 := '';
  // Butt := TDButton(Sender);
  // sMsg := Butt.Hint;
  // if Sender = buttUseBatter then
  // begin
  // if g_boCanUseBatter then
  // sMsg := '当前可以释放连击！！！'
  // else
  // sMsg := '当前不可以释放连击！！！';
  // end;
  //
  // if (sMsg <> '') and ((Sender = RefusePublicChat) or (Sender = RefuseCRY) or
  // (Sender = RefuseWHISPER) or (Sender = Refuseguild) or
  // (Sender = AutoCRY)) then
  // begin
  // with Butt as TDButton do
  // DScreen.ShowHint(Butt.SurfaceX(Butt.Left) - Canvas.TextWidth(sMsg) - 8,
  // Butt.SurfaceY(Butt.Top), sMsg);
  // Exit;
  // end;
  //
  // if Sender = DBottom then
  // begin
  // if ((X >= SCREENWIDTH - 135) and (X <= SCREENWIDTH - 96)) and
  // ((Y >= SCREENHEIGHT - 108) and (Y <= SCREENHEIGHT - 92)) then
  // begin
  // sMsg := '当前等级';
  // nHintX := SCREENWIDTH - 135;
  // nHintY := SCREENHEIGHT - 92 + 20;
  // DScreen.ShowHint(nHintX, nHintY, sMsg);
  // Exit;
  // end
  // else if ((X >= SCREENWIDTH - 135) and (X <= SCREENWIDTH - 55)) and
  // ((Y >= SCREENHEIGHT - 77) and (Y <= SCREENHEIGHT - 63)) then
  // begin
  // sMsg := '当前经验';
  // nHintX := SCREENWIDTH - 135;
  // nHintY := SCREENHEIGHT - 63 + 20;
  // DScreen.ShowHint(nHintX, nHintY,
  // sMsg + FloatToStrFixFmt(100 * g_MySelf.m_Abil.Exp /
  // g_MySelf.m_Abil.MaxExp, 3, 2) + '%');
  // Exit;
  // end
  // else if ((X >= SCREENWIDTH - 135) and (X <= SCREENWIDTH - 55)) and
  // ((Y >= SCREENHEIGHT - 44) and (Y <= SCREENHEIGHT - 28)) then
  // begin
  // sMsg := Format('包裹负重%d/%d', [g_MySelf.m_Abil.Weight,
  // g_MySelf.m_Abil.MaxWeight]);
  // nHintX := SCREENWIDTH - 135;
  // nHintY := SCREENHEIGHT - 28 + 20;
  // DScreen.ShowHint(nHintX, nHintY, sMsg);
  // Exit;
  // end;
  // end;
  //
  // nTag := (Sender as TDButton).Tag;
  // if (Sender = OpenmaiButt1) then
  // begin
  // case BatterPage of
  // 0:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 0 then
  // begin
  // sMsg1 := '幽门穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 0 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '幽门穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '幽门穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end;
  // end;
  // 1:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 0 then
  // begin
  // sMsg1 := '晴阴穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 0 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '晴阴穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '晴阴穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end;
  // end;
  // 2:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 0 then
  // begin
  // sMsg1 := '廉泉穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 0 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '廉泉穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '廉泉穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end;
  // end;
  // 3:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 0 then
  // begin
  // sMsg1 := '承浆穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 0 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '承浆穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '承浆穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end;
  // end;
  // end;
  // end;
  //
  // if (Sender = OpenMaiButt2) then
  // begin
  // case BatterPage of
  // 0:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 1 then
  // begin
  // sMsg1 := '通谷穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 1 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '通谷穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '通谷穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 1 then
  // begin
  // sMsg2 := '通谷穴：当前不可打通';
  // end;
  // end;
  // 1:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 1 then
  // begin
  // sMsg1 := '盘缺穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 1 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '盘缺穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '盘缺穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 1 then
  // begin
  // sMsg2 := '盘缺穴：当前不可打通';
  // end;
  // end;
  // 2:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 1 then
  // begin
  // sMsg1 := '期门穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 1 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '期门穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '期门穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 1 then
  // begin
  // sMsg2 := '期门穴：当前不可打通';
  // end;
  // end;
  // 3:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 1 then
  // begin
  // sMsg1 := '天突穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 1 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '天突穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '天突穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 1 then
  // begin
  // sMsg2 := '天突穴：当前不可打通';
  // end;
  // end;
  // end;
  // end;
  //
  // if (Sender = OpenMaiButt3) then
  // begin
  // case BatterPage of
  // 0:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 3 then
  // begin
  // sMsg1 := '商曲穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 3 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '商曲穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '商曲穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 3 then
  // begin
  // sMsg2 := '商曲穴：当前不可打通';
  // end;
  // end;
  // 1:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 2 then
  // begin
  // sMsg1 := '交信穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 2 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '交信穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '交信穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 2 then
  // begin
  // sMsg2 := '交信穴：当前不可打通';
  // end;
  // end;
  // 2:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 2 then
  // begin
  // sMsg1 := '府舍穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 2 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '府舍穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '府舍穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 2 then
  // begin
  // sMsg2 := '府舍穴：当前不可打通';
  // end;
  // end;
  // 3:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 2 then
  // begin
  // sMsg1 := '鸠尾穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 2 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '鸠尾穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '鸠尾穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 2 then
  // begin
  // sMsg2 := '鸠尾穴：当前不可打通';
  // end;
  // end;
  // end;
  // end;
  //
  // if (Sender = OpenMaiButt4) then
  // begin
  // case BatterPage of
  // 0:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 4 then
  // begin
  // sMsg1 := '四满穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 4 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '四满穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '四满穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 4 then
  // begin
  // sMsg2 := '四满穴：当前不可打通';
  // end;
  // end;
  // 1:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 3 then
  // begin
  // sMsg1 := '照海穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 3 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '照海穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '照海穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 3 then
  // begin
  // sMsg2 := '照海穴：当前不可打通';
  // end;
  // end;
  // 2:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 3 then
  // begin
  // sMsg1 := '冲门穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 3 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '冲门穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '冲门穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 3 then
  // begin
  // sMsg2 := '冲门穴：当前不可打通';
  // end;
  // end;
  // 3:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 3 then
  // begin
  // sMsg1 := '气海穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 3 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '气海穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '气海穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 3 then
  // begin
  // sMsg2 := '气海穴：当前不可打通';
  // end;
  // end;
  // end;
  // end;
  //
  // if (Sender = OpenMaiButt5) then
  // begin
  // case BatterPage of
  // 0:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 2 then
  // begin
  // sMsg1 := '横骨穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 2 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '横骨穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '横骨穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 2 then
  // begin
  // sMsg2 := '横骨穴：当前不可打通';
  // end;
  // end;
  // 1:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 4 then
  // begin
  // sMsg1 := '然谷穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 4 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '然谷穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '然谷穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 4 then
  // begin
  // sMsg2 := '然谷穴：当前不可打通';
  // end;
  // end;
  // 2:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 4 then
  // begin
  // sMsg1 := '筑宾穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 4 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '筑宾穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '筑宾穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 4 then
  // begin
  // sMsg2 := '筑宾穴：当前不可打通';
  // end;
  // end;
  // 3:
  // begin
  // if g_MyPulse[BatterPage].Pulse > 4 then
  // begin
  // sMsg1 := '曲骨穴：已打通';
  // end
  // else if g_MyPulse[BatterPage].Pulse = 4 then
  // begin
  // if g_btInternalForceLevel >= g_OpenPulseNeedLev
  // [BatterPage * 5 + nTag] then
  // begin
  // sMsg1 := '曲骨穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end
  // else
  // begin
  // sMsg2 := '曲骨穴：待打通\' + Format(NeedLev,
  // [g_OpenPulseNeedLev[BatterPage * 5 + nTag]]);
  // end;
  // end
  // else if g_MyPulse[BatterPage].Pulse < 4 then
  // begin
  // sMsg2 := '曲骨穴：当前不可打通';
  // end;
  // end;
  // end;
  // end;
  //
  // if sMsg <> '' then
  // begin
  // if pos('\', sMsg) > 0 then
  // nLocalY := 12
  // else
  // nLocalY := 0;
  //
  // with Butt as TDButton do
  // DScreen.ShowHint(Butt.SurfaceX(Butt.Left),
  // Butt.SurfaceY(Butt.Top - 20 - nLocalY), sMsg);
  // end;
  //
  // if sMsg1 <> '' then
  // begin
  // if pos('\', sMsg1) > 0 then
  // nLocalY := 12
  // else
  // nLocalY := 0;
  //
  // with Butt as TDButton do
  // DScreen.ShowHint(Butt.SurfaceX(Butt.Left),
  // Butt.SurfaceY(Butt.Top - 20 - nLocalY), '{S=' + sMsg1 + ';C=251}');
  // end;
  //
  // if sMsg2 <> '' then
  // begin
  // if pos('\', sMsg2) > 0 then
  // nLocalY := 12
  // else
  // nLocalY := 0;
  //
  // with Butt as TDButton do
  // DScreen.ShowHint(Butt.SurfaceX(Butt.Left),
  // Butt.SurfaceY(Butt.Top - 20 - nLocalY), '{S=' + sMsg2 + ';C=249}');
  // end;
end;

procedure TFrmDlg.DBotFriendClick(Sender: TObject; X, Y: Integer);
begin
  OpenFriendDlg();
end;

procedure TFrmDlg.OpenFriendDlg();
begin
  DFriendDlg.Left := SCREENWIDTH - DFriendDlg.WIDTH;
  DFriendDlg.Top := (SCREENHEIGHT - DFriendDlg.Height - DBottom.Height) DIV 2;
  DFriendDlg.visible := not DFriendDlg.visible;
end;

procedure TFrmDlg.DFashionUS1DirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ax, bbx, bby, ay, sex, nColor: Integer;
begin
  with DFashionUS1 do
  begin
    bbx := Left + Propertites.OffsetX;
    bby := Top + Propertites.OffsetY;
    sex := GenderFeature(UserState1.Feature);
    if UserState1.UseItems[U_FASHION].Name <> '' then
    begin
      D := GetDressStateItemImgXY(UserState1.job, sex,
        UserState1.UseItems[U_FASHION], ax, ay);

      if D <> nil then
      begin
        nColor := GetRGB(UserState1.BodyBlendColor);
        if nColor > 0 then
        begin
          dsurface.DrawColor(SurfaceX(bbx + ax), SurfaceY(bby + ay), D, nColor);
        end
        else
        begin
          dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
            D.ClientRect, D, True);
        end;
      end;

//      if UserDressInnerEffect <> nil then
//        UserDressInnerEffect.Draw(dsurface, SurfaceX(bbx), SurfaceY(bby))
//      else
        DressStateDrawBlend(UserState1.UseItems[U_FASHION].S.Shape,
          UserState1.UseItems[U_FASHION].AniCount, TimeTick, dsurface,
          SurfaceX(bbx), SurfaceY(bby));
    end;
  end;
end;

procedure TFrmDlg.DFrdCloseClick(Sender: TObject; X, Y: Integer);
begin
  DFriendDlg.visible := False;
end;

procedure TFrmDlg.DChgGamePwdCloseClick(Sender: TObject; X, Y: Integer);
begin
  DChgGamePwd.visible := False;
end;

procedure TFrmDlg.DChgGamePwdDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with Sender as TDWindow do
  begin
    if Propertites.Images <> nil then
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;
    D := FontManager.Default.TextOut('GamePoint');
    dsurface.DrawBoldText(SurfaceX(Left + 15), SurfaceY(Top + 13), D,
      clYellow, clBlack);
    D := FontManager.Default.TextOut('GameGold');
    dsurface.DrawBoldText(SurfaceX(Left + 12), SurfaceY(Top + 190), D,
      clYellow, clBlack);
  end;
end;

// 召唤英雄
procedure TFrmDlg.CallHeroClick(Sender: TObject; X, Y: Integer);
begin
end;

// 拒绝行会聊天信息
procedure TFrmDlg.RefuseguildClick(Sender: TObject; X, Y: Integer);
begin
  if g_Refuseguild then
  begin
    g_Refuseguild := False;
  end
  else
  begin
    g_Refuseguild := True;
  end;
  FrmMain.SendMessageState(3, g_Refuseguild);
end;

// 拒绝私聊
procedure TFrmDlg.RefuseWHISPERClick(Sender: TObject; X, Y: Integer);
begin
  if g_RefuseWHISPER then
  begin
    g_RefuseWHISPER := False;
  end
  else
  begin
    g_RefuseWHISPER := True;
  end;

  FrmMain.SendMessageState(2, g_RefuseWHISPER);
end;

procedure TFrmDlg.HeroStateClick(Sender: TObject; X, Y: Integer);
begin
end;

// 关闭英雄信息栏
procedure TFrmDlg.DCloseHeroStateClick(Sender: TObject; X, Y: Integer);
// 清清$008 2007.10.21
begin
end;

// 英雄装备栏绘制   新版状态栏  20100108 邱高奇
procedure TFrmDlg.DCloseMaxMiniMapClick(Sender: TObject; X, Y: Integer);
begin
  g_ISOpenMaxMiniMap := False;
  DWMaxMiniMap.visible := False;
end;


//procedure TFrmDlg.DCloseMaxMiniMapDirectPaint(Sender: TObject;
//  dsurface: TAsphyreCanvas);
//var
//  D: TAsphyreLockableTexture;
//begin
//  with DCloseMaxMiniMap do
//  begin
//    if Downed then
//      D := Propertites.Images[Propertites.DownedIndex]
//    else
//      D := Propertites.Images[Propertites.ImageIndex];
//    if D <> nil then
//      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
//  end;
//end;

// 鼠标在装备栏某个装备上移动显示过程
procedure TFrmDlg.HeroPackageClick(Sender: TObject; X, Y: Integer);
begin
end;

// 英雄显示装备
procedure TFrmDlg.DHeroItemBagDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
end;

// 英雄包裹绘制
procedure TFrmDlg.DHeroItemGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
begin
end;

// 鼠标移动过程，鼠标经过某个物品上显示
procedure TFrmDlg.DHeroItemGridGridMouseMove(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
begin
end;

// 移动英雄装备
procedure TFrmDlg.DSHWeaponClick(Sender: TObject; X, Y: Integer);
begin
end;

// 英雄翻页码过程 清清$013 2007.10.21
procedure TFrmDlg.RefusePublicChatClick(Sender: TObject; X, Y: Integer);
begin
  g_boOwnerMsg := not g_boOwnerMsg;
  if g_boOwnerMsg then
  begin
    FrmMain.AddChatBoardString('【提示】[禁止接收公聊]', GetRGB(219), clWhite);
  end
  else
  begin
    FrmMain.AddChatBoardString('【提示】[允许接收公聊]', GetRGB(219), clWhite);
  end;
end;

procedure TFrmDlg.DHeroItemGridDblClick(Sender: TObject);
begin
end;

// 英雄图标性别 职业 图象区分    清清 2007.11.2  代码$005
function TFrmDlg.HeroIcon(sex: Integer; job: Integer): Integer;
begin
  case sex of
    0:
      Result := 365 + job;
    1:
      Result := 368 + job;
  end;
end;

// 英雄怒气变换函数
procedure TFrmDlg.typeTimeimg;
begin
  if GetTickCount - typetime > 500 then
  begin
    typetime := GetTickCount;
    Inc(imginsex);
    if imginsex > 1 then
      imginsex := 0;
  end;
  if GetTickCount - BatterTime > 200 then
  begin
    BatterTime := GetTickCount;
    Inc(BatterImage);
    if BatterImage > 1 then
      BatterImage := 0;
  end;
end;

procedure TFrmDlg.UIGetPass(var Pass: String; var Handled: Boolean);
begin
  Pass := g_MirStartupInfo.sUIPakKey;
  Handled := True;
end;

procedure TFrmDlg.UIMoveInCommandNode(Sender: TObject;
  ACommandNode: TMessageNode; X, Y: Integer);
begin
  if ACommandNode <> nil then
  begin
    if ACommandNode.Item.Name <> '' then
    begin
       if ACommandNode.Hint <> '' then
       begin
         if DScreen.ItemHint then
          begin
            g_MouseItem.Name := '';
            DScreen.ClearHint;
          end;
          DScreen.ShowHint(g_Application._CurPos, ACommandNode.Hint);
       end else
       begin
          if (ACommandNode.Item.MakeIndex = g_MouseItem.MakeIndex) and
            DScreen.ItemHint then
            DScreen.UpdateItemHintPostion(g_Application._CurPos)
          else
          begin
            DScreen.ClearHint;
            g_MouseItem := ACommandNode.Item;
            if ACommandNode.ItemFromE and (g_MouseItem.S.StdMode = 34) then  //{E=聚灵珠} 展示出来的物品要显示 可存储不能显示满的
              DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkShowCommondE)
            else
              DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
          end;
       end;
    end
    else
    begin
      if ACommandNode.Hint <> '' then
      begin
        if DScreen.ItemHint then
        begin
          g_MouseItem.Name := '';
          DScreen.ClearHint;
        end;
        DScreen.ShowHint(g_Application._CurPos, ACommandNode.Hint);
      end
      else
      begin
        g_MouseItem.Name := '';
        DScreen.ClearHint;
      end;
    end;
  end
  else
  begin
    g_MouseItem.Name := '';
    DScreen.ClearHint;
  end;
end;

procedure TFrmDlg.UIMoveInHint(Sender: TObject; const Hint: String;
  X, Y: Integer);
begin
  if (Hint <> '') and (g_MouseItem.Name = '') then
  begin
    DScreen.ShowHint(g_Application._CurPos, Hint);
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.UIWinSelectClick(ANpc: Integer;
  const Selected, WinName, ItemIndexes: String);
begin
  // if ANpc <> -1 then
  // FrmMain.SendMerchantDlgSelect(ANpc, Selected, WinName, ItemIndexes)
  // else
  FrmMain.SendMerchantDlgSelect(g_nCurMerchant, Selected, WinName, ItemIndexes);
end;

procedure TFrmDlg.UpdateChatSroll;
var
  H: Single;
begin
  if DScreen.ChatMessage.Count > 0 then
  begin
    H := (DChatScrollBottom.Top - DChatScrollTop.Top - DChatScrollTop.Height -
      DChatScroll.Height) / DScreen.ChatMessage.Count;
    DChatScroll.Top := DChatScrollTop.Top + DChatScrollTop.Height +
      Round(H * DScreen.ChatMessage.TopLine);
    // H := (DChatScrollBottom.Top - DChatScrollTop.Top - DChatScrollTop.Height -
    // DChatScroll.Height) / DScreen.ChatMessage.Height;
    // DChatScroll.Top := DChatScrollTop.Top + DChatScrollTop.Height +
    // Round(H * DScreen.ChatMessage.Height);

    if DChatScroll.Top < DChatScrollTop.Top + DChatScrollTop.Height then
      DChatScroll.Top := DChatScrollTop.Top + DChatScrollTop.Height
    else if DChatScroll.Top > DChatScrollBottom.Top - DChatScroll.Height then
      DChatScroll.Top := DChatScrollBottom.Top - DChatScroll.Height;
  end;
end;

procedure TFrmDlg.UpdateChatHisSroll;
var
  H: Single;
begin
  if DScreen.ChatHisMessage.Count > 0 then
  begin
    H := (DBChatHistoryScrollBottom.Top - DBChatHistoryScrollTop.Top -
      DBChatHistoryScrollTop.Height - DBChatHistoryScrollBar.Height) /
      DScreen.ChatHisMessage.Count;
    DBChatHistoryScrollBar.Top := DBChatHistoryScrollTop.Top +
      DBChatHistoryScrollTop.Height + Round(H * DScreen.ChatHisMessage.TopLine);
    if DBChatHistoryScrollBar.Top < DBChatHistoryScrollTop.Top +
      DBChatHistoryScrollTop.Height then
      DBChatHistoryScrollBar.Top := DBChatHistoryScrollTop.Top +
        DBChatHistoryScrollTop.Height
    else if DBChatHistoryScrollBar.Top > DBChatHistoryScrollBottom.Top -
      DBChatHistoryScrollBar.Height then
      DBChatHistoryScrollBar.Top := DBChatHistoryScrollBottom.Top -
        DBChatHistoryScrollBar.Height;
  end;
end;

procedure TFrmDlg.UpdateMailListScroll;
var
  H: Single;
begin
  if g_Mail.Count > 0 then
  begin
    H := (DBMLBottom.Top - DBMLTop.Top - DBMLTop.Height - DBMLScroll.Height) /
      g_Mail.Count;
    DBMLScroll.Top := DBMLTop.Top + DBMLTop.Height + Round(H * g_Mail.TopIndex);
    if DBMLScroll.Top < DBMLTop.Top + DBMLTop.Height then
      DBMLScroll.Top := DBMLTop.Top + DBMLTop.Height
    else if DBMLScroll.Top > DBMLBottom.Top - DBMLScroll.Height then
      DBMLScroll.Top := DBMLBottom.Top - DBMLScroll.Height;
  end;
end;

procedure TFrmDlg.UpdateMailReadScroll;
var
  H: Single;
begin
  if DMMReader.Lines.Count > 0 then
  begin
    H := (DBRMBottom.Top - DBRMTop.Top - DBRMTop.Height - DBRMScroll.Height) /
      DMMReader.Lines.Count;
    DBRMScroll.Top := DBRMTop.Top + DBRMTop.Height +
      Round(H * DMMReader.TopLine);
    if DBRMScroll.Top < DBRMTop.Top + DBRMTop.Height then
      DBRMScroll.Top := DBRMTop.Top + DBRMTop.Height
    else if DBRMScroll.Top > DBRMBottom.Top - DBRMScroll.Height then
      DBRMScroll.Top := DBRMBottom.Top - DBRMScroll.Height;
  end;
end;

procedure TFrmDlg.UpdateMailWriteScroll;
var
  H: Single;
begin
  if DMMailEdit.Lines.Count > 0 then
  begin
    H := (DBWMBottom.Top - DBWMTop.Top - DBWMTop.Height - DBWMScroll.Height) /
      DMMailEdit.Lines.Count;
    DBWMScroll.Top := DBWMTop.Top + DBWMTop.Height +
      Round(H * DMMailEdit.TopLine);
    if DBWMScroll.Top < DBWMTop.Top + DBWMTop.Height then
      DBWMScroll.Top := DBWMTop.Top + DBWMTop.Height
    else if DBWMScroll.Top > DBWMBottom.Top - DBWMScroll.Height then
      DBWMScroll.Top := DBWMBottom.Top - DBWMScroll.Height;
  end;
end;

procedure TFrmDlg.UpdateMiniMissionsScroll;
var
  H: Single;
begin
  if g_Missions.DoingCount > 0 then
  begin
    H := (DBMissionsBottom.Top - DBMissionsTop.Top - DBMissionsTop.Height -
      DBMissionsScroll.Height) / g_Missions.DoingCount;
    DBMissionsScroll.Top := DBMissionsTop.Top + DBMissionsTop.Height +
      Round(H * g_MissionTopIndex);
    if DBMissionsScroll.Top < DBMissionsTop.Top + DBMissionsTop.Height then
      DBMissionsScroll.Top := DBMissionsTop.Top + DBMissionsTop.Height
    else if DBMissionsScroll.Top > DBMissionsBottom.Top -
      DBMissionsScroll.Height then
      DBMissionsScroll.Top := DBMissionsBottom.Top - DBMissionsScroll.Height;
  end;
end;

procedure TFrmDlg.UpdateStallLogScroll;
var
  H: Single;
begin
  if g_StallLogs.Count > 0 then
  begin
    H := (DWStallWinScrollBottom.Top - DWStallWinScrollTop.Top -
      DWStallWinScrollTop.Height - DWStallWinScrollBar.Height) /
      g_StallLogs.Count;
    DWStallWinScrollBar.Top := DWStallWinScrollTop.Top +
      DWStallWinScrollTop.Height + Round(H * FStallLogTopLine);
    if DWStallWinScrollBar.Top < DWStallWinScrollTop.Top +
      DWStallWinScrollTop.Height then
      DWStallWinScrollBar.Top := DWStallWinScrollTop.Top +
        DWStallWinScrollTop.Height
    else if DWStallWinScrollBar.Top > DWStallWinScrollBottom.Top -
      DWStallWinScrollBar.Height then
      DWStallWinScrollBar.Top := DWStallWinScrollBottom.Top -
        DWStallWinScrollBar.Height;
  end;
end;

procedure TFrmDlg.UpdateQueryStallLogScroll;
var
  H: Single;
begin
  if g_QueryStallLogs.Count > 0 then
  begin
    H := (DWStallQueryWinScrollBttom.Top - DWStallQueryWinScrollTop.Top -
      DWStallQueryWinScrollTop.Height - DWStallQueryWinScrollBar.Height) /
      g_QueryStallLogs.Count;
    DWStallQueryWinScrollBar.Top := DWStallQueryWinScrollTop.Top +
      DWStallQueryWinScrollTop.Height + Round(H * FQueryStallLogTopLine);
    if DWStallQueryWinScrollBar.Top < DWStallQueryWinScrollTop.Top +
      DWStallQueryWinScrollTop.Height then
      DWStallQueryWinScrollBar.Top := DWStallQueryWinScrollTop.Top +
        DWStallQueryWinScrollTop.Height
    else if DWStallQueryWinScrollBar.Top > DWStallQueryWinScrollBttom.Top -
      DWStallQueryWinScrollBar.Height then
      DWStallQueryWinScrollBar.Top := DWStallQueryWinScrollBttom.Top -
        DWStallQueryWinScrollBar.Height;
  end;
end;

//
procedure TFrmDlg.DAOpenShopClick(Sender: TObject; X, Y: Integer);
begin
  if(GetTickCount - g_dwShopTick > 2000) then
  begin
    g_dwShopTick := GetTickCount;
    frmMain.SendClientMessage(CM_CLICKGAMESHOP,0,0,0,0);;
  end

  //OpenShop;
end;

procedure TFrmDlg.DShopDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  sd: TDButton;
begin
  with DShop do
  begin
    D := nil;
    if Propertites.Images <> nil then
      D := Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, False);
  end;
  sd := nil;
  D := nil;
  case g_ShopTypePage of
    0:
      sd := DShopDecorate;
    1:
      sd := DShopSupplies;
    2:
      sd := DshopStrengthen;
    3:
      sd := DShopFriend;
    4:
      sd := DShopCapacity;
  end;
  if (sd <> nil) and (sd.Propertites.Images <> nil) then
  begin
    D := sd.Propertites.Images.Images[sd.Propertites.ImageIndex];
    if D <> nil then
      dsurface.Draw(sd.SurfaceX(sd.Left), sd.SurfaceY(sd.Top), D.ClientRect,
        D, False);
  end;


    DShopSelItemName.Propertites.Caption.Text := g_ShopItem.StdItem.Name;

  if g_ShopItem.StdItem.Name <> '' then
    DShopSelItemPrice.Propertites.Caption.Text := IntToStr(FShopAmount * g_ShopItem.nPrice)
  else
    DShopSelItemPrice.Propertites.Caption.Text := '0';


  DShopGamePoint.Propertites.Caption.Text := IntToStr(g_nGamePoint);
  DShopGameGold.Propertites.Caption.Text := IntToStr(g_dwGameGold);

end;

procedure TFrmDlg.DShopCloseClick(Sender: TObject; X, Y: Integer);
begin
  DShop.visible := False;
end;

procedure TFrmDlg.DShopImg1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
const
  ShopColor: Array [Boolean] of TColor = (clWhite, clRed);
var
  Idx: Integer;
  pm: pTShopItem;
  ISAcitve: Boolean;
begin
  with Sender as TDButton do
  begin
    Idx := _Max(Tag + 0 * 10, 0);
    if Idx < g_ShopItemList.Count then
    begin
      pm := pTShopItem(g_ShopItemList[Idx]);
      if pm <> nil then
      begin
        ISAcitve := (g_ShopItem.StdItem.Name <> '') and
          (g_ShopItem.Idx = pm.Idx);
        DrawShopItem(pm^, dsurface, SurfaceX(Left) + 4, SurfaceY(Top) + 4, 36,
          36, TimeTick);
        Textures.ObjectName(dsurface, pm.StdItem.Name)
          .Draw(dsurface, SurfaceX(Left) + 48, SurfaceY(Top) + 2,
          ShopColor[ISAcitve]);
        if ShopKind = 0 then
          dsurface.BoldText(Format('单价:%d %s', [pm.nPrice, g_sGameGoldName]),
            ShopColor[ISAcitve], FontBorderColor, SurfaceX(Left) + 48,
            SurfaceY(Top) + 22)
        else
          dsurface.BoldText(Format('单价:%d %s', [pm.nPrice, g_sGamePointName]),
            ShopColor[ISAcitve], FontBorderColor, SurfaceX(Left) + 48,
            SurfaceY(Top) + 22);
      end;
    end;
  end;
end;

procedure TFrmDlg.DShopImg1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Idx: Integer;
  pm: pTShopItem;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  with Sender as TDButton do
  begin
    Idx := _Max(Tag, 0);
    if Idx < g_ShopItemList.Count then
    begin
      pm := pTShopItem(g_ShopItemList[Idx]);
      if pm <> nil then
      begin
        if DScreen.ItemHint and (g_MouseShopItem.Name <> '') and
          (g_MouseShopItem.Idx = pm^.Idx) then
          DScreen.UpdateItemHintPostion(g_Application._CurPos)
        else
        begin
          g_MouseShopItem := pm^;
          DScreen.ShowShopItemHint(g_Application._CurPos, g_MouseShopItem,
            ShopKind = 1);
        end;
      end
      else
      begin
        g_MouseShopItem.Name := '';
        DScreen.ClearHint;
      end;
    end
    else
    begin
      g_MouseShopItem.Name := '';
      DScreen.ClearHint;
    end;
  end;
end;

procedure TFrmDlg.DShopImgLogoDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  with DShopImgLogo do
    DrawShopItem(g_ShopItem, dsurface, SurfaceX(Left) + 1, SurfaceY(Top) - 1,
      WIDTH, Height, TimeTick);
end;

procedure TFrmDlg.DShopImgLogoMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  if g_ShopItem.Name <> '' then
  begin
    if DScreen.ItemHint then
      DScreen.UpdateItemHintPostion(g_Application._CurPos)
    else
      DScreen.ShowShopItemHint(g_Application._CurPos, g_ShopItem);
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DShopMKindClick(Sender: TObject; X, Y: Integer);
var
  AChanged: Boolean;
  msg: TDefaultMessage;
begin
  if not((Y > 8) and (Y < 30) and (X < 156)) then
    Exit;

  if (X < 68) and (ShopKind = 1) then
  begin
    ShopKind := 0;
    AChanged := True;
  end
  else if (X > 68) and (ShopKind = 0) then
  begin
    ShopKind := 1;
    AChanged := True;
  end;

  if AChanged then
  begin
    g_SoundManager.DXPlaySound(s_norm_button_click);
    ClearShopItems;
    ClearShopSpeciallyItems;
    ShopTabPage := 0;
    g_ShopItem.Name := '';
    msg := MakeDefaultMsg(CM_OPENSHOP, 0, 0 { 页数 } , 0 { ShopType } , ShopKind,
      FrmMain.Certification);
    FrmMain.SendSocket(msg);
    g_ShopTypePage := 0;
    g_ShopPage := 0;
    FShopAmount := 0;
    DEShopAmount.Text := '0';
  end;
end;



procedure TFrmDlg.DShopMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DShopNextClick(Sender: TObject; X, Y: Integer);
var
  msg: TDefaultMessage;
  I: Integer;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  if Sender = DShopPrev then
  begin
    if g_ShopPage > 0 then
    begin
      Dec(g_ShopPage);
      ClearShopItems;
      msg := MakeDefaultMsg(CM_OPENSHOP, 0, g_ShopPage { 页数 } ,
        g_ShopTypePage { ShopType } , ShopKind, FrmMain.Certification);
      FrmMain.SendSocket(msg);
    end;
  end
  else
  begin
    if g_ShopPage < g_ShopReturnPage - 1 then
    begin
      Inc(g_ShopPage);
      ClearShopItems;
      msg := MakeDefaultMsg(CM_OPENSHOP, 0, g_ShopPage { 页数 } ,
        g_ShopTypePage { ShopType } , ShopKind, FrmMain.Certification);
      FrmMain.SendSocket(msg);
    end;
  end;
end;

procedure TFrmDlg.DShopDecorateClick(Sender: TObject; X, Y: Integer);
var
  msg: TDefaultMessage;
  I: Integer;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  ShopIndex := -1;
  g_MouseShopItem.Name := '';
  g_ShopItem.Name := '';
  FShopAmount := 0;
  DEShopAmount.Text := '0';
  ClearShopItems;
  if TDButton(Sender).Tag in [0 .. 4] then
  begin
    g_ShopTypePage := TDButton(Sender).Tag;
    g_ShopPage := 0;
    msg := MakeDefaultMsg(CM_OPENSHOP, 0, 0 { 页数 } ,
      g_ShopTypePage { ShopType } , ShopKind, FrmMain.Certification);
    FrmMain.SendSocket(msg);
  end;
end;

procedure TFrmDlg.DShopImg1Click(Sender: TObject; X, Y: Integer);
var
  Idx: Integer;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  g_ShopItem.Name := '';
  FSpeciallyShop := False;
  ShopGifFrame := 0;
  ShopSpeciallyIndex := -1;
  ShopIndex := TDButton(Sender).Tag;
  Idx := _Max(ShopIndex + 0 * 10, 0);
  if Idx < g_ShopItemList.Count then
  begin
    g_ShopItem := pTShopItem(g_ShopItemList[Idx])^;
    if g_ShopItem.Name <> '' then
    begin
      FShopAmount := 1;
      DEShopAmount.Text := '1';
    end
    else
    begin
      FShopAmount := 0;
      DEShopAmount.Text := '0';
    end;
  end;
  DShopBuy.Enabled := FShopAmount > 0;
  DWinCtl.SetDFocus(DEShopAmount);
end;

(* ******************************************************************************
  作用 : TextOut自动换行代码 (暂时未用)
  过程 : Itemstrorlist(str:string; WIDTH,HEIGH:integer);
  参数 : str为描述的字符串. 想要输出的WIDTH宽度. HEIGH想要输出的高度
  ****************************************************************************** *)
procedure TFrmDlg.Itemstrorlist(str: string; WIDTH, HEIGH: Integer);
var
  I, len, ALine, n, MAXWIDTH, MAXEIGHS: Integer;
  temp: string;
  loop: Boolean;
begin
  MAXWIDTH := WIDTH;
  MAXEIGHS := HEIGH;
  strorliscont := 0;
  n := 0;
  loop := True;
  while loop do
  begin
    temp := '';
    I := 1;
    len := Length(str);
    while True do
    begin
      if I > len then
      begin
        loop := False;
        Break;
      end;
      if Byte(str[I]) >= MAXWIDTH then
      begin
        temp := temp + str[I];
        Inc(I);
        if I <= len then
          temp := temp + str[I]
        else
        begin
          loop := False;
          Break;
        end;
      end
      else
        temp := temp + str[I];

      ALine := FrmMain.Canvas.TextWidth(temp);
      if ALine > MAXWIDTH then
      begin
        strorlist[n] := temp;
        strorlistidx[n] := ALine;
        Inc(strorliscont);
        Inc(n);
        if n >= MAXEIGHS then
        begin
          loop := False;
          Break;
        end;
        str := Copy(str, I + 1, len - I);
        temp := '';
        Break;
      end;
      Inc(I);
    end;
    if temp <> '' then
    begin
      if n < MAXWIDTH then
      begin
        strorlist[n] := temp;
        strorlistidx[n] := FrmMain.Canvas.TextWidth(temp);
        Inc(strorliscont);
      end;
    end;
  end;
end;

procedure TFrmDlg.DShopBuyClick(Sender: TObject; X, Y: Integer);
var
  msg: TDefaultMessage;
begin
  if (DShopBuy.Enabled) and (g_ShopItem.Name <> '') and
    (DMessageDlg('是否确认购买 ' + g_ShopItem.Name + 'x' + IntToStr(FShopAmount) +
    '？', [mbOK, mbCancel]) = mrOK) then
  begin
    if FSpeciallyShop then
      msg := MakeDefaultMsg(CM_BUYSHOPITEM, g_ShopItem.Idx, 5, ShopKind,
        FShopAmount, FrmMain.Certification)
    else
      msg := MakeDefaultMsg(CM_BUYSHOPITEM, g_ShopItem.Idx, g_ShopTypePage,
        ShopKind, FShopAmount, FrmMain.Certification);
    FrmMain.SendSocket(msg, EDcode.Encodestring(g_ShopItem.Name));
  end;
end;

procedure TFrmDlg.DShopBuyDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  dd: TAsphyreLockableTexture;
begin
  with DShopBuy do
  begin
    if Propertites.Images <> nil then
    begin
      if DShopBuy.Enabled and (g_ShopItem.Name <> '') then
      begin
        if not DShopBuy.Downed then
          dd := Propertites.Images.Images[Propertites.DownedIndex]
        else
          dd := Propertites.Images.Images[Propertites.ImageIndex];
      end
      else
        dd := Propertites.Images.Images[Propertites.DisabledIndex];
      if dd <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), dd.ClientRect, dd, True);
    end;
  end;
end;

procedure TFrmDlg.DShopSpeciallyImg1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
const
  ShopColor: Array [Boolean] of TColor = (clWhite, clRed);
var
  Idx: Integer;
  pm: pTShopItem;
  ISAcitve: Boolean;
begin
  with Sender as TDButton do
  begin
    Idx := _Max(Tag - 10, 0);
    if Idx < g_ShopSpeciallyItemList.Count then
    begin
      pm := pTShopItem(g_ShopSpeciallyItemList[Idx]);
      if pm <> nil then
      begin
        ISAcitve := (g_ShopItem.Name <> '') and (g_ShopItem.Idx = pm.Idx);
        DrawShopItem(pm^, dsurface, SurfaceX(Left) + 40, SurfaceY(Top) - 2, 36,
          36, TimeTick);
        Textures.ObjectName(dsurface, pm.StdItem.Name)
          .Draw(dsurface, SurfaceX(Left) + 4, SurfaceY(Top) + 32,
          ShopColor[ISAcitve]);
        if ShopKind = 0 then
          dsurface.BoldText(Format('单价:%d %s', [pm.nPrice, g_sGameGoldName]),
            ShopColor[ISAcitve], FontBorderColor, SurfaceX(Left) + 4,
            SurfaceY(Top) + 46)
        else
          dsurface.BoldText(Format('单价:%d %s', [pm.nPrice, g_sGamePointName]),
            ShopColor[ISAcitve], FontBorderColor, SurfaceX(Left) + 4,
            SurfaceY(Top) + 46);
      end;
    end;
  end;
end;

procedure TFrmDlg.DShopSpeciallyImg5MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Idx: Integer;
  pm: pTShopItem;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  with Sender as TDButton do
  begin
    Idx := _Max(Tag - 10, 0);
    if Idx < g_ShopSpeciallyItemList.Count then
    begin
      pm := pTShopItem(g_ShopSpeciallyItemList[Idx]);
      if DScreen.ItemHint and (g_MouseShopItem.Name <> '') and
        (g_MouseShopItem.Idx = pm^.Idx) then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseShopItem := pm^;
        DScreen.ShowShopItemHint(g_Application._CurPos, g_MouseShopItem,
          ShopKind = 1);
      end;
    end
    else
    begin
      g_MouseShopItem.Name := '';
      DScreen.ClearHint;
    end;
  end;
end;

procedure TFrmDlg.DShopSpeciallyImg1Click(Sender: TObject; X, Y: Integer);
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  g_ShopItem.Name := '';
  FSpeciallyShop := True;
  ShopGifFrame := 0;
  ShopIndex := -1;
  ShopSpeciallyIndex := TDButton(Sender).Tag - 10;
  if ShopSpeciallyIndex < g_ShopSpeciallyItemList.Count then
  begin
    g_ShopItem := pTShopItem(g_ShopSpeciallyItemList[ShopSpeciallyIndex])^;
    if g_ShopItem.Name <> '' then
    begin
      FShopAmount := 1;
      DEShopAmount.Text := '1';
    end
    else
    begin
      FShopAmount := 0;
      DEShopAmount.Text := '0';
    end;
  end;
  DShopBuy.Enabled := FShopAmount > 0;
  DWinCtl.SetDFocus(DEShopAmount);
end;

// Shop 物品动画演示
procedure TFrmDlg.ShopGifInfo(dsurface: TAsphyreCanvas;
  dx, dy, ShopGifBegin, ShopGifEnd: Integer);
var
  D: TAsphyreLockableTexture;
  img: Integer;
begin
  if ShopGifEnd = 0 then
  begin
    D := g_WEffectImages.Images[380];
    if D <> nil then
      dsurface.Draw(dx, dy, D.ClientRect, D, True);
    Exit;
  end;
  ShopGifExplosionFrame := ShopGifEnd - ShopGifBegin;
  if GetTickCount - ShopGifTime > 700 then
  begin
    ShopGifTime := GetTickCount;
    Inc(ShopGifFrame);
  end;

  if ShopGifFrame > ShopGifExplosionFrame then
    ShopGifFrame := 0;

  img := ShopGifBegin + ShopGifFrame;
  D := g_WEffectImages.Images[img];
  if D <> nil then
    dsurface.Draw(dx, dy, D.ClientRect, D, False);
end;

procedure TFrmDlg.CharacterSrankingClick(Sender: TObject; X, Y: Integer);
begin
  DLevelOrder.Left := (SCREENWIDTH - DLevelOrder.WIDTH) div 2;
  DLevelOrder.Top := (SCREENHEIGHT - DLevelOrder.Height - DBottom.Height) div 2;
  DLevelOrder.visible := not DLevelOrder.visible;
  LevelOrderPage := 0;
  LevelOrderPageChanged;
end;

procedure TFrmDlg.ScrollTimerTimer(Sender: TObject);
var
  IntValue: Integer;
begin
  case FScrollType of
    _ST_CHATBOX:
      begin
        if FChatLock then
          Exit;
        case ScrollTimer.Tag of
          1:
            begin
              DScreen.ChatMessage.TopLine := DScreen.ChatMessage.TopLine - 1;
              if DScreen.ChatMessage.TopLine < 0 then
                DScreen.ChatMessage.TopLine := 0;
            end;
          2:
            begin
              DScreen.ChatMessage.TopLine := DScreen.ChatMessage.TopLine + 1;
              if DScreen.ChatMessage.TopLine >
                DScreen.ChatMessage.Count - 1 then
                DScreen.ChatMessage.TopLine := DScreen.ChatMessage.Count - 1;
            end;
        end;
        UpdateChatSroll;
      end;
    _ST_MAILLIST:
      begin
        case ScrollTimer.Tag of
          1:
            begin
              g_Mail.TopIndex := g_Mail.TopIndex - 1;
              if g_Mail.TopIndex < 0 then
                g_Mail.TopIndex := 0;
            end;
          2:
            begin
              g_Mail.TopIndex := g_Mail.TopIndex + 1;
              if g_Mail.TopIndex > g_Mail.Count - 1 then
                g_Mail.TopIndex := g_Mail.Count - 1;
              if g_Mail.TopIndex < 0 then
                g_Mail.TopIndex := 0;
            end;
        end;
        UpdateMailListScroll;
      end;
    _ST_MAILREAD:
      begin
        case ScrollTimer.Tag of
          1:
            begin
              if DMMReader.TopLine > 0 then
                DMMReader.TopLine := DMMReader.TopLine - 1;
            end;
          2:
            begin
              if DMMReader.TopLine < DMMReader.Lines.Count - 1 then
                DMMReader.TopLine := DMMReader.TopLine + 1;
            end;
        end;
        UpdateMailReadScroll;
      end;
    _ST_MAILWRITE:
      begin
        case ScrollTimer.Tag of
          1:
            begin
              if DMMailEdit.TopLine > 0 then
                DMMailEdit.TopLine := DMMailEdit.TopLine - 1;
            end;
          2:
            begin
              if DMMailEdit.TopLine < DMMailEdit.Lines.Count - 1 then
                DMMailEdit.TopLine := DMMailEdit.TopLine + 1;
            end;
        end;
        UpdateMailWriteScroll;
      end;
    _ST_SPLITITEM:
      begin
        case ScrollTimer.Tag of
          1:
            IncSplitItemCount(1);
          2:
            IncSplitItemCount(-1);
        end;
      end;
    _ST_BUYITEM:
      begin
        case ScrollTimer.Tag of
          1:
            IncBuyItemCount(1);
          2:
            IncBuyItemCount(-1);
        end;
      end;
    _ST_MISSIONS:
      begin
        case ScrollTimer.Tag of
          1:
            begin
              Dec(g_MissionTopIndex);
              if g_MissionTopIndex < 0 then
                g_MissionTopIndex := 0;
            end;
          2:
            begin
              Inc(g_MissionTopIndex);
              if g_MissionTopIndex > g_Missions.DoingCount - 1 then
                g_MissionTopIndex := g_Missions.DoingCount - 1;
            end;
        end;
        UpdateMiniMissionsScroll;
      end;
    _ST_STALLLOG:
      begin
        case ScrollTimer.Tag of
          1:
            begin
              Dec(FStallLogTopLine);
              if FStallLogTopLine < 0 then
                FStallLogTopLine := 0;
            end;
          2:
            begin
              Inc(FStallLogTopLine);
              if FStallLogTopLine > g_StallLogs.Count - 1 then
                FStallLogTopLine := g_StallLogs.Count - 1;
            end;
        end;
        UpdateStallLogScroll;
      end;
    _ST_QSTALLLOG:
      begin
        case ScrollTimer.Tag of
          1:
            begin
              Dec(FQueryStallLogTopLine);
              if FQueryStallLogTopLine < 0 then
                FQueryStallLogTopLine := 0;
            end;
          2:
            begin
              Inc(FQueryStallLogTopLine);
              if FQueryStallLogTopLine > g_QueryStallLogs.Count - 1 then
                FQueryStallLogTopLine := g_QueryStallLogs.Count - 1;
            end;
        end;
        UpdateQueryStallLogScroll;
      end;
    _ST_CHATHISBOX:
      begin
        case ScrollTimer.Tag of
          1:
            begin
              DScreen.ChatHisMessage.TopLine :=
                DScreen.ChatHisMessage.TopLine - 1;
              if DScreen.ChatHisMessage.TopLine < 0 then
                DScreen.ChatHisMessage.TopLine := 0;
            end;
          2:
            begin
              DScreen.ChatHisMessage.TopLine :=
                DScreen.ChatHisMessage.TopLine + 1;
              if DScreen.ChatHisMessage.TopLine >
                DScreen.ChatHisMessage.Count - 1 then
                DScreen.ChatHisMessage.TopLine :=
                  DScreen.ChatHisMessage.Count - 1;
            end;
        end;
        UpdateChatSroll;
      end;
  end;
end;

procedure TFrmDlg.DLevelOrderCloseClick(Sender: TObject; X, Y: Integer);
begin
  DLevelOrder.visible := False;
end;

procedure TFrmDlg.DLevelOrderDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  L, T, I: Integer;
  D, ATexture: TAsphyreLockableTexture;
  S: String;
begin
  with DLevelOrder do
  begin
    L := SurfaceX(Left);
    T := SurfaceY(Top);
    D := Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
      dsurface.Draw(L, T, D);

//    ATexture := FontManager.Default.TextOut('排 名');
//    dsurface.DrawText(L + 44, T + 90, ATexture, clSilver);
//    ATexture := FontManager.Default.TextOut('玩家名称');
//    dsurface.DrawText(L + 130, T + 90, ATexture, clSilver);
//    ATexture := FontManager.Default.TextOut('职 业');
//    dsurface.DrawText(L + 290, T + 90, ATexture, clSilver);
//    ATexture := FontManager.Default.TextOut('性别');
//    dsurface.DrawText(L + 342, T + 90, ATexture, clSilver);

    ATexture := nil;
    case g_Orders.OrderType of
      0: DTRankType.Propertites.Caption.Text := '等    级';
      1: DTRankType.Propertites.Caption.Text := '数    量';
      2: DTRankType.Propertites.Caption.Text := '战    力';
      3: DTRankType.Propertites.Caption.Text := '徒 弟 数';
      4: DTRankType.Propertites.Caption.Text := '物理攻击';
      5: DTRankType.Propertites.Caption.Text := '魔法攻击';
      6: DTRankType.Propertites.Caption.Text := '道术攻击';
      7: DTRankType.Propertites.Caption.Text := '箭术攻击';
      8: DTRankType.Propertites.Caption.Text := '刺术攻击';
      9: DTRankType.Propertites.Caption.Text := '武术攻击';
    end;

//    if ATexture <> nil then
//      dsurface.DrawText(L + 376 + (152 - ATexture.WIDTH) div 2, T + 90,
//        ATexture, clSilver);

    if g_Orders.PageCount > 0 then
    begin
      S := Format('第%d/%d页', [g_Orders.Page + 1, g_Orders.PageCount]);
      DTRankPage.Propertites.Caption.Text := S;
    end else
    begin
      DTRankPage.Propertites.Caption.Text := '第1/1页';
    end;

    if g_Orders.MyOrder >= 0 then
      S := IntToStr(g_Orders.MyOrder + 1)
    else
      S := '未上榜';
    DTRankMyOrder.Propertites.Caption.Text := S;
    {
    for I := 0 to 9 do
    begin
      if I > g_Orders.Items.Count - 1 then
        Break;
      if g_Orders.SelectOrder = I then
        dsurface.FillRectAlpha(Rect(L + 35, T + 110 + I * 16, L + 528,
          T + 110 + I * 16 + 16), $007B0F0F, 128)
      else if g_Orders.HoverOrder = I then
        dsurface.FillRectAlpha(Rect(L + 35, T + 110 + I * 16, L + 528,
          T + 110 + I * 16 + 16), $00101113, 128);

      ATexture := FontManager.
        Default.TextOut(Format('%d', [g_Orders.Page * 10 + I + 1]));
      dsurface.DrawText(L + 60 - ATexture.WIDTH div 2, T + 112 + I * 16,
        ATexture, clWhite);

      ATexture := FontManager.
        Default.TextOut(TuOrderItem(g_Orders.Items[I]).Name);
      dsurface.DrawText(L + 90, T + 112 + I * 16, ATexture, clWhite);

      ATexture := FontManager.
        Default.TextOut(TuOrderItem(g_Orders.Items[I]).job);
      dsurface.DrawText(L + 280, T + 112 + I * 16, ATexture, clWhite);

      ATexture := FontManager.
        Default.TextOut(TuOrderItem(g_Orders.Items[I]).sex);
      dsurface.DrawText(L + 342, T + 112 + I * 16, ATexture, clWhite);

      ATexture := FontManager.
        Default.TextOut(TuOrderItem(g_Orders.Items[I]).Data);
      dsurface.DrawText(L + 380, T + 112 + I * 16, ATexture, clWhite);
    end; }
  end;
end;

procedure TFrmDlg.DLevelOrderIndexClick(Sender: TObject; X, Y: Integer);
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  if GetTickCount - DLevelOrder.TimeTick > 300 then
  begin
    g_Orders.Page := 0;
    LevelOrderPageChanged;
    DLevelOrder.TimeTick := GetTickCount;
  end;
end;

procedure TFrmDlg.DLevelOrderLastPageClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DLevelOrder.TimeTick > 300 then
  begin
    if g_Orders.Page <> g_Orders.PageCount - 1 then
    begin
      g_Orders.Page := g_Orders.PageCount - 1;
      LevelOrderPageChanged;
      DLevelOrder.TimeTick := GetTickCount;
    end;
  end;
end;

procedure TFrmDlg.DLevelOrderMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 {
  Y := Y - DLevelOrder.SurfaceY(DLevelOrder.Top);
  if (Y >= 112) and (Y <= 272) then
    g_Orders.HoverOrder := (Y - 112) div 16
  else
    g_Orders.HoverOrder := -1;  }
end;

procedure TFrmDlg.DLevelOrderMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  AName: String;
  NewY: Integer;
begin
{
  if Button = mbRight then
  begin
    NewY := Y - DLevelOrder.SurfaceY(DLevelOrder.Top);
    if (NewY >= 112) and (NewY <= 272) then
    begin
      g_Orders.SelectOrder := (NewY - 112) div 16;
      if g_Orders.SelectOrder > g_Orders.Items.Count - 1 then
        g_Orders.SelectOrder := -1;
    end;

    if g_Orders.SelectOrder <> -1 then
    begin
      AName := TuOrderItem(g_Orders.Items[g_Orders.SelectOrder]).Name;
      if AName <> g_MySelf.m_sUserName then
      begin
        if DXPopupMenu.PopVisible then
          DXPopupMenu.HidePopup;
        DXPopupMenu.BeginUpdate;
        DXPopupMenu.Clear;
        DXPopupMenu.AddMenuItem(1, '查看装备');
        DXPopupMenu.AddMenuItem(11, '私聊');
        DXPopupMenu.AddMenuItem(12, '复制名称');
        if not NameInFriends(AName) and not NameInEnemies(AName) then
          DXPopupMenu.AddMenuItem(14, '添加好友');
        DXPopupMenu.EndUpdate;
        DXPopupMenu.Popup(DLevelOrder, DLevelOrder.LocalX(X) - DLevelOrder.Left,
          DLevelOrder.LocalY(Y) - DLevelOrder.Top, 0, procedure(Tag: Integer;
          const ACaption: String)begin case Tag of 1
          : FrmMain.SendClientMessage(CM_EXECMENUITEM, 0, 0, 0, Tag,
          EDcode.Encodestring(AName));
          11: begin PlayScene.SetChatText('/' + AName + ' '); SetDFocus(DEChat);
          DEChat.SelStart := Length(DEChat.Text); end;
          12: Clipbrd.Clipboard.SetTextBuf(PChar(AName));
          14: FrmMain.AddFriend(AName); end; end);
      end;
    end;
  end;
  }
end;

procedure TFrmDlg.DLevelOrderNextClick(Sender: TObject; X, Y: Integer);
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  if GetTickCount - DLevelOrder.TimeTick > 300 then
  begin
    if g_Orders.Page < g_Orders.PageCount - 1 then
    begin
      g_Orders.Page := g_Orders.Page + 1;
      LevelOrderPageChanged;
      DLevelOrder.TimeTick := GetTickCount;
    end;
  end;
end;

procedure TFrmDlg.DLevelOrderPrevClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DLevelOrder.TimeTick > 300 then
  begin
    if g_Orders.Page > 0 then
    begin
      g_Orders.Page := g_Orders.Page - 1;
      LevelOrderPageChanged;
      DLevelOrder.TimeTick := GetTickCount;
    end;
  end;
end;

procedure TFrmDlg.LevelOrderPageChanged;
begin
  ShowMySelfOrder := False;
  DV_RankInfo.Clear;
  FrmMain.SendQueryOrders(g_Orders.OrderType, g_Orders.Page + 1);
end;

procedure TFrmDlg.DOrderLevelClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DLevelOrder.TimeTick > 300 then
  begin
    g_Orders.Clear;
    g_Orders.OrderType := TDButton(Sender).Tag;
    LevelOrderPageChanged;
    DLevelOrder.TimeTick := GetTickCount;
  end;
end;

procedure TFrmDlg.DCreateChrDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with TDButton(Sender) do
  begin
    D := Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    case g_DWinMan.UIType of
      skReturn:
        begin
          case SelectChrScene.Chars[SelectChrScene.NewIndex].UserChr.job of
            _JOB_SHAMAN:
              D := Propertites.Images.Images[3082];
          else
            D := Propertites.Images.Images
              [2870 + 5 * SelectChrScene.Chars[SelectChrScene.NewIndex]
              .UserChr.sex + SelectChrScene.Chars[SelectChrScene.NewIndex]
              .UserChr.job];
          end;
          if D <> nil then
            dsurface.Draw(SurfaceX(Left) + 114, SurfaceY(Top) + 276,
              D.ClientRect, D, True);
        end;
    end;
  end;
end;

procedure TFrmDlg.DCSendMailItemClick(Sender: TObject; X, Y: Integer);
var
  ATemp: TClientItem;
begin
  if not g_boItemMoving then
  begin
    if g_MailItem.Name <> '' then
    begin
      g_SoundManager.ItemClickSound(g_MailItem.S);
      g_boItemMoving := True;
      g_MovingItem.FromIndex := 0;
      g_MovingItem.Source := msMailItem;
      g_MovingItem.Item := g_MailItem;
      g_MailItem.Name := '';
    end;
  end
  else
  begin
    if g_MovingItem.Source in [msBag, msMailItem] then
    begin
      g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
      if g_MailItem.Name <> '' then
      begin
        ATemp := g_MailItem;
        g_MailItem := g_MovingItem.Item;
        g_MovingItem.FromIndex := 0;
        g_MovingItem.Source := msMailItem;
        g_MovingItem.Item := ATemp;
      end
      else
      begin
        g_MailItem := g_MovingItem.Item;
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
      end;
    end;
  end;
end;

procedure TFrmDlg.DCSendMailItemDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  if g_MailItem.Name <> '' then
    DrawItem(g_MailItem, dsurface, DCSendMailItem.SurfaceX(DCSendMailItem.Left),
      DCSendMailItem.SurfaceY(DCSendMailItem.Top), DCSendMailItem.WIDTH,
      DCSendMailItem.Height, DCSendMailItem.TimeTick);
end;

procedure TFrmDlg.DCSendMailItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if g_MailItem.Name <> '' then
  begin
    if (g_MailItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
      DScreen.UpdateItemHintPostion(g_Application._CurPos)
    else
    begin
      g_MouseItem := g_MailItem;
      DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
    end;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DMyBagClick(Sender: TObject; X, Y: Integer);
begin
  DScreen.ClearHint;
  OpenItemBag;
end;

procedure TFrmDlg.DMyLevelOrderClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DLevelOrder.TimeTick > 300 then
  begin
    if g_Orders.Page <> (g_Orders.MyOrder div 10) then
    begin
      g_Orders.Page := g_Orders.MyOrder div 10;
      if g_Orders.Page < 0 then
        g_Orders.Page := 0;
      LevelOrderPageChanged;
      DLevelOrder.TimeTick := GetTickCount;
      ShowMySelfOrder := True;
    end else
    begin
      DV_RankInfo.SelectedIndex := g_Orders.MyOrder mod 10;
    end;
  end;
end;

procedure TFrmDlg.DMyMagicClick(Sender: TObject; X, Y: Integer);
begin
  DScreen.ClearHint;
  OpenMyStatus(4);
end;

procedure TFrmDlg.DBottomMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
//  if (X >= SCREENWIDTH - 137) and (X <= SCREENWIDTH - 60) then
//  begin
//    if (Y >= SCREENHEIGHT - 72) and (Y <= SCREENHEIGHT - 62) then
//      DScreen.ShowHint(X + 10, Y + 10, Format('%d/%d', [g_MySelf.m_Abil.Exp,
//        g_MySelf.m_Abil.MaxExp]))
//    else if (Y >= SCREENHEIGHT - 40) and (Y <= SCREENHEIGHT - 30) then
//      DScreen.ShowHint(X + 10, Y + 10, Format('%d/%d', [g_MySelf.m_Abil.Weight,
//        g_MySelf.m_Abil.MaxWeight]))
//    else
//      DScreen.ClearHint;
//  end
//  else
//    DScreen.ClearHint;

  DTWeightText.Visible := False;
  DTExpText.Visible := False;
end;

procedure TFrmDlg.DBottomVisibleChange(Sender: TObject);
begin
  if DBottom.visible then
    UpdateChatSroll;
end;

procedure TFrmDlg.MouseRightItem(WhoItemBag, ACol, ARow: Integer);
begin
end;

procedure TFrmDlg.MagicIconClick(Sender: TObject; X, Y: Integer);
var
  D: TDSkillItem;
  Magic: pTClientMagic;
begin
  if Sender is TDButton then
  begin
    With Sender As TDButton do
    begin
      if (DParent <> nil) and (DParent is TDSkillItem) then
      begin
        D := TDSkillItem(DParent);
        Magic := D.FMagic;
        if Magic <> nil then
        begin
          FSelMagic := Magic;
          SetMagicKeyDlg(Word(Magic.Key));
        end;
      end;
    end;

  end;
end;

procedure TFrmDlg.MessageBox(const Title: string; DlgButtons: TMsgDlgButtons;
  Proc: TMessageHandler);
var
  AItem: PTMessageDialogItem;
begin
  New(AItem);
  AItem.Text := Text;
  AItem.Buttons := DlgButtons;
  AItem.Handler := Proc;
  FMessageBoxList.Add(AItem);
  MessageBoxTimer.Enabled := True;
end;

procedure TFrmDlg.MessageBoxTimerTimer(Sender: TObject);
begin
  if (FMessageBoxList.Count > 0) and not DMsgDlg.visible then
  begin
    FDialogItem := FMessageBoxList[0];
    FMessageBoxList.Delete(0);
    BuildMessageBox;
    if FMessageBoxList.Count = 0 then
      MessageBoxTimer.Enabled := False;
  end
  else
    MessageBoxTimer.Enabled := False;
end;

procedure TFrmDlg.MouseDlbTakeItem(WhoItemBag, Idx: Integer);
// 双击穿装备  邱高奇 091101 添加
var
  where: Integer;
  Sender:TObject;
begin
  case WhoItemBag of
    1:
      begin
        if g_MySelf = nil then
          Exit;
        if (Idx = -1) and g_boItemMoving then
        begin
          where := GetTakeOnPosition(g_MovingItem.Item);
          case where of
            U_DRESS:
              begin // 衣服
                if g_MySelf.m_btSex = 0 then
                  if g_MovingItem.Item.S.StdMode <> 10 then
                    Exit; // 女
                if g_MySelf.m_btSex = 1 then
                  if g_MovingItem.Item.S.StdMode <> 11 then
                    Exit; // 男
                g_boDblItem := True;
                DSWWeaponClick(DSWDress, 0, 0);
                g_boDblItem := False;
              end;
            U_WEAPON:
              begin // 武器
                g_boDblItem := True;
                DSWWeaponClick(DSWWeapon, 0, 0);
                g_boDblItem := False;
              end;
            U_NECKLACE:
              begin // 项链
                g_boDblItem := True;
                DSWWeaponClick(DSWNecklace, 0, 0);
                g_boDblItem := False;
              end;
            U_RIGHTHAND:
              begin // 右手
                g_boDblItem := True;
                DSWWeaponClick(DSWLight, 0, 0);
                g_boDblItem := False;
              end;
            U_HELMET:
              begin // 头盔,斗笠 20080417
                g_boDblItem := True;
                DSWWeaponClick(DSWHelmet, 0, 0);
                g_boDblItem := False;
              end;
            U_ZHULI:
              begin
                g_boDblItem := True;
                DSWWeaponClick(DSWZhuli, 0, 0);
                g_boDblItem := False;
              end;
            U_RINGR, U_RINGL:
              begin // 右戒指
                if g_UseItems[U_RINGR].Name = '' then
                begin
                  g_boDblItem := True;
                  g_ItemArr[Idx].Name := ''; // 20080229
                  DSWWeaponClick(DSWRingR, 0, 0);
                end
                else if g_UseItems[U_RINGL].Name = '' then
                begin
                  g_boDblItem := True;
                  g_ItemArr[Idx].Name := ''; // 20080229
                  DSWWeaponClick(DSWRingL, 0, 0);
                end
                else if not g_boRightItemRingEmpty then
                begin
                  g_boDblItem := True;
                  DSWWeaponClick(DSWRingR, 0, 0);
                  g_boRightItemRingEmpty := True; // 20080319
                end
                else if g_boRightItemRingEmpty then
                begin
                  g_boDblItem := True;
                  DSWWeaponClick(DSWRingL, 0, 0);
                  g_boRightItemRingEmpty := False; // 20080319
                end;
                g_boDblItem := False;
              end;
            U_ARMRINGR, U_ARMRINGL:
              begin // 右手手镯
                if g_UseItems[U_ARMRINGR].Name = '' then
                begin
                  g_boDblItem := True;
                  DSWWeaponClick(DSWArmRingR, 0, 0);
                end
                else if g_UseItems[U_ARMRINGL].Name = '' then
                begin
                  g_boDblItem := True;
                  DSWWeaponClick(DSWArmRingL, 0, 0);
                end
                else if not g_boRightItemArmRingEmpty then
                begin
                  g_boDblItem := True;
                  DSWWeaponClick(DSWArmRingR, 0, 0);
                  g_boRightItemArmRingEmpty := True;
                end
                else if g_boRightItemArmRingEmpty then
                begin
                  g_boDblItem := True;
                  DSWWeaponClick(DSWArmRingL, 0, 0);
                  g_boRightItemArmRingEmpty := False;
                end;
                g_boDblItem := False;
              end;
            U_BUJUK:
              begin // 符
                if (g_ItemArr[Idx].S.StdMode = 2) and
                  (g_ItemArr[Idx].AniCount <> 21) then
                  Exit; // 20080322 类型2的物品.右击会隐藏.
                g_boDblItem := True;
                DSWWeaponClick(DSWBujuk, 0, 0);
                g_boDblItem := False;
              end;
            U_BELT:
              begin // 腰带
                g_boDblItem := True;
                DSWWeaponClick(DSWBelt, 0, 0);
                g_boDblItem := False;
              end;
            U_BOOTS:
              begin // 鞋
                g_boDblItem := True;
                DSWWeaponClick(DSWBoots, 0, 0);
                g_boDblItem := False;
              end;
            U_CHARM:
              begin // 宝石
                g_boDblItem := True;
                DSWWeaponClick(DSWCharm, 0, 0);
                g_boDblItem := False;
              end;
            U_FASHION:
              begin
                g_boDblItem := True;
                DSWWeaponClick(DWFashionDress, 0, 0);
                g_boDblItem := False;
              end;
            U_MOUNT:
              begin
                g_boDblItem := True;
                DSWWeaponClick(DSMount, 0, 0);
                g_boDblItem := False;
              end;
            U_SHIED:
              begin
                g_boDblItem := True;
                DSWWeaponClick(DSShied, 0, 0);
                g_boDblItem := False;
              end;
            U_ZODIAC1..U_ZODIAC12:
            begin
              case where of
                U_ZODIAC1:Sender := frmNewItem.DZodiacItem1;
                U_ZODIAC2:Sender := frmNewItem.DZodiacItem2;
                U_ZODIAC3:Sender := frmNewItem.DZodiacItem3;
                U_ZODIAC4:Sender := frmNewItem.DZodiacItem4;
                U_ZODIAC5:Sender := frmNewItem.DZodiacItem5;
                U_ZODIAC6:Sender := frmNewItem.DZodiacItem6;
                U_ZODIAC7:Sender := frmNewItem.DZodiacItem7;
                U_ZODIAC8:Sender := frmNewItem.DZodiacItem8;
                U_ZODIAC9:Sender := frmNewItem.DZodiacItem9;
                U_ZODIAC10:Sender := frmNewItem.DZodiacItem10;
                U_ZODIAC11:Sender := frmNewItem.DZodiacItem11;
                U_ZODIAC12:Sender := frmNewItem.DZodiacItem12;
              end;
              g_boDblItem := True;
              DSWWeaponClick(Sender, 0, 0);
              g_boDblItem := False;
            end;
          end;
        end;
      end;
  end;
end;

{ ****************************************************************************** }
// 宝箱系统
procedure TFrmDlg.DBoxsDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  Shape: Integer;
begin
  with DBoxs do
  begin
    if Propertites.ImageIndex = 510 then
    begin
      if Propertites.Images <> nil then
      begin
        D := Propertites.Images.Images[Propertites.ImageIndex];
        if D <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      end;
    end;

    if g_boPutBoxsKey then
    begin
      if GetTickCount - g_dwBoxsTick > 200 then
      begin
        g_dwBoxsTick := GetTickCount;
        Inc(g_nBoxsImg);
        if g_nBoxsImg > 6 then
        begin
          g_nBoxsImg := 0;
          g_boPutBoxsKey := False;
          DBoxs.SetImgIndex(g_WMain3Images, 510);
          D := g_WMain3Images.Images[510];
          DBoxs.Left := SCREENWIDTH div 2 - D.WIDTH div 2;
          DBoxs.Top := (SCREENHEIGHT - D.Height) div 2;
          D := g_WMain3Images.Images[510];
          if D <> nil then
            dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
          ShowBoxsGird(True); // 显示宝箱格
          DBoxsTautology.visible := True;
        end;
      end;
    end;

    if DBoxsBelt1.visible then
      Exit;
    case g_BoxShape of
      1:
        Shape := 520;
      2:
        Shape := 540;
      3:
        Shape := 560;
      4:
        Shape := 580;
      5:
        Shape := 130;
      6:
        Shape := 510;
    end;
    if Shape <> 130 then
    begin
      DBoxs.SetImgIndex(g_WMain3Images, Shape);
      D := g_WMain3Images.Images[Shape + g_nBoxsImg];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      D := g_WMain3Images.Images[Shape + 7 + g_nBoxsImg];
      if D <> nil then
        dsurface.DrawBlend(SurfaceX(Left), SurfaceY(Top), D, 1);
    end
    else
    begin
      DBoxs.SetImgIndex(g_WMain2Images, Shape);
      D := g_WMain2Images.Images[Shape + g_nBoxsImg];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      D := g_WMain2Images.Images[Shape + 7 + g_nBoxsImg];
      if D <> nil then
        dsurface.DrawBlend(SurfaceX(Left), SurfaceY(Top), D, 1);
    end;
  end;
end;

procedure TFrmDlg.DBoxsClick(Sender: TObject; X, Y: Integer);
var
  msg: TDefaultMessage;
begin
  if not DBoxsTautology.visible then
  begin
    if (not g_boItemMoving) and (g_MovingItem.Item.Name = '') and
      (not g_boPutBoxsKey) then
    begin
      AddItemBag(g_EatingItem);
      DBoxs.visible := False;
      ShowBoxsGird(False); // 显示宝箱格
      g_BoxsShowPosition := -1;
      Exit;
    end;
    if g_boItemMoving then
    begin
      if (g_MovingItem.Item.AniCount = g_EatingItem.AniCount) and
        (g_MovingItem.Item.S.Source = 1) and
        (g_MovingItem.Item.S.StdMode = 48) then
      begin
        msg := MakeDefaultMsg(CM_OPENBOXS, g_EatingItem.MakeIndex,
          { g_MovingItem.Item.MakeIndex } 0, 0, 0, FrmMain.Certification);
        FrmMain.SendSocket(msg,
          EDcode.Encodestring( { Inttostr(g_EatingItem.MakeIndex) + '/' + }
          IntToStr(g_MovingItem.Item.MakeIndex)));
        g_BoxsTempKeyItems := g_MovingItem.Item; // 把钥匙存放到临时物品     失败则返回

        g_boItemMoving := False;
        g_MovingItem.Item.Name := ''; // 把钥匙变没
        g_boPutBoxsKey := True;
        g_BoxsCircleNum := 0; // 初始化转动圈数
        g_BoxsShowPosition := 8;

        g_BoxsFirstMove := False; // 初始化第1次转动
        g_BoxsMoveDegree := 0; // 初始化 转盘次数
        BoxsRandomImg;
        g_SoundManager.MyPlaySound(Openbox_ground);
      end;
    end;
  end;
end;

procedure TFrmDlg.ShowBoxsGird(Show: Boolean);
begin
  if Show then
  begin
    DBoxsBelt1.visible := True;
    DBoxsBelt2.visible := True;
    DBoxsBelt3.visible := True;
    DBoxsBelt4.visible := True;
    DBoxsBelt5.visible := True;
    DBoxsBelt6.visible := True;
    DBoxsBelt7.visible := True;
    DBoxsBelt8.visible := True;
    DBoxsBelt9.visible := True;
  end
  else
  begin
    DBoxsBelt1.visible := False;
    DBoxsBelt2.visible := False;
    DBoxsBelt3.visible := False;
    DBoxsBelt4.visible := False;
    DBoxsBelt5.visible := False;
    DBoxsBelt6.visible := False;
    DBoxsBelt7.visible := False;
    DBoxsBelt8.visible := False;
    DBoxsBelt9.visible := False;
  end;
end;

procedure TFrmDlg.ShowBuyItemDialog(const Caption, ItemName: String;
  MaxCount, Price, Index: Integer);
begin
  DScreen.ClearHint;
  FBuyMaxCount := Max(MaxCount, 10);
  FBuyPrice := Price;
  FBuyIndex := Index;
  FBuyItemName := ItemName;
  FrmMain.CloseTopmost;
  DWBuyItemCountEdt.Text := '1';
  DWBuyItemCount.Caption := Caption;
  DWBuyItemCount.Left := (SCREENWIDTH - DWBuyItemCount.WIDTH) div 2;
  DWBuyItemCount.Top := (SCREENHEIGHT - DWBuyItemCount.Height) div 2;
  DWBuyItemCount.ShowModal;
end;

procedure TFrmDlg.ShowSplitItemDialog(const Caption: String;
  MaxCount, MakeIndex: Integer);
begin
  DScreen.ClearHint;
  FSplitMaxCount := MaxCount;
  FSplitMakeIndex := MakeIndex;

  FrmMain.CloseTopmost;
  DWSplitItem.Caption := Caption;
  DWSplitItemEdt.Text := '1';
  DWSplitItem.Left := (SCREENWIDTH - DWSplitItem.WIDTH) div 2;
  DWSplitItem.Top := (SCREENHEIGHT - DWSplitItem.Height) div 2;
  DWSplitItem.ShowModal;
end;

procedure TFrmDlg.IncBuyItemCount(Value: Integer);
var
  IntValue: Integer;
begin
  IntValue := StrToIntDef(DWBuyItemCountEdt.Text, 0) + Value;
  if IntValue < 1 then
    IntValue := 1
  else if IntValue > FBuyMaxCount then
    IntValue := FBuyMaxCount;
  DWBuyItemCountEdt.Text := IntToStr(IntValue);
end;

procedure TFrmDlg.IncSplitItemCount(Value: Integer);
var
  IntValue: Integer;
begin
  IntValue := StrToIntDef(DWSplitItemEdt.Text, 0) + Value;
  if IntValue < 1 then
    IntValue := 1
  else if IntValue > FSplitMaxCount then
    IntValue := FSplitMaxCount;
  DWSplitItemEdt.Text := IntToStr(IntValue);
end;

procedure TFrmDlg.DBoxsBelt5DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  Idx: Integer;
  sel: Integer;
  Butt: TDButton;
begin
  BoxsRunning(dsurface); // 宝箱转动
  Butt := TDButton(Sender);
  with Butt do
  begin
    sel := Tag;
    case sel of
      8:
        begin
          D := g_WMain3Images.Images[513];
          if D <> nil then
            dsurface.Draw(SurfaceX(Left - 5), SurfaceY(Top - 5),
              D.ClientRect, D, True);
        end
    else
      begin
        D := Propertites.Images.Images[Propertites.ImageIndex];
        if D <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      end;
    end;
    if g_BoxSItems[sel].Name <> '' then
    begin
      if (g_BoxSItems[sel].Name = g_sGameDiaMond) or
        (g_BoxSItems[sel].Name = '经验') or (g_BoxSItems[sel].Name = '声望') then
      begin
        if g_BoxSItems[sel].Name = g_sGameDiaMond then
          Idx := 1187;
        if g_BoxSItems[sel].Name = '经验' then
          Idx := 1186;
        if g_BoxSItems[sel].Name = '声望' then
          Idx := 1185;
      end
      else
        Idx := g_BoxSItems[sel].Looks;
      if Idx >= 0 then
      begin
        if g_BoxsShowPosition = Butt.Tag then
        begin
          BoxsFlash(Butt, dsurface);
          DrawItem(g_BoxSItems[sel], dsurface, SurfaceX(Left), SurfaceY(Top),
            WIDTH, Height, TimeTick);
        end
        else
        begin
          DrawItem(g_BoxSItems[sel], dsurface, SurfaceX(Left), SurfaceY(Top),
            WIDTH, Height, TimeTick);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DBoxsBelt5MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sel: Integer;
  Butt: TDButton;
  temp: TClientItem;
begin
  Butt := TDButton(Sender);
  sel := Butt.Tag;
  if sel <> -1 then
  begin
    temp := g_BoxSItems[sel];
    if temp.Name <> '' then
    begin
      if (temp.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := temp;
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

procedure TFrmDlg.DBoxsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

// 宝箱物品闪烁函数
procedure TFrmDlg.BoxsFlash(Button: TDButton; dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  if GetTickCount - g_dwBoxsFlashTick > 100 then
  begin
    g_dwBoxsFlashTick := GetTickCount;
    Inc(g_BoxsFlashImg);
    if g_BoxsFlashImg > 2 then
      g_BoxsFlashImg := 0;
  end;
  if g_BoxsFlashImg = 2 then
    Exit;
  D := g_WMain3Images.Images[g_BoxsbsImg + g_BoxsFlashImg];
  if D <> nil then
    dsurface.DrawBlend(Button.SurfaceX(Button.Left - 10),
      Button.SurfaceY(Button.Top - 11), D, 1);
end;

// 宝箱物品随机取图
procedure TFrmDlg.BoxsRandomImg;
var
  vList: TList;
  I, J: Integer;
  vData: Integer;
begin
  Randomize; // 播下随机种子
  vList := TList.Create;
  try
    for I := 600 to 617 do
      vList.Add(Pointer(I)); // 得到一副顺序排列的扑克
    for I := 1 to 8 do // 取8个数
    begin
      J := Random(vList.Count); // 从余下的扑克中随机选一张
      vData := Integer(vList[J]);
      if vData = 601 then
        continue;
      if vData = 603 then
        continue;
      if vData = 605 then
        continue;
      if vData = 607 then
        continue;
      if vData = 609 then
        continue;
      if vData = 611 then
        continue;
      if vData = 613 then
        continue;
      if vData = 615 then
        continue;
      if vData = 617 then
        continue;
      vList.Delete(J); // 抽取完后从列表中删除
      g_BoxsbsImg := vData;
      Break;
    end;
  finally
    vList.Free;
  end;
end;

procedure TFrmDlg.DBoxsTautologyClick(Sender: TObject; X, Y: Integer);
var
  msg: TDefaultMessage;
  AGold, AGameGold: Integer;
begin
  BoxsRandomImg; // 变换颜色
  if g_BoxsMoveDegree >= g_nBoxsUseMax then
    DMessageDlg('宝箱开启次数已用完，无法再次启动转盘！', [mbOK])
  else
  begin
    if not g_boBoxsShowPosition then
    begin
      if g_BoxsFirstMove then
      begin
        AGold := g_nBoxGold + g_nBoxIncGold * g_BoxsMoveDegree;
        AGameGold := g_nBoxGameGold + g_nBoxIncGameGold * g_BoxsMoveDegree;
        if mrOK = DMessageDlg('是否确定要再次启动宝箱转盘？这次启动需要：\　　金币：' + IntToStr(AGold) +
          '\　　元宝：' + IntToStr(AGameGold) + '', [mbOK, mbCancel]) then
        begin
          if (g_dwGameGold >= AGameGold) and (g_nGold >= AGold) then
          begin
            msg := MakeDefaultMsg(CM_MOVEBOXS, 1, 0, 0, 0,
              FrmMain.Certification);
            FrmMain.SendSocket(msg);
            g_boBoxsShowPosition := True;
            g_BoxsCircleNum := 0; // 圈数设为0
            g_boBoxsMiddleItems := False; // 显示中间物品
            Inc(g_BoxsMoveDegree);
          end
          else
            DMessageDlg('你身上的金币或者元宝好象不太够哦！', [mbOK]);
        end;
      end
      else
      begin
        msg := MakeDefaultMsg(CM_MOVEBOXS, 1, 0, 0, 0, FrmMain.Certification);
        FrmMain.SendSocket(msg);
        g_boBoxsShowPosition := True;
        g_BoxsCircleNum := 0; // 圈数设为0
        g_boBoxsMiddleItems := False; // 显示中间物品
        g_BoxsFirstMove := True;
        Inc(g_BoxsMoveDegree);
      end;
    end;
  end;
end;

// 宝箱转动
procedure TFrmDlg.BoxsRunning(dsurface: TAsphyreCanvas);
begin
  if g_boBoxsShowPosition then
  begin
    if (g_BoxsCircleNum > 0) and (g_BoxsCircleNum < 9) then
      g_BoxsShowPositionTime := 50
    else
      g_BoxsShowPositionTime := 400;
    if GetTickCount - g_BoxsShowPositionTick > g_BoxsShowPositionTime then
    begin
      g_BoxsShowPositionTick := GetTickCount;
      Inc(g_BoxsShowPosition);
      g_SoundManager.MyPlaySound(SelectBoxFlash_ground); // 点宝箱声音
      if g_BoxsShowPosition > 7 then
      begin
        g_BoxsShowPosition := 0;
        Inc(g_BoxsCircleNum); // 转动圈数
      end;
      if g_BoxsCircleNum >= 9 then
      begin
        if g_BoxSItems[g_BoxsShowPosition].MakeIndex = g_BoxsMakeIndex then
        begin
          g_boBoxsShowPosition := False;
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DBoxsTautologyMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ShowHint(DBoxsTautology.SurfaceX(DBoxsTautology.Left) - 62,
    DBoxsTautology.SurfaceY(DBoxsTautology.Top) - 16, '启动乾坤挪移换取一件外圈物品',
    clWhite, False);
end;

procedure TFrmDlg.DBPayClick(Sender: TObject; X, Y: Integer);
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  FrmMain.SendOpenPayHome;
end;

procedure TFrmDlg.DBReadMailClick(Sender: TObject; X, Y: Integer);
begin
  if (g_Mail.Count > 0) and (g_Mail.SelIndex >= 0) and
    (g_Mail.SelIndex < g_Mail.Count) then
  begin
    if DMailWriter.visible then
      DMailWriter.visible := False;
    DMailReader.Left := DMailList.Left + DMailList.WIDTH;
    DMailReader.Top := DMailList.Top;
    if g_Mail.Selected.Loaded then
    begin
      DMMReader.Lines.Text := g_Mail.Selected.Content;
      DMMReader.BuildLines;
    end
    else
    begin
      DMMReader.Lines.Text := '(载入中...)';
      FrmMain.SendGetMailData(g_Mail.Selected.Index);
    end;
    DMailReader.visible := True;
    SetDFocus(DMailReader);
  end
  else
    g_Application.AddMessageDialog('请选择邮件！', [mbOK]);
end;

procedure TFrmDlg.DBRightBottomPicMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DTWeightText.Visible := False;
  DTExpText.Visible := False;
end;

procedure TFrmDlg.DBRMBottomMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_MAILREAD;
  ScrollTimer.Tag := 1;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DBRMBottomMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DBRMScrollMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMRScrollY := Y;
end;

procedure TFrmDlg.DBRMScrollMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  H: Single;
begin
  if DBRMScroll.Downed then
  begin
    DBRMScroll.Top := DBRMScroll.Top + Y - FMRScrollY;
    if DBRMScroll.Top < DBRMTop.Top + DBRMTop.Height then
      DBRMScroll.Top := DBRMTop.Top + DBRMTop.Height
    else if DBRMScroll.Top > DBRMBottom.Top - DBRMScroll.Height then
      DBRMScroll.Top := DBRMBottom.Top - DBRMScroll.Height;

    H := (DBRMBottom.Top - DBRMTop.Top - DBRMTop.Height - DBRMScroll.Height) /
      DMMReader.Lines.Count;
    DMMReader.TopLine :=
      Round((DBRMScroll.Top - DBRMTop.Top - DBRMTop.Height) / H);
    if DMMReader.TopLine < 0 then
      DMMReader.TopLine := 0
    else if DMMReader.TopLine > DMMReader.Lines.Count - 1 then
      DMMReader.TopLine := DMMReader.Lines.Count - 1;
    FMRScrollY := Y;
  end;
end;

procedure TFrmDlg.DBRMTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_MAILREAD;
  ScrollTimer.Tag := 1;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DBRMTopMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DBSendGoldTypeClick(Sender: TObject; X, Y: Integer);
begin
  if DXPopupMenu.PopVisible then
    DXPopupMenu.HidePopup
  else
  begin
    DXPopupMenu.BeginUpdate;
    DXPopupMenu.Clear;
    DXPopupMenu.AddMenuItem(0, g_sGoldName);
    DXPopupMenu.AddMenuItem(1, g_sGameGoldName);
    DXPopupMenu.EndUpdate;
    DXPopupMenu.Popup(DMailWriter, DBSendGoldType.Left - 40,
      DBSendGoldType.Top + DBSendGoldType.Height, 40 + DBSendGoldType.WIDTH,
      procedure(ATag: Integer; const ACaption: String)begin FSendGoldType :=
      ATag; end);
  end;
end;

procedure TFrmDlg.DBShopCAddClick(Sender: TObject; X, Y: Integer);
begin
  if FShopAmount < 100 then
    Inc(FShopAmount);
  DEShopAmount.Text := IntToStr(FShopAmount);
  DShopBuy.Enabled := FShopAmount > 0;
end;

procedure TFrmDlg.DBShopCDecClick(Sender: TObject; X, Y: Integer);
begin
  if FShopAmount > 0 then
    Dec(FShopAmount);
  DShopBuy.Enabled := FShopAmount > 0;
  DEShopAmount.Text := IntToStr(FShopAmount);
end;

procedure TFrmDlg.DBTitle1Click(Sender: TObject; X, Y: Integer);
var
  ATitle: pTClientHumTitle;
  AIndex: Integer;
begin
  if GetTickCount - TDButton(Sender).TimeTick > 1000 then
  begin
    AIndex := g_TitlesPage * 6 + TDButton(Sender).Tag;
    if (AIndex >= 0) and (AIndex < g_Titles.Count) then
    begin
      ATitle := g_Titles[AIndex];
      if ATitle <> nil then
      begin
        g_Application.AddMessageDialog('确定将“' + ATitle.Item.sName + '”设置为当前称号?',
          [mbOK, mbCancel], procedure(AResult: Integer)
        begin if AResult = mrOK then begin TDButton(Sender).TimeTick :=
          GetTickCount; FrmMain.SendSetActiveTitle(AIndex + 1); end; end);
      end;
    end;
  end;
end;

procedure TFrmDlg.DBTitle1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
  ATitle: pTClientHumTitle;
  AIndex: Integer;
  AButton: TDButton;
begin
  if g_Titles.Count > 0 then
  begin
    AButton := TDButton(Sender);
    AIndex := g_TitlesPage * 6 + AButton.Tag;
    if (AIndex >= 0) and (AIndex < g_Titles.Count) then
    begin
      ATitle := g_Titles[AIndex];
      if ATitle <> nil then
      begin
        D := nil;
        if AButton.Downed then
          D := g_77Title.Images[ATitle.Item.Looks + 2]
        else if AButton.Moveed then
          D := g_77Title.Images[ATitle.Item.Looks + 1];
        if D = nil then
          D := g_77Title.Images[ATitle.Item.Looks];
        if D <> nil then
          dsurface.Draw(AButton.SurfaceX(AButton.Left) + (32 - D.WIDTH) div 2,
            AButton.SurfaceY(AButton.Top) + (AButton.Height - D.Height)
            div 2, D);

        ATexture := FontManager.Default.TextOut(ATitle.Item.sName);
        if ATexture <> nil then
          dsurface.Draw(AButton.SurfaceX(AButton.Left) + 40,
            AButton.SurfaceY(AButton.Top) + 8, ATexture,
            cColor4(cColor1(GetRGB(ATitle.Item.Color))));
      end;
    end;
  end;
end;

procedure TFrmDlg.DBTitle1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  g_FocusTitle := g_TitlesPage * 6 + TDButton(Sender).Tag;
end;

procedure TFrmDlg.DBTitleInfoDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  AHumTitle: pTClientHumTitle;
  ARow, bbx, bby: Integer;
begin
  if (g_FocusTitle >= 0) and (g_FocusTitle < g_Titles.Count) then
  begin
    AHumTitle := g_Titles[g_FocusTitle];
    if AHumTitle <> nil then
    begin
      With Sender As TDButton do
      begin
        bbx := SurfaceX(Left) + Propertites.OffsetX;
        bby := SurfaceY(Top) + Propertites.OffsetY;
      end;

      ARow := 0;
      if (AHumTitle.Item.AC > 0) or (AHumTitle.Item.ACMax > 0) then
      begin
        dsurface.BoldText('防御 ' + IntToStr(AHumTitle.Item.AC) + '-' +
          IntToStr(AHumTitle.Item.ACMax), clSilver, FontBorderColor, bbx,
          bby + 14 * ARow);
        Inc(ARow);
      end;
      if (AHumTitle.Item.MAC > 0) or (AHumTitle.Item.MACMax > 0) then
      begin
        dsurface.BoldText('魔防 ' + IntToStr(AHumTitle.Item.MAC) + '-' +
          IntToStr(AHumTitle.Item.MACMax), clSilver, FontBorderColor, bbx,
          bby + 14 * ARow);
        Inc(ARow);
      end;
      if (AHumTitle.Item.DC > 0) or (AHumTitle.Item.DCMax > 0) then
      begin
        dsurface.BoldText('攻击 ' + IntToStr(AHumTitle.Item.DC) + '-' +
          IntToStr(AHumTitle.Item.DCMax), clSilver, FontBorderColor, bbx,
          bby + 14 * ARow);
        Inc(ARow);
      end;
      if (AHumTitle.Item.MC > 0) or (AHumTitle.Item.MCMax > 0) then
      begin
        dsurface.BoldText('魔法 ' + IntToStr(AHumTitle.Item.MC) + '-' +
          IntToStr(AHumTitle.Item.MCMax), clSilver, FontBorderColor, bbx,
          bby + 14 * ARow);
        Inc(ARow);
      end;
      if (AHumTitle.Item.SC > 0) or (AHumTitle.Item.SCMax > 0) then
      begin
        dsurface.BoldText('道术 ' + IntToStr(AHumTitle.Item.SC) + '-' +
          IntToStr(AHumTitle.Item.SCMax), clSilver, FontBorderColor, bbx,
          bby + 14 * ARow);
        Inc(ARow);
      end;
      if (cjARCHER in g_ServerJobs) and
        ((AHumTitle.Item.Tc > 0) or (AHumTitle.Item.TCMax > 0)) then
      begin
        dsurface.BoldText('箭术 ' + IntToStr(AHumTitle.Item.Tc) + '-' +
          IntToStr(AHumTitle.Item.TCMax), clSilver, FontBorderColor, bbx,
          bby + 14 * ARow);
        Inc(ARow);
      end;
      if (cjCIK in g_ServerJobs) and
        ((AHumTitle.Item.Pc > 0) or (AHumTitle.Item.PCMax > 0)) then
      begin
        dsurface.BoldText('刺术 ' + IntToStr(AHumTitle.Item.Pc) + '-' +
          IntToStr(AHumTitle.Item.PCMax), clSilver, FontBorderColor, bbx,
          bby + 14 * ARow);
        Inc(ARow);
      end;
      if (cjShaman in g_ServerJobs) and
        ((AHumTitle.Item.Wc > 0) or (AHumTitle.Item.WCMax > 0)) then
      begin
        dsurface.BoldText('武术 ' + IntToStr(AHumTitle.Item.Wc) + '-' +
          IntToStr(AHumTitle.Item.WCMax), clSilver, FontBorderColor, bbx,
          bby + 14 * ARow);
        Inc(ARow);
      end;
      if AHumTitle.Item.HitPoint > 0 then
      begin
        dsurface.BoldText('准确 ' + IntToStr(AHumTitle.Item.HitPoint), clSilver,
          FontBorderColor, bbx, bby + 14 * ARow);
        Inc(ARow);
      end;
      if AHumTitle.Item.AntiPoison > 0 then
      begin
        dsurface.BoldText('中毒防御 ' + IntToStr(AHumTitle.Item.AntiPoison) + '%',
          clSilver, FontBorderColor, bbx, bby + 14 * ARow);
        Inc(ARow);
      end;
      if AHumTitle.Item.PoisonRecover > 0 then
      begin
        dsurface.BoldText('中毒恢复 ' + IntToStr(AHumTitle.Item.PoisonRecover) +
          '%', clSilver, FontBorderColor, bbx, bby + 14 * ARow);
        Inc(ARow);
      end;
      if AHumTitle.Item.AntiMagic > 0 then
      begin
        dsurface.BoldText('魔法躲避 ' + IntToStr(AHumTitle.Item.AntiMagic) + '%',
          clSilver, FontBorderColor, bbx, bby + 14 * ARow);
        Inc(ARow);
      end;
      if AHumTitle.Item.HealthRecover > 0 then
      begin
        dsurface.BoldText('体力值恢复 ' + IntToStr(AHumTitle.Item.HealthRecover) +
          '%', clSilver, FontBorderColor, bbx, bby + 14 * ARow);
        Inc(ARow);
      end;
      if AHumTitle.Item.SpellRecover > 0 then
      begin
        dsurface.BoldText('魔力值恢复 ' + IntToStr(AHumTitle.Item.SpellRecover) +
          '%', clSilver, FontBorderColor, bbx, bby + 14 * ARow);
        Inc(ARow);
      end;
      if AHumTitle.Limit <> 0 then
        dsurface.BoldText('到期时间 ' + FormatDateTime('yyyy-MM-dd hh:mm',
          AHumTitle.Limit), clLime, FontBorderColor, bbx, bby + 14 * ARow);
    end;
  end;
end;

procedure TFrmDlg.DBTitleNextClick(Sender: TObject; X, Y: Integer);
begin
  if g_TitlesPage < Ceil(g_Titles.Count / 6) - 1 then
  begin
    Inc(g_TitlesPage);
    if g_TitlesPage < 0 then
      g_TitlesPage := 0;
  end;

  SetTitlePage(g_TitlesPage);
end;

procedure TFrmDlg.DBTitlePreClick(Sender: TObject; X, Y: Integer);
begin
  if g_TitlesPage > 0 then
    Dec(g_TitlesPage);

  SetTitlePage(g_TitlesPage);
end;

procedure TFrmDlg.DBufferButtonsInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  IsRealArea := False;
end;

procedure TFrmDlg.DButtonSideBarClick(Sender: TObject; X, Y: Integer);
begin
  FSideButtonExpand := not FSideButtonExpand;
  RecalcSideBarButtons;
end;

procedure TFrmDlg.DBWeatherDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  if DBWeather.Images <> nil then
  begin
    case g_nDayBright of
      1:
        D := DBWeather.Images.Images[DBWeather.Propertites.ImageIndex]; // 白天
      2:
        D := DBWeather.Images.Images[DBWeather.Propertites.ImageIndex + 1]; // 傍晚
      3:
        D := DBWeather.Images.Images[DBWeather.Propertites.ImageIndex + 2]; // 晚上
      0:
        D := DBWeather.Images.Images[DBWeather.Propertites.ImageIndex + 3]; // 早上
    end;
  end;

  if D <> nil then
  begin
    dsurface.Draw(DBWeather.SurfaceX(DBWeather.Left),
      DBWeather.SurfaceY(DBWeather.Top), D);
  end;
end;

procedure TFrmDlg.DBWMBottomMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_MAILWRITE;
  ScrollTimer.Tag := 2;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DBWMBottomMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DBWMScrollMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMRScrollY := Y;
end;

procedure TFrmDlg.DBWMScrollMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  H: Single;
begin
  if DBWMScroll.Downed then
  begin
    DBWMScroll.Top := DBWMScroll.Top + Y - FMRScrollY;
    if DBWMScroll.Top < DBWMTop.Top + DBWMTop.Height then
      DBWMScroll.Top := DBWMTop.Top + DBWMTop.Height
    else if DBWMScroll.Top > DBWMBottom.Top - DBWMScroll.Height then
      DBWMScroll.Top := DBWMBottom.Top - DBWMScroll.Height;
    H := (DBWMBottom.Top - DBWMTop.Top - DBWMTop.Height - DBWMScroll.Height) /
      DMMailEdit.Lines.Count;
    DMMailEdit.TopLine :=
      Round((DBWMScroll.Top - DBWMTop.Top - DBWMTop.Height) / H);
    if DMMailEdit.TopLine < 0 then
      DMMailEdit.TopLine := 0
    else if DMMailEdit.TopLine > DMMailEdit.Lines.Count - 1 then
      DMMailEdit.TopLine := DMMailEdit.Lines.Count - 1;
    FMRScrollY := Y;
  end;
end;

procedure TFrmDlg.DBWMTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_MAILWRITE;
  ScrollTimer.Tag := 1;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DBWMTopMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DBZhuliStateDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ax, ay, sex, nColor, Idx: Integer;
begin
//  with DBZhuliState do
//  begin
//    if UserState1.UseItems[U_ZHULI].Name <> '' then
//    begin
//      Idx := UserState1.UseItems[U_ZHULI].Looks;
//      if Idx >= 0 then
//      begin
//        D := GetStateItemImgXY(Idx, ax, ay);
//        ax := ax + Propertites.OffsetX;
//        ay := ay + Propertites.OffsetY;
//        if D <> nil then
//          dsurface.Draw(SurfaceX(Left + ax), SurfaceY(Top + ay),
//            D.ClientRect, D, True);
//      end;
//    end
//  end;
end;

procedure TFrmDlg.DBoxsBelt1DblClick(Sender: TObject);
var
  msg: TDefaultMessage;
begin
  if g_boLockMoveItem then
    Exit;
  if not g_boBoxsShowPosition then
  begin
    if g_BoxSItems[TDButton(Sender).Tag].Name <> '' then
    begin
      if g_BoxsShowPosition = TDButton(Sender).Tag then
      begin
        msg := MakeDefaultMsg(CM_GETBOXS, 0, 0, 0, 0, FrmMain.Certification);
        FrmMain.SendSocket(msg);
        DBoxs.visible := False;
        ShowBoxsGird(False);
        g_BoxsShowPosition := -1;
        g_boBoxsShowPosition := False;
      end;
    end;
  end;
end;

procedure TFrmDlg.DItemsUpButMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Trim(ClientConf.sRefineName) <> '' then
    DScreen.ShowHint(DItemsUpBut.SurfaceX(DItemsUpBut.Left),
      DItemsUpBut.SurfaceY(DItemsUpBut.Top + DItemsUpBut.Height),
      ClientConf.sRefineName, clWhite, False);
end;

procedure TFrmDlg.DItemsUpButClick(Sender: TObject; X, Y: Integer);
begin
  if Trim(ClientConf.sRefineName) <> '' then
  begin
    if not DItemsUp.visible then
    begin
      if GetTickCount - DItemsUp.TimeTick > 300 then
      begin
        DItemsUp.TimeTick := GetTickCount;
        FrmMain.SendOpenRefineBox;
      end;
    end
    else
      SetDFocus(DItemsUp);
  end;
end;

procedure TFrmDlg.DItemBagMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.ReBuildGropuUI;
begin
  DGrpAddMem.visible := False;
  DGrpDelMem.visible := False;
  DGrpDismiss.visible := False;
  DGrpExit.Visible := False;
  if g_GroupMembers.Count > 0 then
  begin
    if g_ISGroupMaster then
    begin
      DGrpAddMem.visible := True;
      DGrpDelMem.visible := True;
      DGrpDismiss.visible := True;
    end
    else
    begin
      DGrpExit.visible := True;
    end;
  end
  else
  begin
    DGrpAddMem.visible := True;
  end;
end;

procedure TFrmDlg.ReBuildGroupHeadUI;
begin
  DWGroups.Height := (g_GroupMembers.Count - 2) * 46;
  ViewGroupHeadHealtBox(g_GroupMembers.Count > 0);
end;

procedure TFrmDlg.RefuseCRYClick(Sender: TObject; X, Y: Integer);
begin
  if g_RefuseCRY then
  begin
    g_RefuseCRY := False;
  end
  else
  begin
    g_RefuseCRY := True;
  end;
  FrmMain.SendMessageState(1, g_RefuseCRY);
end;

procedure TFrmDlg.AutoCRYClick(Sender: TObject; X, Y: Integer);
begin
  g_boAutoTalk := not g_boAutoTalk;
  if g_boAutoTalk then
  begin
    g_sAutoTalkStr := DEChat.Text;
    FrmMain.AddChatBoardString('【提示】[启用了自动喊话功能，聊天框中的内容已记录为喊话内容]',
      GetRGB(219), clWhite)
  end
  else
  begin
    g_sAutoTalkStr := '';
    FrmMain.AddChatBoardString('【提示】[自动喊话功能已关闭]', GetRGB(219), clWhite)
  end;
end;

// 物品发光变换函数 20080223
procedure TFrmDlg.ItemLightTimeImg();
begin
  if GetTickCount - ItemLightTimeTick > 200 then
  begin
    ItemLightTimeTick := GetTickCount;
    Inc(ItemLightImgIdx);
    if ItemLightImgIdx > 5 then
      ItemLightImgIdx := 0;
  end;
end;

// 物品发光变换函数 20091222
procedure TFrmDlg.ItemFlashTime();
begin
  if GetTickCount - g_ItemFlashTick > 200 then
  begin
    g_ItemFlashTick := GetTickCount;
    Inc(g_ItemFlash);
    Inc(g_ItemFlash32);
    if g_ItemFlash >= 8 then
      g_ItemFlash := 0;
    if g_ItemFlash32 >= 32 then
      g_ItemFlash32 := 0;
  end;
end;

procedure TFrmDlg.DHairUSDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  hair, sex, ax, ay: Integer;
  D: TAsphyreLockableTexture;
begin
  with DHairUS do
  begin
    hair := HAIRfeature(UserState1.Feature);
    sex := GenderFeature(UserState1.Feature);

    D := GetHumInnerHairImg(UserState1.job, sex, hair, ax, ay);
    if D <> nil then
      dsurface.Draw(SurfaceX(Left + ax), SurfaceY(Top + ay), D.ClientRect,
        D, True); //
  end;
end;

procedure TFrmDlg.DHeiMingDanClick(Sender: TObject; X, Y: Integer);
begin
  DHeiMingDan.Top := 84;
  DPrevFriendDlg.Top := 126;
  DNextFriendDlg.Top := 168;
  DFriendList.Top := 126;
  DAddFriend.Top := 333;
  DAddFriend.Hint := '点击添加黑名单';
  g_btFriendTypePage := TDButton(Sender).Tag;
  if g_btFriendTypePage in [1, 3] then
  begin
    DFriendList.visible := True;
    DAddFriend.visible := True;
    DPrevFriendDlg.visible := True;
    DNextFriendDlg.visible := True;
    g_btFriendPage := 0;
  end;
end;

procedure TFrmDlg.DHelmetUS1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ax, bbx, bby, ay, sex, nColor, Idx: Integer;
begin
  With DHelmetUS1 do
  begin
    if UserState1.UseItems[U_HELMET].Name <> '' then
    begin
      Idx := UserState1.UseItems[U_HELMET].Looks;
      if Idx >= 0 then
      begin
        D := GetStateItemImgXY(Idx, ax, ay);
        ax := ax + Propertites.OffsetX;
        ay := ay + Propertites.OffsetY;
        if D <> nil then
          dsurface.Draw(SurfaceX(Left + ax), SurfaceY(Top + ay),
            D.ClientRect, D, True);
      end;
    end;
  end;
end;

procedure TFrmDlg.DHelpClick(Sender: TObject; X, Y: Integer);
begin
  FrmMain.SendHelpClick;
end;

procedure TFrmDlg.DLabelMissionsClick(Sender: TObject; X, Y: Integer);
begin
  if (g_SelectMission >= 0) and (g_SelectMission < g_Missions.DoingCount) then
  begin
    if g_SelectMission > 16 then
      g_MissionListTopIndex := g_SelectMission
    else
      g_MissionListTopIndex := 0;
    g_MissionListFocused := g_SelectMission;
    ShowMissionDetail(False);
    UpdateMissionContent;
    g_SoundManager.DXPlaySound(s_glass_button_click);
  end;
end;

procedure TFrmDlg.DLabelMissionsDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  r: TRect;
  I, X, Y, OX: Integer;
  ATexturePre, ATexture: TAsphyreLockableTexture;
begin
  with DWMiniMissions do
  begin
    X := SurfaceX(Left);
    Y := SurfaceY(Top);
    r := Bounds(X + 4, Y, DWMiniMissions.WIDTH, DWMiniMissions.Height);
    g_GameCanvas.FillRectAlpha(r, $00101113, 175);
    g_GameCanvas.FrameRect(r, cColorAlpha4(cColor1(clBlack), 175));
    if g_MissionTopIndex >= 0 then
    begin
      for I := g_MissionTopIndex to g_MissionTopIndex + 8 do
      begin
        if I > g_Missions.DoingCount - 1 then
          Break;
        OX := 0;
        ATexture := FontManager.
          Default.TextOut(_MISSION_KINDS_[g_Missions.Doing[I].Kind]);
        if ATexture <> nil then
        begin
          OX := OX + ATexture.WIDTH + 2;
          dsurface.DrawText(X + 8, Y + 8, ATexture,
            _MISSION_COLOR_[g_Missions.Doing[I].Kind]);
        end;
        if I = g_SelectMission then
          ATexture := FontManager.GetFont(DefaultFontName, DefaultFontSize,
            [fsUnderLine]).TextOut(g_Missions.Doing[I].Subject)
        else
          ATexture := FontManager.Default.TextOut(g_Missions.Doing[I].Subject);
        dsurface.Draw(X + 8 + OX, Y + 8, ATexture);
        if g_Missions.Doing[I].State = msCompleted then
        begin
          OX := X + 8 + OX + ATexture.WIDTH;
          ATexturePre := g_77Images.Images[480];
          if ATexturePre <> nil then
            dsurface.Draw(OX, Y + 8, ATexturePre);
        end;
        Y := Y + 16;
      end;
    end;
  end;
end;

procedure TFrmDlg.DLabelMissionsInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  IsRealArea := True;
end;

procedure TFrmDlg.DLabelMissionsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  AIndex: Integer;
begin
  g_SelectMission := -1;
  if (X > 4) and (Y > 8) then
  begin
    AIndex := (Y - 8) div 16;
    if AIndex in [0 .. 8] then
      g_SelectMission := g_MissionTopIndex + AIndex;
  end;
  DScreen.ClearHint;
end;

procedure TFrmDlg.DLBLHelpTextDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
  I : Integer;
  nX,nY : Integer;
begin
  if NAHelps.Count > 0 then
  for I := 0 to NAHelps.Count - 1 do
  begin
    nX := DLBLHelpText.SurfaceX(DLBLHelpText.Left);
    nY := DLBLHelpText.SurfaceY(DLBLHelpText.Top);
      dsurface.TextOut(nX,
        nY +  I * 14, NAHelps[I], clSilver);
  end;
  dsurface.BoldText(362, 121, NewAccountTitle, clWhite, clBlack);
end;

procedure TFrmDlg.DLevelOrderClick(Sender: TObject; X, Y: Integer);
begin
  Y := Y - DLevelOrder.SurfaceY(DLevelOrder.Top);
  if (Y >= 112) and (Y <= 272) then
  begin
    g_Orders.SelectOrder := (Y - 112) div 16;
    if g_Orders.SelectOrder > g_Orders.Items.Count - 1 then
      g_Orders.SelectOrder := -1
    else
      g_SoundManager.DXPlaySound(s_glass_button_click);
  end;
end;

{ ****************************************************************************** }
// 元宝寄售显示窗口 20080316
procedure TFrmDlg.ShowShopSellOffDlg;
begin
  DMenuDlg.visible := False;
  DItemBag.visible := True;
  LastestClickTime := GetTickCount;
  g_sSellPriceStr := '';
  g_SellOffName := '';
  g_SellOffGameGold := 0;
  g_SellOffGameDiaMond := 0;
  // g_boSellOffEnd := False;
end;

procedure TFrmDlg.DSelServerDlgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    DSServer1Click(DSServer1,0,0);
  end;
end;

// 显示寄售列表界面 20080317
procedure TFrmDlg.ShowSellOffListDlg;
begin
 // MenuIndex := -1;
  DMerchantDlg.Left := 0;
  DMerchantDlg.Top := 0;
  DMerchantDlg.visible := True;

  DItemBag.Left := DMerchantDlg.Width + 24;
  DItemBag.Top := 0;
  DItemBag.visible := True;

  LastestClickTime := GetTickCount;
end;

{ ****************************************************************************** }
procedure TFrmDlg.DWSplitItemAddMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IncSplitItemCount(1);
  FScrollType := _ST_SPLITITEM;
  ScrollTimer.Tag := 1;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DWSplitItemAddMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DWSplitItemCancelClick(Sender: TObject; X, Y: Integer);
begin
  DWSplitItem.visible := False;
end;

procedure TFrmDlg.DWSplitItemDecMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IncSplitItemCount(-1);
  FScrollType := _ST_SPLITITEM;
  ScrollTimer.Tag := 2;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DWSplitItemDecMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DWSplitItemDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATexture: TuTexture;
begin
  with DWSplitItem do
  begin
    D := Propertites.Images.Images[Propertites.ImageIndex];
    dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    ATexture := Textures.ObjectName(dsurface, Caption);
    if ATexture <> nil then
      ATexture.Draw(dsurface, SurfaceX(Left) + 20, SurfaceY(Top) + 44, clWhite);
  end;
end;

procedure TFrmDlg.DWSplitItemEdtChange(Sender: TObject);
var
  c: Integer;
begin
  c := StrToIntDef(DWSplitItemEdt.Text, 0);
  c := Max(1, c);
  if c > FSplitMaxCount then
    c := FSplitMaxCount;
  DWSplitItemEdt.Text := IntToStr(c);
end;

procedure TFrmDlg.DWSplitItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DWSplitItemOKClick(Sender: TObject; X, Y: Integer);
var
  ACount: Integer;
begin
  ACount := StrToIntDef(DWSplitItemEdt.Text, 0);
  ACount := Max(ACount, 0);
  if (ACount > 0) and (ACount < FSplitMaxCount) then
  begin
    DWSplitItem.visible := False;
    FrmMain.SendItemSplit(FSplitMakeIndex, ACount);
  end
  else
    g_Application.AddMessageDialog('拆分数量必须小于当前数量并且不得小于1！', [mbOK]);
end;

procedure TFrmDlg.DWStallQueryWinBuyGridGridMouseMove(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  AIndex: Integer;
  tmpItem: TClientItem;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    tmpItem := g_QueryStallBuyItems[AIndex].Item.Item;
    if tmpItem.Name <> '' then
    begin
      if (tmpItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := tmpItem;
        DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem,
          fkQueryStallBuy, g_QueryStallBuyItems[AIndex].Gold,
          g_QueryStallBuyItems[AIndex].GameGold,
          g_QueryStallBuyItems[AIndex].Count);
      end;
    end
    else
    begin
      g_MouseItem.Name := '';
      DScreen.ClearHint;
    end;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DWStallQueryWinBuyGridGridPaint(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState;
  dsurface: TAsphyreCanvas);
var
  AIndex: Integer;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    with DWStallQueryWinBuyGrid do
      DrawItem(g_QueryStallBuyItems[AIndex].Item.Item, dsurface,
        SurfaceX(Rect.Left), SurfaceY(Rect.Top), ColWidth, RowHeight, TimeTick);
  end;
end;

procedure TFrmDlg.DWStallQueryWinBuyGridGridSelect(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  AIndex: Integer;
  AItemName: String;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  if g_boLockMoveItem then
    Exit;
  if not g_boItemMoving then
    Exit;
  if g_MySelf.m_btStall in [1 .. 4] then
    Exit;

  AIndex := ACol + ARow * 4;
  if (g_MovingItem.Source = msBag) and (AIndex in [0 .. 11]) then
  begin
    if g_QueryStallBuyItems[AIndex].ItemName <> '' then
    begin
      if g_QueryStallBuyItems[AIndex].Item.Item.S.
        Index = g_MovingItem.Item.S.Index then
      begin
        MarketItemIndex := AIndex;
        g_MarketItem.Item := g_QueryStallBuyItems[AIndex].Item;
        g_MarketItem.Item.Item := g_MovingItem.Item;
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
        DScreen.ClearHint;
        ShowStallSaleToBuy;
      end;
    end;
  end;
end;

procedure TFrmDlg.DWStallQueryWinCloseClick(Sender: TObject; X, Y: Integer);
begin
  DWStallQueryWin.visible := False;
end;

procedure TFrmDlg.DWStallQueryWinDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  ATexture: TAsphyreLockableTexture;
  I, L, T: Integer;
begin
  with DWStallQueryWin do
  begin
    L := SurfaceX(Left);
    T := SurfaceY(Top);
    DefaultPaint(dsurface);

//    ATexture := g_77Images.Images[124];
//    if ATexture <> nil then
//      dsurface.Draw(L + 340, T + 194, ATexture);

    if DViewStallLog.Visible then
    begin
      with DViewStallLog do
      begin
        L := SurfaceX(Left);
        T := SurfaceY(Top);
      end;

      if g_QueryStallLogs.Count > 0 then
      begin
        for I := FQueryStallLogTopLine to FQueryStallLogTopLine + 6 do
        begin
          if I > g_QueryStallLogs.Count - 1 then
            Break;
          ATexture := FontManager.Default.TextOut(g_QueryStallLogs[I]);
          if ATexture <> nil then
            dsurface.Draw(L, T + (I - FQueryStallLogTopLine) * 14,
              ATexture);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DWStallQueryWinMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  g_MouseItem.Name := '';
  DScreen.ClearHint;
end;

procedure TFrmDlg.DWStallQueryWinSaleGridGridMouseMove(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  AIndex: Integer;
  tmpItem: TClientItem;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    tmpItem := g_QueryStallItems[AIndex].Item;
    if tmpItem.Name <> '' then
    begin
      if (tmpItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := tmpItem;
        DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkQueryStall,
          g_QueryStallItems[AIndex].Gold, g_QueryStallItems[AIndex].GameGold);
      end;
    end
    else
    begin
      g_MouseItem.Name := '';
      DScreen.ClearHint;
    end;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DWStallQueryWinSaleGridGridPaint(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState;
  dsurface: TAsphyreCanvas);
var
  AIndex: Integer;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    with DWStallQueryWinSaleGrid do
      DrawItem(g_QueryStallItems[AIndex].Item, dsurface, SurfaceX(Rect.Left),
        SurfaceY(Rect.Top), ColWidth, RowHeight, TimeTick);
  end;
end;

procedure TFrmDlg.DWStallQueryWinSaleGridGridSelect(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  AIndex: Integer;
begin
  if g_boLockMoveItem then
    Exit;
  if g_MySelf.m_btStall in [1 .. 4] then
    Exit;
  if g_boItemMoving then
    Exit;

  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    if g_QueryStallItems[AIndex].Item.Name <> '' then
    begin
      MarketItemIndex := AIndex;
      g_MarketItem.Item := g_QueryStallItems[AIndex];
      DScreen.ClearHint;
      ShowStallItemBuy;
    end;
  end;
end;

procedure TFrmDlg.DWStallQueryWinScrollBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FQueryStallLogScrollY := Y;
end;

procedure TFrmDlg.DWStallQueryWinScrollBarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  H: Single;
begin
  if DWStallQueryWinScrollBar.Downed then
  begin
    DWStallQueryWinScrollBar.Top := DWStallQueryWinScrollBar.Top + Y -
      FQueryStallLogScrollY;
    if DWStallQueryWinScrollBar.Top < DWStallQueryWinScrollTop.Top +
      DWStallQueryWinScrollTop.Height then
      DWStallQueryWinScrollBar.Top := DWStallQueryWinScrollTop.Top +
        DWStallQueryWinScrollTop.Height
    else if DWStallQueryWinScrollBar.Top > DWStallQueryWinScrollBttom.Top -
      DWStallQueryWinScrollBar.Height then
      DWStallQueryWinScrollBar.Top := DWStallQueryWinScrollBttom.Top -
        DWStallQueryWinScrollBar.Height;

    H := (DWStallQueryWinScrollBttom.Top - DWStallQueryWinScrollTop.Top -
      DWStallQueryWinScrollTop.Height - DWStallQueryWinScrollBar.Height) /
      g_QueryStallLogs.Count;
    FQueryStallLogTopLine :=
      Round((DWStallQueryWinScrollBar.Top - DWStallQueryWinScrollTop.Top -
      DWStallQueryWinScrollTop.Height) / H);
    if FQueryStallLogTopLine < 0 then
      FQueryStallLogTopLine := 0
    else if FQueryStallLogTopLine > g_QueryStallLogs.Count - 1 then
      FQueryStallLogTopLine := g_QueryStallLogs.Count - 1;
    FQueryStallLogScrollY := Y;
  end;
end;

procedure TFrmDlg.DWStallQueryWinScrollBttomMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_QSTALLLOG;
  ScrollTimer.Tag := 2;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DWStallQueryWinScrollTopMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_QSTALLLOG;
  ScrollTimer.Tag := 1;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DWStallStopClick(Sender: TObject; X, Y: Integer);
begin
  FrmMain.SendStallStop;
end;

procedure TFrmDlg.DWStallWinBuyGridGridMouseMove(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  AIndex: Integer;
  tmpItem: TClientItem;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    tmpItem := g_StallBuyItems[AIndex].Item.Item;
    if tmpItem.Name <> '' then
    begin
      if (tmpItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := tmpItem;
        DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkStallBuy,
          g_StallBuyItems[AIndex].Gold, g_StallBuyItems[AIndex].GameGold,
          g_StallBuyItems[AIndex].Count);
      end;
    end
    else
    begin
      g_MouseItem.Name := '';
      DScreen.ClearHint;
    end;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DWStallWinBuyGridGridPaint(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState;
  dsurface: TAsphyreCanvas);
var
  AIndex: Integer;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    with DWStallWinBuyGrid do
      DrawItem(g_StallBuyItems[AIndex].Item.Item, dsurface, SurfaceX(Rect.Left),
        SurfaceY(Rect.Top), ColWidth, RowHeight, TimeTick);
  end;
end;

procedure TFrmDlg.DWStallWinBuyGridGridSelect(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  AIndex: Integer;
  AItemName: String;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  if g_boLockMoveItem then
    Exit;
  if g_boItemMoving then
    Exit;
  if g_MySelf.m_btStall in [1 .. 4] then
    Exit;

  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    if g_StallBuyItems[AIndex].ItemName = '' then
    begin
      case DMessageDlg('请输入收购物品的名称:', [mbOK, mbCancel, mbAbort]) of
        mrOK:
          AItemName := Trim(FrmDlg.DlgEditText);
        mrCancel:
          Exit;
      end;
      AIndex := GetItemIndexByName(AItemName);
      if AIndex <> -1 then
      begin
        g_MarketItem.Inedex := -1;
        g_MarketItem.Item.Item := GetClientItemByName(AItemName);
        g_MovingItem.Item.Name := AItemName;
        g_boItemMoving := False;
        ShowStallBuyPutOn;
      end
      else
        g_Application.AddMessageDialog(Format('物品“%s”信息不存在！', [AItemName]
          ), [mbOK]);;
    end
    else
    begin
      MarketItemIndex := AIndex;
      DScreen.ClearHint;
      ShowStallBuyItemUpdate;
    end;
  end;
end;

procedure TFrmDlg.DWStallWinCloseClick(Sender: TObject; X, Y: Integer);
begin
  DWStallWin.visible := False;
end;

procedure TFrmDlg.DWStallWinCtrlClick(Sender: TObject; X, Y: Integer);
begin
  FrmMain.SendStallStart;
end;

procedure TFrmDlg.DWStallWinDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  ATexture: TAsphyreLockableTexture;
  I, L, T: Integer;
  S: String;
begin
  with DWStallWin do
  begin
    DefaultPaint(dsurface);
    L := SurfaceX(Left);
    T := SurfaceY(Top);

    DStallGoldValue.Propertites.Caption.Text := GetGoldStr(g_MyStallGold);
    DStallGameGoldValue.Propertites.Caption.Text := GetGoldStr(g_MyStallGameGold);

    if DStallLog.Visible then
    begin
      L := DStallLog.SurfaceX(DStallLog.Left);
      T := DStallLog.SurfaceY(DStallLog.Top);
      if g_StallLogs.Count > 0 then
      begin
        for I := FStallLogTopLine to FStallLogTopLine + 6 do
        begin
          if I > g_StallLogs.Count - 1 then
            Break;
          ATexture := FontManager.Default.TextOut(g_StallLogs[I]);
          if ATexture <> nil then
            dsurface.Draw(L , T  + (I - FStallLogTopLine) * 14,
              ATexture);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DWStallWinGetGoldClick(Sender: TObject; X, Y: Integer);
begin
  if not(g_MySelf.m_btStall in [1 .. 4]) then
    FrmMain.SendStallGetBack;
end;

procedure TFrmDlg.DWStallWinLeaveMsgKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (DWStallWinLeaveMsg.Text <> '') and
    (g_SelMarketPlay <> '') then
  begin
    FrmMain.SendStallMessage(g_SelMarketPlay, DWStallWinLeaveMsg.Text);
    DWStallWinLeaveMsg.Text := '';
  end;
end;

procedure TFrmDlg.DWStallWinMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  g_MouseItem.Name := '';
  DScreen.ClearHint;
end;

procedure TFrmDlg.DWStallWinSaleGridGridMouseMove(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  AIndex: Integer;
  tmpItem: TClientItem;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    tmpItem := g_StallItems[AIndex].Item;
    if tmpItem.Name <> '' then
    begin
      if (tmpItem.MakeIndex = g_MouseItem.MakeIndex) and DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := tmpItem;
        DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkStall,
          g_StallItems[AIndex].Gold, g_StallItems[AIndex].GameGold);
      end;
    end
    else
    begin
      g_MouseItem.Name := '';
      DScreen.ClearHint;
    end;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DWStallWinSaleGridGridPaint(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState;
  dsurface: TAsphyreCanvas);
var
  AIndex: Integer;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    with DWStallWinSaleGrid do
      DrawItem(g_StallItems[AIndex].Item, dsurface, SurfaceX(Rect.Left),
        SurfaceY(Rect.Top), ColWidth, RowHeight, TimeTick);
  end;
end;

procedure TFrmDlg.DWStallWinSaleGridGridSelect(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  AIndex: Integer;
begin
{$IFDEF UIDesinging}Exit; {$ENDIF}
  if g_boLockMoveItem then
    Exit;
  if g_MySelf.m_btStall in [1 .. 4] then
    Exit;

  AIndex := ACol + ARow * 4;
  if AIndex in [0 .. 11] then
  begin
    if g_boItemMoving then
    begin
      if g_MovingItem.Source in [msBag, msStall] then
      begin
        g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
        g_MarketItem.Inedex := -1;
        g_MarketItem.Item.Item := g_MovingItem.Item;
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
        g_boPutOn := True;
        ShowStallPutOn;
      end;
    end
    else
    begin
      if g_StallItems[AIndex].Item.Name <> '' then
      begin
        MarketItemIndex := AIndex;
        DScreen.ClearHint;
        ShowStallItemUpdate;
      end;
    end;
  end;
end;

procedure TFrmDlg.DWStallWinScrollBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FStallLogScrollY := Y;
end;

procedure TFrmDlg.DWStallWinScrollBarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  H: Single;
begin
  if DWStallWinScrollBar.Downed then
  begin
    DWStallWinScrollBar.Top := DWStallWinScrollBar.Top + Y - FStallLogScrollY;
    if DWStallWinScrollBar.Top < DWStallWinScrollTop.Top +
      DWStallWinScrollTop.Height then
      DWStallWinScrollBar.Top := DWStallWinScrollTop.Top +
        DWStallWinScrollTop.Height
    else if DWStallWinScrollBar.Top > DWStallWinScrollBottom.Top -
      DWStallWinScrollBar.Height then
      DWStallWinScrollBar.Top := DWStallWinScrollBottom.Top -
        DWStallWinScrollBar.Height;

    H := (DWStallWinScrollBottom.Top - DWStallWinScrollTop.Top -
      DWStallWinScrollTop.Height - DWStallWinScrollBar.Height) /
      g_StallLogs.Count;
    FStallLogTopLine := Round((DWStallWinScrollBar.Top - DWStallWinScrollTop.Top
      - DWStallWinScrollTop.Height) / H);
    if FStallLogTopLine < 0 then
      FStallLogTopLine := 0
    else if FStallLogTopLine > g_StallLogs.Count - 1 then
      FStallLogTopLine := g_StallLogs.Count - 1;
    FStallLogScrollY := Y;
  end;
end;

procedure TFrmDlg.DWStallWinScrollBottomMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_STALLLOG;
  ScrollTimer.Tag := 2;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DWStallWinScrollBottomMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DWStallWinScrollTopMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_STALLLOG;
  ScrollTimer.Tag := 1;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DWStallWinScrollTopMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DWMiniMissionsInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  IsRealArea := False;
end;

procedure TFrmDlg.DWMiniMissionsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DWMissionsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  g_MissionListSelected := -1;
end;

procedure TFrmDlg.DWMiniMapCtrClick(Sender: TObject; X, Y: Integer);
begin
  g_boMiniMapExpand := not g_boMiniMapExpand;
  DBMiniMapImage.visible := g_boMiniMapExpand;
end;

procedure TFrmDlg.DWMiniMapDblClick(Sender: TObject);
begin
  if g_boSDMinimap and (g_btMiniMapType = 2) then
  begin
    g_uAutoRun := False;
    if (g_nMouseMinMapX >= 0) and (g_nMouseMinMapY >= 0) then
    begin
      FrmMain.AutoGoto(g_nMouseMinMapX, g_nMouseMinMapY);
      g_boISTrail := False;
    end;
  end;
end;

procedure TFrmDlg.DWMiniMapInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  IsRealArea := g_boSDMinimap or (g_boMiniMapExpand or (Y <= 25));
end;

procedure TFrmDlg.DWMiniMapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    if g_boMiniMapExpand or g_boSDMinimap then
    begin
      g_boTransparentMiniMap := not g_boTransparentMiniMap;
    end;
  end;
end;

procedure TFrmDlg.DSelectChrMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DBoxsTautologyDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with DBoxsTautology do
  begin
    DefaultPaint(dsurface);

    if GetTickCount - g_dwBoxsTautologyTick > 400 then
    begin
      g_dwBoxsTautologyTick := GetTickCount;
      Inc(g_BoxsTautologyImg);
      if g_BoxsTautologyImg > 3 then
        g_BoxsTautologyImg := 0;
    end;
    D := g_WMain3Images.Images[515 + g_BoxsTautologyImg];
    dsurface.DrawBlend(SurfaceX(Left - 10), SurfaceY(Top - 20), D, 1);
  end;

end;

procedure TFrmDlg.DItemsUpBelt1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  with Sender as TDButton do
  begin
    DrawItem(g_ItemsUpItem[Tag], dsurface, SurfaceX(Left), SurfaceY(Top), WIDTH,
      Height, TimeTick);
  end;
end;

procedure TFrmDlg.DItemsRefreshClick(Sender: TObject; X, Y: Integer);
begin
  if g_boLockMoveItem then
    Exit;
  ReloadBagItems;
end;

procedure TFrmDlg.DItemsRefreshDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with DItemsRefresh do
  begin
    D := nil;
    if CanRefreshBag then
    begin
      if Downed then
        D := Propertites.Images.Images[Propertites.DownedIndex]
      else
        D := Propertites.Images.Images[Propertites.ImageIndex];
    end
    else
      D := Propertites.Images.Images[Propertites.DisabledIndex];

    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
  end;
end;

procedure TFrmDlg.DItemsUpBelt1Click(Sender: TObject; X, Y: Integer);
var
  temp: TClientItem;
  Butt: TDButton;
begin
  if g_boLockMoveItem then
    Exit;
  Butt := TDButton(Sender);
  if not g_boItemMoving then
  begin
    if g_ItemsUpItem[Butt.Tag].Name <> '' then
    begin
      g_SoundManager.ItemClickSound(g_ItemsUpItem[Butt.Tag].S);
      if g_MovingItem.Item.Name <> '' then
        Exit;

      g_boItemMoving := True;
      g_MovingItem.FromIndex := Butt.Tag;
      g_MovingItem.Source := msItemUp;
      g_MovingItem.Item := g_ItemsUpItem[Butt.Tag];
      g_ItemsUpItem[Butt.Tag].Name := '';
    end;
  end
  else
  begin
    if g_MovingItem.Source in [msBag, msItemUp] then
    begin
      g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
      if g_ItemsUpItem[Butt.Tag].Name <> '' then
      begin // 磊府俊 乐栏搁
        temp := g_ItemsUpItem[Butt.Tag];
        g_ItemsUpItem[Butt.Tag] := g_MovingItem.Item;
        g_MovingItem.FromIndex := Butt.Tag;
        g_MovingItem.Source := msItemUp;
        g_MovingItem.Item := temp
      end
      else
      begin
        g_ItemsUpItem[Butt.Tag] := g_MovingItem.Item;
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
      end;
    end;
  end;
end;

procedure TFrmDlg.DItemsUpOkClick(Sender: TObject; X, Y: Integer);
begin
  if (g_ItemsUpItem[0].Name = '') or (g_ItemsUpItem[1].Name = '') or
    (g_ItemsUpItem[2].Name = '') then
    Exit;

  if GetTickCount - DItemsUpOk.TimeTick > 3000 then
  begin
    FrmMain.SendItemUpOK();
    DItemsUpOk.TimeTick := GetTickCount;
  end;
end;

procedure TFrmDlg.DItemsUpVisibleChange(Sender: TObject);
begin
  if not DItemsUp.visible then
  begin
    if g_ItemsUpItem[0].Name <> '' then
    begin
      AddItemBag(g_ItemsUpItem[0]);
      g_ItemsUpItem[0].Name := '';
    end;
    if g_ItemsUpItem[1].Name <> '' then
    begin
      AddItemBag(g_ItemsUpItem[1]);
      g_ItemsUpItem[1].Name := '';
    end;
    if g_ItemsUpItem[2].Name <> '' then
    begin
      AddItemBag(g_ItemsUpItem[2]);
      g_ItemsUpItem[2].Name := '';
    end;
  end;
end;

procedure TFrmDlg.DItemsUpBelt1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Idx: Integer;
begin
  Idx := TDButton(Sender).Tag;
  if Idx in [0 .. 2] then
  begin
    if g_ItemsUpItem[Idx].Name <> '' then
    begin
      if (g_ItemsUpItem[Idx].MakeIndex = g_MouseItem.MakeIndex) and
        DScreen.ItemHint then
        DScreen.UpdateItemHintPostion(g_Application._CurPos)
      else
      begin
        g_MouseItem := g_ItemsUpItem[Idx];
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

procedure TFrmDlg.DItemsUpCloseClick(Sender: TObject; X, Y: Integer);
begin
  DItemsUp.visible := False;
end;

procedure TFrmDlg.DItemsUpMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  g_MouseItem.Name := '';
  DScreen.ClearHint;
end;

procedure TFrmDlg.DPlayGameNum();
var
  J, vData: Integer;
begin
  if GetTickCount - g_DwPlayDrinkTick > 50 then
  begin
    g_DwPlayDrinkTick := GetTickCount;
    if g_nImgLeft < 130 then
      Inc(g_nImgLeft, 30)
    else
      Inc(g_nPlayDrinkDelay);
    if g_nImgLeft > 100 then
      DPlayDrinkWhoWin.visible := True; // 显示谁赢
    if g_nPlayDrinkDelay > 30 then
    begin
      g_boPlayDrink := False;
      ShowPlayDrinkImg(False);
      if g_btWhoWin = 1 then
      begin // NPC赢
        if g_NpcRandomDrinkList.Count = 0 then
          Exit;
        Randomize(); // 随机种子
        J := Random(g_NpcRandomDrinkList.Count); // 从余下的酒中随机选一瓶
        vData := Integer(g_NpcRandomDrinkList[J]);
        g_NpcRandomDrinkList.Delete(J); // 抽取完后从列表中删除
        g_btNpcDrinkTarget := vData; // 随机目标
        g_boNpcAutoSelDrink := True; // 自动选酒
        g_nNpcSelDrinkPosition := -1; // 位置初始化
        g_btNpcAutoSelDrinkCircleNum := 0; // 初始化圈数
      end;
    end;
  end;
end;

procedure TFrmDlg.DPlayDrinkDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
// procedure PlayDrinkTextOut1(dsurface: TAsphyreCanvas);
// var
// str, data, fdata, cmdstr, cmdparam: string;
// lx, ly, sx: Integer;
// // DrawCenter: Boolean;
// pcp: pTClickPoint;
// colorg: string; // 得到NPC颜色码
// color123: TColor; // npc字颜色
// CmdIndex: Integer;
// begin
// with DPlayDrink do
// begin
// lx := 120;
// ly := 46;
// CmdIndex := 0;
// str := g_sPlayDrinkStr1;
// // DrawCenter := FALSE;
// while True do
// begin
// if str = '' then
// break;
// str := GetValidStr3(str, data, ['\']);
// if data <> '' then
// begin
// sx := 0;
// fdata := '';
// while (pos('<', data) > 0) and (pos('>', data) > 0) and (data <> '') do
// begin
// if data[1] <> '<' then
// begin
// data := '<' + GetValidStr3(data, fdata, ['<']);
// end;
// data := ArrestStringEx(data, '<', '>', cmdstr); // 得到"<"和">" 号之间的字   赋予给 cmdstr
// if cmdstr <> '' then
// begin
// if Uppercase(cmdstr) = 'C' then
// begin
// // drawcenter := TRUE;
// continue;
// end;
// if Uppercase(cmdstr) = '/C' then
// begin
// // drawcenter := FALSE;
// continue;
// end;
// cmdparam := GetValidStr3(cmdstr, cmdstr, ['/']); // cmdparam : 命令参数
// colorg := GetValidStr3(cmdparam, colorg, ['=']); // 从NPC脚本中得到字颜色编码
// color123 := GetRGB(Str_ToInt(colorg, 0)); // str转换byte
// end
// else
// begin
// DPlayDrink.visible := False;
// end;
//
// if fdata <> '' then
// begin
// DSurface.TextOut(fdata, clWhite, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// sx := sx + FrmMain.Canvas.TextWidth(fdata);
// end;
// if cmdstr <> '' then
// begin
// if g_boRequireAddPoints1 then
// begin
// New(pcp);
// pcp.rc := Rect(lx + sx, ly, lx + sx + FrmMain.Canvas.TextWidth(cmdstr), ly + 14);
// pcp.RStr := cmdparam;
// pcp.Index := CmdIndex;
// g_PlayDrinkPoints.Add(pcp);
// end;
// if SelectMenuIndex = CmdIndex then
// DSurface.TextOut(cmdstr, clRed, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly))
// else
// begin
// if Str_ToInt(colorg, 0) <> 0 then
// begin
// //dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline]; // 去掉字体下面的下划线
// DSurface.TextOut(cmdstr, color123, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly)) // 显示颜色文字
// end
// else
// DSurface.TextOut(cmdstr, clYellow, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// end;
// sx := sx + FrmMain.Canvas.TextWidth(cmdstr);
// //dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline];
// Inc(CmdIndex);
// end;
// end;
// if data <> '' then
// DSurface.TextOut(data, clWhite, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// end;
// ly := ly + 16;
// end;
// g_boRequireAddPoints1 := False;
// end;
// end;
// procedure PlayDrinkTextOut2(dsurface: TAsphyreCanvas);
// var
// str, data, fdata, cmdstr, cmdparam: string;
// lx, ly, sx: Integer;
// // DrawCenter: Boolean;
// pcp: pTClickPoint;
// colorg: string; // 得到NPC颜色码
// color123: TColor; // npc字颜色
// CmdIndex: Integer;
// begin
// with DPlayDrink do
// begin
// lx := 120;
// ly := 274;
// CmdIndex := 0;
// str := g_sPlayDrinkStr2;
// // DrawCenter := FALSE;
// while True do
// begin
// if str = '' then
// break;
// str := GetValidStr3(str, data, ['\']);
// if data <> '' then
// begin
// sx := 0;
// fdata := '';
// while (pos('<', data) > 0) and (pos('>', data) > 0) and (data <> '') do
// begin
// if data[1] <> '<' then
// begin
// data := '<' + GetValidStr3(data, fdata, ['<']);
// end;
// data := ArrestStringEx(data, '<', '>', cmdstr); // 得到"<"和">" 号之间的字   赋予给 cmdstr
// if cmdstr <> '' then
// begin
// if Uppercase(cmdstr) = 'C' then
// begin
// // drawcenter := TRUE;
// continue;
// end;
// if Uppercase(cmdstr) = '/C' then
// begin
// // drawcenter := FALSE;
// continue;
// end;
// cmdparam := GetValidStr3(cmdstr, cmdstr, ['/']); // cmdparam : 命令参数
// colorg := GetValidStr3(cmdparam, colorg, ['=']); // 从NPC脚本中得到字颜色编码
// color123 := GetRGB(Str_ToInt(colorg, 0)); // str转换byte
// end
// else
// begin
// DPlayDrink.visible := False;
// end;
//
// if fdata <> '' then
// begin
// DSurface.TextOut(fdata, clWhite, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// sx := sx + FrmMain.Canvas.TextWidth(fdata);
// end;
// if cmdstr <> '' then
// begin
// if g_boRequireAddPoints2 then
// begin
// New(pcp);
// pcp.rc := Rect(lx + sx, ly, lx + sx + FrmMain.Canvas.TextWidth(cmdstr), ly + 14);
// pcp.RStr := cmdparam;
// pcp.Index := CmdIndex;
// g_PlayDrinkPoints.Add(pcp);
// end;
// //dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style + [fsUnderline]; // 字体下划线
// if SelectMenuIndex = CmdIndex then
// DSurface.TextOut(cmdstr, clRed, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly))
// else
// begin
// if Str_ToInt(colorg, 0) <> 0 then
// begin
// //dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline]; // 去掉字体下面的下划线
// DSurface.TextOut(cmdstr, color123, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly)) // 显示颜色文字
// end
// else
// DSurface.TextOut(cmdstr, clYellow, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// end;
// sx := sx + FrmMain.Canvas.TextWidth(cmdstr);
// //dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline];
// Inc(CmdIndex);
// end;
// end;
// if data <> '' then
// DSurface.TextOut(data, clWhite, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// end;
// ly := ly + 16;
// end;
// g_boRequireAddPoints2 := False;
// end;
// end;
//
// var
// D: TAsphyreLockableTexture;
// MyIcon: Integer;
// Butt: TDButton;
// rc: TRect;
// IconFlash: Integer; // 定位NPC或玩家头像处喝酒图
begin
  // with DPlayDrink do
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // if g_btDrinkValue[0] <= 92 then
  // begin
  // D := g_WMain2Images.Images[342 + g_btNpcIcon]; // NPC头像
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 16), SurfaceY(Top + 19), D.ClientRect, D, True);
  // end;
  // // ------------------------NPC喝酒动画显示
  // if g_btShowPlayDrinkFlash = 1 then
  // begin
  // if GetTickCount - g_DwShowPlayDrinkFlashTick > 150 then
  // begin
  // g_DwShowPlayDrinkFlashTick := GetTickCount;
  // Inc(g_nShowPlayDrinkFlashImg);
  // if g_btTempDrinkValue[0] > 92 then
  // begin // NPC喝醉了
  // if g_nShowPlayDrinkFlashImg > 14 then
  // begin
  // g_btShowPlayDrinkFlash := 0;
  // g_btDrinkValue[0] := g_btTempDrinkValue[0];
  // end;
  // end
  // else
  // begin
  // if g_nShowPlayDrinkFlashImg > 10 then
  // begin
  // g_btShowPlayDrinkFlash := 0;
  // g_btDrinkValue[0] := g_btTempDrinkValue[0];
  // end;
  // end;
  // end;
  // case g_btNpcIcon of
  // 0:
  // IconFlash := 370;
  // 1:
  // IconFlash := 390;
  // 2:
  // IconFlash := 410;
  // else
  // IconFlash := 370;
  // end;
  // D := g_WMain2Images.Images[IconFlash + g_nShowPlayDrinkFlashImg];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 16), SurfaceY(Top + 19), D.ClientRect, D, True);
  // end;
  // if g_btDrinkValue[0] > 92 then
  // begin // 喝醉了最后的图
  // case g_btNpcIcon of
  // 0:
  // IconFlash := 370;
  // 1:
  // IconFlash := 390;
  // 2:
  // IconFlash := 410;
  // else
  // IconFlash := 370;
  // end;
  // D := g_WMain2Images.Images[IconFlash + g_nShowPlayDrinkFlashImg - 1];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 16), SurfaceY(Top + 19), D.ClientRect, D, True);
  // end;
  // // -----------------
  // if g_btDrinkValue[1] <= 92 then
  // begin
  // if g_MySelf.m_btSex = 0 then
  // MyIcon := 337
  // else
  // MyIcon := 338;
  // if MyIcon > 0 then
  // begin // 玩家头像
  // D := g_WMain2Images.Images[MyIcon];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 16), SurfaceY(Top + 248), D.ClientRect, D, True);
  // end;
  // end;
  // // -------------玩家喝酒动画显示
  // if g_btShowPlayDrinkFlash = 2 then
  // begin
  // if GetTickCount - g_DwShowPlayDrinkFlashTick > 150 then
  // begin
  // g_DwShowPlayDrinkFlashTick := GetTickCount;
  // Inc(g_nShowPlayDrinkFlashImg);
  // if g_btTempDrinkValue[1] > 92 then
  // begin // NPC喝醉了
  // if g_nShowPlayDrinkFlashImg > 14 then
  // begin
  // g_btShowPlayDrinkFlash := 0;
  // g_btDrinkValue[1] := g_btTempDrinkValue[1];
  // end;
  // end
  // else
  // begin
  // if g_nShowPlayDrinkFlashImg > 10 then
  // begin
  // g_btShowPlayDrinkFlash := 0;
  // g_btDrinkValue[1] := g_btTempDrinkValue[1];
  // end;
  // end;
  // end;
  // if g_MySelf.m_btSex = 0 then
  // IconFlash := 430
  // else
  // IconFlash := 450;
  // D := g_WMain2Images.Images[IconFlash + g_nShowPlayDrinkFlashImg];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 16), SurfaceY(Top + 248), D.ClientRect, D, True);
  // end;
  // if g_btDrinkValue[1] > 92 then
  // begin // 喝醉了最后的图
  // if g_MySelf.m_btSex = 0 then
  // IconFlash := 430
  // else
  // IconFlash := 450;
  // D := g_WMain2Images.Images[IconFlash + g_nShowPlayDrinkFlashImg - 1];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 16), SurfaceY(Top + 248), D.ClientRect, D, True);
  // end;
  // // -----------------
  // D := g_WMain2Images.Images[369]; // NPC酒气
  // if D <> nil then
  // begin
  // rc := D.ClientRect;
  // rc.Right := Round((rc.Right - rc.Left) / 100 * g_btDrinkValue[0]);
  // dsurface.Draw(SurfaceX(Left + 111), SurfaceY(Top + 97), rc, D, True);
  // end;
  // D := g_WMain2Images.Images[369]; // 玩家酒气
  // if D <> nil then
  // begin
  // rc := D.ClientRect;
  // rc.Right := Round((rc.Right - rc.Left) / 100 * g_btDrinkValue[1]);
  // dsurface.Draw(SurfaceX(Left + 111), SurfaceY(Top + 326), rc, D, True);
  // end;
  // with dsurface.Canvas do
  // begin
  // Brush.Color := clRed;
  // FillRect(Rect(SurfaceX(Left) + 313, // 左边      填充白色背景
  // SurfaceY(Top) + 97, // 上边
  // SurfaceX(Left) + 315, // 右边
  // SurfaceY(Top) + 106)); // 下边
  // FillRect(Rect(SurfaceX(Left) + 313, // 左边      填充白色背景
  // SurfaceY(Top) + 326, // 上边
  // SurfaceX(Left) + 315, // 右边
  // SurfaceY(Top) + 335)); // 下边
  // Release;
  // end;
  // with dsurface.Canvas do
  // begin
  // {$IF Version = 1}
  // SetBkMode(Handle, TRANSPARENT);
  // Font.Color := clWhite;
  // TextOut(SurfaceX(Left) + 60 - TextWidth(g_sNpcName) div 2, SurfaceY(Top) + 97, g_sNpcName);
  // TextOut(SurfaceX(Left) + 60 - TextWidth(g_MySelf.m_sUserName) div 2, SurfaceY(Top) + 326, g_MySelf.m_sUserName);
  // {$ELSE}
  // clFunc.TextOut(dsurface, SurfaceX(Left) + 60 - FrmMain.Canvas.TextWidth(g_sNpcName) div 2, SurfaceY(Top) + 97, clWhite, g_sNpcName);
  // clFunc.TextOut(dsurface, SurfaceX(Left) + 60 - FrmMain.Canvas.TextWidth(g_MySelf.m_sUserName) div 2, SurfaceY(Top) + 326, clWhite, g_MySelf.m_sUserName);
  // {$IFEND}
  // Release;
  // end;

  // D := g_WMain2Images.Images[348];
  // if D <> nil then
  // begin
  // if g_boStopPlayDrinkGame then
  // dsurface.DrawBlend(SurfaceX(Left) + 395, SurfaceY(Top) + 240, D, 0)
  // else
  // dsurface.Draw(SurfaceX(Left) + 395, SurfaceY(Top) + 240, D.ClientRect, D, True);
  // end;
  // D := g_WMain2Images.Images[350];
  // if D <> nil then
  // begin
  // if g_boStopPlayDrinkGame then
  // dsurface.DrawBlend(SurfaceX(Left) + 351, SurfaceY(Top) + 250, D, 0)
  // else
  // dsurface.Draw(SurfaceX(Left) + 351, SurfaceY(Top) + 250, D.ClientRect, D, True);
  // end;
  // D := g_WMain2Images.Images[352];
  // if D <> nil then
  // begin
  // if g_boStopPlayDrinkGame then
  // DrawBlendEx(dsurface, SurfaceX(Left) + 342, SurfaceY(Top) + 294, D, 0, 0, D.WIDTH, D.Height, 0)
  // else
  // dsurface.Draw(SurfaceX(Left) + 342, SurfaceY(Top) + 294, D.ClientRect, D, True);
  // end;
  // if not g_boStopPlayDrinkGame then
  // begin
  // if g_btPlayDrinkGameNum <= 2 then
  // begin
  // if DPlayDrinkFist.Tag = g_btPlayDrinkGameNum then
  // Butt := DPlayDrinkFist;
  // if DPlayDrinkScissors.Tag = g_btPlayDrinkGameNum then
  // Butt := DPlayDrinkScissors;
  // if DPlayDrinkCloth.Tag = g_btPlayDrinkGameNum then
  // Butt := DPlayDrinkCloth;
  // if Butt.Tag = g_btPlayDrinkGameNum then
  // begin
  // if GetTickCount - g_dwPlayDrinkSelImgTick > 100 then
  // begin
  // g_dwPlayDrinkSelImgTick := GetTickCount;
  // Inc(g_nPlayDrinkSelImg);
  // if g_nPlayDrinkSelImg > 1 then
  // g_nPlayDrinkSelImg := 0;
  // end;
  // with Butt do
  // begin
  // D := g_WMain2Images.Images[361 + g_nPlayDrinkSelImg];
  // if D <> nil then
  // DSurface.DrawBlend(SurfaceX(Left), SurfaceY(Top), D, 1);
  // end;
  // end;
  // end;
  // end;
  // if not g_boPlayDrink then
  // begin
  // PlayDrinkTextOut1(dsurface); // 画脚本内容
  // PlayDrinkTextOut2(dsurface); // 画脚本内容
  // end;
  //
  // if g_boPlayDrink then
  // begin
  // D := g_WMain2Images.Images[339];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  //
  // DPlayGameNum();
  // DPlayDrinkNpcNum.Left := 0 + g_nImgLeft;
  // D := g_WMain2Images.Images[345];
  // if D <> nil then
  // DPlayDrinkPlayNum.Left := DPlayDrink.WIDTH - D.WIDTH - g_nImgLeft;
  //
  // end;
  // end;
end;

procedure TFrmDlg.ChallengeClick(Sender: TObject; X, Y: Integer);
begin

end;

// 酒馆NPC自动选酒中。。
procedure TFrmDlg.NpcAutoSelDrinkRuning(dsurface: TAsphyreCanvas);
begin
  if g_boNpcAutoSelDrink then
  begin // NPC自动选酒中
    if GetTickCount - g_DwShowNpcSelDrinkTick > 150 then
    begin
      g_DwShowNpcSelDrinkTick := GetTickCount;
      Inc(g_nNpcSelDrinkPosition); // 下一个位置
      if g_nNpcSelDrinkPosition > 5 then
      begin
        g_nNpcSelDrinkPosition := 0;
        Inc(g_btNpcAutoSelDrinkCircleNum); // 转动圈数
      end;

      if g_btNpcAutoSelDrinkCircleNum = 2 then
      begin
        if g_nNpcSelDrinkPosition = 0 then
          if DDrink1.Tag = g_btNpcDrinkTarget then
          begin
            DDrink1.visible := False;
            g_boNpcAutoSelDrink := False;
            FrmMain.SendDrinkUpdateValue(g_nCurMerchant, 0, 0);
          end;
        if g_nNpcSelDrinkPosition = 1 then
          if DDrink2.Tag = g_btNpcDrinkTarget then
          begin
            DDrink2.visible := False;
            g_boNpcAutoSelDrink := False;
            FrmMain.SendDrinkUpdateValue(g_nCurMerchant, 0, 0);
          end;
        if g_nNpcSelDrinkPosition = 2 then
          if DDrink4.Tag = g_btNpcDrinkTarget then
          begin
            DDrink4.visible := False;
            g_boNpcAutoSelDrink := False;
            FrmMain.SendDrinkUpdateValue(g_nCurMerchant, 0, 0);
          end;
        if g_nNpcSelDrinkPosition = 3 then
          if DDrink6.Tag = g_btNpcDrinkTarget then
          begin
            DDrink6.visible := False;
            g_boNpcAutoSelDrink := False;
            FrmMain.SendDrinkUpdateValue(g_nCurMerchant, 0, 0);
          end;
        if g_nNpcSelDrinkPosition = 4 then
          if DDrink5.Tag = g_btNpcDrinkTarget then
          begin
            DDrink5.visible := False;
            g_boNpcAutoSelDrink := False;
            FrmMain.SendDrinkUpdateValue(g_nCurMerchant, 0, 0);
          end;
        if g_nNpcSelDrinkPosition = 5 then
          if DDrink3.Tag = g_btNpcDrinkTarget then
          begin
            DDrink3.visible := False;
            g_boNpcAutoSelDrink := False;
            FrmMain.SendDrinkUpdateValue(g_nCurMerchant, 0, 0);
          end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DDrink1DirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  // NpcAutoSelDrinkRuning(dsurface);
  // with TDButton(Sender) do
  // begin
  // if g_boPermitSelDrink then
  // begin // 酒不让透明，允许玩家选酒
  // if TDButton(Sender).ShowHint then
  // begin // 鼠标移动到了这瓶酒  高亮
  // D := g_WMain2Images.Images[329];
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end
  // else
  // begin // 普通显示
  // D := g_WMain2Images.Images[363];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // if g_boNpcAutoSelDrink then
  // begin // NPC自动选
  // if TDButton(Sender).Tag = g_nNpcSelDrinkPosition then
  // begin
  // D := g_WMain2Images.Images[329];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin // 玩家选酒
  // if TDButton(Sender).Tag = g_btPlaySelDrink then
  // begin
  // D := g_WMain2Images.Images[329];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // end;
  // end
  // else
  // begin
  // D := g_WMain2Images.Images[363];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
end;

procedure TFrmDlg.DPlayFistClick(Sender: TObject; X, Y: Integer);
begin
  FrmMain.SendPlayDrinkGame(g_nCurMerchant, g_btPlayDrinkGameNum); // 发送猜拳码数
  g_boPermitSelDrink := True;
  DPlayFist.visible := False;
end;

procedure TFrmDlg.DPlayDrinkCloseDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  // with Sender as TDButton do
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // if not TDButton(Sender).Downed then
  // begin
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // if g_boPlayDrink then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0)
  // else
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end
  // else
  // begin
  // D := Propertites.Images.Images[Propertites.ImageIndex + 1];
  // if D <> nil then
  // if g_boPlayDrink then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0)
  // else
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // end;
  // end;
end;

procedure TFrmDlg.ShowPlayDrink(Who1: Integer; msgstr: string);
var
  I: Integer;
begin
  if Who1 = 1 then // 上面的人
    g_sPlayDrinkStr1 := msgstr
  else if Who1 = 2 then
    g_sPlayDrinkStr2 := msgstr; // 下面的人
  if g_PlayDrinkPoints.Count > 0 then // 20080629
    for I := 0 to g_PlayDrinkPoints.Count - 1 do
      Dispose(pTClickPoint(g_PlayDrinkPoints[I]));
  g_PlayDrinkPoints.Clear;
  if Who1 = 1 then
    g_boRequireAddPoints1 := True;
  if Who1 = 2 then
    g_boRequireAddPoints2 := True;
end;

procedure TFrmDlg.DPlayDrinkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I, L, T: Integer;
  P: pTClickPoint;
begin
  SelectMenuIndex := -1;
  L := DPlayDrink.Left;
  T := DPlayDrink.Top;
  with DPlayDrink do
    if g_PlayDrinkPoints.Count > 0 then // 20080629
      for I := 0 to g_PlayDrinkPoints.Count - 1 do
      begin
        P := pTClickPoint(g_PlayDrinkPoints[I]);
        if (X >= SurfaceX(L + P.rc.Left)) and (X <= SurfaceX(L + P.rc.Right))
          and (Y >= SurfaceY(T + P.rc.Top)) and
          (Y <= SurfaceY(T + P.rc.Bottom)) then
        begin
          SelectMenuIndex := P.Index;
          Break;
        end;
      end;
end;

procedure TFrmDlg.DPlayDrinkMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelectMenuIndex := -1;
end;

procedure TFrmDlg.DPlayDrinkClick(Sender: TObject; X, Y: Integer);
var
  I, L, T: Integer;
  P: pTClickPoint;
begin
  L := DPlayDrink.Left;
  T := DPlayDrink.Top;
  with DPlayDrink do
    if g_PlayDrinkPoints.Count > 0 then // 20080629
      for I := 0 to g_PlayDrinkPoints.Count - 1 do
      begin
        P := pTClickPoint(g_PlayDrinkPoints[I]);
        if (X >= SurfaceX(L + P.rc.Left)) and (X <= SurfaceX(L + P.rc.Right))
          and (Y >= SurfaceY(T + P.rc.Top)) and
          (Y <= SurfaceY(T + P.rc.Bottom)) then
        begin
          FrmMain.SendPlayDrinkDlgSelect(g_nCurMerchant, P.RStr);
          Break;
        end;
      end;
end;

procedure TFrmDlg.DWPleaseDrinkDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
// procedure PlayDrinkTextOut1(dsurface: TAsphyreCanvas);
// var
// str, data, fdata, cmdstr, cmdparam: string;
// lx, ly, sx: Integer;
// // DrawCenter: Boolean;
// pcp: pTClickPoint;
// colorg: string; // 得到NPC颜色码
// color123: TColor; // npc字颜色
// CmdIndex: Integer;
// begin
// with DWPleaseDrink do
// begin
// {$IF Version = 1}
// SetBkMode(dsurface.Canvas.Handle, TRANSPARENT); // 设置透明
// {$IFEND}
// lx := 115;
// ly := 55;
// CmdIndex := 0;
// str := g_sPlayDrinkStr1;
// // DrawCenter := FALSE;
// while True do
// begin
// if str = '' then
// break;
// str := GetValidStr3(str, data, ['\']);
// if data <> '' then
// begin
// sx := 0;
// fdata := '';
// while (pos('<', data) > 0) and (pos('>', data) > 0) and (data <> '') do
// begin
// if data[1] <> '<' then
// begin
// data := '<' + GetValidStr3(data, fdata, ['<']);
// end;
// data := ArrestStringEx(data, '<', '>', cmdstr); // 得到"<"和">" 号之间的字   赋予给 cmdstr
// if cmdstr <> '' then
// begin
// if Uppercase(cmdstr) = 'C' then
// begin
// // drawcenter := TRUE;
// continue;
// end;
// if Uppercase(cmdstr) = '/C' then
// begin
// // drawcenter := FALSE;
// continue;
// end;
// cmdparam := GetValidStr3(cmdstr, cmdstr, ['/']); // cmdparam : 命令参数
// colorg := GetValidStr3(cmdparam, colorg, ['=']); // 从NPC脚本中得到字颜色编码
// color123 := GetRGB(Str_ToInt(colorg, 0)); // str转换byte
// end
// else
// begin
// DPlayDrink.visible := False;
// end;
//
// if fdata <> '' then
// begin
// DSurface.TextOut(fdata, clWhite, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// sx := sx + FrmMain.Canvas.TextWidth(fdata);
// end;
// if cmdstr <> '' then
// begin
// if g_boRequireAddPoints1 then
// begin
// New(pcp);
// pcp.rc := Rect(lx + sx, ly, lx + sx + FrmMain.Canvas.TextWidth(cmdstr), ly + 14);
// pcp.RStr := cmdparam;
// pcp.Index := CmdIndex;
// g_PlayDrinkPoints.Add(pcp);
// end;
// dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style + [fsUnderline]; // 字体下划线
// if SelectMenuIndex = CmdIndex then
// DSurface.TextOut(cmdstr, clRed, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly))
// else
// begin
// if Str_ToInt(colorg, 0) <> 0 then
// begin
// dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline]; // 去掉字体下面的下划线
// DSurface.TextOut(cmdstr, color123, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly)) // 显示颜色文字
// end
// else
// DSurface.TextOut(cmdstr, clYellow, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// end;
// sx := sx + FrmMain.Canvas.TextWidth(cmdstr);
// dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline];
// Inc(CmdIndex);
// end;
// end;
// if data <> '' then
// DSurface.TextOut(data, clWhite, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// end;
// ly := ly + 16;
// end;
// dsurface.Canvas.Release;
// g_boRequireAddPoints1 := False;
// end;
// end;
// procedure PlayDrinkTextOut2(dsurface: TAsphyreCanvas);
// var
// str, data, fdata, cmdstr, cmdparam: string;
// lx, ly, sx: Integer;
// // DrawCenter: Boolean;
// pcp: pTClickPoint;
// colorg: string; // 得到NPC颜色码
// color123: TColor; // npc字颜色
// CmdIndex: Integer;
// begin
// with DWPleaseDrink do
// begin
// lx := 30;
// ly := 263;
// str := g_sPlayDrinkStr2;
// // DrawCenter := FALSE;
// while True do
// begin
// if str = '' then
// break;
// str := GetValidStr3(str, data, ['\']);
// if data <> '' then
// begin
// sx := 0;
// fdata := '';
// while (pos('<', data) > 0) and (pos('>', data) > 0) and (data <> '') do
// begin
// if data[1] <> '<' then
// begin
// data := '<' + GetValidStr3(data, fdata, ['<']);
// end;
// data := ArrestStringEx(data, '<', '>', cmdstr); // 得到"<"和">" 号之间的字   赋予给 cmdstr
// if cmdstr <> '' then
// begin
// if Uppercase(cmdstr) = 'C' then
// begin
// // drawcenter := TRUE;
// continue;
// end;
// if Uppercase(cmdstr) = '/C' then
// begin
// // drawcenter := FALSE;
// continue;
// end;
// cmdparam := GetValidStr3(cmdstr, cmdstr, ['/']); // cmdparam : 命令参数
// colorg := GetValidStr3(cmdparam, colorg, ['=']); // 从NPC脚本中得到字颜色编码
// color123 := GetRGB(Str_ToInt(colorg, 0)); // str转换byte
// end
// else
// begin
// DPlayDrink.visible := False;
// end;
//
// if fdata <> '' then
// begin
// DSurface.TextOut(fdata, clWhite, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// sx := sx + FrmMain.Canvas.TextWidth(fdata);
// end;
// if cmdstr <> '' then
// begin
// if g_boRequireAddPoints2 then
// begin
// New(pcp);
// pcp.rc := Rect(lx + sx, ly, lx + sx + FrmMain.Canvas.TextWidth(cmdstr), ly + 14);
// pcp.RStr := cmdparam;
// pcp.Index := CmdIndex;
// g_PlayDrinkPoints.Add(pcp);
// end;
// dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style + [fsUnderline]; // 字体下划线
// if SelectMenuIndex = CmdIndex then
// DSurface.TextOut(cmdstr, clRed, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly))
// else
// begin
// if Str_ToInt(colorg, 0) <> 0 then
// begin
// dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline]; // 去掉字体下面的下划线
// DSurface.TextOut(cmdstr, color123, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly)) // 显示颜色文字
// end
// else
// DSurface.TextOut(cmdstr, clYellow, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// end;
// sx := sx + FrmMain.Canvas.TextWidth(cmdstr);
// dsurface.Canvas.Font.Style := dsurface.Canvas.Font.Style - [fsUnderline];
// Inc(CmdIndex);
// end;
// end;
// if data <> '' then
// DSurface.TextOut(data, clWhite, clBlack, SurfaceX(Left + lx + sx), SurfaceY(Top + ly));
// end;
// ly := ly + 16;
// end;
// dsurface.Canvas.Release;
// g_boRequireAddPoints2 := False;
// end;
// end;
//
// var
// D: TAsphyreLockableTexture;
// IconFlash: Integer;
begin
  // with DWPleaseDrink do
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  //
  // D := g_WMain2Images.Images[342 + g_btNpcIcon]; // NPC头像
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 16), SurfaceY(Top + 19), D.ClientRect, D, True);
  //
  // // ------------------------NPC喝酒动画显示
  // if g_btShowPlayDrinkFlash = 1 then
  // begin
  // if GetTickCount - g_DwShowPlayDrinkFlashTick > 150 then
  // begin
  // g_DwShowPlayDrinkFlashTick := GetTickCount;
  // Inc(g_nShowPlayDrinkFlashImg);
  // if g_nShowPlayDrinkFlashImg > 10 then
  // begin
  // g_btShowPlayDrinkFlash := 0;
  // g_btDrinkValue[0] := g_btTempDrinkValue[0];
  // end;
  // end;
  // case g_btNpcIcon of
  // 0:
  // IconFlash := 370;
  // 1:
  // IconFlash := 390;
  // 2:
  // IconFlash := 410;
  // else
  // IconFlash := 370;
  // end;
  // D := g_WMain2Images.Images[IconFlash + g_nShowPlayDrinkFlashImg];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 16), SurfaceY(Top + 19), D.ClientRect, D, True);
  // end;
  //
  // with dsurface.Canvas do
  // begin
  // {$IF Version = 1}
  // SetBkMode(Handle, TRANSPARENT);
  // Font.Color := clWhite;
  // TextOut(SurfaceX(Left) + 60 - TextWidth(g_sNpcName) div 2, SurfaceY(Top) + 97, g_sNpcName);
  // {$ELSE}
  // clFunc.TextOut(dsurface, SurfaceX(Left) + 60 - FrmMain.Canvas.TextWidth(g_sNpcName) div 2, SurfaceY(Top) + 97, clWhite, g_sNpcName);
  // {$IFEND}
  // Release;
  // end;
  //
  // PlayDrinkTextOut1(dsurface);
  // PlayDrinkTextOut2(dsurface);
  //
  // D := g_WMain2Images.Images[364];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 96), SurfaceY(Top + 186), D.ClientRect, D, True);
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 290), SurfaceY(Top + 196), D.ClientRect, D, True);
  //
  // end;
end;

procedure TFrmDlg.DPDrink1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  // if Sender = DPDrink1 then
  // begin
  // D := g_WMain2Images.Images[365];
  // if D <> nil then
  // begin
  // if DPDrink1.ShowHint then
  // DrawBlendEx(dsurface, DPDrink1.SurfaceX(DPDrink1.Left), DPDrink1.SurfaceY(DPDrink1.Top), D, 0, 0, D.WIDTH, D.Height, 0)
  // else
  // dsurface.Draw(DPDrink1.SurfaceX(DPDrink1.Left + (DPDrink1.WIDTH - D.WIDTH) div 2), DPDrink1.SurfaceY(DPDrink1.Top + (DPDrink1.Height - D.Height) div 2),
  // D.ClientRect, D, True);
  // end;
  // if g_PDrinkItem[0].Name <> '' then
  // begin
  // D := g_WMain2Images.Images[363];
  // if D <> nil then
  // begin
  // if DPDrink1.ShowHint then
  // DrawBlendEx(dsurface, DPDrink1.SurfaceX(DPDrink1.Left), DPDrink1.SurfaceY(DPDrink1.Top), D, 0, 0, D.WIDTH, D.Height, 0)
  // else
  // dsurface.Draw(DPDrink2.SurfaceX(DPDrink1.Left + (DPDrink1.WIDTH - D.WIDTH) div 2),
  // DPDrink2.SurfaceY(DPDrink1.Top + (DPDrink1.Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end;
  // end;
  //
  // if Sender = DPDrink2 then
  // begin
  // D := g_WMain2Images.Images[365];
  // if D <> nil then
  // begin
  // if DPDrink2.ShowHint then
  // DrawBlendEx(dsurface, DPDrink2.SurfaceX(DPDrink2.Left), DPDrink2.SurfaceY(DPDrink2.Top), D, 0, 0, D.WIDTH, D.Height, 0)
  // else
  // dsurface.Draw(DPDrink2.SurfaceX(DPDrink2.Left + (DPDrink2.WIDTH - D.WIDTH) div 2), DPDrink2.SurfaceY(DPDrink2.Top + (DPDrink2.Height - D.Height) div 2),
  // D.ClientRect, D, True);
  // end;
  // if g_PDrinkItem[1].Name <> '' then
  // begin
  // D := g_WMain2Images.Images[363];
  // if D <> nil then
  // begin
  // if DPDrink2.ShowHint then
  // DrawBlendEx(dsurface, DPDrink2.SurfaceX(DPDrink2.Left), DPDrink2.SurfaceY(DPDrink2.Top), D, 0, 0, D.WIDTH, D.Height, 0)
  // else
  // dsurface.Draw(DPDrink2.SurfaceX(DPDrink2.Left + (DPDrink2.WIDTH - D.WIDTH) div 2),
  // DPDrink2.SurfaceY(DPDrink2.Top + (DPDrink2.Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end;
  // end;
end;

procedure TFrmDlg.DPlayDrinkCloseClick(Sender: TObject; X, Y: Integer);
begin
  DPlayDrink.visible := False;
end;

procedure TFrmDlg.DPlayDrinkFistClick(Sender: TObject; X, Y: Integer);
begin
  if g_boPlayDrink then
    Exit;
  if g_boNpcAutoSelDrink then
    Exit;
  if g_btWhoWin = 0 then
    if not g_boHumWinDrink then
      Exit; // 20080614 玩家赢，是否喝了酒
  g_btPlayDrinkGameNum := TDButton(Sender).Tag;
  DPlayFist.visible := True;
end;

procedure TFrmDlg.DPlayDrinkNpcNumDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with DPlayDrinkNpcNum do
  begin
    D := g_WMain2Images.Images[366 + g_btNpcNum];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  end;
end;

procedure TFrmDlg.DPlayDrinkPlayNumDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with DPlayDrinkPlayNum do
  begin
    D := g_WMain2Images.Images[345 + g_btPlayNum];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  end;
end;

procedure TFrmDlg.DPlayDrinkWhoWinDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with DPlayDrinkWhoWin do
  begin
    D := g_WMain2Images.Images[334 + g_btWhoWin];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  end;
end;

// 是否显示斗酒一些图
procedure TFrmDlg.ShowPlayDrinkImg(Show: Boolean);
begin
  DPlayDrinkWhoWin.visible := Show;
  DPlayDrinkNpcNum.visible := Show;
  DPlayDrinkPlayNum.visible := Show;
end;

procedure TFrmDlg.ShowProgress(const AMessage: String; Max: Integer);
begin
  FPrgMax := Max;
  FPrgMessage := AMessage;
  FPrgTick := GetTickCount;
  DWProgress.visible := True;
end;

procedure TFrmDlg.DPlayDrinkFistDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  // 这个过程不能删除  让斗酒的按钮为空显示
end;

procedure TFrmDlg.DDrink1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if g_boPlayDrink then
    Exit;
  if g_boNpcAutoSelDrink then
    Exit;
  TDButton(Sender).ShowHint := True;
end;

procedure TFrmDlg.DPlayDrinkMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DDrink1.ShowHint := False;
  DDrink2.ShowHint := False;
  DDrink3.ShowHint := False;
  DDrink4.ShowHint := False;
  DDrink5.ShowHint := False;
  DDrink6.ShowHint := False;
end;

procedure TFrmDlg.DDrink1Click(Sender: TObject; X, Y: Integer);
begin
  if g_boPlayDrink then
    Exit;
  if g_boNpcAutoSelDrink then
    Exit;
  if not g_boPermitSelDrink then
    Exit;
  g_btPlaySelDrink := TDButton(Sender).Tag; // 玩家选的酒
  FrmMain.ClientGetPlayDrinkSay(g_nCurMerchant, 2,
    '这坛酒给谁喝好呢？  <对方/@@@对方> <自己/@@@自己>');
end;

procedure TFrmDlg.DPDrink1Click(Sender: TObject; X, Y: Integer);
var
  temp: TClientItem;
  Butt: TDButton;
begin
  Butt := TDButton(Sender);
  if not g_boItemMoving then
  begin
    if g_PDrinkItem[Butt.Tag].Name <> '' then
    begin
      g_SoundManager.ItemClickSound(g_PDrinkItem[Butt.Tag].S);
      if g_MovingItem.Item.Name <> '' then
        Exit;
      g_boItemMoving := True;
      g_MovingItem.FromIndex := Butt.Tag;
      g_MovingItem.Source := msDrinkItem;
      g_MovingItem.Item := g_PDrinkItem[Butt.Tag];
      g_PDrinkItem[Butt.Tag].Name := '';
    end;
  end
  else
  begin
    if g_MovingItem.Source in [msBag, msDrinkItem] then
    begin
      if (g_MovingItem.Item.S.StdMode = 60) and
        (g_MovingItem.Item.S.Shape = 0) then
      begin // 是烧酒
        g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
        if g_PDrinkItem[Butt.Tag].Name <> '' then
        begin // 磊府俊 乐栏搁
          temp := g_PDrinkItem[Butt.Tag];
          g_PDrinkItem[Butt.Tag] := g_MovingItem.Item;
          g_MovingItem.FromIndex := Butt.Tag;
          g_MovingItem.Source := msDrinkItem;
          g_MovingItem.Item := temp
        end
        else
        begin
          g_PDrinkItem[Butt.Tag] := g_MovingItem.Item;
          g_MovingItem.Item.Name := '';
          g_boItemMoving := False;
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DPDrink1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  TDButton(Sender).ShowHint := True;
end;

procedure TFrmDlg.DPEditPopupMenuVisibleChange(Sender: TObject);
var
  Memo : TDEditMemo;
begin
  if Visible = true then
  begin
    if Sender is TDEditMemo then
    begin
      Memo := TDEditMemo(Sender);
      if Memo.IsSelText then
      begin

      end;
    end;
  end;
end;

procedure TFrmDlg.DWPleaseDrinkMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DPDrink1.ShowHint := False;
  DPDrink2.ShowHint := False;
end;

procedure TFrmDlg.DPleaseDrinkExitClick(Sender: TObject; X, Y: Integer);
begin
  DWPleaseDrink.visible := False;
  if g_PDrinkItem[0].Name <> '' then
  begin
    AddItemBag(g_PDrinkItem[0]);
    g_PDrinkItem[0].Name := '';
  end;
  if g_PDrinkItem[1].Name <> '' then
  begin
    AddItemBag(g_PDrinkItem[1]);
    g_PDrinkItem[1].Name := '';
  end;
end;

procedure TFrmDlg.DPleaseDrinkDrinkClick(Sender: TObject; X, Y: Integer);
begin
  if g_PDrinkItem[0].Name = '' then
  begin
    FrmMain.ClientGetPlayDrinkSay(g_nCurMerchant, 1, '年轻人，你不是请我喝酒吗？我的酒呢？');
    Exit;
  end;
  if g_PDrinkItem[1].Name = '' then
  begin
    FrmMain.ClientGetPlayDrinkSay(g_nCurMerchant, 1, '年轻人，你请我喝酒，怎么自己不喝呢？');
    Exit;
  end;
  FrmMain.SendDrinkDrinkOK();
end;

procedure TFrmDlg.DWPleaseDrinkClick(Sender: TObject; X, Y: Integer);
var
  I, L, T: Integer;
  P: pTClickPoint;
begin
  L := DWPleaseDrink.Left;
  T := DWPleaseDrink.Top;
  with DWPleaseDrink do
    if g_PlayDrinkPoints.Count > 0 then // 20080629
      for I := 0 to g_PlayDrinkPoints.Count - 1 do
      begin
        P := pTClickPoint(g_PlayDrinkPoints[I]);
        if (X >= SurfaceX(L + P.rc.Left)) and (X <= SurfaceX(L + P.rc.Right))
          and (Y >= SurfaceY(T + P.rc.Top)) and
          (Y <= SurfaceY(T + P.rc.Bottom)) then
        begin
          FrmMain.SendPlayDrinkDlgSelect(g_nCurMerchant, P.RStr);
          Break;
        end;
      end;
end;

procedure TFrmDlg.DWPleaseDrinkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I, L, T: Integer;
  P: pTClickPoint;
begin
  SelectMenuIndex := -1;
  L := DWPleaseDrink.Left;
  T := DWPleaseDrink.Top;
  with DWPleaseDrink do
    if g_PlayDrinkPoints.Count > 0 then // 20080629
      for I := 0 to g_PlayDrinkPoints.Count - 1 do
      begin
        P := pTClickPoint(g_PlayDrinkPoints[I]);
        if (X >= SurfaceX(L + P.rc.Left)) and (X <= SurfaceX(L + P.rc.Right))
          and (Y >= SurfaceY(T + P.rc.Top)) and
          (Y <= SurfaceY(T + P.rc.Bottom)) then
        begin
          SelectMenuIndex := P.Index;
          Break;
        end;
      end;
end;

procedure TFrmDlg.DWPleaseDrinkMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SelectMenuIndex := -1;
end;

procedure TFrmDlg.DWProgressDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  r: TRect;
  P: Integer;
  AText: TAsphyreLockableTexture;
begin
  P := Round((GetTickCount - FPrgTick) * (150 / FPrgMax / 1000));
  with DWProgress do
  begin
    if Propertites.Images <> nil then
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;

    D := g_77Images.Images[325];
    if D <> nil then
    begin
      r := D.ClientRect;
      r.Right := r.Left + P;
      dsurface.Draw(SurfaceX(Left + 18), SurfaceY(Top + 36), r, D);
      AText := FontManager.Default.TextOut(FPrgMessage);
      if AText <> nil then
        dsurface.DrawBoldText(SurfaceX(Left) + (WIDTH - AText.WIDTH) div 2,
          SurfaceY(Top + 10) + AText.Height div 2, AText, clWhite,
          FontBorderColor);
    end;
    if P > 150 then
      CloseProgress;
  end;
end;

procedure TFrmDlg.DFriendDlgFrdMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DFriendDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DFriendDlgFrdClick(Sender: TObject; X, Y: Integer);
begin
  DHeiMingDan.Top := 338;
  DPrevFriendDlg.Top := 90;
  DNextFriendDlg.Top := 132;
  DFriendList.Top := 90;
  DAddFriend.Top := 320;
  DAddFriend.Hint := '点击添加好友';
  g_btFriendTypePage := TDButton(Sender).Tag;
  if g_btFriendTypePage in [1, 3] then
  begin
    DFriendList.visible := True;
    DAddFriend.visible := True;
    DPrevFriendDlg.visible := True;
    DNextFriendDlg.visible := True;
    g_btFriendPage := 0;
  end;
end;

procedure TFrmDlg.DFriendDlgDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with DFriendDlg do
  begin
    if Propertites.Images <> nil then
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;

    if g_btFriendTypePage = 2 then
    begin
      D := g_WMain3Images.Images[478];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left) + 9, SurfaceY(Top) + 38,
          D.ClientRect, D, True);
    end;
  end;
end;

procedure TFrmDlg.DFriendListDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  msgtop, msgline, I, m: Integer;
  AText: TAsphyreLockableTexture;
begin
  with DFriendList do
  begin
    case g_btFriendTypePage of
      1:
        begin
          msgtop := g_btFriendPage * 14;
          msgline := _MIN(g_btFriendPage * 14 + 14, g_Friends.Count);
          for I := msgtop to msgline - 1 do
          begin
            m := I - msgtop;
            if I = g_btFriendIndex then
            begin
              dsurface.FillRect(Rect(SurfaceX(Left), SurfaceY(Top) + m * 17 - 2,
                SurfaceX(Left) + WIDTH + 8, SurfaceY(Top) + m * 17 + 17),
                cColor4(cColor1(clBlack)));
              AText := FontManager.
                Default.TextOut(pTFriendRecord(g_Friends[I]).Name);
              if AText <> nil then
                dsurface.DrawBoldText(SurfaceX(Left) + 8,
                  SurfaceY(Top) + m * 17, AText, clRed, FontBorderColor);
              if pTFriendRecord(g_Friends[I]).OnLine then
              begin
                AText := FontManager.Default.TextOut('[在线]');
                if AText <> nil then
                  dsurface.DrawBoldText(SurfaceX(Left) + 130,
                    SurfaceY(Top) + m * 17, AText, clRed, FontBorderColor);
              end;
            end
            else
            begin
              AText := FontManager.
                Default.TextOut(pTFriendRecord(g_Friends[I]).Name);
              if AText <> nil then
                dsurface.DrawBoldText(SurfaceX(Left) + 8,
                  SurfaceY(Top) + m * 17, AText, clWhite, FontBorderColor);
              if pTFriendRecord(g_Friends[I]).OnLine then
              begin
                AText := FontManager.Default.TextOut('[在线]');
                if AText <> nil then
                  dsurface.DrawBoldText(SurfaceX(Left) + 130,
                    SurfaceY(Top) + m * 17, AText, clWhite, FontBorderColor);
              end;
            end;
          end;
        end;
      3:
        begin
          msgtop := g_btFriendPage * 14;
          msgline := _MIN(g_btFriendPage * 14 + 14, g_Enemies.Count);
          for I := msgtop to msgline - 1 do
          begin
            m := I - msgtop;
            if I = g_btFriendIndex then
            begin
              // dsurface.FillRectAlpha(Rect(SurfaceX(Left), SurfaceY(Top) + m * 17 - 2, SurfaceX(Left) + WIDTH + 8, SurfaceY(Top) + m * 17 + 17), clBlack, 175);
              AText := FontManager.
                Default.TextOut(pTFriendRecord(g_Enemies[I]).Name);
              if AText <> nil then
                dsurface.DrawBoldText(SurfaceX(Left) + 8,
                  SurfaceY(Top) + m * 17, AText, clRed, FontBorderColor);
              if pTFriendRecord(g_Enemies[I]).OnLine then
              begin
                AText := FontManager.Default.TextOut('[在线]');
                if AText <> nil then
                  dsurface.DrawBoldText(SurfaceX(Left) + 130,
                    SurfaceY(Top) + m * 17, AText, clRed, FontBorderColor);
              end;
            end
            else
            begin
              AText := FontManager.
                Default.TextOut(pTFriendRecord(g_Enemies[I]).Name);
              if AText <> nil then
                dsurface.DrawBoldText(SurfaceX(Left) + 8,
                  SurfaceY(Top) + m * 17, AText, clWhite, FontBorderColor);
              if pTFriendRecord(g_Enemies[I]).OnLine then
              begin
                AText := FontManager.Default.TextOut('[在线]');
                if AText <> nil then
                  dsurface.DrawBoldText(SurfaceX(Left) + 130,
                    SurfaceY(Top) + m * 17, AText, clRed, FontBorderColor);
              end;
            end;
          end;
        end;
    end;
  end;
end;

procedure TFrmDlg.DFriendListClick(Sender: TObject; X, Y: Integer);
begin
  if DXPopupMenu.PopVisible then
    DXPopupMenu.HidePopup
  else
  begin
    if g_btFriendIndex = -1 then
      Exit;

    g_SoundManager.DXPlaySound(s_glass_button_click);
    with DFriendList do
    begin
      DXPopupMenu.BeginUpdate;
      DXPopupMenu.Clear;
      DXPopupMenu.AddMenuItem(0, '查看装备');
      DXPopupMenu.AddMenuItem(1, '私聊');
      DXPopupMenu.AddMenuItem(2, '移除');
      DXPopupMenu.EndUpdate;
      DXPopupMenu.Popup(DFriendList, 0,
        (g_btFriendIndex - g_btFriendPage * 14 + 1) * 17, 90,
        procedure(ATag: Integer; const ACaption: String)
      begin case g_btFriendTypePage of 1: begin if (g_btFriendIndex <=
        g_Friends.Count - 1) and (pTFriendRecord(g_Friends[g_btFriendIndex])
        .Name <> '') then begin case ATag of 0
        : FrmMain.SendClientMessage(CM_EXECMENUITEM, 0, 0, 0, 1,
        EDcode.Encodestring(pTFriendRecord(g_Friends[g_btFriendIndex]).Name));
        1: begin PlayScene.SetChatText('/' + pTFriendRecord(g_Friends
        [g_btFriendIndex]).Name + ' '); SetDFocus(DEChat);
        DEChat.SelStart := Length(DEChat.Text); end;
        2: begin if mrOK = DMessageDlg('你确认删除 [ ' +
        pTFriendRecord(g_Friends[g_btFriendIndex]).Name + ' ] 吗？',
        [mbOK, mbCancel]) then FrmMain.RemoveFriend
        (pTFriendRecord(g_Friends[g_btFriendIndex]).Name); end; end; end; end;
        3: begin if (g_btFriendIndex <= g_Enemies.Count - 1) and
        (pTFriendRecord(g_Enemies[g_btFriendIndex]).Name <> '')
      then begin case ATag of 0: FrmMain.SendClientMessage(CM_EXECMENUITEM, 0,
        0, 0, 1, EDcode.Encodestring(pTFriendRecord(g_Enemies[g_btFriendIndex])
        .Name)); 1: begin PlayScene.SetChatText('/' +
        pTFriendRecord(g_Enemies[g_btFriendIndex]).Name + ' ');
        SetDFocus(DEChat); DEChat.SelStart := Length(DEChat.Text);
        DEChat.SelLength := 0; end;
        2: begin if mrOK = DMessageDlg('你确认删除 [ ' +
        pTFriendRecord(g_Enemies[g_btFriendIndex]).Name + ' ] 吗？',
        [mbOK, mbCancel]) then FrmMain.RemoveEnemiy
        (pTFriendRecord(g_Enemies[g_btFriendIndex]).Name); end; end; end; end;
      end; end);
    end;
  end;
end;

procedure TFrmDlg.DFriendListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  lx, ly, Idx, msgtop: Integer;
begin
  g_btFriendMoveX := X;
  g_btFriendMoveY := Y;
  lx := X - DFriendList.Left;
  ly := Y - DFriendList.Top;
  g_btFriendIndex := -1;
  case g_btFriendTypePage of
    1:
      begin
        if (lx >= 0) and (lx <= DFriendList.WIDTH) and (ly >= 0) and
          (ly <= 330) then
        begin
          Idx := ly div 17;
          if Idx < g_Friends.Count then
          begin
            msgtop := g_btFriendPage * 14;
            g_btFriendIndex := Idx + msgtop;
          end;
        end;
      end;
    3:
      begin
        if (lx >= 0) and (lx <= DFriendList.WIDTH) and (ly >= 0) and
          (ly <= 330) then
        begin
          Idx := ly div 17;
          if Idx < g_Enemies.Count then
          begin
            msgtop := g_btFriendPage * 14;
            g_btFriendIndex := Idx + msgtop;
          end;
        end;
      end;
  end;
end;

procedure TFrmDlg.DPrevFriendDlgClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DPrevFriendDlg then
  begin
    if g_btFriendPage > 0 then
      Dec(g_btFriendPage);
  end
  else
  begin
    if g_btFriendTypePage = 1 then
    begin
      if g_btFriendPage < (g_Friends.Count + 9) div 10 - 1 then
        Inc(g_btFriendPage);
    end;
    if g_btFriendTypePage = 3 then
    begin
      if g_btFriendPage < (g_Enemies.Count + 9) div 10 - 1 then
        Inc(g_btFriendPage);
    end;
  end;
end;

procedure TFrmDlg.DrawMessageBackGround(Sender: TObject);
begin
end;


procedure TFrmDlg.DoMessageGetItemImages(ANode: TMessageNode);
begin
  MerchantMessageGetItemImages(ANode);
end;

procedure TFrmDlg.DAddFriendClick(Sender: TObject; X, Y: Integer);
var
  S: String;
begin
  S := Common.MakeMaskString(DlgEditText);
  case g_btFriendTypePage of
    1:
      begin
        DMessageDlg('添加新的好友', [mbOK, mbAbort]);
        if S = '' then
        begin
          DMessageDlg('必须填写好友名称！！！', [mbOK]);
          Exit;
        end;
        if S = g_MySelf.m_sUserName then
        begin
          DMessageDlg('不可以添加自己到好友！！！', [mbOK]);
          Exit;
        end;

        if Length(S) > 16 then
        begin
          DMessageDlg('人物名必须小于16位', [mbOK]);
          Exit;
        end;
        FrmMain.AddFriend(S);
        DMessageDlg('请求已提交，请等待结果', [mbOK]);
      end;
    3:
      begin
        DMessageDlg('添加新的黑名单', [mbOK, mbAbort]);
        if S = '' then
        begin
          g_Application.AddMessageDialog('必须填写黑名单名称！！！', [mbOK]);
          Exit;
        end;
        if S = g_MySelf.m_sUserName then
        begin
          g_Application.AddMessageDialog('不可以添加自己到黑名单！！！', [mbOK]);
          Exit;
        end;
        if Length(S) > 16 then
        begin
          g_Application.AddMessageDialog('人物名必须小于16位', [mbOK]);
          Exit;
        end;
        FrmMain.AddEnemiy(S);
      end;
  end;
end;

procedure TFrmDlg.DInternetClick(Sender: TObject; X, Y: Integer);
begin
  FrmMain.SendHotClick;
end;

procedure TFrmDlg.DWCheckNumDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  { I,j,k,o,p:   Integer;
    vPoint:   TPoint;
    vLeft:   Integer; }
begin
  // with DWCheckNum do
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  //
  // DSurface.TextOut('图片验证码:', $0040BBF1, clBlack, Left + 14, Top + 14);
  // D := FrmMain.UiDXImageList.Items.Find('CheckNum').PatternSurfaces[0];
  // if D <> nil then
  // begin
  // dsurface.Draw(SurfaceX(Left) + 60, SurfaceY(Top) + 50, D.ClientRect, D, True);
  // end;
  // end;
end;

procedure TFrmDlg.DWDiceCloseClick(Sender: TObject; X, Y: Integer);
begin
  if FDiceAniEnd1 and FDiceAniEnd2 and FDiceAniEnd3 then
    DWDice.visible := False;
end;

procedure TFrmDlg.DWDiceDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
  AIdx, m_wPx, m_wPy: Integer;
  ACanSend: Boolean;
begin
  with TDWindow(Sender) do
  begin
    D := g_77Images.Images[Propertites.ImageIndex];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    if FDiceAniEnd1 then
    begin
      D := g_77Images.GetCachedImage(500 + FDicePoint1 - 1, m_wPx, m_wPy);
      if D <> nil then
        case FDiceCount of
          1:
            begin
              dsurface.Draw(SurfaceX(Left) + 112 + m_wPx,
                SurfaceY(Top) + 78 + m_wPy, D);
              Exit;
            end;
          2:
            dsurface.Draw(SurfaceX(Left) + 70 + m_wPx,
              SurfaceY(Top) + 78 + m_wPy, D);
          3:
            dsurface.Draw(SurfaceX(Left) + 42 + m_wPx,
              SurfaceY(Top) + 78 + m_wPy, D);
        end;
    end;
    if FDiceAniEnd2 and (FDiceCount > 1) then
    begin
      D := g_77Images.GetCachedImage(500 + FDicePoint2 - 1, m_wPx, m_wPy);
      if D <> nil then
        case FDiceCount of
          1:
            ;
          2:
            begin
              dsurface.Draw(SurfaceX(Left) + 154 + m_wPx,
                SurfaceY(Top) + 78 + m_wPy, D);
              Exit;
            end;
          3:
            dsurface.Draw(SurfaceX(Left) + 112 + m_wPx,
              SurfaceY(Top) + 78 + m_wPy, D);
        end;
    end;
    if FDiceAniEnd3 and (FDiceCount > 2) then
    begin
      D := g_77Images.GetCachedImage(500 + FDicePoint3 - 1, m_wPx, m_wPy);
      if D <> nil then
        dsurface.Draw(SurfaceX(Left) + 182 + m_wPx,
          SurfaceY(Top) + 78 + m_wPy, D);
      Exit;
    end;

    AIdx := ((GetTickCount - FDiceTime) div 90) mod 4;
    D := g_77Images.GetCachedImage(506 + AIdx, m_wPx, m_wPy);
    if D <> nil then
    begin
      case FDiceCount of
        1:
          begin
            if not FDiceAniEnd1 then
              dsurface.Draw(SurfaceX(Left) + 112 + m_wPx,
                SurfaceY(Top) + 78 + m_wPy, D);
          end;
        2:
          begin
            if not FDiceAniEnd1 then
              dsurface.Draw(SurfaceX(Left) + 70 + m_wPx,
                SurfaceY(Top) + 78 + m_wPy, D);
            if not FDiceAniEnd2 then
              dsurface.Draw(SurfaceX(Left) + 154 + m_wPx,
                SurfaceY(Top) + 78 + m_wPy, D);
          end;
        3:
          begin
            if not FDiceAniEnd1 then
              dsurface.Draw(SurfaceX(Left) + 42 + m_wPx,
                SurfaceY(Top) + 78 + m_wPy, D);
            if not FDiceAniEnd2 then
              dsurface.Draw(SurfaceX(Left) + 112 + m_wPx,
                SurfaceY(Top) + 78 + m_wPy, D);
            if not FDiceAniEnd3 then
              dsurface.Draw(SurfaceX(Left) + 182 + m_wPx,
                SurfaceY(Top) + 78 + m_wPy, D);
          end;
      end;
    end;
    ACanSend := False;
    if AIdx = 3 then
    begin
      Inc(FDicePlayCount);
      case FDicePlayCount of
        5:
          begin
            FDiceAniEnd1 := True;
            if FDiceCount = 1 then
            begin
              FDiceAniEnd2 := True;
              FDiceAniEnd3 := True;
              ACanSend := True;
            end;
          end;
        8:
          begin
            FDiceAniEnd2 := True;
            if FDiceCount = 2 then
            begin
              FDiceAniEnd3 := True;
              ACanSend := True;
            end;
          end;
        11:
          begin
            FDiceAniEnd3 := True;
            ACanSend := True;
          end;
      end;
    end;
    if ACanSend then
      FrmMain.SendAfterPlayDice(FDiceID, FDicePoint1, FDicePoint2, FDicePoint3);
  end;
end;

procedure TFrmDlg.DCheckNumOKDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  // with Sender as TDButton do
  // begin
  // if not TDButton(Sender).Downed then
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // with dsurface.Canvas do
  // begin
  // Font.Style := Font.Style + [fsBold];
  // DSurface.TextOut(TDButton(Sender).Hint, $008CC6EF, clBlack)
  // .Draw(dsurface, SurfaceX(Left) + 28 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2, SurfaceY(Top) + 6);
  // Font.Style := [];
  // Release;
  // end;
  // end
  // else
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex + 1];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // with dsurface.Canvas do
  // begin
  // Font.Style := Font.Style + [fsBold];
  // DSurface.TextOut(TDButton(Sender).Hint, $0040BBF1, clBlack)
  // .Draw(dsurface, SurfaceX(Left) + 30 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2, SurfaceY(Top) + 7);
  // Font.Style := [];
  // Release;
  // end;
  // end;
  // end;
end;

procedure TFrmDlg.DCheckNumOKClick(Sender: TObject; X, Y: Integer);
begin
  FrmMain.SendCheckNum(DEditCheckNum.Text);
  // g_boIsChangeCheckNum:= True;

end;

procedure TFrmDlg.DEditCheckNumKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', 'a' .. 'z', 'A' .. 'Z', #8, #13]) then
    Key := #0;
end;

procedure TFrmDlg.DEChatKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  function GetClipboardAsLine: String;
  var
    L: TStrings;
  begin
    Result := '';
    L := TStringList.Create;
    try
      L.Text := Clipboard.AsText;
      if L.Count > 0 then
        Result := L[0];
    finally
      L.Free;
    end;
  end;

var
  AddTx: String;
  I: Integer;
begin
  case Key of
    VK_BACK:
      begin
        if DEChat.SelLength > 0 then
          g_InputStr.Delete(DEChat.SelStart, DEChat.SelStop, DEChat.SelLength)
        else if DEChat.SelStart > 0 then
          g_InputStr.Delete(DEChat.SelStart - 1);
      end;
    VK_DELETE:
      begin
        if DEChat.SelLength > 0 then
          g_InputStr.Delete(DEChat.SelStart, DEChat.SelStop, DEChat.SelLength)
        else
        begin
          if (DEChat.Text <> '') and
            (DEChat.SelStart < Length(DEChat.Text)) then
            g_InputStr.Delete(DEChat.SelStart);
        end;
      end;
    Byte('V'):
      begin
        if (ssCtrl in Shift) then
        begin
          if DEChat.SelLength > 0 then
            g_InputStr.Delete(DEChat.SelStart, DEChat.SelStop,
              DEChat.SelLength);
          g_InputStr.Insert(DEChat.SelStart, GetClipboardAsLine);
        end;
      end;
    Byte('X'):
      begin
        if (ssCtrl in Shift) then
          g_InputStr.Delete(DEChat.SelStart, DEChat.SelStop, DEChat.SelLength);
      end;
  end;
end;

procedure TFrmDlg.DEChatKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key) > 31) and ((Ord(Key) < 127) or (Ord(Key) > 159)) then
  begin
    g_InputStr.Delete(DEChat.SelStart, DEChat.SelStop, DEChat.SelLength);
    g_InputStr.Insert(DEChat.SelStart, Key);
  end;

  if Key = #13 then
  begin
    FrmMain.SendSayEx(g_InputStr.DataString, g_InputStr.ObjList);
    DEChat.Text := '';
    g_InputStr.Clear;
    SetDFocus(nil);
    Key := #0;
    // SetImeMode(EdChat.Handle, imClose);
  end;
  if Key = #27 then
  begin
    DEChat.Text := '';
    g_InputStr.Clear;
    SetDFocus(nil);
    Key := #0;
  end;
end;

procedure TFrmDlg.DEditCheckNumKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    DCheckNumOKClick(DCheckNumOK, 0, 0);
end;

procedure TFrmDlg.DCheckFashionClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DCheckFashion.TimeTick > 1000 then
  begin
    g_boShowFashion := not g_boShowFashion;
    DCheckFashion.TimeTick := GetTickCount;
    FrmMain.SendChangeState(STATE_ALLOWFASHION, g_boShowFashion);
  end;
end;

procedure TFrmDlg.DCheckFashionDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
begin
  with DCheckFashion do
  begin
    if not g_boShowFashion then
    begin
      D := g_77Images.Images[238];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end
    else
    begin
      D := g_77Images.Images[239];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;
    if Moveed then
      Color := clWhite
    else
      Color := clSilver;
    ATexture := FontManager.Default.TextOut(Caption);
    if ATexture <> nil then
      dsurface.DrawBoldText(SurfaceX(Left + D.WIDTH + 2), SurfaceY(Top) + 3,
        ATexture, Color, FontBorderColor);
  end;
end;

procedure TFrmDlg.DCheckFashionMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ShowHint(DCheckFashion.SurfaceX(DCheckFashion.Left),
    DCheckFashion.SurfaceY(DCheckFashion.Top + DCheckFashion.Height),
    DCheckFashion.Hint);
end;

procedure TFrmDlg.DCheckNumChangeClick(Sender: TObject; X, Y: Integer);
begin
  FrmMain.SendChangeCheckNum();
end;

procedure TFrmDlg.DWMakeWineDeskDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  // with DWMakeWineDesk do
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  //
  // D := g_WMain2Images.Images[586]; // 上面图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 100), SurfaceY(Top + 9), D.ClientRect, D, True);
  // if g_MakeTypeWine = 0 then
  // begin // 普通酒
  // if g_WineItem[0].Name <> '' then
  // begin
  // D := g_WMain2Images.Images[598]; // 图中酒的配置图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 235), SurfaceY(Top + 124), D.ClientRect, D, True);
  // end;
  // if g_WineItem[1].Name <> '' then
  // begin
  // D := g_WMain2Images.Images[596]; // 图中酒的配置图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 121), SurfaceY(Top + 109), D.ClientRect, D, True);
  // end;
  // if g_WineItem[2].Name <> '' then
  // begin
  // D := g_WMain2Images.Images[597]; // 图中酒的配置图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 155), SurfaceY(Top + 167), D.ClientRect, D, True);
  // end;
  // if g_WineItem[4].Name <> '' then
  // begin
  // D := g_WMain2Images.Images[599]; // 图中酒的配置图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 288), SurfaceY(Top + 119), D.ClientRect, D, True);
  // end;
  // if g_WineItem[5].Name <> '' then
  // begin
  // D := g_WMain2Images.Images[600]; // 图中酒的配置图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 330), SurfaceY(Top + 137), D.ClientRect, D, True);
  // end;
  // if g_WineItem[6].Name <> '' then
  // begin
  // D := g_WMain2Images.Images[601]; // 图中酒的配置图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 294), SurfaceY(Top + 147), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin // 药酒
  // if g_DrugWineItem[0].Name <> '' then
  // begin
  // D := g_WMain2Images.Images[603]; // 图中酒的配置图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 244), SurfaceY(Top + 107), D.ClientRect, D, True);
  // end;
  // if g_DrugWineItem[1].Name <> '' then
  // begin
  // D := g_WMain2Images.Images[602]; // 图中酒的配置图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 158), SurfaceY(Top + 132), D.ClientRect, D, True);
  // end;
  // end;
  //
  // if g_sNpcName <> '' then
  // begin // 画NPC名字
  // clFunc.TextOut(dsurface, Left + 50 - FrmMain.Canvas.TextWidth(g_sNpcName) div 2, Top + 110, clWhite, g_sNpcName);
  // end;
  //
  // if DMaterialMemo.ShowHint then
  // begin
  // D := g_WMain2Images.Images[589]; // 材料说明
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 102), SurfaceY(Top + 13), D.ClientRect, D, True);
  // if g_MakeTypeWine = 0 then
  // begin // 普通酒
  // with dsurface.Canvas do
  // begin
  // DSurface.TextOut('材料的品质是酒品质的基础，品质越好，才越', clWhite, clBlack, SurfaceX(Left + 108), SurfaceY(Top + 21));
  // DSurface.TextOut('有可能酿出好酒。还有，如果你有比我这里清', clWhite, clBlack, SurfaceX(Left + 108), SurfaceY(Top + 35));
  // DSurface.TextOut('水更甘甜的水，那用它来酿酒就更好了。', clWhite, clBlack, SurfaceX(Left + 108), SurfaceY(Top + 49));
  // Release;
  // end;
  // end
  // else
  // begin // 药酒
  // with dsurface.Canvas do
  // begin
  // DSurface.TextOut('药酒的功效主要源自药材，不同的药材会有不', clWhite, clBlack, SurfaceX(Left + 108), SurfaceY(Top + 21));
  // DSurface.TextOut('同的效果。据说还有一些独特的药酒，可能会', clWhite, clBlack, SurfaceX(Left + 108), SurfaceY(Top + 35));
  // DSurface.TextOut('对配置药酒的瓶子另有要求。', clWhite, clBlack, SurfaceX(Left + 108), SurfaceY(Top + 49));
  // Release;
  // end;
  // end;
  // end;
  //
  // if g_MakeTypeWine = 0 then
  // begin // 普通酒
  // D := g_WMain2Images.Images[585]; // 下面图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 98), SurfaceY(Top + 200), D.ClientRect, D, True);
  // end
  // else
  // begin // 药酒
  // D := g_WMain2Images.Images[587]; // 下面图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 98), SurfaceY(Top + 200), D.ClientRect, D, True);
  // end;
  //
  // if DMakeWineHelp.ShowHint then
  // begin // 如何酿酒
  // if g_MakeTypeWine = 0 then
  // begin // 普通酒
  // D := g_WMain2Images.Images[592];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 100), SurfaceY(Top - 2), D.ClientRect, D, True);
  // end
  // else
  // begin // 药酒
  // D := g_WMain2Images.Images[593];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 100), SurfaceY(Top - 2), D.ClientRect, D, True);
  // end;
  // end;
  // if DStartMakeWine.ShowHint then
  // begin
  // D := g_WMain2Images.Images[588]; // 正在酿酒的背景图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 100), SurfaceY(Top + 9), D.ClientRect, D, True);
  //
  // if GetTickCount - g_dwShowStartMakeWineTick > 150 then
  // begin
  // g_dwShowStartMakeWineTick := GetTickCount;
  // Inc(g_nShowStartMakeWineImg);
  //
  // if g_nShowStartMakeWineImg > 18 then
  // begin
  // DStartMakeWine.ShowHint := False;
  // FrmMain.SendMakeWineItems;
  // end;
  //
  // end;
  // D := g_WMain2Images.Images[610 + g_nShowStartMakeWineImg]; // 正在酿酒的背景图
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + 165), SurfaceY(Top + 9), D.ClientRect, D, True);
  //
  // { d := g_WMain2Images.Images[594];   //上面图
  // if d <> nil then
  // DrawBlendEx(dsurface,SurfaceX(Left+100),
  // SurfaceY(Top), d,0,0,d.Width,d.Height, 0); }
  // end;
  // end;
end;

procedure TFrmDlg.DMakeWineHelpDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  // with Sender as TDButton do
  // begin
  // if DStartMakeWine.ShowHint then
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // with dsurface.Canvas do
  // begin
  // Font.Style := Font.Style + [fsBold];
  // DSurface.TextOut(TDButton(Sender).Hint, clGrayText, clBlack)
  // .Draw(dsurface, SurfaceX(Left + 36 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2), SurfaceY(Top) + 5);
  // Font.Style := [];
  // Release;
  // end;
  // Exit;
  // end;
  //
  // if not TDButton(Sender).Downed then
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // with dsurface.Canvas do
  // begin
  // Font.Style := Font.Style + [fsBold];
  // DSurface.TextOut(TDButton(Sender).Hint, $008CC6EF, clBlack)
  // .Draw(dsurface, SurfaceX(Left + 36 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2), SurfaceY(Top) + 5);
  // Font.Style := [];
  // Release;
  // end;
  // end
  // else
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex + 1];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // with dsurface.Canvas do
  // begin
  // Font.Style := Font.Style + [fsBold];
  // DSurface.TextOut(TDButton(Sender).Hint, $0040BBF1, clBlack)
  // .Draw(dsurface, SurfaceX(Left + 38 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2), SurfaceY(Top) + 6);
  // Font.Style := [];
  // Release;
  // end;
  // end;
  // if not TDButton(Sender).Moveed then
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // with dsurface.Canvas do
  // begin
  // Font.Style := Font.Style + [fsBold];
  // DSurface.TextOut(TDButton(Sender).Hint, $00ADD7EF, clBlack)
  // .Draw(dsurface, SurfaceX(Left + 36 - FrmMain.Canvas.TextWidth(TDButton(Sender).Hint) div 2), SurfaceY(Top) + 5);
  // Font.Style := [];
  // Release;
  // end;
  // end;
  // end;
end;

procedure TFrmDlg.DMapAreaFlagDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
  K :Integer;
  D : TAsphyreLockableTexture;
begin
  With DMapAreaFlag do
  begin
    //绘制地图区域状态
    if SetContain(g_nAreaStateValue,AREA_CITYWARAREA) then
    begin
      DSurface.BoldText(SurfaceX(Left), SurfaceX(Top), '攻城区域', clRed, FontBorderColor);
    end
    else
    begin

        K := 0;
        if SetContain(g_nAreaStateValue,AREA_SAFE) then
        begin
          //安全
          d := g_WMainImages.Images[151];
          if d <> nil then
          begin
            DSurface.Draw(DMapAreaFlag.SurfaceX(Left), DMapAreaFlag.SurfaceX(Top), d.ClientRect, d);
            K := K + D.Width;
          end;
        end;
        //战斗
        if SetContain(g_nAreaStateValue,AREA_FIGHT) then
        begin
          d := g_WMainImages.Images[150];
          if d <> nil then
          begin
            DSurface.Draw(DMapAreaFlag.SurfaceX(k), Top, d.ClientRect, d);
          end;
        end;

    end;
  end;
end;

procedure TFrmDlg.DMailListDblClick(Sender: TObject);
begin
  DBReadMailClick(Sender, 0, 0);
end;

procedure TFrmDlg.DMailListDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  I, Y, X: Integer;
  AMailItem: TMailItem;
  ATexture: TuTexture;
begin
  D := DMailList.Propertites.Images.Images[DMailList.Propertites.ImageIndex];
  if D <> nil then
    dsurface.Draw(DMailList.SurfaceX(DMailList.Left),
      DMailList.SurfaceY(DMailList.Top), D, True);
  Y := DMailList.SurfaceY(DMailList.Top) + 76;
  X := DMailList.SurfaceX(DMailList.Left);
  if (g_Mail.Count > 0) and (g_Mail.TopIndex >= 0) then
  begin
    for I := 0 to 4 do
    begin
      if g_Mail.TopIndex + I > g_Mail.Count - 1 then
        Break;

      AMailItem := g_Mail.Items[g_Mail.TopIndex + I];
      if g_Mail.TopIndex + I = g_Mail.SelIndex then
        D := g_77Images.Images[209]
      else
        D := g_77Images.Images[208];
      if D <> nil then
        dsurface.Draw(DMailList.SurfaceX(DMailList.Left) + 19,
          DMailList.SurfaceY(DMailList.Top) + 70 + I * 46, D, True);

      if AMailItem.State = 0 then
        D := g_77Images.Images[183]
      else
        D := g_77Images.Images[184];
      if D <> nil then
        dsurface.Draw(DMailList.SurfaceX(DMailList.Left) + 25,
          DMailList.SurfaceY(DMailList.Top) + 70 + I * 46 + 6, D, True);

      if AMailItem.Attachment > 0 then
      begin
        D := g_77Images.Images[185];
        if D <> nil then
          dsurface.Draw(DMailList.SurfaceX(DMailList.Left) + 42,
            DMailList.SurfaceY(DMailList.Top) + 70 + I * 46 + 24, D, True);
      end;

      dsurface.BoldText(DMailList.SurfaceX(DMailList.Left) + 70,
        DMailList.SurfaceY(DMailList.Top) + 78 + I * 46, '发件人：', clWhite,
        FontBorderColor);
      dsurface.BoldText(DMailList.SurfaceX(DMailList.Left) + 122,
        DMailList.SurfaceY(DMailList.Top) + 78 + I * 46, AMailItem.AFrom,
        clWhite, FontBorderColor);
      dsurface.BoldText(DMailList.SurfaceX(DMailList.Left) + 230,
        DMailList.SurfaceY(DMailList.Top) + 78 + I * 46, AMailItem._ShortDate,
        clWhite, FontBorderColor);
      dsurface.BoldText(DMailList.SurfaceX(DMailList.Left) + 70,
        DMailList.SurfaceY(DMailList.Top) + 94 + I * 46, '主  题：', clWhite,
        FontBorderColor);
      dsurface.BoldText(DMailList.SurfaceX(DMailList.Left) + 122,
        DMailList.SurfaceY(DMailList.Top) + 94 + I * 46, AMailItem.Subject,
        clWhite, FontBorderColor);
    end;
  end;
end;

procedure TFrmDlg.DMailListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  X := X - DMailList.SurfaceX(DMailList.Left);
  Y := Y - DMailList.SurfaceY(DMailList.Top);
  if (X >= 18) and (X <= 264) and (Y >= 70) and (Y <= 296) then
  begin
    g_Mail.SelIndex := g_Mail.TopIndex + (Y - 70) div 46;
    if DMailReader.visible then
    begin
      if (g_Mail.Count > 0) and (g_Mail.SelIndex >= 0) and
        (g_Mail.SelIndex < g_Mail.Count) then
      begin
        if g_Mail.Selected.Loaded then
        begin
          DMMReader.Lines.Text := g_Mail.Selected.Content;
          DMMReader.BuildLines;
        end
        else
        begin
          DMMReader.Lines.Text := '(载入中...)';
          FrmMain.SendGetMailData(g_Mail.Selected.Index);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DMailListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DMailListMouseWheelDownEvent(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (X - DMailList.SurfaceX(DMailList.Left) >= 18) and
    (X - DMailList.SurfaceX(DMailList.Left) <= 264) and
    (Y - DMailList.SurfaceY(DMailList.Top) >= 70) and
    (Y - DMailList.SurfaceY(DMailList.Top) <= 296) then
  begin
    g_Mail.TopIndex := g_Mail.TopIndex + 1;
    if g_Mail.TopIndex > g_Mail.Count - 1 then
      g_Mail.TopIndex := g_Mail.Count - 1;
    UpdateMailListScroll;
  end;
end;

procedure TFrmDlg.DMailListMouseWheelUpEvent(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (X - DMailList.SurfaceX(DMailList.Left) >= 18) and
    (X - DMailList.SurfaceX(DMailList.Left) <= 264) and
    (Y - DMailList.SurfaceY(DMailList.Top) >= 70) and
    (Y - DMailList.SurfaceY(DMailList.Top) <= 296) then
  begin
    g_Mail.TopIndex := g_Mail.TopIndex - 1;
    if g_Mail.TopIndex < 0 then
      g_Mail.TopIndex := 0;
    UpdateMailListScroll;
  end;
end;

procedure TFrmDlg.DMailListPostionChange(Sender: TObject);
begin
  if DMailReader.visible then
  begin
    DMailReader.Left := DMailList.Left + DMailList.WIDTH;
    DMailReader.Top := DMailList.Top;
  end
  else if DMailWriter.visible then
  begin
    DMailWriter.Left := DMailList.Left + DMailList.WIDTH;
    DMailWriter.Top := DMailList.Top;
  end;
end;

procedure TFrmDlg.DMailListVisibleChange(Sender: TObject);
begin
  if FUILoaded and (g_MySelf <> nil) then
  begin
    if not DMailList.visible then
    begin
      DMailReader.visible := False;
      DMailWriter.visible := False;
    end
    else
    begin
      if not g_MailLoaded then
        FrmMain.SendGetMailList;
    end;
  end;
end;

procedure TFrmDlg.DMailReaderDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  AMailItem: TMailItem;
  ATexture: TAsphyreLockableTexture;
  X, Y: Integer;
begin
  X := DMailReader.SurfaceX(DMailReader.Left);
  Y := DMailReader.SurfaceY(DMailReader.Top);
  D := DMailReader.Propertites.Images.Images
    [DMailReader.Propertites.ImageIndex];
  if D <> nil then
    dsurface.Draw(X, Y, D, True);
  if g_Mail.Selected <> nil then
  begin
    ATexture := FontManager.Default.TextOut(g_Mail.Selected.AFrom);
    if ATexture <> nil then
      dsurface.DrawBoldText(X + 22, Y + 48, ATexture, clWhite, FontBorderColor);
    ATexture := FontManager.Default.TextOut(g_Mail.Selected.Subject);
    if ATexture <> nil then
      dsurface.DrawBoldText(X + 22, Y + 72, ATexture, clWhite, FontBorderColor);
    if g_Mail.Selected.GoldStr <> '' then
    begin
      ATexture := FontManager.Default.TextOut(g_Mail.Selected.GoldStr);
      dsurface.DrawBoldText(X + 26, Y + 250, ATexture, clWhite,
        FontBorderColor);
    end;
    if g_Mail.Selected.PriceStr <> '' then
    begin
      ATexture := FontManager.Default.TextOut(g_Mail.Selected.PriceStr);
      dsurface.DrawBoldText(X + 64, Y + 282, ATexture, clWhite,
        FontBorderColor);
    end;
    ATexture := FontManager.
      Default.TextOut(Format('日期：%s', [g_Mail.Selected._Date]));
    if ATexture <> nil then
      dsurface.DrawBoldText(X + 22, Y + 316, ATexture, clWhite,
        FontBorderColor);
  end;
end;

procedure TFrmDlg.DMailReaderMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DMailWriterDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  AMailItem: TMailItem;
  ATexture: TAsphyreLockableTexture;
  X, Y: Integer;
begin
  X := DMailWriter.SurfaceX(DMailWriter.Left);
  Y := DMailWriter.SurfaceY(DMailWriter.Top);
  D := DMailWriter.Propertites.Images.Images
    [DMailWriter.Propertites.ImageIndex];
  if D <> nil then
    dsurface.Draw(X, Y, D, True);
  if ClientConf.nSendMailPrice > 0 then
  begin
    case FSendGoldType of
      0:
        ATexture := FontManager.Default.TextOut(g_sGoldName);
      1:
        ATexture := FontManager.Default.TextOut(g_sGameGoldName);
    else
      ATexture := nil;
    end;
    if ATexture <> nil then
      dsurface.DrawBoldText(X + DBSendGoldType.Left - ATexture.WIDTH - 4,
        Y + DESendGold.Top + (DESendGold.Height - ATexture.Height) div 2,
        ATexture, clYellow, FontBorderColor);
    case FBuyAttGoldType of
      0:
        ATexture := FontManager.Default.TextOut(g_sGoldName);
      1:
        ATexture := FontManager.Default.TextOut(g_sGameGoldName);
    else
      ATexture := nil;
    end;
    if ATexture <> nil then
      dsurface.DrawBoldText(X + DBBuyAttGoldType.Left - ATexture.WIDTH - 4,
        Y + DEBuyAttPrice.Top + (DEBuyAttPrice.Height - ATexture.Height) div 2,
        ATexture, clYellow, FontBorderColor);

    case ClientConf.btSendMailGoldType of
      1:
        ATexture := FontManager.
          Default.TextOut(Format('邮资：%d %s', [ClientConf.nSendMailPrice,
          g_sGameGoldName]));
      2:
        ATexture := FontManager.
          Default.TextOut(Format('邮资：%d %s', [ClientConf.nSendMailPrice,
          g_sGamePointName]));
    else
      ATexture := FontManager.
        Default.TextOut(Format('邮资：%d %s', [ClientConf.nSendMailPrice,
        g_sGoldName]));
    end;
    if ATexture <> nil then
      dsurface.DrawBoldText(X + 100, Y + 342, ATexture, clYellow,
        FontBorderColor);
  end;
end;

procedure TFrmDlg.DMailWriterMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DMailWriterVisibleChange(Sender: TObject);
begin
  if FUILoaded and (g_MySelf <> nil) then
  begin
    if not DMailWriter.visible then
    begin
      if g_MailItem.Name <> '' then
      begin
        AddItemBag(g_MailItem);
        g_MailItem.Name := '';
      end;
    end;
  end;
end;

procedure TFrmDlg.DMakeWineDeskCloseClick(Sender: TObject; X, Y: Integer);
var
  I: Integer;
begin
  if DStartMakeWine.ShowHint then
    Exit;
  DWMakeWineDesk.visible := False;
  DItemBag.visible := False;
  if g_MakeTypeWine = 0 then
  begin // 普通酒
    for I := Low(g_WineItem) to High(g_WineItem) do
    begin
      if g_WineItem[I].Name <> '' then
      begin
        AddItemBag(g_WineItem[I]);
        g_WineItem[I].Name := '';
      end;
    end;
  end
  else
  begin
    for I := Low(g_DrugWineItem) to High(g_DrugWineItem) do
    begin
      if g_DrugWineItem[I].Name <> '' then
      begin // 药酒
        AddItemBag(g_DrugWineItem[I]);
        g_DrugWineItem[I].Name := '';
      end;
    end;
  end;
end;

procedure TFrmDlg.DMakeWineHelpClick(Sender: TObject; X, Y: Integer);
begin
  if DStartMakeWine.ShowHint then
    Exit;
  ShowMakeWine(False); // 隐藏下面BUTTON
  DMakeWineHelp.ShowHint := True; // 按下此按钮
end;

procedure TFrmDlg.DMaterialMemoClick(Sender: TObject; X, Y: Integer);
begin
  if DStartMakeWine.ShowHint then
    Exit;
  ShowMakeWine(True); // 显示下面BUTTON
  DMakeWineHelp.ShowHint := False; // 去掉如何酿久按下为FALSE
  DMaterialMemo.ShowHint := True; // 按下此按钮
end;

procedure TFrmDlg.DMChatHistoryDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  DScreen.ChatHisMessage.Draw(dsurface,
    DMChatHistory.SurfaceX(DMChatHistory.Left),
    DMChatHistory.SurfaceY(DMChatHistory.Top));
end;

procedure TFrmDlg.DMChatHistoryMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  V: String;
begin
  DScreen.ChatHisMessage.Click(X - DMChatHistory.Left,
    Y - DMChatHistory.Top, V);
end;

procedure TFrmDlg.DMChatHistoryMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if g_boXYChanged then
  begin
    DScreen.ChatHisMessage.Move(X - DMChatHistory.Left, Y - DMChatHistory.Top);
    Exit;
  end;
end;

procedure TFrmDlg.DMChatHistoryMouseWheelDownEvent(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  DScreen.ChatHisMessage.TopLine := DScreen.ChatHisMessage.TopLine + 1;
  if DScreen.ChatHisMessage.TopLine > DScreen.ChatHisMessage.Count - 1 then
    DScreen.ChatHisMessage.TopLine := DScreen.ChatHisMessage.Count - 1;
  UpdateChatHisSroll;
end;

procedure TFrmDlg.DMChatHistoryMouseWheelUpEvent(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  DScreen.ChatHisMessage.TopLine := DScreen.ChatHisMessage.TopLine - 1;
  if DScreen.ChatHisMessage.TopLine < 0 then
    DScreen.ChatHisMessage.TopLine := 0;
  UpdateChatHisSroll;
end;

procedure TFrmDlg.DBMateriaMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Butt: TDButton;
begin
  Butt := TDButton(Sender);
  DScreen.ShowHint(Butt.SurfaceX(Butt.Left), Butt.SurfaceY(Butt.Top - 18),
    Butt.Hint);
  g_MouseItem := g_WineItem[Butt.Tag];
end;

procedure TFrmDlg.DBMissionDoingClick(Sender: TObject; X, Y: Integer);
begin
  DBMissionDoing.Tag := Ord(Sender = DBMissionDoing);
  DBMissionUnDo.Tag := Ord(Sender = DBMissionUnDo);
  g_MissionListTopIndex := 0;
  g_MissionListSelected := -1;
  g_MissionListFocused := -1;
  DBMissionsListScroll.Top := DBMissionsListTop.Top + DBMissionsListTop.Height;
  DMissionContent.Lines.Clear;
end;

procedure TFrmDlg.DBMissionsBottomMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_MISSIONS;
  ScrollTimer.Tag := 2;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DBMissionsBottomMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DBMissionsListScrollMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMissionListY := Y;
end;

procedure TFrmDlg.DBMissionsListScrollMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  H: Single;
begin
  if DBMissionsListScroll.Downed then
  begin
    if DBMissionDoing.Tag = 0 then
      H := (DBMissionsListBottom.Top - DBMissionsListTop.Top -
        DBMissionsListTop.Height - DBMissionsListScroll.Height) /
        g_Missions.UnDoCount
    else
      H := (DBMissionsListBottom.Top - DBMissionsListTop.Top -
        DBMissionsListTop.Height - DBMissionsListScroll.Height) /
        g_Missions.DoingCount;
    DBMissionsListScroll.Top := DBMissionsListScroll.Top + Y - FMissionListY;
    if DBMissionsListScroll.Top < DBMissionsListTop.Top +
      DBMissionsListTop.Height then
      DBMissionsListScroll.Top := DBMissionsListTop.Top +
        DBMissionsListTop.Height
    else if DBMissionsListScroll.Top > DBMissionsListBottom.Top -
      DBMissionsListScroll.Height then
      DBMissionsListScroll.Top := DBMissionsListBottom.Top -
        DBMissionsListScroll.Height;
    g_MissionListTopIndex :=
      Round((DBMissionsListScroll.Top - DBMissionsListTop.Top -
      DBMissionsListTop.Height) / H);
    if g_MissionListTopIndex < 0 then
      g_MissionListTopIndex := 0
    else
    begin
      if DBMissionDoing.Tag = 0 then
      begin
        if g_MissionListTopIndex > g_Missions.UnDoCount - 1 then
          g_MissionListTopIndex := g_Missions.UnDoCount - 1;
      end
      else
      begin
        if g_MissionListTopIndex > g_Missions.DoingCount - 1 then
          g_MissionListTopIndex := g_Missions.DoingCount - 1;
      end;
    end;
    FMissionListY := Y;
  end;
  DScreen.ClearHint;
  g_MissionListSelected := -1;
end;

procedure TFrmDlg.DBMissionsScrollMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMissionY := Y;
end;

procedure TFrmDlg.DBMissionsScrollMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  H: Single;
begin
  if DBMissionsScroll.Downed then
  begin
    H := (DBMissionsBottom.Top - DBMissionsTop.Top - DBMissionsTop.Height -
      DBMissionsScroll.Height) / g_Missions.DoingCount;
    DBMissionsScroll.Top := DBMissionsScroll.Top + Y - FMissionY;
    if DBMissionsScroll.Top < DBMissionsTop.Top + DBMissionsTop.Height then
      DBMissionsScroll.Top := DBMissionsTop.Top + DBMissionsTop.Height
    else if DBMissionsScroll.Top > DBMissionsBottom.Top -
      DBMissionsScroll.Height then
      DBMissionsScroll.Top := DBMissionsBottom.Top - DBMissionsScroll.Height;
    g_MissionTopIndex :=
      Round((DBMissionsScroll.Top - DBMissionsTop.Top -
      DBMissionsTop.Height) / H);
    if g_MissionTopIndex < 0 then
      g_MissionTopIndex := 0
    else if g_MissionTopIndex > g_Missions.DoingCount - 1 then
      g_MissionTopIndex := g_Missions.DoingCount - 1;
    FMissionY := Y;
  end;
  DScreen.ClearHint;
end;

procedure TFrmDlg.DBMissionsTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_MISSIONS;
  ScrollTimer.Tag := 1;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DBMissionsTopMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  H: Single;
begin
  if DBMissionsScroll.Downed then
  begin
    H := (DBMissionsBottom.Top - DBMissionsTop.Top - DBMissionsTop.Height -
      DBMissionsScroll.Height) / g_Missions.DoingCount;
    DBMissionsScroll.Top := DBMissionsScroll.Top + Y - FMissionY;
    if DBMissionsScroll.Top < DBMissionsTop.Top + DBMissionsTop.Height then
      DBMissionsScroll.Top := DBMissionsTop.Top + DBMissionsTop.Height
    else if DBMissionsScroll.Top > DBMissionsBottom.Top -
      DBMissionsScroll.Height then
      DBMissionsScroll.Top := DBMissionsBottom.Top - DBMissionsScroll.Height;
    g_MissionTopIndex :=
      Round((DBMissionsScroll.Top - DBMissionsTop.Top -
      DBMissionsTop.Height) / H);
    if g_MissionTopIndex < 0 then
      g_MissionTopIndex := 0
    else if g_MissionTopIndex > g_Missions.DoingCount - 1 then
      g_MissionTopIndex := g_Missions.DoingCount - 1;
    FMissionY := Y;
  end;
  DScreen.ClearHint;
  g_MissionListSelected := -1;
end;

procedure TFrmDlg.DBMissionsTopMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DBMissionsWindowClick(Sender: TObject; X, Y: Integer);
begin
  ShowMissionDetail(True);
end;

procedure TFrmDlg.DBMissionSwitchClick(Sender: TObject; X, Y: Integer);
begin
//  FShowMission := not FShowMission;
//  if FShowMission then
//  begin
//    DBMissionSwitch.Hint := '隐藏任务面板';
//    DBMissionSwitch.Propertites.ImageIndex := 433
//  end
//  else
//  begin
//    DBMissionSwitch.Hint := '显示任务面板';
//    DBMissionSwitch.Propertites.ImageIndex := 431;
//  end;


  DBMissionsTop.visible := DBMissionSwitch.IsExtended;
  DBMissionsScroll.visible := DBMissionSwitch.IsExtended;
  DBMissionsBottom.visible := DBMissionSwitch.IsExtended;
  DLabelMissions.visible := DBMissionSwitch.IsExtended;
end;

procedure TFrmDlg.DBMissionUnDoDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D, ATexture: TAsphyreLockableTexture;
  T: Integer;
begin
  with TDButton(Sender) do
  begin
    T := 0;
    if Tag = 1 then
      D := Propertites.Images.Images[Propertites.ImageIndex]
    else
    begin
      D := Propertites.Images.Images[Propertites.ImageIndex + 1];
      T := 1;
    end;
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    ATexture := FontManager.Default.TextOut(Caption);
    if ATexture <> nil then
      dsurface.DrawBoldText(SurfaceX(Left) + (WIDTH - ATexture.WIDTH) div 2,
        SurfaceY(Top) + (Height - ATexture.Height) div 2 + T, ATexture, clWhite,
        $004A6B94);
  end;
end;

procedure TFrmDlg.DBMLBottomMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_MAILLIST;
  ScrollTimer.Tag := 2;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DBMLBottomMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DBMLScrollMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMLScrollY := Y;
end;

procedure TFrmDlg.DBMLScrollMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  H: Single;
begin
  if DBMLScroll.Downed and (g_Mail.Count > 0) then
  begin
    DBMLScroll.Top := DBMLScroll.Top + Y - FMLScrollY;
    if DBMLScroll.Top < DBMLTop.Top + DBMLTop.Height then
      DBMLScroll.Top := DBMLTop.Top + DBMLTop.Height
    else if DBMLScroll.Top > DBMLBottom.Top - DBMLScroll.Height then
      DBMLScroll.Top := DBMLBottom.Top - DBMLScroll.Height;
    H := (DBMLBottom.Top - DBMLTop.Top - DBMLTop.Height - DBMLScroll.Height) /
      g_Mail.Count;
    g_Mail.TopIndex :=
      Round((DBMLScroll.Top - DBMLTop.Top - DBMLTop.Height) / H);
    if g_Mail.TopIndex < 0 then
      g_Mail.TopIndex := 0
    else if g_Mail.TopIndex > g_Mail.Count - 1 then
      g_Mail.TopIndex := g_Mail.Count - 1;
    FMLScrollY := Y;
  end;
end;

procedure TFrmDlg.DBMLTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_MAILLIST;
  ScrollTimer.Tag := 1;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DBMLTopMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DBMyHairDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ax, ay, nX, nY: Integer;
begin
  if g_MySelf <> nil  then
  begin
    with DBMyHair do
    begin
      // 自己人物发型
      D := GetHumInnerHairImg(g_MySelf.m_btJob, g_MySelf.m_btSex,
        g_MySelf.m_btHair, ax, ay);

      if D <> nil then
      begin
        nX := SurfaceX(Left) + ax;
        nY := SurfaceY(Top) + ay;
        dsurface.Draw(nX, nY, D.ClientRect, D, True);
      end;
    end;
  end;
end;

procedure TFrmDlg.DBNewMailClick(Sender: TObject; X, Y: Integer);
begin
  if DMailReader.visible then
    DMailReader.visible := False;
  DMailWriter.Left := DMailList.Left + DMailList.WIDTH;
  DMailWriter.Top := DMailList.Top;
  DMailWriter.visible := True;
  SetDFocus(DMailWriter);
  DEMailTo.SetFocus;
end;

procedure TFrmDlg.DWMakeWineDeskMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
  g_MouseItem.Name := '';
end;

procedure TFrmDlg.DWMarketBuyItemClick(Sender: TObject; X, Y: Integer);
begin
  if g_MarketItem.Item.Item.Name <> '' then
    ShowMarketItemBuy;
end;

procedure TFrmDlg.DWMarketCloseButtonClick(Sender: TObject; X, Y: Integer);
begin
  DWMarket.visible := False;
  g_boPutOn := False;
end;

procedure TFrmDlg.DWMarketDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  T: TAsphyreLockableTexture;
  I, Idx: Integer;
  FC: TColor;
begin
  with DWMarket do
  begin
    D := Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    case MarketTabIdx of
      0:
        begin
          if ISMarketList then
          begin
            D := g_77Images.Images[87];
            if D <> nil then
              dsurface.Draw(SurfaceX(Left) + 28, SurfaceY(Top) + 94, D);
            Idx := MarketListPage * 10;
            for I := Idx to Idx + 10 - 1 do
            begin
              if I > g_MarketNames.Count - 1 then
                Break;

              FC := clWhite;
              if I = MarketListIndex then
                FC := clRed;;
              dsurface.BoldText(IntToStr(I), FC, clBlack, SurfaceX(Left) + 50,
                SurfaceY(Top) + 120 + (I - Idx) * 26 + 6);
              dsurface.BoldText(g_MarketPlays.Strings[I], FC, clBlack,
                SurfaceX(Left) + 104, SurfaceY(Top) + 120 + (I - Idx) * 26 + 6);
              dsurface.BoldText(g_MarketNames.Strings[I], FC, clBlack,
                SurfaceX(Left) + 272, SurfaceY(Top) + 120 + (I - Idx) * 26 + 6);
            end;
          end
          else
          begin
            D := g_77Images.Images[86];
            if D <> nil then
              dsurface.Draw(SurfaceX(Left) + 166, SurfaceY(Top) + 99, D);
            T := FontManager.Default.TextOut('摊位名称: ' + g_SelMarketName +
              '  所属玩家: ' + g_SelMarketPlay);
            if T <> nil then
              dsurface.DrawBoldText(SurfaceX(Left) + 286, SurfaceY(Top) + 72, T,
                $0093F4F2, FontBorderColor);
          end;
        end;
      1:
        begin
          D := g_77Images.Images[86];
          if D <> nil then
            dsurface.Draw(SurfaceX(Left) + 166, SurfaceY(Top) + 99, D);
          T := FontManager.Default.TextOut('摊位名称:');
          if T <> nil then
            dsurface.DrawBoldText(SurfaceX(Left) + 28, SurfaceY(Top) + 394, T,
              $0093F4F2, FontBorderColor);
          dsurface.BoldText('库存资金', $0093F4F2, FontBorderColor,
            SurfaceX(Left) + 40, SurfaceY(Top) + 106);
          dsurface.BoldText('金币: ' + IIFI(g_MyMarketGold), $0093F4F2,
            FontBorderColor, SurfaceX(Left) + 40, SurfaceY(Top) + 122);
          dsurface.BoldText('元宝: ' + IIFI(g_MyMarketGameGold), $0093F4F2,
            FontBorderColor, SurfaceX(Left) + 40, SurfaceY(Top) + 138);
          DrawTextItem(dsurface, DWMarketName.SurfaceX(DWMarketName.Left) - 12,
            DWMarketName.SurfaceY(DWMarketName.Top) - 4,
            DWMarketName.WIDTH + 24);
          if g_boPutOn then
            dsurface.TextOut('(请选择背包需要上架的物品)', clRed, SurfaceX(Left) + 292,
              SurfaceY(Top) + 70);
        end;
      2:
        ;
    end;
  end;
end;

procedure TFrmDlg.DWMarketExtGoldClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DWMarketExtGold.TimeTick > 10000 then
  begin
    FrmMain.SendMarketExtractGold;
    DWMarketExtGold.TimeTick := GetTickCount;
  end;
end;

procedure TFrmDlg.DWMarketItemsGridMouseMove(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  Idx: Integer;
  AStallItem: TClientStallItem;
  _Pos: TPoint;
begin
  Idx := ACol + ARow * DWMarketItems.ColCount;
  if Idx in [0 .. 11] then
  begin
    _Pos := g_Application._CurPos;
    if ((ACol = 0) and (_Pos.X < DWMarketItems.SurfaceX(DWMarketItems.Left) +
      38)) or ((ACol = 1) and
      (_Pos.X < DWMarketItems.SurfaceX(DWMarketItems.Left) + 270)) then
    begin
      case Self.MarketTabIdx of
        0:
          AStallItem := g_WhoStall[Idx];
        1:
          AStallItem := g_MyMarket[Idx];
      end;
      if AStallItem.Item.Name <> '' then
      begin
        if (AStallItem.Item.MakeIndex = g_MouseItem.MakeIndex) and
          DScreen.ItemHint then
          DScreen.UpdateItemHintPostion(g_Application._CurPos)
        else
        begin
          g_MouseItem := AStallItem.Item;
          DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkMarket,
            AStallItem.Gold, AStallItem.GameGold);
        end;
      end
      else
      begin
        g_MouseItem.Name := '';
        DScreen.ClearHint;
      end;
    end
    else
    begin
      g_MouseItem.Name := '';
      DScreen.ClearHint;
    end;
  end
  else
    DScreen.ClearHint;
end;

procedure TFrmDlg.DWMarketItemsGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
var
  Idx, L: Integer;
  D, T: TAsphyreLockableTexture;
  AStallItem: TClientStallItem;
  NameT: TuTexture;
  c: TColor;
  S: String;
begin
  Idx := ACol + ARow * DWMarketItems.ColCount;
  if Idx in [0 .. 11] then
  begin
    with DWMarketItems do
    begin
      if Idx = MarketItemIndex then
      begin
        D := g_77Images.Images[90];
        dsurface.Draw(SurfaceX(Rect.Left) + ACol * 4,
          SurfaceY(Rect.Top) + 4, D);
      end;
      case MarketTabIdx of
        0:
          AStallItem := g_WhoStall[Idx];
        1:
          AStallItem := g_MyMarket[Idx];
      end;
      if AStallItem.Item.Name <> '' then
      begin
        DrawItem(AStallItem.Item, dsurface, SurfaceX(Rect.Left) + ACol * 4 + 2,
          SurfaceY(Rect.Top) + 6, 34, 34, TimeTick);
        c := clWhite;
        if MarketItemIndex = Idx then
          c := clRed;
        L := SurfaceX(Rect.Left) + ACol * 4 + 40;
        NameT := Textures.ObjectName(dsurface, AStallItem.Item.DisplayName);
        if NameT <> nil then
        begin
          NameT.Draw(dsurface, L, SurfaceY(Rect.Top) + 10, c);
          if AStallItem.Item.S.StdMode in [{$I AddinStdmode.INC}] then
          begin
            T := FontManager.
              Default.TextOut('x' + IntToStr(AStallItem.Item.Dura));
            if T <> nil then
              dsurface.DrawBoldText(L + NameT.WIDTH + 2,
                SurfaceY(Rect.Top) + 10, T, c, FontBorderColor);
          end;
        end;

        T := FontManager.Default.TextOut('单价:');
        if T <> nil then
        begin
          dsurface.DrawBoldText(L + 2, SurfaceY(Rect.Top) + 24, T, c,
            FontBorderColor);
          Inc(L, 8);
          Inc(L, T.WIDTH);
        end;

        if AStallItem.Gold > 0 then
        begin
          T := FontManager.Default.TextOut(IntToStr(AStallItem.Gold) + '金币');
          if T <> nil then
          begin
            dsurface.DrawBoldText(L, SurfaceY(Rect.Top) + 24, T, c,
              FontBorderColor);
            Inc(L, T.WIDTH + 4);
          end;
        end;
        if AStallItem.GameGold > 0 then
        begin
          T := FontManager.
            Default.TextOut(IntToStr(AStallItem.GameGold) + '元宝');
          if T <> nil then
            dsurface.DrawBoldText(L, SurfaceY(Rect.Top) + 24, T, c,
              FontBorderColor);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DWMarketItemsGridSelect(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
  Idx: Integer;
begin
  MarketItemIndex := -1;
  if not g_boStallLock then
  begin
    g_MarketItem.Item.Item.Name := '';
    Idx := ACol + ARow * DWMarketItems.ColCount;
    if Idx in [0 .. 11] then
    begin
      g_SoundManager.DXPlaySound(s_norm_button_click);
      if MarketTabIdx = 1 then
      begin
        if g_MyMarket[Idx].Item.Name <> '' then
        begin
          MarketItemIndex := Idx;
          DScreen.ClearHint;
          ShowMarketItemUpdate;
        end;
      end
      else
      begin
        if g_WhoStall[Idx].Item.Name <> '' then
        begin
          MarketItemIndex := Idx;
          StallItemState := ssMarketBuy;
          g_MarketItem.Item := g_WhoStall[MarketItemIndex];
          // g_MarketItem.Inedex  :=  -1;
        end;
      end;
    end
    else
      MarketItemIndex := -1;
  end;
end;

procedure TFrmDlg.DWMarketItemVisibleChange(Sender: TObject);
begin
  if not DWMarketItem.visible and not g_boStallLock then
  begin
    g_boStallLock := False;
    case StallItemState of
      ssNone:
        begin
          if g_boPutOn and (g_MarketItem.Item.Item.Name <> '') then
            AddItemBag(g_MarketItem.Item.Item);
        end;
      ssMarketBuy:
        ;
      ssMarketUpdate:
        ;
      ssMarketPutOn:
        begin
          AddItemBag(g_MarketItem.Item.Item);
          g_MarketItem.Item.Item.Name := '';
        end;
      ssStallPutOn:
        begin
          AddItemBag(g_MarketItem.Item.Item);
          g_MarketItem.Item.Item.Name := '';
          g_boPutOn := False;
        end;
      ssStallUpdate:
        ;
      ssStallSaleToBuy:
        begin
          AddItemBag(g_MarketItem.Item.Item);
          g_MarketItem.Item.Item.Name := '';
          g_boPutOn := False;
        end;
    end;
  end;
end;

procedure TFrmDlg.DWMarketMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (MarketTabIdx = 0) and ISMarketList then
  begin
    MarketListIndex := -1;
    g_SelMarketName := '';
    g_SelMarketPlay := '';
    if (MarketTabIdx = 0) and ISMarketList then
    begin
      if (X > DWMarket.SurfaceX(DWMarket.Left) + 30) and
        (X < DWMarket.SurfaceX(Left) + 620) and
        (Y > DWMarket.SurfaceY(DWMarket.Top) + 120) and
        (Y < DWMarket.SurfaceY(DWMarket.Top) + 376) then
      begin
        MarketListIndex := (Y - DWMarket.SurfaceY(DWMarket.Top) - 120) div 26 +
          MarketListPage * 10;
        if (MarketListIndex >= 0) and
          (MarketListIndex < g_MarketNames.Count) then
        begin
          g_SelMarketName := g_MarketNames.Strings[MarketListIndex];
          g_SelMarketPlay := g_MarketPlays.Strings[MarketListIndex];
        end;
        g_SoundManager.DXPlaySound(s_norm_button_click);
      end;
    end;
  end;
end;

procedure TFrmDlg.DWMarketMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DWMarketNPageClick(Sender: TObject; X, Y: Integer);
begin
  if MarketListPage < Ceil(g_MarketNames.Count / 10) then
    Inc(MarketListPage);
end;

procedure TFrmDlg.DWMarketNStallClick(Sender: TObject; X, Y: Integer);
begin
  if MarketListIndex > g_MarketNames.Count - 1 then
    Exit;
  Inc(MarketListIndex);
  if (MarketListIndex >= 0) and (MarketListIndex < g_MarketNames.Count) and
    (GetTickCount - DWMarketNStall.TimeTick > 1000) then
  begin
    DWMarketNStall.TimeTick := GetTickCount;
    g_SelMarketName := g_MarketNames.Strings[MarketListIndex];
    g_SelMarketPlay := g_MarketPlays.Strings[MarketListIndex];
    FrmMain.SendMarketGetItems(g_SelMarketPlay);
  end;
end;

procedure TFrmDlg.DWMarketPPageClick(Sender: TObject; X, Y: Integer);
begin
  if MarketListPage > 0 then
    Dec(MarketListPage);
end;

procedure TFrmDlg.DWMarketPStallClick(Sender: TObject; X, Y: Integer);
begin
  ReStall;
  if MarketListIndex <= 0 then
    Exit;
  Dec(MarketListIndex);
  if (MarketListIndex >= 0) and (MarketListIndex < g_MarketNames.Count) and
    (GetTickCount - DWMarketPStall.TimeTick > 1000) then
  begin
    DWMarketPStall.TimeTick := GetTickCount;
    g_SelMarketName := g_MarketNames.Strings[MarketListIndex];
    g_SelMarketPlay := g_MarketPlays.Strings[MarketListIndex];
    FrmMain.SendMarketGetItems(g_SelMarketPlay);
  end;
end;

procedure TFrmDlg.DWMarketPutOnClick(Sender: TObject; X, Y: Integer);
begin
  g_boPutOn := not g_boPutOn;
  if g_boPutOn and not DItemBag.visible then
  begin
    DItemBag.Left := DWMarket.Left + DWMarket.WIDTH;
    DItemBag.Top := 32;
    DItemBag.visible := True;
  end;
end;

procedure TFrmDlg.DWMarketPutOnDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  T: TAsphyreLockableTexture;
  OffSet: Integer;
begin
  OffSet := 0;
  with TDButton(Sender) do
  begin
    if g_boPutOn then
      Propertites.Caption.Text := '取消上架'
    else
      Propertites.Caption.Text := '物品上架';
    DefaultPaint(dsurface);
  end;
end;

procedure TFrmDlg.DWMarketRItemsClick(Sender: TObject; X, Y: Integer);
begin
  ReStall;
  if g_SelMarketPlay <> '' then
    FrmMain.SendMarketGetItems(g_SelMarketPlay);
end;

procedure TFrmDlg.DWMarketRListClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DWMarketRList.TimeTick > 5000 then
  begin
    FrmMain.SendMarketGetList;
    MarketListPage := 0;
    DWMarketRList.TimeTick := GetTickCount;
  end;
end;

procedure TFrmDlg.DWMarketRMyItemsClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DWMarketRMyItems.TimeTick > 5000 then
  begin
    FrmMain.SendMarketGetItems('');
    DWMarketRMyItems.TimeTick := GetTickCount;
  end;
end;

procedure TFrmDlg.DWMarketSButtonClick(Sender: TObject; X, Y: Integer);
begin
  SetMarketTabIndex(TDButton(Sender).Tag);
end;

procedure TFrmDlg.DWMarketSButtonDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  T: TAsphyreLockableTexture;
  OffSet: Integer;
begin
  OffSet := 0;
  with TDButton(Sender) do
  begin
    if not Enabled then
      D := g_77Images.Images[63]
    else if MarketTabIdx = Tag then
    begin
      D := g_77Images.Images[85];
      OffSet := 1;
    end
    else
      D := g_77Images.Images[84];
    dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    T := FontManager.Default.TextOut(Caption);
    if T <> nil then
    begin
      dsurface.DrawBoldText(SurfaceX(Left) + (WIDTH - T.WIDTH) div 2 + OffSet,
        SurfaceY(Top) + (Height - T.Height) div 2 + OffSet, T, $0093F4F2,
        FontBorderColor);
    end;
  end;
end;

procedure TFrmDlg.DWMarketSetNameClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DWMarketSetName.TimeTick > 5000 then
  begin
    if DWMarketName.Text = '' then
    begin
      g_Application.AddMessageDialog('摊位名称必须填写', [mbOK]);
      Exit;
    end;
    if not ISVlidateMaketName(DWMarketName.Text) then
    begin
      g_Application.AddMessageDialog('摊位名称含有非法字符', [mbOK]);
      Exit;
    end;
    FrmMain.SendMarketSetName(Common.MakeMaskString(DWMarketName.Text));
    DWMarketSetName.TimeTick := GetTickCount;
  end;
end;

procedure TFrmDlg.DWMarketVListClick(Sender: TObject; X, Y: Integer);
begin
  ISMarketList := True;
  SetMarketTabIndex(0);
end;



procedure TFrmDlg.DWMarketVStallClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DWMarketRList.TimeTick > 1000 then
  begin
    if (MarketListIndex >= 0) and (MarketListIndex < g_MarketPlays.Count) then
    begin
      FrmMain.SendMarketGetItems(g_MarketPlays.Strings[MarketListIndex]);
      DWMarketRList.TimeTick := GetTickCount;
    end
    else
      g_Application.AddMessageDialog('请先选择摊位', [mbOK]);
  end;
end;

procedure TFrmDlg.DWMaxMiniMapCDblClick(Sender: TObject);
begin
  g_uAutoRun := False;
  if (g_nMouseMaxMapX >= 0) and (g_nMouseMaxMapY >= 0) then
  begin
    FrmMain.AutoGoto(g_nMouseMaxMapX, g_nMouseMaxMapY);
    g_boISTrail := False;
  end;
end;

procedure TFrmDlg.DWMaxMiniMapCDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  rc: TRect;
  mx, my, lx, ly: Integer;
  I: Integer;
  P: PPoint;
  boDrawFlag: Boolean;
  actor: TActor;
  nX, nY: Integer;
  ATexture: TAsphyreLockableTexture;
  xScale,yScale : Double;
begin
  if TryGetMMap(g_nMiniMapIndex, D) then
  begin
    if GetTickCount > m_dwBlinkTime + 300 then
    begin
      m_dwBlinkTime := GetTickCount;
      m_boViewBlink := not m_boViewBlink;
    end;

    if D <> nil then
    begin
      //小地图是缩放 32倍的 所以 这里计算的是 自己在小地图像素的位置
      mx := (g_MySelf.m_nCurrX * 48) div 32;
      my := (g_MySelf.m_nCurrY * 32) div 32;

      //确定绘制地图的区域
      rc.Left := _Max(0, mx - (DWMaxMiniMapC.Width div 2) + g_nMouseMaxMapOffsetX);
      rc.Top := _Max(0, my - (DWMaxMiniMapC.Height div 2) + g_nMouseMaxMapOffsetY);
      rc.Right := _MIN(D.ClientRect.Right, rc.Left + DWMaxMiniMapC.WIDTH);
      rc.Bottom := _MIN(D.ClientRect.Bottom, rc.Top + DWMaxMiniMapC.Height);


      if (rc.Right - rc.Left < DWMaxMiniMapC.WIDTH) and
        (D.WIDTH > DWMaxMiniMapC.WIDTH) then
      begin
        rc.Left := D.ClientRect.Right - DWMaxMiniMapC.WIDTH;
        rc.Right := rc.Left + DWMaxMiniMapC.WIDTH;
      end;

      if (rc.Bottom - rc.Top < DWMaxMiniMapC.Height) and
        (D.Height > DWMaxMiniMapC.Height) then
      begin
        rc.Top := D.ClientRect.Bottom - DWMaxMiniMapC.Height;
        rc.Bottom := rc.Top + DWMaxMiniMapC.Height;
      end;



      with DWMaxMiniMapC do
      begin
        boDrawFlag := False;
        lx := SurfaceX(Left);
        ly := SurfaceY(Top);

        if (D.Width < DWMaxMiniMapC.Width) or (D.Height < DWMaxMiniMapC.Height)   then
        begin
          xScale := DWMaxMiniMapC.Width / D.Width ;
          yScale := DWMaxMiniMapC.Height/ D.Height;
          //dsurface.Draw(lx, ly, rc, D, False);
          rc := D.ClientRect;
          dsurface.Draw(rc, DWMaxMiniMapC.ClientDrawRect, D, cAlpha4(clwhite))
        end else
        begin
          xScale := 1;
          yScale := 1;
          dsurface.Draw(lx, ly, rc, D, False);
        end;

        for I := g_uPointList.Count - 1 downto 0 do
        begin
          P := g_uPointList.Items[I];
          mx := (P.X * 48) div 32;
          my :=  P^.Y;
          if PtInRect(rc, Point(mx, my)) then
          begin
            mx := Round(mx * xScale);
            my := Round(my * yScale);
            dsurface.PixelsOut(lx + mx - rc.Left,
              ly + my - rc.Top, clRed, 2);
            if not boDrawFlag then
            begin
              D := g_77Images.Images[116];
              if (D <> nil) then
                dsurface.Draw(lx + mx - rc.Left,
                  ly + my - rc.Top - D.Height, D);
              boDrawFlag := True;
            end;
          end;
        end;

        //显示地图描述
        for I := 0 to g_CurMapDesc.Count - 1 do
        begin
          if g_CurMapDesc.Items[I]._Type in [0, 2] then
          begin
            mx := (g_CurMapDesc.Items[I].MapX * 48) div 32;
            my := (g_CurMapDesc.Items[I].MapY * 32) div 32;
            if PtInRect(rc, Point(mx, my)) then
            begin
              mx := Round(mx * xScale);
              my := Round(my * yScale);
              ATexture := FontManager.
                Default.TextOut(g_CurMapDesc.Items[I].Desc);
              if ATexture <> nil then
              begin
                if (mx + ATexture.WIDTH div 2 >= rc.Left) and
                  (mx - ATexture.WIDTH div 2 <= rc.Right) and
                  (my + ATexture.Height div 2 >= rc.Top) and
                  (my - ATexture.Height div 2 <= rc.Bottom) then
                  dsurface.DrawBoldTextInRect(lx + mx - rc.Left -
                    ATexture.WIDTH div 2, ly + my - rc.Top -
                    ATexture.Height div 2, Rect(lx, ly, lx + DWMaxMiniMapC.Width, ly + DWMaxMiniMapC.Height),
                    ATexture, g_CurMapDesc.Items[I].Color, FontBorderColor);
              end;
            end;
          end;
        end;

        if m_boViewBlink then
        begin
          mx := (g_MySelf.m_nCurrX * 48) div 32;
          my := (g_MySelf.m_nCurrY * 32) div 32;
          if PtInRect(rc, Point(mx, my)) then
          begin
            mx := Round(mx * xScale);
            my := Round(my * yScale);
            D := g_77Images.Images[111];
            if D <> nil then
            begin
              dsurface.Draw(lx + mx - rc.Left, ly + my - rc.Top, D);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DWMaxMiniMapCMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
  begin
    g_nMouseMaxMapOldX := X;
    g_nMouseMaxMapOldY := Y;
  end;
end;

procedure TFrmDlg.DWMaxMiniMapCMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  D: TAsphyreLockableTexture;
  rc: TRect;
  mx, my, OX, OY: Integer;
begin
  if TryGetMMap(g_nMiniMapIndex, D) then
  begin
    mx := (g_MySelf.m_nCurrX * 48) div 32;
    my := (g_MySelf.m_nCurrY * 32) div 32;

    if (ssLeft in Shift) and ((D.WIDTH > DWMaxMiniMapC.WIDTH) or
      (D.Height > DWMaxMiniMapC.Height)) then
    begin
      //确定小地图显示的像素范围边界
      rc.Left := _Max(0, mx - (DWMaxMiniMapC.Width div 2) + g_nMouseMaxMapOffsetX);
      rc.Top := _Max(0, my - (DWMaxMiniMapC.Height div 2) + g_nMouseMaxMapOffsetY);
      rc.Right := _MIN(D.ClientRect.Right, rc.Left + DWMaxMiniMapC.WIDTH);
      rc.Bottom := _MIN(D.ClientRect.Bottom, rc.Top + DWMaxMiniMapC.Height);


      //图片显示的有效宽度 小于组件的宽度 并且 纹理的宽度 大于组件的宽度。
      if (rc.Right - rc.Left < DWMaxMiniMapC.WIDTH) and
        (D.WIDTH > DWMaxMiniMapC.WIDTH) then
      begin
        rc.Left := D.ClientRect.Right - DWMaxMiniMapC.WIDTH;
        rc.Right := rc.Left + DWMaxMiniMapC.WIDTH;
      end;

      if (rc.Bottom - rc.Top < DWMaxMiniMapC.Height) and
        (D.Height > DWMaxMiniMapC.Height) then
      begin
        rc.Top := D.ClientRect.Bottom - DWMaxMiniMapC.Height;
        rc.Bottom := rc.Top + DWMaxMiniMapC.Height;
      end;

      if (D.WIDTH > DWMaxMiniMapC.WIDTH) then
      begin
        if (rc.Left + (g_nMouseMaxMapOldX - X) > 0) and
          (rc.Right + (g_nMouseMaxMapOldX - X) < D.ClientRect.Right) then
          g_nMouseMaxMapOffsetX := g_nMouseMaxMapOffsetX +
            g_nMouseMaxMapOldX - X;
      end;
      if (D.Height > DWMaxMiniMapC.Height) then
      begin
        if (rc.Top + (g_nMouseMaxMapOldY - Y) > 0) and
          (rc.Bottom + (g_nMouseMaxMapOldY - Y) < D.ClientRect.Bottom) then
          g_nMouseMaxMapOffsetY := g_nMouseMaxMapOffsetY +
            g_nMouseMaxMapOldY - Y;
      end;
      g_nMouseMaxMapOldX := X;
      g_nMouseMaxMapOldY := Y;
    end;

    rc.Left := _Max(0, mx - (DWMaxMiniMapC.Width div 2) + g_nMouseMaxMapOffsetX);
    rc.Top := _Max(0, my - (DWMaxMiniMapC.Height div 2) + g_nMouseMaxMapOffsetY);
    rc.Right := _MIN(D.ClientRect.Right, rc.Left + DWMaxMiniMapC.WIDTH);
    rc.Bottom := _MIN(D.ClientRect.Bottom, rc.Top + DWMaxMiniMapC.Height);

    if (rc.Right - rc.Left < DWMaxMiniMapC.WIDTH) and
      (D.WIDTH > DWMaxMiniMapC.WIDTH) then
    begin
      rc.Left := D.ClientRect.Right - DWMaxMiniMapC.WIDTH;
      rc.Right := rc.Left + DWMaxMiniMapC.WIDTH;
    end;
    if (rc.Bottom - rc.Top < DWMaxMiniMapC.Height) and
      (D.Height > DWMaxMiniMapC.Height) then
    begin
      rc.Top := D.ClientRect.Bottom - DWMaxMiniMapC.Height;
      rc.Bottom := rc.Top + DWMaxMiniMapC.Height;
    end;

    mx := g_nMouseMaxMapX;
    my := g_nMouseMaxMapY;

    if (D.Width < DWMaxMiniMapC.WIDTH) or (D.Height < DWMaxMiniMapC.Height) then
    begin
      g_nMouseMaxMapX := Round(((( X - DWMaxMiniMapC.Left ) * 32) div 48) / (DWMaxMiniMapC.WIDTH / D.Width ));
      g_nMouseMaxMapY := Round((( Y - DWMaxMiniMapC.Top  ) * 32 div 32)  / (DWMaxMiniMapC.Height / D.Height ));
    end else
    begin
      g_nMouseMaxMapX := (((rc.Left + X - DWMaxMiniMapC.Left ) * 32) div 48);
      g_nMouseMaxMapY := ((rc.Top + Y - DWMaxMiniMapC.Top  ) * 32 div 32);
    end;

  end;
end;

procedure TFrmDlg.DWMaxMiniMapDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  _X, _Y: Integer;
begin
  TDWindow(Sender).DefaultPaint(dsurface);
//  _X := DWMaxMiniMap.SurfaceX(DWMaxMiniMap.Left);
//  _Y := DWMaxMiniMap.SurfaceY(DWMaxMiniMap.Top);
//  D := g_77Images.Images[117];
//  if D <> nil then
//    dsurface.Draw(_X, _Y, D, True);
//  dsurface.BoldText(g_sMapTitle, clLime, FontBorderColor, _X + 86, _Y + 42);
//  dsurface.BoldText(IntToStr(g_nMouseMaxMapX), clLime, FontBorderColor,
//    _X + 370, _Y + 42);
//  dsurface.BoldText(IntToStr(g_nMouseMaxMapY), clLime, FontBorderColor,
//    _X + 456, _Y + 42);

  DTMapName.Propertites.Caption.Text := g_sMapTitle;
  DTMapMouseX.Propertites.Caption.Text := IntToStr(g_nMouseMaxMapX);
  DTMapMouseY.Propertites.Caption.Text := IntToStr(g_nMouseMaxMapY)
end;

procedure TFrmDlg.DWMaxMiniMapMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if not g_uAutoRun then
    ClearAutoRunPointList;
end;

procedure TFrmDlg.DWMaxMiniMapVisibleChange(Sender: TObject);
begin
  g_ISOpenMaxMiniMap := DWMaxMiniMap.Visible;
end;

procedure TFrmDlg.ShowMakeWine(bool: Boolean);
begin
  DBMateria.visible := False;
  DBWineSong.visible := False;
  DBWater.visible := False;
  DBWineCrock.visible := False;
  DBAssistMaterial1.visible := False;
  DBAssistMaterial2.visible := False;
  DBAssistMaterial3.visible := False;
  DBDrug.visible := False;
  DBWine.visible := False;
  DBWineBottle.visible := False;
  if g_MakeTypeWine = 0 then
  begin // 普通酒
    DBMateria.visible := bool;
    DBWineSong.visible := bool;
    DBWater.visible := bool;
    DBWineCrock.visible := bool;
    DBAssistMaterial1.visible := bool;
    DBAssistMaterial2.visible := bool;
    DBAssistMaterial3.visible := bool;
  end
  else
  begin // 药酒
    DBDrug.visible := bool;
    DBWine.visible := bool;
    DBWineBottle.visible := bool;
  end;
end;

procedure TFrmDlg.ShowMap;
begin
  if not g_boViewMiniMap then
  begin
    if GetTickCount > g_dwQueryMsgTick then
    begin
      g_dwQueryMsgTick := GetTickCount + 3000;
      FrmMain.SendWantMiniMap;
    end;
  end
  else
  begin
    if g_ISOpenMiniMap and not DWMiniMap.visible and
      (g_btMiniMapType in [1, 2]) then
    begin
      DWMiniMap.visible := True;
    end;
    if g_ISOpenMaxMiniMap and not DWMaxMiniMap.visible then
    begin
      g_nMouseMaxMapX := 0;
      g_nMouseMaxMapY := 0;
      g_nMouseMaxMapOffsetX := 0;
      g_nMouseMaxMapOffsetY := 0;
      DWMaxMiniMap.Left := _Max(0, (SCREENWIDTH - 600) div 2);
      DWMaxMiniMap.Top := _Max(0, (SCREENHEIGHT - 480 - DBottom.Height) div 2);
      DWMaxMiniMap.visible := True;
    end;
  end;
end;

procedure TFrmDlg.ShowMarkteItemModal;
begin
  DScreen.ClearHint;
  FrmMain.CloseTopmost;
  if DWMarket.visible then
  begin
    DWMarketItem.Left := DWMarket.Left +
      (DWMarket.WIDTH - DWMarketItem.WIDTH) div 2;
    DWMarketItem.Top := DWMarket.Top +
      (DWMarket.Height - DWMarketItem.Height) div 2;
  end
  else
  begin
    DWMarketItem.Left := (SCREENWIDTH - DWMarketItem.WIDTH) div 2;
    DWMarketItem.Top := (SCREENHEIGHT - DWMarketItem.Height) div 2;
  end;
  DWMarketItem.ShowModal;
  DWMarketItemGoldEdt.SetFocus;
end;

procedure TFrmDlg.ShowMarketItemBuy;
begin
  StallItemState := ssMarketBuy;
  if g_MarketItem.Item.Item.S.StdMode in [{$I AddinStdmode.INC}] then
  begin
    DWMarketItemCountEdt.Text := IntToStr(g_MarketItem.Item.Item.Dura);
    DWMarketItemCountEdt.ReadOnly := False;
    DWMarketItemGoldEdt.Text :=
      IIFI(g_MarketItem.Item.Gold * g_MarketItem.Item.Item.Dura);
    DWMarketItemGameGoldEdt.Text :=
      IIFI(g_MarketItem.Item.GameGold * g_MarketItem.Item.Item.Dura);
    DWMarketItemCountEdt.SetFocus;
  end
  else
  begin
    DWMarketItemCountEdt.Text := '1';
    DWMarketItemCountEdt.ReadOnly := True;
    DWMarketItemGoldEdt.Text := IIFI(g_MarketItem.Item.Gold);
    DWMarketItemGameGoldEdt.Text := IIFI(g_MarketItem.Item.GameGold);
  end;
  DWMarketItemGoldEdt.ReadOnly := True;
  DWMarketItemGameGoldEdt.ReadOnly := True;
  DWMarketWinName.Propertites.Caption.Text := '购买物品';
  DWMarketItem.visible := True;
  DWMarketItemPutOff.Propertites.Caption.Text := '取消';
  DWMarketItemPutOn.Propertites.Caption.Text := '购买';
  DWMarketItemGameGoldEdt.Propertites.TextHint := '<元宝合计>';
  DWMarketItemGoldEdt.Propertites.TextHint := '<金币合计>';
  ShowMarkteItemModal;
end;

procedure TFrmDlg.ShowMarketItemPutOn;
begin
  StallItemState := ssMarketPutOn;
  if g_MarketItem.Item.Item.S.StdMode in [{$I AddinStdmode.INC}] then
    DWMarketItemCountEdt.Text := IntToStr(g_MarketItem.Item.Item.Dura)
  else
    DWMarketItemCountEdt.Text := '1';
  DWMarketItemCountEdt.ReadOnly := True;
  DWMarketItemGoldEdt.Text := '';
  DWMarketItemGameGoldEdt.Text := '';
  DWMarketItemGoldEdt.ReadOnly := False;
  DWMarketItemGameGoldEdt.ReadOnly := False;
  DWMarketWinName.Propertites.Caption.Text := '物品上架';
  DWMarketItem.visible := True;
  DWMarketItemPutOff.Propertites.Caption.Text := '取消';
  DWMarketItemPutOn.Propertites.Caption.Text := '上架';
  DWMarketItemGameGoldEdt.Propertites.TextHint := '<元宝单价>';
  DWMarketItemGoldEdt.Propertites.TextHint := '<金币单价>';
  ShowMarkteItemModal;
end;

procedure TFrmDlg.ShowMarketItemUpdate;
begin
  if g_MyMarket[MarketItemIndex].Item.Name <> '' then
  begin
    g_MarketItem.Item := g_MyMarket[MarketItemIndex];
    g_MarketItem.Inedex := -1;
    DWMarketItemGoldEdt.ReadOnly := False;
    DWMarketItemGameGoldEdt.ReadOnly := False;
    DWMarketItemCountEdt.ReadOnly := True;
    if g_MarketItem.Item.Item.S.StdMode in [{$I AddinStdmode.INC}] then
      DWMarketItemCountEdt.Text := IntToStr(g_MarketItem.Item.Item.Dura)
    else
      DWMarketItemCountEdt.Text := '1';
    DWMarketItemCountEdt.ReadOnly := True;
    DWMarketItemGoldEdt.Text := IIFI(g_MarketItem.Item.Gold);
    DWMarketItemGameGoldEdt.Text := IIFI(g_MarketItem.Item.GameGold);
    StallItemState := ssMarketUpdate;
    DWMarketWinName.Propertites.Caption.Text := '物品调整';
    DWMarketItem.visible := True;
    DWMarketItemPutOn.Propertites.Caption.Text := '完成修改';
    DWMarketItemPutOff.Propertites.Caption.Text := '下架';
    DWMarketItemGameGoldEdt.Propertites.TextHint := '<元宝单价>';
    DWMarketItemGoldEdt.Propertites.TextHint := '<金币单价>';
    ShowMarkteItemModal;
  end;
end;

procedure TFrmDlg.ShowStallPutOn;
begin
  StallItemState := ssStallPutOn;
  DWMarketItemGoldEdt.Text := '';
  DWMarketItemGameGoldEdt.Text := '';
  DWMarketItemGoldEdt.ReadOnly := False;
  DWMarketItemGameGoldEdt.ReadOnly := False;
  if g_MarketItem.Item.Item.S.StdMode in [{$I AddinStdmode.INC}] then
    DWMarketItemCountEdt.Text := IntToStr(g_MarketItem.Item.Item.Dura)
  else
    DWMarketItemCountEdt.Text := '1';
  DWMarketWinName.Propertites.Caption.Text := '物品上架';
  DWMarketItem.visible := True;
  DWMarketItemPutOff.Propertites.Caption.Text := '取消';
  DWMarketItemPutOn.Propertites.Caption.Text := '上架';
  DWMarketItemGameGoldEdt.Propertites.TextHint := '<元宝单价>';
  DWMarketItemGoldEdt.Propertites.TextHint := '<金币单价>';
  ShowMarkteItemModal;
end;

procedure TFrmDlg.ShowStallItemUpdate;
begin
  if g_StallItems[MarketItemIndex].Item.Name <> '' then
  begin
    g_MarketItem.Item := g_StallItems[MarketItemIndex];
    g_MarketItem.Inedex := -1;
    DWMarketItemGoldEdt.ReadOnly := False;
    DWMarketItemGameGoldEdt.ReadOnly := False;
    DWMarketItemCountEdt.ReadOnly := True;
    if g_MarketItem.Item.Item.S.StdMode in [{$I AddinStdmode.INC}] then
      DWMarketItemCountEdt.Text := IntToStr(g_MarketItem.Item.Item.Dura)
    else
      DWMarketItemCountEdt.Text := '1';
    DWMarketItemCountEdt.ReadOnly := True;
    DWMarketItemGoldEdt.Text := IIFI(g_MarketItem.Item.Gold);
    DWMarketItemGameGoldEdt.Text := IIFI(g_MarketItem.Item.GameGold);
    StallItemState := ssStallUpdate;
    DWMarketWinName.Propertites.Caption.Text := '物品调整';
    DWMarketItem.visible := True;
    DWMarketItemPutOn.Propertites.Caption.Text := '完成修改';
    DWMarketItemPutOff.Propertites.Caption.Text := '下架';
    DWMarketItemGameGoldEdt.Propertites.TextHint := '<元宝单价>';
    DWMarketItemGoldEdt.Propertites.TextHint := '<金币单价>';
    ShowMarkteItemModal;
  end;
end;

procedure TFrmDlg.ShowStallBuyPutOn;
begin
  StallItemState := ssStallBuyPutOn;
  DWMarketItemGoldEdt.Text := '';
  DWMarketItemGameGoldEdt.Text := '';
  DWMarketItemGoldEdt.ReadOnly := False;
  DWMarketItemGameGoldEdt.ReadOnly := False;
  DWMarketItemCountEdt.Text := '1';
  DWMarketWinName.Propertites.Caption.Text := '物品收购';
  DWMarketItemCountEdt.ReadOnly := False;
  DWMarketItem.visible := True;
  DWMarketItemPutOff.Propertites.Caption.Text := '取消';
  DWMarketItemPutOn.Propertites.Caption.Text := '上架';
  DWMarketItemGameGoldEdt.Propertites.TextHint := '<元宝单价>';
  DWMarketItemGoldEdt.Propertites.TextHint := '<金币单价>';
  ShowMarkteItemModal;
end;

procedure TFrmDlg.ShowStallBuyItemUpdate;
begin
  if g_StallBuyItems[MarketItemIndex].ItemName <> '' then
  begin
    g_MarketItem.Item := g_StallBuyItems[MarketItemIndex].Item;
    g_MarketItem.Inedex := -1;
    DWMarketItemGoldEdt.ReadOnly := False;
    DWMarketItemGameGoldEdt.ReadOnly := False;
    DWMarketItemCountEdt.Text :=
      IntToStr(g_StallBuyItems[MarketItemIndex].Count);
    DWMarketItemCountEdt.ReadOnly := False;
    DWMarketItemGoldEdt.Text := IIFI(g_MarketItem.Item.Gold);
    DWMarketItemGameGoldEdt.Text := IIFI(g_MarketItem.Item.GameGold);
    StallItemState := ssStallBuyUpdate;
    DWMarketWinName.Propertites.Caption.Text := '收购物品调整';
    DWMarketItem.visible := True;
    DWMarketItemPutOn.Propertites.Caption.Text := '完成修改';
    DWMarketItemPutOff.Propertites.Caption.Text := '删除';
    DWMarketItemGameGoldEdt.Propertites.TextHint := '<元宝单价>';
    DWMarketItemGoldEdt.Propertites.TextHint := '<金币单价>';
    ShowMarkteItemModal;
  end;
end;

procedure TFrmDlg.ShowStallItemBuy;
begin
  StallItemState := ssStallBuy;
  if g_MarketItem.Item.Item.S.StdMode in [{$I AddinStdmode.INC}] then
  begin
    DWMarketItemCountEdt.Text := IntToStr(g_MarketItem.Item.Item.Dura);
    DWMarketItemCountEdt.ReadOnly := False;
    DWMarketItemGoldEdt.Text :=
      IIFI(g_MarketItem.Item.Gold * g_MarketItem.Item.Item.Dura);
    DWMarketItemGameGoldEdt.Text :=
      IIFI(g_MarketItem.Item.GameGold * g_MarketItem.Item.Item.Dura);
    DWMarketItemCountEdt.SetFocus;
  end
  else
  begin
    DWMarketItemCountEdt.Text := '1';
    DWMarketItemCountEdt.ReadOnly := True;
    DWMarketItemGoldEdt.Text := IIFI(g_MarketItem.Item.Gold);
    DWMarketItemGameGoldEdt.Text := IIFI(g_MarketItem.Item.GameGold);
  end;
  DWMarketItemGoldEdt.ReadOnly := True;
  DWMarketItemGameGoldEdt.ReadOnly := True;
  DWMarketWinName.Propertites.Caption.Text := '购买物品';
  DWMarketItem.visible := True;
  DWMarketItemPutOff.Propertites.Caption.Text := '取消';
  DWMarketItemPutOn.Propertites.Caption.Text := '购买';
  DWMarketItemGameGoldEdt.Propertites.TextHint := '<元宝合计>';
  DWMarketItemGoldEdt.Propertites.TextHint := '<金币合计>';
  ShowMarkteItemModal;
end;

procedure TFrmDlg.ShowStallSaleToBuy;
var
  ADura: Integer;
begin
  StallItemState := ssStallSaleToBuy;
  if g_MarketItem.Item.Item.S.StdMode in [{$I AddinStdmode.INC}] then
  begin
    ADura := Min(g_MarketItem.Item.Item.Dura, g_MovingItem.Item.Dura);
    DWMarketItemCountEdt.Text := IntToStr(ADura);
    DWMarketItemGoldEdt.Text := IIFI(g_MarketItem.Item.Gold * ADura);
    DWMarketItemGameGoldEdt.Text := IIFI(g_MarketItem.Item.GameGold * ADura);
    DWMarketItemCountEdt.SetFocus;
  end
  else
  begin
    DWMarketItemCountEdt.Text := '1';
    DWMarketItemGoldEdt.Text := IIFI(g_MarketItem.Item.Gold);
    DWMarketItemGameGoldEdt.Text := IIFI(g_MarketItem.Item.GameGold);
  end;
  DWMarketItemCountEdt.ReadOnly := True;
  DWMarketItemGoldEdt.ReadOnly := True;
  DWMarketItemGameGoldEdt.ReadOnly := True;
  DWMarketWinName.Propertites.Caption.Text := '出售物品';
  DWMarketItem.visible := True;
  DWMarketItemPutOff.Propertites.Caption.Text := '取消';
  DWMarketItemPutOn.Propertites.Caption.Text := '出售';
  DWMarketItemGameGoldEdt.Propertites.TextHint := '<元宝合计>';
  DWMarketItemGoldEdt.Propertites.TextHint := '<金币合计>';
  ShowMarkteItemModal;
end;

procedure TFrmDlg.DBMailExtrAttClick(Sender: TObject; X, Y: Integer);
begin
  if g_Mail.Selected <> nil then
  begin
    if GetTickCount - DBMailExtrAtt.TimeTick >= 100 then
    begin
      if (g_Mail.Selected.Item1.Name <> '') or
        (g_Mail.Selected.GoldStr <> '') then
      begin
        if g_Mail.Selected.State < 2 then
        begin
          FrmMain.SendExtrAttMail(g_Mail.Selected.Index);
          DBMailExtrAtt.TimeTick := GetTickCount;
        end
        else
          g_Application.AddMessageDialog('该邮件附件已被提取！', [mbOK]);
      end
      else
        g_Application.AddMessageDialog('该邮件没有可提取的附件！', [mbOK]);
    end;
  end
  else
    g_Application.AddMessageDialog('请选择邮件！', [mbOK]);
end;

procedure TFrmDlg.DBMailReplyClick(Sender: TObject; X, Y: Integer);
begin
  if (g_Mail.Selected <> nil) then
  begin
    if g_Mail.Selected.AFrom <> 'System' then
    begin
      DMailReader.visible := False;
      DMailWriter.Left := DMailList.Left + DMailList.WIDTH;
      DMailWriter.Top := DMailList.Top;
      DMailWriter.visible := True;
      DEMailTo.Text := g_Mail.Selected.AFrom;
      DEMailSubject.SetFocus;
    end
    else
      g_Application.AddMessageDialog('不可以对系统回复邮件！', [mbOK]);
  end
  else
    g_Application.AddMessageDialog('请选择邮件！', [mbOK]);
end;

procedure TFrmDlg.DBMailSendClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DBMailSend.TimeTick >= 1000 then
  begin
    if DEMailTo.Text = '' then
    begin
      g_Application.AddMessageDialog('请输入收件人！', [mbOK],
        procedure(AResult: Integer)begin DEMailTo.SetFocus; end);
      Exit;
    end;
    if Trim(DEMailTo.Text) = 'System' then
    begin
      g_Application.AddMessageDialog('不可以对系统发送邮件！', [mbOK],
        procedure(AResult: Integer)begin DEMailTo.Text := '';
        DEMailTo.SetFocus; end);
      Exit;
    end;
    if Trim(DEMailTo.Text) = g_MySelf.m_sUserName then
    begin
      g_Application.AddMessageDialog('不可以对自己发送邮件！', [mbOK],
        procedure(AResult: Integer)begin DEMailTo.Text := '';
        DEMailTo.SetFocus; end);
      Exit;
    end;
    if DEMailSubject.Text = '' then
    begin
      g_Application.AddMessageDialog('请输入邮件主题！', [mbOK],
        procedure(AResult: Integer)begin DEMailSubject.SetFocus; end);
      Exit;
    end;
    if DMMailEdit.Lines.Text = '' then
    begin
      g_Application.AddMessageDialog('请写入邮件内容！', [mbOK],
        procedure(AResult: Integer)begin DMMailEdit.SetFocus; end);
      Exit;
    end;

    FrmMain.SendNewMail(DEMailTo.Text, DEMailSubject.Text,
      DMMailEdit.Lines.Text, g_MailItem, FSendGoldType,
      StrToIntDef(DESendGold.Text, 0), FBuyAttGoldType,
      StrToIntDef(DEBuyAttPrice.Text, 0));
    DEMailTo.Text := '';
    DEMailSubject.Text := '';
    DMMailEdit.Lines.Clear;
    DBMailSend.TimeTick := GetTickCount;
    g_MailItem.Name := '';
  end;
end;

procedure TFrmDlg.DBMailToUsersClick(Sender: TObject; X, Y: Integer);
var
  I: Integer;
begin
  if DXPopupMenu.PopVisible then
    DXPopupMenu.HidePopup
  else
  begin
    DXPopupMenu.BeginUpdate;
    DXPopupMenu.Clear;
    for I := 0 to g_Friends.Count - 1 do
      DXPopupMenu.AddMenuItem(I, pTFriendRecord(g_Friends[I]).Name);
    DXPopupMenu.EndUpdate;
    DXPopupMenu.Popup(DMailWriter, DEMailTo.Left,
      DEMailTo.Top + DEMailTo.Height, DEMailSubject.WIDTH,
      procedure(ATag: Integer; const ACaption: String)begin DEMailTo.Text :=
      ACaption; DEMailTo.SetFocus; end);
  end;
end;

procedure TFrmDlg.DBMateriaClick(Sender: TObject; X, Y: Integer);
var
  temp: TClientItem;
  Butt: TDButton;
begin
  if DStartMakeWine.ShowHint then
    Exit;
  Butt := TDButton(Sender);
  if not g_boItemMoving then
  begin
    if g_WineItem[Butt.Tag].Name <> '' then
    begin
      g_SoundManager.ItemClickSound(g_WineItem[Butt.Tag].S);
      if g_MovingItem.Item.Name <> '' then
        Exit;
      g_boItemMoving := True;
      g_MovingItem.FromIndex := Butt.Tag;
      g_MovingItem.Source := msWineMateria;
      g_MovingItem.Item := g_WineItem[Butt.Tag];
      g_WineItem[Butt.Tag].Name := '';
    end;
  end
  else
  begin
    if g_MovingItem.Source in [msGold, msDealGold, msSellItem] then
      Exit;
    if (g_MovingItem.FromIndex = -45) or (g_MovingItem.FromIndex = -46) then
      Exit; // -45 .. -46 是请酒里的烧酒物品
    // TODO
    if (g_MovingItem.FromIndex >= 0) or (g_MovingItem.FromIndex = -47) or
      (g_MovingItem.FromIndex = -48) or (g_MovingItem.FromIndex = -49) or
      (g_MovingItem.FromIndex = -50) or (g_MovingItem.FromIndex = -51) or
      (g_MovingItem.FromIndex = -52) or (g_MovingItem.FromIndex = -53) then
    begin
      case Butt.Tag of
        0:
          if g_MovingItem.Item.S.StdMode <> 8 then
            Exit;
        1:
          if g_MovingItem.Item.S.StdMode <> 13 then
            Exit;
        2:
          if g_MovingItem.Item.S.StdMode <> 9 then
            Exit;
        3:
          if g_MovingItem.Item.S.StdMode <> 12 then
            Exit;
        4:
          if g_MovingItem.Item.S.StdMode <> 8 then
            Exit;
        5:
          if g_MovingItem.Item.S.StdMode <> 8 then
            Exit;
        6:
          if g_MovingItem.Item.S.StdMode <> 8 then
            Exit;
      end;
      g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
      if g_WineItem[Butt.Tag].Name <> '' then
      begin // 磊府俊 乐栏搁
        temp := g_WineItem[Butt.Tag];
        g_WineItem[Butt.Tag] := g_MovingItem.Item;
        g_MovingItem.FromIndex := -(Butt.Tag + 47);
        g_MovingItem.Source := msWineMateria;
        g_MovingItem.Item := temp
      end
      else
      begin
        g_WineItem[Butt.Tag] := g_MovingItem.Item;
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
      end;
    end;
  end;
end;

procedure TFrmDlg.DBMateriaDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  Idx: Integer;
  Butt: TDButton;
begin
  // if Sender = DBMateria then
  // begin
  // Butt := TDButton(Sender);
  // with Butt do
  // begin
  // if g_WineItem[Butt.Tag].Name <> '' then
  // begin
  // Idx := g_WineItem[Butt.Tag].Looks;
  // if Idx >= 0 then
  // begin
  // if Idx > 9999 then
  // D := g_77WBagItemImages.Images[Idx - 10000]
  // else
  // D := g_WBagItemImages.Images[Idx];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + (WIDTH - D.WIDTH) div 2), SurfaceY(Top + (Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin
  // if (g_MovingItem.Item.S.StdMode = 8) and g_boItemMoving then
  // begin
  // D := FrmMain.UiDXImageList.Items.Find('MakeWineSel').PatternSurfaces[0];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
  // end;
  // end;
  // if Sender = DBWineSong then
  // begin
  // Butt := TDButton(Sender);
  // with Butt do
  // begin
  // if g_WineItem[Butt.Tag].Name <> '' then
  // begin
  // Idx := g_WineItem[Butt.Tag].Looks;
  // if Idx >= 0 then
  // begin
  // if Idx > 9999 then
  // D := g_77WBagItemImages.Images[Idx - 10000]
  // else
  // D := g_WBagItemImages.Images[Idx];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + (WIDTH - D.WIDTH) div 2), SurfaceY(Top + (Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin
  // if (g_MovingItem.Item.S.StdMode = 13) and g_boItemMoving then
  // begin
  // D := FrmMain.UiDXImageList.Items.Find('MakeWineSel').PatternSurfaces[0];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
  // end;
  // end;
  // if Sender = DBWater then
  // begin
  // Butt := TDButton(Sender);
  // with Butt do
  // begin
  // if g_WineItem[Butt.Tag].Name <> '' then
  // begin
  // Idx := g_WineItem[Butt.Tag].Looks;
  // if Idx >= 0 then
  // begin
  // if Idx > 9999 then
  // D := g_77WBagItemImages.Images[Idx - 10000]
  // else
  // D := g_WBagItemImages.Images[Idx];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + (WIDTH - D.WIDTH) div 2), SurfaceY(Top + (Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin
  // if (g_MovingItem.Item.S.StdMode = 9) and g_boItemMoving then
  // begin
  // D := FrmMain.UiDXImageList.Items.Find('MakeWineSel').PatternSurfaces[0];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
  // end;
  // end;
  // if Sender = DBWineCrock then
  // begin
  // Butt := TDButton(Sender);
  // with Butt do
  // begin
  // if g_WineItem[Butt.Tag].Name <> '' then
  // begin
  // Idx := g_WineItem[Butt.Tag].Looks;
  // if Idx >= 0 then
  // begin
  // if Idx > 9999 then
  // D := g_77WBagItemImages.Images[Idx - 10000]
  // else
  // D := g_WBagItemImages.Images[Idx];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + (WIDTH - D.WIDTH) div 2), SurfaceY(Top + (Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin
  // if (g_MovingItem.Item.S.StdMode = 12) and g_boItemMoving then
  // begin
  // D := FrmMain.UiDXImageList.Items.Find('MakeWineSel').PatternSurfaces[0];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
  // end;
  // end;
  // if Sender = DBAssistMaterial1 then
  // begin
  // Butt := TDButton(Sender);
  // with Butt do
  // begin
  // if g_WineItem[Butt.Tag].Name <> '' then
  // begin
  // Idx := g_WineItem[Butt.Tag].Looks;
  // if Idx >= 0 then
  // begin
  // if Idx > 9999 then
  // D := g_77WBagItemImages.Images[Idx - 10000]
  // else
  // D := g_WBagItemImages.Images[Idx];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + (WIDTH - D.WIDTH) div 2), SurfaceY(Top + (Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin
  // if (g_MovingItem.Item.S.StdMode = 8) and g_boItemMoving then
  // begin
  // D := FrmMain.UiDXImageList.Items.Find('MakeWineSel').PatternSurfaces[0];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
  // end;
  // end;
  // if Sender = DBAssistMaterial2 then
  // begin
  // Butt := TDButton(Sender);
  // with Butt do
  // begin
  // if g_WineItem[Butt.Tag].Name <> '' then
  // begin
  // Idx := g_WineItem[Butt.Tag].Looks;
  // if Idx >= 0 then
  // begin
  // if Idx > 9999 then
  // D := g_77WBagItemImages.Images[Idx - 10000]
  // else
  // D := g_WBagItemImages.Images[Idx];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + (WIDTH - D.WIDTH) div 2), SurfaceY(Top + (Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin
  // if (g_MovingItem.Item.S.StdMode = 8) and g_boItemMoving then
  // begin
  // D := FrmMain.UiDXImageList.Items.Find('MakeWineSel').PatternSurfaces[0];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
  // end;
  // end;
  // if Sender = DBAssistMaterial3 then
  // begin
  // Butt := TDButton(Sender);
  // with Butt do
  // begin
  // if g_WineItem[Butt.Tag].Name <> '' then
  // begin
  // Idx := g_WineItem[Butt.Tag].Looks;
  // if Idx >= 0 then
  // begin
  // if Idx > 9999 then
  // D := g_77WBagItemImages.Images[Idx - 10000]
  // else
  // D := g_WBagItemImages.Images[Idx];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + (WIDTH - D.WIDTH) div 2), SurfaceY(Top + (Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin
  // if (g_MovingItem.Item.S.StdMode = 8) and g_boItemMoving then
  // begin
  // D := FrmMain.UiDXImageList.Items.Find('MakeWineSel').PatternSurfaces[0];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
  // end;
  // end;
end;

procedure TFrmDlg.DBDrugDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  Idx: Integer;
  Butt: TDButton;
begin
  // if Sender = DBDrug then
  // begin
  // Butt := TDButton(Sender);
  // with Butt do
  // begin
  // if g_DrugWineItem[Butt.Tag].Name <> '' then
  // begin
  // Idx := g_DrugWineItem[Butt.Tag].Looks;
  // if Idx >= 0 then
  // begin
  // if Idx > 9999 then
  // D := g_77WBagItemImages.Images[Idx - 10000]
  // else
  // D := g_WBagItemImages.Images[Idx];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + (WIDTH - D.WIDTH) div 2), SurfaceY(Top + (Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin
  // if (g_MovingItem.Item.S.StdMode = 14) and g_boItemMoving then
  // begin
  // D := FrmMain.UiDXImageList.Items.Find('MakeWineSel').PatternSurfaces[0];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
  // end;
  // end;
  // if Sender = DBWine then
  // begin
  // Butt := TDButton(Sender);
  // with Butt do
  // begin
  // if g_DrugWineItem[Butt.Tag].Name <> '' then
  // begin
  // Idx := g_DrugWineItem[Butt.Tag].Looks;
  // if Idx >= 0 then
  // begin
  // if Idx > 9999 then
  // D := g_77WBagItemImages.Images[Idx - 10000]
  // else
  // D := g_WBagItemImages.Images[Idx];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + (WIDTH - D.WIDTH) div 2), SurfaceY(Top + (Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin
  // if (g_MovingItem.Item.S.StdMode = 60) and g_boItemMoving then
  // begin
  // D := FrmMain.UiDXImageList.Items.Find('MakeWineSel').PatternSurfaces[0];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
  // end;
  // end;
  // if Sender = DBWineBottle then
  // begin
  // Butt := TDButton(Sender);
  // with Butt do
  // begin
  // if g_DrugWineItem[Butt.Tag].Name <> '' then
  // begin
  // Idx := g_DrugWineItem[Butt.Tag].Looks;
  // if Idx >= 0 then
  // begin
  // if Idx > 9999 then
  // D := g_77WBagItemImages.Images[Idx - 10000]
  // else
  // D := g_WBagItemImages.Images[Idx];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left + (WIDTH - D.WIDTH) div 2), SurfaceY(Top + (Height - D.Height) div 2), D.ClientRect, D, True);
  // end;
  // end
  // else
  // begin
  // if (g_MovingItem.Item.S.StdMode = 12) and g_boItemMoving then
  // begin
  // D := FrmMain.UiDXImageList.Items.Find('MakeWineSel').PatternSurfaces[0];
  // if D <> nil then
  // DrawBlendEx(dsurface, SurfaceX(Left), SurfaceY(Top), D, 0, 0, D.WIDTH, D.Height, 0);
  // end;
  // end;
  // end;
  // end;
end;

procedure TFrmDlg.DBDelAllMailClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DBDelAllMail.TimeTick >= 100 then
  begin
    g_Application.AddMessageDialog('确定删除全部邮件吗？', [mbOK, mbCancel],
      procedure(AResult: Integer)begin if AResult = mrOK then begin FrmMain.
      SendDelAllMail; DBDelAllMail.TimeTick := GetTickCount; g_Mail.Clear;
      ClearMailReader; end; end);
  end;
end;

procedure TFrmDlg.DBDelMailClick(Sender: TObject; X, Y: Integer);
var
  AMainIndex: Integer;
begin
  if g_Mail.Selected <> nil then
  begin
    if GetTickCount - DBDelMail.TimeTick >= 100 then
    begin
      if (g_Mail.Selected.State < 2) and (g_Mail.Selected.Item1.Name <> '') then
      begin
        AMainIndex := g_Mail.Selected.Index;
        g_Application.AddMessageDialog('该邮件有附件没被提取，确定删除吗？', [mbOK, mbCancel],
          procedure(AResult: Integer)begin if AResult = mrOK then begin FrmMain.
          SendDelMail(AMainIndex); DBDelMail.TimeTick := GetTickCount;
          ClearMailReader; end; end);
      end
      else
      begin
        FrmMain.SendDelMail(g_Mail.Selected.Index);
        DBDelMail.TimeTick := GetTickCount;
        ClearMailReader;
      end;
    end;
  end
  else
    g_Application.AddMessageDialog('请选择邮件！', [mbOK]);
end;

procedure TFrmDlg.DBDrugClick(Sender: TObject; X, Y: Integer);
var
  temp: TClientItem;
  Butt: TDButton;
begin
  if DStartMakeWine.ShowHint then
    Exit;
  Butt := TDButton(Sender);
  if not g_boItemMoving then
  begin
    if g_DrugWineItem[Butt.Tag].Name <> '' then
    begin
      g_SoundManager.ItemClickSound(g_DrugWineItem[Butt.Tag].S);
      if g_MovingItem.Item.Name <> '' then
        Exit;
      g_boItemMoving := True;
      g_MovingItem.FromIndex := -(Butt.Tag + 54);
      g_MovingItem.Item := g_DrugWineItem[Butt.Tag];
      g_MovingItem.Source := msWineDrug;
      g_DrugWineItem[Butt.Tag].Name := '';
    end;
  end
  else
  begin
    if g_MovingItem.Source in [msGold, msDealGold, msSellItem] then
      Exit;
    if (g_MovingItem.FromIndex = -45) or (g_MovingItem.FromIndex = -46) then
      Exit; // -45 .. -46 是请酒里的烧酒物品
    if (g_MovingItem.FromIndex = -47) or (g_MovingItem.FromIndex = -48) or
      (g_MovingItem.FromIndex = -49) or (g_MovingItem.FromIndex = -50) or
      (g_MovingItem.FromIndex = -51) or (g_MovingItem.FromIndex = -52) or
      (g_MovingItem.FromIndex = -53) then
      Exit; // 普通酒物品
    if (g_MovingItem.FromIndex >= 0) or (g_MovingItem.FromIndex = -54) or
      (g_MovingItem.FromIndex = -55) or (g_MovingItem.FromIndex = -56) then
    begin
      case Butt.Tag of
        0:
          if g_MovingItem.Item.S.StdMode <> 14 then
            Exit;
        1:
          if g_MovingItem.Item.S.StdMode <> 60 then
            Exit;
        2:
          if g_MovingItem.Item.S.StdMode <> 12 then
            Exit;
      end;
      g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
      if g_DrugWineItem[Butt.Tag].Name <> '' then
      begin // 磊府俊 乐栏搁
        temp := g_DrugWineItem[Butt.Tag];
        g_DrugWineItem[Butt.Tag] := g_MovingItem.Item;
        g_MovingItem.FromIndex := -(Butt.Tag + 54);
        g_MovingItem.Source := msWineDrug;
        g_MovingItem.Item := temp
      end
      else
      begin
        g_DrugWineItem[Butt.Tag] := g_MovingItem.Item;
        g_MovingItem.Item.Name := '';
        g_boItemMoving := False;
      end;
    end;
  end;
end;

procedure TFrmDlg.DStallCtrlClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DStallCtrl.TimeTick > 200 then
  begin
    DStallCtrl.TimeTick := GetTickCount;
    FrmMain.SendShortCut(_SC_OpenStall);
  end;
end;

procedure TFrmDlg.DStartMakeWineClick(Sender: TObject; X, Y: Integer);
begin
  if g_boItemMoving then
    Exit;
  if DStartMakeWine.ShowHint then
    Exit;
  if g_MakeTypeWine = 0 then
  begin // 普通酒
    if (g_WineItem[0].Name = '') or (g_WineItem[2].Name = '') or
      (g_WineItem[3].Name = '') or (g_WineItem[4].Name = '') or
      (g_WineItem[5].Name = '') or (g_WineItem[6].Name = '') then
      Exit;
  end
  else
  begin // 药酒
    if (g_DrugWineItem[0].Name = '') or (g_DrugWineItem[1].Name = '') or
      (g_DrugWineItem[2].Name = '') then
      Exit;
  end;
  if DMakeWineHelp.ShowHint then
  begin
    DMakeWineHelp.ShowHint := False;
    ShowMakeWine(False); // 显示下面BUTTON
  end;
  DStartMakeWine.ShowHint := True;
  g_nShowStartMakeWineImg := 0;
end;

procedure TFrmDlg.DBDrugMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Butt: TDButton;
begin
  Butt := TDButton(Sender);
  DScreen.ShowHint(Butt.SurfaceX(Butt.Left), Butt.SurfaceY(Butt.Top - 18),
    Butt.Hint, clWhite, False);
  g_MouseItem := g_DrugWineItem[Butt.Tag];
end;

procedure TFrmDlg.DHeroLiquorProgressDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
end;

{ var
  d: TAsphyreLockableTexture;
  begin
  with Sender as TDCheckBox do begin
  if not TDCheckBox(Sender).Checked then begin
  d := Propertites.Images.Images[Propertites.ImageIndex];
  if d <> nil then
  dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
  end else begin
  d := Propertites.Images.Images[Propertites.ImageIndex + 1];
  if d <> nil then
  dsurface.Draw (SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
  end;
  end; }
procedure TFrmDlg.DCheckSdoNameShowDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
begin
  with Sender as TDCheckBox do
  begin
    if not TDCheckBox(Sender).Checked then
    begin
      D := g_77Images.Images[238];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end
    else
    begin
      D := g_77Images.Images[239];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;
    if TDCheckBox(Sender).Moveed then
      Color := clWhite
    else
      Color := clSilver;
    ATexture := FontManager.Default.TextOut(TDCheckBox(Sender).Hint);
    if ATexture <> nil then
      dsurface.DrawBoldText(SurfaceX(Left + D.WIDTH + 2), SurfaceY(Top) + 3,
        ATexture, Color, FontBorderColor);
  end;
end;

procedure TFrmDlg.DNewSdoBasicDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with Sender as TDButton do
  begin
    if TDButton(Sender).Tag <> g_btSdoAssistantPage then
    begin
      if Propertites.Images <> nil then
      begin
        D := Propertites.Images.Images[Propertites.ImageIndex];
        if D <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      end;
    end
    else
    begin
      if Propertites.Images <> nil then
      begin
        D := Propertites.Images.Images[Propertites.ImageIndex + 1];
        if D <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top) - 2,
            D.ClientRect, D, True);
      end;
    end;
    dsurface.BoldText(SurfaceX(Left) + 24 - FontManager.
      Default.TextWidth(TDButton(Sender).Hint) div 2, SurfaceY(Top) + 2,
      TDButton(Sender).Hint, clWhite, clBlack);
  end;
end;

procedure TFrmDlg.DNoticeOKClick(Sender: TObject; X, Y: Integer);
begin
  DLoginNotice.Visible := False;
  ClMain.frmMain.SendClientMessage(CM_LOGINNOTICEOK, 0, 0, 0, 0);
  ReleaseDFocus;
end;

procedure TFrmDlg.DWMarketItemCloseClick(Sender: TObject; X, Y: Integer);
begin
  DWMarketItem.visible := False;
end;

procedure TFrmDlg.DWMarketItemCountEdtChange(Sender: TObject);
var
  ACount: Integer;
begin
  if g_MarketItem.Item.Item.S.StdMode in [{$I AddinStdmode.INC}] then
  begin
    ACount := StrToIntDef(DWMarketItemCountEdt.Text, 0);
    case StallItemState of
      ssMarketBuy, ssStallBuy:
        begin
          if ACount > g_MarketItem.Item.Item.Dura then
            ACount := g_MarketItem.Item.Item.Dura;
        end;
      ssStallSaleToBuy:
        begin

        end;
    end;
    DWMarketItemCountEdt.Text := IntToStr(ACount);
    DWMarketItemCountEdt.ReadOnly := False;
    if not(StallItemState in [ssStallBuyPutOn, ssStallBuyUpdate]) then
    begin
      DWMarketItemGoldEdt.Text := IIFI(g_MarketItem.Item.Gold * ACount);
      DWMarketItemGameGoldEdt.Text := IIFI(g_MarketItem.Item.GameGold * ACount);
    end;
  end;
end;

procedure TFrmDlg.DWMarketItemDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  T: TAsphyreLockableTexture;
  NameT: TuTexture;
  S: String;
  AShowCommission: Boolean;
begin
  AShowCommission := (StallItemState = ssStallSaleToBuy) and
    (((g_StallGoldCommission > 0) and (g_StallGoldCommission <= 1000)) or
    ((g_StallGameGoldCommission > 0) and (g_StallGameGoldCommission <= 1000)));


  with DWMarketItem do
  begin
    DefaultPaint(dsurface);

    if AShowCommission then
    begin
      DTCommission.Visible := True;
      S := '佣金:';
      if g_StallGoldCommission > 0 then
        S := S + ' 金币' + IntToStr(g_StallGoldCommission) + '‰';
      if g_StallGameGoldCommission > 0 then
        S := S + ' 元宝' + IntToStr(g_StallGameGoldCommission) + '‰';
      S := '(' + S + ')';
      DTCommission.Propertites.Caption.Text := S;

      {
      T := FontManager.Default.TextOut(S);
      if T <> nil then
        dsurface.DrawBoldText(SurfaceX(Left) + (WIDTH - T.WIDTH) div 2,
          SurfaceY(Top) + 116, T, clYellow, FontBorderColor); }
    end else
    begin
      DTCommission.Visible := False;
    end;
  end;

end;

procedure TFrmDlg.DWMarketItemItemDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  with DWMarketItemItem do
  begin
    if g_MarketItem.Item.Item.Name <> '' then
      DrawItem(g_MarketItem.Item.Item, dsurface, SurfaceX(Left), SurfaceY(Top),
        48, 48, TimeTick);
  end;
end;

procedure TFrmDlg.DWMarketItemItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if g_MarketItem.Item.Item.Name <> '' then
  begin
    if (g_MarketItem.Item.Item.MakeIndex = g_MouseItem.MakeIndex) and
      DScreen.ItemHint then
      DScreen.UpdateItemHintPostion(g_Application._CurPos)
    else
    begin
      g_MouseItem := g_MarketItem.Item.Item;
      DScreen.ShowItemHint(g_Application._CurPos, g_MouseItem, fkNormal);
    end;
  end
  else
  begin
    g_MouseItem.Name := '';
    DScreen.ClearHint;
  end;
end;

procedure TFrmDlg.DWMarketItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DWMarketItemPutOffClick(Sender: TObject; X, Y: Integer);
begin
  case StallItemState of
    ssMarketUpdate:
      FrmMain.SendMarketPutOff(g_MarketItem.Item.Item.MakeIndex);
    ssStallUpdate:
      FrmMain.SendStallPutOff(g_MarketItem.Item.Item.MakeIndex);
    ssStallBuyUpdate:
      FrmMain.SendStallBuyPutOff(g_MarketItem.Item.Index,
        g_MarketItem.Item.Item.Name);
  end;
  DWMarketItem.visible := False;
end;

procedure TFrmDlg.DWMarketItemPutOnClick(Sender: TObject; X, Y: Integer);
begin
  case StallItemState of
    ssMarketBuy:
      begin
        if StrToIntDef(DWMarketItemCountEdt.Text, 0) <= 0 then
          g_Application.AddMessageDialog('购买数量必须大于0', [mbOK])
        else
        begin
          FrmMain.SendMarketBuy(g_SelMarketPlay,
            g_MarketItem.Item.Item.MakeIndex,
            StrToIntDef(DWMarketItemCountEdt.Text, 0));
          g_boStallLock := True;
          DWMarketItem.visible := False;
        end;
      end;
    ssMarketUpdate:
      begin
        if (StrToIntDef(DWMarketItemGoldEdt.Text, 0) <= 0) and
          (StrToIntDef(DWMarketItemGameGoldEdt.Text, 0) <= 0) then
        begin
          g_Application.AddMessageDialog('请输入该物品的金币或元宝单价', [mbOK]);
        end
        else
        begin
          g_boStallLock := True;
          FrmMain.SendMarketUpdate(g_MarketItem.Item.Item.MakeIndex,
            StrToIntDef(DWMarketItemGoldEdt.Text, 0),
            StrToIntDef(DWMarketItemGameGoldEdt.Text, 0));
          DWMarketItem.visible := False;
        end;
      end;
    ssMarketPutOn:
      begin
        if (StrToIntDef(DWMarketItemGoldEdt.Text, 0) <= 0) and
          (StrToIntDef(DWMarketItemGameGoldEdt.Text, 0) <= 0) then
          g_Application.AddMessageDialog('请输入该物品的金币或元宝单价', [mbOK])
        else if StrToIntDef(DWMarketItemCountEdt.Text, 0) <= 0 then
          g_Application.AddMessageDialog('上架数量必须大于0', [mbOK])
        else
        begin
          FrmMain.SendMarketPutOn(g_MarketItem.Item.Item.MakeIndex,
            StrToIntDef(DWMarketItemGoldEdt.Text, 0),
            StrToIntDef(DWMarketItemGameGoldEdt.Text, 0));
          g_boStallLock := True;
          DWMarketItem.visible := False;
        end;
      end;
    // 地摊
    ssStallBuy:
      begin
        FrmMain.SendStallBuy(g_SelMarketPlay, g_MarketItem.Item.Item.MakeIndex,
          StrToIntDef(DWMarketItemCountEdt.Text, 0));
        g_boStallLock := True;
        DWMarketItem.visible := False;
      end;
    ssStallPutOn:
      begin
        if (StrToIntDef(DWMarketItemGoldEdt.Text, 0) <= 0) and
          (StrToIntDef(DWMarketItemGameGoldEdt.Text, 0) <= 0) then
          g_Application.AddMessageDialog('请输入该物品的金币或元宝单价', [mbOK])
        else if StrToIntDef(DWMarketItemCountEdt.Text, 0) <= 0 then
          g_Application.AddMessageDialog('上架数量必须大于0', [mbOK])
        else
        begin
          FrmMain.SendStallPutOn(g_MarketItem.Item.Item.MakeIndex,
            StrToIntDef(DWMarketItemGoldEdt.Text, 0),
            StrToIntDef(DWMarketItemGameGoldEdt.Text, 0));
          g_boStallLock := True;
          DWMarketItem.visible := False;
        end;
      end;
    ssStallUpdate:
      begin
        if (StrToIntDef(DWMarketItemGoldEdt.Text, 0) <= 0) and
          (StrToIntDef(DWMarketItemGameGoldEdt.Text, 0) <= 0) then
        begin
          g_Application.AddMessageDialog('请输入该物品的金币或元宝单价', [mbOK]);
        end
        else
        begin
          g_boStallLock := True;
          FrmMain.SendStallUpdate(g_MarketItem.Item.Item.MakeIndex,
            StrToIntDef(DWMarketItemGoldEdt.Text, 0),
            StrToIntDef(DWMarketItemGameGoldEdt.Text, 0));
          DWMarketItem.visible := False;
        end;
      end;
    ssStallBuyPutOn:
      begin
        if (StrToIntDef(DWMarketItemGoldEdt.Text, 0) <= 0) and
          (StrToIntDef(DWMarketItemGameGoldEdt.Text, 0) <= 0) then
          g_Application.AddMessageDialog('请输入收购该物品的金币或元宝单价', [mbOK])
        else if StrToIntDef(DWMarketItemCountEdt.Text, 0) <= 0 then
          g_Application.AddMessageDialog('收购数量必须大于0', [mbOK])
        else
        begin
          FrmMain.SendStallBuyPutOn(StrToIntDef(DWMarketItemGoldEdt.Text, 0),
            StrToIntDef(DWMarketItemGameGoldEdt.Text, 0),
            StrToIntDef(DWMarketItemCountEdt.Text, 0),
            g_MarketItem.Item.Item.Name);
          g_boStallLock := True;
          DWMarketItem.visible := False;
        end;
      end;
    ssStallBuyUpdate:
      begin
        if (StrToIntDef(DWMarketItemGoldEdt.Text, 0) <= 0) and
          (StrToIntDef(DWMarketItemGameGoldEdt.Text, 0) <= 0) then
          g_Application.AddMessageDialog('请输入收购该物品的金币或元宝单价', [mbOK])
        else if StrToIntDef(DWMarketItemCountEdt.Text, 0) <= 0 then
          g_Application.AddMessageDialog('收购数量必须大于0', [mbOK])
        else
        begin
          g_boStallLock := True;
          FrmMain.SendStallBuyUpdate(g_MarketItem.Item.Index,
            StrToIntDef(DWMarketItemCountEdt.Text, 0),
            StrToIntDef(DWMarketItemGoldEdt.Text, 0),
            StrToIntDef(DWMarketItemGameGoldEdt.Text, 0),
            g_MarketItem.Item.Item.Name);
          DWMarketItem.visible := False;
        end;
      end;
    ssStallSaleToBuy:
      begin
        if StrToIntDef(DWMarketItemCountEdt.Text, 0) <= 0 then
          g_Application.AddMessageDialog('出售数量必须大于0', [mbOK])
        else
        begin
          FrmMain.SendStallSaleToBuy(g_MarketItem.Item.Item.MakeIndex,
            MarketItemIndex, g_SelMarketPlay);
          g_boStallLock := True;
          DWMarketItem.visible := False;
        end;
      end;
  end;
end;

procedure TFrmDlg.DWBuyItemCountAddMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IncBuyItemCount(1);
  FScrollType := _ST_BUYITEM;
  ScrollTimer.Tag := 1;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DWBuyItemCountAddMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DWBuyItemCountCancelClick(Sender: TObject; X, Y: Integer);
begin
  DWBuyItemCount.visible := False;
end;

procedure TFrmDlg.DWBuyItemCountDecMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IncBuyItemCount(-1);
  FScrollType := _ST_BUYITEM;
  ScrollTimer.Tag := 2;
  ScrollTimer.Enabled := True;
end;

procedure TFrmDlg.DWBuyItemCountDecMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DWBuyItemCountDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  ATexture: TAsphyreLockableTexture;
  NameT: TuTexture;
begin
  with DWBuyItemCount do
  begin
    D := Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    NameT := Textures.ObjectName(dsurface, Caption);
    if NameT <> nil then
      NameT.Draw(dsurface, SurfaceX(Left) + 20, SurfaceY(Top) + 44, clWhite);
    ATexture := FontManager.
      Default.TextOut(IntToStr(StrToIntDef(DWBuyItemCountEdt.Text,
      0) * FBuyPrice));
    if ATexture <> nil then
      dsurface.DrawBoldText(SurfaceX(Left) + 52, SurfaceY(Top) + 94, ATexture,
        clWhite, FontBorderColor);
  end;
end;

procedure TFrmDlg.DWBuyItemCountEdtChange(Sender: TObject);
var
  c: Integer;
begin
  c := StrToIntDef(DWBuyItemCountEdt.Text, 0);
  c := Max(1, c);
  if c > FBuyMaxCount then
    c := FBuyMaxCount;
  DWBuyItemCountEdt.Text := IntToStr(c);
end;

procedure TFrmDlg.DWBuyItemCountMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DWBuyItemCountOKClick(Sender: TObject; X, Y: Integer);
var
  ACount: Integer;
begin
  ACount := StrToIntDef(DWBuyItemCountEdt.Text, 0);
  if (ACount > 0) and (FBuyMaxCount <= FBuyMaxCount) then
  begin
    FrmMain.SendBuyItem(g_nCurMerchant, FBuyIndex, ACount, FBuyItemName);
    DWBuyItemCount.visible := False;
  end
  else
    g_Application.AddMessageDialog('单次购买数量过多！', [mbOK]);
end;

procedure TFrmDlg.DWChallengeDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  // with DWChallenge do
  // begin
  // if Propertites.Images <> nil then
  // begin // 20080701
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // with dsurface.Canvas do
  // begin
  // clFunc.TextOut(dsurface, Left + 30, Top + 137, clYellow, FrmMain.CharName);
  // clFunc.TextOut(dsurface, Left + 30, Top + 36, clYellow, g_sChallengeWho);
  // clFunc.TextOut(dsurface, Left + 80, Top + 202, clLime, IntToStr(g_nChallengeGold));
  // clFunc.TextOut(dsurface, Left + 80, Top + 101, clLime, IntToStr(g_nChallengeRemoteGold));
  // clFunc.TextOut(dsurface, Left + 196 - FrmMain.Canvas.TextWidth(IntToStr(g_nChallengeDiamond)) div 2, Top + 176, clLime, IntToStr(g_nChallengeDiamond));
  // clFunc.TextOut(dsurface, Left + 196 - FrmMain.Canvas.TextWidth(IntToStr(g_nChallengeRemoteDiamond)) div 2, Top + 75, clLime,
  // IntToStr(g_nChallengeRemoteDiamond));
  // clFunc.TextOut(dsurface, Left + 179, Top + 163, clWhite, g_sGameDiaMond);
  // clFunc.TextOut(dsurface, Left + 179, Top + 62, clWhite, g_sGameDiaMond);
  // clFunc.TextOut(dsurface, Left + 52, Top + 270, clWhite, '挑战中将已武馆教头的挑战规');
  // clFunc.TextOut(dsurface, Left + 28, Top + 284, clWhite, '则做为评判胜负的标准，如果你同');
  // clFunc.TextOut(dsurface, Left + 28, Top + 298, clWhite, '意就请开始挑战吧。');
  // Release;
  // end;
  // end;
end;

procedure TFrmDlg.DChallengeGridGridMouseMove(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  Idx: Integer;
begin
  Idx := ACol + ARow * DChallengeGrid.ColCount;
  if Idx in [0 .. 3] then
  begin
    g_MouseItem := g_ChallengeItems[Idx];
  end;
end;

procedure TFrmDlg.DChallengeGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
var
  Idx: Integer;
  D: TAsphyreLockableTexture;
begin
  Idx := ACol + ARow * DChallengeGrid.ColCount;
  if Idx in [0 .. 3] then
  begin
    if g_ChallengeItems[Idx].Name <> '' then
    begin
      if g_ChallengeItems[Idx].Looks > 9999 then
        D := g_77WBagItemImages.Images[g_ChallengeItems[Idx].Looks - 10000]
      else
        D := g_WBagItemImages.Images[g_ChallengeItems[Idx].Looks];
      if D <> nil then
        with DChallengeGrid do
          dsurface.Draw(SurfaceX(Rect.Left + (ColWidth - D.WIDTH) div 2 - 1),
            SurfaceY(Rect.Top + (RowHeight - D.Height) div 2 + 1),
            D.ClientRect, D, True);
    end;
  end;
end;

procedure TFrmDlg.DChallengeGridGridSelect(Sender: TObject; ACol, ARow: Integer;
  Shift: TShiftState);
var
  mi, Idx: Integer;
  Int: Byte;
  ASource: TMoveItemSource;
begin
  if not g_boChallengeEnd and (GetTickCount > g_dwChallengeActionTick) then
  begin
    if not g_boItemMoving then
    begin
      Idx := ACol + ARow * DChallengeGrid.ColCount;
      if Idx in [0 .. 3] then
      begin
        if g_ChallengeItems[Idx].Name <> '' then
        begin
          g_boItemMoving := True;
          g_MovingItem.FromIndex := -Idx - 57;
          g_MovingItem.Source := msChallenge;
          g_MovingItem.Item := g_ChallengeItems[Idx];
          g_ChallengeItems[Idx].Name := '';
          g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
        end;
      end
      else
      begin
        if Idx = 4 then
        begin
          Int := 0;
          g_Application.AddMessageDialog('请输入' + g_sGameDiaMond +
            '数量，在0-9999之间', [mbOK, mbAbort], procedure(AResult: Integer)var I
            : Integer;
          begin if AResult = mrOK then begin if DlgEditText = '' then Int := 1;
            for I := 1 to Length(DlgEditText) do if (DlgEditText[I] < '0') or
            (DlgEditText[I] > '9') then Int := 2;
            if Length(DlgEditText) > 4 then Int := 3;
            case Int of 0: begin if (strtoint(DlgEditText) > 0) and
            (strtoint(DlgEditText) < 10000)
          then begin FrmMain.SendChangeChallengeDiamond(strtoint(DlgEditText));
          end; end; 1: g_Application.AddMessageDialog('内容不能为空！', [mbOK]);
            2: g_Application.AddMessageDialog('输入的' + g_sGameDiaMond + '错误',
            [mbOK]); 3: g_Application.AddMessageDialog(g_sGameDiaMond +
            '数量不能超过4位', [mbOK]); end; end; end);
        end;
      end;
    end
    else
    begin
      mi := g_MovingItem.FromIndex;
      ASource := g_MovingItem.Source;
      if (mi >= 0) or (mi <= -57) and (mi > -63) then
      begin // 啊规,俊辑 柯巴父
        g_SoundManager.ItemClickSound(g_MovingItem.Item.S);
        g_boItemMoving := False;
        if mi >= 0 then
        begin
          g_ChallengeDlgItem := g_MovingItem.Item; // 辑滚俊 搬苞甫 扁促府绰悼救 焊包
          FrmMain.SendAddChallengeItem(g_ChallengeDlgItem);
          g_dwChallengeActionTick := GetTickCount + 4000;
        end
        else
          AddChallengeItem(g_MovingItem.Item);
        g_MovingItem.Item.Name := '';
      end;
      if ASource = msGold then
        DDGoldClick(Self, 0, 0);
    end;
    ArrangeItemBag;
  end;
end;

procedure TFrmDlg.DChallengeCloseClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount > g_dwChallengeActionTick then
  begin
    CloseChallengeDlg;
    FrmMain.SendCancelChallenge;
  end;
end;

procedure TFrmDlg.DRChallengeGridGridMouseMove(Sender: TObject;
  ACol, ARow: Integer; Shift: TShiftState);
var
  Idx: Integer;
begin
  Idx := ACol + ARow * DRChallengeGrid.ColCount;
  if Idx in [0 .. 3] then
  begin
    g_MouseItem := g_ChallengeRemoteItems[Idx];
  end;
end;

procedure TFrmDlg.DRChallengeGridGridPaint(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; dsurface: TAsphyreCanvas);
var
  Idx: Integer;
  D: TAsphyreLockableTexture;
begin
  Idx := ACol + ARow * DRChallengeGrid.ColCount;
  if Idx in [0 .. 3] then
  begin
    if g_ChallengeRemoteItems[Idx].Name <> '' then
    begin
      if g_ChallengeRemoteItems[Idx].Looks > 9999 then
        D := g_77WBagItemImages.Images
          [g_ChallengeRemoteItems[Idx].Looks - 10000]
      else
        D := g_WBagItemImages.Images[g_ChallengeRemoteItems[Idx].Looks];
      if D <> nil then
        with DRChallengeGrid do
          dsurface.Draw(SurfaceX(Rect.Left + (ColWidth - D.WIDTH) div 2 - 1),
            SurfaceY(Rect.Top + (RowHeight - D.Height) div 2 + 1),
            D.ClientRect, D, True);
    end;
  end;
end;

procedure TFrmDlg.DChallengeOKClick(Sender: TObject; X, Y: Integer);
var
  mi: Integer;
begin
  if GetTickCount > g_dwChallengeActionTick then
  begin
    FrmMain.SendChallengeEnd;
    g_dwChallengeActionTick := GetTickCount + 4000;
    g_boChallengeEnd := True;
    if g_boItemMoving then
    begin
      mi := g_MovingItem.FromIndex;
      if (mi <= -57) and (mi > -61) then
      begin // 掉 芒俊辑 柯巴父
        AddChallengeItem(g_MovingItem.Item);
        g_boItemMoving := False;
        g_MovingItem.Item.Name := '';
      end;
    end;
  end;
end;

procedure TFrmDlg.DChatBoxDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  if not g_NewUI then
  begin
    FChatLock := True;
    DScreen.ChatMessage.Draw(dsurface, DChatBox.SurfaceX(DChatBox.Left),
      DChatBox.SurfaceY(DChatBox.Top));
    FChatLock := False;
  end;
end;

procedure TFrmDlg.DChatBoxDownInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  if DScreen.ChatMessage.InContext(X, Y) then
  begin
    IsRealArea := True;
  end;
end;

procedure TFrmDlg.DChatBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

  function ExtractUserName(line: string): string;
  var
    uname: string;
  begin
    if pos('[国]', line) = 1 then
      line := Copy(line, Length('[国]'), Length(line) - Length('[国]'))
    else if pos('[阵]', line) = 1 then
      line := Copy(line, Length('[阵]'), Length(line) - Length('[阵]'));
    GetValidStr3(line, line, ['(', '!', '*', '/', ')']);
    GetValidStr3(line, uname, [' ', '=', ':']);
    if uname <> '' then
      if (uname[1] = '/') or (uname[1] = '(') or (uname[1] = ' ') or
        (uname[1] = '[') then
        uname := '';
    Result := uname;
  end;

var
  V: String;
begin
  DScreen.ChatMessage.Click(X - DChatBox.Left, Y - DChatBox.Top, V);
  if V <> '' then
  begin
    SetDFocus(DEChat);
    PlayScene.SetChatText('/' + ExtractUserName(V) + ' ');
  end;
end;

procedure TFrmDlg.DChatBoxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if g_boXYChanged then
  begin
    DScreen.ChatMessage.Move(X - DChatBox.Left, Y - DChatBox.Top);
    Exit;
  end;
end;

procedure TFrmDlg.DChatBoxMouseWheelDownEvent(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  DScreen.ChatMessage.TopLine := DScreen.ChatMessage.TopLine + 1;
  if DScreen.ChatMessage.TopLine > DScreen.ChatMessage.Count - 1 then
    DScreen.ChatMessage.TopLine := DScreen.ChatMessage.Count - 1;
  UpdateChatSroll;
end;

procedure TFrmDlg.DChatBoxMouseWheelUpEvent(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ChatMessage.TopLine := DScreen.ChatMessage.TopLine - 1;
  if DScreen.ChatMessage.TopLine < 0 then
    DScreen.ChatMessage.TopLine := 0;
  UpdateChatSroll;
end;

procedure TFrmDlg.DChatScrollBottomMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_CHATBOX;
  ScrollTimer.Enabled := True;
  ScrollTimer.Tag := 2;
end;

procedure TFrmDlg.DChatScrollBottomMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DChatScrollMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FChatScrollY := Y;
end;

procedure TFrmDlg.DChatScrollMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  _Top: Integer;
  H: Single;
  nScrollPixel: Integer; // 实际滑动距离
begin
  if FChatLock then
    Exit;

  if DChatScroll.Downed then
  begin

    // 更新位置
    DChatScroll.Top := DChatScroll.Top + Y - FChatScrollY;
    if DChatScroll.Top < DChatScrollTop.Top + DChatScrollTop.Height then
      DChatScroll.Top := DChatScrollTop.Top + DChatScrollTop.Height
    else if DChatScroll.Top > DChatScrollBottom.Top - DChatScroll.Height then
      DChatScroll.Top := DChatScrollBottom.Top - DChatScroll.Height;


    // //实际可滑动的像素
    // nScrollPixel := DChatScrollBottom.Top - DChatScrollTop.Top - DChatScrollTop.Height - DChatScroll.Height;
    // //计算当前在的位置
    // H := (DChatScroll.Top - DChatScrollTop.Top - DChatScrollTop.Height ) / nScrollPixel ;
    // _Top := Round((DScreen.ChatMessage.Count - CHATBOXLINECOUNT) * H) ;

    H := (DChatScrollBottom.Top - DChatScrollTop.Top - DChatScrollTop.Height -
      DChatScroll.Height) / DScreen.ChatMessage.Count;
    _Top := Round((DChatScroll.Top - DChatScrollTop.Top -
      DChatScrollTop.Height) / H);

    if _Top < 0 then
      _Top := 0
    else if _Top > DScreen.ChatMessage.Count - 1 then
      _Top := DScreen.ChatMessage.Count - 1;

    DScreen.ChatMessage.TopLine := _Top;
    DScreen.ChatMessage.UpdateTopLine;
    FChatScrollY := Y;
  end;
end;

procedure TFrmDlg.DChatScrollTopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_CHATBOX;
  ScrollTimer.Enabled := True;
  ScrollTimer.Tag := 1;
end;

procedure TFrmDlg.DChatScrollTopMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DChallengeGoldClick(Sender: TObject; X, Y: Integer);
var
  DGold: Integer;
  valstr: string;
begin
  if g_MySelf = nil then
    Exit;
  if not g_boChallengeEnd and (GetTickCount > g_dwChallengeActionTick) then
  begin
    g_SoundManager.DXPlaySound(s_money);

    g_Application.AddMessageDialog('你想抵押多少' + g_sGoldName + '？',
      [mbOK, mbAbort], procedure(AResult: Integer)
    begin if AResult = mrOK then begin GetValidStrVal(DlgEditText, valstr,
      [' ']); DGold := Str_ToInt(valstr, 0);
      if (DGold <= (g_nChallengeGold + g_nGold)) and (DGold > 0)
    then begin FrmMain.SendChangeChallengeGold(DGold);
      g_dwChallengeActionTick := GetTickCount + 4000; end; end; end);
  end;
end;

procedure TFrmDlg.btnRecvChrCloseClick(Sender: TObject; X, Y: Integer);
begin
  dwRecoverChr.visible := False;
  DVRecoverCharNames.Clear;
end;



procedure TFrmDlg.btnRecoverClick(Sender: TObject; X, Y: Integer);
var
  Index : Integer;
  Name : String;
begin
  if DVRecoverCharNames.SelectedIndex >= 0 then
  begin
    Name := DVRecoverCharNames.Items[DVRecoverCharNames.SelectedIndex].SubStrings[0];
    FrmMain.SendResDelChr(Name);
    btnRecvChrCloseClick(Self, 0, 0);
  end;
end;

procedure TFrmDlg.DWChallengeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DWChatHistoryCloseClick(Sender: TObject; X, Y: Integer);
begin
  DWChatHistory.visible := False;
end;

procedure TFrmDlg.DEdtSdoCommonHpTimerKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 123 then
  begin
    FrmMain.OpenSdoAssistant();
  end;
end;

procedure TFrmDlg.DELoginPwdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    Key := 0;
    if LoginScene.Login(DELoginID.Text, DELoginPwd.Text) then
      DELoginPwd.Text := ''
    else
      DELoginPwd.SetFocus;
  end;
end;

procedure TFrmDlg.DHeroItemBagMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DScreen.ClearHint;
end;

function Mz_InternalReadComponentData(var Instance: TComponent;
  const DfmData: string): Boolean;
var
  StrStream: TStringStream;
begin
  StrStream := nil;
  try
    StrStream := TStringStream.Create(DfmData);
    Instance := StrStream.ReadComponent(Instance);
  finally
    StrStream.Free;
  end;
  Result := True;
end;

function Mz_InitInheritedComponent(Instance: TComponent; RootAncestor: TClass;
  const DfmData: string): Boolean;
  function Mz_InitComponent(ClassType: TClass; const DfmData: string): Boolean;
  begin
    Result := False;
    if (ClassType = TComponent) or (ClassType = RootAncestor) then
      Exit;
    Result := Mz_InitComponent(ClassType.ClassParent, DfmData);
    Result := Mz_InternalReadComponentData(Instance, DfmData) or Result; // **
  end;

var
  LocalizeLoading: Boolean;
begin
  GlobalNameSpace.BeginWrite;
  // hold lock across all ancestor loads (performance)
  try
    LocalizeLoading := (Instance.ComponentState * [csInline, csLoading]) = [];
    if LocalizeLoading then
      BeginGlobalLoading; // push new loadlist onto stack
    try
      Result := Mz_InitComponent(Instance.ClassType, DfmData); // **
      if LocalizeLoading then
        NotifyGlobalLoading; // call Loaded
    finally
      if LocalizeLoading then
        EndGlobalLoading; // pop loadlist off stack
    end;
  finally
    GlobalNameSpace.EndWrite;
  end;
end;

constructor TFrmDlg.Create(AOwner: TComponent);
begin
  inherited; // 注释了下面读取组件的代码,就必须由父类类创建组件,所以要调用Inherited 2009-10-29 邱高奇
  // GlobalNameSpace.BeginWrite;
  // try
  // CreateNew(AOwner);
  // if (ClassType <> TForm) and not (csDesigning in ComponentState) then
  // begin
  // Include(FFormState, fsCreating);
  // try
  // if (Mz_InitInheritedComponent(Self, TForm, DemoDfm) = False) then // **
  // ShowMessage('注意, 初始化界面失败, 请检查DataUnit.DfmData, :~)');
  // finally
  // Exclude(FFormState, fsCreating);
  // end;
  // if OldCreateOrder then DoCreate;
  // end;
  // finally
  // GlobalNameSpace.EndWrite;
  // end;
end;

procedure TFrmDlg.CreateSelChrUI;
var
  NameDesc,Name,JobDesc,JobName,LevelDesc,Level : TDTextField;
  Image: TDImagePanel;
  i:Integer;
begin
  ChrAnis[0] := DAChr1;
  ChrAnis[1] := DAChr2;
  ChrAnis[2] := DAChr3;
  ChrAnis[3] := DAChr4;
  ChrAnis[4] := DAChr5;


  ChrSelectButton[0] := DscSelect1;
  ChrSelectButton[1] := DscSelect2;
  ChrSelectButton[2] := DscSelect3;
  ChrSelectButton[3] := DscSelect4;
  ChrSelectButton[4] := DscSelect5;

  for i := 0 to 4 do
  begin
    Name := TDTextField.Create(Self);
    Name.Caption := '角色名称_'+IntToStr(i + 1);
    Name.Name := 'CharName' + IntToStr(i + 1);
    Name.Propertites.Caption.Color := $00ADD6EF;
    Name.Propertites.Caption.Border := $00212121;
    Name.Propertites.Caption.OutLinePixel := 1;

    JobDesc := TDTextField.Create(Self);
    JobDesc.Caption := '职业标题_'+IntToStr(i + 1);
    JobDesc.Name := 'JobDesc' + IntToStr(i + 1);
    JobDesc.Propertites.Caption.Color := $00ADD6EF;
    JobDesc.Propertites.Caption.Border := $00212121;
    JobDesc.Propertites.Caption.OutLinePixel := 1;


    JobName := TDTextField.Create(Self);
    JobName.Caption := '玩家职业_'+IntToStr(i + 1);
    JobName.Name := 'JobName' + IntToStr(i + 1);
    JobName.Propertites.Caption.Color := $00ADD6EF;
    JobName.Propertites.Caption.Border := $00212121;
    JobName.Propertites.Caption.OutLinePixel := 1;

    LevelDesc := TDTextField.Create(Self);
    LevelDesc.Caption := '等级标题_'+IntToStr(i + 1);
    LevelDesc.Name := 'LevelDesc' + IntToStr(i + 1);
    LevelDesc.Propertites.Caption.Color := $00ADD6EF;
    LevelDesc.Propertites.Caption.Border := $00212121;
    LevelDesc.Propertites.Caption.OutLinePixel := 1;

    Level := TDTextField.Create(Self);
    Level.Caption := '玩家等级_'+IntToStr(i + 1);
    Level.Name := 'Level' + IntToStr(i + 1);
    Level.Propertites.Caption.Color := $00ADD6EF;
    Level.Propertites.Caption.Border := $00212121;
    Level.Propertites.Caption.OutLinePixel := 1;

    NameDesc := TDTextField.Create(Self);
    NameDesc.Caption := '名称_'+IntToStr(i + 1);
    NameDesc.Name := 'CharNameDesc' + IntToStr(i + 1);
    NameDesc.Propertites.Caption.Color := $00ADD6EF;
    NameDesc.Propertites.Caption.Border := $00212121;
    NameDesc.Propertites.Caption.OutLinePixel := 1;
    NameDesc.Propertites.Caption.Text := '名称 ';

    ChrNames[i] := Name;
    ChrJobDescs[i] := JobDesc;
    ChrJobName[i] := JobName;
    ChrLevelDesc[i] := LevelDesc;
    ChrLevel[i] := Level;
    ChrNameDesc[i] := NameDesc;


    case i  of
     0: Image := DPanelChr1;
     1: Image := DPanelChr2;
     2: Image := DPanelChr3;
     3: Image := DPanelChr4;
     4: Image := DPanelChr5;
    end;

    ChrInfoPanel[i]:= Image;

    Image.Width  := 150;
    Image.Height := 58;

    Name.Left := 9;
    Name.Top := 8;

    JobDesc.Left := 9;
    JobDesc.Top := 8 + 16;
    JobDesc.Propertites.Caption.Text := '职业 ';

    JobName.Left := 9 + 40;
    JobName.Top := 8 + 16;

    LevelDesc.Left := 9;
    LevelDesc.Top := 8+ 16 + 16;
    LevelDesc.Propertites.Caption.Text := '等级 ';

    Level.Left := 9 + 40;
    Level.Top := 8+ 16 + 16;

    Image.AddSub(Name);
    Image.AddSub(JobDesc);
    Image.AddSub(JobName);
    Image.AddSub(LevelDesc);
    Image.AddSub(Level);
    Image.AddSub(NameDesc);

    case i  of
     0: begin
       Name0 := Name;
       JobDesc0 := JobDesc;
       JobName0 := JobName;
       LevelDesc0 := LevelDesc;
       Level0 := Level;
       NameDesc0 := NameDesc;
     end;
     1: begin
       Name1 := Name;
       JobDesc1 := JobDesc;
       JobName1 := JobName;
       LevelDesc1 := LevelDesc;
       Level1 := Level;
       NameDesc1 := NameDesc;
     end;
     2: begin
       Name2 := Name;
       JobDesc2 := JobDesc;
       JobName2 := JobName;
       LevelDesc2 := LevelDesc;
       Level2 := Level;
       NameDesc2 := NameDesc;
     end;
     3: begin
       Name3 := Name;
       JobDesc3 := JobDesc;
       JobName3 := JobName;
       LevelDesc3 := LevelDesc;
       Level3 := Level;
       NameDesc3 := NameDesc;
     end;
     4: begin
       Name4 := Name;
       JobDesc4 := JobDesc;
       JobName4 := JobName;
       LevelDesc4 := LevelDesc;
       Level4 := Level;
       NameDesc4 := NameDesc;
     end;
    end;
  end;

end;

procedure TFrmDlg.State5Click(Sender: TObject; X, Y: Integer);
begin
  // InternalForcePage := (Sender as TDButton).Tag;
  // InternalForcePageChanged;
end;

procedure TFrmDlg.cmButtDirectPaint(Sender: TObject; dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  // with (Sender as TDButton) do
  // begin
  // if Tag = BatterPage then
  // D := g_WMainImages.Images[1178]
  // else
  // D := g_WMainImages.Images[1179];
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // with dsurface.Canvas do
  // begin
  // Font.Style := [];
  // case Tag of
  // 0:
  // begin
  // if Downed then
  // DSurface.TextOut('冲脉', RGB(165, 145, 115), clBlack, SurfaceX(Left + 3) + 1, SurfaceY(Top + 5) + 1)
  // else
  // DSurface.TextOut('冲脉', RGB(165, 145, 115), clBlack, SurfaceX(Left + 3), SurfaceY(Top + 5))
  // end;
  // 1:
  // begin
  // if Downed then
  // DSurface.TextOut('阴硗', RGB(165, 145, 115), clBlack, SurfaceX(Left + 3) + 1, SurfaceY(Top + 5) + 1)
  // else
  // DSurface.TextOut('阴硗', RGB(165, 145, 115), clBlack, SurfaceX(Left + 3), SurfaceY(Top + 5))
  // end;
  // 2:
  // begin
  // if Downed then
  // DSurface.TextOut('阴维', RGB(165, 145, 115), clBlack, SurfaceX(Left + 3) + 1, SurfaceY(Top + 5) + 1)
  // else
  // DSurface.TextOut('阴维', RGB(165, 145, 115), clBlack, SurfaceX(Left + 3), SurfaceY(Top + 5))
  // end;
  // 3:
  // begin
  // if Downed then
  // DSurface.TextOut('任脉', RGB(165, 145, 115), clBlack, SurfaceX(Left + 3) + 1, SurfaceY(Top + 5) + 1)
  // else
  // DSurface.TextOut('任脉', RGB(165, 145, 115), clBlack, SurfaceX(Left + 3), SurfaceY(Top + 5))
  // end;
  // end;
  // Release;
  // end;
  // end;
end;

procedure TFrmDlg.cmButtClick(Sender: TObject; X, Y: Integer);
begin
  BatterPage := (Sender as TDButton).Tag;
  BatterButtChanged;
end;

procedure TFrmDlg.HeroBatterButtChanged;
begin
end;

procedure TFrmDlg.BatterButtChanged;

begin
  // case BatterPage of
  // 0: begin
  //
  // end;
  // 1: begin
  //
  // end;
  // 2: begin
  //
  // end;
  // 3: begin
  //
  // end;
  // end;
  // ChangeBatterButtPos;
end;

procedure TFrmDlg.ButtChongmaiDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  sMsg: string;
begin
  // case BatterPage of
  // 0:
  // sMsg := '修炼冲脉';
  // 1:
  // sMsg := '修炼阴跷';
  // 2:
  // sMsg := '修炼阴维';
  // 3:
  // sMsg := '修炼任脉';
  // end;
  // with (Sender as TDButton) do
  // begin
  // if Downed then
  // begin
  // D := g_WMainImages.Images[902];
  // end
  // else
  // begin
  // D := g_WMainImages.Images[901];
  // end;
  // if D <> nil then
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // if Downed then
  // begin
  // with dsurface.Canvas do
  // begin
  // Font.Style := []; // RGB(239,207,103)
  // DSurface.TextOut(sMsg, RGB(165, 145, 115), clBlack, SurfaceX(Left) + 2, SurfaceY(Top) + 5);
  // Font.Style := [];
  // Release;
  // end;
  // end
  // else
  // begin
  // with dsurface.Canvas do
  // begin
  // Font.Style := []; // RGB(239,207,103)
  // DSurface.TextOut(sMsg, RGB(165, 145, 115), clBlack, SurfaceX(Left) + 1, SurfaceY(Top) + 4);
  // Font.Style := [];
  // Release;
  // end;
  // end;
  // end;
end;

procedure TFrmDlg.OpenmaiButt1DblClick(Sender: TObject);
var
  Tag1: Integer;
begin
  Tag1 := (Sender as TDButton).Tag;
  with (Sender as TDButton) do
  begin
    if (g_MyPulse[BatterPage].Pulse <> 0) and
      (g_MyPulse[BatterPage].Pulse > Tag1) then
      ShowMDlg(0, '', '当前穴位早已打通！！！')
    else if g_MyPulse[BatterPage].Pulse < Tag1 then
      ShowMDlg(0, '', '您需要先打通上一级筋脉！！！')
    else
      FrmMain.SendOpenPulseQuery(BatterPage, g_MyPulse[BatterPage].Pulse + 1);
  end;
end;

procedure TFrmDlg.BatterSkill1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  Idx, icon, I, J: Integer;
  pm: pTClientMagic;
  D: TAsphyreLockableTexture;
  flag: Byte;
begin
  with Sender as TDButton do
  begin
    Idx := g_BatterOrder[Tag];
    if Downed then
    begin
      case Idx of
        0:
          begin
            D := g_WMainImages.Images[904 + (Tag * 2)];
          end;
        2222:
          begin
            D := g_WMainImages.Images[910];
          end
      else
        begin
          for I := 0 to g_BatterMagicList.Count - 1 do
          begin
            pm := g_BatterMagicList[I];
            if pm.wMagicId = Idx then
            begin
              flag := 8;
              Break;
            end;
          end;
          if flag = 8 then
          begin
            icon := GetBatterMagicIcon(pm.btEffect);
            if icon > -1 then
              D := g_WMainImages.Images[icon]
            else
              D := g_WMainImages.Images[904 + (Tag * 2)];
          end;
        end;
      end;
      if not(g_BatterMagicList.Count > 0) then
        D := g_WMainImages.Images[913 + Tag];
    end
    else
    begin
      case Idx of
        0:
          begin
            D := g_WMainImages.Images[903 + (Tag * 2)];
          end;
        2222:
          begin
            D := g_WMainImages.Images[909];
          end
      else
        begin
          for I := 0 to g_BatterMagicList.Count - 1 do
          begin
            pm := g_BatterMagicList[I];
            if pm.wMagicId = Idx then
            begin
              flag := 8;
              Break;
            end;
          end;
          if flag = 8 then
          begin
            icon := GetBatterMagicIcon(pm.btEffect);
            if icon > -1 then
              D := g_WMainImages.Images[icon]
            else
              D := g_WMainImages.Images[903 + (Tag * 2)];
          end;
        end;
      end;
      if not(g_BatterMagicList.Count > 0) then
        D := g_WMainImages.Images[913 + Tag];
    end;
    if D <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    if (Tag = 0) and (g_BatterMagicList.Count > 0) and (g_BatterOrder[0] = 0)
      and (g_BatterOrder[1] = 0) and (g_BatterOrder[2] = 0) then
    begin
      typeTimeimg;
      D := g_WMainImages.Images[918 + BatterImage];
      if D <> nil then
      begin
        dsurface.Draw(SurfaceX(Left) + 6, SurfaceY(Top) + Height,
          D.ClientRect, D, True);
      end;
      D := g_WMainImages.Images[903];
      if D <> nil then
      begin
        dsurface.Draw(SurfaceX(Left) + BatterImage, SurfaceY(Top) + BatterImage,
          D.ClientRect, D, True);
      end;
    end;
  end;
end;

function TFrmDlg.GetBatterMagicIcon(Eff: Word): Integer;
begin
  Result := -1;
  case Eff of
    102:
      Result := 952; // 三绝杀
    103:
      Result := 944; // 双龙破
    104:
      Result := 934; // 虎啸诀
    105:
      Result := 950; // 追心刺
    106:
      Result := 942; // 凤舞祭
    107:
      Result := 936; // 八卦掌
    108:
      Result := 956; // 断岳斩
    109:
      Result := 946; // 惊雷爆
    110:
      Result := 932; // 三焰咒
    111:
      Result := 954; // 横扫千军
    112:
      Result := 940; // 冰天雪地
    113:
      Result := 930; // 万剑归宗
  end;
end;

procedure TFrmDlg.BatterSkill5DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  Idx, icon, MagicID, I, n01, n02: Integer;
  pm: pTClientMagic;
  D: TAsphyreLockableTexture;
  trLev: Byte;
  sMsg: string; // StormsRate;
  procedure BatterStormsRate(MagicID: Integer;
    var mStormsRate, oStormsRate: Integer);
  var
    I: Integer;
  begin
    mStormsRate := 0;
    oStormsRate := 0;
    if MagicID <= 0 then
      Exit;
    for I := 0 to 2 do
    begin
      if g_BatterOrder[I] = MagicID then
      begin
        case I of
          0:
            begin
              oStormsRate := 10;
            end;
          1:
            begin
              oStormsRate := 15;
            end;
          2:
            begin
              oStormsRate := 25;
            end;
        end;
      end;
    end;
    case MagicID of
      76 .. 78:
        begin
          if g_MyPulse[0].PulseLevel > 0 then
            mStormsRate := g_BatterStormsRate[g_MyPulse[0].PulseLevel - 1]
              .nStormsRate;
        end;
      79 .. 81:
        begin
          if g_MyPulse[1].PulseLevel > 0 then
            mStormsRate := g_BatterStormsRate[g_MyPulse[1].PulseLevel - 1]
              .nStormsRate;
        end;
      82 .. 84:
        begin
          if g_MyPulse[2].PulseLevel > 0 then
            mStormsRate := g_BatterStormsRate[g_MyPulse[2].PulseLevel - 1]
              .nStormsRate;
        end;
      85 .. 87:
        begin
          if g_MyPulse[3].PulseLevel > 0 then
            mStormsRate := g_BatterStormsRate[g_MyPulse[3].PulseLevel - 1]
              .nStormsRate;
        end;
    end;
  end;

begin
  Idx := (Sender as TDButton).Tag;
  pm := nil;
  case g_MySelf.m_btJob of
    0:
      begin
        case Idx of
          0:
            begin
              MagicID := 76;
              sMsg := '三绝杀';
            end;
          1:
            begin
              MagicID := 79;
              sMsg := '追心刺';
            end;
          2:
            begin
              MagicID := 82;
              sMsg := '断岳斩';
            end;
          3:
            begin
              MagicID := 85;
              sMsg := '横扫千军';
            end;
        end;
      end;
    1:
      begin
        case Idx of
          0:
            begin
              MagicID := 77;
              sMsg := '双龙破';
            end;
          1:
            begin
              MagicID := 80;
              sMsg := '凤舞祭';
            end;
          2:
            begin
              MagicID := 83;
              sMsg := '惊雷爆';
            end;
          3:
            begin
              MagicID := 86;
              sMsg := '冰天雪地';
            end;
        end;
      end;
    2:
      begin
        case Idx of
          0:
            begin
              MagicID := 78;
              sMsg := '虎啸诀';
            end;
          1:
            begin
              MagicID := 81;
              sMsg := '八卦掌';
            end;
          2:
            begin
              MagicID := 84;
              sMsg := '三焰咒';
            end;
          3:
            begin
              MagicID := 87;
              sMsg := '万剑归宗';
            end;
        end;
      end;
  end;
  for I := 0 to g_BatterMagicList.Count - 1 do
  begin
    pm := g_BatterMagicList[I];
    if (pm <> nil) and (MagicID = pm.wMagicId) then
    begin
      with (Sender as TDButton) do
      begin
        icon := GetBatterMagicIcon(pm.btEffect);
        trLev := pm.Level;
        if icon <> -1 then
        begin
          D := g_WMainImages.Images[icon];
          if D <> nil then
            dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
        end;
        D := g_WMainImages.Images[112]; // lv
        if D <> nil then
        begin
          dsurface.Draw(SurfaceX(Left) + 40, SurfaceY(Top) + 18,
            D.ClientRect, D, True);
        end;
        D := g_WMainImages.Images[111]; // exp
        if D <> nil then
        begin
          dsurface.Draw(SurfaceX(Left) + 62, SurfaceY(Top) + 18,
            D.ClientRect, D, True);
        end;

        BatterStormsRate(MagicID, n01, n02);
        if n02 <> 0 then
          dsurface.BoldText(SurfaceX(Left) + 40, SurfaceY(Top),
            sMsg + ': ' + IntToStr(n01) + '%+' + IntToStr(n02) + '%暴击',
            RGB(255, 255, 255), clBlack)
        else
          dsurface.BoldText(SurfaceX(Left) + 40, SurfaceY(Top),
            sMsg + ': ' + IntToStr(n01) + '%暴击', RGB(255, 255, 255), clBlack);
        dsurface.BoldText(SurfaceX(Left) + 55, SurfaceY(Top) + 18,
          IntToStr(trLev), RGB(255, 255, 255), clBlack);
        if trLev < 3 then
          dsurface.BoldText(SurfaceX(Left) + 88, SurfaceY(Top) + 18,
            IntToStr(pm.CurTrain) + '/' + IntToStr(pm.MaxTrain),
            RGB(255, 255, 255), clBlack)
        else
          dsurface.BoldText(SurfaceX(Left) + 88, SurfaceY(Top) + 18, '-',
            clSilver, clBlack);
      end;
      Break;
    end;
  end;
end;

procedure TFrmDlg.RenderBottomSurface(Sender: TObject);
var
  D: TAsphyreLockableTexture;
begin

  g_GameCanvas.FillRect(0, 111, BottomSurface.WIDTH, BottomSurface.Height - 111,
    cColor1(clWhite), beNormal);

  D := g_77Images.Images[274]; // 显示左边空血球图片
  if D <> nil then
    g_GameCanvas.Draw(0, 0, D);
  //
  D := g_77Images.Images[275]; // 显示最右边的界面
  if D <> nil then
    g_GameCanvas.Draw(BottomSurface.WIDTH - D.WIDTH, 0, D);

  D := g_77Images.Images[278]; // 绘制左边聊天框左上角
  if D <> nil then
    g_GameCanvas.Draw(194, 94, D);

  D := g_77Images.Images[281]; // 绘制左边聊天框左上角中部
  if D <> nil then
  begin
    g_GameCanvas.Draw(194, 94 + 48, D, True);
    g_GameCanvas.Draw(194, 94 + 48 + 48, D, True);
  end;

  D := g_77Images.Images[283]; // 绘制底部聊天框
  if D <> nil then
    g_GameCanvas.Draw(194, BottomSurface.Height - D.Height, D, True);

  D := g_77Images.Images[279]; // 拉伸绘制聊天框长度
  if D <> nil then
    g_GameCanvas.HorFillDraw(194 + 48, BottomSurface.WIDTH - 177 - 48,
      94, D, True);

  D := g_77Images.Images[280]; // 绘制右上角聊天框
  if D <> nil then
    g_GameCanvas.Draw(BottomSurface.WIDTH - 190 - 48, 94, D, True);

  D := g_77Images.Images[282];
  if D <> nil then
  begin
    g_GameCanvas.Draw(BottomSurface.WIDTH - 190 - 48, 94 + 48, D, True);
    g_GameCanvas.Draw(BottomSurface.WIDTH - 190 - 48, 94 + 48 + 48, D, True);
  end;

  D := g_77Images.Images[284];
  if D <> nil then
    g_GameCanvas.HorFillDraw(194 + 48, BottomSurface.WIDTH - 177 - 48,
      BottomSurface.Height - D.Height, D, True);

  D := g_77Images.Images[285];
  if D <> nil then
    g_GameCanvas.Draw(BottomSurface.WIDTH - 190 - 48, BottomSurface.Height -
      D.Height, D, True);

  D := g_77Images.Images[276];
  if D <> nil then
    g_GameCanvas.Draw((BottomSurface.WIDTH - D.WIDTH) div 2 + 10, 48, D, True);

end;

procedure TFrmDlg.DoClickHintInited(Sender: TObject);
begin
  DHintWindowClose.WIDTH := 20;
  DHintWindowClose.Height := 20;
  DHintWindow.WIDTH := DScreen.ClickItemHint.WIDTH;
  DHintWindow.Height := DScreen.ClickItemHint.Height;
  DHintWindowClose.Left := DHintWindow.WIDTH - 20 + 2;
  DHintWindowClose.Top := 0;
  DHintWindow.Left := (SCREENWIDTH - DHintWindow.WIDTH) div 2;
  DHintWindow.Top := (SCREENHEIGHT - DHintWindow.Height) div 2;
  if DHintWindow.Top < 0 then
    DHintWindow.Top := 0;
  DHintWindow.visible := True;
end;

procedure TFrmDlg.BeginScene(Device: TAsphyreDevice; MSurface: TAsphyreCanvas);
begin
  // if g_UIInitialized and (BottomSurface = nil) then
  // begin
  // BottomSurface := Factory.CreateRenderTargetTexture;
  // BottomSurface.Format := apf_A8R8G8B8;
  // BottomSurface.SetSize(DBottom.WIDTH, DBottom.Height, True);
  // Device.RenderTo(RenderBottomSurface, 0, True, BottomSurface);
  // end;
end;

procedure TFrmDlg.SetBottomButtonsPosition;
var
  AIncW: Integer;
begin
  DBotPlusAbil.visible := True;//g_nBonusPoint > 0;
  DBotMiniMap.Left := 219;
  DBotMiniMap.Top := 104;
  AIncW := 0;
  DBotDeal.visible :=  True;//ClientConf.boShowDealButton;
  if DBotDeal.visible then
  begin
    DBotDeal.Left := 249;
    DBotDeal.Top := 104;
    AIncW := 30;
  end;

  DBotGuild.Left := 249 + AIncW;
  DBotGuild.Top := 104;
  DBotGroup.Left := 279 + AIncW;
  DBotGroup.Top := 104;
  DBotFriend.Left := 309 + AIncW;
  DBotFriend.Top := 104;

//  DBotPlusAbil.Left := 339 + AIncW;
//  DBotPlusAbil.Top := 104;
//  AIncW := AIncW + 30;

  CharacterSranking.Left := 339 + AIncW;
  CharacterSranking.Top := 104;
  DBotHorse.Left := 369 + AIncW;
  DBotHorse.Top := 104;
  DBotChatHistory.Left := 399 + AIncW;
  DBotChatHistory.Top := 104;

  DBotPlusAbil.Left := 459;
  DBotPlusAbil.Top := 104;
  AIncW := AIncW + 30;

end;

procedure TFrmDlg.BatterSkill1Click(Sender: TObject; X, Y: Integer);
var
  btag, I, J, i01, i02, L: Integer;
  pm: pTClientMagic;
  flag: Byte;
  SetMagicID: Word;
  function FindBatterSpell(MagicID: Word): Boolean; // 查找有没有这个连击魔法 20091218 邱高奇
  var
    I, J, cTag, K, flag: Integer;
    pm: pTClientMagic;
  begin
    Result := True;
    flag := 0;
    try
      for I := 0 to g_BatterMagicList.Count - 1 do
      begin
        pm := g_BatterMagicList[I];
        if (pm <> nil) and (pm.wMagicId = MagicID) then
        begin
          flag := 8;
          for J := 0 to 2 do
          begin // 寻早有没有，和自己按钮相同的  20091218 邱高奇
            K := g_BatterOrder[J];
            if (K <> 0) and (K = MagicID) then
            begin
              flag := 9;
              Break;
            end;
          end;
        end;
      end;
      if (flag = 0) or (flag = 9) then
        Result := False;
    except
    end;
  end;

begin
  // if g_BatterMagicList.Count > 0 then
  // begin
  // with Sender as TDButton do
  // begin
  // DBatterPopMenu.Left := Left;
  // DBatterPopMenu.Top := Top + Height;
  // DBatterPopMenu.Tag := Integer(Sender);
  // DBatterPopMenu.visible := True;
  // end;
  // end;
end;

procedure TFrmDlg.BuildBufferStation;
begin
  case UIWindowManager.Form.Buffers.Position of
    upAbsoluteLeftTop:
      begin
        DBufferButtons.Left := UIWindowManager.Form.Buffers.XMargin;
        DBufferButtons.Top := UIWindowManager.Form.Buffers.YMargin;
      end;
    upAbsoluteTopCenter:
      begin
        DBufferButtons.Left := (SCREENWIDTH DIV 2) +
          UIWindowManager.Form.Buffers.XMargin;
        DBufferButtons.Top := UIWindowManager.Form.Buffers.YMargin;
      end;
    upAbsoluteRightTop:
      begin
        DBufferButtons.Left := SCREENWIDTH - DBufferButtons.WIDTH +
          UIWindowManager.Form.Buffers.XMargin;
        DBufferButtons.Top := UIWindowManager.Form.Buffers.YMargin;
      end;
    upAbsoluteLeftMiddle:
      begin
        DBufferButtons.Left := UIWindowManager.Form.Buffers.XMargin;
        DBufferButtons.Top := (SCREENHEIGHT DIV 2) +
          UIWindowManager.Form.Buffers.YMargin;
      end;
    upAbsoluteScreenCenter:
      begin
        DBufferButtons.Left := (SCREENWIDTH DIV 2) +
          UIWindowManager.Form.Buffers.XMargin;
        DBufferButtons.Top := (SCREENHEIGHT DIV 2) +
          UIWindowManager.Form.Buffers.YMargin;
      end;
    upAbsoluteRightMiddle:
      begin
        DBufferButtons.Left := SCREENWIDTH - DBufferButtons.WIDTH +
          UIWindowManager.Form.Buffers.XMargin;
        DBufferButtons.Top := (SCREENHEIGHT DIV 2) +
          UIWindowManager.Form.Buffers.YMargin;
      end;
    upAbsoluteLeftBottom:
      begin
        DBufferButtons.Left := UIWindowManager.Form.Buffers.XMargin;
        DBufferButtons.Top := SCREENHEIGHT - g_BottomHeight +
          UIWindowManager.Form.Buffers.YMargin;
      end;
    upAbsoluteBottomCenter:
      begin
        DBufferButtons.Left := (SCREENWIDTH DIV 2) +
          UIWindowManager.Form.Buffers.XMargin;
        DBufferButtons.Top := SCREENHEIGHT - g_BottomHeight +
          UIWindowManager.Form.Buffers.YMargin;
      end;
    upAbsoluteRightBottom:
      begin
        DBufferButtons.Left := SCREENWIDTH - DBufferButtons.WIDTH +
          UIWindowManager.Form.Buffers.XMargin;
        DBufferButtons.Top := SCREENHEIGHT - g_BottomHeight +
          UIWindowManager.Form.Buffers.YMargin;
      end;
  end;
end;

procedure TFrmDlg.BuildMessageBox;
const
  XBase = 324;
var
  I: Integer;
  lx, ly: Integer;
  D: TAsphyreLockableTexture;
begin
//  if FDialogItem <> nil then
//  begin
//    FrmMain.CloseTopmost;
//    lx := XBase;
//    ly := 126;
//    case DialogSize of
//      0: // 小对话框
//        begin
//          D := g_WMainImages.Images[381];
//          if D <> nil then
//          begin
//            DMsgDlg.SetImgIndex(g_WMainImages, 381);
//            DMsgDlg.Left := (SCREENWIDTH - D.WIDTH) div 2;
//            DMsgDlg.Top := (SCREENHEIGHT - D.Height) div 2;
//            msglx := 39;
//            msgly := 38;
//            lx := 90;
//            ly := 36;
//          end;
//        end;
//      1: // 大对话框（横）
//        begin
//          D := g_77Images.Images[243];
//          if D <> nil then
//          begin
//            DMsgDlg.SetImgIndex(g_77Images, 243);
//            DMsgDlg.Left := (SCREENWIDTH - D.WIDTH) div 2;
//            DMsgDlg.Top := (SCREENHEIGHT - D.Height) div 2;
//            msglx := 39;
//            msgly := 38;
//            lx := XBase;
//            ly := 126;
//          end;
//        end;
//      2: // 大对话框（竖）
//        begin
//          D := g_WMainImages.Images[380];
//          if D <> nil then
//          begin
//            DMsgDlg.SetImgIndex(g_WMainImages, 380);
//            DMsgDlg.Left := (SCREENWIDTH - D.WIDTH) div 2;
//            DMsgDlg.Top := (SCREENHEIGHT - D.Height) div 2;
//            msglx := 23;
//            msgly := 20;
//            lx := 90;
//            ly := 305;
//          end;
//        end;
//    end;
//    MsgText := FDialogItem.Text;
//    ViewDlgEdit := False;
//    DMsgDlg.Floating := True;
//    DMsgDlgOk.visible := False;
//    DMsgDlgYes.visible := False;
//    DMsgDlgCancel.visible := False;
//    DMsgDlgNo.visible := False;
//    DMsgDlg.Left := (SCREENWIDTH - DMsgDlg.WIDTH) div 2;
//    DMsgDlg.Top := (SCREENHEIGHT - DMsgDlg.Height) div 2;
//    FDlgMessage.Clear;
//    FDlgMessage.Parse(FDialogItem.Text);
//    if mbCancel in FDialogItem.Buttons then
//    begin
//      DMsgDlgCancel.Left := lx;
//      DMsgDlgCancel.Top := ly;
//      DMsgDlgCancel.visible := True;
//      lx := lx - 110;
//    end;
//    if mbNo in FDialogItem.Buttons then
//    begin
//      DMsgDlgNo.Left := lx;
//      DMsgDlgNo.Top := ly;
//      DMsgDlgNo.visible := True;
//      lx := lx - 110;
//    end;
//    if mbYes in FDialogItem.Buttons then
//    begin
//      DMsgDlgYes.Left := lx;
//      DMsgDlgYes.Top := ly;
//      DMsgDlgYes.visible := True;
//      lx := lx - 110;
//    end;
//    if (mbOK in FDialogItem.Buttons) or (lx = XBase) then
//    begin // 只有确定
//      DMsgDlgOk.Left := lx;
//      DMsgDlgOk.Top := ly;
//      DMsgDlgOk.visible := True;
//      // lx := lx - 110;
//    end;
//    HideAllControls;
//    DMsgDlg.ShowModal;
//    if mbAbort in FDialogItem.Buttons then
//    begin
//      ViewDlgEdit := True; // 显示编辑框.
//      DMsgDlg.Floating := False;
//      with EdDlgEdit do
//      begin
//        Text := '';
//        WIDTH := DMsgDlg.WIDTH - 70;
//        Left := (SCREENWIDTH - EdDlgEdit.WIDTH) div 2;
//        Top := (SCREENHEIGHT - EdDlgEdit.Height) div 2 - 10;
//      end;
//    end;
//  end;
end;

procedure TFrmDlg.ButtChongmaiClick(Sender: TObject; X, Y: Integer);
begin
  try
    FrmMain.SendRushPulse(BatterPage, g_MyPulse[BatterPage].PulseLevel + 1);
  except
    // 程序异常  20091218 邱高奇
  end;
end;

procedure TFrmDlg.buttUseBatterDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  if g_boCanUseBatter then
  begin
    typeTimeimg();
    D := g_WMainImages.Images[1121 + BatterImage];
    with (Sender as TDButton) do
    begin
      if D <> nil then
      begin
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, False);
      end;
    end;
  end
  else
  begin
    D := g_WMainImages.Images[1120];
    with (Sender as TDButton) do
    begin
      if D <> nil then
      begin
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, False);
      end;
    end;
  end;
end;

procedure TFrmDlg.AdjustWindowShow;
begin
  case g_SNDAVer of
    10:
      begin
        // State5.visible := False;
        // State6.visible := False;
        // State7.visible := False;
        // State8.visible := False;
        // ButtChongmai.visible := False;
      end;
    20:
      begin
      end;
    30:
      begin
      end;
  end;
end;

procedure TFrmDlg.OpenmaiButt1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  if g_MyPulse[BatterPage].Pulse = TDButton(Sender).Tag then
  begin
    if GetTickCount - g_PulseFlashTick > 200 { 一秒 } then
    begin
      g_PulseFlashTick := GetTickCount;
      g_PulseFlash := not g_PulseFlash;
    end;
    if g_PulseFlash then
    begin
      D := g_WMainImages.Images[853];
      if D <> nil then
      begin
        With Sender as TDButton do
        begin
          dsurface.DrawBlend(SurfaceX(Left) - 5, SurfaceY(Top) - 5, D, 1);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DAdjustAbilOkDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with Sender as TDButton do
  begin
    if Propertites.Images <> nil then
    begin
      D := nil;
      if not Enabled then
      begin
        case Propertites.ImageIndex of
          212:
            D := Propertites.Images.Images[216];
          214:
            D := Propertites.Images.Images[217];
        end;
      end
      else begin
        DefaultPaint(dsurface);
      end;

    end;
  end;
end;

procedure TFrmDlg.DAExpBarMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DTExpText.Visible := True;
end;

procedure TFrmDlg.DAOpenDoorDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin

  if DAOpenDoor.Propertites.AniCount - DAOpenDoor.FrameIndex < 5 then
  begin
    if not g_boDoFadeOut and not g_boDoFadeIn then
    begin
      g_boDoFadeOut := True;
      g_boDoFadeIn := True;
      g_nFadeIndex := 29;
    end;
  end;

  if g_boDoFadeOut then
  begin
    if g_nFadeIndex <= 1 then
    begin
      g_WMainImages.ClearCache;
      g_WChrSelImages.ClearCache;
      DScreen.ChangeScene(stSelectChr); //
    end;
  end;
end;

procedure TFrmDlg.DAttzhanshiDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  fcolor: Integer;
begin
  // if g_HeroAttectMode = (Sender as TDButton).Tag then
  // d := g_qingqingImages.Images[8]
  // else
  // d := g_qingqingImages.Images[7];
  if D <> nil then
    with Sender as TDButton do
    begin
      if Moveed then
        fcolor := clWhite
      else
        fcolor := clSilver;
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      case Tag of
        0:
          dsurface.BoldText(SurfaceX(Left) + 20, SurfaceY(Top), '副将英雄以战士状态出战',
            fcolor, clBlack);
        1:
          dsurface.BoldText(SurfaceX(Left) + 20, SurfaceY(Top), '副将英雄以法师状态出战',
            fcolor, clBlack);
        2:
          dsurface.BoldText(SurfaceX(Left) + 20, SurfaceY(Top), '副将英雄以道士状态出战',
            fcolor, clBlack);
      end;
    end;
end;

procedure TFrmDlg.DAWeightBarMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DTWeightText.Visible := True;
end;

procedure TFrmDlg.DAttzhanshiClick(Sender: TObject; X, Y: Integer);
begin
  g_HeroAttectMode := (Sender as TDButton).Tag;
  FrmMain.SendChangeHeroAttectMode();
end;

procedure TFrmDlg.DHeroAttZhanshiDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  fcolor: Integer;
begin
  // if g_HeroAttectMode = (Sender as TDButton).Tag then
  // d := g_qingqingImages.Images[8]
  // else
  // d := g_qingqingImages.Images[7];
  if D <> nil then
    with Sender as TDButton do
    begin
      if Moveed then
        fcolor := clWhite
      else
        fcolor := clSilver;
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
      case Tag of
        0:
          dsurface.BoldText(SurfaceX(Left) + 20, SurfaceY(Top), '副将英雄以战士状态出战',
            fcolor, clBlack);
        1:
          dsurface.BoldText(SurfaceX(Left) + 20, SurfaceY(Top), '副将英雄以法师状态出战',
            fcolor, clBlack);
        2:
          dsurface.BoldText(SurfaceX(Left) + 20, SurfaceY(Top), '副将英雄以道士状态出战',
            fcolor, clBlack);
      end;
    end;
end;

procedure TFrmDlg.DHeroAttZhanshiClick(Sender: TObject; X, Y: Integer);
begin
  g_HeroAttectMode := (Sender as TDButton).Tag;
  FrmMain.SendChangeHeroAttectMode();
end;

procedure TFrmDlg.DStartTrainingDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with Sender as TDButton do
  begin
    DrawCaption := False;
    DefaultPaint(dsurface);
    if Downed then
      dsurface.BoldText(SurfaceX(Left) + 8, SurfaceY(Top) + 6, '开始修炼',
        clYellow, clBlack)
    else
      dsurface.BoldText(SurfaceX(Left) + 7, SurfaceY(Top) + 5, '开始修炼',
        clYellow, clBlack);
  end;
end;

procedure TFrmDlg.DHeroLeftSel2Click(Sender: TObject; X, Y: Integer);
begin
  if g_HeroAutoTrainingNum = 0 then
    g_HeroAutoTrainingNum := 2
  else
    Dec(g_HeroAutoTrainingNum);
end;

procedure TFrmDlg.DHeroRightSel2Click(Sender: TObject; X, Y: Integer);
begin
  if g_HeroAutoTrainingNum = 2 then
    g_HeroAutoTrainingNum := 0
  else
    Inc(g_HeroAutoTrainingNum);
end;

procedure TFrmDlg.DHintWindowCloseClick(Sender: TObject; X, Y: Integer);
begin
  DHintWindow.visible := False;
  DScreen.ClickItemHint.Clear;
end;

procedure TFrmDlg.DHintWindowCloseDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  ALeft, ATop: Integer;
  AColor: TColor;
begin
  with DHintWindowClose do
  begin
    AColor := $008ADAFF;
    if Moveed then
      AColor := $00008ACC;
    ALeft := SurfaceX(Left);
    ATop := SurfaceY(Top);
    dsurface.line(ALeft + 3, ATop + 7, ALeft + 11, ATop + 15, AColor);
    dsurface.line(ALeft + 4, ATop + 7, ALeft + 12, ATop + 15, AColor);
    dsurface.line(ALeft + 10, ATop + 7, ALeft + 2, ATop + 15, AColor);
    dsurface.line(ALeft + 11, ATop + 7, ALeft + 3, ATop + 15, AColor);
  end;
end;

procedure TFrmDlg.DHintWindowDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
begin
  with DHintWindow do
    DScreen.ClickItemHint.Draw(dsurface, SurfaceX(Left), SurfaceY(Top));
end;

procedure TFrmDlg.DHintWindowInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
begin
  with DHintWindow do
    IsRealArea := DScreen.ClickItemHint.InRealArea(LocalX(X), LocalY(Y));
end;

procedure TFrmDlg.DMentSay1DirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  sMsg: string;
  fcolor: Integer;
begin
  // with Sender as TDButton do
  // begin
  // case Tag of
  // 0:
  // begin
  // sMsg := '评定作用';
  // end;
  // 1:
  // begin
  // sMsg := '副将特色';
  // end;
  // 2:
  // begin
  // sMsg := '协同作战';
  // end;
  // 3:
  // begin
  // sMsg := '复仇模式';
  // end;
  // 4:
  // begin
  // sMsg := '宣布人选（最终结果）';
  // end;
  // end;
  // if Downed then
  // begin
  // fcolor := clRed;
  // DSurface.TextOut(sMsg, clRed, clBlack, SurfaceX(Left), SurfaceY(Top));
  // end
  // else if Moveed then
  // begin
  // fcolor := clGreen;
  // DSurface.TextOut(sMsg, clGreen, clBlack, SurfaceX(Left), SurfaceY(Top));
  // end
  // else
  // begin
  // fcolor := clYellow;
  // DSurface.TextOut(sMsg, clYellow, clBlack, SurfaceX(Left), SurfaceY(Top));
  // end;
  // with dsurface.Canvas do
  // begin
  // Pen.Color := fcolor;
  // MoveTo(SurfaceX(Left), SurfaceY(Top) + 12);
  // LineTo(SurfaceX(Left) + WIDTH, SurfaceY(Top) + 12);
  // Release;
  // end;
  // end;
end;

procedure TFrmDlg.DMentSay1Click(Sender: TObject; X, Y: Integer);
begin
  g_MentSayNum := TDButton(Sender).Tag;
end;

procedure TFrmDlg.DEShopAmountChange(Sender: TObject);
begin
  FShopAmount := Min(StrToIntDef(DEShopAmount.Text, 0), 100);
  DEShopAmount.Text := IntToStr(FShopAmount);
  DShopBuy.Enabled := FShopAmount > 0;
end;

procedure TFrmDlg.DExitCancelClick(Sender: TObject; X, Y: Integer);
begin
  DExitGame.Visible := False;
  RestoreHideControls();
end;

procedure TFrmDlg.DExitOkClick(Sender: TObject; X, Y: Integer);
begin
  DExitGame.Visible := False;
  RestoreHideControls();
  if DExitGame.Tag = 1 then
  begin
    frmMain.SendClientMessage(CM_SOFTCLOSE, 0, 0, 0, 0);
    DScreen.Finalize;
    g_Config.Save;
    PlayScene.ClearActors;
    frmMain.CloseAllWindows;
    FrmDlg.DBottom.Visible := False;
    g_SoftClosed := True;
    frmMain.ActiveCmdTimer(tcSoftClose);
    ClearRelation;
    ClearMissions;
    g_SoundManager.Stop;
  end else
  begin
    Application.Terminate;
  end;


end;

procedure TFrmDlg.DSighIconDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with Sender as TDButton do
  begin
    if Downed then
      DSighIcon.DefaultPaint(dsurface)
    else
    begin
      if GetTickCount - TimeTick > 200 then
      begin
        TimeTick := GetTickCount;
        if Tag = 2 then
          Tag := 0
        else
          Tag := 2;
      end;
      D := Propertites.Images.Images[Propertites.ImageIndex + Tag];
      if D <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D);
    end;
  end;
end;

procedure TFrmDlg.DSighIconMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  with DSighIcon do
    if Hint <> '' then
      DScreen.ShowHint(SurfaceX(Left), SurfaceY(Top + Height), Hint);
end;

procedure TFrmDlg.DSideBarButtonsClick(Sender: TObject; X, Y: Integer);
begin
  if (FSideButtonActive > -1) and
    (GetTickCount - DSideBarButtons.TimeTick > 300) then
  begin
    if (FSideButtons.Count > FSideButtonActive) and
      (FSideButtons.Names[FSideButtonActive] <> '') then
    begin
      FrmMain.SendSideButtonClick(FSideButtons.Names[FSideButtonActive]);
      DSideBarButtons.TimeTick := GetTickCount;
      g_SoundManager.DXPlaySound(s_glass_button_click);
    end;
  end;
end;

procedure TFrmDlg.DSideBarButtonsDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  I, L, T: Integer;
  D: TAsphyreLockableTexture;
begin
  L := DSideBarButtons.SurfaceX(DSideBarButtons.Left);
  T := DSideBarButtons.SurfaceY(DSideBarButtons.Top);
  for I := 0 to FSideButtons.Count - 1 do
  begin
    D := FontManager.Default.GetTextTexture(FSideButtons.ValueFromIndex[I]);
    if D <> nil then
    begin
      if FSideButtonActive = I then
      begin
        dsurface.FillRect(Rect(L, T, L + DSideBarButtons.WIDTH, T + 28),
          $00A2A5, $000408);
        dsurface.FillRect(Rect(L + 1, T + 1, L + DSideBarButtons.WIDTH - 1,
          T + 28 - 1), $00A2A5, $000408);
        dsurface.DrawBoldText(L + 8 + Ord(DSideBarButtons.Downed),
          T + (28 - D.Height) div 2 + Ord(DSideBarButtons.Downed), D, clWhite,
          FontBorderColor);
      end
      else
        dsurface.DrawBoldText(L + 8, T + (28 - D.Height) div 2, D, clWhite,
          FontBorderColor);
    end;
    T := T + 28;
  end;
end;

procedure TFrmDlg.DSideBarButtonsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  FSideButtonActive := (Y - DSideBarButtons.Top) div 28;
end;

procedure TFrmDlg.DSideBarDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
  L, T: Integer;
begin
  if FSideButtonExpand then
  begin
    L := DSideBar.SurfaceX(DSideBar.Left);
    T := DSideBar.SurfaceY(DSideBar.Top);
    D := g_77Images.Images[511];
    dsurface.Draw(D.ClientRect, Rect(L, T + 10, L + 118,
      T + DSideBar.Height - 20), D, clWhite4);
    D := g_77Images.Images[510];
    dsurface.Draw(L, T, D);
    D := g_77Images.Images[512];
    dsurface.Draw(L, T + DSideBar.Height - D.Height, D);
  end;
end;

procedure TFrmDlg.DSideBarInRealArea(Sender: TObject; X, Y: Integer;
  var IsRealArea: Boolean);
var
  D: TAsphyreLockableTexture;
begin
  if not FSideButtonExpand then
  begin
    IsRealArea := DButtonSideBar.InRange(X, Y);
  end;
end;

procedure TFrmDlg.DSideBarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  FSideButtonActive := -1;
end;

procedure TFrmDlg.DSighIconClick(Sender: TObject; X, Y: Integer);
begin
  if GetTickCount - DSighIcon.ClickTick > 1000 then
  begin
    FrmMain.SendSighIconMsg;
    DSighIcon.ClickTick := GetTickCount;
  end;
end;

procedure TFrmDlg.DBatterRandomDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  D: TAsphyreLockableTexture;
begin
  with Sender as TDButton do
  begin
    if Downed then
      D := Propertites.Images.Images[Propertites.ImageIndex + 1]
    else
      D := Propertites.Images.Images[Propertites.ImageIndex];
    if D <> nil then
    begin
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
    end;
    if Downed then
    begin
      if Sender = DBatterRandom then
      begin
        dsurface.BoldText(SurfaceX(Left) + 14 + 1, SurfaceY(Top) + 5, '随机',
          FAQColor, clBlack);
      end
      else if Sender = DBatterSort then
      begin
        dsurface.BoldText(SurfaceX(Left) + 8 + 1, SurfaceY(Top) + 5, '快捷键',
          FAQColor, clBlack);
      end;
    end
    else
    begin
      if Sender = DBatterRandom then
      begin
        dsurface.BoldText(SurfaceX(Left) + 14, SurfaceY(Top) + 4, '随机',
          FAQColor, clBlack);
      end
      else if Sender = DBatterSort then
      begin
        dsurface.BoldText(SurfaceX(Left) + 8, SurfaceY(Top) + 4, '快捷键',
          FAQColor, clBlack);
      end;
    end;
  end;
end;

procedure TFrmDlg.DBBuyAttGoldTypeClick(Sender: TObject; X, Y: Integer);
begin
  if DXPopupMenu.PopVisible then
    DXPopupMenu.HidePopup
  else
  begin
    DXPopupMenu.BeginUpdate;
    DXPopupMenu.Clear;
    DXPopupMenu.AddMenuItem(0, g_sGoldName);
    DXPopupMenu.AddMenuItem(1, g_sGameGoldName);
    DXPopupMenu.EndUpdate;
    DXPopupMenu.Popup(DMailWriter, DBBuyAttGoldType.Left - 40,
      DBBuyAttGoldType.Top + DBBuyAttGoldType.Height,
      40 + DBBuyAttGoldType.WIDTH, procedure(ATag: Integer;
      const ACaption: String)begin FBuyAttGoldType := ATag; end);
  end;
end;

procedure TFrmDlg.DBChatHistoryScrollBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FChatScrollY := Y;
end;

procedure TFrmDlg.DBChatHistoryScrollBarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  _Top: Integer;
  H: Single;
begin
  if FChatLock then
    Exit;
  if DBChatHistoryScrollBar.Downed then
  begin
    H := (DBChatHistoryScrollBottom.Top - DBChatHistoryScrollTop.Top -
      DBChatHistoryScrollTop.Height - DBChatHistoryScrollBar.Height) /
      DScreen.ChatHisMessage.Count;
    DBChatHistoryScrollBar.Top := DBChatHistoryScrollBar.Top + Y - FChatScrollY;
    if DBChatHistoryScrollBar.Top < DBChatHistoryScrollTop.Top +
      DBChatHistoryScrollTop.Height then
      DBChatHistoryScrollBar.Top := DBChatHistoryScrollTop.Top +
        DBChatHistoryScrollTop.Height
    else if DBChatHistoryScrollBar.Top > DBChatHistoryScrollBottom.Top -
      DBChatHistoryScrollBar.Height then
      DBChatHistoryScrollBar.Top := DBChatHistoryScrollBottom.Top -
        DBChatHistoryScrollBar.Height;
    _Top := Round((DBChatHistoryScrollBar.Top - DBChatHistoryScrollTop.Top -
      DBChatHistoryScrollTop.Height) / H);
    if _Top < 0 then
      _Top := 0
    else if _Top > DScreen.ChatHisMessage.Count - 1 then
      _Top := DScreen.ChatHisMessage.Count - 1;
    DScreen.ChatHisMessage.TopLine := _Top;
    DScreen.ChatHisMessage.UpdateTopLine;
    FChatScrollY := Y;
  end;
end;

procedure TFrmDlg.DBChatHistoryScrollBottomMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_CHATHISBOX;
  ScrollTimer.Enabled := True;
  ScrollTimer.Tag := 2;
end;

procedure TFrmDlg.DBChatHistoryScrollTopMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FScrollType := _ST_CHATHISBOX;
  ScrollTimer.Enabled := True;
  ScrollTimer.Tag := 1;
end;

procedure TFrmDlg.DBChatHistoryScrollTopMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ScrollTimer.Enabled := False;
end;

procedure TFrmDlg.DBCloseMailClick(Sender: TObject; X, Y: Integer);
begin
  DMailList.visible := False;
end;

procedure TFrmDlg.DBCloseMissionsClick(Sender: TObject; X, Y: Integer);
begin
  DWMissions.visible := False;
end;

procedure TFrmDlg.DBCloseReaderClick(Sender: TObject; X, Y: Integer);
begin
  DMailReader.visible := False;
end;

procedure TFrmDlg.DBCloseWriterClick(Sender: TObject; X, Y: Integer);
begin
  DMailWriter.visible := False;
end;

procedure TFrmDlg.DBatterPopMenuDirectPaint(Sender: TObject;
  dsurface: TAsphyreCanvas);
var
  pcm: pTClientMagic;
  D: TAsphyreLockableTexture;
  I: Integer;
  H, len: Word;
  S: string;
begin
  // with Sender as TDButton do
  // begin
  // if not Moveed then
  // BatterSelMenu := 0;
  // h := Height div 6;
  // D := Propertites.Images.Images[Propertites.ImageIndex];
  // if D <> nil then
  // begin
  // dsurface.Draw(SurfaceX(Left), SurfaceY(Top), D.ClientRect, D, True);
  // end;
  // with dsurface.Canvas do
  // begin
  // if BatterSelMenu > 0 then
  // begin
  // Brush.Color := clBlue;
  // FillRect(Rect(SurfaceX(Left) + 8, SurfaceY(Top) + ((BatterSelMenu - 1) * h) + 1, SurfaceX(Left) + WIDTH - 8, SurfaceY(Top) + BatterSelMenu * h - 1));
  // Release; // 释放
  // end;
  // for I := 0 to g_BatterMenuNameList.Count - 1 do
  // begin
  // S := g_BatterMenuNameList.Strings[I];
  // len := (WIDTH - TextWidth(S)) div 2;
  // Release;
  // if (BatterSelMenu > 0) and (I = BatterSelMenu - 1) then
  // clFunc.TextOut(dsurface, SurfaceX(Left) + len, SurfaceY(Top) + (I * h) + 3, clWhite, S)
  // else
  // clFunc.TextOut(dsurface, SurfaceX(Left) + len, SurfaceY(Top) + (I * h) + 3, RGB(189, 162, 123), S);
  // end;
  // end;
  // end;
end;

procedure TFrmDlg.DBatterPopMenuMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  len: Word;
begin
  with Sender as TDButton do
  begin
    len := Height div 6;
    if (Y > 97) then
    begin
      if Y < 97 + len * 1 then
        BatterSelMenu := 1
      else if Y < 97 + len * 2 then
        BatterSelMenu := 2
      else if Y < 97 + len * 3 then
        BatterSelMenu := 3
      else if Y < 97 + len * 4 then
        BatterSelMenu := 4
      else if Y < 97 + len * 5 then
        BatterSelMenu := 5
      else if Y < 97 + len * 6 then
        BatterSelMenu := 6;
    end;
  end;
end;

procedure TFrmDlg.DBatterPopMenuClick(Sender: TObject; X, Y: Integer);
var
  n, I, K: Integer;
  S: string;
  function GetMagicIDByName(MagicName: string): Integer;
  begin
    Result := -1;
    if MagicName = '' then
      Exit;
    if MagicName = '空' then
      Result := 0;
    if MagicName = '随机' then
      Result := 2222;
    if MagicName = '三绝杀' then
      Result := 76;
    if MagicName = '双龙破' then
      Result := 77;
    if MagicName = '虎啸诀' then
      Result := 78;
    if MagicName = '追心刺' then
      Result := 79;
    if MagicName = '凤舞祭' then
      Result := 80;
    if MagicName = '八卦掌' then
      Result := 81;
    if MagicName = '断岳斩' then
      Result := 82;
    if MagicName = '惊雷爆' then
      Result := 83;
    if MagicName = '三焰咒' then
      Result := 84;
    if MagicName = '横扫千军' then
      Result := 85;
    if MagicName = '冰天雪地' then
      Result := 86;
    if MagicName = '万剑归宗' then
      Result := 87;
  end;
  function FindBatterSpell(MagicID: Word): Boolean;
  var
    I, J, cTag, K, flag: Integer;
    pm: pTClientMagic;
  begin
    Result := True;
    flag := 0;
    try
      for I := 0 to g_BatterMagicList.Count - 1 do
      begin
        pm := g_BatterMagicList[I];
        if (pm <> nil) and (pm.wMagicId = MagicID) then
        begin
          flag := 8;
          for J := 0 to 2 do
          begin // 寻早有没有，和自己按钮相同的  20091218 邱高奇
            K := g_BatterOrder[J];
            if (K <> 0) and (K = MagicID) then
            begin
              g_BatterOrder[J] := 0; // 20100329 新增直接为0
              flag := 9;
              Break;
            end;
          end;
        end;
      end;
      if (flag = 0) or (flag = 9) then
        Result := False;
    except
    end;
  end;

begin
  try
    with Sender as TDButton do
    begin
      n := TDButton(Tag).Tag;
      if (BatterSelMenu > 0) and
        (g_BatterMenuNameList.Count >= BatterSelMenu) then
      begin
        S := g_BatterMenuNameList.Strings[BatterSelMenu - 1];
        if Trim(S) <> '' then
        begin
          K := GetMagicIDByName(Trim(S));
          if K > -1 then
          begin
            FindBatterSpell(K);
            g_BatterOrder[n] := K;
            FrmMain.SendSetBatterOrder();
          end;
        end;
        visible := False;
      end;
    end;
  except

  end;
end;

procedure TFrmDlg.BatterSkill1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sMsg: string;
begin
  with Sender as TDButton do
  begin
    case Tag of
      0:
        sMsg := '连击第1招，\可增加暴击率10%\点击可编辑连击招式';
      1:
        sMsg := '连击第2招，\可增加暴击率15%\点击可编辑连击招式';
      2:
        sMsg := '连击第3招，\可增加暴击率25%\点击可编辑连击招式';
    end;
    DScreen.ShowHint(SurfaceX(Left) - 120, SurfaceY(Top), sMsg,
      clYellow, False);
  end;
end;

procedure TFrmDlg.DSWZodiacOtherClick(Sender: TObject; X, Y: Integer);
begin
  if Sender = DSWZodiacOther then
  begin
    frmViewOtherNewItem.DZodiacSigns.visible :=
      not frmViewOtherNewItem.DZodiacSigns.visible;
  end
  else
  begin
    frmViewOtherNewItem.DJewelryBox.visible :=
      not frmViewOtherNewItem.DJewelryBox.visible;;
  end;

end;

procedure TFrmDlg.DTabGameShopTypeTabChange(Sender: TDControl; SourceIndex,
  Index: Integer);
var
  msg: TDefaultMessage;
begin
 // g_SoundManager.DXPlaySound(s_norm_button_click);
  ShopKind := Index;
  ClearShopItems;
  ClearShopSpeciallyItems;
  ShopTabPage := 0;
  g_ShopItem.Name := '';
  msg := MakeDefaultMsg(CM_OPENSHOP, 0, 0 { 页数 } , 0 { ShopType } , ShopKind,
    FrmMain.Certification);
  FrmMain.SendSocket(msg);
  g_ShopTypePage := 0;
  g_ShopPage := 0;
  FShopAmount := 0;
  DEShopAmount.Text := '0';
end;

procedure TFrmDlg.DTItemNameDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
 Tex : TuTexture;
 nX,nY : Integer;
begin
  Tex := Textures.ObjectName(DSurface,g_MarketItem.Item.Item.DisplayName);

  nX := DTItemName.SurfaceX(DTItemName.Left);
  nY := DTItemName.SurfaceY(DTItemName.Top);

  nX := nX + (DTItemName.Width - Tex.Width) div 2;
  Tex.Draw(DSurface,nX,nY,DTItemName.Propertites.Caption.Color);

end;

procedure TFrmDlg.DTMySelfNameDirectPaint(Sender: TObject;
  DSurface: TAsphyreCanvas);
var
 Tex : TuTexture;
 nX,nY : Integer;
 Actor : TActor;
begin
  Actor := g_MySelf;
  if ((Pos('{',Actor.m_sUserName) > 0) and (Pos('}',Actor.m_sUserName) > 0)) then
  begin
    DTMySelfName.DefaultDraw := False;
    Tex := Textures.ObjectName(DSurface,Actor.m_sUserName);
    nX := DTMySelfName.SurfaceX(DTMySelfName.Left);
    nY := DTMySelfName.SurfaceY(DTMySelfName.Top);

    nX := nX + (DTMySelfName.Width - Tex.Width) div 2;
    Tex.Draw(DSurface,nX,nY,clSilver);
  end else
  begin
    DTMySelfName.DefaultDraw := True;
  end;
end;

procedure InitVarTextField();
begin
  ExtUI.GetVarTextFieldFunc := GetDVarValue;
  AddDVarTextList('$HP', tbInt, @g_MyAbil.HP);
  AddDVarTextList('$HPMAX', tbInt, @g_MyAbil.MaxHP);
  AddDVarTextList('$MP', tbInt, @g_MyAbil.MP);
  AddDVarTextList('$MPMAX', tbInt, @g_MyAbil.MaxMP);
  AddDVarTextList('$LEVEL', tbInt, @g_MyAbil.Level);
  AddDVarTextList('$EXP', tbuInt, @g_MyAbil.Exp);
  AddDVarTextList('$MAXEXP', tbuInt, @g_MyAbil.MaxExp);
  AddDVarTextList('$DC', tbInt, @g_MyAbil.DCMin);
  AddDVarTextList('$DCMAX', tbInt, @g_MyAbil.DCMax);
  AddDVarTextList('$AC', tbInt, @g_MyAbil.ACMin);
  AddDVarTextList('$ACMAX', tbInt, @g_MyAbil.ACMax);
  AddDVarTextList('$MAC', tbInt, @g_MyAbil.MACMin);
  AddDVarTextList('$MACMAX', tbInt, @g_MyAbil.MACMax);
  AddDVarTextList('$MC', tbInt, @g_MyAbil.MCMin);
  AddDVarTextList('$MCMAX', tbInt, @g_MyAbil.MCMax);
  AddDVarTextList('$SC', tbInt, @g_MyAbil.SCMin);
  AddDVarTextList('$SCMAX', tbInt, @g_MyAbil.SCMax);
  AddDVarTextList('$PC', tbInt, @g_MyAbil.PCMin);
  AddDVarTextList('$PCMAX', tbInt, @g_MyAbil.PCMax);
  AddDVarTextList('$TC', tbInt, @g_MyAbil.TCMin);
  AddDVarTextList('$TCMAX', tbInt, @g_MyAbil.TcMax);
  AddDVarTextList('$WC', tbInt, @g_MyAbil.WCMin);
  AddDVarTextList('$WCMAX', tbInt, @g_MyAbil.WCMax);
  AddDVarTextList('$SPEED', tbWord, @g_MySubAbility.SpeedPoint);
  AddDVarTextList('$HIT', tbWord, @g_MySubAbility.HitPoint);
  AddDVarTextList('$WEIGHT', tbWord, @g_MyAbil.Weight);
  AddDVarTextList('$WEIGHTMAX', tbWord, @g_MyAbil.MaxWeight);
  AddDVarTextList('$WEARWEIGHT', tbWord, @g_MyAbil.WearWeight);
  AddDVarTextList('$WEARWEIGHTMAX', tbWord, @g_MyAbil.MaxWearWeight);
  AddDVarTextList('$HANDWEIGHT', tbWord, @g_MyAbil.HandWeight);
  AddDVarTextList('$HANDWEIGHTMAX', tbWord, @g_MyAbil.MaxHandWeight);
  AddDVarTextList('$FIGHTPOWER', tbInt64, @g_MyMixedAbility);
  AddDVarTextList('$ANTIMAGIC', tbWord, @g_MySubAbility.AntiMagic);
  AddDVarTextList('$ANTIPOISON', tbWord, @g_MySubAbility.AntiPoison);
  AddDVarTextList('$POISONRECOVER', tbWord, @g_MySubAbility.PoisonRecover);
  AddDVarTextList('$HEALTHRECOVER', tbWord, @g_MySubAbility.HealthRecover);
  AddDVarTextList('$SPELLRECOVER', tbWord, @g_MySubAbility.SpellRecover);
  AddDVarTextList('$ABSORBING', tbWord, @g_MySubAbility.Absorbing);
  AddDVarTextList('$REBOUND', tbWord, @g_MySubAbility.Rebound);
  AddDVarTextList('$ATTACKADD', tbWord, @g_MySubAbility.AttackAdd);
  AddDVarTextList('$PUNCHHIT', tbWord, @g_MySubAbility.PunchHit);
  AddDVarTextList('$CRITICALHIT', tbWord, @g_MySubAbility.CriticalHit);
  AddDVarTextList('$EXPADDRATE', tbWord, @g_MySubAbility.ExpAdd);
  AddDVarTextList('$ITEMDROPADDRATE', tbWord, @g_MySubAbility.ItemAdd);
  AddDVarTextList('$GOLDDROPADDRATE', tbWord, @g_MySubAbility.GoldAdd);
  AddDVarTextList('$APPENDDAMAGE', tbWord, @g_MySubAbility.AppendDamage);
  AddDVarTextList('$HPMAXRATE', tbWord, @g_MySubAbility.HPMaxRate);
  AddDVarTextList('$MPMAXRATE', tbWord, @g_MySubAbility.MPMaxRate);
  AddDVarTextList('$LUCKY', tbShortInt, @g_MySubAbility.Lucky);
  AddDVarTextList('$HITSPEED', tbHitSpeed, nil);
  AddDVarTextList('$PUNCHITAPPENDDAMAGE', tbInt,
    @g_MySubAbility.PunchHitAppendDamage);
  AddDVarTextList('$CRITICALHITAPPENDDAMAGE', tbInt,
    @g_MySubAbility.CriticalHitAppendDamage);
  AddDVarTextList('$CREDITPOINT', tbInt, @g_MySubAbility.CreditPoint);
  AddDVarTextList('$GOLD', tbInt, @g_nGold);
  AddDVarTextList('$GAMEGOLD', tbuInt, @g_dwGameGold);
  AddDVarTextList('$GAMEPOINT', tbInt, @g_nGamePoint);
  AddDVarTextList('$GAMEDIAMOND', tbInt, @g_nGameDiaMond);
  AddDVarTextList('$GAMEGIRD', tbInt, @g_nGameGird);
  AddDVarTextList('$GAMEGLORY', tbInt, @g_nGameGlory);
  AddDVarTextList('$JOB', tbString, @g_JobName);
  AddDVarTextList('$USERNAME', tbMyName, nil);

  AddDVarTextList('$MAPNAME',tbString,@g_sMapTitle);
  AddDVarTextList('$MAPX',tbMapX,nil);
  AddDVarTextList('$MAPY',tbMapY,nil);
  AddDVarTextList('$GOLD_V',tbGoldV,nil);
  AddDVarTextList('$GAMEGOLD_V',tbGameGoldV,nil);

  AddDVarTextList('$STALLGAMEGOLDCOMMISSION',tbInt,@g_StallGameGoldCommission);
  AddDVarTextList('$STALLGOLDCOMMISSION',tbInt,@g_StallGoldCommission);
  AddDVarTextList('$RELEVEL',tbByte,@g_MySubAbility.ReLevel);

  //他人的信息
  AddDVarTextList('$HP_T',tbInt,@UserState1.m_Abil.HP);
  AddDVarTextList('$HPMAX_T',tbInt,@UserState1.m_Abil.MaxHP);
  AddDVarTextList('$MP_T',tbInt,@UserState1.m_Abil.MP);
  AddDVarTextList('$MPMAX_T',tbInt,@UserState1.m_Abil.MaxMP);
  AddDVarTextList('$LEVEL_T',tbInt,@UserState1.m_Abil.Level);
  AddDVarTextList('$EXP_T',tbuInt,@UserState1.m_Abil.Exp);
  AddDVarTextList('$MAXEXP_T',tbuInt,@UserState1.m_Abil.MaxExp);
  AddDVarTextList('$DC_T',tbInt,@UserState1.m_Abil.DCMin);
  AddDVarTextList('$DCMAX_T',tbInt,@UserState1.m_Abil.DCMax);
  AddDVarTextList('$AC_T',tbInt,@UserState1.m_Abil.ACMin);
  AddDVarTextList('$ACMAX_T',tbInt,@UserState1.m_Abil.ACMax);
  AddDVarTextList('$MAC_T',tbInt,@UserState1.m_Abil.MACMin);
  AddDVarTextList('$MACMAX_T',tbInt,@UserState1.m_Abil.MACMax);
  AddDVarTextList('$MC_T',tbInt,@UserState1.m_Abil.MCMin);
  AddDVarTextList('$MCMAX_T',tbInt,@UserState1.m_Abil.MCMax);
  AddDVarTextList('$SC_T',tbInt,@UserState1.m_Abil.SCMin);
  AddDVarTextList('$SCMAX_T',tbInt,@UserState1.m_Abil.SCMax);
  AddDVarTextList('$PC_T',tbInt,@UserState1.m_Abil.PcMin);
  AddDVarTextList('$PCMAX_T',tbInt,@UserState1.m_Abil.PcMax);
  AddDVarTextList('$TC_T',tbInt,@UserState1.m_Abil.TcMin);
  AddDVarTextList('$TCMAX_T',tbInt,@UserState1.m_Abil.TcMin);
  AddDVarTextList('$WC_T',tbInt,@UserState1.m_Abil.WcMin);
  AddDVarTextList('$WCMAX_T',tbInt,@UserState1.m_Abil.WcMax);
  AddDVarTextList('$SPEED_T',tbWord,@g_MySubAbility.SpeedPoint);
  AddDVarTextList('$HIT_T',tbWord,@g_MySubAbility.HitPoint);
  AddDVarTextList('$WEIGHT_T',tbWord,@UserState1.m_Abil.Weight);
  AddDVarTextList('$WEIGHTMAX_T',tbWord,@UserState1.m_Abil.MaxWeight);
  AddDVarTextList('$WEARWEIGHT_T',tbWord,@UserState1.m_Abil.WearWeight);
  AddDVarTextList('$WEARWEIGHTMAX_T',tbWord,@UserState1.m_Abil.MaxWearWeight);
  AddDVarTextList('$HANDWEIGHT_T',tbWord,@UserState1.m_Abil.HandWeight);
  AddDVarTextList('$HANDWEIGHTMAX_T',tbWord,@UserState1.m_Abil.MaxHandWeight);
  AddDVarTextList('$FIGHTPOWER_T',tbInt64,@UserFightPower);
  AddDVarTextList('$ANTIMAGIC_T',tbWord,@UserState1.m_SubAbility.AntiMagic);
  AddDVarTextList('$ANTIPOISON_T',tbWord,@UserState1.m_SubAbility.AntiPoison);
  AddDVarTextList('$POISONRECOVER_T',tbWord,@UserState1.m_SubAbility.PoisonRecover);
  AddDVarTextList('$HEALTHRECOVER_T',tbWord,@UserState1.m_SubAbility.HealthRecover);
  AddDVarTextList('$SPELLRECOVER_T',tbWord,@UserState1.m_SubAbility.SpellRecover);
  AddDVarTextList('$ABSORBING_T',tbWord,@UserState1.m_SubAbility.Absorbing);
  AddDVarTextList('$REBOUND_T',tbWord,@UserState1.m_SubAbility.Rebound);
  AddDVarTextList('$ATTACKADD_T',tbWord,@UserState1.m_SubAbility.AttackAdd);
  AddDVarTextList('$PUNCHHIT_T',tbWord,@UserState1.m_SubAbility.PunchHit);
  AddDVarTextList('$CRITICALHIT_T',tbWord,@UserState1.m_SubAbility.CriticalHit);
  AddDVarTextList('$EXPADDRATE_T',tbWord,@UserState1.m_SubAbility.ExpAdd);
  AddDVarTextList('$ITEMDROPADDRATE_T',tbWord,@UserState1.m_SubAbility.ItemAdd);
  AddDVarTextList('$GOLDDROPADDRATE_T',tbWord,@UserState1.m_SubAbility.GoldAdd);
  AddDVarTextList('$APPENDDAMAGE_T',tbWord,@UserState1.m_SubAbility.AppendDamage);
  AddDVarTextList('$HPMAXRATE_T',tbWord,@UserState1.m_SubAbility.HPMaxRate);
  AddDVarTextList('$MPMAXRATE_T',tbWord,@UserState1.m_SubAbility.MPMaxRate);
  AddDVarTextList('$PUNCHITAPPENDDAMAGE_T',tbInt,@UserState1.m_SubAbility.PunchHitAppendDamage);
  AddDVarTextList('$CRITICALHITAPPENDDAMAGE_T',tbInt,@UserState1.m_SubAbility.CriticalHitAppendDamage);
  AddDVarTextList('$CREDITPOINT_T',tbInt,@UserState1.m_SubAbility.CreditPoint);

end;

function GetDVarValue(Sender : TDVarTextField; Const VarName:String):string;
var
  D:TDVarTextDataType;
  Value_Int64:Int64;
begin
  Result := '';
  if VarTextCaption.TryGetValue(VarName,D) then
  begin
     case D.DataType of
       tbInt,
       tbuInt,
       tbWord,
       tbByte,
       tbInt64,
       tbShortInt:
       begin
         case D.DataType of
           tbShortInt : Value_Int64 := PShortInt(D.Data)^;
           tbInt : Value_Int64 := PInteger(D.Data)^;
           tbuInt :Value_Int64 := PCardinal(D.Data)^;
           tbWord : Value_Int64 := PWord(D.Data)^;
           tbByte : Value_Int64 := PByte(D.Data)^;
           tbInt64: Value_Int64 := PInt64(D.Data)^;
         end;
         if Sender.Propertites.QuteNumber then
           Result := GetGoldStr(Value_Int64)
         else
           Result := IntToStr(Value_Int64);
       end;
       tbString:
       begin
         Result := PString(D.Data)^;
       end;
       tbMyName :
       begin
         if g_MySelf <> nil then
         begin
           Result := g_MySelf.m_sUserName;
         end else
         begin
           Result := '';
         end;
       end;
       tbMapX :
       begin
         if g_MySelf <> nil then
         begin
           Result := IntToStr(g_MySelf.m_nCurrX);
         end else
         begin
           Result := '';
         end;
       end;
       tbMapY:
       begin
         if g_MySelf <> nil then
         begin
           Result := IntToStr(g_MySelf.m_nCurrY);
         end else
         begin
           Result := '';
         end;
       end;
       tbGameGoldV:
       begin
         Result := GetGoldStr(g_dwGameGold)
       end;
       tbGoldV:
       begin
         Result := GetGoldStr(g_nGold);
       end;
       tbHitSpeed:
       begin
         Result := '0';
         if g_MySelf <> nil then
         begin
           Result := IntToStr(g_MySelf.m_nHitSpeed)
         end;
       end;
     end;
  end;
end;


initialization
  VarTextCaption := TDictionary<string,TDVarTextDataType>.Create(256);
finalization
  VarTextCaption.Free;

end.
