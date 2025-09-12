// modules_state.dart
part of 'modules_cubit.dart';

abstract class ModulesState {}

class ModulesInitial extends ModulesState {}

class ModulesLoading extends ModulesState {}

class ModulesLoaded extends ModulesState {
  final CourseModel course;
  ModulesLoaded(this.course);
}

class ModulesError extends ModulesState {
  final String message;
  ModulesError(this.message);
}
