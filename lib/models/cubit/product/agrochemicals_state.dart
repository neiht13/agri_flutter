// product_state.dart
import 'package:equatable/equatable.dart';
import 'agrochemicals.dart';

abstract class AgrochemicalsState extends Equatable {
  const AgrochemicalsState();

  @override
  List<Object> get props => [];
}

class AgrochemicalsInitial extends AgrochemicalsState {}

class AgrochemicalsLoading extends AgrochemicalsState {}

class AgrochemicalsLoaded extends AgrochemicalsState {
  final List<Agrochemicals> agrochemicalss;

  const AgrochemicalsLoaded(this.agrochemicalss);

  @override
  List<Object> get props => [agrochemicalss];
}

class AgrochemicalsError extends AgrochemicalsState {
  final String message;

  const AgrochemicalsError(this.message);

  @override
  List<Object> get props => [message];
}
