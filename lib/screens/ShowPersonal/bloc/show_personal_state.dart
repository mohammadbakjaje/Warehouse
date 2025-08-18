abstract class ShowPersonalState {}

class ShowPersonalInitial extends ShowPersonalState {}

class ShowPersonalLoading extends ShowPersonalState {}

class ShowPersonalLoaded extends ShowPersonalState {
  // final List<RoomModel> rooms; // ممكن تكون Personal أو Room
  //
  // ShowPersonalLoaded({required this.rooms});
}

class ShowPersonalError extends ShowPersonalState {
  final String message;

  ShowPersonalError(this.message);
}
