<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Enums\WeekDay;
use App\Models\Appointment;
use App\Models\DoctorProfile;
use App\Models\Specialty;
use Carbon\Carbon;
use Illuminate\Http\Request;

class DoctorApiController extends Controller
{
    public function index()
    {
        $doctors = DoctorProfile::query()
            ->with(['user', 'specialty'])
            ->where('is_available', true)
            ->latest()
            ->get()
            ->map(fn (DoctorProfile $doctor) => $this->transform($doctor))
            ->values();

        return response()->json([
            'success' => true,
            'message' => 'Doctors loaded successfully.',
            'data' => $doctors,
        ]);
    }

    public function show(DoctorProfile $doctor)
    {
        $doctor->load(['user', 'specialty', 'workingHours']);

        return response()->json([
            'success' => true,
            'message' => 'Doctor loaded successfully.',
            'data' => $this->transform($doctor, true),
        ]);
    }

    public function schedule(Request $request, DoctorProfile $doctor)
{
    $validated = $request->validate([
        'date' => ['nullable', 'date_format:Y-m-d'],
        'slot_duration_minutes' => ['nullable', 'integer', 'min:10', 'max:240'],
        'ignore_appointment_id' => ['nullable', 'integer'],
    ]);

    $slotDurationMinutes = max(10, (int) ($validated['slot_duration_minutes'] ?? 30));
    $ignoreAppointmentId = isset($validated['ignore_appointment_id']) ? (int) $validated['ignore_appointment_id'] : null;

    if (empty($validated['date'])) {
        $workingHours = $doctor->workingHours()
            ->where('is_available', true)
            ->get(['id', 'day_of_week', 'start_time', 'end_time', 'is_available', 'notes'])
            ->sortBy(function ($hour) {
                $position = array_search($hour->day_of_week, WeekDay::values(), true);

                return $position === false ? PHP_INT_MAX : $position;
            })
            ->values();

        return response()->json([
            'success' => true,
            'message' => 'Doctor schedule loaded successfully.',
            'data' => $workingHours,
        ]);
    }

    $date = Carbon::createFromFormat('Y-m-d', $validated['date']);
    $dayOfWeek = strtolower($date->format('l'));

    $workingHours = $doctor->workingHours()
        ->where('day_of_week', $dayOfWeek)
        ->where('is_available', true)
        ->orderBy('start_time')
        ->get(['id', 'day_of_week', 'start_time', 'end_time', 'is_available', 'notes']);

    $availableSlots = Appointment::availableSlotsForDate($doctor, $date, $slotDurationMinutes, $ignoreAppointmentId);

    return response()->json([
        'success' => true,
        'message' => 'Doctor schedule loaded successfully.',
        'data' => [
            'doctor_profile_id' => $doctor->id,
            'date' => $date->toDateString(),
            'day_of_week' => $dayOfWeek,
            'slot_duration_minutes' => $slotDurationMinutes,
            'working_hours' => $workingHours->map(function ($hour) {
                return [
                    'id' => $hour->id,
                    'day_of_week' => $hour->day_of_week,
                    'start_time' => Carbon::parse($hour->start_time)->format('H:i'),
                    'end_time' => Carbon::parse($hour->end_time)->format('H:i'),
                    'is_available' => (bool) $hour->is_available,
                    'notes' => $hour->notes,
                ];
            })->values(),
            'available_slots' => $availableSlots,
        ],
    ]);
}

    public function specialties()
    {
        $specialties = Specialty::query()
            ->where('is_active', true)
            ->orderBy('name')
            ->get(['id', 'name', 'description']);

        return response()->json([
            'success' => true,
            'message' => 'Specialties loaded successfully.',
            'data' => $specialties,
        ]);
    }

    protected function transform(DoctorProfile $doctor, bool $withWorkingHours = false): array
    {
        $data = [
            'id' => $doctor->id,
            'full_name' => $doctor->full_name,
            'license_number' => $doctor->license_number,
            'phone' => $doctor->phone,
            'bio' => $doctor->bio,
            'consultation_fee' => (float) $doctor->consultation_fee,
            'is_available' => (bool) $doctor->is_available,
            'specialty' => $doctor->specialty ? [
                'id' => $doctor->specialty->id,
                'name' => $doctor->specialty->name,
            ] : null,
        ];

        if ($withWorkingHours) {
            $data['working_hours'] = $doctor->workingHours
                ->where('is_available', true)
                ->sortBy(function ($hour) {
                    $position = array_search($hour->day_of_week, WeekDay::values(), true);

                    return $position === false ? PHP_INT_MAX : $position;
                })
                ->map(fn ($wh) => [
                    'day_of_week' => $wh->day_of_week,
                    'start_time' => Carbon::parse($wh->start_time)->format('H:i'),
                    'end_time' => Carbon::parse($wh->end_time)->format('H:i'),
                    'notes' => $wh->notes,
                ])
                ->values();
        }

        return $data;
    }
}
