
import 'package:dsain/dummy.dart';
import 'package:dsain/scrrens/LastMealStep.dart';
import 'package:dsain/scrrens/LoadingScreen.dart';
import 'package:dsain/scrrens/NewResultScreen.dart';
// import 'package:dsain/scrrens/ResultsScreen.dart';
import 'package:dsain/scrrens/Moody_Screen.dart';
import 'package:dsain/scrrens/cart_screen.dart';
import 'package:dsain/scrrens/kuraimi_payment_screen.dart';
import 'package:dsain/scrrens/splash_Screen.dart';
import 'package:dsain/theme/appTheme.dart';
import 'package:flutter/material.dart';
import 'Provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'model/meal.dart';
import 'scrrens/Budget_selection.dart';
import 'scrrens/FavoritesScreen.dart';
import 'scrrens/MealDetailsScreen.dart';
import 'scrrens/onboarding_screen.dart';
import 'scrrens/quesScreen.dart';
import 'scrrens/stomachStatusStep.dart';

void main() {
  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   final List<Meal> availableMeals = DUMMY_MEALS;
 final List<Meal> _favortMeals =[];
 void _toggleFavorit(String mealid){
  final existingIndex = _favortMeals.indexWhere((e)=>e.id==mealid);
  if(existingIndex >= 0){
    setState(() {
        _favortMeals.removeAt(existingIndex);
      });
      } else{
        setState(() {
          _favortMeals.add(DUMMY_MEALS.firstWhere((e)=>e.id==mealid));
        });
      }
 }

 bool _isMealfavort(String id){
  return _favortMeals.any((e)=>e.id==id);
 }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'تطبيق الوجبات',
      theme: AppTheme.lightTheme,
      routes: {
        '/': (context)=> SplashScreen(),
        OnboardingScreen.routname: (context)=> OnboardingScreen(),
        Quesscreen.routname: (context)=> Quesscreen(),
        moodyScreen.routname: (context)=> moodyScreen(),
        Stomachstatusstep.routname: (context)=> Stomachstatusstep(),
        BudgetSelection.routname: (context)=> BudgetSelection(),
        LastMealStep.routname : (context)=> LastMealStep(),
        Loadingscreen.routName: (context)=> Loadingscreen(),
        // ResultsScreen.routname: (context)=> ResultsScreen(),
        Newresultscreen.routname : (context)=> Newresultscreen(isFavorite: _isMealfavort,toggleFavorite: _toggleFavorit,),
        MealDetailsScreen.routname :(context)=> MealDetailsScreen(availableMeals: availableMeals,isFavorite: _isMealfavort,toggleFavorite: _toggleFavorit,),
        FavoritesScreen.routname: (context)=> FavoritesScreen(favoriteMeals: _favortMeals,toggleFavorite: _toggleFavorit,),
        CartScreen.routeName: (context) => CartScreen(),
        KuraimiPaymentScreen.routeName: (context) => KuraimiPaymentScreen(),
      },
    );
  }
}

