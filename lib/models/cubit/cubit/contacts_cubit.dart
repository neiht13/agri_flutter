import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());
}
