import 'package:objectbox/objectbox.dart';

//final customers = parseCustomersFromJson(jsonResponse);

@Entity()
class CustomerEntity {
  @Id(assignable: true)
  int id;
  @Index(type: IndexType.value)
  @Unique(onConflict: ConflictStrategy.replace)
  String? customerId;
  String? stateId;
  String? regionId;
  @Index(type: IndexType.value)
  String? name;
  int? dateModification;
  String? phone;
  String? fax;
  String? codeClient;
  @Index(type: IndexType.value)
  String? address;
  @Index(type: IndexType.value)
  String? town;
  String? client;
  CustomerEntity({
    this.id = 0,
    this.customerId,
    this.stateId,
    this.regionId,
    this.name,
    this.dateModification,
    this.phone,
    this.fax,
    this.codeClient,
    this.address,
    this.town,
    this.client,
  });
}

List<CustomerEntity> parseCustomersFromJson(List<dynamic> jsonList) {
  return jsonList.map((customerJson) {
    final CustomerEntity customer = CustomerEntity(
      customerId: customerJson["id"],
      stateId: customerJson["state_id"] is int
          ? customerJson["state_id"].toString()
          : customerJson["state_id"],
      regionId: customerJson["region_id"] is int
          ? customerJson["region_id"].toString()
          : customerJson["region_id"],
      name: customerJson["name"],
      dateModification: customerJson["date_modification"],
      phone: customerJson["phone"],
      fax: customerJson["fax"],
      codeClient: customerJson["code_client"],
      address: customerJson["address"],
      town: customerJson["town"],
      client: customerJson["client"],
    );
    return customer;
  }).toList();
}
