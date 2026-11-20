import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/figma_icon.dart';
import 'checkout_payment_screen.dart';

class CheckoutBillingScreen extends StatefulWidget {
  const CheckoutBillingScreen({super.key});

  @override
  State<CheckoutBillingScreen> createState() => _CheckoutBillingScreenState();
}

class _CheckoutBillingScreenState extends State<CheckoutBillingScreen> {
  bool _saveDetails = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildStepsIndicator(1),
                      const SizedBox(height: 32),
                      const Text(
                        'Your billing details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'These details will appear on your receipt.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: const [
                          Expanded(
                            child: _BillingField(
                              label: 'First name',
                              value: 'Ronald',
                            ),
                          ),
                          SizedBox(width: 17),
                          Expanded(
                            child: _BillingField(
                              label: 'Last name',
                              value: 'Richard',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const _BillingField(
                        label: 'Email address',
                        value: 'studentdemo@example.com',
                      ),
                      const SizedBox(height: 20),
                      const _BillingField(
                        label: 'Country / region',
                        value: 'United States',
                      ),
                      const SizedBox(height: 20),
                      const _BillingField(
                        label: 'Street address',
                        value: '123 SW Market Street',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Expanded(
                            child: _BillingField(
                              label: 'City',
                              value: 'Portland',
                            ),
                          ),
                          SizedBox(width: 17),
                          Expanded(
                            child: _BillingField(
                              label: 'State',
                              value: 'Oregon',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Expanded(
                            child: _BillingField(
                              label: 'ZIP code',
                              value: '97205',
                            ),
                          ),
                          SizedBox(width: 17),
                          Expanded(
                            child: _BillingField(
                              label: 'Phone number',
                              value: '90154-91036',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _saveDetails = !_saveDetails),
                        child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: _saveDetails
                                    ? AppColors.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: _saveDetails
                                    ? null
                                    : Border.all(
                                        color: const Color(0xFFB8AFC7)),
                              ),
                              child: _saveDetails
                                  ? const Center(
                                      child: Text(
                                        '✓',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Save these details for next time',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'No shipping needed. Your courses are digital.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const FigmaIcon('back_icon', size: 22),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Checkout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const FigmaIcon('lock_icon', size: 22),
        ],
      ),
    );
  }

  Widget _buildStepsIndicator(int currentStep) {
    return Row(
      children: [
        _buildStep(1, 'Billing', currentStep),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.sageMint,
          ),
        ),
        _buildStep(2, 'Payment', currentStep),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.sageMint,
          ),
        ),
        _buildStep(3, 'Review', currentStep),
      ],
    );
  }

  Widget _buildStep(int step, String label, int currentStep) {
    final isDone = step < currentStep;
    final isCurrent = step == currentStep;

    return Column(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: isCurrent || isDone
                ? AppColors.primary
                : const Color(0xFFE9E7EF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight:
                isCurrent ? FontWeight.w600 : FontWeight.normal,
            color: isCurrent
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CheckoutPaymentScreen(),
                ),
              );
            },
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Continue to payment →',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BillingField extends StatelessWidget {
  final String label;
  final String value;

  const _BillingField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFDED9E8), width: 1),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
