<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\AdminAuthController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\ProductController;
use App\Models\Category;
use App\Models\Product;

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

            $latestProducts = Product::with('category')
                ->latest()
                ->take(6)
                ->get();

            return view('admin.dashboard', compact(
                'categoriesCount',
                'productsCount',
                'featuredProductsCount',
                'latestProducts'
            ));
        })->name('dashboard');

        Route::post('/logout', [AdminAuthController::class, 'logout'])->name('logout');

        Route::resource('categories', CategoryController::class);
        Route::resource('products', ProductController::class)->except(['show']);
    });
});
