import 'package:brtoon/enums/sizes_enum.dart';

extension SizeExtencion on SizesEnum {
  double get getSize {
    switch (this) {
      case SizesEnum.xxxs:
        return 4;
      case SizesEnum.xxs:
        return 6;
      case SizesEnum.xs:
        return 8;
      case SizesEnum.sm:
        return 12;
      case SizesEnum.md:
        return 16;
      case SizesEnum.lg:
        return 24;
      case SizesEnum.xl:
        return 32;
      case SizesEnum.xxl:
        return 48;
      case SizesEnum.xxxl:
        return 64;
    }
  }
}
