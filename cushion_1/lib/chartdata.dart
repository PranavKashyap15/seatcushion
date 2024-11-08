// class ChartData {
//   ChartData(this.x, double timeInHours)
//       : hours = timeInHours.floor(),
//         minutes = ((timeInHours - timeInHours.floor()) * 60).round();

//   final String x;
//   final int hours;
//   final int minutes;

//   String get formattedTime {
//     if (hours == 0) {
//       return '$minutes minutes';
//     } else {
//       return '$hours hours $minutes minutes';
//     }
//   }
// }
// class ChartData {
//   ChartData(this.x, double timeInHours)
//       : hours = timeInHours.floor(),
//         minutes = ((timeInHours - timeInHours.floor()) * 60).floor(),
//         seconds = (((timeInHours - timeInHours.floor()) * 60 - ((timeInHours - timeInHours.floor()) * 60).floor()) * 60).round();

//   final String x;
//   final int hours;
//   final int minutes;
//   final int seconds;

//   String get formattedTime {
//     if (hours == 0 && minutes == 0) {
//       return '$seconds seconds';
//     } else if (hours == 0) {
//       return '$minutes minutes';
//     } else {
//       return '$hours hours $minutes minutes';
//     }
//   }
// }
class ChartData {
  ChartData(this.x, double timeInHours)
      : hours = timeInHours.floor(),
        minutes = ((timeInHours - timeInHours.floor()) * 60).floor(),
        seconds = (((timeInHours - timeInHours.floor()) * 60 - ((timeInHours - timeInHours.floor()) * 60).floor()) * 60).round(),
        totalTimeInSeconds = (timeInHours * 3600).round(); // Added this line

  final String x;
  final int hours;
  final int minutes;
  final int seconds;
  final int totalTimeInSeconds; // Make sure this field is defined

  String get formattedTime {
    if (hours == 0 && minutes == 0) {
      return '$seconds seconds';
    } else if (hours == 0) {
      return '$minutes minutes';
    } else {
      return '$hours hours $minutes minutes';
    }
  }
}
