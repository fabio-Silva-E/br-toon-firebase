import 'package:brtoon/enums/sizes_enum.dart';
import 'package:brtoon/extensions/ui/sizes_extension.dart';
import 'package:flutter/material.dart';

class SizedBoxWidget extends StatelessWidget {
  final SizesEnum size;
  const SizedBoxWidget({
    super.key,
    this.size = SizesEnum.md,
  });
  const SizedBoxWidget.xxxl({
    super.key,
    this.size = SizesEnum.xxxl,
  });
  const SizedBoxWidget.xxl({
    super.key,
    this.size = SizesEnum.xxl,
  });
  const SizedBoxWidget.xl({
    super.key,
    this.size = SizesEnum.xl,
  });
  const SizedBoxWidget.lg({
    super.key,
    this.size = SizesEnum.xl,
  });
  const SizedBoxWidget.md({
    super.key,
    this.size = SizesEnum.md,
  });
  const SizedBoxWidget.sm({
    super.key,
    this.size = SizesEnum.sm,
  });
  const SizedBoxWidget.xs({
    super.key,
    this.size = SizesEnum.xs,
  });
  const SizedBoxWidget.xxs({
    super.key,
    this.size = SizesEnum.xxs,
  });
  const SizedBoxWidget.xxxs({
    super.key,
    this.size = SizesEnum.xxxs,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.getSize,
      width: size.getSize,
    );
  }
}
