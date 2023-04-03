# Start with a base image that has Flutter and Dart already installed
FROM cirrusci/flutter:stable-web

# Set the working directory in the container
WORKDIR /app

# Copy the pubspec.yaml file to the container
COPY pubspec.yaml /app/

# Install the dependencies for the app
RUN flutter pub get

# Copy the rest of the app code to the container
COPY . /app/

# Build the app for release in web mode
RUN flutter build web --release

# Expose the port your app runs on
EXPOSE 8080

# Start the app when the container starts
CMD ["flutter", "run", "--release", "-d", "serve", "--web-port", "8080"]