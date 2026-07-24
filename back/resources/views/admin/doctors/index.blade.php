@extends('admin.layouts.app')

@section('title', 'Doctors')

@section('content')
<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0">Doctors</h4>
    <a href="{{ route('admin.doctors.create') }}" class="btn btn-primary">Create Doctor</a>
</div>

<div class="card shadow-sm border-0">
    <div class="card-body table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-light">
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Specialty</th>
                    <th>Status</th>
                    <th width="280">Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse($doctors as $doctor)
                    <tr>
                        <td>{{ $doctor->full_name }}</td>
                        <td>{{ $doctor->user->email }}</td>
                        <td>{{ $doctor->specialty?->name ?? '-' }}</td>
                        <td>
                            <span class="badge bg-{{ $doctor->user->is_active ? 'success' : 'secondary' }}">
                                {{ $doctor->user->is_active ? 'Active' : 'Inactive' }}
                            </span>
                        </td>
                        <td>
                            <a href="{{ route('admin.doctors.show', $doctor) }}" class="btn btn-sm btn-info">View</a>
                            <a href="{{ route('admin.doctors.edit', $doctor) }}" class="btn btn-sm btn-warning">Edit</a>

                            <form method="POST" action="{{ route('admin.doctors.toggle-status', $doctor) }}" class="d-inline">
                                @csrf
                                @method('PATCH')
                                <button class="btn btn-sm btn-secondary">Toggle</button>
                            </form>

                            <form method="POST" action="{{ route('admin.doctors.destroy', $doctor) }}" class="d-inline" onsubmit="return confirm('Delete this doctor?')">
                                @csrf
                                @method('DELETE')
                                <button class="btn btn-sm btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="5" class="text-center py-4 text-muted">No doctors found.</td>
                    </tr>
                @endforelse
            </tbody>
        </table>

        {{ $doctors->links() }}
    </div>
</div>
@endsection
