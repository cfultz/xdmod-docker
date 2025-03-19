# Use Rocky Linux 8 as the base image
FROM rockylinux:8

# Creator/Maintainer information
LABEL maintainer="Caleb Fultz <sun3ku>"
LABEL org.opencontainers.image.authors="Caleb Fultz <sun3ku@virginia.edu>"

# Labels for project details
LABEL org.opencontainers.image.title="XDMod on Rocky 8 through RPM installation"
LABEL org.opencontainers.image.description="XDMod Containerized on Rocky 8"
LABEL org.opencontainers.image.version="0.1"
LABEL org.opencontainers.image.url="https://www.rc.virginia.edu"
LABEL org.opencontainers.image.source="https://github.com/ubccr/xdmod"
LABEL org.opencontainers.image.documentation="https://open.xdmod.org/11.0/index.html"

# Update Rocky 8 and install essential tools
RUN dnf -y update && dnf -y install git curl wget epel-release

# Install Node.js 16
RUN curl -fsSL https://rpm.nodesource.com/setup_16.x | bash - && \
    dnf -y install nodejs

# Setup Remi's Repos for PHP 7.4
RUN dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf -y module reset php && \
    dnf -y module enable php:remi-7.4

# Install PHP and MariaDB dependencies for XDMoD
RUN dnf -y install php php-cli php-fpm php-mysqlnd php-zip php-gd php-mbstring php-curl php-xml php-bcmath make libzip-devel php-pear php-devel mariadb-server mariadb

# Download and install XDMoD dependencies
RUN dnf -y install chromium-headless crontabs jq libreoffice-writer librsvg2-tools logrotate mod_ssl perl-Image-ExifTool php-pecl-apcu

# Download and install XDMoD
RUN wget https://github.com/ubccr/xdmod/releases/download/v11.0.0-1.0/xdmod-11.0.0-1.0.el8.noarch.rpm && \
    rpm -ivh xdmod-11.0.0-1.0.el8.noarch.rpm

# Clean up downloaded RPM and cache 
RUN rm xdmod-11.0.0-1.0.el8.noarch.rpm
RUN dnf clean all
