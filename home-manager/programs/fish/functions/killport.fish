# killport - kill a process using fzf
set _line (ss -tlnp | fzf --header-lines=1 --prompt="kill> ")
if test -z "$_line"; return 0; end
set _pid (string match -rg 'pid=(\d+)' $_line)
if test -z "$_pid"
  echo "no pid found"
  return 1
end
kill -9 $_pid
echo "killed pid $_pid"
