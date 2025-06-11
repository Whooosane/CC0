import 'package:circleapp/controller/getx_controllers/offer_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/style/customTextStyle.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/explore_section/share_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:circleapp/models/message_models/get_message_model.dart';

class OfferDetailsScreen extends StatefulWidget {
  final OfferDetails offer;
  final String? token;
  const OfferDetailsScreen({super.key, required this.offer, this.token});
  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}
class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  RxInt selectedIndex = 0.obs;
  late OffersController offersController;
  @override
  void initState() {
    super.initState();
    offersController = Get.find<OffersController>();
  }
  void _bookOffer() async {
    await offersController.buyOffer(
      offerId: widget.offer.id,
      token: widget.token.toString(),
    );
  }
  void _saveOffer() async {
    await offersController.saveOffer(
      offerId: widget.offer.id,
      token: widget.token.toString(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.mainColorBackground,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: Get.back,
              child: Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 19.px),
            ),
            getHorizentalSpace(4.w),
            Text(widget.offer.title, style: CustomTextStyle.mediumTextExplore),
          ],
        ),
        actions: [
          Obx(
                () => GestureDetector(
              onTap: _saveOffer,
              child: SvgPicture.asset(
                "assets/svg/save.svg",
                height: 3.9.h,
                colorFilter: ColorFilter.mode(
                    offersController.returnMessage.value !=
                        "Offer saved successfully"
                        ? Colors.white
                        : AppColors.mainColorYellow,
                    BlendMode.srcIn),
              ),
            ),
          ),
          getHorizentalSpace(2.w),
          GestureDetector(
            onTap: () {
              Get.to(() => ShareGroupScreen(
                titleId: widget.offer.id,
                titleKey: "offerId",
              ));
            },
            child: SvgPicture.asset(
              "assets/svg/shareIcon.svg",
              height: 3.4.h,
            ),
          ),
          getHorizentalSpace(2.w),
          GestureDetector(
            onTap: _bookOffer,
            child: Container(
              height: 24.px,
              width: 20.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.mainColorYellow),
              child: const Center(child: Text("Book")),
            ),
          ),
          getHorizentalSpace(6.w),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.h),
            child: SingleChildScrollView(
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.offer.imageUrls.isEmpty
                      ? _buildEmptyState()
                      : Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 48.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: widget.offer
                                  .imageUrls[selectedIndex.value],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Shimmer.fromColors(
                                    baseColor: AppColors.shimmerColor1,
                                    highlightColor:
                                    AppColors.shimmerColor2,
                                    child: Container(color: Colors.white),
                                  ),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      getVerticalSpace(1.h),
                      SizedBox(
                        height: 11.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: widget.offer.imageUrls.length,
                          itemBuilder: (context, index) =>
                              GestureDetector(
                                onTap: () => selectedIndex.value = index,
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      widget.offer.imageUrls[index],
                                      height: 82,
                                      width: 22.w,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                            baseColor:
                                            AppColors.shimmerColor1,
                                            highlightColor:
                                            AppColors.shimmerColor2,
                                            child: Container(
                                                color: Colors.white),
                                          ),
                                      errorWidget:
                                          (context, url, error) =>
                                      const Icon(Icons.error,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                  getVerticalSpace(1.h),
                  Text(
                    widget.offer.description,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11.px,
                        fontWeight: FontWeight.w400,
                        fontFamily: "medium"),
                  ),
                  getVerticalSpace(1.h),
                  Row(
                    children: [
                      Text("Offer for: ",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 11.px,
                              fontWeight: FontWeight.w400,
                              fontFamily: "medium")),
                      getHorizentalSpace(0.5.w),
                      Text("${widget.offer.numberOfPeople} People",
                          style: CustomTextStyle.mediumTextM),
                    ],
                  ),
                  getVerticalSpace(1.h),
                  Row(
                    children: [
                      Text("Interest: ",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 11.px,
                              fontWeight: FontWeight.w400,
                              fontFamily: "medium")),
                      getHorizentalSpace(0.5.w),
                      Text(widget.offer.interest,
                          style: CustomTextStyle.mediumTextM),
                    ],
                  ),
                  getVerticalSpace(1.h),
                  Row(
                    children: [
                      Text("Total Price: ",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 11.px,
                              fontWeight: FontWeight.w400,
                              fontFamily: "medium")),
                      getHorizentalSpace(0.5.w),
                      Text("\$${widget.offer.price}",
                          style: CustomTextStyle.mediumTextM),
                      const Expanded(child: SizedBox()),
                      Text(
                        widget.offer.startingDate,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11.px,
                            fontWeight: FontWeight.w400,
                            fontFamily: "medium"),
                      ),
                    ],
                  ),
                  getVerticalSpace(2.h),
                ],
              )),
            ),
          ),
          Obx(() => offersController.bookOfferLoading.value ||
              offersController.saveOfferLoading.value
              ? Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.secondaryColor),
                  ),
                  getVerticalSpace(2.h),
                  Text(
                    offersController.saveOfferLoading.value
                        ? offersController.returnMessage.value ==
                        "Offer saved successfully"
                        ? "UnSaved your offer..."
                        : "Saving your offer..."
                        : "Booking your offer...",
                    style: CustomTextStyle.mediumTextM14.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          )
              : const SizedBox()),
        ],
      ),
    );
  }

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

    return Container(
      height: 48.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            categoryIcons[widget.offer.interest] ?? Icons.local_offer_outlined,
            size: 48.px,
            color: Colors.white54,
          ),
          getVerticalSpace(2.h),
          Text(
            "No Images for ${widget.offer.interest} Offer",
            style:
            CustomTextStyle.mediumTextM14.copyWith(color: Colors.white54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
