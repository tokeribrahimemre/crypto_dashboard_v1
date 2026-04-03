import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> signIn(String email, String password) async {
    try {
      final userId = await remoteDataSource.signIn(email, password);
      return Right(userId);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> signUp(String email, String password) async {
    try {
      final userId = await remoteDataSource.signUp(email, password);
      return Right(userId);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  bool get isSignedIn => remoteDataSource.isSignedIn;
}