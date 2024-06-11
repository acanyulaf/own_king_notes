// import 'package:flutter/material.dart';
// import 'package:maktek_arge_app/providers/ble_data.dart';
// import 'package:maktek_arge_app/providers/ble_data/comms.dart';
// import 'package:maktek_arge_app/providers/remote_data.dart';
// import 'package:maktek_arge_app/data/second_gen/diagnostic_menu_list.dart';
// import 'package:maktek_arge_app/screens/third_gen/diagnostic_menu/calibration_screen.dart';
// import 'package:maktek_arge_app/screens/third_gen/diagnostic_menu/configuration_screen.dart';
// import 'package:maktek_arge_app/screens/third_gen/diagnostic_menu/ecm_info_screen.dart';
// import 'package:maktek_arge_app/screens/third_gen/diagnostic_menu/error_codes_screen.dart';
// import 'package:maktek_arge_app/screens/third_gen/diagnostic_menu/live_data_screen.dart';
// import 'package:maktek_arge_app/screens/third_gen/diagnostic_menu/programming_screen.dart';
// import 'package:maktek_arge_app/screens/third_gen/diagnostic_menu/tests_screen.dart';
// import 'package:maktek_arge_app/screens/third_gen/diagnostic_menu/vehicle_info_screen.dart';
// import 'package:maktek_arge_app/theme/wrapper.dart';
// import 'package:maktek_arge_app/widgets/second_gen/grid_item_general.dart';

// class DiagnosticMenuScreen extends StatelessWidget {
//   const DiagnosticMenuScreen({
//     super.key,
//     this.bluetoothSource,
//     this.remoteSource,
//     required this.isBluetooth,
//   });
//   final RemoteDataProvider? remoteSource;
//   final BleDeviceProvider? bluetoothSource;
//   final bool isBluetooth;

//   @override
//   Widget build(BuildContext context) {
//     BleDeviceProvider instance = BleDeviceProvider();
//     String BleStateString = instance.bleStateString();
//     String connectionStateString = instance.bleConnectionStateString();

//     var source;
//     if (remoteSource == null) {
//       source = bluetoothSource!;
//     } else {
//       source = remoteSource!;
//     }

//     void onTapped(String name) {
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) {
//           switch (name) {
//             case 'Canlı Değerler':
//               {
//                 return LiveDataScreen(
//                   source: source,
//                 );
//               }
//             case 'ECM Bilgisi':
//               {
//                 return ECMInfoScreen(
//                   source: source,
//                 );
//               }
//             case 'Testler':
//               {
//                 return TestsScreen();
//               }
//             case 'Kalibrasyon':
//               {
//                 return CalibrationScreen();
//               }
//             case 'Programlama':
//               {
//                 return ProgrammingScreen();
//               }
//             case 'Hata Kodları':
//               {
//                 return FailureCodeScreen(
//                   source: source,
//                 );
//               }
//             case 'Konfigürasyon':
//               {
//                 return ConfigurationScreen();
//               }
//           }
//           return VehicleInfoScreen(
//             source: source,
//           );
//         }),
//       );
//     }

//     return Wrapper(
//       Child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Text('Diyagnostik Menü', textAlign: TextAlign.left),
//           leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: const Icon(
//               Icons.arrow_back,
//               size: 30,
//             ),
//           ),
//         ),
//         body: AnimatedBuilder(
//           animation: source,
//           builder: (context, child) =>
//               (isBluetooth && source.deviceConnected) || !isBluetooth
//                   ? GridView(
//                       padding: const EdgeInsetsDirectional.symmetric(
//                           vertical: 40, horizontal: 16),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         // crossAxisCount: 2,
//                         childAspectRatio: 1.5,
//                         crossAxisSpacing: 16,
//                         mainAxisSpacing: 16,
//                       ),
//                       children: [
//                         for (final item in diagnosticMenuList)
//                           GridItemGeneral(
//                             name: item.name,
//                             icon: item.icon,
//                             onTappedGridItem: () => onTapped(item.name),
//                           ),
//                       ],
//                     )
//                   : isBluetooth && source.isConnectingDisconnecting
//                       ? Container(
//                           height: 100,
//                           width: 100,
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Theme.of(context).cardColor,
//                             ),
//                             strokeWidth: 5,
//                           ),
//                         )
//                       : Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.bluetooth_disabled, size: 100),
//                               SizedBox(height: 40),
//                               Text(
//                                 'Herhangi bir cihaza bağlı değil.',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .copyWith(fontSize: 25),
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 'Bluetooth Durumu: ${BleStateString}',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .copyWith(fontSize: 25),
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 'Bağlantı Durumu: ${connectionStateString}',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .copyWith(fontSize: 25),
//                               ),
//                               SizedBox(height: 80),
//                               Text(
//                                 'Diyagnostik Menüsüne Nasıl Erişirim?',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge!
//                                     .copyWith(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 20),
//                               Text(
//                                 '   -Maktek\'in konumunuza erişmesine müsade edin.',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge!
//                                     .copyWith(fontSize: 14),
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 '   -Bluetooth erişiminizi açın ve bekleyin.',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .copyWith(fontSize: 14),
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 '   -Bu kadar. Gerisini Maktek\e bırakın.',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .copyWith(fontSize: 14),
//                               ),
//                             ],
//                           ),
//                         ),
//         ),
//       ),
//     );
//   }
// }