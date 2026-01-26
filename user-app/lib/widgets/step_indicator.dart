import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> stepTitles;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Step dots and connectors
        Row(
          children: List.generate(
            stepTitles.length * 2 - 1,
            (index) {
              if (index.isEven) {
                // Step circle
                final stepIndex = index ~/ 2;
                final isCompleted = stepIndex < currentStep;
                final isCurrent = stepIndex == currentStep;

                return _buildStepCircle(
                  context,
                  stepIndex + 1,
                  isCompleted: isCompleted,
                  isCurrent: isCurrent,
                );
              } else {
                // Connector line
                final stepIndex = index ~/ 2;
                final isCompleted = stepIndex < currentStep;

                return Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                  ),
                );
              }
            },
          ),
        ),

        const SizedBox(height: 8),

        // Step titles
        Row(
          children: List.generate(
            stepTitles.length,
            (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;

              return Expanded(
                child: Text(
                  stepTitles[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                    color: isCompleted || isCurrent
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStepCircle(
    BuildContext context,
    int stepNumber, {
    required bool isCompleted,
    required bool isCurrent,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isCurrent
            ? Theme.of(context).primaryColor
            : Colors.grey.shade300,
        border: Border.all(
          color: isCurrent
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check,
                size: 18,
                color: Colors.white,
              )
            : Text(
                stepNumber.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isCurrent ? Colors.white : Colors.grey.shade600,
                ),
              ),
      ),
    );
  }
}
