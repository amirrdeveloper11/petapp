<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class DoctorWorkingHour extends Model
{
    use HasFactory;

    protected $fillable = [
        'doctor_profile_id',
        'day_of_week',
        'start_time',
        'end_time',
        'is_available',
        'notes',
    ];

    protected $casts = [
        'is_available' => 'boolean',
    ];

    public function doctorProfile(): BelongsTo
    {
        return $this->belongsTo(DoctorProfile::class);
    }

    public function scopeForDoctorProfile(Builder $query, int $doctorProfileId): Builder
    {
        return $query->where('doctor_profile_id', $doctorProfileId);
    }

    public static function hasOverlap(
        int $doctorProfileId,
        string $dayOfWeek,
        string $startTime,
        string $endTime,
        ?int $ignoreId = null
    ): bool {
        $newStart = Carbon::createFromFormat('H:i', $startTime);
        $newEnd = Carbon::createFromFormat('H:i', $endTime);

        return static::query()
            ->where('doctor_profile_id', $doctorProfileId)
            ->where('day_of_week', $dayOfWeek)
            ->when($ignoreId, fn (Builder $query) => $query->where('id', '!=', $ignoreId))
            ->get()
            ->contains(function (self $hour) use ($newStart, $newEnd) {
                $existingStart = Carbon::createFromFormat('H:i:s', Carbon::parse($hour->start_time)->format('H:i:s'));
                $existingEnd = Carbon::createFromFormat('H:i:s', Carbon::parse($hour->end_time)->format('H:i:s'));

                return $newStart->lt($existingEnd) && $newEnd->gt($existingStart);
            });
    }
}
