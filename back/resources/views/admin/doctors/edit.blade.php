@extends('admin.layouts.app')

@section('title', 'Edit Doctor')

@section('content')
<h4 class="mb-3">Edit Doctor</h4>

<form method="POST" action="{{ route('admin.doctors.update', $doctor) }}">
    @csrf
    @method('PUT')

    <div class="card shadow-sm border-0">
        <div class="card-body row g-3">
            <div class="col-md-6">
                <label class="form-label" for="full_name">Full Name</label>
                <input id="full_name" name="full_name" class="form-control" value="{{ old('full_name', $doctor->full_name) }}" required>
            </div>

            <div class="col-md-6">
                <label class="form-label" for="email">Email</label>
                <input id="email" name="email" type="email" class="form-control" value="{{ old('email', $doctor->user->email) }}" required>
            </div>

            <div class="col-md-6">
                <label class="form-label" for="password">Password</label>
                <input id="password" name="password" type="password" class="form-control">
            </div>

            <div class="col-md-6">
                <label class="form-label" for="password_confirmation">Confirm Password</label>
                <input id="password_confirmation" name="password_confirmation" type="password" class="form-control">
            </div>

            <div class="col-md-6">
                <label class="form-label" for="phone">Phone</label>
                <input id="phone" name="phone" class="form-control" value="{{ old('phone', $doctor->phone) }}">
            </div>

            <div class="col-md-6">
                <label class="form-label" for="specialty_id">Specialty</label>
                <select id="specialty_id" name="specialty_id" class="form-select">
                    <option value="">-- Select --</option>
                    @foreach ($specialties as $specialty)
                        <option value="{{ $specialty->id }}" @selected(old('specialty_id', $doctor->specialty_id) == $specialty->id)>
                            {{ $specialty->name }}
                        </option>
                    @endforeach
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label" for="license_number">License Number</label>
                <input id="license_number" name="license_number" class="form-control" value="{{ old('license_number', $doctor->license_number) }}">
            </div>

            <div class="col-md-6">
                <label class="form-label" for="consultation_fee">Consultation Fee</label>
                <input id="consultation_fee" name="consultation_fee" type="number" step="0.01" class="form-control" value="{{ old('consultation_fee', $doctor->consultation_fee) }}">
            </div>

            <div class="col-12">
                <label class="form-label" for="bio">Bio</label>
                <textarea id="bio" name="bio" class="form-control" rows="4">{{ old('bio', $doctor->bio) }}</textarea>
            </div>

            <div class="col-md-4">
                <input type="hidden" name="is_active" value="0">
                <div class="form-check">
                    <input
                        class="form-check-input"
                        type="checkbox"
                        name="is_active"
                        id="is_active"
                        value="1"
                        @checked(old('is_active', $doctor->user->is_active))
                    >
                    <label class="form-check-label" for="is_active">
                        Account Active
                    </label>
                </div>
            </div>

            <div class="col-md-4">
                <input type="hidden" name="is_available" value="0">
                <div class="form-check">
                    <input
                        class="form-check-input"
                        type="checkbox"
                        name="is_available"
                        id="is_available"
                        value="1"
                        @checked(old('is_available', $doctor->is_available))
                    >
                    <label class="form-check-label" for="is_available">
                        Available
                    </label>
                </div>
            </div>
        </div>
    </div>

    <button class="btn btn-primary mt-3">Update</button>
    <a href="{{ route('admin.doctors.index') }}" class="btn btn-secondary mt-3">Cancel</a>
</form>
@endsection
