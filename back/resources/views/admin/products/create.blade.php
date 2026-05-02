@extends('admin.layouts.app')
@section('title', 'Add Product')

@section('content')
<div class="card shadow-sm border-0">
    <div class="card-body p-4">
        <h4 class="mb-3">Add Pet Product</h4>

        <form action="{{ route('admin.products.store') }}" method="POST" enctype="multipart/form-data">
            @csrf

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Category</label>
                    <select name="category_id" class="form-select" required>
                        <option value="">-- Select Category --</option>
                        @foreach($categories as $category)
                            <option value="{{ $category->id }}" @selected(old('category_id') == $category->id)>
                                {{ $category->name }}
                            </option>
                        @endforeach
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Name</label>
                    <input type="text" name="name" value="{{ old('name') }}" class="form-control" required>
                </div>

                <div class="col-md-12">
                    <label class="form-label">Description</label>
                    <textarea name="description" rows="4" class="form-control">{{ old('description') }}</textarea>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Price</label>
                    <input type="number" step="0.01" name="price" value="{{ old('price', 0) }}" class="form-control" required>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Stock</label>
                    <input type="number" name="stock" value="{{ old('stock', 0) }}" class="form-control" required>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Image</label>
                    <input type="file" name="image" class="form-control">
                </div>

                <div class="col-md-12">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="is_featured" value="1" id="is_featured" checked>
                        <label class="form-check-label" for="is_featured">
                            Featured
                        </label>
                    </div>
                </div>
            </div>

            <div class="mt-4">
                <button class="btn btn-success">Create</button>
                <a href="{{ route('admin.products.index') }}" class="btn btn-secondary">Back</a>
            </div>
        </form>
    </div>
</div>
@endsection
