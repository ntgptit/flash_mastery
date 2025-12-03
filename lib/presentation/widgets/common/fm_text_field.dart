import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom text field widget with built-in validation and styling
class FMTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  const FMTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  /// Factory for email field
  factory FMTextField.email({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? errorText,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) {
    return FMTextField(
      controller: controller,
      label: label ?? 'Email',
      hint: hint ?? 'Enter your email',
      errorText: errorText,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  /// Factory for password field
  /// Note: Use FMPasswordTextField widget directly for password fields
  factory FMTextField.password({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? errorText,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) = FMPasswordTextField;

  /// Factory for search field
  factory FMTextField.search({
    TextEditingController? controller,
    String? hint,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    VoidCallback? onClear,
  }) {
    return FMTextField(
      controller: controller,
      hint: hint ?? 'Search...',
      prefixIcon: Icons.search_rounded,
      suffixIcon: Icons.close_rounded,
      onSuffixIconPressed: onClear,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  /// Factory for multiline text field
  factory FMTextField.multiline({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? errorText,
    int maxLines = 5,
    int? maxLength,
    void Function(String)? onChanged,
  }) {
    return FMTextField(
      controller: controller,
      label: label,
      hint: hint,
      errorText: errorText,
      maxLines: maxLines,
      minLines: 3,
      maxLength: maxLength,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      onChanged: onChanged,
    );
  }

  @override
  State<FMTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<FMTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null,
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                icon: Icon(widget.suffixIcon),
                onPressed: widget.onSuffixIconPressed,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        filled: !widget.enabled,
        fillColor: !widget.enabled
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : null,
      ),
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      textCapitalization: widget.textCapitalization,
    );
  }
}

/// FMPassword text field with show/hide functionality
class FMPasswordTextField extends FMTextField {
  FMPasswordTextField({
    super.key,
    super.controller,
    String? label,
    String? hint,
    super.errorText,
    super.onChanged,
    super.onSubmitted,
  }) : super(
          label: label ?? 'FMPassword',
          hint: hint ?? 'Enter your password',
          prefixIcon: Icons.lock_outline,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'FMPassword is required';
            }
            if (value.length < 6) {
              return 'FMPassword must be at least 6 characters';
            }
            return null;
          },
        );

  @override
  State<FMTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<FMPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return FMTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      prefixIcon: Icons.lock_outline,
      suffixIcon: _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      onSuffixIconPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'FMPassword is required';
        }
        if (value.length < 6) {
          return 'FMPassword must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

/// OTP/FMPin input field
class FMPinTextField extends StatelessWidget {
  final int length;
  final TextEditingController? controller;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;

  const FMPinTextField({
    super.key,
    this.length = 6,
    this.controller,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: length,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
          ),
      onChanged: (value) {
        onChanged?.call(value);
        if (value.length == length) {
          onCompleted?.call(value);
        }
      },
    );
  }
}
