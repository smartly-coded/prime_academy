import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/networking/api_result.dart';
import 'package:prime_academy/features/profileScreen/data/Repos/student_profile_repo.dart';
import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  //  final CourseRepository repository;
  final StudentProfileRepo _studentProfileRepo;
  ProfileCubit(this._studentProfileRepo) : super(ProfileState.initial());
  void emitprofileState() async {
    emit(const ProfileState.loading());
    final response = await _studentProfileRepo.getStudentProfileData();
    response.when(
      success: (studentProfileResponse) async {
        emit(
          ProfileState<StudentProfileResponse>.success(studentProfileResponse),
        );
      },
      failure: (error) {
        emit(ProfileState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  //Future<void> loadUserCourses(int userId) async {
  //  try {
  //    emit(CourseLoading());
  //    final courses = await repository.getUserCourses(userId);
  //    emit(CourseLoaded(courses));
  //  } catch (e) {
  //    emit(CourseError(e.toString()));
  //  }
  //}
}
