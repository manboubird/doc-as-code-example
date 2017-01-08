#!/bin/bash
#
# based on the script below:
# https://github.com/adithyakhamithkar/ansible-playbooks/blob/master/roles/jenkins-configure/templates/install-jenkins-plugin.sh.j2

set -eu

if [ $# -eq 0 ]; then
  echo "USAGE: $0 plugin1 plugin2 ..."
  exit 1
fi

JENKINS_HOME=${JENKINS_HOME:-"${HOME}/.jenkins"}
PLUGIN_DIR="${JENKINS_HOME}/plugins"
FILE_OWNER=${FILE_OWNER:-"$(whoami).stuff"}

main() {
  log $(cat <<EOF
JENKINS_HOME=$JENKINS_HOME
PLUGIN_DIR=$PLUGIN_DIR
FILE_OWNER=$FILE_OWNER
EOF
)

  for plugin in $*; do
    install_plugin "$plugin"
  done
  
  local changed=1
  local maxloops=10
  
  while [ "$changed"  == "1" ]; do
    log "Check for missing dependecies ..."
    if  [ $maxloops -lt 1 ] ; then
      log "Max loop count reached - probably a bug in this script: $0"
      exit 1
    fi
    ((maxloops--))
    local changed=0
    for f in ${PLUGIN_DIR}/*.hpi ; do
      # without optionals
      #deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | grep -v "resolution:=optional" | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
      # with optionals
      local deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
      for plugin in $deps; do
        install_plugin "$plugin" 1 && changed=1
      done
    done
  done
  
  log "fixing permissions"
  
  chown ${FILE_OWNER} ${PLUGIN_DIR} -R
  
  log "all done"
}

install_plugin() {
  local plugin_hpi_id="$1"
  if [ -f ${PLUGIN_DIR}/${plugin_hpi_id}.hpi -o -f ${PLUGIN_DIR}/${plugin_hpi_id}.jpi ]; then
    # if [ "$plugin_hpi_id" == "1" ]; then
    #   return 1
    # fi
    log "Skipped: ${plugin_hpi_id} (already installed)"
    return 0
  else
    log "Installing: ${plugin_hpi_id}"
    curl -L --silent --output ${PLUGIN_DIR}/${plugin_hpi_id}.hpi  https://updates.jenkins-ci.org/latest/${plugin_hpi_id}.hpi
    return 0
  fi
}

log() {
  echo "[$(date +"%F %T")] $@"
}

main $@
exit 0
