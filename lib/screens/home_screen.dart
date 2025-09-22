import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cagnotte_app/screens/pay_merchant_screen.dart';
import 'package:cagnotte_app/widgets/horizontal_spacer.dart';
import 'package:cagnotte_app/widgets/vertical_spacer.dart';
import '../services/api_service.dart';

enum PointsTransactionType { earn, spend }

class PointsTransaction {
  final String merchantName;
  final String dateTime;
  final double points;
  final PointsTransactionType type;

  PointsTransaction({
    required this.merchantName,
    required this.dateTime,
    required this.points,
    required this.type,
  });
}

class HomeScreen extends StatefulWidget {
  final int customerId; // ID client à passer à l'écran de paiement
  const HomeScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PointsTransaction> transactions = [];
  double totalPoints = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    try {
      final customerData = await ApiService.getCustomer(widget.customerId);
      setState(() {
        totalPoints = (customerData['points'] ?? 0).toDouble();
        transactions = (customerData['transactions'] as List<dynamic>?)
                ?.map((tx) => PointsTransaction(
                      merchantName: tx['merchantName'],
                      dateTime: tx['dateTime'],
                      points: (tx['points'] as num).toDouble(),
                      type: tx['type'] == 'earn'
                          ? PointsTransactionType.earn
                          : PointsTransactionType.spend,
                    ))
                .toList() ??
            [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur chargement: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER
          SizedBox(
            height: 262.h,
            width: double.infinity,
            child: Stack(
              children: [
                Container(height: 262.h, width: double.infinity, color: Theme.of(context).colorScheme.primary),
                CustomPaint(size: Size(double.infinity, 262.h), painter: DrawTriangleShape()),
                Positioned(
                  top: 48.h,
                  left: 30.w,
                  right: 30.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Dashboard", style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500)),
                      CircleAvatar(radius: 20.w, backgroundImage: const AssetImage("assets/images/Profile Picture.png")),
                    ],
                  ),
                ),
                Positioned(top: 120.h, left: 30.w, child: Text("Hi, Amanda!", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16.sp, fontWeight: FontWeight.w500))),
                Positioned(top: 152.h, left: 30.w, child: Text("Total Points", style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500))),
                Positioned(
                  top: 190.h,
                  left: 30.w,
                  right: 30.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${totalPoints.toStringAsFixed(2)} pts", style: TextStyle(color: Colors.white, fontSize: 40.sp, fontWeight: FontWeight.w600)),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(width: 24.w, height: 24.h, child: FittedBox(child: SvgPicture.asset("assets/images/notifications_icon.svg"), fit: BoxFit.fill)),
                          Positioned(
                            right: 3.07.w,
                            top: -4.h,
                            child: Container(height: 10.h, width: 10.w, decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, shape: BoxShape.circle)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalSpacer(height: 32),

          // ACTION BUTTONS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionButton(
                  context,
                  iconWidget: SvgPicture.asset("assets/images/send_icon.svg"),
                  label: "Payer un marchand",
                  color: Theme.of(context).colorScheme.secondary,
                  onTap: () async {
                    final newTransaction = await Navigator.push<PointsTransaction>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PayMerchantScreen(customerId: widget.customerId),
                      ),
                    );

                    if (newTransaction != null) {
                      setState(() {
                        transactions.insert(0, newTransaction);
                        totalPoints += newTransaction.points;
                      });
                    }
                  },
                ),
                _actionButton(
                  context,
                  iconWidget: const Icon(Icons.videogame_asset, color: Colors.white),
                  label: "Jouer",
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MiniGameScreen()));
                  },
                ),
              ],
            ),
          ),
          const VerticalSpacer(height: 32),

          // HISTORIQUE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Historique des points", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp)),
                InkWell(
                  onTap: () {},
                  child: Text("Voir tout", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
          ),
          const VerticalSpacer(height: 16),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const VerticalSpacer(height: 16),
                itemBuilder: (context, index) => _transactionCard(transactions[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required Widget iconWidget,
    required String label,
    required Color color,
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 49.h,
        width: 165.w,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10.w)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 21.w, height: 21.h, child: FittedBox(child: iconWidget, fit: BoxFit.fill)),
            const HorizontalSpacer(width: 4),
            Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _transactionCard(PointsTransaction tx) {
    return SizedBox(
      height: 49.h,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.w,
            backgroundColor: const Color(0xFFF3F4F5),
            child: Text(tx.merchantName[0], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp, color: Colors.black)),
          ),
          const HorizontalSpacer(width: 17),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tx.merchantName, style: TextStyle(fontSize: 14.sp, color: Colors.black)),
              const VerticalSpacer(height: 1),
              Text(tx.dateTime, style: TextStyle(fontSize: 12.sp, color: Colors.black.withOpacity(0.4))),
            ],
          ),
          const Spacer(),
          Text(
            tx.type == PointsTransactionType.earn ? "+${tx.points.toStringAsFixed(2)} pts" : "-${tx.points.toStringAsFixed(2)} pts",
            style: TextStyle(color: tx.type == PointsTransactionType.earn ? Colors.green : Colors.red, fontSize: 16.sp, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class DrawTriangleShape extends CustomPainter {
  final Paint painter = Paint()..color = const Color(0xFF3491DB)..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MiniGameScreen extends StatelessWidget {
  const MiniGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mini-Jeu")),
      body: Center(
        child: Text("Ici sera le mini-jeu ! 🎮", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
