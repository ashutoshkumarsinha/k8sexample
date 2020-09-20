FROM golang:alpine as builder

# Set necessary environmet variables needed for our image
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Move to working directory /build
WORKDIR /build

# Copy and download dependency
RUN apk add git
RUN go get github.com/gin-gonic/gin

# Copy the code into the container
WORKDIR /build
COPY ./main.go .

# Build the application
RUN go build -o main .

# Move to /dist directory as the place for resulting binary folder
WORKDIR /dist

# Copy binary from build to dist folder
RUN cp /build/main .

# Build a small image
FROM scratch

# Copy binary from build to main folder
COPY --from=builder /dist/main /

# Expose port
EXPOSE 3000

# Command to run when starting the container
ENTRYPOINT ["/main"]