#!/bin/bash
# shellcheck disable=SC1090
if [ -e defaults ]
then
  . "$(dirname "${0}")/defaults"
fi
while [ $# -gt 0 ]
do
  case "$1" in
    "--author")
      shift
      author="${1}"
      shift
      ;;
    "--authoring-date")
      shift
      authoring_date="${1}"
      shift
      ;;
    "--project-name")
      shift
      project_name="${1}"
      ;;
    "--project-codename")
      shift
      project_codename="${1}"
      shift
      ;;
    "--version")
      shift
      version="${1}"
      shift
      ;;
"--deployment-path")
      shift
      deployment_path="${1}"
      shift
      ;;
    *)
      echo "Ignoring unknwon parameter '${1}'"
      shift
      ;;
  esac
done

destination_path="${deployment_path}/${project_codename}"
mkdir "${destination_path}"
script_path=$(dirname "${0}")
cp "${script_path}/skeleton" "${destination_path}" -rfp
mv "${destination_path}/project_codename.py" "${destination_path}/${project_codename}.py"
while read -r file
do
    sed -i "s/%project_codename%/${project_codename}/g" "${file}"
    sed -i "s/%author%/${author}/g" "${file}"
    sed -i "s/%authoring_date%/${authoring_date}/g" "${file}"
    sed -i "s/%project_name%/${project_name}/g" "${file}"
    sed -i "s/%version%/${version}/g" "${file}"
done <<< "$(ls "${destination_path}/")"