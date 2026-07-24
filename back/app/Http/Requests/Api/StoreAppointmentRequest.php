<?php

namespace App\Http\Requests\Api;

use App\Models\Appointment;
use App\Models\DoctorProfile;
use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreAppointmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->check() && auth()->user()->role === 'user';
    }

    public function rules(): array
    {
        return [
            'pet_id' => [
                'required',
                Rule::exists('pets', 'id')
                    ->where(fn ($query) => $query->where('user_id', auth()->id())),
            ],

            'doctor_profile_id' => [
                'required',
                Rule::exists('doctor_profiles', 'id')
                    ->where(fn ($query) => $query
                        ->where('is_available', true)
                        ->whereNull('deleted_at')),
            ],

            'appointment_date' => [
                'required',
                'date',
                'after_or_equal:today',
            ],

            'appointment_time' => [
                'required',
                'date_format:H:i',
            ],

            'duration_minutes' => [
                'nullable',
                'integer',
                'min:10',
                'max:240',
            ],

            'reason' => [
                'required',
                'string',
                'max:2000',
            ],
        ];
    }

    public function withValidator($validator): void
    {
        $validator->after(function ($validator) {
            $doctorProfileId = (int) $this->input('doctor_profile_id');
            $appointmentDate = $this->input('appointment_date');
            $appointmentTime = $this->input('appointment_time');

            if (! $doctorProfileId || ! $appointmentDate || ! $appointmentTime) {
                return;
            }

            try {
                $durationMinutes = max(10, (int) $this->input('duration_minutes', 30));

                $start = Carbon::createFromFormat('Y-m-d H:i', sprintf(
                    '%s %s',
                    Carbon::parse($appointmentDate)->toDateString(),
                    Carbon::createFromFormat('H:i', $appointmentTime)->format('H:i')
                ));
                $end = $start->copy()->addMinutes($durationMinutes);

                if ($start->isPast()) {
                    $validator->errors()->add(
                        'appointment_time',
                        'The appointment time must be in the future.'
                    );

                    return;
                }

                $doctorProfile = DoctorProfile::query()
                    ->with('workingHours')
                    ->find($doctorProfileId);

                if (! $doctorProfile) {
                    $validator->errors()->add('doctor_profile_id', 'The selected doctor is invalid.');
                    return;
                }

                if (! Appointment::slotFitsDoctorWorkingHours($doctorProfile, $start, $end)) {
                    $validator->errors()->add(
                        'appointment_time',
                        'The selected appointment time is outside the doctor working hours.'
                    );
                    return;
                }

                if (Appointment::hasSchedulingConflict($doctorProfile->id, $start, $end)) {
                    $validator->errors()->add(
                        'appointment_time',
                        'This appointment time is already booked.'
                    );
                }
            } catch (\Throwable $e) {
                $validator->errors()->add(
                    'appointment_time',
                    'The selected appointment time is invalid.'
                );
            }
        });
    }
}
