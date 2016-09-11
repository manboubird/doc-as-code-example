
log() {
  echo "[$(date +"%F %T")] $@"
}

die() {
  echo "[$(date +"%F %T")] $@" 1>&2; exit 1;
}
