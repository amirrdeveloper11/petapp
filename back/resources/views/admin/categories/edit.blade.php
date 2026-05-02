@extends('admin.layouts.app')
@section('title','Edit Category')

@section('content')
<div class="card p-4">
    <h4 class="mb-3">Edit Category</h4>

    <form action="{{ route('admin.categories.update', $category) }}" method="POST" enctype="multipart/form-data">
        @csrf
        @method('PUT')

        <div class="mb-3">
            <label class="form-label">Name</label>
            <input name="name" value="{{ old('name', $category->name) }}" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Current Image</label>

            <div class="mb-2">
                @if($category->image_url)
                    <img src="{{ $category->image_url }}"
                         style="width:120px;height:120px;object-fit:cover;border-radius:6px;">
                @else
                    <div class="text-muted">No image</div>
                @endif
            </div>

            <label class="form-label">Replace Image</label>
            <input type="file" name="image" class="form-control">
        </div>

        <button class="btn btn-primary">Update</button>
        <a href="{{ route('admin.categories.index') }}" class="btn btn-secondary">Back</a>
    </form>
</div>
@endsection
