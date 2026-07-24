<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Enums\OrderStatus;
use App\Http\Requests\Admin\UpdateOrderStatusRequest;
use App\Models\Order;

class OrderController extends Controller
{
    public function index()
    {
        $orders = Order::with(['user', 'items.product'])
            ->latest()
            ->paginate(20);

        return view('admin.orders.index', compact('orders'));
    }

    public function show(Order $order)
    {
        $order->load(['user', 'items.product']);

        return view('admin.orders.show', compact('order'));
    }

   public function updateStatus(UpdateOrderStatusRequest $request, Order $order)
{
    $currentStatus = $order->status instanceof OrderStatus
        ? $order->status
        : OrderStatus::from($order->status);

    if (
        $currentStatus === OrderStatus::Cancelled ||
        $currentStatus === OrderStatus::Delivered
    ) {
        return back()->with(
            'error',
            'This order cannot be updated because it is already cancelled or delivered.'
        );
    }

    $newStatus = OrderStatus::from($request->validated('status'));

    if ($currentStatus === $newStatus) {
        return back()->with('info', 'Order status is already up to date.');
    }

    $order->update([
        'status' => $newStatus->value,
    ]);

    return back()->with('success', 'Order status updated.');
}
}
