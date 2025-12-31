Laravel Backend (scaffold helper)

This folder contains helper files to scaffold a Laravel backend for the AITravelBuddy app.

Recommended approaches to create the project locally:

1) Use Composer (requires Composer installed):

Run the provided setup script which will call Composer to create a Laravel project and copy the example templates.

2) Use Docker Compose (quick local DB + runtime):

Run `docker-compose up -d` in this folder to start a MySQL service you can point your Laravel app to.

Contents:
- .env.example: DB connection template
- docker-compose.yml: MySQL service and a placeholder for adding an app container
- setup.sh: helper script to run `composer create-project` and copy templates
- templates/: small template stubs for `routes/api.php`, a controller, model, and migration

Next steps after scaffolding:
- Edit `laravel-app/.env` to set `DB_*` values to point to your MySQL (XAMPP or docker service).
- Run `php artisan migrate` to create tables or copy the provided migration and run it.
- Implement authentication (Laravel Sanctum recommended) and add API endpoints.

If you prefer, I can run the scaffold locally and commit the generated `laravel-app` (this will add many files). Otherwise run `./setup.sh` locally and tell me when done so I can help patch further.
