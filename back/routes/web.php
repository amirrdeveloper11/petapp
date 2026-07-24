<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\AdminAuthController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\DoctorController;
use App\Http\Controllers\Admin\OrderController as AdminOrderController;
use App\Http\Controllers\Doctor\DoctorAuthController;
use App\Http\Controllers\Doctor\DashboardController as DoctorDashboardController;
use App\Http\Controllers\Doctor\AppointmentController as DoctorAppointmentController;
use App\Http\Controllers\Doctor\ScheduleController as DoctorScheduleController;
use App\Models\Category;
use App\Models\Product;
use App\Models\DoctorProfile;

Route::get('/', function () {
    return redirect('/admin/login');
});

Route::prefix('admin')->name('admin.')->group(function () {

    Route::get('/login', [AdminAuthController::class, 'showLogin'])->name('login');
    Route::post('/login', [AdminAuthController::class, 'login'])->name('login.submit');

    Route::middleware('admin')->group(function () {

        Route::get('/dashboard', function () {
            $categoriesCount = Category::count();
            $productsCount = Product::count();
            $featuredProductsCount = Product::where('is_featured', true)->count();
            $doctorsCount = DoctorProfile::count();

            $latestProducts = Product::with('category')
                ->latest()
                ->take(6)
                ->get();

            return view('admin.dashboard', compact(
                'categoriesCount',
                'productsCount',
                'featuredProductsCount',
                'doctorsCount',
                'latestProducts'
            ));
        })->name('dashboard');

        Route::post('/logout', [AdminAuthController::class, 'logout'])->name('logout');

        Route::resource('categories', CategoryController::class);
        Route::resource('products', ProductController::class)->except(['show']);

        Route::resource('doctors', DoctorController::class);
        Route::patch('doctors/{doctor}/toggle-status', [DoctorController::class, 'toggleStatus'])->name('doctors.toggle-status');

        Route::get('orders', [AdminOrderController::class, 'index'])->name('orders.index');
        Route::get('orders/{order}', [AdminOrderController::class, 'show'])->name('orders.show');
        Route::patch('orders/{order}/status', [AdminOrderController::class, 'updateStatus'])->name('orders.status');
    });
});

Route::prefix('doctor')->name('doctor.')->group(function () {

    Route::get('/login', [DoctorAuthController::class, 'showLogin'])->name('login');
    Route::post('/login', [DoctorAuthController::class, 'login'])->name('login.submit');

    Route::middleware('doctor')->group(function () {
        Route::post('/logout', [DoctorAuthController::class, 'logout'])->name('logout');

        Route::get('/dashboard', [DoctorDashboardController::class, 'index'])->name('dashboard');

        Route::get('/appointments', [DoctorAppointmentController::class, 'index'])->name('appointments.index');
        Route::get('/appointments/{appointment}', [DoctorAppointmentController::class, 'show'])->name('appointments.show');
        Route::patch('/appointments/{appointment}', [DoctorAppointmentController::class, 'update'])->name('appointments.update');

        Route::get('/schedule', [DoctorScheduleController::class, 'index'])->name('schedule.index');
        Route::post('/schedule', [DoctorScheduleController::class, 'store'])->name('schedule.store');
        Route::put('/schedule/{workingHour}', [DoctorScheduleController::class, 'update'])->name('schedule.update');
        Route::delete('/schedule/{workingHour}', [DoctorScheduleController::class, 'destroy'])->name('schedule.destroy');
    });
});
