
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:rxdart/rxdart.dart';

enum UiState { idle, loading, done, error, redirect }

class BaseBloc {
  // Services
  final dialog = CustomDialog();
  var dialogData = DialogData();
//  final appDatabase = AppDatabaseSingleton.database;

  // Variables
  BehaviorSubject<UiState> _uiState =
      BehaviorSubject<UiState>.seeded(UiState.idle);
  BehaviorSubject<bool> _showAlert = BehaviorSubject<bool>();
  BehaviorSubject<bool> _showDialogAlert = BehaviorSubject<bool>();

  //stream getters
  Stream<UiState> get uiState => _uiState.stream;
  Stream<bool> get showAlert => _showAlert.stream;
  Stream<bool> get showDialogAlert => _showDialogAlert.stream;

  // Ui state Getters
  get isLoading => _uiState.value == UiState.loading;
  get isDone => _uiState.value == UiState.done;
  get hasError => _uiState.value == UiState.error;

  // Functions
  void setUiState(UiState uiState) {
    _uiState.add(uiState);
  }

  void setShowAlert(bool show) {
    _showAlert.add(show);
  }

  void setShowDialogAlert(bool show) {
    _showDialogAlert.add(show);
  }

  void initBloc() {}

  void reset() {
    _uiState = BehaviorSubject<UiState>.seeded(UiState.idle);
    _showAlert = BehaviorSubject<bool>();
    _showDialogAlert = BehaviorSubject<bool>();
  }

  void dispose() {
    _uiState.close();
    _showAlert.close();
    _showDialogAlert.close();
  }
}
