
#Start with a base image
FROM  golang:1.22.5 as base

#Set the working directory inside the container
WORKDIR /app

#copy the go.mod files to the working directory
COPY go.mod ./

#Download all the dependencies
RUN go mod download

#Copy all the source code to the working directory
COPY . .

#Build the application
RUN go build -o main .

####################################
#Reduce the image size by using multi stage builds
#using distroless image to build the application
FROM gcr.io/distroless/base

#Copy the binary from previous stage
COPY --from=base /app/main .

# Copy the static files from previous stage
COPY --from=base /app/static ./static

#Expose the port on which application will run
EXPOSE 8080

#Command to run the application
CMD ["./main"]




