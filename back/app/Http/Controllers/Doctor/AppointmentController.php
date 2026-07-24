<?php

namespace App\Http\Controllers\Doctor;

use App\Http\Controllers\Controller;
use App\Http\Enums\AppointmentStatus;
use App\Http\Requests\Doctor\UpdateAppointmentRequest;
use App\Models\Appointment;
use Illuminate\Http\Request;

class AppointmentController extends Controller
{
    public function index(Request $request)
    {
        $doctorProfile = auth()->user()->doctorProfile;

        abort_unless($doctorProfile, 403, 'Doctor profile not found.');

        $filter = $request->query('filter', 'upcoming');

        $query = Appointment::query()
            ->with(['user', 'pet'])
            ->where('doctor_profile_id', $doctorProfile->id);

        switch ($filter) {
            case 'today':
                $query->whereDate('appointment_date', today());
                break;

            case 'pending':
                $query->where('status', AppointmentStatus::Pending->value);
                break;

            case 'all':
                break;

            case 'upcoming':
            default:
                $query->whereDate('appointment_date', '>=', today())
                    ->whereIn('status', [
                        AppointmentStatus::Pending->value,
                        AppointmentStatus::Accepted->value,
                    ]);
                break;
        }

        $appointments = $query
            ->orderBy('appointment_date')
            ->orderBy('appointment_time')
            ->paginate(20)
            ->withQueryString();

        return view('doctor.appointments.index', compact('appointments', 'filter'));
    }

    public function show(Appointment $appointment)
    {
        $doctorProfile = auth()->user()->doctorProfile;

        abort_unless($doctorProfile, 403, 'Doctor profile not found.');
        abort_unless((int) $appointment->doctor_profile_id === (int) $doctorProfile->id, 403);

        $appointment->load(['user', 'pet', 'doctor.specialty']);

        return view('doctor.appointments.show', compact('appointment'));
    }

    public function update(UpdateAppointmentRequest $request, Appointment $appointment)
    {
        $doctorProfile = auth()->user()->doctorProfile;

        abort_unless($doctorProfile, 403, 'Doctor profile not found.');
        abort_unless((int) $appointment->doctor_profile_id === (int) $doctorProfile->id, 403);

        $data = $request->validated();

        $currentStatus = $appointment->status instanceof AppointmentStatus
            ? $appointment->status
            : AppointmentStatus::from((string) $appointment->status);

        $newStatus = AppointmentStatus::from($data['status']);

        if (! $this->canTransition($currentStatus, $newStatus)) {
            return back()->withErrors([
                'status' => 'Invalid appointment status transition.',
            ]);
        }

        $payload = [
            'status' => $newStatus->value,
            'accepted_at' => $appointment->accepted_at,
            'completed_at' => $appointment->completed_at,
            'consultation_notes' => $appointment->consultation_notes,
            'rejection_reason' => $appointment->rejection_reason,
        ];

        if ($newStatus === AppointmentStatus::Accepted) {
            $payload['accepted_at'] = $appointment->accepted_at ?? now();
            $payload['completed_at'] = null;
            $payload['rejection_reason'] = null;
        }

        if ($newStatus === AppointmentStatus::Rejected) {
            $payload['accepted_at'] = null;
            $payload['completed_at'] = null;
            $payload['consultation_notes'] = null;
            $payload['rejection_reason'] = $data['rejection_reason'] ?? 'Rejected by doctor';
        }

        if ($newStatus === AppointmentStatus::Completed) {
            $payload['completed_at'] = now();
            $payload['rejection_reason'] = null;
            $payload['consultation_notes'] = $data['consultation_notes'];
        }

        $appointment->update($payload);

        return back()->with('success', 'Appointment updated successfully.');
    }

    private function canTransition(AppointmentStatus $current, AppointmentStatus $new): bool
    {
        return match ($current) {
            AppointmentStatus::Pending => in_array($new, [
                AppointmentStatus::Accepted,
                AppointmentStatus::Rejected,
            ], true),

            AppointmentStatus::Accepted => $new === AppointmentStatus::Completed,

            default => false,
        };
    }
}
