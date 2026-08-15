import 'package:flutter/material.dart';

import 'package:front/core/theme.dart';
import 'package:front/widgets/app_confirm_dialog.dart';

import '../models/appointment_model.dart';
import '../providers/appointment_provider.dart';
import '../../../core/services/vet_service.dart';
import '../widgets/appointment_details_actions.dart';
import '../widgets/appointment_details_summary_card.dart';
import '../widgets/appointment_reschedule_sheet.dart';

class AppointmentDetailsPage extends StatefulWidget {
  final AppointmentModel appointment;
  final AppointmentProvider? provider;

  const AppointmentDetailsPage({
    super.key,
    required this.appointment,
    this.provider,
  });

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  final VetService _service =  VetService();
  late AppointmentModel _appointment;
  bool _busy = false;

  AppointmentProvider? get _provider => widget.provider;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
  }

  Future<void> _cancel() async {
    if (!_appointment.canCancelAction || _busy) return;

    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Cancel appointment?',
      message: 'This will cancel the appointment if it is still pending.',
      confirmText: 'Cancel',
      destructive: true,
    );
    if (!confirmed) return;

    await _runMutation(() async {
      final updated = _provider != null
          ? await _provider!.cancel(_appointment.id)
          : await _service.cancelAppointment(_appointment.id);
      _provider?.replaceLocal(updated);
      return updated;
    }, successMessage: 'Appointment cancelled');
  }

  Future<void> _reschedule() async {
    if (!_appointment.canRescheduleAction || _busy) return;

    final result = await showModalBottomSheet<AppointmentRescheduleResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppointmentRescheduleSheet(
        service: _service,
        appointment: _appointment,
      ),
    );
    if (result == null) return;

    await _runMutation(() async {
      final updated = _provider != null
          ? await _provider!.reschedule(
              id: _appointment.id,
              appointmentDate: result.date,
              appointmentTime: result.time,
            )
          : await _service.rescheduleAppointment(
              id: _appointment.id,
              appointmentDate: result.date,
              appointmentTime: result.time,
            );
      _provider?.replaceLocal(updated);
      return updated;
    }, successMessage: 'Appointment rescheduled');
  }

  Future<void> _runMutation(
    Future<AppointmentModel> Function() mutation, {
    required String successMessage,
  }) async {
    setState(() => _busy = true);
    try {
      final updated = await mutation();
      if (!mounted) return;

      setState(() => _appointment = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
      Navigator.pop(context, updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: Text(
          'Appointment #${_appointment.id}',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.deepTeal),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          AppointmentDetailsSummaryCard(appointment: _appointment),
          const SizedBox(height: 16),
          AppointmentDetailsActions(
            canReschedule: _appointment.canRescheduleAction,
            canCancel: _appointment.canCancelAction,
            busy: _busy,
            onReschedule: _reschedule,
            onCancel: _cancel,
          ),
        ],
      ),
    );
  }
}
