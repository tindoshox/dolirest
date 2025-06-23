import 'package:objectbox/objectbox.dart';

//final customers = parseCustomersFromJson(jsonResponse);

@Entity()
class CustomerEntity {
  @Id(assignable: true)
  int id = 0;
  @Index(type: IndexType.value)
  @Unique(onConflict: ConflictStrategy.replace)
  String customerId;
  String stateId;
  String regionId;
  @Index(type: IndexType.value)
  String name;
  int dateModification;
  String phone;
  String fax;
  String codeClient;
  @Index(type: IndexType.value)
  String address;
  @Index(type: IndexType.value)
  String town;
  String client;
  CustomerEntity({
    this.customerId = '',
    this.stateId = '',
    this.regionId = '',
    this.name = '',
    this.dateModification = 0,
    this.phone = '',
    this.fax = '',
    this.codeClient = '',
    this.address = '',
    this.town = '',
    this.client = '1',
  });
}

List<CustomerEntity> parseCustomerListFromJson(List<dynamic> jsonList) {
  return jsonList.map((customerJson) {
    final CustomerEntity customer = CustomerEntity(
      customerId: customerJson["id"] ?? '',
      stateId: customerJson["state_id"] ?? '',
      regionId: customerJson["region_id"] ?? '',
      name: customerJson["name"] ?? '',
      dateModification: customerJson["date_modification"] ?? '',
      phone: customerJson["phone"] ?? '',
      fax: customerJson["fax"] ?? '',
      codeClient: customerJson["code_client"] ?? '',
      address: customerJson["address"] ?? '',
      town: customerJson["town"] ?? '',
      client: customerJson["client"] ?? '',
    );
    return customer;
  }).toList();
}

CustomerEntity parseCustomerFromJson(Map<String, dynamic> customerJson) {
  final CustomerEntity customer = CustomerEntity(
    customerId: customerJson["id"] ?? '',
    stateId: customerJson["state_id"] ?? '',
    regionId: customerJson["region_id"] ?? '',
    name: customerJson["name"] ?? '',
    dateModification: customerJson["date_modification"] ?? '',
    phone: customerJson["phone"] ?? '',
    fax: customerJson["fax"] ?? '',
    codeClient: customerJson["code_client"] ?? '',
    address: customerJson["address"] ?? '',
    town: customerJson["town"] ?? '',
    client: customerJson["client"] ?? '',
  );
  return customer;
}
