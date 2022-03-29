import 'dart:convert';

extension PrettyJson on Map<String, dynamic> {
  String toPrettyString() {
    const encoder = JsonEncoder.withIndent("     ");
    return encoder.convert(this);
  }
}
