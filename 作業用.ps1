. C:\git\pwshLabo\pwshLabo.ps1

xrea entry

#xrea search

exit 0

https://cp.xrea.com/account/login/s500.xrea.com/

s500.xrea.com

ConvertTo-Json @{
    mailaddress = 'maad999'
    tag = 'bbb'
}

(ConvertFrom-Json '{
    "mailaddress": "maad999",
    "tag": "bbb"
}')[0].mailaddress


flutter build apk --release
flutter build windows

git add -f build\app\outputs\flutter-apk\app-release.apk
git add -f build\windows\runner\Release\matching.exe
git add -f build\windows\runner\Release\data
git commit -m ('{0:yyyyMMddHHmm}' -f (Get-Date))
git push flutterLabo main -f

RestScr
Xrea clean
Xrea build
Xrea php
Xrea release

dart -h 2>&1 | Set-Clipboard

flutter -h | Set-Clipboard



git add lib\main.dart

Copy-Item C:\flutter\bin\cache\artifacts\engine\windows-x64-release\flutter_windows.dll C:\Users\macot\Desktop\

Get-ChildItem C:\Windows flutter_windows.dll -Recurse

"${$val["aaa"]}"

"${"a"}"