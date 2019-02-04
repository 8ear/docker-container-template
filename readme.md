Docker Container Template
===

This repository contains an example template for Docker container. It contains :
* Docker CI scripts to use in Travis or Gitlab CI to build, tag, and push Docker container to an Docker registry.
* Makefile to an easier CI script usage
* Example CI files (only available on the web UI)
* Example folder structure (only available on the web UI)

Requirements to use this scripts:
* One Docker container per git repository **(Recommended)**
* All Docker container versions are separate folder in this git repository. **(Required)**

**Hint:** 
You can also have different images under one repository. Because every foldername is one tag in this Docker container repository. But I do not recommend this.

## Example Folder Structure to Use this CI Scripts
The following folder structure in a Docker container git repository is required:
```
-- <Your repository name>
--- .ci
--- <VERSION_NUMBER>-<BASE>
--- 0.1-ubuntu
------ .gitlab-ci.yml
------ configuration.sh
------ Dockerfile
--- 2.0-alpine
------ .gitlab-ci.yml
------ configuration.sh
------ Dockerfile
--- 2.1-alpine
------ .gitlab-ci.yml
------ configuration.sh
------ Dockerfile
--- .gitignore
--- .gitlab-ci.yml
--- .travis.yml
--- LICENSE
--- Makefile
```
If you use **only Travis CI** you do not require any .gitlab-ci.yml file.

# 01_before_install.sh
This script installs dependencies for the CI Environment.
For Gitlab for example you require an Docker in Docker container which is on alpine base without any programs.
For more Information for Gitlab runner: https://docs.gitlab.com/runner/install/docker.html

Usage:
```bash
# For Travis CI:
sudo .ci/01_before_install.sh
    # Packages can only be installed with sudo
# For Gitlab CI:
.ci/01_before_install.sh
    # No sudo is available.
```


# 02_build.sh
This script build the docker container image.

| Parameter Number | Parameter | Example | Type | Description | 
| --- | --- | --- | --- |
| 1 | <FOLDER> | 0.1-debian | **Required** | This informs the script which image folder should be build. |
| 2 | <true|false> | false | Optional | If you want no '-dev' tag set the production parameter to **true** |


Usage:
```bash
- make build v=${FOLDER} prod=false
```

Output:
```
$> make build v=1.0-debian
...
Successfully tagged not2push/docker-container-template:1.0-debian-dev
```
```
$> make build v=1.0-debian prod=true
...
Successfully tagged not2push/docker-container-template:1.0-debian
```

# 03_tagging.sh
This script, retag the previous builded images. 
The script add tags for major, and latest version and add tags for a complete custom registry.

| Parameter Number | Parameter | Example | Type | Description | 
| --- | --- | --- | --- |
| 1 | <repository slug|URL> | 8ear OR myown.docker.registry | **Required** | For your own hub.docker.com slug or your own Docker registry |
| 2 | <true|false> | false | Optional | If you want no '-dev' tag set the production parameter to **true** |


Usage with the Makefile:
```bash
make tags REPO=$DOCKER_SLUG prod=false  # Set prod=true, if you want to add tags without '-dev' tag
```

Example Output:
```bash
$> make tags REPO=8ear
### Show images before tagging:
not2push/docker-container-template   2.1-alpine-dev      f29b11f3dd56
not2push/docker-container-template   2.0-alpine-dev      98d3f7fa2cdb
not2push/docker-container-template   1.0-debian-dev      38e645383533
### Show images after tagging:
### Show images after tagging:
8ear/docker-container-template       2-dev               f29b11f3dd56
8ear/docker-container-template       2.1-alpine-dev      f29b11f3dd56
8ear/docker-container-template       latest-dev          f29b11f3dd56
8ear/docker-container-template       2.0-alpine-dev      98d3f7fa2cdb
8ear/docker-container-template       1-dev               38e645383533
8ear/docker-container-template       1.0-debian-dev      38e645383533
```
``` bash
$> make tags REPO=8ear prod=true
### Show images before tagging:
not2push/docker-container-template   2.0-alpine          50b52ceab4b3
not2push/docker-container-template   2.1-alpine          5450ea7054ab
### Show images after tagging:
8ear/docker-container-template       2.0-alpine          50b52ceab4b3
8ear/docker-container-template       2.1-alpine          5450ea7054ab
8ear/docker-container-template       latest              5450ea7054ab
```

# 04_push.sh
This script, make an `docker login`, search all build images, and pushes it to the specific Docker repository.

| Parameter Number | Parameter | Example | Type | Description | 
| --- | --- | --- | --- |
| 1 | <repository slug|URL> | 8ear OR myown.docker.registry | **Required** | For your own hub.docker.com slug or your own Docker registry |
| 2 | <USERNAME> | myUser42 | **Required** | Your username for the Docker registry login |
| 3 | <Password> | SecurePassword123 | **Required** | Your password for the Docker registry login |

Usage with the Makefile:
```bash
    # For hub.docker.com:
    make push REPO=$DOCKER_SLUG USER=$DOCKER_USERNAME PW=$DOCKER_PASSWORD
# OR
    # For your own Docker repository:
    make push REPO=$CUSTOM_REGISTRY_URL USER=$CUSTOM_REGISTRY_USER PW=$CUSTOM_REGISTRY_PW
```
# 05_notifiy_hub.docker.com.sh
This script triggers the automatic build option at hub.docker.com. With this script you can create an automatic build repository and every time your CI build your versions you can trigger this script to update the readme file.

| Parameter Number | Parameter | Example | Type | Description | 
| --- | --- | --- | --- |
| 1 | <Token> | 4325345-345-43-52435 | **Required** | For your hub.docker.com API token for an automatic_build repository |


Usage:
```bash
make notify-hub-docker-com TOKEN=$HUB_TOKEN
```
