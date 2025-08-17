String? emailValidator(v) =>
    v != null && v.contains('@') ? null : 'Invalid email';

String? textValidator(v) => v != null && v.isNotEmpty ? null : 'Required';
