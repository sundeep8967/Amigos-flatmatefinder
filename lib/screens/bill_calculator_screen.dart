import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BillCalculatorScreen extends StatefulWidget {
  const BillCalculatorScreen({super.key});

  @override
  State<BillCalculatorScreen> createState() => _BillCalculatorScreenState();
}

class _BillCalculatorScreenState extends State<BillCalculatorScreen> {
  final _rentController = TextEditingController();
  final _electricityController = TextEditingController();
  final _waterController = TextEditingController();
  final _internetController = TextEditingController();
  final _gasController = TextEditingController();
  final _maintenanceController = TextEditingController();
  final _otherController = TextEditingController();
  
  int _numberOfPeople = 2;
  final List<String> _peopleNames = ['Person 1', 'Person 2'];
  final Map<String, double> _customSplits = {};

  @override
  void dispose() {
    _rentController.dispose();
    _electricityController.dispose();
    _waterController.dispose();
    _internetController.dispose();
    _gasController.dispose();
    _maintenanceController.dispose();
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Bill Calculator'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareBillSplit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calculate, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Split Bills Fairly',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Calculate how much each person owes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Number of People
            _buildSectionTitle('Number of People'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.people, color: Colors.green),
                    const SizedBox(width: 12),
                    const Text('People sharing bills:'),
                    const Spacer(),
                    IconButton(
                      onPressed: _numberOfPeople > 2 ? _decreasePeople : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$_numberOfPeople',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _numberOfPeople < 10 ? _increasePeople : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // People Names
            _buildSectionTitle('People Names'),
            ..._buildPeopleNameFields(),
            
            const SizedBox(height: 24),
            
            // Bill Categories
            _buildSectionTitle('Monthly Bills'),
            _buildBillField('Rent', _rentController, Icons.home),
            _buildBillField('Electricity', _electricityController, Icons.electrical_services),
            _buildBillField('Water', _waterController, Icons.water_drop),
            _buildBillField('Internet', _internetController, Icons.wifi),
            _buildBillField('Gas', _gasController, Icons.local_gas_station),
            _buildBillField('Maintenance', _maintenanceController, Icons.build),
            _buildBillField('Other', _otherController, Icons.more_horiz),
            
            const SizedBox(height: 24),
            
            // Calculation Results
            _buildCalculationResults(),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _shareBillSplit,
                    icon: const Icon(Icons.share),
                    label: const Text('Share Split'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Widget> _buildPeopleNameFields() {
    return List.generate(_numberOfPeople, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          initialValue: _peopleNames[index],
          decoration: InputDecoration(
            labelText: 'Person ${index + 1} Name',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            if (index < _peopleNames.length) {
              _peopleNames[index] = value.isEmpty ? 'Person ${index + 1}' : value;
            }
          },
        ),
      );
    });
  }

  Widget _buildBillField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green.shade600),
          prefixText: 'Rs. ',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildCalculationResults() {
    final totalBill = _calculateTotalBill();
    final perPersonAmount = totalBill / _numberOfPeople;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt, color: Colors.green.shade600, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Bill Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Total Bill
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Monthly Bill:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Rs. ${totalBill.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Per Person Amount
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Per Person (Equal Split):',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Rs. ${perPersonAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Individual Breakdown
            const Text(
              'Individual Breakdown:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            ...List.generate(_numberOfPeople, (index) {
              final name = index < _peopleNames.length ? _peopleNames[index] : 'Person ${index + 1}';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Rs. ${perPersonAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
            
            if (totalBill > 0) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              
              // Bill Breakdown
              const Text(
                'Bill Breakdown:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              ..._buildBillBreakdown(),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBillBreakdown() {
    final bills = [
      ('Rent', _rentController.text),
      ('Electricity', _electricityController.text),
      ('Water', _waterController.text),
      ('Internet', _internetController.text),
      ('Gas', _gasController.text),
      ('Maintenance', _maintenanceController.text),
      ('Other', _otherController.text),
    ];

    return bills
        .where((bill) => bill.$2.isNotEmpty && double.tryParse(bill.$2) != null && double.parse(bill.$2) > 0)
        .map((bill) {
      final amount = double.parse(bill.$2);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bill.$1,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Rs. ${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  double _calculateTotalBill() {
    double total = 0;
    
    final controllers = [
      _rentController,
      _electricityController,
      _waterController,
      _internetController,
      _gasController,
      _maintenanceController,
      _otherController,
    ];
    
    for (final controller in controllers) {
      final value = double.tryParse(controller.text) ?? 0;
      total += value;
    }
    
    return total;
  }

  void _increasePeople() {
    if (_numberOfPeople < 10) {
      setState(() {
        _numberOfPeople++;
        _peopleNames.add('Person $_numberOfPeople');
      });
    }
  }

  void _decreasePeople() {
    if (_numberOfPeople > 2) {
      setState(() {
        _numberOfPeople--;
        if (_peopleNames.length > _numberOfPeople) {
          _peopleNames.removeLast();
        }
      });
    }
  }

  void _clearAll() {
    setState(() {
      _rentController.clear();
      _electricityController.clear();
      _waterController.clear();
      _internetController.clear();
      _gasController.clear();
      _maintenanceController.clear();
      _otherController.clear();
      _numberOfPeople = 2;
      _peopleNames.clear();
      _peopleNames.addAll(['Person 1', 'Person 2']);
      _customSplits.clear();
    });
  }

  void _shareBillSplit() {
    final totalBill = _calculateTotalBill();
    final perPersonAmount = totalBill / _numberOfPeople;
    
    if (totalBill == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some bill amounts first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final shareText = '''
🏠 Monthly Bill Split

💰 Total Bill: Rs. ${totalBill.toStringAsFixed(2)}
👥 Split among $_numberOfPeople people
💵 Per Person: Rs. ${perPersonAmount.toStringAsFixed(2)}

📋 Breakdown:
${_peopleNames.map((name) => '• $name: Rs. ${perPersonAmount.toStringAsFixed(2)}').join('\n')}

📱 Calculated with FlatmateFinder
''';

    // In a real app, you would use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Bill split copied to clipboard!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Bill Split Summary'),
                content: SingleChildScrollView(
                  child: Text(shareText),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    
    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: shareText));
  }
}