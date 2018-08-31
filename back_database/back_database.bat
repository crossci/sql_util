@echo off & setlocal ENABLEEXTENSIONS 

:: ---------- 配置项 ---------- 

:: 备份放置的路径，加 \ 
set BACKUP_PATH=D:\Backup\

:: 要备份的数据库名称，多个用空格分隔 
set DATABASES=database_name

:: MySQL 用户名 
set USERNAME=root

:: MySQL 密码 
set PASSWORD="password"
:: MySQL Bin 目录，加 \ 
:: 如果可以直接使用 mysqldump（安装时添加 MySQL Bin 目录到了环境变量），此处留空即可 
set MYSQL="C:\Program Files\MySQL\MySQL Server 5.7\bin\"
:: WinRAR 自带命令行工具的可执行文件路径，长文件名注意用 Dos 长文件名书写方式 
set WINRAR="C:\Program Files\WinRAR\Rar.exe"

:: ---------- 以下请勿修改 ---------- 

set YEAR=%date:~0,4%
set MONTH=%date:~5,2%
set DAY=%date:~8,2%
:: 如果在 dos 下输入 time 返回的不是 24 小时制（没有 0 填充），请自行修改此处 
set HOUR=%time:~0,2%
set MINUTE=%time:~3,2%
set SECOND=%time:~6,2%

set DIR=%BACKUP_PATH%%YEAR%\%MONTH%\%DAY%\
set ADDON=%YEAR%%MONTH%%DAY%%HOUR%%MINUTE%%SECOND%
:: create dir 
if not exist %DIR% ( 
mkdir %DIR% 2>nul 
) 
if not exist %DIR% ( 
echo Backup path: %DIR% not exists, create dir failed. 
goto exit 
) 
cd /d %DIR% 

:: backup 
echo Start dump databases... 
for %%D in (%DATABASES%) do ( 
echo Dumping database %%D ... 
%MYSQL%mysqldump -u%USERNAME% -p%PASSWORD% %%D -R -E > %%D.%ADDON%.sql
:: winrar 
if exist %WINRAR% ( 
%WINRAR% a -k -r -s -m1 -ep1 %%D.%ADDON%.rar %%D.%ADDON%.sql 2>nul 
del /F /S /Q %%D.%ADDON%.sql 2>nul 
) 
) 
echo Done 

:exit 