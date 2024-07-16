String getDeviceTimeZone() {
  var now = DateTime.now();
  var offset = now.timeZoneOffset;
  var hours = offset.inHours.abs().toString().padLeft(2, '0');
  var minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
  var sign = offset.isNegative ? '-' : '+';

  return 'UTC$sign$hours:$minutes';
}
