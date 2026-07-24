<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class RefreshToken extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'token', 'expires_at', 'revoked'];

    protected $casts = [
        'expires_at' => 'datetime',
        'revoked' => 'boolean',
    ];

    public string $plainTextToken = '';

    public static function generate(User $user): self
    {
        $plainTextToken = Str::random(64);

        $token = self::create([
            'user_id' => $user->id,
            'token' => hash('sha256', $plainTextToken),
            'expires_at' => now()->addDays(7),
            'revoked' => false,
        ]);

        $token->plainTextToken = $plainTextToken;

        return $token;
    }

    public static function findByPlainToken(string $plainToken): ?self
    {
        return self::where('token', hash('sha256', $plainToken))->first();
    }

    public function isExpired(): bool
    {
        return $this->expires_at->isPast() || $this->revoked;
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
