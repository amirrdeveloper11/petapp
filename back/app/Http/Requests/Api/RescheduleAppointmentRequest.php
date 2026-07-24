<?php

namespace App\Http\Requests\Api;

use App\Models\Appointment;
use App\Models\DoctorProfile;
use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;

class RescheduleAppointmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->check() && auth()->user()->role === 'user';
    }

    public function rules(): array
    {
        return [
            'appointment_date' => ['required', 'date', 'after_or_equal:today'],
            'appointment_time' => ['required', 'date_format:H:i'],
        ];
    }

    public function messages(): array
    {
        return [
            'appointment_date.after_or_equal' => 'The appointment date must be today or in the future.',
            'appointment_time.date_format' => 'The appointment time must be in HH:MM format (for example 09:30).',
        ];
    }

    public function withValidator($validator): void
    {
        $validator->after(function ($validator) {
            $appointment = $this->route('appointment');

            if (! $appointment instanceof Appointment) {
                $validator->errors()->add('appointment_time', 'The selected appointment is invalid.');
                return;
            }

            $appointmentDate = $this->input('appointment_date');
            $appointmentTime = $this->input('appointment_time');

            if (! $appointmentDate || ! $appointmentTime) {
                return;
            }

            try {
                $start = Carbon::createFromFormat('Y-m-d H:i', sprintf(
                    '%s %s',
                    Carbon::parse($appointmentDate)->toDateString(),
                    Carbon::createFromFormat('H:i', $appointmentTime)->format('H:i')
                ));

                $end = $start->copy()->addMinutes((int) $appointment->duration_minutes);

                if ($start->isPast()) {
                    $validator->errors()->add(
                        'appointment_time',
                        'The appointment must be rescheduled to a future time.'
                    );
                    return;
                }

                $doctorProfile = DoctorProfile::query()
                    ->with('workingHours')
                    ->find($appointment->doctor_profile_id);

                if (! $doctorProfile) {
                    $validator->errors()->add('appointment_time', 'The selected doctor is no longer available.');
                    return;
                }

                if (! Appointment::slotFitsDoctorWorkingHours($doctorProfile, $start, $end)) {
                    $validator->errors()->add(
                        'appointment_time',
                        'The selected appointment time is outside the doctor working hours.'
                    );
                    return;
                }

                if (Appointment::hasSchedulingConflict($doctorProfile->id, $start, $end, $appointment->id)) {
                    $validator->errors()->add(
                        'appointment_time',
                        'The new time slot is already booked. Please choose another time.'
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
