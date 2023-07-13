# Utilisez une image de base contenant PHP et Apache
FROM php:7.4-apache

# Installez les dépendances système nécessaires
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libpq-dev \
        libzip-dev \
        unzip \
        git \
        mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Activez les modules Apache nécessaires
RUN a2enmod rewrite

# Installez les extensions PHP nécessaires
RUN docker-php-ext-install pdo pdo_mysql zip opcache

# Copiez le fichier composer.json et composer.lock dans le conteneur
COPY composer.json composer.lock /var/www/html/

# Définissez le répertoire de travail
WORKDIR /var/www/html

# Installez les dépendances en utilisant Composer
RUN composer install --no-dev --optimize-autoloader

# Copiez le reste des fichiers du projet Drupal dans le conteneur
COPY . /var/www/html

# Définissez les permissions appropriées pour les fichiers et dossiers Drupal
RUN chown -R www-data:www-data sites modules themes

# Exposez le port Apache
EXPOSE 80

# Démarrez Apache lorsque le conteneur est lancé
CMD ["apache2-foreground"]
