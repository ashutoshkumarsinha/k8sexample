# k8sexample

Example API app written in Golang. 

Makefile is used for housekeeping purpose.
1.  Cleans the Go binaries in project directory & docker images 
2.  Installs missing dependencies 
3.  Formats the Go source file
4.  Executes the Go source file without generating binaries
5.  Compiles the Go source file & generates go binaries
6.  Tests the Go binary using cURL, Robot Framework & RestInstance
7.  Compiles the Go source file for every OS and Platform Architecture
8.  Executes the Go binary
9.  Generate docker image
10.  Execute docker image
11.  Upload docker image on DockerHub

Future tasks:
1. Create k8s yaml for this app
2. create helm chart
3. Add observability & CI/CD concepts