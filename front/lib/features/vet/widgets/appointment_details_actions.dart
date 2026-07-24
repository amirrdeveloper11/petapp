import 'package:flutter/material.dart';
import 'package:front/widgets/custom_button.dart';

class AppointmentDetailsActions extends StatelessWidget {
  final bool canReschedule;
  final bool canCancel;
  final bool busy;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  const AppointmentDetailsActions({
    super.key,
    required this.canReschedule,
    required this.canCancel,
    required this.busy,
    required this.onReschedule,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (!canReschedule && !canCancel) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (canReschedule)
          CustomButton(
            text: busy ? 'Please wait...' : 'Reschedule appointment',
            onPressed: busy ? null : onReschedule,
            isLoading: false,
            icon: Icons.update_rounded,
          ),
        if (canCancel) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton(
              onPressed: busy ? null : onCancel,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                busy ? 'Please wait...' : 'Cancel appointment',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
