import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cagnotte_app/widgets/primary_button.dart';
import 'package:cagnotte_app/widgets/vertical_spacer.dart';
import '../services/api_service.dart';
import '../screens/home_screen.dart'; // Pour PointsTransactionType

class PayMerchantScreen extends StatefulWidget {
  final int customerId; // ID du client pour l'API

  const PayMerchantScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  State<PayMerchantScreen> createState() => _PayMerchantScreenState();
}

class _PayMerchantScreenState extends State<PayMerchantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final double amount = double.parse(_amountController.text);
    final String merchant = _merchantController.text.trim();

    setState(() => _isLoading = true);

    try {
      final paymentResponse = await ApiService.createPayment(
        widget.customerId,
        amount,
        merchant,
      );

      // Points gagnés
      final double pointsEarned = amount;

      final now = DateTime.now();
      final newTransaction = PointsTransaction(
        merchantName: merchant,
        dateTime:
            "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}",
        points: pointsEarned,
        type: PointsTransactionType.earn,
      );

      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200.w,
                    height: 150.h,
                    child: FittedBox(
                      child: SvgPicture.asset('assets/images/sent_illustration.svg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  const VerticalSpacer(height: 20),
                  Text(
                    "Paiement effectué avec succès !",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const VerticalSpacer(height: 10),
                  Text(
                    "Vous avez gagné ${pointsEarned.toStringAsFixed(0)} points",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const VerticalSpacer(height: 20),
                  PrimaryButton(
                    text: "Ok",
                    onPressed: () {
                      Navigator.pop(context); // ferme le dialog
                      Navigator.pop(context, newTransaction); // renvoie transaction au HomeScreen
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/back_icon.svg'),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payer un marchand",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nom du marchand",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
              const VerticalSpacer(height: 8),
              TextFormField(
                controller: _merchantController,
                validator: (value) =>
                    value == null || value.isEmpty ? "Champ obligatoire" : null,
                decoration: InputDecoration(
                  hintText: "Entrez le nom du marchand",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w)),
                ),
              ),
              const VerticalSpacer(height: 20),
              Text("Montant (€)",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
              const VerticalSpacer(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Champ obligatoire";
                  if (double.tryParse(value) == null) return "Montant invalide";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Entrez le montant",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w)),
                ),
              ),
              const VerticalSpacer(height: 20),
              Text("Note (facultatif)",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
              const VerticalSpacer(height: 8),
              TextFormField(
                controller: _noteController,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Ajouter une note",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w)),
                ),
              ),
              const VerticalSpacer(height: 40),
              Center(
                child: PrimaryButton(
                  text: _isLoading ? "Paiement..." : "Payer",
                  onPressed: _isLoading ? null : _submitPayment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
