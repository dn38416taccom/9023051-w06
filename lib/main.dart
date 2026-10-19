import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudentFormPage(),
    );
  }
}

class StudentFormPage extends StatefulWidget {
  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _studentIdController = TextEditingController();
  final _nameController = TextEditingController();

  String? _selectedBranch;
  int? _selectedYear;

  final List<String> _branches = ['CS', 'IT', 'GI'];
  final List<int> _years = [1, 2, 3];

  @override
  void dispose() {
    _studentIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('ข้อมูลที่กรอก'),
          content: Text(
            'รหัสนักศึกษา: ${_studentIdController.text}\n'
            'ชื่อ-นามสกุล: ${_nameController.text}\n'
            'สาขา: $_selectedBranch\n'
            'ชั้นปี: $_selectedYear',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ตกลง'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลนักศึกษา'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // รหัสนักศึกษา
              TextFormField(
                controller: _studentIdController,
                decoration: InputDecoration(
                  labelText: 'รหัสนักศึกษา',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรหัสนักศึกษา';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // ชื่อจริง-นามสกุล
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อจริง-นามสกุล',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อจริง-นามสกุล';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // สาขา
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'สาขา',
                ),
                value: _selectedBranch,
                items: _branches.map((branch) {
                  return DropdownMenuItem(
                    value: branch,
                    child: Text(branch),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBranch = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'กรุณาเลือกสาขา';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // ชั้นปี โดยใช้ FormField เพื่อให้ validate ได้
              FormField<int>(
                initialValue: _selectedYear,
                validator: (value) {
                  if (value == null) {
                    return 'กรุณาเลือกชั้นปี';
                  }
                  return null;
                },
                builder: (FormFieldState<int> state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชั้นปี'),
                      Row(
                        children: _years.map((year) {
                          return Row(
                            children: [
                              Radio<int>(
                                value: year,
                                groupValue: state.value,
                                onChanged: (value) {
                                  state.didChange(value);
                                  setState(() {
                                    _selectedYear = value;
                                  });
                                },
                              ),
                              Text('ปี $year'),
                              SizedBox(width: 8),
                            ],
                          );
                        }).toList(),
                      ),
                      if (state.hasError)
                        Text(
                          state.errorText!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                    ],
                  );
                },
              ),

              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
