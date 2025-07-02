import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_app_bar.dart';
import '../widgets/booking_button.dart';
import '../models/customer_info.dart';
import 'booking_summary_screen.dart';

class CustomerInfoScreen extends StatefulWidget {
  const CustomerInfoScreen({super.key});

  @override
  State<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  
  bool _saveForFuture = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final customerInfo = context.read<BookingProvider>().booking.customerInfo;
    if (customerInfo != null) {
      _firstNameController.text = customerInfo.firstName;
      _lastNameController.text = customerInfo.lastName;
      _phoneController.text = customerInfo.phoneNumber;
      _emailController.text = customerInfo.email ?? '';
      _notesController.text = customerInfo.specialInstructions ?? '';
      _saveForFuture = customerInfo.saveForFuture;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const BookingAppBar(
            title: 'Customer Details',
          ),
          body: Column(
            children: [
              BookingProgressIndicator(
                currentStep: 3,
                totalSteps: 5,
                stepTitles: const [
                  'Select Service',
                  'Choose Staff',
                  'Pick Date & Time',
                  'Your Details',
                  'Confirm Booking',
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormField(
                          controller: _firstNameController,
                          label: 'First Name',
                          isRequired: true,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'First name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.space16),
                        _buildFormField(
                          controller: _lastNameController,
                          label: 'Last Name',
                          isRequired: true,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Last name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.space16),
                        _buildFormField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          isRequired: true,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [_PhoneNumberFormatter()],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Phone number is required';
                            }
                            final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                            if (digitsOnly.length != 10) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.space16),
                        _buildFormField(
                          controller: _emailController,
                          label: 'Email (optional)',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.space16),
                        _buildFormField(
                          controller: _notesController,
                          label: 'Special Instructions',
                          maxLines: 3,
                          maxLength: 200,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        const SizedBox(height: AppSpacing.space24),
                        _buildSaveOption(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BookingFloatingButton(
            text: 'Continue',
            onPressed: () => _handleContinue(bookingProvider),
          ),
        );
      },
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.labelLarge,
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            hintStyle: AppTypography.bodyLarge.copyWith(
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: AppColors.inputFill,
            border: OutlineInputBorder(
              borderRadius: AppSizes.inputBorderRadius,
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: AppSizes.borderNormal,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSizes.inputBorderRadius,
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: AppSizes.borderNormal,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSizes.inputBorderRadius,
              borderSide: const BorderSide(
                color: AppColors.inputFocused,
                width: AppSizes.borderThick,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppSizes.inputBorderRadius,
              borderSide: const BorderSide(
                color: AppColors.inputError,
                width: AppSizes.borderNormal,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppSizes.inputBorderRadius,
              borderSide: const BorderSide(
                color: AppColors.inputError,
                width: AppSizes.borderThick,
              ),
            ),
            contentPadding: AppSpacing.formFieldPadding,
            counterStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveOption() {
    return Row(
      children: [
        Checkbox(
          value: _saveForFuture,
          onChanged: (value) {
            setState(() {
              _saveForFuture = value ?? false;
            });
          },
          activeColor: AppColors.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: AppSpacing.space8),
        Expanded(
          child: Text(
            'Save info for future bookings',
            style: AppTypography.bodyMedium,
          ),
        ),
      ],
    );
  }

  void _handleContinue(BookingProvider bookingProvider) {
    if (_formKey.currentState?.validate() ?? false) {
      final customerInfo = CustomerInfo(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        specialInstructions: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
        saveForFuture: _saveForFuture,
      );

      bookingProvider.updateCustomerInfo(customerInfo);
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BookingSummaryScreen(),
        ),
      );
    }
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length <= 10) {
      String formattedText = '';
      
      if (digitsOnly.isNotEmpty) {
        if (digitsOnly.length <= 3) {
          formattedText = '($digitsOnly';
        } else if (digitsOnly.length <= 6) {
          formattedText = '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3)}';
        } else {
          formattedText = '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
        }
      }
      
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
    
    return oldValue;
  }
} 