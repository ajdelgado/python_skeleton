#!/bin/bash
function usage() {
  echo "$(basename "${0}" .sh) [--help|-h|-?] [--author|-a 'Author name'] [--authoring-date|-d 'date of creation'] [--project-name|-n 'Name of the project'] [--project-codename|-p short_project_name] [--version|-v 'version number'] [--deployment-path|-r 'path/to/copy/skeleton'] [--author-email|-e 'email@example.org'] [--url|-u 'https://domain.com'] [--license|-l 'LICENSEv1'] [--forgejo-instance|-f 'https://repos.example.org'] [--forgejo-token|-t 'Very Secret Token']"
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
  echo " --license-url       License URL to fetch in plain text and save in your project folder."
  echo " --description       Description."
  echo " --forgejo-instance  URL to your Forgejo instance to create a repository. If present, will try to create a private repository."
  echo " --forgeto-token     API token to authenticate to your Forgejo instance."
  if [ -e "$(dirname "${0}")/defaults" ]
  then
    echo "Defaults:"
    cat "$(dirname "${0}")/defaults"
  fi
  echo ""
}
AUTHOR_EMAIL="${USER}@$(hostname -f)"
FORGEJO_INSTANCE=''
FORGEJO_TOKEN=''
# shellcheck disable=SC1090
if [ -e "$(dirname "${0}")/defaults" ]
then
  source "$(dirname "${0}")/defaults"
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
      PROJECT_CODENAME="${1//-/_}"
      PROJECT_CODENAME_CAMEL=$(echo "${PROJECT_CODENAME}" | sed -E 's/_([a-z])/\U\1/g' | sed -E 's/^([a-z])/\U\1/' )
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
    "--license-url"|"-U")
      shift
      LICENSE_URL="${1}"
      shift
      ;;
    "--description")
      shift
      DESCRIPTION="${1}"
      shift
      ;;
    "--forgejo-instance"|"-f")
      shift
      FORGEJO_INSTANCE="${1}"
      shift
      ;;
    "--forgejo-token"|"-t")
      shift
      FORGEJO_TOKEN="${1}"
      shift
      ;;
    *)
      echo "Ignoring unknwon parameter '${1}'"
      shift
      ;;
  esac
done
if [ -z "${DESCRIPTION}" ]; then
  DESCRIPTION=${PROJECT_NAME}
fi

destination_path="${DEPLOYMENT_PATH}/${PROJECT_CODENAME}"
mkdir -p "${DEPLOYMENT_PATH}"
script_path=$(dirname "${0}")
cp "${script_path}/skeleton" "${destination_path}" -rfp
if [ -z "${LICENSE_URL}" ]; then
  case "${license}" in
    "GPLv3")
      LICENSE_URL="https://www.gnu.org/licenses/gpl-3.0.txt"
      ;;
    "GPLv2")
      LICENSE_URL="https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt"
      ;;
    "GPLv1"|"GPL")
      licence_url="https://www.gnu.org/licenses/old-licenses/gpl-1.0.txt"
      ;;
    *)
      echo "Warning! Put the license text in the file ${destination_path}/LICENSE or pass the URL with the --license-url option"
      ;;
  esac
fi
if [ -n "${licence_url}" ]; then
  curl -s "${LICENSE_URL}" > "${destination_path}/LICENSE"
fi
mv "${destination_path}/project_codename" "${destination_path}/${PROJECT_CODENAME}"
mv "${destination_path}/${PROJECT_CODENAME}/project_codename.py" "${destination_path}/${PROJECT_CODENAME}/${PROJECT_CODENAME}.py"
mv "${destination_path}/project_codename.sh" "${destination_path}/${PROJECT_CODENAME}.sh"
while read -r file
do
  sed -i "s/__project_codename__/${PROJECT_CODENAME}/g" "${file}"
  sed -i "s/__project_codename_camel__/${PROJECT_CODENAME_CAMEL}/g" "${file}"
  sed -i "s/__author__/${AUTHOR}/g" "${file}"
  sed -i "s/__author_email__/${AUTHOR_EMAIL}/g" "${file}"
  sed -i "s/__authoring_date__/${AUTHORING_DATE}/g" "${file}"
  sed -i "s/__project_name__/${PROJECT_NAME}/g" "${file}"
  sed -i "s/__version__/${VERSION}/g" "${file}"
  # shellcheck disable=SC2001
  escape_url=$(echo "${URL}" | sed 's_/_\\/_g')
  sed -i "s/__url__/${escape_url}/g" "${file}"
  sed -i "s/__license__/${LICENSE}/g" "${file}"
  sed -i "s/__description__/${DESCRIPTION}/g" "${file}"
done <<< "$(find "${destination_path}/" -type f)"

if [ -n "${FORGEJO_INSTANCE}" ]; then
  data="{ \"default_branch\": \"main\", \"description\": \"${DESCRIPTION}\", \"name\": \"${PROJECT_CODENAME}\", \"private\": true}"
  response=$(curl -s "${FORGEJO_INSTANCE}/api/v1/user/repos" \
    -H "Authorization: Bearer ${FORGEJO_TOKEN}" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -X POST \
    -d "${data}")
    git_url=$(echo "${response}" | jq '.ssh_url')
    cd "${destination_path}" || exit 1
    git init
    git checkout -b main
    git add .
    git commit -m "Initial commit"
    git remote add origin "${git_url}"
    git push -u origin main
fi
