#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ ! -d "${script_dir}/.venv" ]; then
    python -m venv "$script_dir/.venv"
fi
# shellcheck disable=1091
source "$script_dir/.venv/bin/activate"
pip install -r "$script_dir/requirements.txt" > /dev/null
pip install "$script_dir/" > /dev/null
nc_password_client.py "${@}"
