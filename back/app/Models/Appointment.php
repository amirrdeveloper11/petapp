<?php

namespace App\Models;

use App\Http\Enums\AppointmentStatus;
use Carbon\Carbon;
use DateTimeInterface;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Appointment extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'pet_id',
        'doctor_profile_id',
        'appointment_date',
        'appointment_time',
        'duration_minutes',
        'reason',
        'status',
        'consultation_notes',
        'rejection_reason',
        'accepted_at',
        'completed_at',
    ];

    protected $casts = [
        'appointment_date' => 'date',
        'accepted_at' => 'datetime',
        'completed_at' => 'datetime',
        'status' => AppointmentStatus::class,
        'duration_minutes' => 'integer',
    ];

    public static function bookingKey(int $doctorProfileId, string|DateTimeInterface $appointmentDate, string $appointmentTime): string
    {
        return sprintf(
            '%d:%s:%s',
            $doctorProfileId,
            Carbon::parse($appointmentDate)->toDateString(),
            Carbon::parse($appointmentTime)->format('H:i')
        );
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function pet(): BelongsTo
    {
        return $this->belongsTo(Pet::class);
    }

    public function doctor(): BelongsTo
    {
        return $this->belongsTo(DoctorProfile::class, 'doctor_profile_id')->withTrashed();
    }

    public static function activeBookingStatuses(): array
    {
        return [
            AppointmentStatus::Pending->value,
            AppointmentStatus::Accepted->value,
        ];
    }

    public function scopeActiveBookings(Builder $query): Builder
    {
        return $query->whereIn('status', self::activeBookingStatuses());
    }

    public function scopeUpcoming(Builder $query): Builder
    {
        $now = now();

        return $query->where(function (Builder $q) use ($now) {
            $q->whereDate('appointment_date', '>', $now->toDateString())
              ->orWhere(function (Builder $q) use ($now) {
                  $q->whereDate('appointment_date', $now->toDateString())
                    ->whereTime('appointment_time', '>=', $now->format('H:i:s'));
              });
        });
    }

    public static function normalizeDateTime(DateTimeInterface|string $appointmentDate, DateTimeInterface|string $appointmentTime): Carbon
    {
        $date = Carbon::parse($appointmentDate)->toDateString();
        $time = Carbon::parse($appointmentTime)->format('H:i');

        return Carbon::createFromFormat('Y-m-d H:i', $date.' '.$time);
    }

    public static function appointmentEnd(Carbon $start, int $durationMinutes): Carbon
    {
        return $start->copy()->addMinutes(max(1, $durationMinutes));
    }

    public static function intervalsOverlap(Carbon $startA, Carbon $endA, Carbon $startB, Carbon $endB): bool
    {
        return $startA->lt($endB) && $endA->gt($startB);
    }

    public static function slotFitsDoctorWorkingHours(DoctorProfile $doctorProfile, Carbon $start, Carbon $end): bool
    {
        $doctorProfile->loadMissing('workingHours');

        $dayOfWeek = strtolower($start->format('l'));

        $workingHours = $doctorProfile->workingHours
            ->where('day_of_week', $dayOfWeek)
            ->where('is_available', true)
            ->values();

        if ($workingHours->isEmpty()) {
            return false;
        }

        foreach ($workingHours as $hour) {
            $windowStart = Carbon::createFromFormat(
                'Y-m-d H:i',
                $start->toDateString().' '.Carbon::parse($hour->start_time)->format('H:i')
            );

            $windowEnd = Carbon::createFromFormat(
                'Y-m-d H:i',
                $start->toDateString().' '.Carbon::parse($hour->end_time)->format('H:i')
            );

            if ($start->greaterThanOrEqualTo($windowStart) && $end->lessThanOrEqualTo($windowEnd)) {
                return true;
            }
        }

        return false;
    }

    public static function hasSchedulingConflict(
        int $doctorProfileId,
        Carbon $start,
        Carbon $end,
        ?int $ignoreAppointmentId = null
    ): bool {
        $appointments = static::query()
            ->select(['id', 'appointment_date', 'appointment_time', 'duration_minutes'])
            ->where('doctor_profile_id', $doctorProfileId)
            ->whereDate('appointment_date', $start->toDateString())
            ->activeBookings()
            ->when($ignoreAppointmentId, fn ($query) => $query->where('id', '!=', $ignoreAppointmentId))
            ->get();

        foreach ($appointments as $appointment) {
            $existingStart = static::normalizeDateTime($appointment->appointment_date, $appointment->appointment_time);
            $existingEnd = static::appointmentEnd($existingStart, (int) $appointment->duration_minutes);

            if (static::intervalsOverlap($start, $end, $existingStart, $existingEnd)) {
                return true;
            }
        }

        return false;
    }

    public static function slotCanBeBooked(
        DoctorProfile $doctorProfile,
        Carbon $start,
        Carbon $end,
        ?int $ignoreAppointmentId = null,
        ?\Illuminate\Support\Collection $bookedAppointments = null
    ): bool {
        if (! static::slotFitsDoctorWorkingHours($doctorProfile, $start, $end)) {
            return false;
        }

        if ($bookedAppointments === null) {
            return ! static::hasSchedulingConflict($doctorProfile->id, $start, $end, $ignoreAppointmentId);
        }

        foreach ($bookedAppointments as $appointment) {
            if ($ignoreAppointmentId && (int) $appointment->id === (int) $ignoreAppointmentId) {
                continue;
            }

            $existingStart = static::normalizeDateTime($appointment->appointment_date, $appointment->appointment_time);
            $existingEnd = static::appointmentEnd($existingStart, (int) $appointment->duration_minutes);

            if (static::intervalsOverlap($start, $end, $existingStart, $existingEnd)) {
                return false;
            }
        }

        return true;
    }

    public static function availableSlotsForDate(
        DoctorProfile $doctorProfile,
        Carbon $date,
        int $slotDurationMinutes = 30,
        ?int $ignoreAppointmentId = null
    ): array {
        $slotDurationMinutes = max(10, $slotDurationMinutes);
        $dayOfWeek = strtolower($date->format('l'));

        $workingHours = $doctorProfile->workingHours()
            ->where('day_of_week', $dayOfWeek)
            ->where('is_available', true)
            ->orderBy('start_time')
            ->get();

        $bookedAppointments = static::query()
            ->select(['id', 'appointment_date', 'appointment_time', 'duration_minutes'])
            ->where('doctor_profile_id', $doctorProfile->id)
            ->whereDate('appointment_date', $date->toDateString())
            ->activeBookings()
            ->when($ignoreAppointmentId, fn ($query) => $query->where('id', '!=', $ignoreAppointmentId))
            ->get();

        $slots = [];

        foreach ($workingHours as $hour) {
            $windowStart = Carbon::createFromFormat(
                'Y-m-d H:i',
                $date->toDateString().' '.Carbon::parse($hour->start_time)->format('H:i')
            );

            $windowEnd = Carbon::createFromFormat(
                'Y-m-d H:i',
                $date->toDateString().' '.Carbon::parse($hour->end_time)->format('H:i')
            );

            $cursor = $windowStart->copy();

            while ($cursor->copy()->addMinutes($slotDurationMinutes)->lessThanOrEqualTo($windowEnd)) {
                $slotEnd = $cursor->copy()->addMinutes($slotDurationMinutes);

                if (static::slotCanBeBooked($doctorProfile, $cursor, $slotEnd, $ignoreAppointmentId, $bookedAppointments)) {
                    $slots[] = [
                        'date' => $date->toDateString(),
                        'start_time' => $cursor->format('H:i'),
                        'end_time' => $slotEnd->format('H:i'),
                        'label' => $cursor->format('H:i'),
                        'bookable' => true,
                    ];
                }

                $cursor->addMinutes($slotDurationMinutes);
            }
        }

        return array_values($slots);
    }

    public static function bookedSlotsForDate(DoctorProfile $doctorProfile, Carbon $date): array
    {
        return static::query()
            ->where('doctor_profile_id', $doctorProfile->id)
            ->whereDate('appointment_date', $date->toDateString())
            ->activeBookings()
            ->orderBy('appointment_time')
            ->get()
            ->map(function (self $appointment) use ($date) {
                $start = static::normalizeDateTime($date, $appointment->appointment_time);
                $end = static::appointmentEnd($start, (int) $appointment->duration_minutes);

                return [
                    'id' => $appointment->id,
                    'date' => $date->toDateString(),
                    'start_time' => $start->format('H:i'),
                    'end_time' => $end->format('H:i'),
                    'duration_minutes' => (int) $appointment->duration_minutes,
                    'status' => $appointment->status instanceof AppointmentStatus
                        ? $appointment->status->value
                        : (string) $appointment->status,
                ];
            })
            ->values()
            ->all();
    }

    public function isActiveBooking(): bool
    {
        $status = $this->status instanceof AppointmentStatus
            ? $this->status->value
            : (string) $this->status;

        return in_array($status, self::activeBookingStatuses(), true);
    }

    public function scheduledStart(): Carbon
    {
        return static::normalizeDateTime($this->appointment_date, $this->appointment_time);
    }

    public function scheduledEnd(): Carbon
    {
        return static::appointmentEnd($this->scheduledStart(), (int) $this->duration_minutes);
    }
}
