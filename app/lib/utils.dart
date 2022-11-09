import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

extension PrettyJson on Map<String, dynamic> {
  String toPrettyString() {
    const encoder = JsonEncoder.withIndent("     ");
    return encoder.convert(this);
  }
}

final supabaseClient = Supabase.instance.client;
