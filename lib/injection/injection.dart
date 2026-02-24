import 'package:get_it/get_it.dart';
import 'package:fox_link_app/modules/auth/infra/datasources/auth_remote_datasource.dart';
import 'package:fox_link_app/modules/auth/infra/repositories/auth_repository_impl.dart';
import 'package:fox_link_app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:fox_link_app/modules/users/infra/datasources/user_remote_datasource.dart';
import 'package:fox_link_app/modules/tenant/infra/datasources/tenant_remote_datasource.dart';
import 'package:fox_link_app/modules/services/infra/datasources/service_remote_datasource.dart';
import 'package:fox_link_app/core/session/tenant_session.dart';
import 'package:fox_link_app/modules/professionals/infra/datasources/professional_remote_datasource.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(),
  );

  getIt.registerLazySingleton<ServiceRemoteDataSource>(
        () => ServiceRemoteDataSource(),
  );

  getIt.registerLazySingleton<ProfessionalRemoteDataSource>(
        () => ProfessionalRemoteDataSource(),
  );

  getIt.registerLazySingleton<TenantSession>(
        () => TenantSession(),
  );

  getIt.registerLazySingleton<TenantRemoteDataSource>(
        () => TenantRemoteDataSource(),
  );

  getIt.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSource(),
  );

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt()),
  );
}