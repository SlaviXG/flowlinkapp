String getDeviceTimeZone({bool includeUTC = true}) {
  var now = DateTime.now();
  var offset = now.timeZoneOffset;
  var hours = offset.inHours.abs().toString().padLeft(2, '0');
  var minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
  var sign = offset.isNegative ? '-' : '+';
  return includeUTC ? 'UTC$sign$hours:$minutes' : '$sign$hours:$minutes';
}

double calculateHoursSaved(Map <String, dynamic> response) {
  double hoursSaved = 0.0;
  if(response.containsKey('task')) {
    // 15 seconds
    hoursSaved += 0.00416;
  } else if (response.containsKey('event')) {
    // 30 seconds
    hoursSaved += 0.00833;
  }
  return hoursSaved;
}