<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\StoreDoctorRequest;
use App\Http\Requests\Admin\UpdateDoctorRequest;
use App\Models\DoctorProfile;
use App\Models\Specialty;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DoctorController extends Controller
{
    public function index()
    {
        $doctors = DoctorProfile::with(['user', 'specialty'])
            ->latest()
            ->paginate(15);

        return view('admin.doctors.index', compact('doctors'));
    }

    public function create()
    {
        $specialties = Specialty::where('is_active', true)->orderBy('name')->get();

        return view('admin.doctors.create', compact('specialties'));
    }

    public function store(StoreDoctorRequest $request)
    {
        DB::transaction(function () use ($request) {
            $user = User::where('email', $request->email)->first();

            if ($user) {
                $user->update([
                    'name' => $request->full_name,
                    'password' => Hash::make($request->password),
                    'role' => 'doctor',
                    'is_active' => true,
                ]);
            } else {
                $user = User::create([
                    'name' => $request->full_name,
                    'email' => $request->email,
                    'password' => Hash::make($request->password),
                    'role' => 'doctor',
                    'is_active' => true,
                ]);
            }

            $attributes = [
                'specialty_id' => $request->specialty_id,
                'full_name' => $request->full_name,
                'license_number' => $request->license_number,
                'phone' => $request->phone,
                'bio' => $request->bio,
                'consultation_fee' => $request->consultation_fee,
                'is_available' => $request->boolean('is_available', true),
            ];

            $doctorProfile = DoctorProfile::withTrashed()->where('user_id', $user->id)->first();

            if ($doctorProfile) {
                $doctorProfile->restore();
                $doctorProfile->update($attributes);
            } else {
                DoctorProfile::create($attributes + ['user_id' => $user->id]);
            }
        });

        return redirect()->route('admin.doctors.index')->with('success', 'Doctor created successfully.');
    }

    public function show(DoctorProfile $doctor)
    {
        $doctor->load(['user', 'specialty', 'workingHours', 'appointments.pet', 'appointments.user']);

        return view('admin.doctors.show', compact('doctor'));
    }

    public function edit(DoctorProfile $doctor)
    {
        $doctor->load('user');
        $specialties = Specialty::where('is_active', true)->orderBy('name')->get();

        return view('admin.doctors.edit', compact('doctor', 'specialties'));
    }

    public function update(UpdateDoctorRequest $request, DoctorProfile $doctor)
    {
        DB::transaction(function () use ($request, $doctor) {
            $doctor->update([
                'specialty_id' => $request->specialty_id,
                'full_name' => $request->full_name,
                'license_number' => $request->license_number,
                'phone' => $request->phone,
                'bio' => $request->bio,
                'consultation_fee' => $request->consultation_fee,
                'is_available' => $request->boolean('is_available'),
            ]);

            $doctor->user->update([
                'name' => $request->full_name,
                'email' => $request->email,
                'is_active' => $request->boolean('is_active'),
                'password' => $request->filled('password') ? Hash::make($request->password) : $doctor->user->password,
            ]);
        });

        return redirect()->route('admin.doctors.index')->with('success', 'Doctor updated successfully.');
    }

    public function destroy(DoctorProfile $doctor)
    {
        DB::transaction(function () use ($doctor) {
            $doctor->workingHours()->delete();

            $doctor->user()->update(['is_active' => false]);
            $doctor->delete();
        });

        return redirect()->route('admin.doctors.index')->with('success', 'Doctor removed successfully.');
    }

    public function toggleStatus(DoctorProfile $doctor)
    {
        $newActiveState = ! $doctor->user->is_active;

        $doctor->user->update([
            'is_active' => $newActiveState,
        ]);

        $doctor->update([
            'is_available' => $newActiveState,
        ]);

        return back()->with('success', 'Doctor status updated.');
    }
}
