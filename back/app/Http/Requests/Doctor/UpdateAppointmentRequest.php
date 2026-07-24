<?php

namespace App\Http\Requests\Doctor;

use App\Http\Enums\AppointmentStatus;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateAppointmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->check() && auth()->user()->role === 'doctor';
    }

    public function rules(): array
    {
        return [
            'status' => [
                'required',
                Rule::in([
                    AppointmentStatus::Accepted->value,
                    AppointmentStatus::Rejected->value,
                    AppointmentStatus::Completed->value,
                ]),
            ],
            'consultation_notes' => [
                'nullable',
                'string',
                'required_if:status,'.AppointmentStatus::Completed->value,
            ],
            'rejection_reason' => [
                'nullable',
                'string',
                'required_if:status,'.AppointmentStatus::Rejected->value,
            ],
        ];
    }
}
