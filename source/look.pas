unit look;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, Buttons, IdIcmpClient, IdBaseComponent, IdComponent, IdRawBase, IdRawClient, MMSystem;

type
  TForm1 = class(TForm)
    btn1: TButton;
    lbl1: TLabel;
    btn99: TButton;
    mmo1: TMemo;
    lbl2: TLabel;
    mmo2: TMemo;
    lbl30: TLabel;
    lbl31: TLabel;
    lbl40: TLabel;
    lbl41: TLabel;
    lbl42: TLabel;
    mmo3: TMemo;
    Run: TButton;
    img100: TImage;
    btn2: TBitBtn;
    idcmpclnt1: TIdIcmpClient;
    sound: TButton;
    tmr1: TTimer;
    START: TButton;
    lbl43: TLabel;
    tmr2: TTimer;
    lbl44: TLabel;
    btn3: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn99Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RunClick(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure idcmpclnt1Reply(ASender: TComponent;
      const AReplyStatus: TReplyStatus);
    procedure soundClick(Sender: TObject);
    procedure STARTClick(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure btn3Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }


     timeout:Integer;
     counter:Integer;
     loscounter:Integer;


    // TImage: TControl;
     //img: Array [1..20] of TImage;
   end;



var
  Form1: TForm1;
  workdir: string;
  hostlist: array [0..19] of string;
  hostname: array [0..19] of string;
  img: Array [0..19] of TImage;
  Lab: Array of TLabel;
  dir: string;
  alarm: Integer;
  numberhost: Integer;
  timeout: Integer; //300
  counter: Integer; //5
  countlos: Integer; //300
  ringchek: Integer; //units*timeout*counter
  hostcount:Integer;
  flog:TextFile;
  procedure pingtohost(ahost:string; ahcount, atimeout, acounter, anumer :Integer);
  procedure writelog (stlog:string);

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var

  //pingfile: TextFile;
  i,ieof,ieofs:Integer;
  tempstr1:string;
  xx, yy, n :Integer;
  //stst: string;

begin
   numberhost:=19;
   //dir:=GetCurrentDir+'\';
   workdir:=dir;
   lbl1.Caption:='Work directory : '+ workdir;
   mmo1.Lines.Clear;
   mmo2.Lines.Clear;
   mmo3.Lines.Clear;
   for i:=0 to numberhost do hostlist[i]:='';

   //mmo1.Lines.Add(LongDateFormat);
   //AssignFile(pingfile,dir+'hostlist.ini');
   mmo1.Lines.LoadFromFile(dir+'hostlist.ini');
   ieof:=mmo1.Lines.Count-1;
   if ieof>20 then ieof:=20;
   lbl2.Caption:='Find '+ IntToStr(ieof) +' records';
   hostcount:=ieof;
   for i:=0 to ieof-1 do
                       begin
                         n:=Pos(';;', mmo1.Lines[i]);
                       tempstr1:=mmo1.Lines[i];
                       ieofs:=n;
                       hostlist[i]:= Copy(tempstr1,3,n-3);
                       tempstr1:=hostlist[i];
                       ieofs:=Length(tempstr1);
                       hostlist[i]:= Copy(tempstr1,1,ieofs);
                       mmo2.Lines.Add(hostlist[i]);

                       tempstr1:=mmo1.Lines[i];
                       ieofs:=Length(tempstr1);

                       hostname[i]:= Copy(tempstr1,n+2,ieofs);
                       tempstr1:=hostname[i];
                       ieofs:=Length(tempstr1);
                       hostname[i]:= Copy(tempstr1,1,ieofs-2);
                       mmo3.Lines.Add(hostname[i]);

                       end;



// form1.Refresh;
lbl31.Caption:='Find '+ IntToStr(hostcount) +' records';
xx:=form1.lbl42.Left;
yy:=Form1.lbl42.Top;
yy:=yy+15;
ieof:=mmo2.Lines.Count-1;

n := hostcount;
numberhost:=n;
  SetLength(Lab, n+1);

  for i := 0 to n-1 do
    begin
      Lab[i] := TLabel.Create(Self);
      Lab[i].Parent := Self;
      Lab[i].Left := xx;
      Lab[i].Top := yy+(i*25)+10;
      //Lab[i].Caption := 'Lable....'+IntToStr(i+1);
      Lab[i].Caption := 'host'+IntToStr(i)+'..'+Form1.mmo2.Lines[i]+'::'+Form1.mmo3.Lines[i];
      end;


end;

procedure TForm1.btn99Click(Sender: TObject);
begin
Form1.Close;
end;


///////////////////********

procedure TForm1.FormActivate(Sender: TObject);

var
  pathsetup:string;
  ui, ueof:Integer;
  uii, uiend: Integer;
  uis: string;
begin

///---------------------------------

Form1.mmo1.Visible:=False;
Form1.mmo2.Visible:=False;
Form1.mmo3.Visible:=False;
btn1.Visible:=False;
Run.Visible:=False;
btn2.Visible:=False;
sound.Visible:=False;

 AssignFile(flog,dir+'PINGLog.txt');
   writelog('....Program is start');

///---------------------------------



tmr1.Interval:=10000;
tmr2.Interval:=10000;
tmr1.Enabled:=False;
tmr2.Enabled:=False;

img100.Visible:=True;
img100.Picture.LoadFromFile(dir+'red25.jpg');
lbl44.Height:=17;
lbl44.Width:=227;
lbl44.Font.Size:=8;
lbl44.Caption:='Chek Off';




Form1.Width:=1024;
form1.Height:=768;
lbl1.Height:=17;
lbl1.Width:=227;
lbl1.Font.Size:=8;
lbl2.Height:=17;
lbl2.Width:=227;
lbl2.Font.Size:=8;

//img100.Visible:=False;

timeout:=300;
counter:=5;
loscounter:=300;

// get work dir path
dir:=GetCurrentDir+'\';
pathsetup:=dir+'setup.ini'  ;

// clear mmo
Form1.mmo2.Lines.Clear;
form1.mmo1.Lines.Clear;
// read from file

mmo1.Lines.LoadFromFile(pathsetup);
ueof:= mmo1.Lines.Count-1;
for ui:=1 to  ueof
            do
            begin
            if Pos( 'timeout', Form1.mmo1.Lines[ui])>0 then
                                                        begin
                                                        uii:= Pos( ':', Form1.mmo1.Lines[ui]);
                                                        uiend:=Length(Form1.mmo1.Lines[ui]);
                                                        uis:= Copy(Form1.mmo1.Lines[ui],uii+1,uiend);
                                                        timeout:=StrToInt(uis);
                                                        end;
            if Pos( 'counter', Form1.mmo1.Lines[ui])>0 then
                                                        begin
                                                        uii:= Pos( ':', Form1.mmo1.Lines[ui]);
                                                        uiend:=Length(Form1.mmo1.Lines[ui]);
                                                        uis:= Copy(Form1.mmo1.Lines[ui],uii+1,uiend);
                                                        counter:=StrToInt(uis);
                                                        end;
            if Pos( 'countlos', Form1.mmo1.Lines[ui])>0 then
                                                        begin
                                                        uii:= Pos( ':', Form1.mmo1.Lines[ui]);
                                                        uiend:=Length(Form1.mmo1.Lines[ui]);
                                                        uis:= Copy(Form1.mmo1.Lines[ui],uii+1,uiend);
                                                        countlos:=StrToInt(uis);
                                                        end;
            end;


///// begin


lbl30.Height:=17;
lbl30.Width:=227;
lbl30.Caption:='Program setup:';

lbl40.Height:=17;
lbl40.Width:=227;
lbl40.Caption:= 'timeout.......'+IntToStr(timeout);

lbl41.Height:=17;
lbl41.Width:=227;
lbl41.Caption:= 'counter.......'+IntToStr(counter);

lbl42.Height:=17;
lbl42.Width:=227;
lbl42.Caption:= 'countlos......'+IntToStr(countlos);

lbl31.Height:=17;
lbl31.Width:=227;
lbl31.Caption:='Find '+ IntToStr(hostcount) +' records';

lbl43.Visible:=False;

btn1Click(Self);
RunClick(Self);


end;

procedure TForm1.RunClick(Sender: TObject);
var
  i,j:Integer;
  host1: string  ;
  nnn: string;
  Memo: TMemo;
  im: TImage;
  columnenter, topgeer :Integer;
begin


columnenter:=0;
topgeer:=0;
for i:=0 to numberhost-1 do
  begin
  j:=45+(45*i);
  img[i]:=TImage.Create(Self);
  img[i].Parent:=Self;
  img[i].Left:=45+columnenter;
  img[i].Top:=45+j-topgeer;
  img[i].Width:=25;
  img[i].Height:=25;
  img[i].Visible:=True;
  //nnn:='semafor'+IntToStr(i);
  //im.Name:= nnn;
  mmo2.Lines.Add(img[i].Name);
  img[i].Picture.LoadFromFile(dir+'grey25.jpg');
  //img[i]:=im;
  Lab[i].Left:=45+30+columnenter;
  Lab[i].Top:=45+j+10-topgeer;
  Lab[i].Font.Size:=10;
  if i=9 then columnenter:=columnenter+275;
  if i=9 then topgeer:=450;
  end;

  //img[0].Picture.LoadFromFile(dir+'red25.jpg');


end;



procedure TForm1.idcmpclnt1Reply(ASender: TComponent;
  const AReplyStatus: TReplyStatus);
  var
    ssst:string;
begin
  // if AReplyStatus.MsRoundTripTime>2000 then
  //  st :=IntToStr()
  //  else
  //  st:=IntToStr (AReplyStatus.MsRoundTripTime);

    Mmo1.Lines.Add ('Reply:'+Inttostr(AReplyStatus.MsRoundTripTime));
    Mmo1.Lines.Add ('Host:'+Form1.idcmpclnt1.Host);


end;





procedure pingtohost (ahost:string; ahcount, atimeout, acounter, anumer :Integer);
var

aahost:string;
aacount, aatimeout, aacounter, aanumber:Integer;


 i,n,k,xch:Integer;
  st5:string;
  st6:string;
  hosts1:string;
  hcounter:Integer;
  ll, lm:Integer;
  r,g,gr:Boolean;
 // hosts: array [1..100] of string;



  begin
     //=========================================================================

  aanumber:=anumer;
  aahost:=ahost;
  aacount:=ahcount;
  aatimeout:=atimeout;
  aacounter:=acounter;
  Form1.mmo1.Clear;

//    img[aanumber].Picture.LoadFromFile(dir+'grey25.jpg');

    for i:=1 to aacounter do
    begin
       Form1.idcmpclnt1.Host:=aahost;
       Form1.idcmpclnt1.ReceiveTimeout:=aatimeout;
       form1.idcmpclnt1.Ping();

    end;
    ll:=Form1.mmo1.Lines.Count-1;
    Form1.mmo2.Clear;
    for i:=0 to ll do
    begin
        st5:=Form1.mmo1.Lines[i];
        n:=Pos('Reply:',st5);
        if n=1 then
        begin
          st6:= Copy(st5,7,Length(st5)-n);
          //k:=StrToInt(st6);
          Form1.mmo2.Lines.Add(st6)
        end;

    end;

    ll:=Form1.mmo2.Lines.Count-1;
    xch:=0;
    for i:=0 to ll do
       begin
        k:=StrToInt(Form1.mmo2.Lines[i]);
        if k>= aatimeout then xch:=xch+1;

       end;
       form1.mmo3.clear;
       Form1.mmo3.Lines.Add(inttostr(xch));
   ///=========================================

    if xch>=3 then
        begin
         img[aanumber].Picture.LoadFromFile(dir+'red25.jpg');
         //..Form1.Refresh;
        // writelog('....not connect..'+hosts1);
        writelog('....not connect..'+aahost);
        alarm:=alarm+1;
        end

    else
       begin
          img[aanumber].Picture.LoadFromFile(dir+'green25.jpg');
          //..Form1.Refresh;
       end;
     //Form1.mmo1.Clear;
     //Form1.mmo2.Clear;
     //Form1.mmo3.Clear;
    //=========================================================================




  end;

procedure TForm1.btn2Click(Sender: TObject);
var
  k:Integer;
begin
alarm:=0;
//k:=5;
for k:=0 to numberhost-1 do
    begin
    pingtohost(hostlist[k],countlos,timeout,counter,k);
    Self.Refresh;
    if alarm>0 then
    begin
     sndPlaySound(PChar(dir+'ALARM.WAV'), SND_ASYNC);
    end;

   end;
end;



procedure TForm1.soundClick(Sender: TObject);
begin

//sndPlaySound('C:\Program Files\Borland\Delphi7\Projects\fito\ALARM.WAV', SND_ASYNC);

sndPlaySound(PChar(dir+'ALARM.WAV'), SND_ASYNC);
end;

procedure TForm1.STARTClick(Sender: TObject);

var
  w:Integer;
begin
    w:= timeout*counter;
    w:= w*numberhost;
    w:=w+5000;
    lbl43.Height:=17;
    lbl43.Width:=227;
    lbl43.Caption:='Node polling cycle...'+IntToStr(w);
    lbl43.Visible:=True;
    tmr1.Interval:=w;
    tmr1.Enabled:=True;

end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
    img100.Picture.LoadFromFile(dir+'green25.jpg');
    lbl44.Caption:='Chek ON';
    btn2Click(Self);
end;

procedure TForm1.btn3Click(Sender: TObject);

var
  i:Integer;
begin
        tmr1.Enabled:=False;
        img100.Picture.LoadFromFile(dir+'red25.jpg');
        lbl44.Caption:='Chek OFF';

        for i:=0 to numberhost-1 do
  begin

  img[i].Picture.LoadFromFile(dir+'grey25.jpg');
  
  end;


end;

   procedure writelog (stlog: string);
var
  d:string;


begin


  // Form1.edtTime.Text:=IntToStr(1500);
   d:=DateTimeToStr(Now);
   d:=d+stlog;
   //FileOpen(dir+'\units\TORMLog.txt',fmOpenWrite);
   //Writeln(flog,d);
   stlog:=d;
   Append(flog);
   Writeln(flog,stlog);
   CloseFile(flog);
end;





end.
