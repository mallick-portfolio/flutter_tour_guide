import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, String>> sliderItems = [
    {
      'title': 'Slide 1',
      'image': 'https://via.placeholder.com/300x200',
      'subtitle': 'This is the subtitle for Slide 1',
    },
    {
      'title': 'Slide 2',
      'image': 'https://via.placeholder.com/300x200',
      'subtitle': 'This is the subtitle for Slide 2',
    },
    {
      'title': 'Slide 3',
      'image': 'https://via.placeholder.com/300x200',
      'subtitle': 'This is the subtitle for Slide 3',
    },
  ];

  int currentIndex = 0;
  final cs.CarouselSliderController buttonCarouselController =
      cs.CarouselSliderController();

  // Correctly define the method to return the CarouselSlider widget
  Widget buildSlider() {
    return cs.CarouselSlider(
      carouselController: buttonCarouselController,
      options: cs.CarouselOptions(
        height: 500.0,
        autoPlay: false,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      items: sliderItems.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item['title']!,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.network(
                    item['image']!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item['subtitle']!,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget buildBulletIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sliderItems.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: currentIndex == index ? 12.0 : 8.0,
          height: currentIndex == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }

  Future<void> showConfirmationDialog() async {
    print("calling");
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Do you want to see the carousel again?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (result == true) {
      buttonCarouselController.jumpToPage(0); // Reset to the first slide
      setState(() {
        currentIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 9,
                child: buildSlider(), // Call the method to build the slider
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => showConfirmationDialog(),
                        child: const Text("Skip"),
                      ),
                      buildBulletIndicator(), // Directly use Text widget
                      currentIndex == sliderItems.length - 1
                          ? ElevatedButton(
                              onPressed: () {
                                // Handle "Done" action
                                print("Done button pressed!");
                              },
                              child: const Text('Done'),
                            )
                          : ElevatedButton(
                              onPressed: () =>
                                  buttonCarouselController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear,
                              ),
                              child: const Text('→'),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
