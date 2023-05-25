part of 'customer_bloc.dart';

@freezed
class CustomerState with _$CustomerState {
  const CustomerState._();
  const factory CustomerState.initial({required CustomerModelState data}) =
      _Initial;

  const factory CustomerState.loading({required CustomerModelState data}) =
      _Loading;

  const factory CustomerState.fetchCustomerDataSuccess({
    required CustomerModelState data,
  }) = _FetchCustomerDataSuccess;

  const factory CustomerState.fetchCustomerDataFailed({
    required CustomerModelState data,
    required String message,
  }) = _FetchCustomerDataFailed;

  const factory CustomerState.openCustomerDetailSuccess({
    required CustomerModelState data,
    required Customer customer,
  }) = _OpenCustomerDetailSuccess;

  const factory CustomerState.openCustomerDetailFailed(
      {required CustomerModelState data,
      required String message}) = _OpenCustomerDetailFailed;

  const factory CustomerState.selectCustomerSuccess({
    required CustomerModelState data,
    required Customer customer,
  }) = _SelectCustomerSuccess;

  const factory CustomerState.selectCustomerFailed({
    required CustomerModelState data,
    required String message,
  }) = _SelectCustomerFailed;

  const factory CustomerState.deleteCustomerSuccess(
      {required CustomerModelState data}) = _DeleteCustomerSuccess;

  const factory CustomerState.deleteCustomerFailed(
      {required CustomerModelState data,
      required String message}) = _DeleteCustomerFailed;

  const factory CustomerState.openCustomerAddEditPage({
    required CustomerModelState data,
    required String message,
  }) = _OpenCustomerAddEditPage;

  bool get isLoading => this is _Loading;

  Customer get customer {
    if (this is _SelectCustomerSuccess) {
      return (this as _SelectCustomerSuccess).customer;
    } else {
      return Customer.empty;
    }
  }
}
