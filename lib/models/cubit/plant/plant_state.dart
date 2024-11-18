// lib/data/cubit/plant/plant_state.dart
part of 'plant_cubit.dart';

@immutable
abstract class PlantState {}

class PlantInitial extends PlantState {}

class PlantLoading extends PlantState {}

class PlantLoaded extends PlantState {
  final List<Plant> plants;

  PlantLoaded({required this.plants});
}

class PlantError extends PlantState {
  final String message;

  PlantError({required this.message});
}
