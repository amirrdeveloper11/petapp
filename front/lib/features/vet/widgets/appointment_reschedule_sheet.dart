import 'package:flutter/material.dart';
import 'package:front/widgets/custom_button.dart';

import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../models/doctor_schedule_model.dart';
import '../services/vet_service.dart';
import 'booking_date_field.dart';
import 'slot_picker.dart';

class AppointmentRescheduleSheet extends StatefulWidget {
  final VetService service;
  final AppointmentModel appointment;

  const AppointmentRescheduleSheet({
    super.key,
    required this.service,
    required this.appointment,
  });

  @override
  State<AppointmentRescheduleSheet> createState() =>
      _AppointmentRescheduleSheetState();
}

class _AppointmentRescheduleSheetState
    extends State<AppointmentRescheduleSheet> {
  DoctorModel? _doctor;
  DoctorScheduleModel? _schedule;
  bool _loading = true;
  bool _scheduleLoading = false;
  String? _error;
  String? _scheduleError;
  DateTime? _selectedDate;
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = _parseDate(widget.appointment.appointmentDate);
    _selectedTime = widget.appointment.appointmentTime;
    _load();
  }

  Future<void> _load() async {
    final doctorId = widget.appointment.doctor?.id;

    if (doctorId == null || doctorId <= 0) {
      if (mounted) {
        setState(() {
          _error = 'Doctor not found';
          _loading = false;
        });
      }
      return;
    }

    try {
      final initialDate = _selectedDate ?? DateTime.now();
      final results = await Future.wait([
        widget.service.fetchDoctor(doctorId),
        widget.service.fetchDoctorSchedule(
          doctorId: doctorId,
          date: _formatDate(initialDate),
          ignoreAppointmentId: widget.appointment.id,
        ),
      ]);

      if (!mounted) return;

      _doctor = results[0] as DoctorModel;
      _schedule = results[1] as DoctorScheduleModel;

      if (_selectedTime != null &&
          !(_schedule?.availableSlots.contains(_selectedTime) ?? false)) {
        _selectedTime = null;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadScheduleForDate(DateTime date) async {
    final doctor = _doctor;
    if (doctor == null) return;

    final normalized = DateUtils.dateOnly(date);

    setState(() {
      _selectedDate = normalized;
      _selectedTime = null;
      _scheduleLoading = true;
      _scheduleError = null;
    });

    try {
      final schedule = await widget.service.fetchDoctorSchedule(
        doctorId: doctor.id,
        date: _formatDate(normalized),
        ignoreAppointmentId: widget.appointment.id,
      );

      if (!mounted) return;
      if (_selectedDate == null ||
          !DateUtils.isSameDay(_selectedDate!, normalized)) {
        return;
      }

      setState(() {
        _schedule = schedule;
      });
    } catch (e) {
      if (!mounted) return;
      if (_selectedDate != null &&
          DateUtils.isSameDay(_selectedDate!, normalized)) {
        setState(() {
          _scheduleError = e.toString();
          _schedule = null;
        });
      }
    } finally {
      if (!mounted) return;
      if (_selectedDate != null &&
          DateUtils.isSameDay(_selectedDate!, normalized)) {
        setState(() => _scheduleLoading = false);
      }
    }
  }

  List<DateTime> _availableDates() {
    final doctor = _doctor;
    if (doctor == null) return const [];

    final days = doctor.workingHours
        .map((e) => e.dayOfWeek.toLowerCase())
        .toSet();
    final today = DateUtils.dateOnly(DateTime.now());
    final result = <DateTime>[];

    for (int i = 0; i < 30; i++) {
      final date = today.add(Duration(days: i));
      final name = _weekdayName(date.weekday);

      if (days.contains(name)) {
        result.add(date);
      }
    }

    return result;
  }

  List<String> _slotsForSelectedDate() {
    return _schedule?.availableSlots ?? const [];
  }

  Future<void> _confirm() async {
    final date = _selectedDate;
    final time = _selectedTime;

    if (date == null || time == null) return;

    Navigator.pop(
      context,
      AppointmentRescheduleResult(date: _formatDate(date), time: time),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final dates = _availableDates();
    final slots = _slotsForSelectedDate();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: 16 + bottomInset,
        ),
        child: _loading
            ? const SizedBox(
                height: 280,
                child: Center(child: CircularProgressIndicator()),
              )
            : _error != null
            ? SizedBox(height: 220, child: Center(child: Text(_error!)))
            : _doctor == null
            ? const SizedBox(
                height: 220,
                child: Center(child: Text('Doctor not found')),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reschedule appointment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 98,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: dates.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final date = dates[i];
                        final selected =
                            _selectedDate != null &&
                            DateUtils.isSameDay(_selectedDate, date);

                        return BookingDateChip(
                          date: date,
                          selected: selected,
                          onTap: () => _loadScheduleForDate(date),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_scheduleLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    if (_scheduleError != null) ...[
                      Text(
                        _scheduleError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SlotPicker(
                      slots: slots,
                      selectedSlot: _selectedTime,
                      onSelected: (slot) =>
                          setState(() => _selectedTime = slot),
                    ),
                  ],
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Confirm reschedule',
                    onPressed:
                        (_selectedDate != null &&
                            _selectedTime != null &&
                            !_scheduleLoading)
                        ? _confirm
                        : null,
                  ),
                ],
              ),
      ),
    );
  }

  DateTime _parseDate(String value) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _weekdayName(int w) {
    const map = {
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };
    return map[w]!;
  }
}

class AppointmentRescheduleResult {
  final String date;
  final String time;

  const AppointmentRescheduleResult({required this.date, required this.time});
}
