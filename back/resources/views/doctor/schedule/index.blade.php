@extends('doctor.layouts.app')

@section('title', 'Working Hours')

@section('content')
@php
    use App\Http\Enums\WeekDay;
@endphp

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
    <div>
        <h4 class="mb-1">Working Hours</h4>
        <p class="text-muted mb-0">Manage your availability from your doctor panel.</p>
    </div>

    <a href="{{ route('doctor.dashboard') }}" class="btn btn-outline-secondary">Back to Dashboard</a>
</div>

<div class="card shadow-sm border-0 mb-4">
    <div class="card-body">
        <h5 class="fw-bold mb-3">
            {{ $editingWorkingHour ? 'Edit Working Hour' : 'Add Working Hour' }}
        </h5>

        <form
            method="POST"
            action="{{ $editingWorkingHour ? route('doctor.schedule.update', $editingWorkingHour) : route('doctor.schedule.store') }}"
            class="row g-3"
        >
            @csrf
            @if($editingWorkingHour)
                @method('PUT')
            @endif

            <div class="col-md-3">
                <label class="form-label">Day</label>
                <select name="day_of_week" class="form-select @error('day_of_week') is-invalid @enderror" required>
                    <option value="">Select Day</option>
                    @foreach(WeekDay::cases() as $day)
                        <option
                            value="{{ $day->value }}"
                            @selected(old('day_of_week', $editingWorkingHour?->day_of_week) === $day->value)
                        >
                            {{ ucfirst($day->value) }}
                        </option>
                    @endforeach
                </select>
                @error('day_of_week')
                    <div class="invalid-feedback">{{ $message }}</div>
                @enderror
            </div>

            <div class="col-md-2">
                <label class="form-label">Start Time</label>
                <input
                    type="time"
                    name="start_time"
                    class="form-control @error('start_time') is-invalid @enderror"
                    value="{{ old('start_time', $editingWorkingHour?->start_time ? \Illuminate\Support\Carbon::parse($editingWorkingHour->start_time)->format('H:i') : '') }}"
                    required
                >
                @error('start_time')
                    <div class="invalid-feedback">{{ $message }}</div>
                @enderror
            </div>

            <div class="col-md-2">
                <label class="form-label">End Time</label>
                <input
                    type="time"
                    name="end_time"
                    class="form-control @error('end_time') is-invalid @enderror"
                    value="{{ old('end_time', $editingWorkingHour?->end_time ? \Illuminate\Support\Carbon::parse($editingWorkingHour->end_time)->format('H:i') : '') }}"
                    required
                >
                @error('end_time')
                    <div class="invalid-feedback">{{ $message }}</div>
                @enderror
            </div>

            <div class="col-md-3">
                <label class="form-label">Notes</label>
                <input
                    name="notes"
                    class="form-control @error('notes') is-invalid @enderror"
                    placeholder="Optional note"
                    value="{{ old('notes', $editingWorkingHour?->notes) }}"
                >
                @error('notes')
                    <div class="invalid-feedback">{{ $message }}</div>
                @enderror
            </div>

            <div class="col-md-2 d-flex align-items-end">
                <div class="form-check mb-2">
                    <input
                        class="form-check-input"
                        type="checkbox"
                        name="is_available"
                        id="is_available"
                        value="1"
                        @checked(old('is_available', $editingWorkingHour ? $editingWorkingHour->is_available : true))
                    >
                    <label class="form-check-label" for="is_available">
                        Available
                    </label>
                </div>
            </div>

            <div class="col-12 d-flex flex-wrap gap-2">
                <button class="btn btn-primary">
                    {{ $editingWorkingHour ? 'Update Working Hour' : 'Save Working Hour' }}
                </button>

                @if($editingWorkingHour)
                    <a href="{{ route('doctor.schedule.index') }}" class="btn btn-outline-secondary">Cancel Edit</a>
                @endif
            </div>
        </form>
    </div>
</div>

<div class="card shadow-sm border-0">
    <div class="card-body">
        <h5 class="fw-bold mb-3">Current Working Hours</h5>

        @forelse ($workingHours as $day => $hours)
            <div class="mb-4">
                <h6 class="fw-bold text-capitalize mb-3">{{ $day }}</h6>

                <div class="table-responsive">
                    <table class="table table-bordered align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Time</th>
                                <th>Status</th>
                                <th>Notes</th>
                                <th class="text-end" width="180">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($hours as $hour)
                                <tr>
                                    <td>
                                        {{ \Illuminate\Support\Carbon::parse($hour->start_time)->format('H:i') }}
                                        -
                                        {{ \Illuminate\Support\Carbon::parse($hour->end_time)->format('H:i') }}
                                    </td>
                                    <td>
                                        <span class="badge bg-{{ $hour->is_available ? 'success' : 'secondary' }}">
                                            {{ $hour->is_available ? 'Available' : 'Unavailable' }}
                                        </span>
                                    </td>
                                    <td>{{ $hour->notes ?? '-' }}</td>
                                    <td class="text-end">
                                        <div class="d-inline-flex gap-2">
                                            <a
                                                href="{{ route('doctor.schedule.index', ['edit' => $hour->id]) }}"
                                                class="btn btn-sm btn-outline-primary"
                                            >
                                                Edit
                                            </a>

                                            <form
                                                method="POST"
                                                action="{{ route('doctor.schedule.destroy', $hour) }}"
                                                onsubmit="return confirm('Delete this working hour?')"
                                            >
                                                @csrf
                                                @method('DELETE')
                                                <button class="btn btn-sm btn-outline-danger">Delete</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        @empty
            <p class="mb-0 text-muted">No working hours added yet.</p>
        @endforelse
    </div>
</div>
@endsection
