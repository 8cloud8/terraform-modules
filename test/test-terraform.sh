#!/usr/bin/env bash

#set -x

__validate() {
  terraform validate -check-variables=false . && echo "[OK]: $(pwd)"
}

__validate-fmt() {
  terraform fmt -check=true -diff=true
}

main () {
  local action="${1:-validate}"
  shift
  case "$action" in
    "validate-fmt")
	    __validate-fmt "$@"
	    ;;
    "validate")
	    __validate "$@"
	    ;;
    *)
     echo "$(basename $0)"
	   ;;
  esac
}

for d in $(git ls-files '*.tf' | xargs -n1 dirname | LC_ALL=C sort | uniq);
do
  pushd "$d" >/dev/null
  main "$@"
  popd >/dev/null
done
