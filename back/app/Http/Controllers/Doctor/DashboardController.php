<?php

namespace App\Http\Controllers\Doctor;

use App\Http\Controllers\Controller;
use App\Http\Enums\AppointmentStatus;
use App\Models\Appointment;

class DashboardController extends Controller
{
    public function index()
    {
        auth()->user()->loadMissing('doctorProfile.specialty');

        $doctorProfile = auth()->user()->doctorProfile;

        abort_unless($doctorProfile, 403, 'Doctor profile not found.');

        $baseQuery = Appointment::query()
            ->where('doctor_profile_id', $doctorProfile->id);

        $todayAppointments = (clone $baseQuery)
            ->whereDate('appointment_date', today())
            ->count();

        $pendingAppointments = (clone $baseQuery)
            ->where('status', AppointmentStatus::Pending->value)
            ->count();

        $upcomingAppointments = (clone $baseQuery)
            ->upcoming()
            ->whereIn('status', [
                AppointmentStatus::Pending->value,
                AppointmentStatus::Accepted->value,
            ])
            ->count();

        $latestAppointments = (clone $baseQuery)
            ->with(['user', 'pet'])
            ->orderByDesc('appointment_date')
            ->orderByDesc('appointment_time')
            ->limit(5)
            ->get();

        return view('doctor.dashboard', compact(
            'doctorProfile',
            'todayAppointments',
            'pendingAppointments',
            'upcomingAppointments',
            'latestAppointments'
        ));
    }
}
