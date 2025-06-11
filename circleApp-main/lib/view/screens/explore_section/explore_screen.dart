import 'package:circleapp/controller/getx_controllers/offer_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/preference_keys.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/controller/utils/style/customTextStyle.dart';
import 'package:circleapp/models/offer_models/offers_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/explore_section/early_bird_offer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late OffersController offersController;
  final List<String> options = ["Travelling", "Photography", "Shopping", "Music", "Movies", "Fitness", "Sports", "Video Games", "Night Out", "Art"];
  final RxInt selectedIndex = 0.obs;
  final RxString token = "".obs;

  @override
  void initState() {
    super.initState();
    offersController = Get.put(OffersController(context));
    token.value=MySharedPreferences.getString(userTokenKey);
    offersController.getOffers(load: offersController.offersModel.value == null, interest: options[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.px),
        child: Column(
          children: [
            getVerticalSpace(8.h),
            Text("Explore (Offers)", style: CustomTextStyle.mediumTextExplore),
            getVerticalSpace(3.h),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.only(left: 2.5.h, top: 1.2.h),
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                      color: Color(0xff383838),
                    ),
                    child: Text(options[selectedIndex.value], style: CustomTextStyle.mediumTextLight),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => _showFilterDialog(context),
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                        color: AppColors.mainColorYellow,
                      ),
                      child: Transform.scale(scale: 0.6, child: SvgPicture.asset("assets/svg/filter.svg")),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: offersController.loading.value
                  ? _buildShimmer()
                  : offersController.offersModel.value!.offers.isEmpty
                  ? _buildEmptyState()
                  : _buildOfferList(),
            ),
          ],
        ),
      ),
    ));
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.textFieldColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text('Filter', style: CustomTextStyle.mediumTextM14),
            const Spacer(),
            GestureDetector(onTap: Get.back, child: const Icon(Icons.cancel, color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 4.5.h, bottom: 10.px),
              child: Text('Choose group to see offers', style: CustomTextStyle.mediumTextS),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  children: options
                      .asMap()
                      .entries
                      .map((entry) => GestureDetector(
                    onTap: () => selectedIndex.value = entry.key,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.mainColorBackground,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.value, style: CustomTextStyle.mediumTextM14),
                          Obx(() => selectedIndex.value == entry.key ? SvgPicture.asset("assets/svg/tick.svg") : const SizedBox()),
                        ],
                      ),
                    ),
                  ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          GestureDetector(
            onTap: () {
              offersController.getOffers(load: true, interest: options[selectedIndex.value]);
              Get.back();
            },
            child: Container(
              height: 4.h,
              width: 36.w,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.mainColorYellow),
              child: const Center(child: Text("Done")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() => Shimmer.fromColors(
    baseColor: AppColors.shimmerColor1,
    highlightColor: AppColors.shimmerColor2,
    child: ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 210.px,
        decoration: BoxDecoration(color: AppColors.mainColor, borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );

  Widget _buildEmptyState() {
    final Map<String, IconData> categoryIcons = {
      "Travelling": Icons.flight_takeoff,
      "Photography": Icons.camera_alt,
      "Shopping": Icons.shopping_bag,
      "Music": Icons.music_note,
      "Movies": Icons.movie,
      "Fitness": Icons.fitness_center,
      "Sports": Icons.sports,
      "Video Games": Icons.videogame_asset,
      "Night Out": Icons.nightlife,
      "Art": Icons.palette,
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            categoryIcons[options[selectedIndex.value]] ?? Icons.local_offer_outlined,
            size: 48.px,
            color: Colors.white54,
          ),
          getVerticalSpace(2.h),
          Text(
            "No Offers for ${options[selectedIndex.value]}",
            style: CustomTextStyle.mediumTextM14.copyWith(color: Colors.white54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOfferList() => ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: offersController.offersModel.value!.offers.length,
    itemBuilder: (context, index) {
      Offer offer = offersController.offersModel.value!.offers[index];
      return GestureDetector(
        onTap: () => Get.to(() => OfferDetails(offer: offer,token: token.value )),
        child: Container(
          margin: EdgeInsets.only(top: 10.px),
          padding: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 2.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.textFieldColor),
          child: offerCard(
            title: offer.title,
            titleId: offer.id,
            description: offer.description,
            interest: offer.interest,
            price: offer.price,
            startingDate: offer.startingDate,
            numberOfPeople: offer.numberOfPeople,
            imageUrls: offer.imageUrls,
            showShare: true,

          ),
        ),
      );
    },
  );
}