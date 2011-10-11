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

unit XQPNode;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, dDelphiS, XQDataT;

type
  //-----------------------------------------------------------------------
  // ����һ�������¼�ڵ�(�����¼��), �������ӡ����ֵܵı�ʾ����
  // ���������¼�Ķ���������������ֵܵĶ�������ʾ��ͬʱÿ���ڵ�
  // ��һ��ָ��ԭ�����������׽ڵ�(����һ����)��ָ�롣
  //.......................................................................
  dTXQPlayNode = class
  public
    StepNo      : dTInt32;                      // �ڼ���������״̬Ϊ��0��
    StrRec      : String[10];                   // ����������, ��'�ڶ�ƽ��'
    XYf         : dTBYTE;                       // ���������ʼλ��XY
    XYt         : dTBYTE;                       // �������Ŀ��λ��XY
    QiziXY      : dTXQZXY;                      // �������ߺ�32���ӵ�λ��
    Remark      : TStringList;                  // �������ע��
    LastStepNode: dTXQPlayNode;                 // ��һ����Ľڵ�
    LParent     : dTXQPlayNode;                 // ˫�׽ڵ�
    RParent     : dTXQPlayNode;                 // LParent��RParent������
                                                // һ��Ϊnil,  ����ýڵ�
                                                // ��˫�׵����ӣ���LPΪ
                                                // nil, ��֮, RPΪnil
    LChild      : dTXQPlayNode;                 // ����
    LChildTag   : dTInt32;                      //   ���ӵı��
    RChild      : dTXQPlayNode;                 // �Һ��� (ʵ�����ֵ�)
    RChildTag   : dTInt32;                      //   �Һ��ӵı��

    procedure dSetLChild(Node: dTXQPlayNode);   // ��������
    procedure dSetRChild(Node: dTXQPlayNode);   // �����Һ���

    // ���캯��
    constructor Create(iStepNo:dTInt32; sStrRec:String; bXYf, bXYt:dTBYTE;
                       qzXY:dTXQZXY; slRMK:TStringList;
                       LN,LP,RP:dTXQPlayNode);
    // ��������
    destructor Destroy; override;
  end;

implementation
procedure dTXQPlayNode.dSetLChild(Node: dTXQPlayNode);
begin
  LChild := Node;
  if (Node <> nil) then begin Node.RParent:=Self; Node.LParent:=nil; end;
end;

procedure dTXQPlayNode.dSetRChild(Node: dTXQPlayNode);
begin
  RChild := Node;
  if (Node <> nil) then begin Node.LParent:=Self; Node.RParent:=nil; end;
end;

constructor dTXQPlayNode.Create(iStepNo:dTInt32; sStrRec:String;
                            bXYf,bXYt:dTBYTE; qzXY:dTXQZXY;
                            slRMK:TStringList; LN,LP,RP:dTXQPlayNode);
var
  i: dTInt32;
begin
  StepNo:=iStepNo; StrRec:=sStrRec; XYf:=bXYf; XYt:=bXYt;
  for i:=1 to 32 do QiziXY[i]:=qzXY[i];
  Remark:=slRMK; LastStepNode:=LN;
  LParent:=LP; RParent:=RP; LChild:=nil; RChild:=nil;
  if (LParent <> nil) then LParent.RChild := Self;
  if (RParent <> nil) then RParent.LChild := Self;
end;

destructor dTXQPlayNode.Destroy;
begin
  // �ȶϿ���˫�׵�����
  if (LParent <> nil) then LParent.RChild := nil;
  if (RParent <> nil) then RParent.LChild := nil;

  if (LChild <> nil) then LChild.Free;
  if (RChild <> nil) then RChild.Free;

  if (Remark <> nil) then Remark.Free;

  // ShowMessage(StrRec + 'Free');
end;

end.
