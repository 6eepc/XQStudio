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

unit XQView;

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, dDelphiS, XQDataT, XQPNode;

interface
  //-----------------------------------------------------------------------
  // ����������
  //.......................................................................
  dTXQView = class
  public
    BoardImage  : TImage;                       // ������ͼ��
    BoardXY     : dTXQPXY;                      // ����9x10�������
    QiziMoveImg : TImage;                       // �ƶ������ӵ�ͼ��
                                                // ���������ƶ�
    Qizi        : array [1..32] of dTXQZ;       // 32��������
    QiziMove    : dTXQZ;                        // �������ƶ�������
    MovePosFrom : TImage;                       // ����ƶ��������ӵ�λ��
    MovePosTo   : TImage;                       //   ������ʾ����ָʾ
  public
    constructor Create(imgBoard: TImage; imgXY: dTXQPXY; imgQZMove: TImage;
                       imgLastMovePos: TImage;  picQZ: dTXQZPIC);
    destructor Destroy; override;

    procedure dStartMoveFromXY(XY:dTBYTE);      // ��XY����ʼ�ƶ�����
    procedure dStopMoveAtXY(XY:dTBYTE);         // �ƶ�ֹͣ��XY��
    procedure dUndoMove;                        // ȡ���ƶ�
    procedure dRefreshBoard(ReStart:Boolean);
    procedure dDispQiziAtRecNo(iRec: dTINT32);  // ��ʾiRec�������
    procedure dMoveMemoToRecNo(iRec:dTINT32);   // ��ע������Ծּ�¼
    procedure dLoadMemoFromRecNo(iRec:dTINT32); // ����¼�е�ע����ʾ����
    procedure dDispVarStepAtRecNo(iRec:dTInt32);
    procedure dLoadAllRecForVarStepNo(iVar:dTInt32);
    procedure dLoadAllRecForPlayNode(PN:dTXQPlayNode);
    procedure dAddPlayNodeIntoPlayRec(PN:dTXQPlayNode);
    procedure dOnRecListBoxClick;               // ��Ӧ������ּ�¼�¼�
    procedure dOnVarListBoxClick;
    procedure dReverseBoard;                    // ���̵�ת180��
  end;

function  sGetPlayRecStr(var qzXY:dTXQZXY; XYf,XYt:dTBYTE):string;


implementation

end.
