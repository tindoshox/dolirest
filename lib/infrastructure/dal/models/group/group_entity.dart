import 'package:objectbox/objectbox.dart';

@Entity()
class GroupEntity {
  @Id()
  int id = 0;
  @Unique(onConflict: ConflictStrategy.replace)
  String? groupId;
  @Index()
  String? name;

  GroupEntity({
    this.groupId,
    this.name,
  });
}

List<GroupEntity> parseGroupsFromJson(List<dynamic> jsonList) {
  return jsonList.map((groupJson) {
    final GroupEntity group = GroupEntity(
      groupId: groupJson['id'],
      name: groupJson['name'],
    );
    return group;
  }).toList();
}
