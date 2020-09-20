# k8sexample

Example API app written in Golang. 

Makefile is used for housekeeping purpose.
1.  clean         Cleans the Go binaries in project directory & docker images 
2.  deps          Installs missing dependencies 
3.  format        Formats the Go source file
4.  run           Executes the Go source file without generating binaries
5.  build         Compiles the Go source file & generates go binaries
6.  test          Tests the Go binary 
7.  build-cross   Compiles the Go source file for every OS and Platform Architecture
8.  exe           Executes the Go binary
9.  image         Generate docker image
10.  container     Execute docker image
11.  upload        Upload docker image on DockerHub

Future tasks:
1. Create k8s yaml for this app
2. create helm chart
3. Add observability & CI/CD concepts


