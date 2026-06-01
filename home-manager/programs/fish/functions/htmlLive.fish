# htmlLive - start live-reload preview server and open browser
set _scripts ~/Codings/GO-playground/internship/scripts
if ss -ltn 2>/dev/null | grep -q ':9000 '
  echo "live-reload server already running"
else
  python3 $_scripts/live_reload.py &
  sleep 0.5
end
xdg-open http://localhost:9000 2>/dev/null
