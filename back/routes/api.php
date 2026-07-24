<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PetController;
use App\Http\Controllers\Api\CategoryApiController;
use App\Http\Controllers\Api\ProductApiController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\AppointmentController;
use App\Http\Controllers\Api\DoctorApiController;
use App\Http\Controllers\Api\DeliveryAddressController;

$registerApiRoutes = function (): void {
    Route::prefix('auth')->group(function () {
        Route::post('register', [AuthController::class, 'register']);
        Route::post('login', [AuthController::class, 'login']);
        Route::post('refresh', [AuthController::class, 'refresh']);

        Route::middleware(['auth:sanctum', 'active'])->group(function () {
            Route::post('logout', [AuthController::class, 'logout']);
            Route::post('update-profile', [AuthController::class, 'updateProfile']);
            Route::delete('delete-account', [AuthController::class, 'deleteAccount']);
        });
    });

    Route::get('/categories', [CategoryApiController::class, 'index']);
    Route::get('/categories/{id}', [CategoryApiController::class, 'show']);

    Route::get('/products', [ProductApiController::class, 'index']);
    Route::get('/products/featured', [ProductApiController::class, 'featured']);
    Route::get('/products/{id}', [ProductApiController::class, 'show']);

    Route::get('/doctors', [DoctorApiController::class, 'index']);
    Route::get('/doctors/{doctor}', [DoctorApiController::class, 'show']);
    Route::get('/doctors/{doctor}/schedule', [DoctorApiController::class, 'schedule']);
    Route::get('/specialties', [DoctorApiController::class, 'specialties']);

    Route::middleware(['auth:sanctum', 'active'])->group(function () {
        Route::get('/pets', [PetController::class, 'index']);
        Route::post('/pets', [PetController::class, 'store']);
        Route::get('/pets/{id}', [PetController::class, 'show']);
        Route::put('/pets/{id}', [PetController::class, 'update']);
        Route::delete('/pets/{id}', [PetController::class, 'destroy']);

        Route::get('/orders', [OrderController::class, 'index']);
        Route::post('/orders', [OrderController::class, 'store']);
        Route::get('/orders/{order}', [OrderController::class, 'show']);
        Route::patch('/orders/{order}/cancel', [OrderController::class, 'cancel']);

        Route::get('/appointments', [AppointmentController::class, 'index']);
        Route::post('/appointments', [AppointmentController::class, 'store']);
        Route::get('/appointments/{appointment}', [AppointmentController::class, 'show']);
        Route::patch('/appointments/{appointment}/reschedule', [AppointmentController::class, 'reschedule']);
        Route::patch('/appointments/{appointment}/cancel', [AppointmentController::class, 'cancel']);

        Route::get('/delivery-addresses', [DeliveryAddressController::class, 'index']);
        Route::post('/delivery-addresses', [DeliveryAddressController::class, 'store']);
        Route::get('/delivery-addresses/{deliveryAddress}', [DeliveryAddressController::class, 'show']);
        Route::put('/delivery-addresses/{deliveryAddress}', [DeliveryAddressController::class, 'update']);
        Route::patch('/delivery-addresses/{deliveryAddress}', [DeliveryAddressController::class, 'update']);
        Route::delete('/delivery-addresses/{deliveryAddress}', [DeliveryAddressController::class, 'destroy']);
    });
};

$registerApiRoutes();
Route::prefix('v1')->group($registerApiRoutes);
