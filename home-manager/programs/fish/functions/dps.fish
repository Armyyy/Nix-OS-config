# dps - docker ps using csvlens
docker ps -a --format '{{json .}}' | mlr --jsonl --ocsv cut -o -f ID,Names,Status,CreatedAt,Image,Ports,LocalVolumes,HealthStatus | csvlens
