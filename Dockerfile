# Stage 1: Build the Go application
FROM golang:1.22 AS builder

# Set working directory
WORKDIR /app 

# Copy Go module files and download dependencies
COPY go.mod . 
RUN go mod download

# Copy the rest of the application source code
COPY . . 

# Build the Go application
RUN go build -o main .

# Stage 2: Use a minimal, secure distroless image
FROM gcr.io/distroless/base AS final

# Set working directory
WORKDIR /app

# Copy the built Go binary from the builder stage
COPY --from=builder /app/main /app/main
COPY --from=builder /app/static /app/static

EXPOSE 8080

CMD ["/app/main"]
