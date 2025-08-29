import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/screens/ShowPersonalForWK/Bloc/show_personal_server_mangent.dart';

import 'package:warehouse/screens/ShowPersonalForWK/Bloc/show_personal_states.dart';

class ShowPersonalCubit extends Cubit<ShowPersonalState> {
  final CustodyWKService custodyService;

  ShowPersonalCubit({required this.custodyService})
      : super(ShowPersonalInitial()) {
    loadCustody();
  }

  List<Map<String, dynamic>> _allCustody = [];
  String _searchQuery = "";

  Future<void> loadCustody() async {
    emit(ShowPersonalLoading());
    try {
      _allCustody = await custodyService.fetchAllCustody();
      _filterCustody();
    } catch (e) {
      emit(ShowPersonalError(e.toString()));
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterCustody();
  }

  void _filterCustody() {
    final filteredCustody = _allCustody.where((custody) {
      final owner = custody["owner"]!.toLowerCase();
      return owner.contains(_searchQuery.toLowerCase());
    }).toList();

    emit(ShowPersonalLoaded(
      allCustody: _allCustody,
      filteredCustody: filteredCustody,
      searchQuery: _searchQuery,
    ));
  }
}
