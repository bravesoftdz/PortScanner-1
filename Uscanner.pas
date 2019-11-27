unit Uscanner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin, IdAntiFreezeBase, IdAntiFreeze;

type
  TfrmScanner = class(TForm)
    edtIp: TEdit;
    seInicio: TSpinEdit;
    seFim: TSpinEdit;
    lblIp: TLabel;
    mmoResultado: TMemo;
    shp1: TShape;
    lbl1: TLabel;
    lbl2: TLabel;
    btnIniciar: TButton;
    lblResultado: TLabel;
    actvtyndctr1: TActivityIndicator;
    lbl3: TLabel;
    IdTCPClient1: TIdTCPClient;
    idntfrz1: TIdAntiFreeze;
    procedure btnIniciarClick(Sender: TObject);
  private
    { Private declarations }
    procedure IniciarVarredura(const fPortInicio, fPortFim : Integer);
  public
    { Public declarations }

  end;

var
  frmScanner: TfrmScanner;
  Stop: integer;

implementation

{$R *.dfm}

procedure TfrmScanner.btnIniciarClick(Sender: TObject);
begin
  try
    actvtyndctr1.Animate := True;
    IniciarVarredura(seInicio.Value, seFim.value);
  finally
    actvtyndctr1.Animate := False;
  end;
end;

procedure TfrmScanner.IniciarVarredura(const fPortInicio, fPortFim: Integer);
var
  iport : Integer;
begin
  Stop:= 0 ;
  iport:= fPortInicio;

  mmoResultado.clear;

  IdTCPClient1.host:= edtIp.text;

  mmoResultado.lines.Clear;
  mmoResultado.lines.Add('Iniciando Varredura de portas, '+
                         'disparada para o host: ' + edtIp.text);
  mmoResultado.lines.add(#13);

  while iport <= fPortFim do
  Begin
    //If Stop = 1 then break;
    // implements future kkk
    mmoResultado.lines.Add('Verificando status da porta: [ '+ IntToStr(iport)+' ] '+
                           'para o host: ' + edtIp.text);

    Application.ProcessMessages;

    if IdTCPClient1.Connected then
      IdTCPClient1.disconnect;

    IdTCPClient1.port:= iport;
    Try
      try

        IdTCPClient1.connect;

        if IdTCPClient1.Connected then
          mmoResultado.lines.add('* OPEN * Porta [ '+ inttostr(iport)+ ' ] est� Aberta.')

      except
        mmoResultado.lines.add('A Porta [ '+ inttostr(iport)+ ' ] est� Fechada.');
      end;

      mmoResultado.lines.add(#13);
    Finally
      Inc(iport);
      Application.ProcessMessages;
    end;
  end;

  mmoResultado.lines.add(#13#10);
  mmoResultado.lines.add('Verifica��o Terminada.');
end;

end.