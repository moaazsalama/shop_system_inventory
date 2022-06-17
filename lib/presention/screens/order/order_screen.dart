import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mafroshat_tech/business_logic/order/order_cubit.dart';
import 'package:mafroshat_tech/business_logic/pdf/pdf_cubit.dart';
import 'package:mafroshat_tech/constants/colors.dart';
import 'package:mafroshat_tech/constants/fonts.dart';
import 'package:mafroshat_tech/constants/strings.dart';
import 'package:mafroshat_tech/data/models/order.dart';
import 'package:mafroshat_tech/presention/widgets/drawer.dart';
import 'package:mafroshat_tech/presention/widgets/myapp_bar.dart';

import '../../widgets/mybutton.dart';
import '../../widgets/text_field.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const DrawerWidget(),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          var cubit = OrderCubit.getCubit(context);
          return DefaultTextStyle(
              style: bodyStyle,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => Card(
                        child: OrderWidget(order: cubit.orders[index]),
                      ),
                      itemCount: cubit.orders.length,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * .15,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text('البيع اليومي '),
                              Text(cubit.dailySell().toString())
                            ],
                          ),
                          Column(
                            children: [
                              Text('البيع الشهري '),
                              Text(cubit.monthlySell().toString())
                            ],
                          ),
                          Column(
                            children: [
                              Text('البيع السنوي '),
                              Text(cubit.yearlySell().toString())
                            ],
                          ),
                          Column(
                            children: [
                              Text('البيع اليومي '),
                              Text(cubit.weekySell().toString())
                            ],
                          ),
                        ]),
                  )
                ],
              ));
        },
      ),
    );
  }
}

class OrderWidget extends StatelessWidget {
  const OrderWidget({Key? key, required this.order}) : super(key: key);
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all()),
      child: ExpansionTile(
        leading: Text(order.orderId.toString()),
        title: Text(order.clinentName, style: bodyStyle.copyWith(color: null)),
        collapsedTextColor: amberColor,
        subtitle: Text(
            DateFormat.yMMMEd().add_jms().format(order.dateTime).toString()),
        children: [
          Center(
            child: Text(
              'الفاتورة',
              style: titleStyle.copyWith(),
            ),
          ),
          MyButton(
            title: 'اطبع فاتوره ',
            onPressed: () async {
              PdfCubit.getPdf(order: order);
            },
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'الاسم ',
                  style: titleStyle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ),
              MyButton(
                title: 'استرجاع',
                onPressed: () async {
                  await OrderCubit.getCubit(context)
                      .removeOrder(order, context);
                  OrderCubit.getCubit(context).emit(OrderInitial());
                },
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'الكمية',
                      style: titleStyle.copyWith(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'x',
                        style: titleStyle.copyWith(color: Colors.white),
                      ),
                    ),
                    Text(
                      'سعر البيع',
                      style: titleStyle.copyWith(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'الاجمالي',
                        style: titleStyle.copyWith(color: amberColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.white,
          ),
          ...List.generate(
            order.orderItems.length,
            (ind) => Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    order.orderItems[ind].product.title,
                    style: titleStyle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
                MyButton(
                    title: 'تعديل',
                    onPressed: () => Navigator.pushNamed(
                        context, addOrderScreen,
                        arguments: order.orderItems[ind])),
                SizedBox(
                  width: 10,
                ),
                MyButton(
                  title:
                      'استرجاع ${order.orderItems[ind].orderItemID.toString()}',
                  onPressed: () => OrderCubit.getCubit(context)
                      .removeOrderItem(order.orderItems[ind], context),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        order.orderItems[ind].quantity.toString(),
                        style: titleStyle.copyWith(color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'x',
                          style: titleStyle.copyWith(color: Colors.white),
                        ),
                      ),
                      Text(
                        order.orderItems[ind].product.sellPrices.toString(),
                        style: titleStyle.copyWith(color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (order.orderItems[ind].product.sellPrices *
                                  order.orderItems[ind].quantity)
                              .toString(),
                          style: titleStyle.copyWith(color: amberColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).toList(),
          const Divider(
            color: Colors.white,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'الاجمالي',
                  style: titleStyle.copyWith(color: Colors.white, fontSize: 16),
                ),
              ),
              Text(
                order.getTotoal().toString(),
                style: titleStyle.copyWith(
                    color: amberColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'الخصم ',
                  style: bodyStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                order.discount.toString(),
                style: titleStyle.copyWith(
                    color: amberColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'بعد الخصم',
                  style: titleStyle.copyWith(color: Colors.white, fontSize: 14),
                ),
              ),
              Text(
                (order.getTotoal() - order.discount).toString(),
                style: titleStyle.copyWith(
                    color: amberColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'اسم العميل',
                  style: bodyStyle.copyWith(color: Colors.white),
                ),
              ),
              Text(
                order.clinentName.toString(),
                style: titleStyle.copyWith(
                    color: amberColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
