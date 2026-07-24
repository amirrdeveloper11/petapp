@extends('admin.layouts.app')

@section('title', 'Order Details')

@section('content')
<div class="card shadow-sm border-0 mb-3">
    <div class="card-body">
        <h5 class="fw-bold mb-3">Order {{ $order->order_number }}</h5>

        <p class="mb-1"><strong>User:</strong> {{ $order->user->name }}</p>
        <p class="mb-1"><strong>Email:</strong> {{ $order->user->email }}</p>
        <p class="mb-1"><strong>Total:</strong> {{ number_format($order->total, 2) }}</p>
        <p class="mb-1">
            <strong>Status:</strong>
            {{ $order->status->value ?? $order->status }}
        </p>
        <p class="mb-1"><strong>Payment Method:</strong> {{ $order->payment_method_label ?? '-' }}</p>
        <p class="mb-1"><strong>Delivery Address:</strong> {{ $order->delivery_address ?? '-' }}</p>
        <p class="mb-1"><strong>City:</strong> {{ $order->city ?? '-' }}</p>
        <p class="mb-1"><strong>Area:</strong> {{ $order->area ?? '-' }}</p>
        <p class="mb-1"><strong>Contact Phone:</strong> {{ $order->contact_phone ?? '-' }}</p>
        <p class="mb-0"><strong>Notes:</strong> {{ $order->notes ?? '-' }}</p>

        @php
            $currentStatus = $order->status->value ?? $order->status;
            $isTerminal = in_array($currentStatus, ['cancelled', 'delivered'], true);
        @endphp

        <form method="POST" action="{{ route('admin.orders.status', $order) }}" class="row g-2 mt-4">
            @csrf
            @method('PATCH')

            <div class="col-md-4">
                <select
                    name="status"
                    class="form-select"
                    {{ $isTerminal ? 'disabled' : '' }}
                >
                    <option value="pending" {{ old('status', $currentStatus) == 'pending' ? 'selected' : '' }}>
                        Pending
                    </option>

                    <option value="processing" {{ old('status', $currentStatus) == 'processing' ? 'selected' : '' }}>
                        Processing
                    </option>

                    <option value="delivered" {{ old('status', $currentStatus) == 'delivered' ? 'selected' : '' }}>
                        Delivered
                    </option>

                    <option value="cancelled" {{ old('status', $currentStatus) == 'cancelled' ? 'selected' : '' }}>
                        Cancelled
                    </option>
                </select>
            </div>

            <div class="col-md-2">
                <button
                    type="submit"
                    class="btn btn-primary w-100"
                    {{ $isTerminal ? 'disabled' : '' }}
                >
                    Update
                </button>
            </div>
        </form>

        @if($isTerminal)
            <div class="alert alert-warning mt-3 mb-0">
                @if($currentStatus === 'cancelled')
                    <strong>Cancelled Order:</strong>
                    This order was cancelled and can no longer be updated.
                @elseif($currentStatus === 'delivered')
                    <strong>Delivered Order:</strong>
                    This order has already been delivered and can no longer be updated.
                @endif
            </div>
        @endif

    </div>
</div>

<div class="card shadow-sm border-0 mb-3">
    <div class="card-body">
        <h5 class="fw-bold mb-3">Delivery Information</h5>

        <div class="row g-3">
            <div class="col-md-6">
                <strong>Delivery Address:</strong>
                <div>{{ $order->delivery_address ?? '-' }}</div>
            </div>

            <div class="col-md-6">
                <strong>Contact Phone:</strong>
                <div>{{ $order->contact_phone ?? '-' }}</div>
            </div>

            <div class="col-md-6">
                <strong>City:</strong>
                <div>{{ $order->city ?? '-' }}</div>
            </div>

            <div class="col-md-6">
                <strong>Area:</strong>
                <div>{{ $order->area ?? '-' }}</div>
            </div>
        </div>
    </div>
</div>

<div class="card shadow-sm border-0">
    <div class="card-body table-responsive">
        <table class="table table-bordered align-middle">
            <thead class="table-light">
                <tr>
                    <th>Product</th>
                    <th class="text-center">Qty</th>
                    <th class="text-end">Unit Price</th>
                    <th class="text-end">Total</th>
                </tr>
            </thead>

            <tbody>
                @forelse($order->items as $item)
                    <tr>
                        <td>{{ $item->product_name }}</td>
                        <td class="text-center">{{ $item->quantity }}</td>
                        <td class="text-end">{{ number_format($item->unit_price, 2) }}</td>
                        <td class="text-end">{{ number_format($item->total_price, 2) }}</td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="4" class="text-center py-4 text-muted">
                            No items found.
                        </td>
                    </tr>
                @endforelse
            </tbody>

            <tfoot>
                <tr>
                    <th colspan="3" class="text-end">Grand Total</th>
                    <th class="text-end">{{ number_format($order->total, 2) }}</th>
                </tr>
            </tfoot>
        </table>
    </div>
</div>
@endsection
