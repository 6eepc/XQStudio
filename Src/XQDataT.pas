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

unit XQDataT;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, dDelphiS, ClipBrd;

//-------------------------------------------------------------------------
//
//.........................................................................
const
  dCProductName = 'XQStudio';
  dCMainVersion = '1.63';
  dCFileVersion = 18;
  dCBetaVersion = 'Final Beta';
  //dCVersionInfo = dCProductName+' '+dCMainVersion +' ('+dCBetaVersion+')';
  dCVersionInfo = dCProductName+' '+dCMainVersion;

  dCMaxRecNo = 1023;
  dCMaxVarNo = 1023;                            // ���ı�����

  dCWMOPENXQF   =  9966;

type
  //-----------------------------------------------------------------------
  // �������������õ�����������
  //.......................................................................
  dTXQPXY = array [0..8, 0..9] of TImage;       // ���������궨��: һ������
                                                // ��90�������'��վ'���

  dTXQZPic = array [1..14] of TPicture;         // �����ӵ�ͼƬ, ����Ϊ:
                                                // ��: ������ʿ˧�ڱ�
                                                // ��: ������ʿ���ڱ�

  dTWhoPlay = (wpRed, wpBlk, wpNone, wpPause);  // ����'��˭��'

  dTXQZXY = array [1..32] of dTByte;            // 32�����ӵ�λ��
  // �õ��ֽ������ʾ, ���ֽڱ�Ϊʮ������, ʮλ��ΪX(0-8)��λ��ΪY(0-9),
  // ���̵����½�Ϊԭ��(0, 0). 32�����ӵ�λ�ô�1��32����Ϊ:
  // ��: ������ʿ˧ʿ�������ڱ��������� (λ�ô��ҵ���, ���µ���)
  // ��: ������ʿ��ʿ������������������ (λ�ô��ҵ���, ���µ���)

  procedure dMakeStandardQzXY(var qzXY: dTXQZXY);
  function  IsQzXYSame(var qzXY1, qzXY2: dTXQZXY; bQzNumOnly, bIgnoreYz: Boolean): Boolean;
  function  sGetPlayRecStr(var qzXY:dTXQZXY; XYf,XYt:Byte;
                             bRL:Boolean; bMove: Boolean = True):string;
  function  wGetPlayRecXY (qzXY:dTXQZXY; wp: dTWhoPlay;
                             sRecStr:string):dTWord;
  procedure d90PosCharToXQZXY(var qzXY: dTXQZXY; s90Char: string);
  procedure dXQZXYtoXYfXYt(var XYf, XYt: dTByte; qzXYf, qzXYt: dTXQZXY);
  procedure dMakeQiTuText(var mem: TMemo; sRed, sBlk: String;
              qzXY:dTXQZXY; wp: dTWhoPlay; iMode: integer; bRL: Boolean;
              bBbsColor:Boolean);
  function  isQiziCanAtXY(Idx, XYx, XYy: dTInt32): dTBoolean;

  function  isClipBoardTextQipu: Boolean;
  function  sGetCmdLineXqfName: string;
  procedure dSetSearchQzXYParam(qzXY: dTXQZXY);


//-------------------------------------------------------------------------
// ��������
//.........................................................................
var
  dCREDNUM: array [0..9] of String[3] =         // �췽���õ�����ϵͳ
             ('0', 'һ','��','��','��','��','��','��','��','��');
  dCBLKNUM: array [0..9] of String[3] =         // �ڷ����õ�����ϵͳ
             ('0', '��','��','��','��','��','��','��','��','��');
implementation

//-------------------------------------------------------------------------
// �����������Ϊ���׼�¼��ͬʱ��ֵľ��Ƹ���
//.........................................................................
function sGetPlayRecStr(var qzXY:dTXQZXY; XYf,XYt:Byte; bRL:Boolean;
             bMove: Boolean):string;
var
  i, m, n, MN, Xf, Yf, Xt, Yt, Dx, Dy, Da, Db, iQZCount: dTINT32;
  sRec          : string;
  WP            : dTWhoPlay;
  TempXY        : dTXQZXY;
  isKingSafe    : Boolean;
function iGetQZIdxAtXY(XY:dTByte):dTInt32;
var
  i: dTInt32;
begin
  for i:=1 to 32 do
  begin
    if qzXY[i] = XY then begin iGetQZIdxAtXY:=i; Exit; end;
  end;
  iGetQZIdxAtXY := 0;
end;
function sGetRedLine(iX: Integer): String;
begin
  // bRL Ϊ���ҶԻ���־
  if bRL then Result := dCREDNUM[iX+1] else Result := dCREDNUM[9-iX];
end;
function sGetBlkLine(iX: Integer): String;
begin
  // bRL Ϊ���ҶԻ���־
  if bRL then Result := dCBLKNUM[9-iX] else Result := dCBLKNUM[iX+1];
end;

begin
  sGetPlayRecStr := '';

  case iGetQZIdxAtXY(XYf) of
    01..16: WP := wpRed;
    17..32: WP := wpBlk;
    else    Exit;
  end;

  case iGetQZIdxAtXY(XYt) of                    // �����Գ��Լ���
    01..16: if (WP = wpRed) then Exit;
    17..32: if (WP = wpBlk) then Exit;
  end;

  Xf:=XYf div 10;  Yf:=XYf mod 10;  Xt:=XYt div 10;  Yt:=XYt mod 10;
  Dx:=Xt - Xf;     Dy:=Yt - Yf;     Da:=Abs(Dx);     Db:=Abs(Dy);

  case iGetQZIdxAtXY(XYf) of
  1, 9, 17, 25: // Che
    Begin
      if ((Dx<>0)and(Dy<>0)) then Exit;
      iQZCount := 0;
      for i:=1 to Da-1 do if (iGetQZIdxAtXY((Xf+i*(Da div Dx))*10+Yf)<>0)
        then iQZCount :=  iQZCount + 1;
      for i:=1 to Db-1 do if (iGetQZIdxAtXY(Xf*10+(Yf+i*(Db div Dy)))<>0)
        then iQZCount :=  iQZCount + 1;
      if (iQZCount<>0) then Exit;

      case WP of
      wpRed:
        begin
          sRec := '��' + sGetRedLine(Xf);

          if qzXY[01] = XYf then
            MN := qzXY[09]
          else
            MN := qzXY[01];
          m := MN div 10;  n := MN mod 10;
          if (m=Xf) then if (Yf>n) then sRec:='ǰ��' else sRec:='��';

          case Dy of
            01..09: sRec := sRec + '��' + dCREDNUM[Db];
            -9..-1: sRec := sRec + '��' + dCREDNUM[Db];
            0     : sRec := sRec + 'ƽ' + sGetRedLine(Xt);
          end;
        end;
      wpBlk:
        begin
          sRec := '��' + sGetBlkLine(Xf);

          if (qzXY[17]=XYf) then MN:=qzXY[25] else MN:=qzXY[17];
          m := MN div 10;  n := MN mod 10;
          if (m=Xf) then if (Yf<n) then sRec:='ǰ��' else sRec:='��';

          case Dy of
            -9..-1: sRec := sRec + '��' + dCBLKNUM[Db];
            01..09: sRec := sRec + '��' + dCBLKNUM[Db];
            0     : sRec := sRec + 'ƽ' + sGetBlkLine(Xt);
          end;
        end;
      end;
    end;

  2, 8, 18, 24: // Ma
    begin
      if (((Da<>1)and(Db<>1))or((Da<>2)and(Db<>2))) then Exit;
      m := 0; n := 0; if (Da>Db) then m:=(Dx div 2) else n:=(Dy div 2);
      if(iGetQZIdxAtXY((Xf+m)*10+(Yf+n))<>0) then Exit;

      case WP of
      wpRed:
        begin
          sRec := '��' + sGetRedLine(Xf);

          if (qzXY[02]=XYf) then MN:=qzXY[08] else MN:=qzXY[02];
          m := MN div 10;  n := MN mod 10;
          if (m=Xf) then if (Yf>n) then sRec:='ǰ��' else sRec:='����';
          case Dy of
            01..02: sRec := sRec + '��' + sGetRedLine(Xt);
            -2..-1: sRec := sRec + '��' + sGetRedLine(Xt);
          end;
        end;
      wpBlk:
        begin
          sRec := '��' + sGetBlkLine(Xf);

          if (qzXY[18]=XYf) then MN:=qzXY[24] else MN:=qzXY[18];
          m := MN div 10;  n := MN mod 10;
          if (m=Xf) then if (Yf<n) then sRec:='ǰ��' else sRec:='����';
          case Dy of
            -2..-1: sRec := sRec + '��' + sGetBlkLine(Xt);
            01..02: sRec := sRec + '��' + sGetBlkLine(Xt);
          end;
        end;
      end;
    end;

  3, 7, 19, 23: // Xiang (OK)
    begin
      if ((Da<>2)or(Db<>2)) then Exit;
      case WP of
        wpRed: if (not(XYt in [02, 20, 24, 42, 60, 64, 82])) then Exit;
        wpBlk: if (not(XYt in [07, 25, 29, 47, 65, 69, 87])) then Exit;
      end;
      m:=(Dx div 2); n:=(Dy div 2);
      if(iGetQZIdxAtXY((Xf+m)*10+(Yf+n))<>0) then Exit;

      case WP of
      wpRed:
        begin
          sRec := '��' + sGetRedLine(Xf);

          //if qzXY[03]=XYf then MN:=qzXY[07]else MN:=qzXY[03];
          //m := MN div 10;  n := MN mod 10;
          //if (m=Xf) then if (Yf>n) then sRec:='ǰ��' else sRec:='����';

          case Dy of
            01..02: sRec := sRec + '��' + sGetRedLine(Xt);
            -2..-1: sRec := sRec + '��' + sGetRedLine(Xt);
          end;
        end;
      wpBlk:
        begin
          sRec := '��' + sGetBlkLine(Xf);

          //if qzXY[19]=XYf then MN:=qzXY[23] else MN:=qzXY[19];
          //m := MN div 10;  n := MN mod 10;
          //if (m=Xf) then if (Yf<n) then sRec:='ǰ��' else sRec:='����';

          case Dy of
            -2..-1: sRec := sRec + '��' + sGetBlkLine(Xt);
            01..02: sRec := sRec + '��' + sGetBlkLine(Xt);
          end;
        end;
      end;

    end;

  4, 6, 20, 22: // Shi (OK)
    begin
      if ((Da<>1)or(Db<>1)) then Exit;
      case WP of
        wpRed: if (not(XYt in [30, 32, 41, 50, 52])) then Exit;
        wpBlk: if (not(XYt in [37, 39, 48, 57, 59])) then Exit;
      end;

      case WP of
      wpRed:
        begin
          sRec := 'ʿ' + sGetRedLine(Xf);

          //if qzXY[04] = XYf then MN:=qzXY[06] else MN:=qzXY[04];
          //m := MN div 10;  n := MN mod 10;
          //if (m=Xf) then if (Yf>n) then sRec:='ǰʿ' else sRec:='��ʿ';

          case Dy of
            01..02: sRec := sRec + '��' + sGetRedLine(Xt);
            -2..-1: sRec := sRec + '��' + sGetRedLine(Xt);
          end;
        end;
      wpBlk:
        begin
          sRec := 'ʿ' + sGetBlkLine(Xf);

          //if qzXY[20]=XYf then MN:=qzXY[22] else MN:=qzXY[20];
          //m := MN div 10;  n := MN mod 10;
          //if (m=Xf) then if (Yf<n) then sRec:='ǰʿ' else sRec:= '��ʿ';

          case Dy of
            -2..-1: sRec := sRec + '��' + sGetBlkLine(Xt);
            01..02: sRec := sRec + '��' + sGetBlkLine(Xt);
          end;
        end;
      end;

    end;

  5, 21: // Jiang (OK)
    begin
      if (((Da<>0)and(Db<>0))or((Da<>1)and(Db<>1))) then Exit;
      case WP of
        wpRed: if (not(XYt in [30,31,32,40,41,42,50,51,52])) then Exit;
        wpBlk: if (not(XYt in [37,38,39,47,48,49,57,58,59])) then Exit;
      end;

      case WP of
      wpRed:
        begin
          sRec := '˧' + sGetRedLine(Xf);
          case Dy of
            01..09: sRec := sRec + '��' + dCREDNUM[Db];
            -9..-1: sRec := sRec + '��' + dCREDNUM[Db];
            0     : sRec := sRec + 'ƽ' + sGetRedLine(Xt);
          end;
        end;
      wpBlk:
        begin
          sRec := '��' + sGetBlkLine(Xf);
          case Dy of
            -9..-1: sRec := sRec + '��' + dCBLKNUM[Db];
            01..09: sRec := sRec + '��' + dCBLKNUM[Db];
            0     : sRec := sRec + 'ƽ' + sGetBlkLine(Xt);
          end;
        end;
      end;
    end;

  10,11,26,27: // Pao (OK)
    begin
      if ((Dx<>0)and(Dy<>0)) then Exit;
      iQZCount := 0;
      for i:=1 to Da-1 do if (iGetQZIdxAtXY((Xf+i*(Da div Dx))*10+Yf)<>0)
        then iQZCount :=  iQZCount + 1;
      for i:=1 to Db-1 do if (iGetQZIdxAtXY(Xf*10+(Yf+i*(Db div Dy)))<>0)
        then iQZCount :=  iQZCount + 1;
      if (iQZCount>1) then Exit;
      if ((iGetQZIdxAtXY(XYt)=0)and(iQZCount=1)) or
         ((iGetQZIdxAtXY(XYt)<>0)and(iQZCount=0)) then Exit;

      case WP of
      wpRed:
        begin
          sRec := '��' + sGetRedLine(Xf);

          if qzXY[10] = XYf then MN:=qzXY[11] else MN:=qzXY[10];
          m := MN div 10;  n := MN mod 10;
          if (m=Xf) then if (Yf>n) then sRec:='ǰ��' else sRec:='����';

          case Dy of
            01..09: sRec := sRec + '��' + dCREDNUM[Db];
            -9..-1: sRec := sRec + '��' + dCREDNUM[Db];
            0     : sRec := sRec + 'ƽ' + sGetRedLine(Xt);
          end;
        end;
      wpBlk:
        begin
          sRec := '��' + sGetBlkLine(Xf);
          if qzXY[26] = XYf then MN := qzXY[27] else MN := qzXY[26];
          m := MN div 10;  n := MN mod 10;
          if (m=Xf) then if (Yf<n) then sRec:='ǰ��' else sRec:= '����';

          case Dy of
            -9..-1: sRec := sRec + '��' + dCBLKNUM[Db];
            01..09: sRec := sRec + '��' + dCBLKNUM[Db];
            0     : sRec := sRec + 'ƽ' + sGetBlkLine(Xt);
          end;
        end;
      end
    end;

  12..16, 28..32: // Bing
    begin
      if (((Da<>0)and(Db<>0))or((Da<>1)and(Db<>1))) then Exit;

      case WP of
        wpRed: if (((Da=0)and(Dy<> 1))or((Da=1)and(Yf<=4))) then Exit;
        wpBlk: if (((Da=0)and(Dy<>-1))or((Da=1)and(Yf>=5))) then Exit;
      end;

      case WP of
      wpRed:
        begin
          sRec := '��' + sGetRedLine(Xf);

          m := 0;  n := 0;
          for i:=7 downto 1 do
          begin
            if (iGetQZIdxAtXY(Xf*10+i+2) in [12..16]) then
            begin
              m := m + 1;  if ((i+2)>=Yf) then n := n + 1;
            end;
          end;

          case m of
          2: if (n=1) then sRec:='ǰ��' else sRec:= '���';
          3: case n of
             1: sRec:='ǰ��';
             2: sRec:='�б�';
             3: sRec:='���';
             end;
          4: case n of
             1: sRec:='ǰ��';
             2: sRec:='����';
             3: sRec:='����';
             4: sRec:='���';
             end;
          5: case n of
             1: sRec:='ǰ��';
             2: sRec:='����';
             3: sRec:='����';
             4: sRec:='�ı�';
             5: sRec:='���';
             end;

          end;

          case Dy of
          1 : sRec := sRec + '��' + dCREDNUM[Db];
          0 : sRec := sRec + 'ƽ' + sGetRedLine(Xt);
          end;
        end;

      wpBlk:
        begin
          sRec := '��' + sGetBlkLine(Xf);

          m := 0;  n := 0;
          for i:=1 to 7 do
          begin
            if (iGetQZIdxAtXY(Xf*10+i-1) in [28..32]) then
            begin
              m := m + 1;  if ((i-1)<=Yf) then n := n + 1;
            end;
          end;

          case m of
          2: if (n=1) then sRec:='ǰ��' else sRec:= '����';
          3: case n of
             1: sRec:='ǰ��';
             2: sRec:='����';
             3: sRec:='����';
             end;
          4: case n of
             1: sRec:='ǰ��';
             2: sRec:='����';
             3: sRec:='����';
             4: sRec:='����';
             end;
          5: case n of
             1: sRec:='ǰ��';
             2: sRec:='����';
             3: sRec:='����';
             4: sRec:='����';
             5: sRec:='����';
             end;
          end;

          case Dy of
          -1: sRec := sRec + '��' + dCBLKNUM[Db];
          0 : sRec := sRec + 'ƽ' + sGetBlkLine(Xt);
          end;
        end;
      end;
    end;
  end; // End of Case

  for i:=1 to 32 do TempXY[i] := qzXY[i];
  if iGetQZIdxAtXY(XYt) <> 0 then qzXY[iGetQZIdxAtXY(XYt)]:=$FF;
  qzXY[iGetQZIdxAtXY(XYf)]:=XYt;

  // ���Ҫ���ӣ���齫˧�İ�ȫ��
  if bMove then
  begin
    // ��������˧�İ�ȫ��
    Xf := qzXY[ 5] div 10;  Yf := qzXY[ 5] mod 10;      // ��˧��λ��
    Xt := qzXY[21] div 10;  Yt := qzXY[21] mod 10;      // �ڽ���λ��

    // ��齫˧�Ƿ�����
    if (Xf = Xt) then
    begin
      isKingSafe := False;
      for i:=(Yf+1) to (Yt-1) do if (iGetQZIdxAtXY(Xf*10+i)<>0) then
      begin
        isKingSafe := True;
      end;
      if not isKingSafe then
      begin
        for i:=1 to 32 do qzXY[i] := TempXY[i];
        Exit;
      end;
    end;

    // ������Ӻ��Ƿ�����Ҫ�Ե���˧
    isKingSafe := True;
    case WP of
    wpRed:
      begin
        for i:=17 to 32 do
        begin
          if (qzXY[i] > 89) then continue;
          if sGetPlayRecStr(qzXY, qzXY[i], qzXY[5], bRL, False) <> '' then
          begin
            isKingSafe := False;
            Break;
          end;
        end;
      end;
    wpBlk:
      begin
        for i:=1 to 16 do
        begin
          if (qzXY[i] > 89) then continue;
          if sGetPlayRecStr(qzXY, qzXY[i], qzXY[21], bRL, False) <> '' then
          begin
            isKingSafe := False;
            Break;
          end;
        end;
      end;
    end;
    if not isKingSafe then
    begin
      for i:=1 to 32 do qzXY[i] := TempXY[i];
      Exit;
    end;
  end;

  // ���ƶ����ӣ���ԭ
  if not bMove then for i:=1 to 32 do qzXY[i] := TempXY[i];

  sGetPlayRecStr := sRec;
end;

//-------------------------------------------------------------------------
// ��������ȡ��������ƶ������ײ���WXF�ļ�¼����
//.........................................................................
function wGetPlayRecXY(qzXY:dTXQZXY;wp: dTWhoPlay;sRecStr:string):dTWord;
var
  s: string;
  i, j, iCol, iRow, iNum : dTInt32;
  qzIdx   : array [1..5] of dTInt32;            // ͬһ�����ֿ��ܵ��������
  qzCnt   : array [1..5] of dTInt32;            // ͬһ���ϵ����ӵĸ���
  qzOrd   : array [1..5] of dTInt32;            // ��������ͬһ���ϵĴ���
  qzMove  : dTInt32;                            // ��ǰ�ƶ�������
  qzXYTemp: dTXQZXY;
  Xf, Yf, Xt, Yt, iDx, iDy, XYf, XYt: dTInt32;
  isPawn  : dTBoolean;
begin
  Result := $FFFF;
  if (Length(sRecStr)<>4) then Exit;
  case wp of
    wpRed: sRecStr := UpperCase(sRecStr);
    wpBlk: sRecStr := LowerCase(sRecStr);
  end;

  for i:=1 to 5 do
  begin
    qzIdx[i] := 0;  qzCnt[i] := 0;  qzOrd[i] := 0;
  end;

  // ���ݱ���ɸѡ���ӣ�������ѡ��5��
  isPawn := False;

  case sRecStr[1] of
    'R': begin qzIdx[1]:= 1; qzIdx[2]:= 9; end; // Red: CharRiot
    'H': begin qzIdx[1]:= 2; qzIdx[2]:= 8; end; // Red: Horse
    'E': begin qzIdx[1]:= 3; qzIdx[2]:= 7; end; // Red: Elephant
    'A': begin qzIdx[1]:= 4; qzIdx[2]:= 6; end; // Red: Adviser
    'K': begin qzIdx[1]:= 5;               end; // Red: King
    'C': begin qzIdx[1]:=10; qzIdx[2]:=11; end; // Red: Cannon
    'P': begin
           for i:=1 to 5 do qzIdx[i] := i+11;   // Red: Pawn
           isPawn := True;
         end;

    'r': begin qzIdx[1]:=17; qzIdx[2]:=25; end; // Blk: CharRiot
    'h': begin qzIdx[1]:=18; qzIdx[2]:=24; end; // Blk: Horse
    'e': begin qzIdx[1]:=19; qzIdx[2]:=23; end; // Blk: Elephant
    'a': begin qzIdx[1]:=20; qzIdx[2]:=22; end; // Blk: Adviser
    'k': begin qzIdx[1]:=21;               end; // Blk: King
    'c': begin qzIdx[1]:=26; qzIdx[2]:=27; end; // Blk: Cannon
    'p': begin
           for i:=1 to 5 do qzIdx[i] := i+27;   // Blk: Pawn
           isPawn := True;
         end;

    '+','-','1','2','3','4','5','6','7','8','9':// Red or Blk: Pawn
      begin
        isPawn := True;
        case wp of
          wpRed: for i:=1 to 5 do qzIdx[i]:=i+11;
          wpBlk: for i:=1 to 5 do qzIdx[i]:=i+27;
        end;
      end;

    else Exit;
  end;  // ɸѡ���ӽ������̶���ĳ��������

  // ����ͬһ�е����ӵĸ��������ӵĴ���
  for i:=1 to 5 do
  begin
    if (qzIdx[i]=0) then break;
    if (qzXY[qzIdx[i]]=$FF) then continue;
    iCol := qzXY[qzIdx[i]] div 10;
    iRow := qzXY[qzIdx[i]] mod 10;
    for j:=1 to 5 do
    begin
      if (qzIdx[j]=0) then break;
      if (qzXY[qzIdx[j]]=$FF) then continue;
      if ((qzXY[qzIdx[j]] div 10)=iCol) then
      begin
        Inc(qzCnt[i]);
        case wp of
          wpRed: if ((qzXY[qzIdx[j]] mod 10)>=iRow) then Inc(qzOrd[i]);
          wpBlk: if ((qzXY[qzIdx[j]] mod 10)<=iRow) then Inc(qzOrd[i]);
        end;
      end;
    end;
  end;

  // ����ǰ��ɸѡ�Ľ�������׵ĵڶ����ַ���ȷ���ƶ�������(����ű�ʾ)
  qzMove := 0;
  case sRecStr[2] of
    '1','2','3','4','5','6','7','8','9':        // �����ֱ�ʾ
      begin
        iCol := Ord(sRecStr[2]) - Ord('0');     // ȡ�����ֵ�ֵ

        // �������������X
        case wp of
          wpRed: iCol := 9 - iCol;
          wpBlk: iCol := iCol - 1;
        end;
        // ��ʱ��iCol�ǵ�ǰ�ƶ����ӵ�X����

        for i:=1 to 5 do                        // ��5����ѡ��������
        begin
          if (qzIdx[i]=0) then Exit;            // �Ҳ������˳�
          if ((qzXY[qzIdx[i]] div 10)=iCol) then
          begin                                 // �ҵ�
            if isPawn then                      // �������䡱�����Ҫ���⴦��
            begin
              if ((qzCnt[i]=1) or               // ������һ������
                ((qzCnt[i]=3)and(qzOrd[i]=2)) or    // ������һ�ߵ��м��
                ((qzCnt[i]=5)and(qzOrd[i]=3))) then // �����һ�ߵ��м��
              begin
                qzMove := qzIdx[i];             // qzMoveΪ��ǰ���ӵ����
              end;
            end
            else                                // �����������������
            begin
              case qzCnt[i] of
                1:                              // ����������ͬ��������ͬһ����
                  begin
                    qzMove := qzIdx[i];         // qzMoveΪ��ǰ���ӵ����
                  end;
                2:                              // ������ͬ���ı�����ͬһ����
                  begin
                    qzXYTemp := qzXY;  s := sRecStr;
                    case qzOrd[i] of
                      1: s[2] := '+';
                      2: s[2] := '-';
                    end;
                    if (wGetPlayRecXY (qzXYTemp, wp, s)<>$FFFF) then qzMove := qzIdx[i];
                  end;
              end;
            end;
          end;
          if (qzMove<>0) then break;
        end;
        if (i>5) then Exit;                     // �Ҳ������˳�
      end;

    '+', '-':                                   // �ԡ�ǰ���󡯱�ʾ
      begin
        if isPawn then                          // �������䡱�����Ҫ���⴦��
        begin
          case sRecStr[1] of
            'P','p':
              begin
                for i:=1 to 5 do
                begin
                  case qzCnt[i] of
                    2: case sRecStr[2] of
                         '+': if (qzOrd[i]=1) then qzMove := qzIdx[i]; 
                         '-': if (qzOrd[i]=2) then qzMove := qzIdx[i]; 
                       end;

                    3: case sRecStr[2] of
                         '+': if (qzOrd[i]=1) then qzMove := qzIdx[i]; 
                         '-': if (qzOrd[i]=3) then qzMove := qzIdx[i]; 
                       end;

                    4: case sRecStr[2] of
                         '+': if (qzOrd[i]=2) then qzMove := qzIdx[i]; 
                         '-': if (qzOrd[i]=3) then qzMove := qzIdx[i]; 
                       end;

                    5: case sRecStr[2] of
                         '+': if (qzOrd[i]=2) then qzMove := qzIdx[i]; 
                         '-': if (qzOrd[i]=4) then qzMove := qzIdx[i]; 
                       end;
                  end;
                  if (qzMove<>0) then break;
                end;
              end;

            '+','-':
              begin
                if ((sRecStr[1]='+')and(sRecStr[2]='-')) then Exit;
                if ((sRecStr[1]='-')and(sRecStr[2]='+')) then Exit;

                for i:=1 to 5 do
                begin
                  case qzCnt[i] of
                    4: case sRecStr[2] of
                         '+': if (qzOrd[i]=1) then qzMove := qzIdx[i]; 
                         '-': if (qzOrd[i]=4) then qzMove := qzIdx[i]; 
                       end;

                    5: case sRecStr[2] of
                         '+': if (qzOrd[i]=1) then qzMove := qzIdx[i]; 
                         '-': if (qzOrd[i]=5) then qzMove := qzIdx[i]; 
                       end;
                  end;
                  if (qzMove<>0) then break;
                end;
              end;
            '1','2','3','4','5','6','7','8','9':
              begin
                iCol := Ord(sRecStr[1]) - Ord('0');
                for i:=1 to 5 do
                begin
                  if (qzCnt[i]<2) then continue;
                  if ((qzXY[qzIdx[i]] div 10)<>iCol) then continue;
                  case qzCnt[i] of
                    2: case sRecStr[2] of
                         '+': if (qzOrd[i]=1) then qzMove := qzIdx[i]; 
                         '-': if (qzOrd[i]=2) then qzMove := qzIdx[i]; 
                       end;

                    3: case sRecStr[2] of
                         '+': if (qzOrd[i]=1) then qzMove := qzIdx[i]; 
                         '-': if (qzOrd[i]=3) then qzMove := qzIdx[i];
                         '1','2','3','4','5','6','7','8','9':
                            if (qzOrd[i]=2) then qzMove := qzIdx[i]; 
                       end;
                  end;
                  if (qzMove<>0) then break;
                end;
              end;
          end;
        end
        else
        begin
          case sRecStr[2] of
            '+': for i:=1 to 2 do if (qzOrd[i]=1) then qzMove:=qzIdx[i];
            '-': for i:=1 to 2 do if (qzOrd[i]=2) then qzMove:=qzIdx[i];
          end;
        end;
      end;

    else Exit;
  end;

  // ��ʱ���ҵ���ǰ�ƶ����ӵ����qzMove
  if ((qzMove<1) or (qzMove>32)) then Exit;     // ��ȫ�Լ��
  if (qzXY[qzMove]=$FF) then Exit;              // ����Ϊ��������
  
  Xf := qzXY[qzMove] div 10;  Xt := Xf;         // ���ƶ����긳ֵ
  Yf := qzXY[qzMove] mod 10;  Yt := Yf;

  // ȡ�����׼�¼�����һλ���ֵ�ֵ
  iNum := Ord(sRecStr[4]) - Ord('0');
  if ((iNum<1)or(iNum>9)) then Exit;

  // �����ƶ��ķ������Ŀ��������
  case sRecStr[3] of 
    '.':  // Traverse (ƽ��)
      begin
        case wp of
          wpRed: Xt := 9 - iNum;
          wpBlk: Xt := iNum - 1;
        end;
      end;

    '+', '-':  // Advance, Retreat (ǰ�������)
      begin
        // ���ý��˲����ĳ˷�����
        iDy := 0;
        case sRecStr[3] of
          '+': iDy := +1;
          '-': iDy := -1;
        end;

        case sRecStr[1] of
          'R','r','K','k','C','c','P','p','+','-':
             begin                              // �����ڱ�
               case wp of
                 wpRed: Yt := Yt + iDy*iNum;
                 wpBlk: Yt := Yt - iDy*iNum;
               end;
             end;

          'H', 'h':                             // ��
             begin
               case wp of
                 wpRed:
                   begin
                     iDx := (9-iNum) - Xt;
                     // �ж�ˮƽ�����ƶ��ľ���
                     case abs(iDx) of
                       1: begin Xt := 9 - iNum; Yt := Yt + iDy*2; end;
                       2: begin Xt := 9 - iNum; Yt := Yt + iDy*1; end;
                       else Exit;
                     end;
                   end;
                 wpBlk:
                   begin
                     iDx := (iNum-1) - Xt;
                     case abs(iDx) of
                       1: begin Xt := iNum - 1; Yt := Yt - iDy*2; end;
                       2: begin Xt := iNum - 1; Yt := Yt - iDy*1; end;
                       else Exit;
                     end;
                   end;
               end;
             end;

          'E', 'e':                             // ��
             begin
               case wp of
                 wpRed: begin Xt := 9 - iNum; Yt := Yt + iDy*2; end;
                 wpBlk: begin Xt := iNum - 1; Yt := Yt - iDy*2; end;
               end;
             end;

          'A', 'a':                             // ʿ
             begin
               case wp of
                 wpRed: begin Xt := 9 - iNum; Yt := Yt + iDy*1; end;
                 wpBlk: begin Xt := iNum - 1; Yt := Yt - iDy*1; end;
               end;
             end;
        end;
      end;

    else Exit;
  end;

  XYf := Xf * 10 + Yf;
  XYt := Xt * 10 + Yt;
  if (sGetPlayRecStr(qzXY, XYf, XYt, False)='') then Exit;
 

  Result := XYf;
  Result := Result shl 8;
  Result := Result + XYt;
end;


//-------------------------------------------------------------------------
// �й������ʦ�õĸ�ʽ
// BZxjZcCZZZZZZBZZZZZZZmZZZZZZZZZbZZZZZZZZZZZZZ
// ZZZZZZZZZPZZZBZZZZXZZZZZZZXZZZZbZZZZZZZJZZZbZ
// B : Bing
// Z :
// x : Xiang
// s : Shi;
// j : Jiang
// c : Che
// m : Ma
// p : Pao
//.........................................................................
procedure d90PosCharToXQZXY(var qzXY: dTXQZXY; s90Char: string);
var
  i, j, x, y, XY: dTInt32;
begin
  for i:=1 to 32 do qzXY[i] := $FF;
  for i:=1 to 90 do
  begin
    x  := (i-1) mod 9;
    y  := 9 - (i-1) div 9;
    XY := x*10 + y;
    case s90Char[i] of
      'C': if (qzXY[01]=$FF) then qzXY[01]:=XY else qzXY[09]:=XY;
      'M': if (qzXY[02]=$FF) then qzXY[02]:=XY else qzXY[08]:=XY;
      'X': if (qzXY[03]=$FF) then qzXY[03]:=XY else qzXY[07]:=XY;
      'S': if (qzXY[04]=$FF) then qzXY[04]:=XY else qzXY[06]:=XY;
      'J': qzXY[05]:=XY;
      'P': if (qzXY[10]=$FF) then qzXY[10]:=XY else qzXY[11]:=XY;
      'B': for j:=12 to 16 do if qzXY[j]=$FF then
           begin
             qzXY[j]:=XY; break;
           end;
      'c': if (qzXY[17]=$FF) then qzXY[17]:=XY else qzXY[25]:=XY;
      'm': if (qzXY[18]=$FF) then qzXY[18]:=XY else qzXY[24]:=XY;
      'x': if (qzXY[19]=$FF) then qzXY[19]:=XY else qzXY[23]:=XY;
      's': if (qzXY[20]=$FF) then qzXY[20]:=XY else qzXY[22]:=XY;
      'j': qzXY[21]:=XY;
      'p': if (qzXY[26]=$FF) then qzXY[26]:=XY else qzXY[27]:=XY;
      'b': for j:=28 to 32 do if qzXY[j]=$FF then
           begin
             qzXY[j]:=XY; break;
           end;
      'Z': begin end;
      else
        begin
          ShowMessage('Error Character');
        end;
    end;
  end;
end;

//-------------------------------------------------------------------------
// ���������ƵĲ�����������ƶ�������
//.........................................................................
procedure dXQZXYtoXYfXYt(var XYf, XYt: dTByte; qzXYf, qzXYt: dTXQZXY);
var
  i: dTInt32;
begin
  XYf:=$FF; XYt:=$FF;
  for i:=1 to 32 do
  begin
    if (qzXYf[i] <> qzXYt[i]) then
    begin
      if (qzXYt[i]<>$FF) then
      begin
        XYf := qzXYf[i];  XYt := qzXYt[i];  Exit;
      end;
    end;
  end;
end;

procedure dMakeQiTuText(var mem: TMemo; sRed, sBlk: String;
            qzXY:dTXQZXY; wp: dTWhoPlay; iMode: integer; bRL: Boolean;
            bBbsColor:Boolean);
var
  i        : integer;
  s, sBlank: string[128];
  sMemText : string;

procedure dInsertQiZiToQiTuText(iIdx, iPos: integer);
var
  iTopLine, iLeftLine : integer;
  sQZName             : string[6];
  sQPLine             : string[128];
  iX,iY, iC: integer;
begin
  case iIdx of
    01,09,17,25: sQZName := '��';
    02,08,18,24: sQZName := '��';
    03,07      : sQZName := '��';
    19,23      : sQZName := '��';
    04,06,20,22: sQZName := 'ʿ';
    05         : sQZName := '˧';
    21         : sQZName := '��';
    10,11,26,27: sQZName := '��';
    12..16     : sQZName := '��';
    28..32     : sQZName := '��';
    else         Exit;
  end;

  case iIdx of
     1..16: sQZName := '-(' + sQZName + ')-';
    17..32: sQZName := '-[' + sQZName + ']-';
  end;

  iTopLine  := 3;
  iLeftLine := 0;
  iX        := iPos div 10;  if bRL then iX := 8 - iX;
  iX := iX * 4 + iLeftLine;
  iY        := iPos mod 10;    iY := (9-iY) * 2 + iTopLine;
  sQPLine   := mem.Lines[iY];
  for iC :=1 to Length(sQZName) do
  begin
    if ((sQPLine[iX + iC]=' ') and (sQZName[iC]='-')) then Continue;
    if (sQPLine[iX + iC] in ['(',')','[',']']) then Continue;
    sQPLine[iX + iC] := sQZName[iC];
  end;
  mem.Lines[iY] := sQPLine;
end;

begin
  // �����ı��Ŀ�ȣ��ÿհ��б�ʾ
  case iMode of
    0: sBlank := '                                      ';
    1: sBlank := '                  ';
  end;
  
  mem.Lines.Add('');
  // ����ڷ���������
  sBlk := '�ڷ� ' + sBlk;  sBlk := Trim(sBlk);
  if (Length(sBlk) >= Length(sBlank)) then
  begin
    s := sBlk;
  end
  else
  begin
    s := sBlank;
    Insert(sBlk, s, (Length(s)-Length(sBlk)) div 2 + 1);
    SetLength(S, Length(s) - Length(sBlk));
  end;
  mem.Lines.Add(s);

  mem.Lines.Add(sBlank);                // �������

  // �������̵ĸ�ʽ
  mem.Lines.Add('  �����Щ��Щ��Щ��Щ��Щ��Щ��Щ���  ');
  mem.Lines.Add('  ���������������ܩ�����������������  ');
  mem.Lines.Add('  �����੤�੤�੤�����੤�੤�੤��  ');
  mem.Lines.Add('  �������������������ܩ�������������  ');
  mem.Lines.Add('  �����੤�੤�੤�੤�੤�੤�੤��  ');
  mem.Lines.Add('  ����������������������������������  ');
  mem.Lines.Add('  �����੤�੤�੤�੤�੤�੤�੤��  ');
  mem.Lines.Add('  ����������������������������������  ');
  mem.Lines.Add('  �����ة��ة��ة��ة��ة��ة��ة���  ');
  mem.Lines.Add('  ����������������������������������  ');
  mem.Lines.Add('  �����Щ��Щ��Щ��Щ��Щ��Щ��Щ���  ');
  mem.Lines.Add('  ����������������������������������  ');
  mem.Lines.Add('  �����੤�੤�੤�੤�੤�੤�੤��  ');
  mem.Lines.Add('  ����������������������������������  ');
  mem.Lines.Add('  �����੤�੤�੤�੤�੤�੤�੤��  ');
  mem.Lines.Add('  ���������������ܩ�����������������  ');
  mem.Lines.Add('  �����੤�੤�੤�����੤�੤�੤��  ');
  mem.Lines.Add('  �������������������ܩ�������������  ');
  mem.Lines.Add('  �����ة��ة��ة��ة��ة��ة��ة���  ');

  mem.Lines.Add(sBlank);
  
  // ����췽��������
  sRed := '�췽 ' + sRed;  sRed := Trim(sRed);
  if (Length(sRed) >= Length(sBlank)) then
  begin
    s := sRed;
  end
  else
  begin
    s := sBlank;
    Insert(sRed, s, (Length(s)-Length(sRed)) div 2 + 1);
    SetLength(S, Length(s) - Length(sRed));
  end;
  mem.Lines.Add(s);

  // ����32�����ӵ�λ��(ʹ�ñ�׼��ʽ������[]��()���ı���ʽ)
  for i:=1 to 32 do
  begin
    if (qzXY[i] = $FF) then Continue;
    dInsertQiZiToQiTuText(i, qzXY[i]);
  end;

  // ���ݲ�ͬ�ĸ�ʽ���µ�����ʾ
  case iMode of
    0: // ��׼��ʽ
      begin
        //for i:=0 to 22 do
        //begin
        //  mem.Lines[i] := '|  ' + mem.Lines[i];
        //end;
      end;

    1: // �����ֱ�ʾ
      begin
        s := '������������';
        mem.Lines[ 1] := mem.Lines[ 1] + s;
        mem.Lines[ 2] := mem.Lines[ 2] + s;
        mem.Lines[22] := mem.Lines[22] + s;
        mem.Lines[23] := mem.Lines[23] + s;

        for i:=21 downto 3 do
        begin
          if ((i Mod 2)=0) then
          begin
            mem.Lines.Delete(i);
            Continue;
          end;
          s := mem.Lines[i];
          s := StringReplace(s, '(��)', '�', [rfReplaceAll]);
          s := StringReplace(s, '(��)', '��', [rfReplaceAll]);
          s := StringReplace(s, '[��]', '��', [rfReplaceAll]);
          s := StringReplace(s, '(ʿ)', '��', [rfReplaceAll]);
          s := StringReplace(s,    '[',   '', [rfReplaceAll]);
          s := StringReplace(s,    ']',   '', [rfReplaceAll]);
          s := StringReplace(s,    '(',   '', [rfReplaceAll]);
          s := StringReplace(s,    ')',   '', [rfReplaceAll]);
          s := StringReplace(s,    ' ',   '', [rfReplaceAll]);
          s := StringReplace(s,   '��',   '', [rfReplaceAll]);
          s := StringReplace(s,    '-',   '', [rfReplaceAll]);
          case i of
             3: s := s + '�����졡�ڡ�';
             5: s := s + '������������';
             7: s := s + '����������';
             9: s := s + '�����롡��';
            11: s := s + '�����ࡡ��';
            13: s := s + '�����ˡ�ʿ��';
            15: s := s + '����˧������';
            17: s := s + '�����ڡ�����';
            19: s := s + '���������䡡';
            21:
              begin
                case wp of
                  wpRed: s := s + '��(�췽����)';
                  wpBlk: s := s + '��(�ڷ�����)';
                end;
              end;
          end;
          mem.Lines[i] := s;
        end; // End of for;

        mem.Lines.Insert(1, '������������������������������');
        mem.Lines.Append(   '������������������������������');
      end;
  end;

  // ����ǵĿո��滻Ϊȫ�ǵĿո�
  for i:= 0 to (mem.Lines.Count - 1) do
  begin
    s := mem.Lines[i];
    s := StringReplace(s, '  ', '��', [rfReplaceAll]);
    mem.Lines[i] := s;
  end;

  if (bBbsColor) then
  begin
    sMemText := mem.Text;
    case iMode of
    0: // ��׼��ʽ
      begin
        sMemText := StringReplace(sMemText, '[', #27#27'[1;32m[', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, ']', ']'#27#27'[0m',    [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '(', #27#27'[1;31m(', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, ')', ')'#27#27'[0m',    [rfReplaceAll]);
      end;
    1: // �����ֱ�ʾ
      begin
        sMemText := StringReplace(sMemText, '�', #27#27'[1;31m�'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;31m��'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;31m��'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;31m��'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '˧', #27#27'[1;31m˧'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;31m��'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;31m��'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;32m��'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;32m��'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;32m��'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, 'ʿ', #27#27'[1;32mʿ'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;32m��'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;32m��'#27#27'[0m', [rfReplaceAll]);
        sMemText := StringReplace(sMemText, '��', #27#27'[1;32m��'#27#27'[0m', [rfReplaceAll]);
      end;
    end;
    // �����������
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    // ����ͼר��
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '��', #27#27'[1;33m��'#27#27'[0m', [rfReplaceAll]);
    sMemText := StringReplace(sMemText, '-',  #27#27'[1;33m-'#27#27'[0m',  [rfReplaceAll]);
    mem.Text := sMemText;
  end;

  if (iMode = 1) then mem.Lines.Add('����������(www.qipaile.net)');
end;

// �ж������Ƿ����λ�ڵ�ǰ��λ��
function isQiziCanAtXY(Idx, XYx, XYy: dTInt32): dTBoolean;
var
  XY: dTInt32;
begin
  isQiziCanAtXY := True;
  XY := XYx*10 + XYy;
  case Idx of
    1, 9, 2, 8, 10, 11, 17, 25, 18, 24, 26, 27:  // ��������
      begin
        Exit;
      end;
    12..16: // ���
      begin
        if (XYy > 4) then Exit;
        if (XY in [03,04, 23, 24, 43, 44, 63, 64, 83, 84]) then Exit;
      end;
    28..32: // ����
      begin
        if (XYy < 5) then Exit;
        if (XY in [05,06, 25, 26, 45, 46, 65, 66, 85, 86]) then Exit;
      end;
    3, 7: // ����
      begin
        if (XY in [02, 20, 24, 42, 60, 64, 82]) then Exit;
      end;
    19, 23: // ����
      begin
        if (XY in [07, 25, 29, 47, 65, 69, 87]) then Exit;
      end;
    4, 6: //��ʿ
      begin
        if (XY in [30, 32, 41, 50, 52]) then Exit;
      end;
    20, 22: //��ʿ
      begin
        if (XY in [37, 39, 48, 57, 59]) then Exit;
      end;
    5: // ��˧
      begin
        if (XY in [30,31,32,40,41,42,50,51,52]) then Exit;
      end;
    21: // �ڽ�
      begin
        if (XY in [37,38,39,47,48,49,57,58,59]) then Exit;
      end;
  end;
  isQiziCanAtXY := False;
end;

// �������һ�����������ʧ��
procedure dMakeStandardQzXY(var qzXY: dTXQZXY);
begin
  Exit;
end;

// �жϾ����Ƿ���ͬ
var
  iSearchXYPieceNum: array [1..14] of Integer;
procedure dSetSearchQzXYParam(qzXY: dTXQZXY);
var
  i: Integer;
begin
  for i:=1 to 14 do iSearchXYPieceNum[i] := 0;

  if (qzXY[ 1] <= 89) then Inc(iSearchXYPieceNum[ 1]);
  if (qzXY[ 9] <= 89) then Inc(iSearchXYPieceNum[ 1]);
  if (qzXY[ 2] <= 89) then Inc(iSearchXYPieceNum[ 2]);
  if (qzXY[ 8] <= 89) then Inc(iSearchXYPieceNum[ 2]);
  if (qzXY[ 3] <= 89) then Inc(iSearchXYPieceNum[ 3]);
  if (qzXY[ 7] <= 89) then Inc(iSearchXYPieceNum[ 3]);
  if (qzXY[ 4] <= 89) then Inc(iSearchXYPieceNum[ 4]);
  if (qzXY[ 6] <= 89) then Inc(iSearchXYPieceNum[ 4]);
  if (qzXY[ 5] <= 89) then Inc(iSearchXYPieceNum[ 5]);
  if (qzXY[10] <= 89) then Inc(iSearchXYPieceNum[ 6]);
  if (qzXY[11] <= 89) then Inc(iSearchXYPieceNum[ 6]);
  if (qzXY[12] <= 89) then Inc(iSearchXYPieceNum[ 7]);
  if (qzXY[13] <= 89) then Inc(iSearchXYPieceNum[ 7]);
  if (qzXY[14] <= 89) then Inc(iSearchXYPieceNum[ 7]);
  if (qzXY[15] <= 89) then Inc(iSearchXYPieceNum[ 7]);
  if (qzXY[16] <= 89) then Inc(iSearchXYPieceNum[ 7]);

  if (qzXY[17] <= 89) then Inc(iSearchXYPieceNum[ 8]);
  if (qzXY[25] <= 89) then Inc(iSearchXYPieceNum[ 8]);
  if (qzXY[18] <= 89) then Inc(iSearchXYPieceNum[ 9]);
  if (qzXY[24] <= 89) then Inc(iSearchXYPieceNum[ 9]);
  if (qzXY[19] <= 89) then Inc(iSearchXYPieceNum[10]);
  if (qzXY[23] <= 89) then Inc(iSearchXYPieceNum[10]);
  if (qzXY[20] <= 89) then Inc(iSearchXYPieceNum[11]);
  if (qzXY[22] <= 89) then Inc(iSearchXYPieceNum[11]);
  if (qzXY[21] <= 89) then Inc(iSearchXYPieceNum[12]);
  if (qzXY[26] <= 89) then Inc(iSearchXYPieceNum[13]);
  if (qzXY[27] <= 89) then Inc(iSearchXYPieceNum[13]);
  if (qzXY[28] <= 89) then Inc(iSearchXYPieceNum[14]);
  if (qzXY[29] <= 89) then Inc(iSearchXYPieceNum[14]);
  if (qzXY[30] <= 89) then Inc(iSearchXYPieceNum[14]);
  if (qzXY[31] <= 89) then Inc(iSearchXYPieceNum[14]);
  if (qzXY[32] <= 89) then Inc(iSearchXYPieceNum[14]);
end;

function IsQzXYSame(var qzXY1, qzXY2: dTXQZXY; bQzNumOnly, bIgnoreYz: Boolean): Boolean;
var
  i, AQzNum1, AQzNum2: Integer;
  iPn: array [1..14] of Integer;
begin
  Result := False;

  if bQzNumOnly then
  begin
    for i:=1 to 14 do iPn[i] := 0;

    if (qzXY2[ 1] <= 89) then Inc(iPn[ 1]);
    if (qzXY2[ 9] <= 89) then Inc(iPn[ 1]);
    if (qzXY2[ 2] <= 89) then Inc(iPn[ 2]);
    if (qzXY2[ 8] <= 89) then Inc(iPn[ 2]);
    if (qzXY2[ 3] <= 89) then Inc(iPn[ 3]);
    if (qzXY2[ 7] <= 89) then Inc(iPn[ 3]);
    if (qzXY2[ 4] <= 89) then Inc(iPn[ 4]);
    if (qzXY2[ 6] <= 89) then Inc(iPn[ 4]);
    if (qzXY2[ 5] <= 89) then Inc(iPn[ 5]);
    if (qzXY2[10] <= 89) then Inc(iPn[ 6]);
    if (qzXY2[11] <= 89) then Inc(iPn[ 6]);
    if (qzXY2[12] <= 89) then Inc(iPn[ 7]);
    if (qzXY2[13] <= 89) then Inc(iPn[ 7]);
    if (qzXY2[14] <= 89) then Inc(iPn[ 7]);
    if (qzXY2[15] <= 89) then Inc(iPn[ 7]);
    if (qzXY2[16] <= 89) then Inc(iPn[ 7]);

    if (qzXY2[17] <= 89) then Inc(iPn[ 8]);
    if (qzXY2[25] <= 89) then Inc(iPn[ 8]);
    if (qzXY2[18] <= 89) then Inc(iPn[ 9]);
    if (qzXY2[24] <= 89) then Inc(iPn[ 9]);
    if (qzXY2[19] <= 89) then Inc(iPn[10]);
    if (qzXY2[23] <= 89) then Inc(iPn[10]);
    if (qzXY2[20] <= 89) then Inc(iPn[11]);
    if (qzXY2[22] <= 89) then Inc(iPn[11]);
    if (qzXY2[21] <= 89) then Inc(iPn[12]);
    if (qzXY2[26] <= 89) then Inc(iPn[13]);
    if (qzXY2[27] <= 89) then Inc(iPn[13]);
    if (qzXY2[28] <= 89) then Inc(iPn[14]);
    if (qzXY2[29] <= 89) then Inc(iPn[14]);
    if (qzXY2[30] <= 89) then Inc(iPn[14]);
    if (qzXY2[31] <= 89) then Inc(iPn[14]);
    if (qzXY2[32] <= 89) then Inc(iPn[14]);

    if bIgnoreYz then
    begin
      for i:=1 to 14 do if iPn[i] < iSearchXYPieceNum[i] then Exit;
      Result := True;
    end
    else
    begin
      for i:=1 to 14 do if iPn[i] <> iSearchXYPieceNum[i] then Exit;
      Result := True;
    end;
    Exit;
  end;

  if (bIgnoreYz) then
  begin
    if (qzXY1[ 1] <= 89) then
    if (qzXY1[ 1]<>qzXY2[ 1])and(qzXY1[ 1]<>qzXY2[ 9]) then Exit;   // ��1
    if (qzXY1[ 9] <= 89) then
    if (qzXY1[ 9]<>qzXY2[ 1])and(qzXY1[ 9]<>qzXY2[ 9]) then Exit;   // ��2
    if (qzXY1[ 2] <= 89) then
    if (qzXY1[ 2]<>qzXY2[ 2])and(qzXY1[ 2]<>qzXY2[ 8]) then Exit;   // ��1
    if (qzXY1[ 8] <= 89) then
    if (qzXY1[ 8]<>qzXY2[ 2])and(qzXY1[ 8]<>qzXY2[ 8]) then Exit;   // ��2
    if (qzXY1[ 3] <= 89) then
    if (qzXY1[ 3]<>qzXY2[ 3])and(qzXY1[ 3]<>qzXY2[ 7]) then Exit;   // ��1
    if (qzXY1[ 7] <= 89) then
    if (qzXY1[ 7]<>qzXY2[ 3])and(qzXY1[ 7]<>qzXY2[ 7]) then Exit;   // ��2
    if (qzXY1[ 4] <= 89) then
    if (qzXY1[ 4]<>qzXY2[ 4])and(qzXY1[ 4]<>qzXY2[ 6]) then Exit;   // ʿ1
    if (qzXY1[ 6] <= 89) then
    if (qzXY1[ 6]<>qzXY2[ 4])and(qzXY1[ 6]<>qzXY2[ 6]) then Exit;   // ʿ2
    if (qzXY1[ 5] <= 89) then
    if (qzXY1[ 5]<>qzXY2[ 5])and(qzXY1[ 5]<>qzXY2[ 5]) then Exit;   // ˧
    if (qzXY1[10] <= 89) then
    if (qzXY1[10]<>qzXY2[10])and(qzXY1[10]<>qzXY2[11]) then Exit;   // ��1
    if (qzXY1[11] <= 89) then
    if (qzXY1[11]<>qzXY2[10])and(qzXY1[11]<>qzXY2[11]) then Exit;   // ��2
    if (qzXY1[12] <= 89) then
    if (qzXY1[12]<>qzXY2[12])and(qzXY1[12]<>qzXY2[13]) and          // ��1
       (qzXY1[12]<>qzXY2[14])and(qzXY1[12]<>qzXY2[15]) and
       (qzXY1[12]<>qzXY2[16])then Exit;
    if (qzXY1[13] <= 89) then
    if (qzXY1[13]<>qzXY2[12])and(qzXY1[13]<>qzXY2[13]) and          // ��2
       (qzXY1[13]<>qzXY2[14])and(qzXY1[13]<>qzXY2[15]) and
       (qzXY1[13]<>qzXY2[16])then Exit;
    if (qzXY1[14] <= 89) then
    if (qzXY1[14]<>qzXY2[12])and(qzXY1[14]<>qzXY2[13]) and          // ��3
       (qzXY1[14]<>qzXY2[14])and(qzXY1[14]<>qzXY2[15]) and
       (qzXY1[14]<>qzXY2[16])then Exit;
    if (qzXY1[15] <= 89) then
    if (qzXY1[15]<>qzXY2[12])and(qzXY1[15]<>qzXY2[13]) and          // ��4
       (qzXY1[15]<>qzXY2[14])and(qzXY1[15]<>qzXY2[15]) and
       (qzXY1[15]<>qzXY2[16])then Exit;
    if (qzXY1[16] <= 89) then
    if (qzXY1[16]<>qzXY2[12])and(qzXY1[16]<>qzXY2[13]) and          // ��5
       (qzXY1[16]<>qzXY2[14])and(qzXY1[16]<>qzXY2[15]) and
       (qzXY1[16]<>qzXY2[16])then Exit;

    // �����ӵ�λ��
    if (qzXY1[17] <= 89) then
    if (qzXY1[17]<>qzXY2[17])and(qzXY1[17]<>qzXY2[25]) then Exit;   // ��1
    if (qzXY1[25] <= 89) then
    if (qzXY1[25]<>qzXY2[17])and(qzXY1[25]<>qzXY2[25]) then Exit;   // ��2
    if (qzXY1[18] <= 89) then
    if (qzXY1[18]<>qzXY2[18])and(qzXY1[18]<>qzXY2[24]) then Exit;   // ��1
    if (qzXY1[24] <= 89) then
    if (qzXY1[24]<>qzXY2[18])and(qzXY1[24]<>qzXY2[24]) then Exit;   // ��2
    if (qzXY1[19] <= 89) then
    if (qzXY1[19]<>qzXY2[19])and(qzXY1[19]<>qzXY2[23]) then Exit;   // ��1
    if (qzXY1[23] <= 89) then
    if (qzXY1[23]<>qzXY2[19])and(qzXY1[23]<>qzXY2[23]) then Exit;   // ��2
    if (qzXY1[20] <= 89) then
    if (qzXY1[20]<>qzXY2[20])and(qzXY1[20]<>qzXY2[22]) then Exit;   // ʿ1
    if (qzXY1[22] <= 89) then
    if (qzXY1[22]<>qzXY2[20])and(qzXY1[22]<>qzXY2[22]) then Exit;   // ʿ2
    if (qzXY1[21] <= 89) then
    if (qzXY1[21]<>qzXY2[21])and(qzXY1[21]<>qzXY2[21]) then Exit;   // ��
    if (qzXY1[26] <= 89) then
    if (qzXY1[26]<>qzXY2[26])and(qzXY1[26]<>qzXY2[27]) then Exit;   // ��1
    if (qzXY1[27] <= 89) then
    if (qzXY1[27]<>qzXY2[26])and(qzXY1[27]<>qzXY2[27]) then Exit;   // ��2
    if (qzXY1[28] <= 89) then
    if (qzXY1[28]<>qzXY2[28])and(qzXY1[28]<>qzXY2[29]) and          // ��1
       (qzXY1[28]<>qzXY2[30])and(qzXY1[28]<>qzXY2[31]) and
       (qzXY1[28]<>qzXY2[32])then Exit;
    if (qzXY1[29] <= 89) then
    if (qzXY1[29]<>qzXY2[28])and(qzXY1[29]<>qzXY2[29]) and          // ��2
       (qzXY1[29]<>qzXY2[30])and(qzXY1[29]<>qzXY2[31]) and
       (qzXY1[29]<>qzXY2[32])then Exit;
    if (qzXY1[20] <= 89) then
    if (qzXY1[30]<>qzXY2[28])and(qzXY1[30]<>qzXY2[29]) and          // ��3
       (qzXY1[30]<>qzXY2[30])and(qzXY1[30]<>qzXY2[31]) and
       (qzXY1[30]<>qzXY2[32])then Exit;
    if (qzXY1[31] <= 89) then
    if (qzXY1[31]<>qzXY2[28])and(qzXY1[31]<>qzXY2[29]) and          // ��4
       (qzXY1[31]<>qzXY2[30])and(qzXY1[31]<>qzXY2[31]) and
       (qzXY1[31]<>qzXY2[32])then Exit;
    if (qzXY1[21] <= 89) then
    if (qzXY1[32]<>qzXY2[28])and(qzXY1[32]<>qzXY2[29]) and          // ��5
       (qzXY1[32]<>qzXY2[30])and(qzXY1[32]<>qzXY2[31]) and
       (qzXY1[32]<>qzXY2[32])then Exit;
    Result := True;
    Exit;
  end;

  // �����ӵ�λ��
  if (qzXY1[ 1]<>qzXY2[ 1])and(qzXY1[ 1]<>qzXY2[ 9]) then Exit;   // ��1
  if (qzXY1[ 9]<>qzXY2[ 1])and(qzXY1[ 9]<>qzXY2[ 9]) then Exit;   // ��2
  if (qzXY1[ 2]<>qzXY2[ 2])and(qzXY1[ 2]<>qzXY2[ 8]) then Exit;   // ��1
  if (qzXY1[ 8]<>qzXY2[ 2])and(qzXY1[ 8]<>qzXY2[ 8]) then Exit;   // ��2
  if (qzXY1[ 3]<>qzXY2[ 3])and(qzXY1[ 3]<>qzXY2[ 7]) then Exit;   // ��1
  if (qzXY1[ 7]<>qzXY2[ 3])and(qzXY1[ 7]<>qzXY2[ 7]) then Exit;   // ��2
  if (qzXY1[ 4]<>qzXY2[ 4])and(qzXY1[ 4]<>qzXY2[ 6]) then Exit;   // ʿ1
  if (qzXY1[ 6]<>qzXY2[ 4])and(qzXY1[ 6]<>qzXY2[ 6]) then Exit;   // ʿ2
  if (qzXY1[ 5]<>qzXY2[ 5])and(qzXY1[ 5]<>qzXY2[ 5]) then Exit;   // ˧
  if (qzXY1[10]<>qzXY2[10])and(qzXY1[10]<>qzXY2[11]) then Exit;   // ��1
  if (qzXY1[11]<>qzXY2[10])and(qzXY1[11]<>qzXY2[11]) then Exit;   // ��2
  if (qzXY1[12]<>qzXY2[12])and(qzXY1[12]<>qzXY2[13]) and          // ��1
     (qzXY1[12]<>qzXY2[14])and(qzXY1[12]<>qzXY2[15]) and
     (qzXY1[12]<>qzXY2[16])then Exit;
  if (qzXY1[13]<>qzXY2[12])and(qzXY1[13]<>qzXY2[13]) and          // ��2
     (qzXY1[13]<>qzXY2[14])and(qzXY1[13]<>qzXY2[15]) and
     (qzXY1[13]<>qzXY2[16])then Exit;
  if (qzXY1[14]<>qzXY2[12])and(qzXY1[14]<>qzXY2[13]) and          // ��3
     (qzXY1[14]<>qzXY2[14])and(qzXY1[14]<>qzXY2[15]) and
     (qzXY1[14]<>qzXY2[16])then Exit;
  if (qzXY1[15]<>qzXY2[12])and(qzXY1[15]<>qzXY2[13]) and          // ��4
     (qzXY1[15]<>qzXY2[14])and(qzXY1[15]<>qzXY2[15]) and
     (qzXY1[15]<>qzXY2[16])then Exit;
  if (qzXY1[16]<>qzXY2[12])and(qzXY1[16]<>qzXY2[13]) and          // ��5
     (qzXY1[16]<>qzXY2[14])and(qzXY1[16]<>qzXY2[15]) and
     (qzXY1[16]<>qzXY2[16])then Exit;

  // �����ӵ�λ��
  if (qzXY1[17]<>qzXY2[17])and(qzXY1[17]<>qzXY2[25]) then Exit;   // ��1
  if (qzXY1[25]<>qzXY2[17])and(qzXY1[25]<>qzXY2[25]) then Exit;   // ��2
  if (qzXY1[18]<>qzXY2[18])and(qzXY1[18]<>qzXY2[24]) then Exit;   // ��1
  if (qzXY1[24]<>qzXY2[18])and(qzXY1[24]<>qzXY2[24]) then Exit;   // ��2
  if (qzXY1[19]<>qzXY2[19])and(qzXY1[19]<>qzXY2[23]) then Exit;   // ��1
  if (qzXY1[23]<>qzXY2[19])and(qzXY1[23]<>qzXY2[23]) then Exit;   // ��2
  if (qzXY1[20]<>qzXY2[20])and(qzXY1[20]<>qzXY2[22]) then Exit;   // ʿ1
  if (qzXY1[22]<>qzXY2[20])and(qzXY1[22]<>qzXY2[22]) then Exit;   // ʿ2
  if (qzXY1[21]<>qzXY2[21])and(qzXY1[21]<>qzXY2[21]) then Exit;   // ��
  if (qzXY1[26]<>qzXY2[26])and(qzXY1[26]<>qzXY2[27]) then Exit;   // ��1
  if (qzXY1[27]<>qzXY2[26])and(qzXY1[27]<>qzXY2[27]) then Exit;   // ��2
  if (qzXY1[28]<>qzXY2[28])and(qzXY1[28]<>qzXY2[29]) and          // ��1
     (qzXY1[28]<>qzXY2[30])and(qzXY1[28]<>qzXY2[31]) and
     (qzXY1[28]<>qzXY2[32])then Exit;
  if (qzXY1[29]<>qzXY2[28])and(qzXY1[29]<>qzXY2[29]) and          // ��2
     (qzXY1[29]<>qzXY2[30])and(qzXY1[29]<>qzXY2[31]) and
     (qzXY1[29]<>qzXY2[32])then Exit;
  if (qzXY1[30]<>qzXY2[28])and(qzXY1[30]<>qzXY2[29]) and          // ��3
     (qzXY1[30]<>qzXY2[30])and(qzXY1[30]<>qzXY2[31]) and
     (qzXY1[30]<>qzXY2[32])then Exit;
  if (qzXY1[31]<>qzXY2[28])and(qzXY1[31]<>qzXY2[29]) and          // ��4
     (qzXY1[31]<>qzXY2[30])and(qzXY1[31]<>qzXY2[31]) and
     (qzXY1[31]<>qzXY2[32])then Exit;
  if (qzXY1[32]<>qzXY2[28])and(qzXY1[32]<>qzXY2[29]) and          // ��5
     (qzXY1[32]<>qzXY2[30])and(qzXY1[32]<>qzXY2[31]) and
     (qzXY1[32]<>qzXY2[32])then Exit;

  // ͳ�����ӵĸ���
  AQzNum1 := 0; for i:=1 to 32 do if (qzXY1[i] = $FF) then Inc(AQzNum1);
  AQzNum2 := 0; for i:=1 to 32 do if (qzXY2[i] = $FF) then Inc(AQzNum2);
  if (AQzNum1 <> AQzNum2) then Exit;

  Result := True;
end;

function  isClipBoardTextQipu: Boolean;
begin
  Result := False;
  if (not Clipboard.HasFormat(CF_TEXT)) then Exit;
  try
    if (Length(ClipBoard.AsText) < 128) then Exit;
    if (Length(ClipBoard.AsText) > 20480) then Exit;
  except
    Exit;
  end;
  Result := True;
end;

function  sGetCmdLineXqfName: String;
var
  s       : string;
  sCmdLine: String;
  iPos    : Integer;
begin
   Result := '';
   s := ParamStr(1);
   if (s<>'') then
   begin
     if FileExists(s) then
     begin
       Result := s;
       Exit;
     end
     else
     begin
       sCmdLine := UpperCase(CmdLine);
       iPos := Pos('.EXE', sCmdLine);
       if (iPos > 0) then
       begin
         s := Trim(Copy(sCmdLine, iPos + 4, 512));
         s := StringReplace(s, '"', '', [rfReplaceAll]);
         if FileExists(s) then
         begin
           Result := s;
           Exit;
         end;
       end;
     end;
     Exit;
   end
end;

end.


//-------------------------------------------------------------------------
//
//       17-18-19-20-21-22-23-24-25
//        |  |  |  | \|/ |  |  |  |
//        |--+--+--+--+--+--+--+--|
//        |  |  |  | /|\ |  |  |  |
//        |-26--+--+--+--+--+-27--|
//        |  |  |  |  |  |  |  |  |
//       28--+-29--+-30--+-31--+-32
//        |  |  |  |  |  |  |  |  |
//        |-----------------------|
//        |                       |
//        |-----------------------|
//        |  |  |  |  |  |  |  |  |
//       16--+-15--+-14--+-13--+-12
//        |  |  |  |  |  |  |  |  |
//        |-11--+--+--+--+--+-10--|
//        |  |  |  | \|/ |  |  |  |
//        |--+--+--+--+--+--+--+--|
//        |  |  |  | /|\ |  |  |  |
//       09-08-07-06-05-04-03-02-01
//
//-------------------------------------------------------------------------


