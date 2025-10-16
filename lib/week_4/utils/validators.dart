class Validators {
  static String? validatePhone(String? v, {String field = 'Nomor HP'}) {
    if (v == null || v.trim().isEmpty) return '$field wajib diisi';
    final s = v.trim();

    // contoh rule: harus mulai dengan '62', hanya digit, panjang 10..15
    if (!s.startsWith('62')) return '$field harus diawali dengan 62';
    if (!RegExp(r'^\d+$').hasMatch(s)) return '$field hanya boleh berisi angka';
    if (s.length < 10 || s.length > 15) return '$field harus 10–15 digit';

    return null; // ✅ null artinya valid
  }

  static bool isValidEmail(String value) {
    final re = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    return re.hasMatch(value.trim());
  }

  static String? validateEmail(String? v, {String field = 'Email'}) {
    if (v == null || v.trim().isEmpty) return '$field wajib diisi';
    if (!isValidEmail(v)) return 'Format $field tidak valid';
    return null;
  }

  static String? validatePassword(String? v, {String field = 'Password'}) {
    if (v == null || v.trim().isEmpty) {
      return '$field wajib diisi';
    }
    if (v.trim().length < 6) {
      return '$field Minimal 6 karakter';
    }
    return null;
  }

  static String? requiredText(String? v, {String field = 'Field'}) {
    if (v == null || v.trim().isEmpty) return '$field wajib diisi';
    return null;
  }

  static String? minLen(String? v, int n, {String field = 'Field'}) {
    if (v == null || v.trim().length < n) return '$field minimal $n karakter';
    return null;
  }

  static String? dateDdMMyyyy(String? v) {
    if (v == null || v.trim().isEmpty) return 'Tanggal lahir wajib diisi';
    try {
      final parts = v.split('-'); // dd-MM-yyyy
      if (parts.length != 3) throw Exception('format');
      final d = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final y = int.parse(parts[2]);
      final dob = DateTime(y, m, d);
      final now = DateTime.now();
      if (dob.isAfter(now)) return 'Tanggal tidak boleh di masa depan';
      final minAgeDate = DateTime(now.year - 18, now.month, now.day);
      if (dob.isAfter(minAgeDate)) return 'Minimal usia 18 tahun';
      return null;
    } catch (_) {
      return 'Format tanggal tidak valid (dd-MM-yyyy)';
    }
  }

  static String? requiredDropdown(String? v, {String field = 'Field'}) {
    return v == null ? 'Pilih $field' : null;
  }

  static String? jobSelected(String? v, {String field = 'Field'}) {
    return v == null ? 'Pilih $field' : null;
  }
}

class DateUtilsExt {
  static String toDdMMyyyy(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd-$mm-${d.year}';
  }

  static DateTime suggestInitial18yo() {
    final now = DateTime.now();
    return DateTime(now.year - 18, now.month, now.day);
  }
}
