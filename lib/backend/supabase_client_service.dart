import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  SupabaseClientService._();
  static final SupabaseClientService _clientService =
      SupabaseClientService._();
  factory SupabaseClientService() {
    return _clientService;
  }

  SupabaseClient getClient() => Supabase.instance.client;
}
