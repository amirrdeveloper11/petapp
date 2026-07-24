@extends('doctor.layouts.app')

@section('title', 'Appointments')

@section('content')
@php
    use Illuminate\Support\Str;

    $badgeMap = [
        'pending' => 'warning',
        'accepted' => 'primary',
        'completed' => 'success',
        'rejected' => 'danger',
        'cancelled' => 'secondary',
    ];
@endphp

<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0">Appointments</h4>

    <ul class="nav nav-pills">
        <li class="nav-item">
            <a class="nav-link {{ $filter === 'today' ? 'active' : '' }}"
               href="{{ route('doctor.appointments.index', ['filter' => 'today']) }}">Today</a>
        </li>
        <li class="nav-item">
            <a class="nav-link {{ $filter === 'upcoming' ? 'active' : '' }}"
               href="{{ route('doctor.appointments.index', ['filter' => 'upcoming']) }}">Upcoming</a>
        </li>
        <li class="nav-item">
            <a class="nav-link {{ $filter === 'pending' ? 'active' : '' }}"
               href="{{ route('doctor.appointments.index', ['filter' => 'pending']) }}">Pending</a>
        </li>
        <li class="nav-item">
            <a class="nav-link {{ $filter === 'all' ? 'active' : '' }}"
               href="{{ route('doctor.appointments.index', ['filter' => 'all']) }}">All</a>
        </li>
    </ul>
</div>

@if(session('success'))
    <div class="alert alert-success">{{ session('success') }}</div>
@endif

<div class="card shadow-sm border-0">
    <div class="card-body table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-light">
                <tr>
                    <th>Date</th>
                    <th>Time</th>
                    <th>User</th>
                    <th>Pet</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th width="220"></th>
                </tr>
            </thead>
            <tbody>
                @forelse($appointments as $appointment)
                    @php
                        $status = $appointment->status instanceof \App\Http\Enums\AppointmentStatus
                            ? $appointment->status->value
                            : (string) $appointment->status;

                        $rejectionReason = trim((string) ($appointment->rejection_reason ?? ''));
                    @endphp

                    <tr>
                        <td>{{ \Illuminate\Support\Carbon::parse($appointment->appointment_date)->format('Y-m-d') }}</td>
                        <td>{{ $appointment->appointment_time }}</td>
                        <td>{{ $appointment->user->name }}</td>
                        <td>{{ $appointment->pet?->name ?? '-' }}</td>
                        <td>{{ Str::limit($appointment->reason, 40) }}</td>
                        <td>
                            <span class="badge bg-{{ $badgeMap[$status] ?? 'light' }}">
                                {{ ucfirst($status) }}
                            </span>

                            @if($status === 'rejected' && $rejectionReason !== '')
                                <div class="small text-danger mt-1">
                                    {{ \Illuminate\Support\Str::limit($rejectionReason, 50) }}
                                </div>
                            @endif
                        </td>
                        <td>
                            <a href="{{ route('doctor.appointments.show', $appointment) }}" class="btn btn-sm btn-info">Open</a>

                            @if($status === 'pending')
                                <form method="POST" action="{{ route('doctor.appointments.update', $appointment) }}" class="d-inline">
                                    @csrf
                                    @method('PATCH')
                                    <input type="hidden" name="status" value="accepted">
                                    <button class="btn btn-sm btn-success" onclick="return confirm('Accept this appointment?')">Accept</button>
                                </form>

                                <form method="POST" action="{{ route('doctor.appointments.update', $appointment) }}" class="d-inline">
                                    @csrf
                                    @method('PATCH')
                                    <input type="hidden" name="status" value="rejected">
                                    <button class="btn btn-sm btn-danger" onclick="return confirm('Reject this appointment?')">Reject</button>
                                </form>
                            @endif
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">No appointments found.</td>
                    </tr>
                @endforelse
            </tbody>
        </table>

        {{ $appointments->links() }}
    </div>
</div>
@endsection
