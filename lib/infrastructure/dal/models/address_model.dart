import 'package:hive_ce_flutter/hive_flutter.dart';

part 'address_model.g.dart';

@HiveType(typeId: 12)
class AddressModel {
  @HiveField(1)
  final String town;
  @HiveField(2)
  final String address;
  const AddressModel({
    required this.town,
    required this.address,
  });
}
