#!/usr/bin/env bash
set -e

echo "Laravel scaffold helper"
if ! command -v composer >/dev/null 2>&1; then
  echo "Composer not found. Install Composer first: https://getcomposer.org/"
  exit 1
fi

TARGET_DIR=laravel-app

if [ -d "$TARGET_DIR" ]; then
  echo "$TARGET_DIR already exists. Remove or rename it before running this script."
  exit 1
fi

echo "Creating Laravel project in $TARGET_DIR"
composer create-project laravel/laravel "$TARGET_DIR"

echo "Copying template stubs into project"
mkdir -p "$TARGET_DIR"/app/Http/Controllers/Api
mkdir -p "$TARGET_DIR"/app/Models
mkdir -p "$TARGET_DIR"/database/migrations
cp templates/routes_api.php "$TARGET_DIR"/routes/api.php
cp templates/DestinationController.php "$TARGET_DIR"/app/Http/Controllers/Api/DestinationController.php
cp templates/ModelDestination.php "$TARGET_DIR"/app/Models/Destination.php
cp templates/migration_create_destinations.php "$TARGET_DIR"/database/migrations/2025_01_01_000000_create_destinations_table.php

echo "Done. Edit $TARGET_DIR/.env to configure DB settings and run:"
echo "  cd $TARGET_DIR"
echo "  composer install"
echo "  php artisan migrate"
echo "  php artisan serve"
