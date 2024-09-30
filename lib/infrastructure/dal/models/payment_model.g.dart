// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentModelAdapter extends TypeAdapter<PaymentModel> {
  @override
  final int typeId = 4;

  @override
  PaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentModel(
      amount: fields[1] as dynamic,
      type: fields[2] as dynamic,
      date: fields[3] as DateTime?,
      num: fields[4] as dynamic,
      ref: fields[5] as dynamic,
      refExt: fields[6] as dynamic,
      fkBankLine: fields[7] as dynamic,
      invoiceId: fields[8] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.num)
      ..writeByte(5)
      ..write(obj.ref)
      ..writeByte(6)
      ..write(obj.refExt)
      ..writeByte(7)
      ..write(obj.fkBankLine)
      ..writeByte(8)
      ..write(obj.invoiceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
