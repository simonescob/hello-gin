# Use the official Golang image to create a build artifact
FROM golang:1.20-alpine as builder

# Set the working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod ./

# Download all dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Use a minimal alpine image for the final stage
FROM alpine:latest

# Set the working directory
WORKDIR /root/

# Copy the binary from builder
COPY --from=builder /app/main .

# Set GIN_MODE to release
ENV GIN_MODE=release

# Expose port 8080
EXPOSE 8080

# Run the application
CMD ["./main"]