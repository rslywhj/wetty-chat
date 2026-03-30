import 'group_member_api_service.dart';
import 'group_member_models.dart';

class GroupMemberRepository {
  GroupMemberRepository({GroupMemberApiService? apiService})
    : _apiService = apiService ?? GroupMemberApiService();

  final GroupMemberApiService _apiService;

  Future<List<GroupMember>> fetchMembers(String chatId) {
    return _apiService.fetchMembers(chatId);
  }
}
