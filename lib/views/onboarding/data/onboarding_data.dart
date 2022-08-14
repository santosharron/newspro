import 'onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> allBoards = [
    OnboardingModel(
      title: 'Welcome, Beautiful Person',
      description:
          'We are Country\'s  Vibrant news app, providing news from authentic sources',
      imageLocation: 'assets/animations/animation_hello.json',
    ),
    OnboardingModel(
      title: 'Read the World Today',
      description:
          'Our news are handpicked by expert editors, our News are at Another Perspective.',
      imageLocation: 'assets/animations/animation_handpicked.json',
    ),
    OnboardingModel(
      title: 'Your Morning Updates',
      description:
          'Our experts are working constantly to make your news reading experience best.',
      imageLocation: 'assets/animations/animation_update.json',
    ),
  ];
}
