@extends('admin.layouts.app')

@section('title', 'Orders')

@section('content')
<h4 class="mb-3">Orders</h4>

<div class="card shadow-sm border-0">
    <div class="card-body table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-light">
                <tr>
                    <th>Order #</th>
                    <th>User</th>
                    <th>Phone</th>
                    <th>City</th>
                    <th>Area</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th width="120"></th>
                </tr>
            </thead>
            <tbody>
                @forelse($orders as $order)
                    <tr>
                        <td>{{ $order->order_number }}</td>
                        <td>{{ $order->user->name }}</td>
                        <td>{{ $order->contact_phone ?? '-' }}</td>
                        <td>{{ $order->city ?? '-' }}</td>
                        <td>{{ $order->area ?? '-' }}</td>
                        <td>{{ number_format($order->total, 2) }}</td>
                        <td>
                            <span class="badge bg-secondary">
                                {{ $order->status->value ?? $order->status }}
                            </span>
                        </td>
                        <td>{{ optional($order->placed_at)->format('Y-m-d H:i') }}</td>
                        <td>
                            <a href="{{ route('admin.orders.show', $order) }}" class="btn btn-sm btn-info">View</a>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="9" class="text-center py-4 text-muted">No orders found.</td>
                    </tr>
                @endforelse
            </tbody>
        </table>

        {{ $orders->links() }}
    </div>
</div>
@endsection
