// lib/services/step_counter_service.dart
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounterService {
  static const String STEPS_KEY_PREFIX = 'daily_steps_';

  // Threshold for step detection
  final double _threshold = 12.0;
  bool _isCountingSteps = false;
  double _lastMagnitude = 0.0;

  // Get today's date as string key
  String get _todayKey => STEPS_KEY_PREFIX + DateTime.now().toIso8601String().split('T')[0];

  // Initialize step counter
  Future<void> initializeStepCounter() async {
    final prefs = await SharedPreferences.getInstance();
    // Check if we need to reset steps (new day)
    _checkAndResetSteps(prefs);

    // Start listening to accelerometer events
    accelerometerEvents.listen((AccelerometerEvent event) {
      _processAccelerometerEvent(event);
    });
  }

  // Process accelerometer data to detect steps
  void _processAccelerometerEvent(AccelerometerEvent event) async {
    final magnitude = _calculateMagnitude(event);

    if (!_isCountingSteps && magnitude > _threshold && _lastMagnitude <= _threshold) {
      _isCountingSteps = true;
      await _incrementSteps();
    } else if (_isCountingSteps && magnitude <= _threshold) {
      _isCountingSteps = false;
    }

    _lastMagnitude = magnitude;
  }

  // Calculate magnitude of acceleration
  double _calculateMagnitude(AccelerometerEvent event) {
    return (event.x * event.x + event.y * event.y + event.z * event.z).abs();
  }

  // Increment step count
  Future<void> _incrementSteps() async {
    final prefs = await SharedPreferences.getInstance();
    final currentSteps = await getTodaySteps();
    await prefs.setInt(_todayKey, currentSteps + 1);
  }

  // Get steps for today
  Future<int> getTodaySteps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_todayKey) ?? 0;
  }

  // Check and reset steps if it's a new day
  Future<void> _checkAndResetSteps(SharedPreferences prefs) async {
    final lastResetDate = prefs.getString('last_reset_date');
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastResetDate != today) {
      await prefs.setString('last_reset_date', today);
      await prefs.setInt(_todayKey, 0);
    }
  }

  // Get steps for a specific date
  Future<int> getStepsForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey = STEPS_KEY_PREFIX + date.toIso8601String().split('T')[0];
    return prefs.getInt(dateKey) ?? 0;
  }

  // Get steps for the last 7 days
  Future<Map<String, int>> getWeeklySteps() async {
    final Map<String, int> weeklySteps = {};
    final prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey = STEPS_KEY_PREFIX + date.toIso8601String().split('T')[0];
      weeklySteps[date.toIso8601String().split('T')[0]] = prefs.getInt(dateKey) ?? 0;
    }

    return weeklySteps;
  }
}