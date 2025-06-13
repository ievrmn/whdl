import 'package:flutter/material.dart';

// موديل العضو
class Member {
  final String id;
  final String name;
  bool isMuted;
  bool isAdmin;

  Member({
    required this.id,
    required this.name,
    this.isMuted = false,
    this.isAdmin = false,
  });
}

class AdminFeaturesScreen extends StatefulWidget {
  final String roomId;
  final String adminId; // ايدي المشرف نفسه

  AdminFeaturesScreen({required this.roomId, required this.adminId});

  @override
  _AdminFeaturesScreenState createState() => _AdminFeaturesScreenState();
}

class _AdminFeaturesScreenState extends State<AdminFeaturesScreen> {
  // قائمة الأعضاء داخل الروم (ممكن تجلبها من API أو قاعدة بيانات)
  List<Member> members = [
    Member(id: '1', name: 'أحمد'),
    Member(id: '2', name: 'سارة'),
    Member(id: '3', name: 'محمد', isAdmin: true),
    Member(id: '4', name: 'هالة'),
  ];

  // حظر الأعضاء في روم معين (قائمة الأعضاء الممنوعين)
  List<String> bannedMemberIds = [];

  // تغيير حالة المايك (قفل/فتح)
  void toggleMute(Member member) {
    if (member.id == widget.adminId) return; // لا يمكن تعديل نفسك
    setState(() {
      member.isMuted = !member.isMuted;
    });
    // هنا ترسل طلب تحديث للمخدم (API/Firebase)
  }

  // رفع أو تنزيل مشرف
  void toggleAdmin(Member member) {
    if (member.id == widget.adminId) return; // لا يمكن تعديل نفسك
    setState(() {
      member.isAdmin = !member.isAdmin;
    });
    // هنا ترسل طلب تحديث للمخدم
  }

  // طرد عضو
  void kickMember(Member member) {
    if (member.id == widget.adminId) return;
    setState(() {
      members.removeWhere((m) => m.id == member.id);
    });
    // طلب طرد العضو من المخدم
  }

  // حظر عضو (وإضافة ID إلى bannedMemberIds)
  void banMember(Member member) {
    if (member.id == widget.adminId) return;
    setState(() {
      bannedMemberIds.add(member.id);
      members.removeWhere((m) => m.id == member.id);
    });
    // طلب حظر العضو من المخدم
  }

  // إلغاء حظر عضو (من القائمة المحظورة)
  void unbanMember(String memberId) {
    setState(() {
      bannedMemberIds.remove(memberId);
    });
    // طلب إلغاء الحظر من المخدم
  }

  // إرسال تحذير/إبلاغ
  void sendWarning(Member member) {
    // اكتب هنا الكود لإرسال تحذير للعضو، أو تسجيل الإبلاغ في النظام
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إرسال تحذير إلى ${member.name}')),
    );
  }

  // واجهة عرض الأعضاء
  Widget buildMemberItem(Member member) {
    bool isYou = member.id == widget.adminId;

    return ListTile(
      leading: CircleAvatar(child: Text(member.name[0])),
      title: Text(member.name + (isYou ? " (أنت)" : "")),
      subtitle: Text(member.isAdmin ? 'مشرف' : 'عضو'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              member.isMuted ? Icons.mic_off : Icons.mic,
              color: member.isMuted ? Colors.red : Colors.green,
            ),
            tooltip: member.isMuted ? 'فتح المايك' : 'قفل المايك',
            onPressed: isYou ? null : () => toggleMute(member),
          ),
          IconButton(
            icon: Icon(
              member.isAdmin ? Icons.star : Icons.star_border,
              color: member.isAdmin ? Colors.orange : Colors.grey,
            ),
            tooltip: member.isAdmin ? 'تنزيل مشرف' : 'رفع مشرف',
            onPressed: isYou ? null : () => toggleAdmin(member),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle, color: Colors.red),
            tooltip: 'طرد العضو',
            onPressed: isYou
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('تأكيد الطرد'),
                        content: Text('هل تريد طرد ${member.name}؟'),
                        actions: [
                          TextButton(
                            child: Text('إلغاء'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                            child: Text('طرد'),
                            onPressed: () {
                              kickMember(member);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  },
          ),
          IconButton(
            icon: Icon(Icons.block, color: Colors.deepOrange),
            tooltip: 'حظر العضو',
            onPressed: isYou
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('تأكيد الحظر'),
                        content: Text('هل تريد حظر ${member.name} من الروم؟'),
                        actions: [
                          TextButton(
                            child: Text('إلغاء'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                            child: Text('حظر'),
                            onPressed: () {
                              banMember(member);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  },
          ),
          IconButton(
            icon: Icon(Icons.report, color: Colors.purple),
            tooltip: 'إرسال تحذير',
            onPressed: isYou ? null : () => sendWarning(member),
          ),
        ],
      ),
    );
  }

  // واجهة عرض المحظورين
  Widget buildBannedList() {
    return ListView.builder(
      itemCount: bannedMemberIds.length,
      itemBuilder: (context, index) {
        String bannedId = bannedMemberIds[index];
        return ListTile(
          leading: Icon(Icons.block, color: Colors.red),
          title: Text('عضو محظور (ID: $bannedId)'),
          trailing: ElevatedButton(
            child: Text('إلغاء الحظر'),
            onPressed: () => unbanMember(bannedId),
          ),
        );
      },
    );
  }

  // قائمة التبديل بين الأعضاء والمحظورين
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة تحكم المشرف'),
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
          tabs: [
            Tab(text: 'الأعضاء (${members.length})'),
            Tab(text: 'المحظورون (${bannedMemberIds.length})'),
          ],
          controller: TabController(length: 2, vsync: ScaffoldState()),
        ),
      ),
      body: _selectedTab == 0 ? _buildMembersList() : buildBannedList(),
    );
  }

  Widget _buildMembersList() {
    if (members.isEmpty) {
      return Center(child: Text('لا يوجد أعضاء في الروم'));
    }
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) => buildMemberItem(members[index]),
    );
  }
}