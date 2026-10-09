#!/bin/bash
app=$(basename "${0}" .sh)
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ ! -d "${script_dir}/.venv" ]; then
    echo "Creating virtual environment in '${script_dir}/.venv'..."
    python3 -m venv "$script_dir/.venv"
fi
# shellcheck source=/dev/null
source "$script_dir/.venv/bin/activate"
if [ "${1}" == "--update" ] || [ ! -x "${script_dir}/.venv/bin/python3" ] || [ ! -x "${script_dir}/.venv/bin/${app}" ] || ! "${app}" --help &> /dev/null; then
    if [ "${1}" == "--update" ]; then
        shift
    fi
    if [ -r "$script_dir/requirements.txt" ]; then
        echo "Installing requirements in virtual environment..."
        pip install -r "$script_dir/requirements.txt" > /dev/null
    fi
    echo "Installing in virtual environment..."
    pip install "$script_dir/" > /dev/null
fi
"${app}" "${@}"
