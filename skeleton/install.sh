#!/bin/bash
destination="/usr/local/bin"
while [ $# -gt 0 ]
do
  case "$1" in
    "--help"|"-h"|"-?")
      usage
      exit 0
      ;;
    "--destination"|"-d")
      shift
      destination="${1}"
      shift
      ;;
    *)
      echo "Ignoring unknwon parameter '${1}'"
      shift
      ;;
  esac
done

if [ ! -e "${HOME}/.config/__project_codename__.conf" ]; then
    touch "${HOME}/.config/__project_codename__.conf"
fi
chmod go-rwx "${HOME}/.config/__project_codename__.conf"

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
sed "s#__src_folder__#${script_dir}#g" wrapper.sh > "${destination}/__project_codename__.sh"
chmod +x "${destination}/__project_codename__.sh"
