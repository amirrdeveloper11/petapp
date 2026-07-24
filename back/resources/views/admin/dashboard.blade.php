@extends('admin.layouts.app')

@section('title', 'Dashboard')

@section('content')
<div class="mb-4">
    <h2 class="fw-bold">Admin Dashboard</h2>
    <p class="text-muted mb-0">Welcome, {{ auth()->user()->name ?? 'Admin' }}.</p>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <h6 class="text-muted">Categories</h6>
                <h3 class="mb-0">{{ $categoriesCount }}</h3>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <h6 class="text-muted">Products</h6>
                <h3 class="mb-0">{{ $productsCount }}</h3>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <h6 class="text-muted">Featured Products</h6>
                <h3 class="mb-0">{{ $featuredProductsCount }}</h3>
            </div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <h6 class="text-muted">Doctors</h6>
                <h3 class="mb-0">{{ $doctorsCount ?? 0 }}</h3>
            </div>
        </div>
    </div>
</div>

<div class="card shadow-sm border-0">
    <div class="card-header bg-white">
        <h5 class="mb-0">Latest Products</h5>
    </div>

    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Featured</th>
                    </tr>
                </thead>

                <tbody>
                    @forelse($latestProducts as $product)
                        <tr>
                            <td>{{ $product->id }}</td>
                            <td>
                                @if($product->image_url)
                                    <img src="{{ $product->image_url }}"
                                         style="width:55px;height:55px;object-fit:cover;border-radius:8px;">
                                @else
                                    <span class="text-muted">No image</span>
                                @endif
                            </td>
                            <td>{{ $product->name }}</td>
                            <td>{{ $product->category->name ?? '-' }}</td>
                            <td>{{ number_format($product->price, 2) }}</td>
                            <td>{{ $product->stock }}</td>
                            <td>
                                @if($product->is_featured)
                                    <span class="badge bg-success">Featured</span>
                                @else
                                    <span class="badge bg-secondary">Normal</span>
                                @endif
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="7" class="text-center py-4 text-muted">
                                No products found.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>
@endsection
