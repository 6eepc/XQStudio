///////////////////////////////////////////////////////////////////////////////
//
// XQStduio Source Code (http://www.qipaile.net/xqstudio)
//
// Copyright (c) 1998-2008, DONG Shiwei (����ΰ or ������)
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 
//    1) Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//    2) Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer
//       in the documentation and/or other materials provided with the
//       distribution.
//    3) Neither the name of the XQStudio nor the names of its contributors
//       may be used to endorse or promote products derived from this
//       software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
// TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
///////////////////////////////////////////////////////////////////////////////
//
// Note: Some characters of this file are Simplified Chinese characters 
//       encoded with GB2312/GB18030 standard
//

unit XQSystem;

//-------------------------------------------------------------------------
//
//.........................................................................
interface

//-------------------------------------------------------------------------
//
//.........................................................................
uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, dDelphiS, XQDataT, XQPNode, XQRecLBX;

//-------------------------------------------------------------------------
//  ���Ͷ���
//.........................................................................
type

  //-----------------------------------------------------------------------
  // ������������
  //.......................................................................
  dTXQZ = class
    Index       : dTINT32;      // ��������
    Name        : String[16];   // ��������
    Picture     : TPicture;     // ����ͼ��
    Arms        : 1..7;         // ����,����Ϊ:������ʿ���ڱ�
    XYStart     : dTBYTE;       // ���ӵĿ���λ��(ָԭʼλ��)
    XY          : dTBYTE;       // ���ӵ�λ��(ָ�����������ϵ�ǰ��λ��)
   public
    constructor Create(iIdx:dTINT32; sName:String; pic:TPicture;
                       iArms:dTBYTE; bXYStart:dTBYTE);
  end;

  //-----------------------------------------------------------------------
  // ���������ʱ��
  //.......................................................................
  dTXQCLOCK = class
    Name        : String[16];
  public
    constructor Create;
    destructor Destroy; override;
  end;



  //-----------------------------------------------------------------------
  // ����������
  //.......................................................................
  dTXiangQi = class
  public
    BoardImage  : TImage;                       // ������ͼ��
    BoardXY     : dTXQPXY;                      // ����9x10�������
    QiziMoveImg : TImage;                       // �ƶ������ӵ�ͼ��
                                                // ���������ƶ�
    Qizi        : array [1..32] of dTXQZ;       // 32��������
    QiziMove    : dTXQZ;                        // �������ƶ�������
    MovePosFrom : TImage;                       // ����ƶ��������ӵ�λ��
    MovePosTo   : TImage;                       //   ������ʾ����ָʾ
    Clock       : dTXQCLOCK;                    // ��ʱ��
    RedPlayer   : String[32];                   // �췽����
    BlkPlayer   : String[32];                   // �ڷ�����
    RecListBox  : TListBox;                     // ���׼�¼�б��
    VarListBox  : TListBox;                     // ���ż�¼�б��
    isAddVarStep: dTBoolean;                    // �Ƿ��Ǽ������״̬
    RecMemo     : TMemo;                        // ע�ⱸע
    isMemoEdit  : dTBoolean;
    PlayStepNo  : dTINT32;                      // ��ǰ������ܲ���
    DispStepNo  : dTINT32;                      // ��ǰ��ʾ����Ļ�ǵڼ�����
    PlayNode    : dTXQPlayNode;                 // ��ǰ���һ����Ľڵ�
    DispNode    : dTXQPlayNode;                 // ��ǰ������ʾ����Ľڵ�
    WhoPlay     : dTWHOPLAY;                    // �ֵ�˭��
    ReverseH    : Boolean;                      // ���ҶԻ���־
    PlayRec     : array [0..dCMaxRecNo] of dTXQPlayNode; // �����¼(����)
    PlayVar     : array [0..dCMaxVarNo] of dTXQPlayNode;
    PlayTree    : dTXQPlayNode;                 // ������
    PlayRecHook : procedure;
    RefreshHook : procedure;

    //XQRecLBX    : dTXQRecListBox;
  private
    function sGetFMTRecStr(PN: dTXQPlayNode): string;

  public
    constructor Create(imgBoard: TImage; imgXY: dTXQPXY; imgQZMove: TImage;
                       imgMovePosF, imgMovePosT:TImage; picQZ:dTXQZPIC;
                       lbxRec,lbxOther:TListBox; memRec: TMemo); overload;
    constructor Create(imgBoard:TImage;imgXY:dTXQPXY;imgQZMove:TImage;
                       imgMovePosF, imgMovePosT:TImage;picQZ:dTXQZPIC;
                       lbxRec,lbxOther:TListBox;
                       memRec:TMemo;XQZXY:dTXQZXY); overload;
    destructor Destroy; override;

    procedure dStartMoveFromXY(XY:dTBYTE);      // ��XY����ʼ�ƶ�����
    procedure dStopMoveAtXY(XY:dTBYTE);         // �ƶ�ֹͣ��XY��
    function  isMoveToValid(XY:dTBYTE; var sPlayRec:String):dTBOOLEAN;
                // �ж��ƶ��Ƿ�Ϻ�����, sPlayRec ��¼��������

//    function  GetPlayRecStr(qzXY:dTXQZXY; WP:dTWhoPlay;
//                            XYf,XYt:dTBYTE):string;
    procedure dUndoMove;                        // ȡ���ƶ�
    function  iQiziIndexAtXY(XY:dTBYTE):dTINT32;// ȡXY��������������
    function  isPlayOneStepOK(XYf, XYt: dTBYTE): dTBOOLEAN;
                // �жϴ�XYf�ƶ���XYt�Ƿ�Ϻ�����, ���Ϻ�����,����ִ��
    procedure dEnablePlayer(WP:dTWHOPLAY); overload; // ����һ������
    procedure dEnablePlayer(PN:dTXQPlayNode); overload;
    procedure dDeleteOnePlayRec(bRefresh: Boolean=True); // ɾ�����һ���Ծּ�¼
    procedure dDeleteOnePlayNode;               // ɾ���ո��߹���һ����Ľڵ�
    procedure dDeletePlayVar(PN:dTXQPlayNode);
    procedure dRefreshBoard(ReStart:Boolean);
                // ˢ�µ�ǰ���, Restart = True ��ʾ�ӵ�0����ʼ(��λ)
    procedure dDispQiziAtRecNo(iRec: dTINT32);  // ��ʾiRec�������
    procedure dMoveMemoToRecNo(iRec:dTINT32);   // ��ע������Ծּ�¼
    procedure dLoadMemoFromRecNo(iRec:dTINT32); // ����¼�е�ע����ʾ����
    function  isHighlightVarStepActive: Boolean;
    procedure dMovePlayVarUp;
    procedure dMovePlayVarDown;

    procedure dDispVarStepAtRecNo(iRec:dTInt32);
    procedure dLoadAllRecForPlayNode(PN:dTXQPlayNode);
    procedure dAddPlayNodeIntoPlayRec(PN:dTXQPlayNode);
    procedure dOnRecListBoxClick;               // ��Ӧ������ּ�¼�¼�
    procedure dOnVarListBoxDblClick;
    procedure dOnRecMemoChange;
    procedure dRefreshRecStr;
//    procedure dReverseBoard;                    // ���̵�ת180��
  end;

const
dCXqzXY: dTXQZXY = (80,70,60,50,40,30,20,10,00,72,12,83,63,43,23,03,
                      09,19,29,39,49,59,69,79,89,17,77,06,26,46,66,86);


var
  IsAutoPlaying: Boolean = False;

///////////////////////////////////////////////////////////////////////////
implementation

//-------------------------------------------------------------------------
//
//.........................................................................
constructor dTXQZ.Create(iIdx:dTINT32; sName:String; pic:TPicture;
                         iArms:dTBYTE; bXYStart:dTBYTE);
begin
  Name := sName;  Picture := pic;  Arms := iArms; XYStart := bXYStart;
end;

//-------------------------------------------------------------------------
//
//.........................................................................
constructor dTXQCLOCK.Create;
begin
  ShowMessage('XQCLOCK Create');
end;

destructor dTXQCLOCK.Destroy;
begin

end;


//-------------------------------------------------------------------------
// ������Ĺ��캯��
//.........................................................................
constructor dTXIANGQI.Create(imgBoard:TImage;imgXY:dTXQPXY;imgQZMove:TImage;
                             imgMovePosF,imgMovePosT:TImage;picQZ:dTXQZPIC;
                             lbxRec,lbxOther:TListBox;
                             memRec:TMemo; XQZXY:dTXQZXY);
var
  i, j: dTINT32;
begin
  BoardImage := imgBoard;                       // ����ͼƬ

  for i:=0 to 8 do for j:=0 to 9 do             // �����������е�'��վ'
  begin
    BoardXY[i,j]         := imgXY[i, j];
    BoardXY[i,j].Tag     := i*10 + j;           // Tag �д���'��վ'����
    BoardXY[i,j].Picture := nil;
  end;

  QiziMoveImg := imgQZMove;                     // �����ƶ������ӵ�ͼƬ

  QiziMove    := nil;                           // �����ƶ�������

  MovePosFrom         := imgMovePosF;
  MovePosTo           := imgMovePosT;           // ����ƶ������ӵ�ָʾ
  MovePosTo.Visible   := False;                 // �ص�����ָʾ
  MovePosFrom.Visible := False;

  // ����32��������(��ҪQiziPic����)
  QiZi[ 1] := dTXQZ.Create( 1, '��', picQZ[ 1], 1, 80); // Red
  QiZi[ 2] := dTXQZ.Create( 2, '��', picQZ[ 2], 2, 70);
  QiZi[ 3] := dTXQZ.Create( 3, '��', picQZ[ 3], 3, 60);
  QiZi[ 4] := dTXQZ.Create( 4, 'ʿ', picQZ[ 4], 4, 50);
  QiZi[ 5] := dTXQZ.Create( 5, '˧', picQZ[ 5], 5, 40);
  QiZi[ 6] := dTXQZ.Create( 6, 'ʿ', picQZ[ 4], 4, 30);
  QiZi[ 7] := dTXQZ.Create( 7, '��', picQZ[ 3], 3, 20);
  QiZi[ 8] := dTXQZ.Create( 8, '��', picQZ[ 2], 2, 10);
  QiZi[ 9] := dTXQZ.Create( 9, '��', picQZ[ 1], 1, 00);
  QiZi[10] := dTXQZ.Create(10, '��', picQZ[ 6], 6, 72);
  QiZi[11] := dTXQZ.Create(11, '��', picQZ[ 6], 6, 12);
  QiZi[12] := dTXQZ.Create(12, '��', picQZ[ 7], 7, 83);
  QiZi[13] := dTXQZ.Create(13, '��', picQZ[ 7], 7, 63);
  QiZi[14] := dTXQZ.Create(14, '��', picQZ[ 7], 7, 43);
  QiZi[15] := dTXQZ.Create(15, '��', picQZ[ 7], 7, 23);
  QiZi[16] := dTXQZ.Create(16, '��', picQZ[ 7], 7, 03);
  QiZi[17] := dTXQZ.Create(17, '��', picQZ[ 8], 1, 09); // Blk
  QiZi[18] := dTXQZ.Create(18, '��', picQZ[ 9], 2, 19);
  QiZi[19] := dTXQZ.Create(19, '��', picQZ[10], 3, 29);
  QiZi[20] := dTXQZ.Create(20, 'ʿ', picQZ[11], 4, 39);
  QiZi[21] := dTXQZ.Create(21, '��', picQZ[12], 5, 49);
  QiZi[22] := dTXQZ.Create(22, 'ʿ', picQZ[11], 4, 59);
  QiZi[23] := dTXQZ.Create(23, '��', picQZ[10], 3, 69);
  QiZi[24] := dTXQZ.Create(24, '��', picQZ[ 9], 2, 79);
  QiZi[25] := dTXQZ.Create(25, '��', picQZ[ 8], 1, 89);
  QiZi[26] := dTXQZ.Create(26, '��', picQZ[13], 6, 17);
  QiZi[27] := dTXQZ.Create(27, '��', picQZ[13], 6, 77);
  QiZi[28] := dTXQZ.Create(28, '��', picQZ[14], 7, 06);
  QiZi[29] := dTXQZ.Create(29, '��', picQZ[14], 7, 26);
  QiZi[30] := dTXQZ.Create(30, '��', picQZ[14], 7, 46);
  QiZi[31] := dTXQZ.Create(31, '��', picQZ[14], 7, 66);
  QiZi[32] := dTXQZ.Create(32, '��', picQZ[14], 7, 86);

  PlayTree := dTXQPlayNode.Create(0,'========= ',0,0,XQZXY,nil,nil,nil,nil);
  PlayNode := PlayTree;

  // 32�����ӵĵ�ǰλ��
  for i:=1 to 32 do
  begin
    Qizi[i].XY           := $FF;        // ���Ӿ�����������
    PlayTree.QiziXY[i] := XQZXY[i];
  end;

  PlayRec[0] := PlayTree;

  RecListBox := lbxRec;
  VarListBox := lbxOther;
  RecMemo    := memRec;
  RecListBox.Items.Add(' ============ ');

  //  Clock       : dTXQCLOCK;                    // ��ʱ��

  RedPlayer := 'RedPlayer';
  BlkPlayer := 'BlkPlayer';

  PlayStepNo:= 0; // ��ǰ������ܲ���

  PlayRecHook := nil;
  RefreshHook := nil;

  ReverseH    := False;

  dDispQiziAtRecNo(0);
  dEnablePlayer(PlayTree);
end;

constructor dTXIANGQI.Create(imgBoard:TImage;imgXY:dTXQPXY;imgQZMove:TImage;
                             imgMovePosF,imgMovePosT:TImage;picQZ:dTXQZPIC;
                             lbxRec,lbxOther:TListBox;memRec:TMemo);
begin
  Create(imgBoard,imgXY,imgQZMove,imgMovePosF,imgMovePosT,picQZ,
         lbxRec,lbxOther,memRec,dCXQZXY);
end;

destructor dTXIANGQI.Destroy;
var
  i: dTINT32;
begin
  for i:=1 to 32 do Qizi[i].Destroy;
  //XQRecLBX.Free;
  PlayTree.Free;
  inherited Destroy;
end;

function dTXiangQi.sGetFMTRecStr(PN: dTXQPlayNode):string;
var
  s : string;
begin
  sGetFMTRecStr := '';
  if (PN=nil) then Exit;
  case PN.StepNo mod 2 of
    1:
      begin
        s := IntToStr((PN.StepNo + 1) div 2);
        case Length(s) of
          1: s := '  ' + s;
          2: s := ' ' + s;
        end;
        s := s + '. ' + PN.StrRec + ' ';
      end;
    0:
      begin
        s := '     ' + PN.StrRec + ' ';
      end;
  end;
  if (PN=PlayTree) then s := ' ============ ';

  if ((PN.LParent<>nil)or(PN.RChild<>nil)) then s := s + 'm';
  if PN.Remark <> nil then s := s + '*';

  sGetFMTRecStr := s;
end;


//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXIANGQI.dStartMoveFromXY(XY:dTBYTE);
var
  iIdx, X, Y: dTINT32;
begin
  QiziMove := nil;  X := XY div 10;  Y := XY mod 10;

  if(not((X in [0..8])and(Y in [0..9]))) then Exit;
  iIdx := iQiziIndexAtXY(XY);
  case iIdx of
    0     : Exit;
    01..16: if (WhoPlay <> wpRed) then Exit;
    17..32: if (WhoPlay <> wpBlk) then Exit;
  end;

  MovePosTo.Visible     := False;
  MovePosFrom.Visible   := False;
  
  QiziMove              := Qizi[iIdx];
  QiziMove.XY           := XY;

  QiziMoveImg.Picture   := QiziMove.Picture;
  QiziMoveImg.Left      := BoardXY[X,Y].Left;
  QiziMoveImg.Top       := BoardXY[X,Y].Top;
  QiziMoveImg.Visible   := True;
  BoardXY[X,Y].Cursor   := crDefault;
  BoardXY[X,Y].Picture  := nil;
  BoardXY[X,Y].DragMode := dmManual;
  MovePosFrom.Left := BoardXY[X,Y].Left;
  MovePosFrom.Top  := BoardXY[X,Y].Top;
end;

//-------------------------------------------------------------------------
//
//.........................................................................
function  dTXIANGQI.iQiziIndexAtXY(XY: dTBYTE): dTINT32;
var
  i: dTINT32;
begin
  for i:= 1 to 32 do
  begin
    if (XY = Qizi[i].XY) then
    begin
      iQiziIndexAtXY := i;
      Exit;
    end;
  end;
  iQiziIndexAtXY := 0;
end;

//-------------------------------------------------------------------------
// ��������
//.........................................................................
var
  dCREDNUM: array [1..9] of String[3] =         // �췽���õ�����ϵͳ
             ('һ','��','��','��','��','��','��','��','��');
  dCBLKNUM: array [1..9] of String[3] =         // �ڷ����õ�����ϵͳ
             ('��','��','��','��','��','��','��','��','��');
function dTXIANGQI.isMoveToValid(XY:dTBYTE; var sPlayRec:String):dTBOOLEAN;
var
  i    : dTINT32;
  qzXY : dTXQZXY;
  PN   : dTXQPlayNode;
begin
  isMoveToValid := False;
  for i:=1 to 32 do qzXY[i] := Qizi[i].XY;
  sPlayRec:=sGetPlayRecStr(qzXY, QiziMove.XY, XY, ReverseH);
  if (sPlayRec='') then Exit;
  if (isAddVarStep and (PlayNode.LChild<>nil)) then
  begin
    PN := PlayNode.LChild;
    while (PN<>nil) do
    begin
      if ((PN.XYf=QiziMove.XY)and(PN.XYt=XY)) then
      begin
        Application.MessageBox(
          '���ղ��ߵ�һ�������Ѿ����ڣ��뻻һ���߷���Ϊ���š�',
          'ϵͳ��Ϣ - �����±���',
          MB_OK + MB_ICONWARNING + MB_DEFBUTTON1);
        Exit;
      end;
      PN := PN.RChild;
    end;
  end;
  isMoveToValid := True; ;
end;

//-------------------------------------------------------------------------
//
//.........................................................................
function dTXIANGQI.isPlayOneStepOK(XYf, XYt: dTBYTE): dTBOOLEAN;
var
  iRecNo : dTINT32;
begin
  iRecNo := PlayStepNo;
  dStartMoveFromXY(XYf); dStopMoveAtXY(XYt);
  isPlayOneStepOK := (iRecNo <> PlayStepNo);
end;


//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXIANGQI.dUndoMove;
var
  X, Y: dTINT32;
begin
  X := QiziMove.XY div 10;  Y := QiziMove.XY mod 10;
  BoardXY[X,Y].Picture  := QiziMove.Picture;
  BoardXY[X,Y].Cursor   := crHandPoint;
  BoardXY[X,Y].DragMode := dmAutomatic;
  QiziMoveImg.Visible   := False;

  // 2001-02-15 : �������������⡣
  MovePosTo.Left := BoardXY[X,Y].Left;  MovePosTo.Top := BoardXY[X,Y].Top;
  MovePosTo.Visible := True;
end;

//-------------------------------------------------------------------------
// �ƶ���������
//.........................................................................
procedure dTXIANGQI.dStopMoveAtXY(XY:dTBYTE);
var
  i, X, Y: dTInt32;
  sPlayRec   : string;                          // ����������ּ�¼
  qzXY       : dTXQZXY;
  XYFrom     : dTByte;
  PN, PNTemp : dTXQPlayNode;
begin
  if (QiziMove = nil) then Exit;                // û�������ƶ�������
  if ((PlayStepNo>(dCMaxRecNo-1))or
     (not isMoveToValid(XY, sPlayRec))) then    // ��Ч��ȡ���ƶ�
  begin
    dUndoMove;
    Exit;
  end;

  X := XY div 10;  Y := XY mod 10;              // �ֽ�X, Y
  XYFrom := QiziMove.XY;                        // �����ƶ������

  i := iQiziIndexAtXY(XY);                      // ���Ե�������
  if (i <> 0) then begin Qizi[i].XY := $FF; end;

  // �����ӷ���
  QiziMove.XY := XY;  BoardXY[X,Y].Picture := QiziMove.Picture;

  // �������ӵ��ƶ��������ƶ�ָʾ
  MovePosTo.Left := BoardXY[X,Y].Left;  MovePosTo.Top := BoardXY[X,Y].Top;
  MovePosTo.Visible := True;
  MovePosFrom.Visible := True;

  // �����ƶ���'����'���������
  QiziMoveImg.Visible := False;  QiziMove := nil;

  dMoveMemoToRecNo(PlayStepNo);                 // ��¼ע��(�ƶ�ǰ��ע��)

  PlayStepNo := PlayStepNo + 1;                 // �����¼����һ��
  DispStepNo := PlayStepNo;

  for i:=1 to 32 do qzXY[i] := Qizi[i].XY;

  // �ж��Ƿ������ӱ���״̬
  if not isAddVarStep then
  begin
    // �������ӱ���״̬, ���ڶ�����������һ�����ӽڵ�, ������ǰ�ڵ�
    // ����Ϊ�ýڵ�
    PN := dTXQPlayNode.Create(PlayStepNo, sPlayRec,
            XYFrom, XY, qzXY, nil, PlayNode, nil, PlayNode);
  end
  else
  begin
    // �����ӱ���״̬�����ڶ�����������һ���Һ��ӽڵ㣬������ǰ�ڵ�
    // ����Ϊ�ýڵ�, �ýڵ�Ӧ���ڵ�ǰ�ڵ�����Һ��
    PN:= dTXQPlayNode.Create(PlayStepNo, sPlayRec,
           XYFrom, XY, qzXY, nil, DispNode, nil, nil);
    PNTemp := DispNode.LChild;
    if (PNTemp = nil) then begin ShowMessage('Error PNTemp'); Exit; end;
     // Ѱ�����Һ��
    while (PNTemp.RChild <> nil) do PNTemp := PNTemp.RChild;
    PNTemp.dSetRChild(PN);
  end;

  dAddPlayNodeIntoPlayRec(PN);

  PlayNode := PN;
  DispNode := PN;
  // isAddVarStep := False;
  RecListBox.ItemIndex := PlayStepNo;
  dDispVarStepAtRecNo(PlayStepNo);

  dDispQiziAtRecNo(PlayStepNo);  //??

  dEnablePlayer(PlayNode);
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXIANGQI.dEnablePlayer(WP: dTWHOPLAY);
var
  i, j, X, Y, m, n: dTINT32;
begin
  if (WP <> wpPause) then WhoPlay := WP;  m := 0;  n := 0;

  for i:=0 to 8 do for j:=0 to 9 do
  begin
    BoardXY[i,j].Cursor   := crDefault;
    BoardXY[i,j].DragMode := dmManual;
  end;

  case WP of
  wpNone  : Exit;
  wpPause : Exit;
  wpRed   : begin m:=01; n:=16; end;
  wpBlk   : begin m:=17; n:=32; end;
  end;

  for i:=m to n do
  begin
    if (Qizi[i].XY = $FF) then Continue;
    X := Qizi[i].XY div 10;  Y := Qizi[i].XY mod 10;
    BoardXY[X,Y].Cursor   := crHandPoint;
    BoardXY[X,Y].DragMode := dmAutomatic;
  end;
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXIANGQI.dEnablePlayer(PN: dTXQPlayNode);
begin
  if (PN=nil) then begin dEnablePlayer(wpPause); Exit; end;
  if ((PN=PlayTree)and(PlayStepNo=0)and(PN.XYf=0)) then
  begin
    if (PN.XYt=0) then                  // ��0����XYtָʾ��˭����
      dEnablePlayer(wpRed)
    else
      dEnablePlayer(wpBlk);
    Exit;
  end;
  if (PN.StepNo<PlayStepNo) then begin dEnablePlayer(wpPause); Exit; end;
  case iQiziIndexAtXY(PN.XYt) of
    01..16: dEnablePlayer(wpBlk);
    17..32: dEnablePlayer(wpRed);
  end;
end;

//-------------------------------------------------------------------------
// ��ʾ���׼�¼��ĳһ�������沼��  (��0��Ϊ���ֵ�����)
//.........................................................................
procedure dTXIANGQI.dDispQiziAtRecNo(iRec: dTINT32);
var
  i, Xf, Yf, Xt, Yt, iHeight: dTINT32;
begin
  if ((iRec<0)or(iRec>PlayStepNo)) then Exit;   // ��鲽������Ч��

  MovePosFrom.Visible := False;

  if (IsAutoPlaying and (DispStepNo = (iRec - 1))) then
  begin
    Xf := PlayRec[iRec].XYf div 10;  Yf := PlayRec[iRec].XYf mod 10;
    with BoardXY[Xf, Yf] do
    begin
      iHeight := Height;
      Height  := 0;
      Repaint;
      Sleep(333);
      Height  := iHeight;
      Repaint;
      Sleep(333);
    end;
  end;

  MovePosTo.Visible   := False;                 // �ص�����ָʾ
  
  for i:=1 to 32 do                             // ������õ�����
  begin
   if (Qizi[i].XY <> PlayRec[iRec].QiziXY[i]) then
   begin
     Xf := Qizi[i].XY div 10;  Yf := Qizi[i].XY mod 10;
     if (Xf < 10) then BoardXY[Xf, Yf].Picture := nil;
   end;
  end;

  for i:=1 to 32 do                             // ��ʾ��һ��������
  begin
     if (PlayRec[iRec].QiziXY[i] <> Qizi[i].XY ) then
     begin
       Xt := PlayRec[iRec].QiziXY[i] div 10;
       Yt := PlayRec[iRec].QiziXY[i] mod 10;
       if (Xt in [0..8]) then BoardXY[Xt, Yt].Picture := Qizi[i].Picture;
       Qizi[i].XY := PlayRec[iRec].QiziXY[i];
     end;
  end;

  if (iRec > 0) then                            // ��ʾ�����߶�ָʾ
  begin
    Xf                  := PlayRec[iRec].XYf div 10;
    Yf                  := PlayRec[iRec].XYf mod 10;
    MovePosFrom.Left    := BoardXY[Xf,Yf].Left;
    MovePosFrom.Top     := BoardXY[Xf,Yf].Top;
    MovePosFrom.Visible := True;
    Xt                  := PlayRec[iRec].XYt div 10;
    Yt                  := PlayRec[iRec].XYt mod 10;
    MovePosTo.Left      := BoardXY[Xt,Yt].Left;
    MovePosTo.Top       := BoardXY[Xt,Yt].Top;
    MovePosTo.Visible   := True;
  end;

  dMoveMemoToRecNo(DispStepNo);                 // �����µ�ע���¼����
  dLoadMemoFromRecNo(iRec);                     // ��ʾ�������ע��

  dDispVarStepAtRecNo(iRec);
  RecListBox.ItemIndex := iRec;
  DispStepNo := iRec;                           // ���õ�ǰ��ʾ�ļ�¼
  DispNode   := PlayRec[DispStepNo];

  if(@PlayRecHook<>nil) then PlayRecHook;
end;

//-------------------------------------------------------------------------
// ��ע�����Ծּ�¼
//.........................................................................
procedure dTXIANGQI.dMoveMemoToRecNo(iRec:dTINT32);
var
  PN : dTXQPlayNode;
begin
  if (not isMemoEdit) then Exit;
  if ((iRec<0)or(iRec>PlayStepNo)) then Exit;   // ��鷶Χ

  PN := PlayRec[iRec];

  if (PN.Remark <> nil) then                    // ���ͷžɵļ�¼
  begin
      PN.Remark.Free;  PN.Remark := nil;
  end;

  if (RecMemo.Lines.Count>0) then               // ��ע��
    if (not ((RecMemo.Lines.Count=1) and (RecMemo.Lines[0]=''))) then
    begin
      PN.Remark      := TStringList.Create;
      PN.Remark.Text := RecMemo.Text;
    end;
  RecListBox.Items[iRec] := sGetFMTRecStr(PN);

  RecMemo.Lines.Clear;
end;

//-------------------------------------------------------------------------
// ����¼�е�ע����ʾ����
//.........................................................................
procedure dTXIANGQI.dLoadMemoFromRecNo(iRec:dTINT32);
var
  PN : dTXQPlayNode;
begin
  RecMemo.Lines.Clear;

  PN := PlayRec[iRec];

  if (PN.Remark <> nil) then
  begin
    RecMemo.Text := PN.Remark.Text;
    RecMemo.SelStart := 0;  RecMemo.SelLength := 0;
  end;
end;

//-------------------------------------------------------------------------
// ���ż�¼�ǵ�ǰ��¼��
//.........................................................................
function dTXiangQi.isHighlightVarStepActive: Boolean;
var
  iRec : dTInt32;
  iVar : dTInt32;
begin
  Result := False;
  iRec := RecListBox.ItemIndex;
  iVar := VarListBox.ItemIndex;
  if ((iRec<1)or(iRec>dCMaxRecNo)) then Exit;
  if ((iVar<0)or(iVar>dCMaxVarNo)) then Exit;
  if PlayRec[iRec] = nil then Exit;
  if PlayVar[iVar] = nil then Exit;
  Result := (PlayRec[iRec] = PlayVar[iVar]);
end;


procedure dExchangePlayVar(var upNode, dnNode: dTXQPlayNode);
var
  tmpRChild: dTXQPlayNode;
begin
  if ((upNode=nil)or(dnNode=nil)) then Exit;

  tmpRChild  := dnNode.RChild;

  dnNode.LParent := upNode.LParent;
  dnNode.RParent := upNode.RParent;
  if (dnNode.RChild <> nil) then dnNode.RChild.LParent:=upNode;
  dnNode.RChild  := upNode;
  if (upNode.LParent <> nil) then upNode.Lparent.RChild := dnNode;
  if (upNode.RParent <> nil) then upNode.RParent.LChild := dnNode;

  upNode.LParent := dnNode;
  upNode.RParent := nil;  //tmpRParent;
  upNode.RChild  := tmpRChild;
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXiangQi.dMovePlayVarUp;
var
  iVar : dTInt32;
begin
  iVar := VarListBox.ItemIndex;
  if (iVar<1) then Exit;
  dExchangePlayVar(PlayVar[iVar-1], PlayVar[iVar]);
  dDispVarStepAtRecNo(RecListBox.ItemIndex);
  VarListBox.ItemIndex := (iVar-1);
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXiangQi.dMovePlayVarDown;
var
  iVar : dTInt32;
begin
  iVar := VarListBox.ItemIndex;
  if (iVar>=(VarListBox.Items.Count-1)) then Exit;
  dExchangePlayVar(PlayVar[iVar], PlayVar[iVar+1]);
  dDispVarStepAtRecNo(RecListBox.ItemIndex);
  VarListBox.ItemIndex := (iVar+1);
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXiangQi.dDispVarStepAtRecNo(iRec:dTInt32);
var
  PN    : dTXQPlayNode;
  n     : dTInt32;
  s     : string;
begin
  VarListBox.Items.Clear;

  if ((iRec<1)or(iRec>dCMaxRecNo)) then Exit;
  if PlayRec[iRec] = nil then Exit;

  // �����׼�¼���ҵ���ǰ�Ľڵ����һ����Ľڵ�ĵ�һ��Ӧ��
  PN := PlayRec[iRec].LastStepNode.LChild;  n := 0;
  while (PN <> nil) do
  begin
    s := '  A. ';  s[3] := chr(ord(s[3])+n);
    s := s + PN.StrRec;
    if (PN = PlayRec[iRec]) then  s := s + ' <--';
    VarListBox.Items.Add(s);
    PlayVar[n] := PN;
    n := n + 1;

    PN := PN.RChild;
  end;
  if n<>0 then
  begin
    RecListBox.Items[iRec]:=sGetFMTRecStr(PlayRec[iRec]);
  end;
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXiangQi.dLoadAllRecForPlayNode(PN:dTXQPlayNode);
var
  i, iDispStepNo :  dTInt32;
begin
  // ��ɾ��ԭ�����߷�(����ʾ�ĵ�ǰ״����ʼ)
  if (PN=nil) then Exit;
  iDispStepNo := DispStepNo;
  if (iDispStepNo<PN.StepNo) then iDispStepNo:=PN.StepNo;

  dMoveMemoToRecNo(DispStepNo);
  dLoadMemoFromRecNo(DispStepNo);

  for i:=PlayStepNo downto iDispStepNo do
  begin
    //Ϊ����������ע����ʾ�Ĵ���
    if i = iDispStepNo then
    begin
      dDeleteOnePlayRec;
    end
    else
    begin
      dDeleteOnePlayRec(False);
    end;
  end;
  if PN = PlayTree then
  begin
    iDispStepNo:=0; RecListBox.Items.Clear;
  end;
  while PN <> nil do
  begin
    dAddPlayNodeIntoPlayRec(PN);
    PlayStepNo := PN.StepNo;
    PlayNode   := PN;
    PN := PN.LChild;
  end;

  dDispQiziAtRecNo(iDispStepNo);
  dEnablePlayer(PlayNode);
end;

//-------------------------------------------------------------------------
// ������ڵ���������б�
//.........................................................................
procedure dTXiangQi.dAddPlayNodeIntoPlayRec(PN:dTXQPlayNode);
begin
  if (PN=nil) then Exit;

  if (PN.StepNo <= dCMaxRecNo) then
  begin
    PlayRec[PN.StepNo] := PN;
    RecListBox.Items.Add(sGetFMTRecStr(PN));    // ��ʾ������
  end;
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXIANGQI.dOnRecListBoxClick;
begin
  if (RecListBox.Items.Count=0) then Exit;
  if (RecListBox.ItemIndex<0) then Exit;
  dDispQiziAtRecNo(RecListBox.ItemIndex);
  dEnablePlayer(DispNode);
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXIANGQI.dOnVarListBoxDblClick;
begin
  if (VarListBox.Items.Count=0) then Exit;
  if (VarListBox.ItemIndex<0) then Exit;
  if isHighlightVarStepActive then Exit;
  dLoadAllRecForPlayNode(PlayVar[VarListBox.ItemIndex]);
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXIANGQI.dOnRecMemoChange;
begin
  isMemoEdit := True;
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXIANGQI.dDeleteOnePlayNode;
var
  PN : dTXQPlayNode;
begin
  if ((PlayStepNo=0)or(PlayStepNo<>DispStepNo)) then Exit;
  PN := PlayRec[PlayStepNo];
  if (PN=nil) then Exit;
  if (not ((PN.LParent=nil)and(PN.RChild=nil))) then // �б���
  begin
    case Application.MessageBox(
          '������ļ�¼�б��Ŵ��ڣ������ɾ���˱���¼�����еı����Լ���'+
          '���仯���ᱻɾ����'#13#10#13#10'���Ҫɾ����',
          'ɾ�����׼�¼',
          MB_OKCANCEL + MB_ICONQUESTION + MB_DEFBUTTON2) of
      IDOK:
        begin end;
      else
        Exit;
    end;
  end;
  dDeleteOnePlayRec;
  if (PN <> nil) then PN.Free;
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXiangQi.dDeletePlayVar(PN:dTXQPlayNode);
begin
  if (PN=nil) then Exit;

  if (not (PN.LChild=nil)) then // �к����仯
  begin
    case Application.MessageBox(
          '���������к����仯�������ɾ���˱���¼�����еĺ�'+
          '���仯���ᱻɾ����'#13#10#13#10'���Ҫɾ����',
          'ɾ������',
          MB_OKCANCEL + MB_ICONQUESTION + MB_DEFBUTTON2) of
      IDOK:
        begin end;
      else
        Exit;
    end;
  end;

  if(PN.RParent<>nil) then
  begin
    PN.RParent.dSetLChild(PN.RChild);
  end;
  if(PN.LParent<>nil) then
  begin
    PN.LParent.dSetRChild(PN.RChild);
  end;
  PN.LParent:=nil;  PN.RParent:=nil; PN.LChild:=nil; PN.RChild:=nil;
  PN.Free;
end;

//-------------------------------------------------------------------------
// ɾ��һ�����׼�¼����RecListBox��
//.........................................................................
procedure dTXIANGQI.dDeleteOnePlayRec(bRefresh: Boolean);
begin
  if (PlayStepNo = 0) then Exit;
  RecListBox.Items.Delete(RecListBox.Items.Count-1);
  PlayStepNo := RecListBox.Items.Count - 1;    // ���岽��-1
  PlayNode   := PlayNode.LastStepNode;
  RecListBox.ItemIndex := -1;
  if (bRefresh) then dDispQiziAtRecNo(PlayStepNo);
  RecListBox.ItemIndex := 0;
  RecListBox.ItemIndex := PlayStepNo;
  if (bRefresh) then dEnablePlayer(PlayNode);
end;

//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXIANGQI.dRefreshBoard(ReStart:Boolean);
var
  i, j, m, n: Integer;
begin
  if ReStart then
  begin
    for i:=1 to 32 do
    begin
      Qizi[i].XY := Qizi[i].XYStart;
    end;
    RecListBox.Items.Clear;
    PlayStepNo          := 0;
    DispStepNo          := 0;
    MovePosTo.Visible   := False;
    MovePosFrom.Visible := False;
  end;

  for i:=0 to 8 do for j:=0 to 9 do
  begin
    BoardXY[i, j].Picture  := nil;
    BoardXY[i, j].Cursor   := crDefault;
    BoardXY[i, j].DragMode := dmManual;
  end;

  for i:=1 to 32 do
  begin
    if (Qizi[i].XY = $FF) then Continue;
    m := Qizi[i].XY div 10;  n := Qizi[i].XY mod 10;
    BoardXY[m, n].Picture  := Qizi[i].Picture;
  end;
end;
{
//-------------------------------------------------------------------------
//
//.........................................................................
procedure dTXIANGQI.dReverseBoard;
var
  i, j, iLeft, iTop: dTINT32;
begin
  MovePosTo.Visible   := False;
  MovePosFrom.Visible := False;
  for i:=0 to 8 do for j:=0 to 4 do
  begin
    iLeft                  := BoardXY[i, j].Left;
    iTop                   := BoardXY[i, j].Top;
    BoardXY[i, j].Left     := BoardXY[8-i, 9-j].Left;
    BoardXY[i, j].Top      := BoardXY[8-i, 9-j].Top;
    BoardXY[8-i, 9-j].Left := iLeft;
    BoardXY[8-i, 9-j].Top  := iTop;
  end;
  dDispQiziAtRecNo(DispStepNo);         // Ϊ����ʾ����ƶ����ӵı��
end;
}

procedure dTXIANGQI.dRefreshRecStr;
var
  i: Integer;
procedure RefreshPNodeRecStr(APNode: dTXQPlayNode);
begin
  if APNode = nil then Exit;
  if APNode.LastStepNode = nil then
  begin
    APnode.StrRec := '';
  end
  else
  begin
    APNode.StrRec := sGetPlayRecStr(APNode.LastStepNode.QiZiXY,
       APNode.XYf, APNode.XYt, ReverseH, False);
  end;
  RefreshPNodeRecStr(APNode.LChild);
  RefreshPNodeRecStr(APNode.RChild);
end;
begin
  RefreshPNodeRecStr(PlayTree);
  for i:=1 to RecListBox.Items.Count do
  begin
    RecListBox.Items[i-1]:=sGetFMTRecStr(PlayRec[i-1]);
  end;
end;

end.
///////////////////////////////////////////////////////////////////////////