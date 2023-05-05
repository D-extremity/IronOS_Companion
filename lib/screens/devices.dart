import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ironos_companion/widgets/device_list.dart';
import 'package:rive/rive.dart';

class DeviceSelectionScreen extends StatefulHookConsumerWidget {
  const DeviceSelectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeviceSelectionScreenState();
}

class _DeviceSelectionScreenState extends ConsumerState<DeviceSelectionScreen>
    with TickerProviderStateMixin {
  late final AnimationController controllerFirst;
  late final Animation<double> animationFirst;

  late final AnimationController controllerSecond;
  late final Animation<double> animationSecond;

  late final AnimationController controllerThird;
  late final Animation<double> animationThird;

  bool isAnimationComplete = false;
  bool isAnimationComplete2 = false;

  @override
  void initState() {
    super.initState();
    controllerFirst = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animationFirst = CurvedAnimation(
      parent: controllerFirst,
      curve: Curves.easeIn,
    );
    controllerFirst.forward();

    controllerSecond = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animationSecond = CurvedAnimation(
      parent: controllerSecond,
      curve: Curves.easeIn,
    );

    controllerThird = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      upperBound: 1.0,
      lowerBound: 0.5,
      value: 1,
    );
    animationThird = CurvedAnimation(
      parent: controllerThird,
      curve: Curves.linear,
    );

    // Delay the second animation by 3 seconds
    Future.delayed(const Duration(seconds: 2), () {
      controllerSecond.forward().then((value) {
        controllerThird.reverse(from: 1);
        if (mounted) {
          setState(() {
            isAnimationComplete = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: animationThird,
                child: Column(
                  children: [
                    FadeTransition(
                      opacity: controllerFirst,
                      child: Text(
                        'Welcome to',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    FadeTransition(
                      opacity: controllerSecond,
                      child: Text(
                        'IronOS Companion',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                height: isAnimationComplete
                    ? MediaQuery.of(context).size.height * 0.7
                    : 0,
                onEnd: () {
                  setState(() {
                    isAnimationComplete2 = true;
                  });
                },
                child: isAnimationComplete
                    ? AnimatedOpacity(
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeInOut,
                        opacity: isAnimationComplete2 ? 1 : 0,
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Column(children: [
                            const SizedBox(height: 20),
                            Text(
                              'Let\'s find your device, make sure it\'s turned on and bluetooth is enabled.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            // Rive animation
                            const SizedBox(
                              width: 300,
                              height: 300,
                              child: RiveAnimation.asset(
                                'assets/scanning.riv',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Expanded(child: DeviceList()),
                          ]),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
