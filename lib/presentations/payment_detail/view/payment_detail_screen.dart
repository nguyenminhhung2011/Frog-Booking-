import 'dart:math';

import 'package:flight_booking/core/components/enum/payment_status_enum.dart';
import 'package:flight_booking/core/components/widgets/extension/context_extension.dart';
import 'package:flight_booking/core/components/widgets/flux_table/flux_ticket_table.dart';
import 'package:flight_booking/core/components/widgets/payment_status_utils.dart';
import 'package:flight_booking/domain/entities/payment/payment.dart';
import 'package:flight_booking/presentations/payment_detail/bloc/payment_detail_bloc.dart';
import 'package:flight_booking/presentations/payment_detail/view/widgets/flight_info_card.dart';
import 'package:flight_booking/presentations/payment_detail/view/widgets/payment_detail_card.dart';
import 'package:flight_booking/presentations/payment_detail/view/widgets/payment_info_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flight_booking/core/config/common_ui_config.dart';
import 'package:intl/intl.dart';

import '../../../core/components/enum/action_enum.dart';
import '../../../core/components/widgets/flux_table/flux_table_row.dart';
import '../../../generated/l10n.dart';

class PaymentDetailScreen extends StatelessWidget {
  PaymentDetailScreen({super.key});

  final PaymentDetailBloc test = PaymentDetailBloc("");

  Widget _buildPaymentStatusComponent(
    BuildContext context,
    PaymentStatus status,
  ) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: status.getColorBaseOnStatus().shade200,
        borderRadius: CommonAppUIConfig.primaryRadiusBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            status.getIconBaseOnStatus(),
            color: status.getColorBaseOnStatus().shade900,
          ),
          const SizedBox(width: 5),
          Text(
            status.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: status.getColorBaseOnStatus().shade900,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTable(BuildContext context) {
    return FluxTicketTable<Payment>(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      tableDecoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: CommonAppUIConfig.primaryRadiusBorder,
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      data: [],
      rowBuilder: (data) {
        return FluxTableRow(
          rowDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).scaffoldBackgroundColor,
            border:
                Border.all(width: 0.15, color: Theme.of(context).disabledColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          itemBuilder: (data, int columnIndex) {
            if (columnIndex == 6) {
              return _buildPaymentStatusComponent(context, data);
            }
            if (columnIndex == 7) {
              return PopupMenuButton<ActionEnum>(
                itemBuilder: (context) => [
                  PopupMenuItem<ActionEnum>(
                    value: ActionEnum.detail,
                    child: Text(
                      ActionEnum.detail.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  PopupMenuItem<ActionEnum>(
                    child: Text(
                      ActionEnum.edit.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  PopupMenuItem<ActionEnum>(
                    child: Text(
                      ActionEnum.delete.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
                onSelected: (value) {},
                icon: const Icon(Icons.more_vert),
              );
            }
            return Text(
              data.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            );
          },
          rowData: [
            FlexRowTableData<String>(flex: 2, data: data.id),
            FlexRowTableData<String>(flex: 2, data: data.customer?.id),
            FlexRowTableData<String>(flex: 2, data: data.paymentType.name),
            FlexRowTableData<String>(flex: 2, data: data.total.toString()),
            FlexRowTableData<String>(
              flex: 2,
              data: DateFormat().add_MMMMEEEEd().add_Hm().format(
                    DateTime.fromMillisecondsSinceEpoch(data.createDate),
                  ),
            ),
            FlexRowTableData<PaymentStatus>(flex: 2, data: getRandomStatus()),
            FlexRowTableData<String>(flex: 1),
          ],
        );
      },
      rowSelectedDecoration: BoxDecoration(
          border: Border.all(width: 2, color: Theme.of(context).primaryColor)),
      titleRow: FluxTableRow(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        rowDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
          border:
              Border.all(width: 0.15, color: Theme.of(context).disabledColor),
        ),
        itemBuilder: (data, index) {
          if (data == null) return const SizedBox();
          return Text(data.toString());
        },
        rowData: [
          FlexRowTableData<String>(flex: 2, data: S.of(context).id),
          FlexRowTableData<String>(flex: 2, data: S.of(context).customerId),
          FlexRowTableData<String>(flex: 2, data: S.of(context).paymentMethod),
          FlexRowTableData<String>(flex: 2, data: S.of(context).amount),
          FlexRowTableData<String>(flex: 2, data: S.of(context).creDate),
          FlexRowTableData<String>(flex: 2, data: S.of(context).status),
          FlexRowTableData<String>(flex: 1, data: S.of(context).actions),
        ],
      ),
      isSelectable: true,
    );
  }

  PaymentStatus getRandomStatus() {
    final status = [
      PaymentStatus.create,
      PaymentStatus.declined,
      PaymentStatus.pending,
      PaymentStatus.succeeded
    ];

    return status.elementAt(Random().nextInt(4));
  }

  final double cardSpace = 10;

  void _stateChangeListener(BuildContext context, PaymentDetailState state) {
    state.whenOrNull();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentDetailBloc, PaymentDetailState>(
      bloc: test,
      listener: _stateChangeListener,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconTheme: IconThemeData(color: context.titleSmall.color),
            elevation: 1,
            title: Text(
              "Payment Detail",
              style: context.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold, color: context.titleSmall.color),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Expanded(
                                  flex: 2, child: PaymentConfirmCard()),
                              SizedBox(width: cardSpace),
                              const Expanded(flex: 3, child: FlightInfoCard()),
                            ],
                          ),
                        ),
                        SizedBox(height: cardSpace),
                        Expanded(
                          child: _buildPaymentTable(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: cardSpace),
                  const Expanded(child: PaymentDetailCard()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
