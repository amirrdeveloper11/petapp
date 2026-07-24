<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Appointment;
use App\Models\DoctorProfile;

class DashboardController extends Controller
{
    public function index()
    {
        return view('admin.dashboard', [
            'doctorCount' => DoctorProfile::count(),
            'orderCount' => Order::count(),
            'appointmentCount' => Appointment::count(),
            'todayAppointments' => Appointment::whereDate('appointment_date', today())->count(),
        ]);
    }
}
