echo off
REM Aipo→Googleカレンダースケジュール同期アプリ
REM Usage
REM   引数
REM     無し
REM �@googleCalenderでAIPO専用のカレンダーを作成する 
REM �AAipoToGcal.batを編集してcdの後を実行モジュールのある位置に設定する
REM �BAtoGconfig.yamlを自分の情報に編集する
REM �CAipoToGcal.batを実行する


cd /d "D:\work\tools"
AipoToGcal.exe
