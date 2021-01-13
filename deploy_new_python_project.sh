#!/bin/bash
-e defaults && . defaults
while [ $# -gt 0 ]
do
  case "$1" in
    "--author")
      shift
      DESTINATION="${1}"
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