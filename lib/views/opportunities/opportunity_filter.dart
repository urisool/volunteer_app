// views/opportunity/opportunity_filter.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/opportunity_provider.dart';

class OpportunityFilterScreen extends StatefulWidget {
  const OpportunityFilterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OpportunityFilterScreenState createState() => _OpportunityFilterScreenState();
}

class _OpportunityFilterScreenState extends State<OpportunityFilterScreen> {
  String _selectedLocation = 'الكل';
  final List<String> _selectedSkills = [];

  @override
  Widget build(BuildContext context) {
    final provider = context.read<OpportunityProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text('تصفية الفرص')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              items: ['الكل', 'الرياض', 'جدة'].map((location) => 
                DropdownMenuItem(value: location, child: Text(location))
              ).toList(),
              onChanged: (value) => setState(() => _selectedLocation = value!),
            ),
            SizedBox(height: 20),
            Text('المهارات المطلوبة:', style: TextStyle(fontSize: 16)),
            ...provider.allSkills.map((skill) => CheckboxListTile(
              title: Text(skill),
              value: _selectedSkills.contains(skill),
              onChanged: (value) => setState(() {
                value! 
                  ? _selectedSkills.add(skill)
                  : _selectedSkills.remove(skill);
              }),
            )),
            Spacer(),
            ElevatedButton(
              child: Text('تطبيق الفلترة'),
              onPressed: () {
                provider.applyFilters(
                  location: _selectedLocation,
                  skills: _selectedSkills,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}