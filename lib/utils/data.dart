Map<String, dynamic> mergeMaps(Map<String, dynamic> map1, Map<String, dynamic> map2) {
  Map<String, dynamic> mergedMap = {};

  map1.forEach((key, value) {
    if (map2.containsKey(key)) {
      if (value is Map<String, dynamic> && map2[key] is Map<String, dynamic>) {
        mergedMap[key] = mergeMaps(value, map2[key]);
      } else {
        mergedMap[key] = map2[key];
      }
    } else {
      mergedMap[key] = value;
    }
  });
  map2.forEach((key, value) {
    if (!mergedMap.containsKey(key)) {
      mergedMap[key] = value;
    }
  });

  return mergedMap;
}