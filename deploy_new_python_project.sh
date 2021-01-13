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
      AUTHOR="${1}"
      shift
      ;;
    "--authoring-date")
      shift
      AUTHORING_DATE="${1}"
      shift
      ;;
    "--project-name")
      shift
      PROJECT_NAME="${1}"
      ;;
    "--project-codename")
      shift
      PROJECT_CODENAME="${1}"
      shift
      ;;
    "--version")
      shift
      VERSION="${1}"
      shift
      ;;
"--deployment-path")
      shift
      DEPLOYMENT_PATH="${1}"
      shift
      ;;
    *)
      echo "Ignoring unknwon parameter '${1}'"
      shift
      ;;
  esac
done

destination_path="${DEPLOYMENT_PATH}/${PROJECT_CODENAME}"
mkdir "${destination_path}"
script_path=$(dirname "${0}")
cp "${script_path}/skeleton" "${destination_path}" -rfp
mv "${destination_path}/project_codename.py" "${destination_path}/${PROJECT_CODENAME}.py"
while read -r file
do
    sed -i "s/__project_codename__/${PROJECT_CODENAME}/g" "${file}"
    sed -i "s/__author__/${AUTHOR}/g" "${file}"
    sed -i "s/__authoring_date__/${AUTHORING_DATE}/g" "${file}"
    sed -i "s/__project_name__/${PROJECT_NAME}/g" "${file}"
    sed -i "s/__version__/${VERSION}/g" "${file}"
done <<< "$(ls "${destination_path}/")"