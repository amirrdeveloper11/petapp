@extends('admin.layouts.app')

@section('title', 'Doctor Details')

@section('content')
<div class="row g-3">
    <div class="col-lg-4">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <h5 class="fw-bold">{{ $doctor->full_name }}</h5>
                <p class="mb-1"><strong>Email:</strong> {{ $doctor->user->email }}</p>
                <p class="mb-1"><strong>Phone:</strong> {{ $doctor->phone ?? '-' }}</p>
                <p class="mb-1"><strong>Specialty:</strong> {{ $doctor->specialty?->name ?? '-' }}</p>
                <p class="mb-1"><strong>License:</strong> {{ $doctor->license_number ?? '-' }}</p>
                <p class="mb-1"><strong>Fee:</strong> {{ $doctor->consultation_fee ?? '-' }}</p>
                <p class="mb-0">
                    <strong>Status:</strong>
                    <span class="badge bg-{{ $doctor->user->is_active ? 'success' : 'secondary' }}">
                        {{ $doctor->user->is_active ? 'Active' : 'Inactive' }}
                    </span>
                </p>
            </div>
        </div>
    </div>

    <div class="col-lg-8">
        <div class="card shadow-sm border-0 mb-3">
            <div class="card-body">
                <h6 class="fw-bold">Bio</h6>
                <p class="mb-0">{{ $doctor->bio ?? 'No bio available.' }}</p>
            </div>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                    <h6 class="fw-bold mb-0">Working Hours</h6>
                    <small class="text-muted">Managed from the doctor panel.</small>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Day</th>
                                <th>Start</th>
                                <th>End</th>
                                <th>Status</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            @php
                                $dayOrder = array_flip([
                                    'monday',
                                    'tuesday',
                                    'wednesday',
                                    'thursday',
                                    'friday',
                                    'saturday',
                                    'sunday',
                                ]);

                                $orderedHours = $doctor->workingHours->sort(function ($a, $b) use ($dayOrder) {
                                    $dayCompare = ($dayOrder[$a->day_of_week] ?? 999) <=> ($dayOrder[$b->day_of_week] ?? 999);

                                    if ($dayCompare !== 0) {
                                        return $dayCompare;
                                    }

                                    return strcmp((string) $a->start_time, (string) $b->start_time);
                                });
                            @endphp

                            @forelse($orderedHours as $hour)
                                <tr>
                                    <td>{{ ucfirst($hour->day_of_week) }}</td>
                                    <td>{{ \Illuminate\Support\Carbon::parse($hour->start_time)->format('H:i') }}</td>
                                    <td>{{ \Illuminate\Support\Carbon::parse($hour->end_time)->format('H:i') }}</td>
                                    <td>
                                        <span class="badge bg-{{ $hour->is_available ? 'success' : 'secondary' }}">
                                            {{ $hour->is_available ? 'Available' : 'Unavailable' }}
                                        </span>
                                    </td>
                                    <td>{{ $hour->notes ?? '-' }}</td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">No working hours added yet.</td>
                                </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
