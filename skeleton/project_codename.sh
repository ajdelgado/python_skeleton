#!/bin/bash
if [ ! -d "$(dirname "${0}")/.venv" ]; then
    python -m venv "$(dirname "${0}")/.venv"
fi
# shellcheck disable=1091
source "$(dirname "${0}")/.venv/bin/activate"
pip install -r "$(dirname "${0}")/requirements.txt" > /dev/null
pip install "$(dirname "${0}")/" > /dev/null
__project_codename__.py "${@}"
