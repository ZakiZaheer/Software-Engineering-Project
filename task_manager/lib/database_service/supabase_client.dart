import 'package:supabase_flutter/supabase_flutter.dart';

class SupaBaseService{
  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> initialize() async{
    await   Supabase.initialize(
      url: 'https://sornufnxzvrhthrqcijb.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNvcm51Zm54enZyaHRocnFjaWpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjYwNDIyNzcsImV4cCI6MjA0MTYxODI3N30.zCvK-nlDCvxX-OJwMjafq3UEAa8FZgbqsgXAkgmvZjg');
  }
}