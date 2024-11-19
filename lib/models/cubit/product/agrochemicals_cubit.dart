// agrochemicals_cubit.dart
import 'package:agriplant/models/model/nhatky.dart';
import 'package:bloc/bloc.dart';
import 'agrochemicals_state.dart';
import 'agrochemicals_service.dart';
import 'agrochemicals.dart';

class AgrochemicalsCubit extends Cubit<AgrochemicalsState> {
  final AgrochemicalsService agrochemicalsService;

  AgrochemicalsCubit(this.agrochemicalsService) : super(AgrochemicalsInitial());

  // Phương thức để tải sản phẩm từ API
  Future<void> fetchAgrochemicalss(FarmingLog? log) async {

    try {
      emit(AgrochemicalsLoading());
      if (log != null) {
        final agrochemicalss = await agrochemicalsService.fetchAgrochemicalss(log);
        emit(AgrochemicalsLoaded(agrochemicalss));
      } else {
        emit(AgrochemicalsLoaded([]));

      }
    } catch (e) {
      emit(AgrochemicalsError(e.toString()));
    }
  }

  // Phương thức thêm sản phẩm
  void addAgrochemicals(Agrochemicals agrochemicals) {
    if (state is AgrochemicalsLoaded) {
      final updatedAgrochemicalss = List<Agrochemicals>.from((state as AgrochemicalsLoaded).agrochemicalss)
        ..add(agrochemicals);
      emit(AgrochemicalsLoaded(updatedAgrochemicalss));
    }
  }

  

  // Phương thức xóa sản phẩm
  void removeAgrochemicals(String agrochemicalsId) {
    if (state is AgrochemicalsLoaded) {
      final updatedAgrochemicalss = (state as AgrochemicalsLoaded)
          .agrochemicalss
          .where((agrochemicals) => agrochemicals?.id != agrochemicalsId)
          .toList();
      emit(AgrochemicalsLoaded(updatedAgrochemicalss));
    }
  }

  // Phương thức cập nhật danh sách sản phẩm (ví dụ khi edit FarmingLog)
  void setAgrochemicalss(List<Agrochemicals> agrochemicalss) {
    emit(AgrochemicalsLoaded(agrochemicalss));
  }
}
