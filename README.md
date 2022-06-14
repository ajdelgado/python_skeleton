# Python skeleton

## Usage
Run:
deploy_new_python_project.sh --project-name "My Project" --project-codename my_project --deployment-path /path/to/my/repos/
This will create the folder /path/to/my/repos/my_project with the skeleton inside and the text replaced for each option passed to the script. Check deploy_new_python_project.sh --help to see more options.

deploy_new_python_project [--help|-h|-?] [--author|-a 'Author name'] [--authoring-date|-d 'date of creation'] [--project-name|-n 'Name of the project'] [--project-codename|-p short_project_name] [--version|-v 'version number'] [--deployment-path|-r 'path/to/copy/skeleton'] [--author-email|-e 'email@example.org'] [--url|-u 'https://domain.com'] [--license|-l 'LICENSEv1']

 --help              Show this help.
 --author            Author name, between quotes for spaces.
 --authoring-date    Date when the script was created.
 --project-name      Long name of the project.
 --project-codename  Short name without spaces for command line script.
 --version           Initial version 0.0.1?
 --deployment-path   Path to deploy the skeleton.
 --author-email      Email address of the author.
 --url               URL of the project.
 --license           License name.
 --license-url       License URL to fetch in plain text and save in your project folder.
 --description       Description.
