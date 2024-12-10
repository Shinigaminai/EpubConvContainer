# Epub Converter Static Containerized

Project to convert a word or libreoffice writer file to epub.
Interface is via a static website on nginx and the whole application is deployed as a docker container.
Build and deployment via docker compose.
The conversion is done by libreoffice.

**Warning**: Potentially insecure path routing and no authentication. Deploy only in private networks.

## Installation
pull the github project to your server and run `docker compose up`.
