<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Enums\AppointmentStatus;
use App\Http\Requests\Api\RescheduleAppointmentRequest;
use App\Http\Requests\Api\StoreAppointmentRequest;
use App\Models\Appointment;
use App\Models\DoctorProfile;
use Carbon\Carbon;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class AppointmentController extends Controller
{
    public function index()
    {
        $appointments = Appointment::query()
            ->with(['pet', 'doctor.specialty', 'doctor.user'])
            ->where('user_id', auth()->id())
            ->orderByDesc('appointment_date')
            ->orderByDesc('appointment_time')
            ->get()
            ->map(fn (Appointment $appointment) => $this->format($appointment))
            ->values();

        return response()->json([
            'success' => true,
            'message' => 'Appointments loaded successfully',
            'data' => $appointments,
        ]);
    }

    public function store(StoreAppointmentRequest $request)
    {
        $validated = $request->validated();

        try {
            $appointment = DB::transaction(function () use ($validated) {
                $doctorProfile = DoctorProfile::query()
                    ->with('workingHours')
                    ->findOrFail($validated['doctor_profile_id']);

                $start = Appointment::normalizeDateTime(
                    $validated['appointment_date'],
                    $validated['appointment_time']
                );

                $durationMinutes = (int) ($validated['duration_minutes'] ?? 30);
                $durationMinutes = max(10, $durationMinutes);
                $end = Appointment::appointmentEnd($start, $durationMinutes);

                $conflict = Appointment::query()
                    ->where('doctor_profile_id', $doctorProfile->id)
                    ->whereDate('appointment_date', $start->toDateString())
                    ->activeBookings()
                    ->lockForUpdate()
                    ->get()
                    ->contains(function (Appointment $existing) use ($start, $end) {
                        $existingStart = Appointment::normalizeDateTime(
                            $existing->appointment_date,
                            $existing->appointment_time
                        );

                        $existingEnd = Appointment::appointmentEnd(
                            $existingStart,
                            (int) $existing->duration_minutes
                        );

                        return Appointment::intervalsOverlap($start, $end, $existingStart, $existingEnd);
                    });

                if (! Appointment::slotFitsDoctorWorkingHours($doctorProfile, $start, $end)) {
                    throw ValidationException::withMessages([
                        'appointment_time' => ['The selected appointment time is outside the doctor working hours.'],
                    ]);
                }

                if ($conflict) {
                    throw ValidationException::withMessages([
                        'appointment_time' => ['This appointment time is already booked.'],
                    ]);
                }

                return Appointment::create([
                    'user_id' => auth()->id(),
                    'pet_id' => $validated['pet_id'],
                    'doctor_profile_id' => $doctorProfile->id,
                    'appointment_date' => $start->toDateString(),
                    'appointment_time' => $start->format('H:i'),
                    'duration_minutes' => $durationMinutes,
                    'reason' => $validated['reason'],
                    'status' => AppointmentStatus::Pending->value,
                ]);
            });
        } catch (QueryException $e) {
            if ($this->isActiveBookingUniqueViolation($e)) {
                throw ValidationException::withMessages([
                    'appointment_time' => ['This appointment time is already booked.'],
                ]);
            }

            throw $e;
        }

        $appointment->load(['pet', 'doctor.specialty', 'doctor.user']);

        return response()->json([
            'success' => true,
            'message' => 'Appointment booked successfully.',
            'data' => $this->format($appointment),
        ], 201);
    }

    public function show(Appointment $appointment)
    {
        abort_unless((int) $appointment->user_id === (int) auth()->id(), 403, 'Forbidden.');

        $appointment->load(['pet', 'doctor.specialty', 'doctor.user']);

        return response()->json([
            'success' => true,
            'message' => 'Appointment loaded successfully.',
            'data' => $this->format($appointment),
        ]);
    }

    public function reschedule(RescheduleAppointmentRequest $request, Appointment $appointment)
{
    abort_unless((int) $appointment->user_id === (int) auth()->id(), 403, 'Forbidden.');

    if (! $this->canModifyUpcomingAppointment($appointment)) {
        return response()->json([
            'success' => false,
            'message' => 'Only upcoming pending or accepted appointments can be rescheduled.',
        ], 422);
    }

    $validated = $request->validated();

    try {
        DB::transaction(function () use ($validated, $appointment) {
            $doctorProfile = DoctorProfile::query()
                ->with('workingHours')
                ->findOrFail($appointment->doctor_profile_id);

            $start = Appointment::normalizeDateTime(
                $validated['appointment_date'],
                $validated['appointment_time']
            );

            $end = Appointment::appointmentEnd($start, (int) $appointment->duration_minutes);

            $conflict = Appointment::query()
                ->where('doctor_profile_id', $doctorProfile->id)
                ->whereDate('appointment_date', $start->toDateString())
                ->activeBookings()
                ->where('id', '!=', $appointment->id)
                ->lockForUpdate()
                ->get()
                ->contains(function (Appointment $existing) use ($start, $end) {
                    $existingStart = Appointment::normalizeDateTime(
                        $existing->appointment_date,
                        $existing->appointment_time
                    );

                    $existingEnd = Appointment::appointmentEnd(
                        $existingStart,
                        (int) $existing->duration_minutes
                    );

                    return Appointment::intervalsOverlap($start, $end, $existingStart, $existingEnd);
                });

            if (! Appointment::slotFitsDoctorWorkingHours($doctorProfile, $start, $end)) {
                throw ValidationException::withMessages([
                    'appointment_time' => ['The selected appointment time is outside the doctor working hours.'],
                ]);
            }

            if ($conflict) {
                throw ValidationException::withMessages([
                    'appointment_time' => ['The new time slot is already booked. Please choose another time.'],
                ]);
            }

            $appointment->update([
                'appointment_date' => $start->toDateString(),
                'appointment_time' => $start->format('H:i'),
                'status' => AppointmentStatus::Pending->value,
                'accepted_at' => null,
                'completed_at' => null,
                'consultation_notes' => null,
                'rejection_reason' => null,
            ]);
        });
    } catch (QueryException $e) {
        if ($this->isActiveBookingUniqueViolation($e)) {
            throw ValidationException::withMessages([
                'appointment_time' => ['The new time slot is already booked. Please choose another time.'],
            ]);
        }

        throw $e;
    }

    $appointment->load(['pet', 'doctor.specialty', 'doctor.user']);

    return response()->json([
        'success' => true,
        'message' => 'Appointment rescheduled successfully and set to pending review.',
        'data' => $this->format($appointment),
    ]);
}

    public function cancel(Appointment $appointment)
    {
        abort_unless((int) $appointment->user_id === (int) auth()->id(), 403, 'Forbidden.');

        if (! $this->canModifyUpcomingAppointment($appointment)) {
            return response()->json([
                'success' => false,
                'message' => 'Only upcoming pending or accepted appointments can be cancelled.',
            ], 422);
        }

        $appointment->update([
            'status' => AppointmentStatus::Cancelled->value,
        ]);

        $appointment->load(['pet', 'doctor.specialty', 'doctor.user']);

        return response()->json([
            'success' => true,
            'message' => 'Appointment cancelled successfully.',
            'data' => $this->format($appointment),
        ]);
    }

    private function canModifyUpcomingAppointment(Appointment $appointment): bool
    {
        $status = $appointment->status instanceof AppointmentStatus
            ? $appointment->status->value
            : (string) $appointment->status;

        if (! in_array($status, [
            AppointmentStatus::Pending->value,
            AppointmentStatus::Accepted->value,
        ], true)) {
            return false;
        }

        return $this->appointmentDateTime($appointment)->greaterThanOrEqualTo(now());
    }

    private function appointmentDateTime(Appointment $appointment): Carbon
    {
        return Appointment::normalizeDateTime($appointment->appointment_date, $appointment->appointment_time);
    }

    private function formatDate($value): ?string
    {
        if (blank($value)) {
            return null;
        }

        return Carbon::parse($value)->format('Y-m-d');
    }

    private function format(Appointment $appointment): array
    {
        $status = $appointment->status instanceof AppointmentStatus
            ? $appointment->status->value
            : (string) $appointment->status;

        return [
            'id' => $appointment->id,
            'appointment_date' => $this->formatDate($appointment->appointment_date),
            'appointment_time' => $appointment->appointment_time,
            'duration_minutes' => (int) $appointment->duration_minutes,
            'status' => $status,
            'can_reschedule' => $this->canModifyUpcomingAppointment($appointment),
            'can_cancel' => $this->canModifyUpcomingAppointment($appointment),
            'reason' => $appointment->reason,
            'consultation_notes' => $appointment->consultation_notes,
            'rejection_reason' => $appointment->rejection_reason,
            'accepted_at' => $appointment->accepted_at,
            'completed_at' => $appointment->completed_at,
            'created_at' => $appointment->created_at,
            'updated_at' => $appointment->updated_at,
            'pet' => $appointment->pet ? [
                'id' => $appointment->pet->id,
                'name' => $appointment->pet->name,
                'type' => $appointment->pet->type,
                'breed' => $appointment->pet->breed,
            ] : null,
            'doctor' => $appointment->doctor ? [
                'id' => $appointment->doctor->id,
                'full_name' => $appointment->doctor->full_name,
                'consultation_fee' => (float) $appointment->doctor->consultation_fee,
                'specialty' => $appointment->doctor->specialty ? [
                    'id' => $appointment->doctor->specialty->id,
                    'name' => $appointment->doctor->specialty->name,
                ] : null,
            ] : null,
        ];
    }

    private function isActiveBookingUniqueViolation(QueryException $exception): bool
    {
        $message = $exception->getMessage();
        $sqlState = $exception->errorInfo[0] ?? null;
        $driverCode = $exception->errorInfo[1] ?? null;

        return in_array($driverCode, [2601, 2627], true)
            || in_array($sqlState, ['23000', '23505'], true)
            || str_contains($message, 'appointments_active_booking_unique');
    }
}
