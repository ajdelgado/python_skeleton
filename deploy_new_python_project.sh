#!/bin/bash
function usage() {
  echo "$(basename "${0}" .sh) [--help|-h|-?] [--author|-a 'Author name'] [--authoring-date|-d 'date of creation'] [--project-name|-n 'Name of the project'] [--project-codename|-p short_project_name] [--version|-v 'version number'] [--deployment-path|-r 'path/to/copy/skeleton'] [--author-email|-e 'email@example.org'] [--url|-u 'https://domain.com'] [--license|-l 'LICENSEv1']"
  echo ""
  echo " --help              Show this help."
  echo " --author            Author name, between quotes for spaces."
  echo " --authoring-date    Date when the script was created."
  echo " --project-name      Long name of the project."
  echo " --project-codename  Short name without spaces for command line script."
  echo " --version           Initial version 0.0.1?"
  echo " --deployment-path   Path to deploy the skeleton."
  echo " --author-email      Email address of the author."
  echo " --url               URL of the project."
  echo " --license           License name."
  if [ -e "$(dirname "${0}")/defaults" ]
  then
    echo "Defaults:"
    cat "$(dirname "${0}")/defaults"
  fi
}
# shellcheck disable=SC1090
if [ -e "$(dirname "${0}")/defaults" ]
then
  . "$(dirname "${0}")/defaults"
fi
while [ $# -gt 0 ]
do
  case "$1" in
    "--help"|"-h"|"-?")
      usage
      exit 0
      ;;
    "--author"|"-a")
      shift
      AUTHOR="${1}"
      shift
      ;;
    "--authoring-date"|"-d")
      shift
      AUTHORING_DATE="${1}"
      shift
      ;;
    "--project-name"|"-n")
      shift
      PROJECT_NAME="${1}"
      shift
      ;;
    "--project-codename"|"-p")
      shift
      PROJECT_CODENAME="${1}"
      shift
      ;;
    "--version"|"-v")
      shift
      VERSION="${1}"
      shift
      ;;
    "--deployment-path"|"-r")
      shift
      DEPLOYMENT_PATH="${1}"
      shift
      ;;
    "--author-email"|"-e")
      shift
      AUTHOR_EMAIL="${1}"
      shift
      ;;
    "--url"|"-u")
      shift
      URL="${1}"
      shift
      ;;
    "--license"|"-l")
      shift
      LICENSE="${1}"
      shift
      ;;
    *)
      echo "Ignoring unknwon parameter '${1}'"
      shift
      ;;
  esac
done

destination_path="${DEPLOYMENT_PATH}/${PROJECT_CODENAME}"
mkdir -p "${DEPLOYMENT_PATH}"
script_path=$(dirname "${0}")
cp "${script_path}/skeleton" "${destination_path}" -rfp
mv "${destination_path}/project_codename.py" "${destination_path}/${PROJECT_CODENAME}.py"
while read -r file
do
  sed -i "s/__project_codename__/${PROJECT_CODENAME}/g" "${file}"
  sed -i "s/__author__/${AUTHOR}/g" "${file}"
  sed -i "s/__author_email__/${AUTHOR_EMAIL}/g" "${file}"
  sed -i "s/__authoring_date__/${AUTHORING_DATE}/g" "${file}"
  sed -i "s/__project_name__/${PROJECT_NAME}/g" "${file}"
  sed -i "s/__version__/${VERSION}/g" "${file}"
  sed -i "s/__url__/${URL}/g" "${file}"
  sed -i "s/__license__/${LICENSE}/g" "${file}"
done <<< "$(find "${destination_path}/" -type f)"