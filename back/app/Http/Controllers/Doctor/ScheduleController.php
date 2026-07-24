<?php

namespace App\Http\Controllers\Doctor;

use App\Http\Controllers\Controller;
use App\Http\Requests\Doctor\WorkingHourRequest;
use App\Http\Enums\WeekDay;
use App\Models\DoctorWorkingHour;
use Illuminate\Http\Request;

class ScheduleController extends Controller
{
    public function index(Request $request)
    {
        $doctorProfile = $this->doctorProfile();

        $editingWorkingHour = null;
        if ($request->filled('edit')) {
            $editingWorkingHour = DoctorWorkingHour::query()
                ->forDoctorProfile((int) $doctorProfile->id)
                ->findOrFail((int) $request->query('edit'));
        }

        $workingHours = $doctorProfile->workingHours()
            ->orderBy('day_of_week')
            ->orderBy('start_time')
            ->get()
            ->groupBy('day_of_week');

        $orderedWorkingHours = collect(WeekDay::values())
            ->mapWithKeys(function (string $day) use ($workingHours) {
                return [$day => $workingHours->get($day, collect())];
            })
            ->filter(fn ($hours) => $hours->isNotEmpty());

        return view('doctor.schedule.index', [
            'doctorProfile' => $doctorProfile,
            'workingHours' => $orderedWorkingHours,
            'editingWorkingHour' => $editingWorkingHour,
        ]);
    }

    public function store(WorkingHourRequest $request)
    {
        $doctorProfile = $this->doctorProfile();
        $data = $request->validated();
        $data['is_available'] = $request->boolean('is_available');

        DoctorWorkingHour::create([
            'doctor_profile_id' => $doctorProfile->id,
            ...$data,
        ]);

        return redirect()
            ->route('doctor.schedule.index')
            ->with('success', 'Working hour added successfully.');
    }

    public function update(WorkingHourRequest $request, DoctorWorkingHour $workingHour)
    {
        $doctorProfile = $this->doctorProfile();

        abort_unless((int) $workingHour->doctor_profile_id === (int) $doctorProfile->id, 403);

        $data = $request->validated();
        $data['is_available'] = $request->boolean('is_available');

        $workingHour->update($data);

        return redirect()
            ->route('doctor.schedule.index', ['edit' => $workingHour->id])
            ->with('success', 'Working hour updated successfully.');
    }

    public function destroy(DoctorWorkingHour $workingHour)
    {
        $doctorProfile = $this->doctorProfile();

        abort_unless((int) $workingHour->doctor_profile_id === (int) $doctorProfile->id, 403);

        $workingHour->delete();

        return redirect()
            ->route('doctor.schedule.index')
            ->with('success', 'Working hour deleted successfully.');
    }

    private function doctorProfile()
    {
        $doctorProfile = auth()->user()->doctorProfile;

        abort_unless($doctorProfile, 403, 'Doctor profile not found.');

        return $doctorProfile;
    }
}
