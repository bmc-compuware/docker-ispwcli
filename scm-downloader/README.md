# SCM Downloader Docker Image

This Docker image provides the BMC AMI DevX SCM Downloader CLI tool in a containerized environment.

## Overview

The Source Code Download extension allows users to download Code Pipeline (ISPW) members from the mainframe to the PC. Source can then be accessed on the PC, for example, for SonarQube analysis and reporting. This Docker image packages the tool with all necessary dependencies for easy deployment and execution.

## Base Image

- **Base**: `eclipse-temurin:17-jre-jammy`
- **Java**: Eclipse Temurin JRE 17
- **OS**: Ubuntu 22.04 LTS (Jammy)

## Prerequisites

- Docker installed on your system
- `TopazCLI-linux.gtk.x86_64.zip` file placed in the `dist/` directory before building

## Building the Image

```bash
docker build -f scm-downloader/Dockerfile -t cp-scm-downloader:1.0.0 .
```

## Usage

### Basic Usage

Run the container with the help command (default):

```bash
docker run cp-scm-downloader:latest
```

### Custom Commands

Pass custom arguments to the SCM Downloader CLI:

```bash
docker run cp-scm-downloader:latest [OPTIONS]
```
For example, Downloading Code Pipeline Container members

```bash
docker run --rm -it cp-scm-downloader:latest -host "host.company.com" -port "12345" -code 1047 -timeout "90" -id "ABCDEF1" -pass ****** -targetFolder "/workbench-cli/data/SCM/Container" -data /workbench-cli/data/SCM/TopazCliWkspc -ispwServerConfig "TPTP" -scm ispwc -ispwContainerName "PLAY031243" -ispwContainerType "0" -ispwServerLevel "DEV1" -ispwDownloadAll "false" -ispwDownloadIncl "true" -cpCategorizeOnComponentType "true" -cpCategorizeOnSubAppl "true" -ispwComponentType "COB,COPY"
```

For example, Downloading Code Pipeline Repository members

```bash
docker run --rm -it cp-scm-downloader:latest -host "host.company.com" -port "12345" -code 1047 -timeout "90" -id "ABCDEF1" -pass ****** -targetFolder "/workbench-cli/data/SCM/Repository" -data /workbench-cli/data/SCM/TopazCliWkspc -ispwServerConfig "TPTP" -scm ispw -ispwServerStream "PLAY" -ispwServerApp "PLAY" -ispwServerSubAppl "PLAY" -ispwServerLevel "DEV1" -ispwLevelOption "0" -ispwFilterFiles "false" -ispwDownloadAll "true" -ispwDownloadIncl "true" -cpCategorizeOnComponentType "true" -cpCategorizeOnSubAppl "true"
```

### Mounting Volumes

To access local files or persist downloaded content:

```bash
docker run -v /local/path:/container/path cp-scm-downloader:latest [OPTIONS]
```

For example, Downloading Code Pipeline Container members

```bash
docker run --rm -it -v /home/user/SCM/Container:/workbench-cli/data/SCM/Container cp-scm-downloader:latest -host "host.company.com" -port "12345" -code 1047 -timeout "90" -id "ABCDEF1" -pass ****** -targetFolder "/workbench-cli/data/SCM/Container" -data /workbench-cli/data/SCM/TopazCliWkspc -ispwServerConfig "TPTP" -scm ispwc -ispwContainerName "PLAY031243" -ispwContainerType "0" -ispwServerLevel "DEV1" -ispwDownloadAll "false" -ispwDownloadIncl "true" -cpCategorizeOnComponentType "true" -cpCategorizeOnSubAppl "true" -ispwComponentType "COB,COPY"
```

For example, Downloading Code Pipeline Repository members

```bash
docker run --rm -it /home/user/SCM/Repository:/workbench-cli/data/SCM/Repository cp-scm-downloader:latest -host "host.company.com" -port "12345" -code 1047 -timeout "90" -id "ABCDEF1" -pass ****** -targetFolder "/workbench-cli/data/SCM/Repository" -data /workbench-cli/data/SCM/TopazCliWkspc -ispwServerConfig "TPTP" -scm ispw -ispwServerStream "PLAY" -ispwServerApp "PLAY" -ispwServerSubAppl "PLAY" -ispwServerLevel "DEV1" -ispwLevelOption "0" -ispwFilterFiles "false" -ispwDownloadAll "true" -ispwDownloadIncl "true" -cpCategorizeOnComponentType "true" -cpCategorizeOnSubAppl "true"
```

## Installed Components

- **Java Runtime**: Eclipse Temurin JRE 17
- **Git**: For SCM operations
- **wget**: For downloading resources
- **unzip**: For archive extraction
- **Topaz Workbench CLI**: SCM Downloader functionality

## Image Details

- **Author**: BMC Software
- **Working Directory**: `/workbench-cli`
- **Entry Point**: `/workbench-cli/SCMDownloaderCLI.sh`
- **Default Command**: `--help`

## File Structure

```
/workbench-cli/
├── SCMDownloaderCLI.sh     (executable)
└── [other BMC Workbench CLI files]
```

## Notes

- The image runs with root privileges
- The SCMDownloaderCLI.sh script is made executable during the build process
- All APT package lists are cleaned up to minimize image size
- The original zip file is removed after extraction

## Support

For issues related to:
- **Docker image**: Contact the maintainer of this repository
- **SCM Downloader CLI**: Refer to [BMC documentation](https://docs.bmc.com/xwiki/bin/view/Mainframe/DevX/BMC-AMI-DevX-Mainframe-DevOps/mdvops/Working-with-APIs/Workbench-CLI/SCM-Downloader-CLI-SCMDownloaderCLI-bat/)

## License

See the LICENSE.txt file in the root directory of this repository.
