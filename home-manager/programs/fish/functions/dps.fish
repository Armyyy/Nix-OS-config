argparse 'full' -- $argv

if set -q _flag_full
    docker ps -a --format '{{json .}}' | mlr --jsonl --ocsv put '$__s = ($Status =~ "^Up") ? 0 : 1' then sort -n __s -r CreatedAt then cut -x -f __s then cut -o -f ID,Names,Status,CreatedAt,Image,Ports,LocalVolumes,HealthStatus then rename Names,Name,Ports,Port | csvlens
else
    docker ps -a --format '{{json .}}' | mlr --jsonl --ocsv put '$__s = ($Status =~ "^Up") ? 0 : 1' then sort -n __s -r CreatedAt then cut -x -f __s then cut -o -f ID,Names,Status,Ports then rename Names,Name,Ports,Port | csvlens
end
