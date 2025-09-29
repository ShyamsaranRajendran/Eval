import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BatchesScreen extends StatefulWidget {
  @override
  _BatchesScreenState createState() => _BatchesScreenState();
}

class _BatchesScreenState extends State<BatchesScreen> {
  List batches = [];
  List mentors = [];
  List students = [];
  List projects = [];

  final String baseUrl = "http://localhost:3000";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final resBatches = await http.get(Uri.parse("$baseUrl/batches"));
    final resMentors = await http.get(
      Uri.parse("$baseUrl/users/role/Reviewer"),
    );
    final resStudents = await http.get(
      Uri.parse("$baseUrl/users/role/Student"),
    );
    final resProjects = await http.get(Uri.parse("$baseUrl/projects"));

    if (resBatches.statusCode == 200) batches = json.decode(resBatches.body);
    if (resMentors.statusCode == 200) mentors = json.decode(resMentors.body);
    if (resStudents.statusCode == 200) students = json.decode(resStudents.body);
    if (resProjects.statusCode == 200) projects = json.decode(resProjects.body);

    setState(() {});
  }

  void showAddBatchDialog() {
    TextEditingController batchNameCtrl = TextEditingController();
    TextEditingController deptCtrl = TextEditingController();
    TextEditingController yearCtrl = TextEditingController();

    String? selectedMentor;
    List<Map<String, dynamic>> teams = [];

    // helper to add a team
    void addTeam(void Function(void Function()) refreshParent) {
      TextEditingController teamNameCtrl = TextEditingController();
      String? teamLeader;
      List<String> teamMembers = [];
      String? projectId;
      String status = "Active";

      showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (context, setModalState) => AlertDialog(
            title: Text("Add Team"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: teamNameCtrl,
                    decoration: InputDecoration(labelText: "Team Name"),
                  ),

                  DropdownButtonFormField<String>(
                    value: teamLeader,
                    decoration: InputDecoration(labelText: "Team Leader"),
                    items: students.map<DropdownMenuItem<String>>((s) {
                      return DropdownMenuItem<String>(
                        value: s['_id'] as String,
                        child: Text(s['name'] as String),
                      );
                    }).toList(),
                    onChanged: (val) => setModalState(() => teamLeader = val),
                  ),

                  Wrap(
                    spacing: 6,
                    children: students.map((s) {
                      final selected = teamMembers.contains(s['_id']);
                      return FilterChip(
                        label: Text(s['name']),
                        selected: selected,
                        onSelected: (bool value) {
                          setModalState(() {
                            value
                                ? teamMembers.add(s['_id'])
                                : teamMembers.remove(s['_id']);
                          });
                        },
                      );
                    }).toList(),
                  ),

                  DropdownButtonFormField<String>(
                    value: projectId,
                    decoration: InputDecoration(labelText: "Project"),
                    items: projects.map((p) {
                      return DropdownMenuItem<String>(
                        value: p['_id'] as String,
                        child: Text(p['title'] as String),
                      );
                    }).toList(),
                    onChanged: (val) => setModalState(() => projectId = val),
                  ),

                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: InputDecoration(labelText: "Status"),
                    items: ["Active", "Completed", "Inactive"]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) =>
                        setModalState(() => status = val ?? "Active"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  teams.add({
                    "teamName": teamNameCtrl.text,
                    "teamLeader": teamLeader,
                    "members": teamMembers,
                    "projectId": projectId,
                    "status": status,
                  });
                  refreshParent(() {}); // refresh parent dialog
                  Navigator.pop(context);
                },
                child: Text("Save Team"),
              ),
            ],
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text("Add Batch"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: batchNameCtrl,
                  decoration: InputDecoration(labelText: "Batch Name"),
                ),
                TextField(
                  controller: deptCtrl,
                  decoration: InputDecoration(labelText: "Department"),
                ),
                TextField(
                  controller: yearCtrl,
                  decoration: InputDecoration(labelText: "Year"),
                  keyboardType: TextInputType.number,
                ),

                DropdownButtonFormField<String>(
                  value: selectedMentor,
                  decoration: InputDecoration(labelText: "Mentor"),
                  items: mentors.map<DropdownMenuItem<String>>((m) {
                    return DropdownMenuItem<String>(
                      value: m['_id'] as String,
                      child: Text(m['name'] as String),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setDialogState(() => selectedMentor = val),
                ),

                ElevatedButton.icon(
                  onPressed: () => addTeam(setDialogState),
                  icon: Icon(Icons.group_add),
                  label: Text("Add Team"),
                ),
                SizedBox(height: 10),

                // Show teams summary
                ...teams.map(
                  (t) => ListTile(
                    title: Text(t['teamName']),
                    subtitle: Text(
                      "Leader: ${t['teamLeader']} | Members: ${t['members'].length}",
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await http.post(
                  Uri.parse("$baseUrl/batches"),
                  headers: {"Content-Type": "application/json"},
                  body: json.encode({
                    "batchName": batchNameCtrl.text,
                    "department": deptCtrl.text,
                    "year": int.parse(yearCtrl.text),
                    "mentorId": selectedMentor,
                    "teams": teams,
                  }),
                );
                fetchData();
                Navigator.pop(context);
              },
              child: Text("Save Batch"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Batches")),
      body: ListView.builder(
        itemCount: batches.length,
        itemBuilder: (context, i) {
          final b = batches[i];
          return ExpansionTile(
            title: Text("${b['batchName']} (${b['year']})"),
            subtitle: Text("Dept: ${b['department']}"),
            children: [
              Text("Mentor: ${b['mentorId']['name'] ?? b['mentorId']}"),
              ...b['teams']
                  .map<Widget>(
                    (t) => ListTile(
                      title: Text("Team: ${t['teamName']}"),
                      subtitle: Text(
                        "Leader: ${t['teamLeader']['name'] ?? t['teamLeader']}\n"
                        "Project: ${t['projectId']?['title'] ?? 'N/A'}\n"
                        "Status: ${t['status']}",
                      ),
                    ),
                  )
                  .toList(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddBatchDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
