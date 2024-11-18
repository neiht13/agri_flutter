// lib/data/cubit/plant/plant_cubit.dart
import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/model/plant.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'plant_state.dart';

class PlantCubit extends Cubit<PlantState> {
  final ApiService apiService = ApiService();

  PlantCubit() : super(PlantInitial());

  // Fetch all plants
  Future<void> fetchPlants() async {
    emit(PlantLoading());
    try {
      // final plants = await apiService.get();
      // emit(PlantLoaded(plants: plants));
    } catch (e) {
      emit(PlantError(message: e.toString()));
    }
  }

  // Add a new plant
  Future<void> addPlant(Plant plant) async {
    try {
      // await apiService.addPlant(plant);
      fetchPlants();
    } catch (e) {
      emit(PlantError(message: e.toString()));
    }
  }

  // Update a plant
  Future<void> updatePlant(Plant plant) async {
    try {
      // await apiService.updatePlant(plant);
      fetchPlants();
    } catch (e) {
      emit(PlantError(message: e.toString()));
    }
  }

  // Delete a plant
  Future<void> deletePlant(String plantId) async {
    try {
      // await apiService.deletePlant(plantId);
      fetchPlants();
    } catch (e) {
      emit(PlantError(message: e.toString()));
    }
  }
}
