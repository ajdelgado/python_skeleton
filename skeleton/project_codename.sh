#!/bin/bash
update=false
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ ! -d "${script_dir}/.venv" ]; then
    python3 -m venv "$script_dir/.venv"
fi
# shellcheck disable=1091
source "$script_dir/.venv/bin/activate"
while [ "${#}" -gt 0 ]
do
    case "${1}" in
        '--update'|'-u')
            shift
            update=true
            ;;
    esac
done
if [ "${update}" == "true" ]; then
    pip install -r "$script_dir/requirements.txt" > /dev/null
    pip install "$script_dir/" > /dev/null
fi
__project_codename__.py "${@}"
