import 'package:flutter/foundation.dart';
class NormalizationProvider with ChangeNotifier {
  int _normalizationFactor = 130; 
  int get normalizationFactor => _normalizationFactor;
  double _currentScale = 1.5; 
  double get currentScale => _currentScale; 
  void setNormalizationFactor(double scale) {
     _currentScale = scale;
    if (scale == 1.0) {
      _normalizationFactor = 88;
    } else if (scale == 1.5) {
      _normalizationFactor = 130;
    } else if (scale == 2.0) {
      _normalizationFactor = 160;
    }
    notifyListeners();
  }
}
