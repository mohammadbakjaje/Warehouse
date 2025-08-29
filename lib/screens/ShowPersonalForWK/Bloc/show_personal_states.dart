abstract class ShowPersonalState {
  const ShowPersonalState();
}

class ShowPersonalInitial extends ShowPersonalState {
  @override
  List<Object> get props => [];
}

class ShowPersonalLoading extends ShowPersonalState {
  @override
  List<Object> get props => [];
}

class ShowPersonalLoaded extends ShowPersonalState {
  final List<Map<String, dynamic>> allCustody;
  final List<Map<String, dynamic>> filteredCustody;
  final String searchQuery;

  const ShowPersonalLoaded({
    required this.allCustody,
    required this.filteredCustody,
    required this.searchQuery,
  });

  @override
  List<Object> get props => [allCustody, filteredCustody, searchQuery];
}

class ShowPersonalError extends ShowPersonalState {
  final String message;

  const ShowPersonalError(this.message);

  @override
  List<Object> get props => [message];
}
