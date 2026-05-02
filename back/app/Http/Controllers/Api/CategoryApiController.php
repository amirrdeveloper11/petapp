<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;

class CategoryApiController extends Controller
{
    public function index()
    {
        $categories = Category::with(['products' => function ($query) {
            $query->where('is_active', true)->latest();
        }])
            ->latest()
            ->get()
            ->map(function (Category $category) {
                return [
                    'id' => $category->id,
                    'name' => $category->name,
                    'image_url' => $category->image_url,
                    'products' => $category->products->map(function ($product) {
                        return [
                            'id' => $product->id,
                            'name' => $product->name,
                            'description' => $product->description,
                            'price' => (float) $product->price,
                            'stock' => (int) $product->stock,
                            'is_active' => (bool) $product->is_active,
                            'category_id' => (int) $product->category_id,
                            'image_url' => $product->image_url,
                        ];
                    })->values(),
                ];
            })->values();

        return response()->json([
            'success' => true,
            'message' => 'Categories loaded successfully',
            'data' => $categories,
        ]);
    }

    public function show($id)
    {
        $category = Category::with(['products' => function ($query) {
            $query->where('is_active', true)->latest();
        }])->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Category loaded successfully',
            'data' => [
                'id' => $category->id,
                'name' => $category->name,
                'image_url' => $category->image_url,
                'products' => $category->products->map(function ($product) {
                    return [
                        'id' => $product->id,
                        'name' => $product->name,
                        'description' => $product->description,
                        'price' => (float) $product->price,
                        'stock' => (int) $product->stock,
                        'is_active' => (bool) $product->is_active,
                        'category_id' => (int) $product->category_id,
                        'image_url' => $product->image_url,
                    ];
                })->values(),
            ],
        ]);
    }
}
