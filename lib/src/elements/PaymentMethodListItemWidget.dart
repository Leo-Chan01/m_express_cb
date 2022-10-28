import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_paystack_payment/flutter_paystack_payment.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/checkout_controller.dart';
import '../helpers/custom_trace.dart';
import '../models/payment_method.dart';

// ignore: must_be_immutable
class PaymentMethodListItemWidget extends StatefulWidget {
  PaymentMethod paymentMethod;
  CheckoutController _con;


  PaymentMethodListItemWidget({Key key, this.paymentMethod}) : super(key: key);

  @override
  _PaymentMethodListItemWidgetState createState() =>
      _PaymentMethodListItemWidgetState();
}

class _PaymentMethodListItemWidgetState
    extends StateMVC<PaymentMethodListItemWidget> {
  CheckoutController _con;

  _PaymentMethodListItemWidgetState() : super(CheckoutController()) {
    _con = controller;
  }
  @override
  void initState() {
    plugin.initialize(publicKey: publicKey);
    super.initState();
  }

  String heroTag;

  var publicKey = 'pk_test_2442c1c75c79a8cbd1fdd8cba558a68ea1dd8524';

  //
  final plugin = PaystackPayment();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary,
      focusColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {

        Navigator.of(context).pushNamed(widget.paymentMethod.route);
        // if (widget.paymentMethod.id == 'flutterwave') {
        //
        //   _con.chargeCard(context);
        //
        //   // _chargeCard();r
        // }else{
        //   Navigator.of(context).pushNamed(widget.paymentMethod.route);
        //
        // }
        log(widget.paymentMethod.route);
        print(CustomTrace(StackTrace.current,
            message: this.widget.paymentMethod.name));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                    image: AssetImage(widget.paymentMethod.logo),
                    fit: BoxFit.fill),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.paymentMethod.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          widget.paymentMethod.description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).focusColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // _makePayment(BuildContext context) async {
  //   final style = FlutterwaveStyle(
  //       appBarText: "Checkout with Flutterwave",
  //       appBarTitleTextStyle: TextStyle(color: Colors.white),
  //       buttonColor: Colors.black,
  //       appBarIcon: Icon(Icons.message, color: Colors.white),
  //       buttonText: 'Continue',
  //       buttonTextStyle: TextStyle(
  //           color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
  //       appBarColor: Colors.black,
  //       dialogCancelTextStyle: TextStyle(color: Colors.redAccent, fontSize: 18),
  //       dialogContinueTextStyle: TextStyle(color: Colors.black, fontSize: 18));
  //
  //   final Customer customer = Customer(
  //       name: "Mez Express User",
  //       phoneNumber: "1234566677777",
  //       email: "customer@customer.com");
  //
  //   final Flutterwave flutterwave = Flutterwave(
  //       context: context,
  //       style: style,
  //       publicKey: "FLWPUBK_TEST-46d2d918ac29137f8a911db6814da801-X",
  //       currency: "NGN",
  //       redirectUrl: "my_redirect_url",
  //       txRef: DateTime.now().toString(),
  //       amount: "3000",
  //       customer: customer,
  //       paymentOptions: "ussd, card, barter, payattitude",
  //       customization: Customization(title: "Test Payment"),
  //       isTestMode: true);
  //   final ChargeResponse response = await flutterwave.charge();
  //   if (response != null) {
  //     print(response.toJson());
  //     if (response.success) {
  //       // Call the verify transaction endpoint with the transactionID returned in `response.transactionId` to verify transaction before offering value to customer
  //     } else {
  //       // Transaction not successful
  //     }
  //   } else {
  //     // User cancelled
  //   }
  // }
  // PaymentCard _getCardFromUI() {
  //   // Using just the must-required parameters.
  //   // return PaymentCard(
  //   //   number: cardNumber,
  //   //   cvc: cvv,
  //   //   expiryMonth: expiryMonth,
  //   //   expiryYear: expiryYear,
  //   // );
  // }
  //
  _chargeCard() async {
    double total =_con.total;


    log('TOTAL : ${_con.total.toString()}');
    Charge charge = Charge();
    charge
      ..amount = total.round()
      ..email = 'user@email.com'
      ..reference = DateTime.now().toString()

      ..putCustomField('Charged From', 'Flutter PLUGIN');

    if(plugin.sdkInitialized){
      final response = plugin.checkout(context, charge: charge,method: CheckoutMethod.card);

      response.then((value) {
        if(value.status){
          Navigator.pushNamed(context, widget.paymentMethod.route);
        }
      });

    }else{
      log('NOT INITIALIZED');
    }

    // final response = await plugin.chargeCard(context, charge: charge);
    // Use the response
  }
}
