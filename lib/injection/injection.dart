import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fox_link_app/core/session/tenant_session.dart';

import 'package:fox_link_app/modules/auth/infra/datasources/auth_remote_datasource.dart';
import 'package:fox_link_app/modules/auth/infra/repositories/auth_repository_impl.dart';
import 'package:fox_link_app/modules/auth/domain/repositories/auth_repository.dart';

import 'package:fox_link_app/modules/users/infra/datasources/user_remote_datasource.dart';
import 'package:fox_link_app/modules/tenant/infra/datasources/tenant_remote_datasource.dart';
import 'package:fox_link_app/modules/services/infra/datasources/service_remote_datasource.dart';
import 'package:fox_link_app/modules/professionals/infra/datasources/professional_remote_datasource.dart';

import 'package:fox_link_app/modules/scheduling/domain/repositories/scheduling_repository.dart';
import 'package:fox_link_app/modules/scheduling/domain/usecases/create_appointment_usecase.dart';
import 'package:fox_link_app/modules/scheduling/infra/repositories/scheduling_repository_impl.dart';

import 'package:fox_link_app/modules/availability/domain/repositories/availability_repository.dart';
import 'package:fox_link_app/modules/availability/infra/repositories/availability_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {

  /// 🔥 1️⃣ FIRESTORE PRIMEIRO
  getIt.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  /// 🔥 2️⃣ AVAILABILITY
  getIt.registerLazySingleton<AvailabilityRepository>(
        () => AvailabilityRepositoryImpl(getIt()),
  );

  /// 🔥 3️⃣ SCHEDULING
  getIt.registerLazySingleton<SchedulingRepository>(
        () => SchedulingRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<CreateAppointmentUseCase>(
        () => CreateAppointmentUseCase(getIt()),
  );

  /// 🔥 4️⃣ AUTH
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(),
  );

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt()),
  );

  /// 🔥 5️⃣ USERS / TENANT
  getIt.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSource(),
  );

  getIt.registerLazySingleton<TenantRemoteDataSource>(
        () => TenantRemoteDataSource(),
  );

  getIt.registerLazySingleton<TenantSession>(
        () => TenantSession(),
  );

  /// 🔥 6️⃣ SERVICES
  getIt.registerLazySingleton<ServiceRemoteDataSource>(
        () => ServiceRemoteDataSource(),
  );

  getIt.registerLazySingleton<ProfessionalRemoteDataSource>(
        () => ProfessionalRemoteDataSource(),
  );
}