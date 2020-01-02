import './step_res.dart';

class TripInfoRes {
  final int distance; // met
  final int time;
  final List<StepsRes> steps;

  TripInfoRes(this.distance,this.time, this.steps);
}