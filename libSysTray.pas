unit libSysTray;

interface
  uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CoolTrayIcon;

function showBalloonTip(trayID: TCoolTrayIcon; TipTitle, TipInfo: string;
    flag: TBalloonHintIcon; timeout: integer): Boolean;
function hideBalloonTip(trayID: TCoolTrayIcon): Boolean;


implementation

function showBalloonTip(trayID: TCoolTrayIcon; TipTitle, TipInfo: string;
    flag: TBalloonHintIcon; timeout: integer): Boolean;
begin
  Result := trayID.ShowBalloonHint(TipTitle, TipInfo, flag, timeout);
end;


function hideBalloonTip(trayID: TCoolTrayIcon): Boolean;
begin
  Result := trayID.HideBalloonHint();
end;



end.
