@extends('doctor.layouts.app')

@section('title', 'Appointment Details')

@section('content')
@php
    $statusLabel = $appointment->effectiveStatus();
    $isExpired = $statusLabel === 'expired';
    $rejectionReason = old('rejection_reason', $appointment->rejection_reason);
@endphp

<div class="row g-4">
    <div class="col-lg-6">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-body">
                <h4 class="fw-bold mb-3">Appointment Details</h4>

                <p class="mb-1"><strong>Client:</strong> {{ $appointment->user->name }}</p>
                <p class="mb-1"><strong>Email:</strong> {{ $appointment->user->email }}</p>
                <p class="mb-1"><strong>Pet:</strong> {{ $appointment->pet?->name ?? '-' }}</p>
                <p class="mb-1"><strong>Date:</strong> {{ \Illuminate\Support\Carbon::parse($appointment->appointment_date)->format('Y-m-d') }}</p>
                <p class="mb-1"><strong>Time:</strong> {{ $appointment->appointment_time }}</p>
                <p class="mb-1"><strong>Duration:</strong> {{ $appointment->duration_minutes }} minutes</p>
                <p class="mb-1"><strong>Status:</strong> {{ ucfirst($statusLabel) }}</p>
                <p class="mb-1"><strong>Reason:</strong><br>{{ $appointment->reason }}</p>
                <p class="mb-1"><strong>Consultation Notes:</strong><br>{{ $appointment->consultation_notes ?? '-' }}</p>
                <p class="mb-0"><strong>Rejection Reason:</strong><br>{{ $appointment->rejection_reason ?? '-' }}</p>
            </div>
        </div>
    </div>

    <div class="col-lg-6">
        <div class="card shadow-sm border-0 h-100">
            <div class="card-body">
                <h4 class="fw-bold mb-3">Update Status</h4>

                @if($isExpired)
                    <div class="alert alert-dark mb-0">
                        This appointment has expired. It can no longer be accepted or rejected.
                    </div>

                    <a href="{{ route('doctor.appointments.index') }}"
                       class="btn btn-secondary mt-3">
                        Back
                    </a>
                @elseif(in_array($statusLabel, ['pending', 'accepted'], true))
                    <form method="POST" action="{{ route('doctor.appointments.update', $appointment) }}">
                        @csrf
                        @method('PATCH')

                        <div class="mb-3">
                            <label class="form-label">Status</label>

                            <select name="status" id="appointment-status" class="form-select">
                                @if($statusLabel === 'pending')
                                    <option value="accepted" @selected(old('status') === 'accepted')>
                                        Accepted
                                    </option>
                                    <option value="rejected" @selected(old('status') === 'rejected')>
                                        Rejected
                                    </option>
                                @else
                                    <option value="accepted"
                                            @selected(old('status', $statusLabel) === 'accepted')>
                                        Accepted
                                    </option>
                                    <option value="completed" @selected(old('status') === 'completed')>
                                        Completed
                                    </option>
                                @endif
                            </select>

                            @error('status')
                                <div class="text-danger small mt-1">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="mb-3" id="rejection-reason-wrapper" style="display: none;">
                            <label class="form-label">Rejection Reason</label>

                            <textarea name="rejection_reason"
                                      id="rejection-reason"
                                      rows="3"
                                      class="form-control"
                                      placeholder="Write the reason for rejection">{{ $rejectionReason }}</textarea>

                            @error('rejection_reason')
                                <div class="text-danger small mt-1">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="mb-3" id="consultation-notes-wrapper" style="display: none;">
                            <label class="form-label">Consultation Notes</label>

                            <textarea name="consultation_notes"
                                      rows="5"
                                      class="form-control"
                                      placeholder="Write consultation notes">{{ old('consultation_notes', $appointment->consultation_notes) }}</textarea>

                            @error('consultation_notes')
                                <div class="text-danger small mt-1">{{ $message }}</div>
                            @enderror
                        </div>

                        <button class="btn btn-success">Save Changes</button>
                        <a href="{{ route('doctor.appointments.index') }}"
                           class="btn btn-secondary ms-2">
                            Back
                        </a>
                    </form>
                @else
                    <div class="alert alert-info mb-0">
                        This appointment is already finalized and cannot be updated.
                    </div>

                    <a href="{{ route('doctor.appointments.index') }}"
                       class="btn btn-secondary mt-3">
                        Back
                    </a>
                @endif
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const statusSelect = document.getElementById('appointment-status');
    const rejectionWrapper = document.getElementById('rejection-reason-wrapper');
    const consultationWrapper = document.getElementById('consultation-notes-wrapper');

    if (!statusSelect) return;

    function toggleFields() {
        const status = statusSelect.value;

        if (rejectionWrapper) {
            rejectionWrapper.style.display =
                status === 'rejected' ? 'block' : 'none';
        }

        if (consultationWrapper) {
            consultationWrapper.style.display =
                status === 'completed' ? 'block' : 'none';
        }
    }

    toggleFields();
    statusSelect.addEventListener('change', toggleFields);
});
</script>
@endsection
