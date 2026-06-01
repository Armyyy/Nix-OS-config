# Run from project-backend dir — wraps air, auto-regenerates html preview on form design changes
# Usage: devBackend [--noAutoDelete]
#   --noAutoDelete  skip pgcsv refresh on delete events

set _no_delete 0
if contains -- --noAutoDelete $argv
  set _no_delete 1
end

air 2>&1 | while read -l line
  echo $line
  set _trigger 0
  if string match -rq 'http_form_design_handler\.go.*(Save form design with fields successful|Create form design successful)' $line
    set _trigger 1
  else if test $_no_delete -eq 0; and string match -rq 'http_form_design_handler\.go.*Delete form design successful' $line
    set _trigger 1
  end
  if test $_trigger -eq 1
    pgcsv -q html/html_output.sql
    or echo "[devBackend] pgcsv html/html_output.sql failed"
    pgcsv -q form/design/with_fields.sql
    or echo "[devBackend] pgcsv form/design/with_fields.sql failed"
  end
end
