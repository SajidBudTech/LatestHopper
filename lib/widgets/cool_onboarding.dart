import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/onboarding_slide.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CoolOnboarding extends StatefulWidget {
  CoolOnboarding({
    Key key,
    @required this.onBoardingSlides,
    this.onSkipPressed,
    this.completedText = GeneralStrings.save,
    this.onCompletedPressed,
    this.indicatorDotColor,
    this.indicatorActiveDotColor,
  }) : super(key: key);

  final List<OnboardingSlide> onBoardingSlides;
  final String completedText;
  final Function onSkipPressed;
  final Function onCompletedPressed;
  final Color indicatorDotColor;
  final Color indicatorActiveDotColor;

  @override
  _CoolOnboardingState createState() => _CoolOnboardingState();
}

class _CoolOnboardingState extends State<CoolOnboarding> {
  //pageview controller
  PageController _pageController = PageController();
  bool atLastPageView = false;
  int currentPageIndex=0;

  //listen to pageview change
  void _pageViewChanged(int currentPage) {
    currentPageIndex=currentPage;
    if (currentPage == widget.onBoardingSlides.length - 1) {
      atLastPageView = true;
    } else {
      atLastPageView = false;
    }

    setState(() {
      atLastPageView = atLastPageView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 20,left: 30),
          child:Column(
         mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            widget.onBoardingSlides[currentPageIndex].asset,
            width:double.infinity,
            height: MediaQuery.of(context).size.height * 0.60,
            fit: BoxFit.fill,
          ),
          SmoothPageIndicator(
            controller: _pageController, // PageController
            count: 2,
            effect: ExpandingDotsEffect(
              spacing: 5.0,
              // radius: 4.0,
              dotWidth: 10.0,
              dotHeight: 5.0,
              strokeWidth: 1.5,
              dotColor: widget.indicatorDotColor ?? Colors.teal[200],
              activeDotColor: widget.indicatorActiveDotColor ?? Colors.teal[900],
            ), // your preferred effect
          ),
          Expanded(child: PageView(
            controller: _pageController,
            onPageChanged: _pageViewChanged,
            children: widget.onBoardingSlides,
          )),

        ],
      ))




     /* Stack(
        children: <Widget>[
          //onboarding sliders


          PageView(
            controller: _pageController,
            onPageChanged: _pageViewChanged,
            children: widget.onBoardingSlides,
          ),

          //Slider actions
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //pageview indicators
                  SmoothPageIndicator(
                    controller: _pageController, // PageController
                    count: 2,
                    effect: ExpandingDotsEffect(
                      spacing: 5.0,
                      // radius: 4.0,
                      dotWidth: 20.0,
                      dotHeight: 5.0,
                      strokeWidth: 1.5,
                      dotColor: widget.indicatorDotColor ?? Colors.teal[200],
                      activeDotColor: widget.indicatorActiveDotColor ?? Colors.teal[900],
                    ), // your preferred effect
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  //pageview action buttons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //skip button
                      ButtonTheme(
                        minWidth: 0,
                        padding: EdgeInsets.all(5),
                        child: FlatButton(
                          onPressed: widget.onSkipPressed,
                          child: Text(
                            GeneralStrings.skip,
                          ),
                        ),
                      ),

                      //next/start button
                      CustomButton(
                        color: AppColor.accentColor,
                        textColor: Colors.white,
                        onPressed: atLastPageView
                            ? widget.onCompletedPressed
                            : () {
                                _pageController.nextPage(
                                  duration: Duration(
                                    milliseconds: 300,
                                  ),
                                  curve: Curves.ease,
                                );
                              },
                        child: Text(
                          atLastPageView
                              ? widget.completedText
                              : GeneralStrings.next,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),*/
    );
  }
}
