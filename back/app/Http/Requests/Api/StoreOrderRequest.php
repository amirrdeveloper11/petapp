<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreOrderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    protected function prepareForValidation(): void
    {
        $paymentMethod = $this->input('payment_method');

        if (is_string($paymentMethod)) {
            $normalized = strtolower(trim($paymentMethod));

            $map = [
                'cash on delivery' => 'cod',
                'cash_on_delivery' => 'cod',
                'cash-delivery' => 'cod',
                'cash' => 'cod',
                'cod' => 'cod',
                'online payment' => 'online',
                'online_payment' => 'online',
                'online' => 'online',
                'manual payment' => 'online',
                'manual_payment' => 'online',
                'manual' => 'online',
            ];

            $paymentMethod = $map[$normalized] ?? $normalized;
        }

        $this->merge([
            'payment_method' => $paymentMethod,
        ]);
    }

    public function rules(): array
    {
        return [
            'payment_method' => ['required', 'string', Rule::in(['cod', 'online'])],
            'payment_reference' => ['nullable', 'string', 'max:100'],

            'delivery_address' => ['required', 'string', 'max:255'],
            'city' => ['required', 'string', 'max:100'],
            'area' => ['required', 'string', 'max:100'],
            'contact_phone' => ['required', 'string', 'max:30'],

            'notes' => ['nullable', 'string'],

            'items' => ['required', 'array', 'min:1'],
            'items.*.product_id' => [
                'required',
                'distinct',
                Rule::exists('products', 'id')->where('is_active', true),
            ],
            'items.*.quantity' => ['required', 'integer', 'min:1'],
        ];
    }

    public function messages(): array
    {
        return [
            'payment_method.required' => 'Payment method is required.',
            'payment_method.in' => 'The selected payment method is invalid.',
            'delivery_address.required' => 'Delivery address is required.',
            'city.required' => 'City is required.',
            'area.required' => 'Area is required.',
            'contact_phone.required' => 'Contact phone is required.',
            'items.required' => 'At least one item is required.',
            'items.*.product_id.exists' => 'One or more selected products are unavailable.',
        ];
    }
}
