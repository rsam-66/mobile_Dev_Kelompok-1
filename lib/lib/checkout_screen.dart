import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CheckoutScreen extends StatefulWidget {
  final String productType;
  final int productId;
  final int quantity;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.productType,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String _shippingMethod = 'Private person';
  String _paymentMethod = 'cash';
  bool _isLoading = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidInitialize = AndroidInitializationSettings('app_icon');
    const iOSInitialize = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOSDetails = DarwinNotificationDetails();
    const generalNotificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Order Confirmation',
      'Pesanan berhasil dibuat',
      generalNotificationDetails,
    );
  }

  Future<void> _createOrder(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create order directly - the API will handle stock checking and updating
      final response = await http.post(
        Uri.parse('http://localhost:3000/orders'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'productType': widget.productType, // 'barang' or 'pohon'
          'productId': widget.productId,
          'quantity': widget.quantity,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'shippingMethod': _shippingMethod,
          'paymentMethod': _paymentMethod,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (context.mounted) {
          await _showNotification();
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(responseData['message'] ?? 'Pesanan berhasil dibuat'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['error'] ?? 'Failed to create order');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception:', '')),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: ${widget.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                focusNode: _firstNameFocus,
                autofocus: false,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_lastNameFocus);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                focusNode: _lastNameFocus,
                autofocus: false,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocus);
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _shippingMethod,
                decoration: const InputDecoration(
                  labelText: 'Shipping',
                  border: OutlineInputBorder(),
                ),
                items: ['Private person'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    await Future.delayed(Duration.zero);
                    if (mounted) {
                      setState(() => _shippingMethod = newValue);
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                autofocus: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: ['cash', 'credit_card', 'bank_transfer']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.replaceAll('_', ' ').toUpperCase()),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    await Future.delayed(Duration.zero);
                    if (mounted) {
                      setState(() => _paymentMethod = newValue);
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _createOrder(context),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
