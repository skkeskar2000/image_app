import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_app/Preferences/preferences.dart';
import 'package:image_app/Preferences/preferences_helper.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleSignIn googleSignIn;

  AuthBloc({required this.googleSignIn}) : super(AuthInitial()) {
    on<GoogleSignInEvent>((event, emit) async {
      try {
        final googleAccount = await googleSignIn.signIn();
        if(googleAccount!=null){
          final authHeaders = await googleAccount!.authentication.then((auth) {
            return {
              'Authorization': 'Bearer ${auth.accessToken}',
            };
          });
          final accessToken =
              authHeaders['Authorization']?.split(' ')?.last ?? '';
          PreferencesHelper.setString(Preferences.accessToken, accessToken);
          PreferencesHelper.setBoolean(Preferences.isLoggedIn, true);
          emit(GoogleSignInSuccess());
        }else{
          emit(GoogleSignInErrorState());
        }
      } catch (error) {
        print(error);
        emit(GoogleSignInErrorState());
      }
    });

    on<GoogleSignOutEvent>((event, emit) {
      print("signOut called");
      googleSignIn.signOut();
      PreferencesHelper.setBoolean(Preferences.isLoggedIn, false);
      emit(GoogleSignOutSuccess());
    });

  }
}
