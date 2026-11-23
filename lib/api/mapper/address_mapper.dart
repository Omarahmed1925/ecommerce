import 'package:ecommerce/api/model/request/address_request_dto.dart';
import 'package:ecommerce/api/model/request/shipping_address_request_dto.dart';
import 'package:ecommerce/api/model/response/address/address_dto.dart';
import 'package:ecommerce/domain/entities/request/address_request.dart';
import 'package:ecommerce/domain/entities/request/shipping_address.dart';
import 'package:ecommerce/domain/entities/response/address.dart';

extension AddressMapper on AddressDto {
  Address toAddress() =>
      Address(id: id, name: name, details: details, phone: phone, city: city);
}

extension AddressRequestMapper on AddressRequest {
  AddressRequestDto toAddressRequestDto() =>
      AddressRequestDto(name: name, details: details, phone: phone, city: city);
}

extension ShippingAddressMapper on ShippingAddress {
  ShippingAddressRequestDto toShippingAddressRequestDto() =>
      ShippingAddressRequestDto(
        shippingAddress: ShippingAddressDto(
          details: details,
          phone: phone,
          city: city,
        ),
      );
}
