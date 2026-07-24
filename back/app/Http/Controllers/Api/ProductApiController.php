<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;

class ProductApiController extends Controller
{
    public function index()
    {
        $products = Product::active()
            ->with('category')
            ->latest()
            ->get()
            ->map(fn (Product $product) => $this->formatProduct($product))
            ->values();

        return response()->json([
            'success' => true,
            'message' => 'Products loaded successfully',
            'data' => $products,
        ]);
    }

    public function featured()
    {
        $products = Product::active()
            ->featured()
            ->with('category')
            ->latest()
            ->get()
            ->map(fn (Product $product) => $this->formatProduct($product))
            ->values();

        return response()->json([
            'success' => true,
            'message' => 'Featured products loaded successfully',
            'data' => $products,
        ]);
    }

    public function show($id)
    {
        $product = Product::active()
            ->with('category')
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Product loaded successfully',
            'data' => $this->formatProduct($product),
        ]);
    }

    private function formatProduct(Product $product): array
    {
        return [
            'id' => $product->id,
            'name' => $product->name,
            'description' => $product->description,
            'price' => (float) $product->price,
            'stock' => (int) $product->stock,
            'is_featured' => (bool) $product->is_featured,
            'is_active' => (bool) $product->is_active,
            'category_id' => (int) $product->category_id,
            'category' => $product->category ? [
                'id' => $product->category->id,
                'name' => $product->category->name,
            ] : null,
            'image_url' => $product->image_url,
        ];
    }
}
