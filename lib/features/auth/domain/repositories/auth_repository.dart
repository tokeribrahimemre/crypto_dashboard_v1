import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> signIn(String email, String password);
  Future<Either<Failure, String>> signUp(String email, String password);
  Future<Either<Failure, void>> signOut();
  bool get isSignedIn;
}