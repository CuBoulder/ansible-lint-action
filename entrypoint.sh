#! /usr/bin/env bash
#########################
#### Function Header ####
#########################
Header() {
  version=$(ansible-lint --version)
  echo "---------------------------------------------"
  echo "---------- Running Ansible Lint -------------"
  echo "---------- [${version}] -------------"
  echo "---------------------------------------------"
}

#########################
#### Function Footer ####
#########################
Footer() {
  echo "---------------------------------------------"
  echo "--------------- All done! -------------------"
  echo "---------------------------------------------"
}

set -Eeuo pipefail

# Filter out arguments that are not available to this action
# args:
#   $@: Arguments to be filtered
parse_args() {
  local opts=""
  while (( "$#" )); do
    case "$1" in
      -q|--quiet)
        opts="$opts -q"
        shift
        ;;
      -c)
        opts="$opts -c $2"
        shift 2
        ;;
      -p)
        opts="$opts -p"
        shift
        ;;
      -r)
        opts="$opts -r $2"
        shift 2
        ;;
      -R)
        opts="$opts -R"
        shift
        ;;
      -t)
        opts="$opts -t $2"
        shift 2
        ;;
      -x)
        opts="$opts -x $2"
        shift 2
        ;;
      --exclude)
        opts="$opts --exclude=$2"
        shift 2
        ;;
      --no-color)
        opts="$opts --no-color"
        shift
        ;;
      --parseable-severity)
        opts="$opts --parseable-severity"
        shift
        ;;
      --) # end argument parsing
        shift
        break
        ;;
      -*) # unsupported flags
        >&2 echo "ERROR: Unsupported flag: '$1'"
        exit 1
        ;;
      *) # positional arguments
        shift  # ignore
        ;;
    esac
  done

  # set remaining positional arguments (if any) in their proper place
  eval set -- "$opts"

  echo "${opts/ /}"
  return 0
}

# Generates client.
# args:
#   $@: additional options
# env:
#   [optional] TARGETS : Files or directories (i.e., playbooks, tasks, handlers etc..) to be linted
ansible::lint() {
  : "${GITHUB_WORKSPACE?GITHUB_WORKSPACE has to be set. Did you use the actions/checkout action?}"
  # Go to the workspace directory
  pushd "${GITHUB_WORKSPACE}"
  local opts
  opts=$(parse_args $@ || exit 1)
  if [ -f "requirements.yaml" ]; then
    ansible-galaxy collection install -r requirements.yaml
  fi
  ansible-lint -v --force-color $opts ${TARGETS}
}


args=("$@")

if [ "$0" = "${BASH_SOURCE[*]}" ] ; then
  Header
  ansible::lint "${args[@]}"
  Footer
fi
