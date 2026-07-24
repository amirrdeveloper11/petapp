@extends('admin.layouts.app')

@section('title', 'Create Doctor')

@section('content')
<h4 class="mb-3">Create Doctor</h4>

<form method="POST" action="{{ route('admin.doctors.store') }}">
    @csrf

    <div class="card shadow-sm border-0">
        <div class="card-body row g-3">
            <div class="col-md-6">
                <label class="form-label">Full Name</label>
                <input name="full_name" class="form-control" value="{{ old('full_name') }}" required>
            </div>

            <div class="col-md-6">
                <label class="form-label">Email</label>
                <input name="email" type="email" class="form-control" value="{{ old('email') }}" required>
            </div>

            <div class="col-md-6">
                <label class="form-label">Password</label>
                <input name="password" type="password" class="form-control" required>
            </div>

            <div class="col-md-6">
                <label class="form-label">Confirm Password</label>
                <input name="password_confirmation" type="password" class="form-control" required>
            </div>

            <div class="col-md-6">
                <label class="form-label">Phone</label>
                <input name="phone" class="form-control" value="{{ old('phone') }}">
            </div>

            <div class="col-md-6">
                <label class="form-label">Specialty</label>
                <select name="specialty_id" class="form-select">
                    <option value="">-- Select --</option>
                    @foreach ($specialties as $specialty)
                        <option value="{{ $specialty->id }}">{{ $specialty->name }}</option>
                    @endforeach
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label">License Number</label>
                <input name="license_number" class="form-control" value="{{ old('license_number') }}">
            </div>

            <div class="col-md-6">
                <label class="form-label">Consultation Fee</label>
                <input name="consultation_fee" type="number" step="0.01" class="form-control" value="{{ old('consultation_fee') }}">
            </div>

            <div class="col-12">
                <label class="form-label">Bio</label>
                <textarea name="bio" class="form-control" rows="4">{{ old('bio') }}</textarea>
            </div>

            <div class="col-12">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="is_available" value="1" checked>
                    <label class="form-check-label">Available</label>
                </div>
            </div>
        </div>
    </div>

    <button class="btn btn-primary mt-3">Save</button>
    <a href="{{ route('admin.doctors.index') }}" class="btn btn-secondary mt-3">Cancel</a>
</form>
@endsection
