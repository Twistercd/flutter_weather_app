import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/weather_repository.dart';
import '../data/models/weather_display_model.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc(this.repository) : super(WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    try {
      final data = await repository.fetchWeather(event.city);
      emit(WeatherLoaded(WeatherDisplayModel.fromResponse(data)));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}