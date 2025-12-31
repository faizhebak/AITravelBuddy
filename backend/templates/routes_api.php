<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\DestinationController;

Route::middleware('api')->group(function () {
    Route::get('/destinations', [DestinationController::class, 'index']);
    Route::get('/destinations/{id}', [DestinationController::class, 'show']);
});
