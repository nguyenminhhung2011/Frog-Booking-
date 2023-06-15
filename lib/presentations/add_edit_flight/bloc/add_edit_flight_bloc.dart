import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flight_booking/core/components/enum/date_time_enum.dart';
import 'package:flight_booking/core/components/network/app_exception.dart';
import 'package:flight_booking/domain/entities/airline/airline.dart';
import 'package:flight_booking/domain/entities/flight/flight.dart';
import 'package:flight_booking/domain/usecase/airport_usecase.dart';
import 'package:flight_booking/presentations/add_edit_flight/bloc/add_edit_flight_model_state.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/airport/airport.dart';
import '../../../domain/usecase/airline_usecase.dart';
import '../../../domain/usecase/flight_usecase.dart';
import '../../../generated/l10n.dart';

part 'add_edit_flight_event.dart';
part 'add_edit_flight_state.dart';
part 'add_edit_flight_bloc.freezed.dart';

const _idNull = '';
const _failedEvent = 'Failed';

@injectable
class AddEditFlightBloc extends Bloc<AddEditFlightEvent, AddEditFlightState> {
  final String _flightId;
  final FlightsUsecase _flightsUsecase;
  final AirportUsecase _airportUsecase;
  final AirlineUsecase _airlineUsecase;

  AddEditFlightModelState get data => state.data;

  AddEditFlightBloc(
    @factoryParam String flightId,
    this._flightsUsecase,
    this._airportUsecase,
    this._airlineUsecase,
  )   : _flightId = flightId,
        super(
          AddEditFlightState.initial(
            data: AddEditFlightModelState(
              timeEnd: DateTime.now(),
              timeStart: DateTime.now(),
              headerText: S.current.addNewFlight,
              listAirline: <Airline>[],
              listAirport: <Airport>[],
            ),
          ),
        ) {
    on<_Started>(_onStarted);
    on<_EditFlight>(_onEditFlight);
    on<_AddNewFlight>(_onAddNewFlight);
    on<_UpdateDateField>(_onUpdateDateField);
    on<_Dispose>(_onDispose);
    on<_FetchAllAirports>(_onFetchAllAirports);
    on<_FetchAllAirlines>(_onFetchAllAirlines);
    on<_SelectedAirline>(_onSelectAirline);
    on<_SelectedAirport>(_onSelectAirport);
    on<_ButtonTap>(_onButtonTap);
  }

  bool get _isDataNull =>
      data.airline == null ||
      data.airportStart == null ||
      data.airportEnd == null;

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<AddEditFlightState> emit,
  ) {
    if (_flightId != _idNull) {}
    emit(
      state.copyWith(
        data: data.copyWith(
          headerText: _flightId != _idNull
              ? S.current.editFlight
              : S.current.addNewFlight,
        ),
      ),
    );
  }

  FutureOr<void> _onButtonTap(
    _ButtonTap event,
    Emitter<AddEditFlightState> emit,
  ) {
    if (_flightId.isNotEmpty) {
      add(_EditFlight(id: _flightId));
    } else {
      add(const _AddNewFlight());
    }
  }

  FutureOr<void> _onSelectAirport(
    _SelectedAirport event,
    Emitter<AddEditFlightState> emit,
  ) {
    if (event.isStartAirport) {
      emit(state.copyWith(
        data: data.copyWith(
          airportStart: event.airport,
        ),
      ));
    } else {
      emit(state.copyWith(
        data: data.copyWith(
          airportEnd: event.airport,
        ),
      ));
    }
  }

  FutureOr<void> _onSelectAirline(
    _SelectedAirline event,
    Emitter<AddEditFlightState> emit,
  ) {
    emit(
      state.copyWith(
        data: data.copyWith(airline: event.airline),
      ),
    );
  }

  FutureOr<void> _onFetchAllAirports(
    _FetchAllAirports event,
    Emitter<AddEditFlightState> emit,
  ) async {
    emit(AddEditFlightState.loading(data: data, type: 0));
    try {
      final result = await _airportUsecase.fetchAllAirports();
      final airport = result.isNotEmpty ? result.first : null;
      emit(AddEditFlightState.fetchAirportSuccess(
        data: data.copyWith(
          listAirport: result,
          airportStart: airport,
          airportEnd: airport,
        ),
      ));
    } on AppException catch (e) {
      emit(AddEditFlightState.fetchAirportFailed(
        data: data,
        message: e.toString(),
      ));
    } catch (e) {
      emit(AddEditFlightState.fetchAirportFailed(
        data: data,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onFetchAllAirlines(
    _FetchAllAirlines event,
    Emitter<AddEditFlightState> emit,
  ) async {
    emit(AddEditFlightState.loading(data: data, type: 0));
    try {
      final result = await _airlineUsecase.fetchAllAirlines();
      final airline = result.isNotEmpty ? result.first : null;
      emit(AddEditFlightState.fetchAirlineSuccess(
        data: data.copyWith(listAirline: result, airline: airline),
      ));
    } on AppException catch (e) {
      emit(AddEditFlightState.fetchAirlineFailed(
        data: data,
        message: e.toString(),
      ));
    } catch (e) {
      emit(AddEditFlightState.fetchAirlineFailed(
        data: data,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onDispose(
    _Dispose event,
    Emitter<AddEditFlightState> emit,
  ) {}

  FutureOr<void> _onEditFlight(
    _EditFlight event,
    Emitter<AddEditFlightState> emit,
  ) async {
    emit(AddEditFlightState.loading(data: state.data, type: 1));
    if (_isDataNull) {
      emit(AddEditFlightState.editFlightFailed(
        data: data,
        message: _failedEvent,
      ));
      return;
    }
    try {
      final newFlight = Flight(
        id: 0,
        arrivalAirport: data.airportStart!,
        departureAirport: data.airportEnd!,
        timeStart: data.timeStart,
        timeEnd: data.timeEnd,
        airline: data.airline!,
      );
      final edit = await _flightsUsecase.editFlight(newFlight, _flightId);
      if (edit == null) {
        emit(
          AddEditFlightState.editFlightFailed(
            data: state.data,
            message: _failedEvent,
          ),
        );
        return;
      }
      emit(AddEditFlightState.editFlightSuccess(data: data, flight: edit));
    } on AppException catch (e) {
      emit(AddEditFlightState.editFlightFailed(
        data: state.data,
        message: e.toString(),
      ));
    } catch (e) {
      emit(AddEditFlightState.editFlightFailed(
        data: state.data,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onAddNewFlight(
    _AddNewFlight event,
    Emitter<AddEditFlightState> emit,
  ) async {
    emit(AddEditFlightState.loading(data: state.data, type: 1));
    if (_isDataNull) {
      emit(AddEditFlightState.addNewFlightFailed(
        data: data,
        message: _failedEvent,
      ));
      return;
    }
    try {
      final newFlight = Flight(
        id: 0,
        arrivalAirport: data.airportStart!,
        departureAirport: data.airportEnd!,
        timeStart: data.timeStart,
        timeEnd: data.timeEnd,
        airline: data.airline!,
      );
      final add = await _flightsUsecase.addNewFlight(newFlight);
      if (add == null) {
        emit(AddEditFlightState.addNewFlightFailed(
          data: state.data,
          message: _failedEvent,
        ));
        return;
      }
      emit(AddEditFlightState.addNewFlightSuccess(data: data, flight: add));
    } on AppException catch (e) {
      emit(AddEditFlightState.addNewFlightFailed(
        data: state.data,
        message: e.toString(),
      ));
    } catch (e) {
      emit(AddEditFlightState.addNewFlightFailed(
        data: state.data,
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> _onUpdateDateField(
    _UpdateDateField event,
    Emitter<AddEditFlightState> emit,
  ) {
    if (event.enumTime == DateTimeEnum.timeStart) {
      emit(state.copyWith(data: data.copyWith(timeStart: event.dateTime)));
    } else {
      emit(state.copyWith(data: data.copyWith(timeEnd: event.dateTime)));
    }
  }
}
