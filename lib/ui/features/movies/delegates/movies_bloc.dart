import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/core/usecases/usecase.dart';
import 'package:flutter_projects/domain/usecases/get_movies.dart';
import 'package:flutter_projects/domain/usecases/get_movie_by_id.dart';
import 'package:flutter_projects/domain/usecases/add_movie.dart';
import 'package:flutter_projects/domain/usecases/delete_movie.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMovies getMovies;
  final GetMovieById getMovieById;
  final AddMovie addMovie;
  final DeleteMovie deleteMovie;

  MoviesBloc({
    required this.getMovies,
    required this.getMovieById,
    required this.addMovie,
    required this.deleteMovie,
  }) : super(MoviesInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<GetMovieByIdEvent>(_onGetMovieById);
    on<AddMovieEvent>(_onAddMovie);
    on<DeleteMovieEvent>(_onDeleteMovie);
  }

  Future<void> _onLoadMovies(
    LoadMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    try {
      final movies = await getMovies(NoParams());
      emit(MoviesLoaded(movies));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onGetMovieById(
    GetMovieByIdEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    try {
      final movie = await getMovieById(event.id);
      emit(MovieLoaded(movie));
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onAddMovie(
    AddMovieEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      await addMovie(event.movie);
      emit(MovieOperationSuccess('Фильм добавлен'));
      add(LoadMovies());
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onDeleteMovie(
    DeleteMovieEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      await deleteMovie(event.id);
      emit(MovieOperationSuccess('Фильм удален'));
      add(LoadMovies());
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }
}
