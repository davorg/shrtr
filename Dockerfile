# Use an official Perl image as the base
FROM perl:5.40

# Set environment variables
ENV DANCER_ENVIRONMENT=production

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    libssl-dev \
    libz-dev \
    make \
    gcc \
    g++ \
    libperl-dev \
    perl-modules \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Pre-install tricky Perl dependencies
# RUN cpanm -n Dist::CheckConflicts File::ShareDir::Install

# Set the working directory
WORKDIR /usr/src/app

# Copy the application files
COPY . .

# Install Perl dependencies using Carton
RUN cpanm -n --installdeps .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["plackup", "-p", "3000", "-E", "deployment", "-I", "Shrtr/lib", "Shrtr/bin/app.pl"]
