// lib/data/cubit/nhatky.dart
import 'package:agriplant/models/model/nhatky.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class FarmingLogState extends Equatable {
  const FarmingLogState();


  @override
  List<Object?> get props => [];
}

class FarmingLogInitial extends FarmingLogState {}

class FarmingLogLoading extends FarmingLogState {}

class FarmingLogLoaded extends FarmingLogState {
  final List<FarmingLog> logs;

  const FarmingLogLoaded({required this.logs});

  @override
  List<Object?> get props => [logs];
}


class UserStatisticsLoaded extends FarmingLogState {
  final Map<String, List<FarmingLog>> userNhatKyMap;

  const UserStatisticsLoaded(this.userNhatKyMap);
}

class FarmingLogError extends FarmingLogState {
  final String message;

  const FarmingLogError({required this.message});

  @override
  List<Object?> get props => [message];
}
