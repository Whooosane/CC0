import 'package:circleapp/controller/getx_controllers/picker_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/customTextStyle.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class PaymentScreen extends StatelessWidget {
  final String title;
  const PaymentScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    RxBool paymentSuccess = false.obs;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController securityCodeController = TextEditingController();
    final PickerController paymentController = Get.put(PickerController());
    return Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.3.h),
            child: Column(
              children: [
                getVerticalSpace(6.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        paymentSuccess.value = false;
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 2.h,
                      ),
                    ),
                    getHorizentalSpace(1.5.h),
                    Text(
                      'Payment',
                      style: CustomTextStyle.headingStyle,
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
                paymentSuccess.value == true
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.h),
                        child: Column(
                          children: [
                            getVerticalSpace(12.2.h),
                            Container(
                                height: 11.h,
                                width: 11.h,
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                child: Image.asset(
                                  'assets/png/sucess sign.png',
                                  fit: BoxFit.cover,
                                )),
                            getVerticalSpace(3.9.h),
                            Text(
                              'Payment Successful',
                              style: CustomTextStyle.buttonText.copyWith(fontSize: 14.px, color: Colors.white),
                            ),
                            getVerticalSpace(1.3.h),
                            Text(
                              '''Lorem ipsum dolor sit amet consectetur. Eget aliquam suspendisse ultrices a mattis vitae. Adipiscing id vestibulum ultrices lorem. Nibh dignissim bibendum a.''',
                              style: CustomTextStyle.hintText,
                              textAlign: TextAlign.center,
                            ),
                            getVerticalSpace(13.8.h)
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getVerticalSpace(4.2.h),
                          Text(
                            'Select Payment Method',
                            style: CustomTextStyle.buttonText,
                          ),
                          getVerticalSpace(1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: 7.h,
                                  width: 12.h,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.px)),
                                  child: const Image(
                                    image: AssetImage('assets/png/visacard.png'),
                                    fit: BoxFit.cover,
                                  )),
                              Container(
                                  height: 7.h,
                                  width: 12.h,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.px)),
                                  child: const Image(
                                    image: AssetImage('assets/png/mastercard.png'),
                                    fit: BoxFit.cover,
                                  )),
                              Container(
                                  height: 7.h,
                                  width: 12.h,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.px)),
                                  child: const Image(
                                    image: AssetImage('assets/png/apppay.png'),
                                    fit: BoxFit.cover,
                                  )),
                            ],
                          ),
                          getVerticalSpace(2.2.h),
                          Text(
                            'Enter your Card Details to save Info',
                            style: CustomTextStyle.buttonText.copyWith(fontSize: 10.px),
                          ),
                          getVerticalSpace(2.9.h),
                          Text(
                            'Name on card',
                            style: CustomTextStyle.buttonText.copyWith(fontSize: 10.px),
                          ),
                          getVerticalSpace(.5.h),
                          customTextFormField(
                            nameController,
                            'Full Name',
                            isObsecure: false,
                          ),
                          getVerticalSpace(2.h),
                          Text(
                            'card Number',
                            style: CustomTextStyle.buttonText.copyWith(fontSize: 10.px),
                          ),
                          getVerticalSpace(.5.h),
                          customTextFormField(cardNumberController, 'XXXX   XXXX   XXXX   XXXX',
                              isObsecure: false, keyboardType: TextInputType.number),
                          getVerticalSpace(2.h),
                          Text(
                            'expiry date',
                            style: CustomTextStyle.buttonText.copyWith(fontSize: 10.px),
                          ),
                          getVerticalSpace(.5.h),
                          customTextFormField(nameController, paymentController.formatedDate.value, isObsecure: false, readOnly: true, isTap: () {
                            paymentController.selectDate(context,DateTime.now());
                          }),
                          getVerticalSpace(2.h),
                          Text(
                            'Security code',
                            style: CustomTextStyle.buttonText.copyWith(fontSize: 10.px),
                          ),
                          getVerticalSpace(.5.h),
                          customTextFormField(securityCodeController, 'CVV', isObsecure: false),
                          getVerticalSpace(7.1.h),
                        ],
                      ),
                paymentSuccess.value == true
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.5.h),
                        child: customButton(
                            onTap: () {
                              if (title == 'dinnerPlan') {
                                // Get.to(() => const ToDoBillDetailScreen());
                              } else if (title == 'bookTicket') {
                              }
                            },
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.primaryColor,
                            title: 'Done',
                            titleColor: Colors.black,
                            height: 4.5.h),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.5.h),
                        child: customButton(
                            onTap: () {
                              paymentSuccess.value = true;
                              // if(paymentSuccess.value==true){
                              //   Get.to(()=> const AddNewPlan(title: 'payment',));
                              // }
                            },
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.primaryColor,
                            title: 'Done',
                            titleColor: Colors.black,
                            height: 4.5.h),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
