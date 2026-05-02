@extends('admin.layouts.app')
@section('title','Categories')

@section('content')
<div class="d-flex justify-content-between align-items-center mb-3">
    <h3>Categories</h3>
    <a href="{{ route('admin.categories.create') }}" class="btn btn-success">Add Category</a>
</div>

<table class="table table-striped table-bordered align-middle">
    <thead>
        <tr>
            <th width="80">#</th>
            <th width="100">Image</th>
            <th>Name</th>
            <th width="200">Actions</th>
        </tr>
    </thead>
    <tbody>
        @forelse($categories as $cat)
            <tr>
                <td>{{ $cat->id }}</td>

                <td>
                    @if($cat->image_url)
                        <img src="{{ $cat->image_url }}"
                             style="width:64px;height:64px;object-fit:cover;border-radius:6px;">
                    @else
                        <span class="text-muted">No image</span>
                    @endif
                </td>

                <td>{{ $cat->name }}</td>

                <td>
                    <a href="{{ route('admin.categories.edit', $cat) }}" class="btn btn-sm btn-primary">Edit</a>

                    <form action="{{ route('admin.categories.destroy', $cat) }}" method="POST" class="d-inline">
                        @csrf
                        @method('DELETE')
                        <button class="btn btn-sm btn-danger" onclick="return confirm('Delete category?')">
                            Delete
                        </button>
                    </form>
                </td>
            </tr>
        @empty
            <tr>
                <td colspan="4" class="text-center">No categories yet.</td>
            </tr>
        @endforelse
    </tbody>
</table>

{{ $categories->links() }}
@endsection
