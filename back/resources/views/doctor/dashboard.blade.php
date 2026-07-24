@extends('doctor.layouts.app')

@section('title', 'Dashboard')

@section('content')
<div class="mb-4">
    <h2 class="fw-bold">Doctor Dashboard</h2>
    <p class="text-muted mb-0">Welcome, {{ auth()->user()->name ?? 'Doctor' }}.</p>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <h6 class="text-muted">Today Appointments</h6>
                <h3 class="mb-0">{{ $todayAppointments }}</h3>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <h6 class="text-muted">Pending Appointments</h6>
                <h3 class="mb-0">{{ $pendingAppointments }}</h3>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <h6 class="text-muted">Specialty</h6>
                <h3 class="mb-0">{{ $doctorProfile?->specialty?->name ?? '-' }}</h3>
            </div>
        </div>
    </div>
</div>

<div class="row g-3">
    <div class="col-lg-7">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-body">
                <h5 class="fw-bold mb-3">Doctor Profile</h5>
                <p class="mb-1"><strong>Name:</strong> {{ $doctorProfile?->full_name ?? '-' }}</p>
                <p class="mb-1"><strong>Email:</strong> {{ auth()->user()->email ?? '-' }}</p>
                <p class="mb-1"><strong>Phone:</strong> {{ $doctorProfile?->phone ?? '-' }}</p>
                <p class="mb-1"><strong>Fee:</strong> {{ $doctorProfile?->consultation_fee ?? '-' }}</p>
                <p class="mb-0"><strong>Status:</strong> {{ $doctorProfile?->is_available ? 'Available' : 'Unavailable' }}</p>
            </div>
        </div>
    </div>

    <div class="col-lg-5">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-body d-flex flex-column justify-content-between">
                <div>
                    <h5 class="fw-bold mb-3">Working Hours</h5>
                    <p class="text-muted mb-3">Set your own schedule from the doctor panel.</p>
                </div>
                <a href="{{ route('doctor.schedule.index') }}" class="btn btn-success">Manage Working Hours</a>
            </div>
        </div>
    </div>
</div>
@endsection
