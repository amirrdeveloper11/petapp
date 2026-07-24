<?php

namespace App\Http\Enums;

enum AppointmentStatus: string
{
    case Pending = 'pending';
    case Accepted = 'accepted';
    case Rejected = 'rejected';
    case Completed = 'completed';
    case Cancelled = 'cancelled';

    public static function values(): array
    {
        return array_map(static fn (self $case) => $case->value, self::cases());
    }

    public function doctorEditableTransitions(): array
    {
        return match ($this) {
            self::Pending => [self::Accepted, self::Rejected],
            self::Accepted => [self::Accepted, self::Completed],
            default => [],
        };
    }

    public function canBeEditedByDoctor(): bool
    {
        return ! empty($this->doctorEditableTransitions());
    }

    public function isActiveBooking(): bool
    {
        return in_array($this, [self::Pending, self::Accepted], true);
    }
}
