import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import 'success_screen.dart';

void main() => runApp(const App());

void callback(response, context) {
  debugPrint('Payment Response: $response');
  switch (response['status']) {
    case PAYMENT_CANCELLED:
      debugPrint(PAYMENT_CANCELLED);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(PAYMENT_CANCELLED),
      ));
      break;

    case PENDING_PAYMENT:
      debugPrint(PENDING_PAYMENT);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(PENDING_PAYMENT),
      ));
      break;

    case PAYMENT_INIT:
      debugPrint(PAYMENT_INIT);
      debugPrint('Request Data: ${response['requestData']}');
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //content: Text(PAYMENT_INIT),
      //));
      break;

    case PAYMENT_SUCCESS:
      debugPrint(PAYMENT_SUCCESS);
      debugPrint('Transaction ID: ${response['transactionId']}');
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(PAYMENT_SUCCESS),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(
            amount: response['requestData']['amount'],
            transactionId: response['transactionId'],
          ),
        ),
      );
      break;

    default:
      debugPrint(UNKNOWN_EVENT);
      break;
  }
}

final kkiapay = KKiaPay(
  amount: 1,
  sandbox: false,
  apikey: "your_api_key_here",
  callback: callback,
  countries: ["BJ", "TG"],
  paymentMethods: ["momo"],
  providers: Providers(
    exclude: ["moov-bj", "celtiis-bj", "mtn-bj", "moov-tg"],
  ),
);

final kkiapayOnlyAccept = KKiaPay(
  amount: 2,
  sandbox: false,
  apikey: "your_api_key_here",
  callback: callback,
  countries: ["NE", "CI", "SN"],
  paymentMethods: ["momo", "wallet"],
  providers: Providers(
    accept: ["airtel", "wave"],
  ),
);

final kkiapayOnlyExclude = KKiaPay(
  amount: 3,
  sandbox: false,
  apikey: "your_api_key_here",
  callback: callback,
  countries: ["BJ"],
  paymentMethods: ["momo"],
  providers: Providers(
    exclude: ["celtiis-tg"],
  ),
);

final kkiapayCountrySpecific = KKiaPay(
  amount: 5,
  sandbox: false,
  apikey: "your_api_key_here",
  callback: callback,
  countries: ["TG", "BJ"],
  paymentMethods: ["momo"],
  providers: Providers(
    accept: ["moov-bj", "moov-tg"],
    exclude: [],
  ),
);

final kkiapayNoProviders = KKiaPay(
  amount: 4,
  sandbox: true,
  apikey: "your_api_key_here",
  callback: callback,
  paymentMethods: ["momo", "card"],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('Kkiapay Sample'),
          centerTitle: true,
        ),
        body: const KkiapaySample(),
      ),
    );
  }
}

class KkiapaySample extends StatelessWidget {
  const KkiapaySample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ButtonTheme(
            minWidth: 500.0,
            height: 80.0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xff222F5A)),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text(
                'Accept: Wave,MTN,Moov | Exclude: Orange\n(All Countries)',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => kkiapay),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          ButtonTheme(
            minWidth: 500.0,
            height: 80.0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xff4E6BFC)),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text(
                'Accept: Airtel\n(NE only)',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => kkiapayOnlyAccept),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          ButtonTheme(
            minWidth: 500.0,
            height: 80.0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xffF11C33)),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text(
                'Exclude: Celtiis(BJ, TG only)',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => kkiapayOnlyExclude),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          ButtonTheme(
            minWidth: 500.0,
            height: 80.0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xff6f42c1)),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text(
                'Country-Specific: moov-tg\n(Togo only)',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => kkiapayCountrySpecific),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          ButtonTheme(
            minWidth: 500.0,
            height: 80.0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xff28a745)),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text(
                'No Provider Restrictions\n(BJ, CI - All Available)',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => kkiapayNoProviders),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          ButtonTheme(
            minWidth: 500.0,
            height: 80.0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xff222F5A)),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text(
                'Pay Now (WEB Version)',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () {
                KkiapayFlutterSdkPlatform.instance
                    .pay(kkiapay, context, callback);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ));
  }
}
