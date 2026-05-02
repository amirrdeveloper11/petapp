<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;

class ProductApiController extends Controller
{
    public function index()
    {
        $products = Product::with('category')
            ->latest()
            ->get()
            ->map(function (Product $product) {
                return [
                    'id' => $product->id,
                    'name' => $product->name,
                    'description' => $product->description,
                    'price' => (float) $product->price,
                    'stock' => (int) $product->stock,
                    'is_featured' => (bool) $product->is_featured,
                    'category_id' => (int) $product->category_id,
                    'category' => $product->category ? [
                        'id' => $product->category->id,
                        'name' => $product->category->name,
                    ] : null,
                    'image_url' => $product->image_url,
                ];
            })->values();

        return response()->json([
            'success' => true,
            'message' => 'Products loaded successfully',
            'data' => $products,
        ]);
    }

    public function featured()
    {
        $products = Product::with('category')
            ->where('is_featured', true)
            ->latest()
            ->get()
            ->map(function (Product $product) {
                return [
                    'id' => $product->id,
                    'name' => $product->name,
                    'description' => $product->description,
                    'price' => (float) $product->price,
                    'stock' => (int) $product->stock,
                    'is_featured' => (bool) $product->is_featured,
                    'category_id' => (int) $product->category_id,
                    'category' => $product->category ? [
                        'id' => $product->category->id,
                        'name' => $product->category->name,
                    ] : null,
                    'image_url' => $product->image_url,
                ];
            })->values();

        return response()->json([
            'success' => true,
            'message' => 'Featured products loaded successfully',
            'data' => $products,
        ]);
    }

    public function show($id)
    {
        $product = Product::with('category')->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Product loaded successfully',
            'data' => [
                'id' => $product->id,
                'name' => $product->name,
                'description' => $product->description,
                'price' => (float) $product->price,
                'stock' => (int) $product->stock,
                'is_featured' => (bool) $product->is_featured,
                'category_id' => (int) $product->category_id,
                'category' => $product->category ? [
                    'id' => $product->category->id,
                    'name' => $product->category->name,
                ] : null,
                'image_url' => $product->image_url,
            ],
        ]);
    }
}
