import 'dart:convert';

import 'package:stripe_example/config.dart';
import 'package:supabase/supabase.dart';

extension PrettyJson on Map<String, dynamic> {
  String toPrettyString() {
    const encoder = JsonEncoder.withIndent("     ");
    return encoder.convert(this);
  }
}

final supabaseClient = SupabaseClient(supabaseUrl, supabaseAnonKey);
