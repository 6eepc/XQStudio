object frmXQTipsDlg: TfrmXQTipsDlg
  Left = 207
  Top = 185
  BorderStyle = bsDialog
  Caption = '�ռ����� - �������ա������ݲ��ҡ�ʹ�ü���'
  ClientHeight = 227
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '����'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object pnlTip: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 193
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    object pnlTipIcon: TPanel
      Left = 9
      Top = 9
      Width = 48
      Height = 175
      Align = alLeft
      BevelOuter = bvNone
      Color = clAppWorkSpace
      TabOrder = 0
      object imgTipIcon: TImage
        Left = 8
        Top = 12
        Width = 32
        Height = 32
        AutoSize = True
        Center = True
        Picture.Data = {
          07544269746D617076020000424D760200000000000076000000280000002000
          000020000000010004000000000000020000C40E0000C40E0000100000000000
          000000000000000080000080000000808000800000008000800080800000C0C0
          C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00888888888888888888888888888888888888888888888888088888888888
          88888888888888888880E088888888888888888888888888880EFE0888888888
          888888888888888880EFFFE08888888888888888888888880EFFFFFE08888888
          8888888888888880EFFFFFFFE0888888888888888888880EFFF000FFFE088888
          88888888888880EFFF00000FFFE088888888888888880EFFF88F7700FFFE0888
          888888888880EFFFF8F00070FFFFE08888888888880EFFFF880F77000FFFFE08
          8888888880EFFFFF8FF000770FFFFFE088888888888EFFFF800333000FFFFE08
          888888888888EFFF033BBB330FFFE0888888888888888EF03BBBBBBB30FE0888
          88888888888888E03BBFBFBF30E088888888888888888803BBB808BBB3088888
          888888888888803BBFB000BFBF30888888888888888880BBBBF808FBBB308888
          8888888888883BBFBFBFBFBFBFB308888888888888883BBBFBFB0BFBFBB30888
          8888888888883FBFFFFF0FBFBFB308888888888888883BFFFFF808FBFBB30888
          8888888888883BFFFFF000BFBFB3088888888888888883FFFFF000FBFBB08888
          88888888888883BFFFF000BFBFB08888888888888888883BFFF808FBBB088888
          8888888888888883BFBFBFBFB3888888888888888888888833BBBBB338888888
          8888888888888888883333388888888888888888888888888888888888888888
          8888}
        Transparent = True
      end
    end
    object pnlTipShow: TPanel
      Left = 57
      Top = 9
      Width = 385
      Height = 175
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object bvlLine: TBevel
        Left = 0
        Top = 49
        Width = 385
        Height = 4
        Align = alTop
        Shape = bsTopLine
      end
      object pnlTipDYK: TPanel
        Left = 0
        Top = 0
        Width = 385
        Height = 49
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        BorderWidth = 8
        Caption = '��֪����? ��'
        Color = clWhite
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -29
        Font.Name = '����'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object pnlTipMemo: TPanel
        Left = 0
        Top = 53
        Width = 385
        Height = 122
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 8
        Color = clWhite
        TabOrder = 1
        object memTip: TMemo
          Left = 8
          Top = 8
          Width = 369
          Height = 106
          Align = alClient
          BorderStyle = bsNone
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = '����'
          Font.Style = []
          Lines.Strings = (
            '���ǡ��ջ����ۡ���ʾ���ڣ�ͨ����ʱ��Ļ��ۣ���'
            '��ܿ����ձ������ʹ�÷�����')
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
        object memTips: TMemo
          Left = 8
          Top = 8
          Width = 369
          Height = 106
          Align = alClient
          BorderStyle = bsNone
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = '����'
          Font.Style = []
          Lines.Strings = (
            
              '�����ݲ���(XQStudio)��רҵ�������������������з�������׼�¼��' +
              '���͡������ǿ��ľ����������ܣ���ȫ���������������֡�����Ա��' +
              '�������ֹ����ߵĸ�����Ҫ��'
            
              'XQStudioǿ������ס���ͼ����͵�������Ϊ���������Ϻ����ѽ����ṩ' +
              '�˼���ķ��㡣'
            
              'XQStudio��Ҫͨ��Internet���У����µİ汾����ʹ��������ӡ�http:/' +
              '/www.qipaile.net/xqstudio�����վ�������� (��ע����ĸȫ��ΪСд' +
              '����ͬ) ��'
            
              'Ŀǰ���������Ѿ����������ʹ��XQStudio�����������ļ�(�����ļ���' +
              '׺��.XQF��)�ɹ����ء��������ڡ�http://www.qipaile.net/xqf�����' +
              'վ��������Щ�ļ���ͬʱҲ��ӭ�����Լ��������ļ��ϴ������ǡ�'
            
              '�������XQStudio��ʲô������飬���������ߵ��ʼ���ַ��xqstudio' +
              '@qipaile.net����������ϵ�����߷ǳ�ϣ���ʹ�ұ���E-Mail��ϵ��'
            
              'Ϊ�˷���ʹ�ã��������������Ͻ���XQStudio�Ŀ�ݷ�ʽ�D�Dͼ����һ��' +
              '����ġ����֣�˫����ͼ�꼴����ֱ������XQStudio��'
            
              '�������һ��XQStudio�ĳ�ѧ�ߣ�������ϸ�Ķ��������������ѡ���е�' +
              '��ʹ��˵�����������ϰ��ף�����վ�ͨXQStudio�ĸ��ֹ��ܡ�'
            
              'XQStudio֧���ļ��������ܣ��μ������б������ʹ��˵������.XQF�ļ�' +
              '��XQStudio���������󣬿���ֱ��˫���ļ�����.XQF�ļ���'
            
              '������.XQF�ļ����������Ϳ��Բ��ؽ�ѹ��.ZIP�ļ����鿴.ZIP�ļ���' +
              '�������ļ��ˡ�'
            
              'XQStudio����ʱ��Ҫ800x600(256ɫ)���ϵ���ʾ�ֱ��ʣ�ͬʱϵͳ���ʹ' +
              '����������(С����)������ʽ�����������ϵͳ�Ա�ﵽ��õ�ʹ��Ч��' +
              '��'
            
              'XQStudio�ṩ��������ļ��б��ܣ��ù���ʹ�����Է���ش����' +
              'ʹ�ù��������ļ���'
            
              'XQStudio���ϵļҡ��� http://www.qipaile.net(��������:����������)' +
              '��Ϊ������ư������ṩ��һ���������ֵĺõط������ǽ������ڽ���վ' +
              '�����Ϊһ������������Ż�վ�㣬��ӭ������������'
            
              '�����������֡����˷�������������XQStudio�����°汾�⣬ͬʱ����' +
              '�����������ӡ��������ϡ��Ž����֡�����������Ŀ��ּ����Ϊ�����' +
              '�ư������ṩȫ��λ�ķ���'
            
              '��ʹ���ļ����ҹ���ʱ���󲿷ֵĲ���ѡ��ǡ�ģ��ƥ�䡱�ģ�������' +
              '����ȫ������Ϣ��ֻҪ���벿�����ּ��ɿ�ʼ���ҡ�'
            
              '����������ҵ��ļ������Ѿ���������������ʤ����Ϣ�������ض����ֵ�' +
              '�Ծ�ʱ����ֻ���ļ�����ָ����������������������ʱֻ����ļ�������' +
              '��Ҫ���ļ����ܼ������߲��ҵ��ٶȡ�'
            
              'Ϊ�˼ӿ��ѯ�ٶȣ�ƽʱ��ע�⽨���ṹ���õ�Ŀ¼�ṹ��ͬʱ��ʱ����' +
              '���ػ���������׷��࣬�ڲ����ļ�ʱ�뾡��ָ����ȷ���ļ���λ�ã���' +
              '��ͬʱ�ڽϴ�Χ��������'
            
              '��ʹ�þ�����ҹ���ʱ��һ���ǲ���Ҫ�Լ��ڷ�����λ�õġ��ڲ�ѯ����' +
              '�У�ֻҪ�㿴����ߵľ��ƣ��Ϳ��Բ��ң��������ͼ�Ǵ���ʱ����Ļ�' +
              '��Ԥ��ǰ�����õ��ġ����⣬Ҳ����ͨ�������彫����ͼճ�������ҽ���' +
              '��'
            
              '��ʹ���ļ����ҹ���ʱ�����һ�β��ҵõ����ļ�����̫�࣬����ѡ����' +
              '��β��ҵ����ļ��Ļ�����ָ���µĲ������������²��ң��ظ��������' +
              '�����Եõ�����Ĳ��ҽ����'
            
              '�ڲ��ҵ����ļ��б��ϵ�������Ҽ����ɵ����ļ����ҽ��������ѡ��' +
              '�������Խ�ѡ�е��ļ������ơ����ƶ�����ָ�����ļ��С�ʹ�ô˹���' +
              '���������ֻ�����ר����ֱ���練�ƣ�'
            
              'Ϊ�˷���У԰���ַ�BBS��ʹ���߽������ס���ͼ�ͷ������£�XQStudio' +
              '�ṩ���ı����׺Ͳ�ɫASCII�ַ���ͼ��������ܡ�ͨ�������壬������' +
              '��BBS�Ϸ�����Ư�������׺���ͼ�ˡ�'
            
              '��ע��:���ַ�BBS��ɫ�����ı���ͼ����HTML�������ʽ��������̳��̳' +
              '�ǲ����õġ������Ҫ��HTML��̳�����ı���ͼ���벻Ҫʹ����ɫ���ܡ�'
            
              '�������������̳�Ͽ�������XQStudio���ɵ��ı���ͼ(˧�á�(˧)����' +
              'ʾ�����á�[��]����ʾ)������ʹ��XQStudio�ṩ�ĵ�����ͼ�Ĺ��ܽ���' +
              '��ͼ���ɲо��ļ�����ȥ�˰ڷ�����λ�õķ��ա�'
            
              '�ڴ��׹����У�������ʱ������Ҽ��������������б�(��������������' +
              '��ʾ�������׵ĵط�)�������зḻ�ĵ���͵������ܹ���ѡ��'
            
              'XQStudio�����Զ��ؽ��ı�����(�硰�ڶ�ƽ�塱)��¼���뵱ǰ��֡���' +
              '������̳��������������˶Ծּ�¼���ı��������Խ����ı����Ƶ�����' +
              '�壬Ȼ��ճ������ǰ����С�����Ĳ�����ʽ��μ�����ѡ���еġ�ʹ��' +
              '˵������'
            
              'XQStudio֧�ֶ��ָ�ʽ�ı����׵����룬��������ͳ���ĸ�ʽ��AXF��ʽ' +
              '��WXF��ʽ��ICCS��ʽ�ȡ��������ĸ�ʽ֧�ֻ�֧�ַ����ֵ������ļ���'
            
              'XQStudio�ɶ������ڡ����졢�й���Ϸ���ĵ��й�����Ĵ����ļ��ʹ�' +
              '�ֵ��ı������ļ������ڷǡ�.XQF���ļ���֧����ͨ��ճ���ļ��Ĺ���ʵ' +
              '�ֵģ�����ʹ�÷�ʽ��ο���ʹ��˵������'
            
              'XQStudio�ɽ����׵���Ϊ֧��Java��̬���̵�HTML�ı����ر��ʺϽ�����' +
              '�����Ϸ���'
            
              'XQStudio֧�ִ����е�Java�����е������ס�ͨ��ճ��Java���̵�Դ�ļ�' +
              '���ɽ�����ճ������ǰ��֡�'
            
              'XQStudio�ṩ�ĵ����ʼ�ֱ�ӷ������׹���ʹ�������û�֮�佻�����ױ�' +
              '�ø�Ϊ���㡣'
            
              'XQStudio�ṩ�����׼������뷨Ϊϲ������¼�����׵������ṩ��һ�ָ�' +
              'Ч���������뷽�������ѿɸ����Լ���ϰ��������С���̻���ƴ������' +
              '���뷽ʽ������ѡ��'
            
              '��ʹ��XQStudioʱ����������ʱ���¡�Ctrl+F����ϼ��򹤾�������Ӧ��' +
              '��ť���������ļ����Һ�������ڡ����ù��������ڿ����л����ڡ�'
            
              '�ڰڷ����ӵ�С�����ϵ�������Ҽ��ɵ������⹦��ѡ��������Ĺ��ܿ�' +
              '�ܸ����������ľ�ϲ��'
            
              '�ڴ��׹����У���������˫�����׼�¼���ɴӸò��Զ���ʾ����ʾ��ʱ' +
              '�����������ɵ����������׼�¼�ϵ�����������ֹͣ�Զ���ʾ��'
            
              '�����ͼ�ĵ������ܺ�Word���ִ����ļ���ϣ���������Ư����������' +
              '��'
            
              '�ڴ��׵Ĺ����У�����ʹ�����̵��ú����ҵ����������Ӳ�ͬ�ĽǶ�����' +
              '��֡��������ҵ������ܻ�����һ�ν������ڡ��ڰ�ƽ�塱������������' +
              '���Զ�ת���ɴ��ϰ�ߵġ��ڶ�ƽ�塱����֮��Ȼ��'
            
              '����ڴ���ʱ�������ӵľ��棬���Ե����������ϵġ����ݡ���ť������' +
              '��ǰ��ֵ��������̣��������ݺ����ı仯��'
            
              'XQStudio�ṩ�ĵ����͵����ı����׵Ĺ��ܿɽ����������е����׼�¼��' +
              '�뵽��ǰ����С�'
            
              'XQStudio�ϲ����׹����ܿ���һ�ν�һ�����������ļ��ϲ�����ǰ�ļ�' +
              '�С��ϲ���������ļ����ϲ�ǰ�����ļ��ı仯Ϊһ�壬Ϊ�о����ֺ���' +
              '�������ṩ�˼���ķ��㡣'
            
              'XQStudio����Ҫ�ر�İ�װ�Ϳ������У������Խ�ִ���ļ���XQStudio.E' +
              'XE�����Ƶ�һ�������ϣ����Ƶ���ͬ�Ļ��������С������Ը�⣬Ҳ����' +
              '��������ֱ�����С����ν��С�����硢����ǿ�󡱡�'
            
              'XQStudio�Ǹ������������������ú��ã��������ɵؽ���������ص���' +
              'һ�������������վ�㣬Ҳ�������ɵؽ����������ҳ���ӵ��Լ���վ��' +
              '�ϡ�����ʹ�á�http://www.qipaile.net/xqstuio����Ϊ���ӵ�·����'
            
              'XQStudio�ڿ��������еõ��˹���������ѵ�����֧�֣������ڴ˱�ʾ��' +
              '�ĵĸ�л��ͬʱҲϣ��������֧��XQStudio����ע��http://www.qipaile' +
              '.net����'
            
              '׷����ֹ���������޼��ޣ������ǹ�ͬ�ڴ������ݲ���(XQStudio)����һ' +
              '���汾��XQStudio 2.0�����ϲ�¥�� (������2002��06��12���ڱ���)' +
              '��'
            ' '
            ' '
            ' ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          Visible = False
          WordWrap = False
        end
      end
    end
  end
  object chkTipShow: TCheckBox
    Left = 8
    Top = 202
    Width = 185
    Height = 17
    Hint = 
      '|���ѡ�и�ѡ�ÿ������XQStudioʱ������ʾ����ʾ���ڣ������ϣ' +
      '������ʱ��ʾ�ô��ڣ��ɲ�ѡ����Ժ���Դӡ�������ѡ���д򿪴˴�' +
      '�ڡ�'
    Caption = '����ʱ��ʾ���ջ����ۡ�����'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 368
    Top = 198
    Width = 75
    Height = 21
    Caption = '�ر�'
    Default = True
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object btnLastTip: TButton
    Left = 199
    Top = 198
    Width = 75
    Height = 21
    Caption = '< ��һ��'
    Enabled = False
    TabOrder = 2
    OnClick = btnLastTipClick
  end
  object btnNextTip: TButton
    Left = 279
    Top = 198
    Width = 75
    Height = 21
    Caption = '��һ�� >'
    Enabled = False
    TabOrder = 3
    OnClick = btnNextTipClick
  end
end
