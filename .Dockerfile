FROM php:8.2-apache

# Instala extensões necessárias pro Laravel
RUN apt-get update && apt-get install -y \
    git zip unzip libpng-dev libonig-dev libxml2-dev curl && \
    docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Define o diretório de trabalho
WORKDIR /var/www/html

# Copia os arquivos
COPY . .

# Instala dependências
RUN composer install --no-dev --optimize-autoloader

# Gera chave do app
RUN php artisan key:generate

# Ajusta permissões
RUN chmod -R 775 storage bootstrap/cache

# Expõe a porta
EXPOSE 8000

# Comando inicial
CMD php artisan serve --host=0.0.0.0 --port=8000
