unit Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Media, FMX.TabControl,
  FMX.Objects, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, System.Permissions;

type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    btnCamera: TButton;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnCameraClick(Sender: TObject);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
  private
    { Private declarations }
{$IF CompilerVersion >= 35.0}
    // after Delphi 11 Alexandria
    procedure resultadoPermissao(Sender: TObject; const APermissions: TClassicStringDynArray; const resultados: TClassicPermissionStatusDynArray);
    procedure problemasPermissao(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
{$ELSE}
    // before Delphi 11 Alexandria
    procedure resultadoPermissao(Sender: TObject; const APermissions: TArray<string>; const resultados: TArray<TPermissionStatus>);
    procedure problemasPermissao(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
{$ENDIF}
  public
    { Public declarations }
    permissaoCamera, permissaoEscreverArquivos, permissaoLerArquivos: String;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ TForm1 }

uses Androidapi.Jni.Os, Androidapi.Jni.JavaTypes, Androidapi.Helpers;

//Necess�rio Permitir o Secure File Sharing (Entitlement List), Read e Write External Storage e C�mera

procedure TForm1.FormCreate(Sender: TObject);
begin
  permissaoCamera           := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  permissaoEscreverArquivos := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
  permissaoLerArquivos      := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
end;

procedure TForm1.btnCameraClick(Sender: TObject);
begin
  PermissionsService.RequestPermissions([permissaoCamera, permissaoEscreverArquivos, permissaoLerArquivos], resultadoPermissao, problemasPermissao);
end;

{$IF CompilerVersion >= 35.0}
    // after Delphi 11 Alexandria
procedure TForm1.resultadoPermissao(Sender: TObject; const APermissions: TClassicStringDynArray; const resultados: TClassicPermissionStatusDynArray);
{$ELSE}
    // before Delphi 11 Alexandria
procedure TForm1.resultadoPermissao(Sender: TObject; const APermissions: TArray<string>; const resultados: TArray<TPermissionStatus>);
{$ENDIF}
begin
  if ((Length(resultados) = 3) and (resultados[0] = TPermissionStatus.Granted) and (resultados[1] = TPermissionStatus.Granted) and (resultados[2] = TPermissionStatus.Granted))then
    TakePhotoFromCameraAction1.Execute;
end;

{$IF CompilerVersion >= 35.0}
    // after Delphi 11 Alexandria
procedure TForm1.problemasPermissao(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
{$ELSE}
    // before Delphi 11 Alexandria
procedure TForm1.problemasPermissao(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
{$ENDIF}
begin
  //Pode ser colocada uma msg de que a permiss�o foi negada e que algumas coisas n�o ir�o funcionar
  //direciona novamente p a msg de permiss�o
  //APostRationaleProc;
end;

procedure TForm1.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
begin
  Image1.Bitmap.Assign(Image);
end;

end.
