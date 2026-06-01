# Usage: pgcsv [-html] [-q] <sql_file|csv_file|query> [output_file]
set _pgscripts ~/Codings/GO-playground/internship/scripts

set _html_mode 0
set _quiet 0
for _flag in -html -q
  if test "$argv[1]" = "$_flag"
    if test "$_flag" = "-html"; set _html_mode 1; end
    if test "$_flag" = "-q";    set _quiet 1;     end
    set argv $argv[2..]
  end
end

if string match -q "*.csv" -- $argv[1]
  set _out $_pgscripts/output/$argv[1]
  if not test -f $_out
    echo "error: file not found: $_out"
    return 1
  end
else if string match -q "*.sql" -- $argv[1]
  set _sql $_pgscripts/sql/$argv[1]
  set _out (test -n "$argv[2]"; and echo $argv[2]; or echo $_pgscripts/output/(string replace .sql .csv $argv[1]))
  $_pgscripts/export_csv_fast.sh $_sql $_out
  set _exit $status
  if test $_exit -eq 2
    echo "error: can not connect to database. checking existing output..."
    if test -f $_out
      echo "opening existing output instead..."
    else
      echo "can not find existing output"
      return 1
    end
  else if test $_exit -ne 0
    return $_exit
  end
else
  set _tmp (mktemp /tmp/pgcsv_XXXXXX.sql)
  echo $argv[1] > $_tmp
  set _out (test -n "$argv[2]"; and echo $argv[2]; or echo $_pgscripts/output/temp.csv)
  $_pgscripts/export_csv_fast.sh $_tmp $_out
  set _exit $status
  rm -f $_tmp
  if test $_exit -eq 2
    echo "error: can not connect to database. checking existing output..."
    if test -f $_out
      echo "opening existing output instead..."
    else
      echo "can not find existing output"
      return 1
    end
  else if test $_exit -ne 0
    return $_exit
  end
end

if test $_html_mode -eq 1
  set _html (string replace -r '\.csv$' .html $_out)
  rm -f $_html
  tail -n +2 $_out | sed '1s/^"//' | sed '$s/"$//' | sed 's/""/"/g' > $_html
  chmod 444 $_html
else if test $_quiet -eq 0
  csvlens $_out
end
