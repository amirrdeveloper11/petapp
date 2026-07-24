<?php

namespace App\Http\Requests\Doctor;

use App\Http\Enums\WeekDay;
use App\Models\DoctorWorkingHour;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class WorkingHourRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->check()
            && auth()->user()->role === 'doctor'
            && auth()->user()->doctorProfile !== null;
    }

    public function rules(): array
    {
        return [
            'day_of_week' => ['required', Rule::in(WeekDay::values())],
            'start_time' => ['required', 'date_format:H:i'],
            'end_time' => ['required', 'date_format:H:i', 'after:start_time'],
            'is_available' => ['nullable', 'boolean'],
            'notes' => ['nullable', 'string', 'max:1000'],
        ];
    }

    public function withValidator($validator): void
    {
        $validator->after(function ($validator) {
            $doctorProfile = auth()->user()?->doctorProfile;

            if (! $doctorProfile || ! $this->filled(['day_of_week', 'start_time', 'end_time'])) {
                return;
            }

            $workingHour = $this->route('workingHour');
            $ignoreId = $workingHour instanceof DoctorWorkingHour ? $workingHour->id : null;

            if (! DoctorWorkingHour::hasOverlap(
                (int) $doctorProfile->id,
                (string) $this->input('day_of_week'),
                (string) $this->input('start_time'),
                (string) $this->input('end_time'),
                $ignoreId
            )) {
                return;
            }

            $validator->errors()->add(
                'start_time',
                'The working hour overlaps with another working hour in your schedule.'
            );
        });
    }
}
