<?php

namespace App\Models;

use App\Http\Enums\OrderStatus;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'order_number',
        'subtotal',
        'total',
        'status',
        'payment_method',
        'payment_reference',
        'delivery_address',
        'city',
        'area',
        'contact_phone',
        'notes',
        'placed_at',
    ];

    protected $casts = [
        'user_id' => 'integer',
        'subtotal' => 'decimal:2',
        'total' => 'decimal:2',
        'status' => OrderStatus::class,
        'placed_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function items(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }

    public function getPaymentMethodLabelAttribute(): string
    {
        return match (strtolower(trim((string) $this->payment_method))) {
            'cod' => 'Cash on delivery',
            'online' => 'Online payment',
            default => $this->payment_method ?: '-',
        };
    }
}
