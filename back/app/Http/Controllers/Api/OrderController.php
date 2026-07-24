<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Enums\OrderStatus;
use App\Http\Requests\Api\StoreOrderRequest;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class OrderController extends Controller
{
    public function index()
    {
        $orders = Order::with(['items.product.category'])
            ->where('user_id', auth()->id())
            ->latest()
            ->get()
            ->map(fn (Order $order) => $this->formatOrder($order))
            ->values();

        return response()->json([
            'success' => true,
            'message' => 'Orders loaded successfully',
            'data' => $orders,
        ]);
    }

    public function show(Order $order)
    {
        abort_unless((int) $order->user_id === (int) auth()->id(), 403);

        $order->load(['items.product.category']);

        return response()->json([
            'success' => true,
            'message' => 'Order loaded successfully',
            'data' => $this->formatOrder($order),
        ]);
    }

    public function store(StoreOrderRequest $request)
    {
        $user = $request->user();
        $validated = $request->validated();

        $order = DB::transaction(function () use ($validated, $user) {
            $subtotal = 0.0;

            $order = Order::create([
                'user_id' => $user->id,
                'order_number' => 'ORD-'.now()->format('YmdHis').'-'.Str::upper(Str::random(6)),
                'subtotal' => 0,
                'total' => 0,
                'status' => OrderStatus::Pending->value,
                'payment_method' => $validated['payment_method'],
                'payment_reference' => $validated['payment_reference'] ?? null,
                'delivery_address' => $validated['delivery_address'],
                'city' => $validated['city'],
                'area' => $validated['area'],
                'contact_phone' => $validated['contact_phone'],
                'notes' => $validated['notes'] ?? null,
                'placed_at' => now(),
            ]);

            foreach ($validated['items'] as $item) {
                $product = Product::query()
                    ->whereKey($item['product_id'])
                    ->lockForUpdate()
                    ->first();

                if (! $product || ! $product->is_active) {
                    throw ValidationException::withMessages([
                        'items' => ['One or more products are unavailable.'],
                    ]);
                }

                $quantity = (int) $item['quantity'];

                if ($product->stock < $quantity) {
                    throw ValidationException::withMessages([
                        'items' => ["Insufficient stock for product [{$product->name}]."],
                    ]);
                }

                $unitPrice = (float) $product->price;
                $lineTotal = round($unitPrice * $quantity, 2);

                $order->items()->create([
                    'product_id' => $product->id,
                    'product_name' => $product->name,
                    'sku' => null,
                    'quantity' => $quantity,
                    'unit_price' => $unitPrice,
                    'total_price' => $lineTotal,
                ]);

                $product->decrement('stock', $quantity);
                $subtotal = round($subtotal + $lineTotal, 2);
            }

            $order->update([
                'subtotal' => $subtotal,
                'total' => $subtotal,
            ]);

            return $order->load(['items.product.category']);
        });

        return response()->json([
            'success' => true,
            'message' => 'Order created successfully.',
            'data' => $this->formatOrder($order),
        ], 201);
    }

    public function cancel(Order $order)
    {
        abort_unless($order->user_id === auth()->id(), 403);

        if ($order->status !== OrderStatus::Pending) {
            return response()->json([
                'success' => false,
                'message' => 'Only pending orders can be cancelled.',
            ], 422);
        }

        DB::transaction(function () use ($order) {
            $order->loadMissing('items');

            foreach ($order->items as $item) {
                $product = Product::query()
                    ->whereKey($item->product_id)
                    ->lockForUpdate()
                    ->first();

                if ($product) {
                    $product->increment('stock', (int) $item->quantity);
                }
            }

            $order->update([
                'status' => OrderStatus::Cancelled->value,
            ]);
        });

        $order->load(['items.product.category']);

        return response()->json([
            'success' => true,
            'message' => 'Order cancelled successfully.',
            'data' => $this->formatOrder($order),
        ]);
    }

    private function formatOrder(Order $order): array
    {
        $status = $order->status instanceof OrderStatus ? $order->status->value : (string) $order->status;
        $paymentMethod = (string) $order->payment_method;

        return [
            'id' => $order->id,
            'order_number' => $order->order_number,
            'subtotal' => (float) $order->subtotal,
            'total' => (float) $order->total,
            'status' => $status,
            'can_cancel' => $status === OrderStatus::Pending->value,
            'payment_method' => $paymentMethod,
            'payment_method_label' => $order->payment_method_label,
            'payment_reference' => $order->payment_reference,
            'delivery_address' => $order->delivery_address,
            'city' => $order->city,
            'area' => $order->area,
            'contact_phone' => $order->contact_phone,
            'notes' => $order->notes,
            'placed_at' => $order->placed_at,
            'created_at' => $order->created_at,
            'updated_at' => $order->updated_at,
            'items' => $order->items->map(fn (OrderItem $item) => $this->formatItem($item))->values(),
        ];
    }

    private function formatItem(OrderItem $item): array
    {
        return [
            'id' => $item->id,
            'product_id' => $item->product_id,
            'product_name' => $item->product_name,
            'sku' => $item->sku,
            'quantity' => (int) $item->quantity,
            'unit_price' => (float) $item->unit_price,
            'total_price' => (float) $item->total_price,
            'product' => $item->product ? [
                'id' => $item->product->id,
                'name' => $item->product->name,
                'price' => (float) $item->product->price,
                'stock' => (int) $item->product->stock,
                'is_featured' => (bool) $item->product->is_featured,
                'is_active' => (bool) $item->product->is_active,
                'category' => $item->product->category ? [
                    'id' => $item->product->category->id,
                    'name' => $item->product->category->name,
                ] : null,
                'image_url' => $item->product->image_url,
            ] : null,
        ];
    }
}
