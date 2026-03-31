#!/bin/bash
python setup.py bdist_wheel
version=$(grep '^version' setup.cfg | awk 'BEGIN {FS="="} {print($2)}' | sed 's/ //g')
if [ ! -e "dist/__project_codename__-${version}-py3-none-any.whl" ]; then
    echo "Wheel not created in 'dist/__project_codename__-${version}-py3-none-any.whl'"
    exit 1
fi
twine upload --repository forgejo "dist/__project_codename__-${version}-py3-none-any.whl"
