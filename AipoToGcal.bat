echo off
REM Aipo→Googleカレンダースケジュール同期アプリ
REM Usage
REM   引数
REM     無し
REM ①googleCalenderでAIPO専用のカレンダーを作成する 
REM ②AipoToGcal.batを編集してcdの後を実行モジュールのある位置に設定する
REM ③AtoGconfig.yamlを自分の情報に編集する
REM ④AipoToGcal.batを実行する


cd /d "D:\work\tools"
AipoToGcal.exe
