// ignore_for_file: invalid_annotation_target

import 'package:bb_mobile/_model/address.dart';
import 'package:bdk_flutter/bdk_flutter.dart' as bdk;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'transaction2.freezed.dart';
part 'transaction2.g.dart';

@freezed
class Transaction2 with _$Transaction2 {
  const factory Transaction2({
    required String txid,
    int? received,
    int? sent,
    int? fee,
    int? height,
    int? timestamp,
    String? label,
    String? fromAddress,
    String? toAddress,
    String? psbt,
    @Default(false) bool rbfEnabled,
    @Default(false) bool oldTx,
    int? broadcastTime,
    // String? serializedTx,
    List<String>? inAddresses,
    List<String>? outAddresses,
    @Default([]) List<Address> outAddrs,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    bdk.TransactionDetails? bdkTx,
  }) = _Transaction2;
  const Transaction2._();

  factory Transaction2.fromJson(Map<String, dynamic> json) => _$Transaction2FromJson(json);
  String mapOutValueToAddress(String value) {
    if (outAddresses == null) return '';
    final String address = outAddresses!.firstWhere(
      (element) => element.split(':')[1] == value,
      orElse: () => '',
    );
    return address.split(':')[0];
  }

  List<Address> createOutAddrsFromTx() {
    final List<Address> outAddrs = [];
    return outAddrs;
  }

  bool isReceived() => sent == 0;

  int getAmount({bool sentAsTotal = false}) {
    try {
      return isReceived()
          ? received!
          : sentAsTotal
              ? (sent! - received!)
              : (sent! - received! - fee!);
    } catch (e) {
      return 0;
    }
  }

  // int getAmount({bool sentAsTotal = false}) => isReceived()
  //     ? (received! - fee!)
  //     : sentAsTotal
  //         ? sent!
  //         : (sent! - fee!);

  DateTime getDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
  }

  static const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec',
  ];

  String getDateTimeStr() {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    if (dt.isAfter(DateTime.now().subtract(const Duration(days: 2)))) return timeago.format(dt);
    final day = dt.day.toString().length == 1 ? '0${dt.day}' : dt.day.toString();
    return months[dt.month - 1] + ' ' + day + ', ' + dt.year.toString();
  }

  DateTime? getBroadcastDateTime() =>
      broadcastTime == null ? null : DateTime.fromMillisecondsSinceEpoch(broadcastTime!);

  bool canRBF() => rbfEnabled == true && timestamp == null || timestamp == 0;
}

DateTime getDateTimeFromInt(int time) => DateTime.fromMillisecondsSinceEpoch(time * 1000);
