<?php

namespace App\Http\Requests\Doctor;

use Illuminate\Foundation\Http\FormRequest;

class StoreConsultationNotesRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->check() && auth()->user()->role === 'doctor';
    }

    public function rules(): array
    {
        return [
            'consultation_notes' => ['required', 'string'],
        ];
    }
}
