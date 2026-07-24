<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

class UpdateDeliveryAddressRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->check();
    }

    public function rules(): array
    {
        return [
            'delivery_address' => ['sometimes', 'required', 'string', 'max:2000'],
            'city' => ['sometimes', 'required', 'string', 'max:100'],
            'area' => ['sometimes', 'required', 'string', 'max:100'],
            'contact_phone' => ['sometimes', 'required', 'string', 'max:30'],
            'notes' => ['nullable', 'string', 'max:2000'],
        ];
    }
}
