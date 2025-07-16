# Use an official Perl image as the base
FROM perl:5.40

# Set environment variables
ENV DANCER_ENVIRONMENT=production \
    PERL_CARTON_PATH=local

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    make \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install Carton for dependency management
RUN cpanm Carton

# Set the working directory
WORKDIR /usr/src/app

# Copy the application files
COPY . .

# Install Perl dependencies using Carton
RUN carton install

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["carton", "exec", "plackup", "-p", "3000", "-E", "deployment", "-I", "Shrtr/lib", "Shrtr/bin/app.pl"]
