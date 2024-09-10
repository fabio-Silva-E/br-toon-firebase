import 'package:freezed_annotation/freezed_annotation.dart';

part 'publications_result.freezed.dart';

@freezed
class PublicationsResult<T> with _$PublicationsResult<T> {
  factory PublicationsResult.success(List<T> data) = Success;
  factory PublicationsResult.error(String message) = Error;
}
