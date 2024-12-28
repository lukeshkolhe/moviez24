import 'package:moviez24/app/base/services/local/local_storage_util.dart';

abstract class BaseLocalService {
  final LocalStorageUtil localStorageUtil = SecureStorageUtil();
}