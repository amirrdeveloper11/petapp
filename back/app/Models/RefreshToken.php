<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Support\Str;

class RefreshToken extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'token', 'expires_at', 'revoked'];

    protected $casts = [
        'expires_at' => 'datetime',
        'revoked' => 'boolean',
    ];

    /**
     * Generate a new refresh token for a given user.
     */
    public static function generate(User $user): self
    {
        return self::create([
            'user_id' => $user->id,
            'token' => Str::random(64),
            'expires_at' => now()->addDays(7), // 7 days
        ]);
    }

    /**
     * Check if the refresh token is expired or revoked.
     */
    public function isExpired(): bool
    {
        return $this->expires_at->isPast() || $this->revoked;
    }

    /**
     * Relationship: token belongs to a user.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
