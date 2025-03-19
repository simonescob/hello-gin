# Use a multi-stage build to minimize final image size
# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Final stage
FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/main .

EXPOSE 8080
CMD ["./main"]

# Build command
# Use the following command to build the Docker image
# docker build -t my-gin-app .
# Port configuration
# The application will run on port 8080