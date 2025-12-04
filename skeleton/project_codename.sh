#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ ! -d "${script_dir}/.venv" ]; then
    python3 -m venv "$script_dir/.venv"
fi
# shellcheck disable=1091
source "$script_dir/.venv/bin/activate"
if [ "${1}" == "--update" ]; then
    if [ -r "$script_dir/requirements.txt" ]; then
        pip install -r "$script_dir/requirements.txt" > /dev/null
    fi
    pip install "$script_dir/" > /dev/null
fi
__project_codename__.py "${@}"
