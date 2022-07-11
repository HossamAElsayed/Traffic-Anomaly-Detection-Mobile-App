// ignore_for_file: must_be_immutable

part of 'records_cubit.dart';

abstract class RecordsState extends Equatable {
  List<Record> records;
  RecordsState(this.records);
  @override
  List<Object> get props => [records];
}

class RecordsInitial extends RecordsState {
  RecordsInitial(List<Record> records) : super(records);
}

class AddRecord extends RecordsState {
  AddRecord(List<Record> records) : super(records);
  @override
  List<Object> get props => [records];
}
